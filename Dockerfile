FROM srmklive/docker-ubuntu:latest

LABEL maintainer="Raza Mehdi<srmk@outlook.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y upgrade
  
RUN add-apt-repository ppa:nginx/stable \
  && add-apt-repository ppa:ondrej/php \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update

RUN apt-get -y install nginx nodejs yarn libssl1.1 openssl php5.6-fpm php5.6-cli php5.6-curl php5.6-mcrypt \
  php5.6-mbstring php5.6-zip php5.6-json php5.6-mysql php5.6-pgsql php5.6-gd \
  php5.6-bcmath php5.6-imap php5.6-xml php5.6-json php5.6-intl php5.6-soap \
  php5.6-readline php5.6-memcached php-xdebug php-redis

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"
  
RUN npm i npm@latest -g \
  && yarn --global install \
  && yarn --global upgrade

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
