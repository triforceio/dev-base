FROM schmidh/arch-base
MAINTAINER Joe Fiorini <joe@joefiorini.com>

RUN pacman -Syy

RUN pacman -S --noconfirm zsh vim tmux ack fortune-mod tcpdump netcat supervisor && \
    useradd -mG wheel -s /bin/zsh dev && usermod -aG tty dev && \
    echo 'LANG="en_US.UTF-8"' > /etc/locale.conf


RUN pacman -S --noconfirm openssh mosh sqlite

RUN sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && sed -i 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    mkdir /home/dev/.ssh && curl http://files.static.ly/authorized_keys > /home/dev/.ssh/authorized_keys

RUN curl http://files.static.ly/authorized_keys > /home/dev/.ssh/authorized_keys && \
    chown dev /home/dev/.ssh && chown dev /home/dev/.ssh/authorized_keys && chmod 400 /home/dev/.ssh/authorized_keys && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key

RUN sed -i 's/^dev:\!:/:x:/' /etc/shadow && sed -i 's/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers

ADD http://configs.static.triforce.io/configs-base-0.0.3.tar.gz /configs.tar.gz
RUN tar -xvzf /configs.tar.gz && chown -R dev /home/dev && chgrp -R dev /home/dev

EXPOSE 22

CMD ["supervisord", "-n"]
