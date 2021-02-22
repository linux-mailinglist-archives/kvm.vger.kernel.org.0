Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2D321474
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 11:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhBVKwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 05:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230169AbhBVKv5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 05:51:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613991030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r/umkKobSl1oJ5nCTeCGkktIBMKXA0l63/V8yWAiXgY=;
        b=AKrRLCQGWCHFEwreUJmD5KHxfPRB0e45fG4PoO2NxVuL9v1w/ITXwEGT2tIBfjfA9+/fHA
        SH/O3kf1lzk+kwlJF2Lcr1uK/tw084FI/daYMbySWiZXo7fuKwmOcxR22DgXv7/Y00dbpp
        RTieycYtDPww80EYPQ/+qQ/KaOLbbm4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-y0lzOX-2PMS7-pcmryYWxw-1; Mon, 22 Feb 2021 05:50:28 -0500
X-MC-Unique: y0lzOX-2PMS7-pcmryYWxw-1
Received: by mail-wm1-f70.google.com with SMTP id b201so4869115wmb.9
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 02:50:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r/umkKobSl1oJ5nCTeCGkktIBMKXA0l63/V8yWAiXgY=;
        b=JT0mbOZCM1GdMsfHJlDj7NeI1v6NLSfPad/2nyGrEbmhc73YpIYY0fhxZDDBx7JQ9W
         z+wwJ9xavJY3w5cAuFcv2gedRLY4U85W+mf3TvkaV+oQW+U0xlxk7Gp97tL2Ow9sPCOd
         nUJjS0fT9l5Z1JOtVCn2rsqyHHrJDSzg5oRmjKEEn8itsml5nP6F4T+/Sx43KazHyMuW
         BmEcQ9ffGPf4VCBPLDaBpfi4Sla5k6FN9DZhRmx3fW8d4IRTGVQmH6owGETtIBB+Y41o
         8jiegAJXcv69FmD6/SXCgrTrnMpObc6SyAR18dZ290aNpWnwY1/lbJERjEqetcg6dYe0
         yX3w==
X-Gm-Message-State: AOAM530QTUUx5p7lD6rGS301MqNfmpCGkhy7E8VIsHKC1YAUBSq9W57X
        n027iudabrcCXI5MJswQg1sqZKMi1HQowYSxczveJs+mYJ0KQdmvGf1KSQP56LgT3AtmVdzP1j5
        eixteWeGKhD8i
X-Received: by 2002:a1c:356:: with SMTP id 83mr20229594wmd.31.1613991027236;
        Mon, 22 Feb 2021 02:50:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGeo1jDQvRWIZunRRhVDnke7H4Q4D0daD7CIHbY/NWBlQs7bEj3/GryyH4ccKUfYqegxDaVg==
X-Received: by 2002:a1c:356:: with SMTP id 83mr20229567wmd.31.1613991027006;
        Mon, 22 Feb 2021 02:50:27 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v15sm28696163wra.61.2021.02.22.02.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 02:50:26 -0800 (PST)
Date:   Mon, 22 Feb 2021 11:50:23 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 01/19] af_vsock: update functions for connectible
 socket
Message-ID: <20210222105023.aqcu25irkeed6div@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053607.1066783-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053607.1066783-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 08:36:03AM +0300, Arseny Krasnov wrote:
>This prepares af_vsock.c for SEQPACKET support: some functions such
>as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
>shared between both types of sockets, so rename them in general
>manner.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
> 1 file changed, 34 insertions(+), 30 deletions(-)

