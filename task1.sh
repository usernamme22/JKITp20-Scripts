#!/bin/bash
#The script which creating user from .txt document with specific params
echo "--------Script for creating users---------"
echo -e "\n\n"
echo "Text document which contains users should be placed in directory src"
echo -e "\n"
read -p "Enter name of the file which contains users with params: " FILE_USERS

USERS_PATH="./src/$FILE_USERS"


if [[ -f $USERS_PATH ]]; then
	IFS=$'\n'
	for LINEE in `cat $USERS_PATH`
	do	
		
		username=`echo "$LINEE" | cut -d ":" -f1`
		user_group=`echo "$LINEE" | cut -d ":" -f2`
		user_password=`echo "$LINEE" | cut -d ":" -f3`
		ssl_password=`openssl passwd -1 "$user_password"`
		user_shell=`echo "$LINEE" | cut -d ":" -f4`
		if ! grep -q $username "/etc/passwd"; then
			    echo "$user was not found in the system!"
			    read -p "Do you want to create a new user $username? [yes/no]" ANS_NEW         
                case $ANS_NEW in
                	 [yY]|[yY][eE][sS])   
							if  [[ `grep $user_group /etc/group` ]]; then
								echo "$user_group alredy exist in the system"
								useradd $username -s $user_shell -m -g $user_group -p $ssl_password
							else
								echo -e "Group $user_group doesnt exist in the system"
								group add $user_group
								useradd $username -s $user_shell -m -g $user_group -p $ssl_password
			 	            fi
            				echo -e "User $username was created!"
            				;;
            		[Nn]|[nN][oO])
            				echo "The creation of $username will  skip!\n"
            				;;
            		*)
            				echo -e "Please enter [yes,no] only!\n"	
            				;;
        esac				
            		
            							 
		elif [[ `grep $username /etc/passwd` ]]; then
			echo -e "$username was found in system!\n"
			read -p "Do you want to make some changes for $username? (yes/no):"  ANSWER_CHANGES																											
			case $ANSWER_CHANGES in
					[yY]|[yY][Ee][Ss])
						echo "You answered yes!";;
					[Nn]|[Nn][Oo])
						echo "You answered no!";;
					*)
						echo "You need to enterer only YES/NOI!!!";;
			esac																																				


		fi
	done

else
	echo "$FILE_USERS doesnt exist"
	echo "You need to create a new file!"
fi
