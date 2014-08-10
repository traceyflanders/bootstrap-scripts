#!/bin/bash
# BootStrap EC2 Web Server
# Version: 140809
# Author: AlphaMusk.com

## SETUP: Get Latest Git code
# Install git
apt-get install -y git php5 php5-mysql apache2 mysql-client 


# Create install directories
rm -rf /root/scripts
mkdir -p /root/scripts && cd /root/scripts

# Download script
rm -f /root/scripts/getLastestGitCode.sh && wget https://raw.githubusercontent.com/alphamusk/bootstrap-scripts/master/getLastestGitCode.sh
chmod +x /root/scripts/getLastestGitCode.sh

# Clone latest code for AppClient webserver
rm -rf /var/www/html
mkdir -p  /var/www/html
chown www-data.www-data -R /var/www/html
chmod 755 -R /var/www/html
cd /var/www/html && git clone https://github.com/alphamusk/mock-app-client

# Create crontab for getting latest code
codeCMD="/root/scripts/getLastestGitCode.sh /var/www/html https://github.com/alphamusk mock-app-client > /dev/null 2>&1"
job="*/10 * * * * $codeCMD"
cat <(grep -i -v "$codeCMD" <(crontab -l)) <(echo "$job") | crontab -

# Run script once to grab AppClient webserver code
/root/scripts/getLastestGitCode.sh /var/www/html https://github.com/alphamusk mock-app-client

# Change apache settings
cp -v /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.org
rm -f /etc/apache2/sites-enabled/000-default.conf
touch /etc/apache2/sites-enabled/000-default.conf
echo '<VirtualHost *:80>' 								>> /etc/apache2/sites-enabled/000-default.conf
echo ' ServerName www.democloudservices.com'			>> /etc/apache2/sites-enabled/000-default.conf
echo ' ServerAdmin webmaster@democloudservices.com'		>> /etc/apache2/sites-enabled/000-default.conf
echo ' DocumentRoot /var/www/html/'						>> /etc/apache2/sites-enabled/000-default.conf
echo ' '												>> /etc/apache2/sites-enabled/000-default.conf
echo ' <Directory /var/www/html/>'						>> /etc/apache2/sites-enabled/000-default.conf
echo ' Options Indexes FollowSymLinks'					>> /etc/apache2/sites-enabled/000-default.conf
echo ' AllowOverride None'								>> /etc/apache2/sites-enabled/000-default.conf
echo ' Require all granted'								>> /etc/apache2/sites-enabled/000-default.conf
echo ' </Directory>'									>> /etc/apache2/sites-enabled/000-default.conf
echo ' '												>> /etc/apache2/sites-enabled/000-default.conf
echo ' ErrorLog ${APACHE_LOG_DIR}/democloudservices.com_error.log'				>> /etc/apache2/sites-enabled/000-default.conf
echo ' CustomLog ${APACHE_LOG_DIR}/democloudservices.com_access.log combined'	>> /etc/apache2/sites-enabled/000-default.conf
echo ' '												>> /etc/apache2/sites-enabled/000-default.conf
echo ' </VirtualHost>'									>> /etc/apache2/sites-enabled/000-default.conf

cat /etc/apache2/sites-enabled/000-default.conf

# Restart apache for changes to take affect
apachectl restart


# Git App Server shell script
# cd /opt && git clone https://github.com/alphamusk/bootstrap-scripts
# /root/scripts/getLastestGitCode.sh /opt https://github.com/alphamusk bootstrap-scripts
# chmod +x /opt/bootstrap-scripts/*.sh

# Create crontab for getting latest code
# serverCMD="/opt/bootstrap-scripts/AppServer.sh > /dev/null 2>&1"
# job="*/1 * * * * $serverCMD"
# cat <(grep -i -v "$serverCMD" <(crontab -l)) <(echo "$job") | crontab -

# Start AppServer
# /opt/bootstrap-scripts/AppServer.sh > /dev/null 2>&1