IIRC I had already given my R-b to this patch. Please carry it over when 
you post a new version.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 5546710d8ac1..656370e11707 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -604,8 +604,8 @@ static void vsock_pending_work(struct work_struct *work)
>
> /**** SOCKET OPERATIONS ****/
>
>-static int __vsock_bind_stream(struct vsock_sock *vsk,
>-			       struct sockaddr_vm *addr)
>+static int __vsock_bind_connectible(struct vsock_sock *vsk,
>+				    struct sockaddr_vm *addr)
> {
> 	static u32 port;
> 	struct sockaddr_vm new_addr;
>@@ -685,7 +685,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
> 		spin_lock_bh(&vsock_table_lock);
>-		retval = __vsock_bind_stream(vsk, addr);
>+		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
> 		break;
>
>@@ -767,6 +767,11 @@ static struct sock *__vsock_create(struct net *net,
> 	return sk;
> }
>
>+static bool sock_type_connectible(u16 type)
>+{
>+	return type == SOCK_STREAM;
>+}
>+
> static void __vsock_release(struct sock *sk, int level)
> {
> 	if (sk) {
>@@ -785,7 +790,7 @@ static void __vsock_release(struct sock *sk, int level)
>
> 		if (vsk->transport)
> 			vsk->transport->release(vsk);
>-		else if (sk->sk_type == SOCK_STREAM)
>+		else if (sock_type_connectible(sk->sk_type))
> 			vsock_remove_sock(vsk);
>
> 		sock_orphan(sk);
>@@ -947,7 +952,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 	lock_sock(sk);
> 	if (sock->state == SS_UNCONNECTED) {
> 		err = -ENOTCONN;
>-		if (sk->sk_type == SOCK_STREAM)
>+		if (sock_type_connectible(sk->sk_type))
> 			goto out;
> 	} else {
> 		sock->state = SS_DISCONNECTING;
>@@ -960,7 +965,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 		sk->sk_shutdown |= mode;
> 		sk->sk_state_change(sk);
>
>-		if (sk->sk_type == SOCK_STREAM) {
>+		if (sock_type_connectible(sk->sk_type)) {
> 			sock_reset_flag(sk, SOCK_DONE);
> 			vsock_send_shutdown(sk, mode);
> 		}
>@@ -1015,7 +1020,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
> 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
>
>-	} else if (sock->type == SOCK_STREAM) {
>+	} else if (sock_type_connectible(sk->sk_type)) {
> 		const struct vsock_transport *transport;
>
> 		lock_sock(sk);
>@@ -1262,8 +1267,8 @@ static void vsock_connect_timeout(struct work_struct *work)
> 	sock_put(sk);
> }
>
>-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
>-				int addr_len, int flags)
>+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>+			 int addr_len, int flags)
> {
> 	int err;
> 	struct sock *sk;
>@@ -1413,7 +1418,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
>
> 	lock_sock(listener);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sock->type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1490,7 +1495,7 @@ static int vsock_listen(struct socket *sock, int backlog)
>
> 	lock_sock(sk);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sk->sk_type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1534,11 +1539,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
> 	vsk->buffer_size = val;
> }
>
>-static int vsock_stream_setsockopt(struct socket *sock,
>-				   int level,
>-				   int optname,
>-				   sockptr_t optval,
>-				   unsigned int optlen)
>+static int vsock_connectible_setsockopt(struct socket *sock,
>+					int level,
>+					int optname,
>+					sockptr_t optval,
>+					unsigned int optlen)
> {
> 	int err;
> 	struct sock *sk;
>@@ -1616,10 +1621,10 @@ static int vsock_stream_setsockopt(struct socket *sock,
> 	return err;
> }
>
>-static int vsock_stream_getsockopt(struct socket *sock,
>-				   int level, int optname,
>-				   char __user *optval,
>-				   int __user *optlen)
>+static int vsock_connectible_getsockopt(struct socket *sock,
>+					int level, int optname,
>+					char __user *optval,
>+					int __user *optlen)
> {
> 	int err;
> 	int len;
>@@ -1687,8 +1692,8 @@ static int vsock_stream_getsockopt(struct socket *sock,
> 	return 0;
> }
>
>-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>-				size_t len)
>+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>+				     size_t len)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>@@ -1827,10 +1832,9 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return err;
> }
>
>-
> static int
>-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-		     int flags)
>+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			  int flags)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>@@ -2006,7 +2010,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.owner = THIS_MODULE,
> 	.release = vsock_release,
> 	.bind = vsock_bind,
>-	.connect = vsock_stream_connect,
>+	.connect = vsock_connect,
> 	.socketpair = sock_no_socketpair,
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
>@@ -2014,10 +2018,10 @@ static const struct proto_ops vsock_stream_ops = {
> 	.ioctl = sock_no_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
>-	.setsockopt = vsock_stream_setsockopt,
>-	.getsockopt = vsock_stream_getsockopt,
>-	.sendmsg = vsock_stream_sendmsg,
>-	.recvmsg = vsock_stream_recvmsg,
>+	.setsockopt = vsock_connectible_setsockopt,
>+	.getsockopt = vsock_connectible_getsockopt,
>+	.sendmsg = vsock_connectible_sendmsg,
>+	.recvmsg = vsock_connectible_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
> };
>-- 
>2.25.1
>

