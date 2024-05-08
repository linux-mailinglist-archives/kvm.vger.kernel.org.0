Return-Path: <kvm+bounces-16986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E03E18BF864
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1030F1C2141B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF2B4502A;
	Wed,  8 May 2024 08:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PjuDEr2R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A354086F
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715156539; cv=none; b=r2PvAQCYI8jtEymVLtBZb9ceqkm0fFY9CA2jFiI0eID3AJf3ttH27c0gRB3QBGfUAUYHXRJRmkQKwdKfpbfO9MFuNP88NvKX3G0PrrR3tBukH1bgH0p+8bUI5JAkvvQzTnVK0bW32Y7+4YuQLgMlhx8AwWg9AL7vorZeydaznA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715156539; c=relaxed/simple;
	bh=ygFz4Xi5KPzs5xGDIbJIGzXq1wtvM0/GTF+V51fuSIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G74T4Lm5UWherL9iqAO9zs2dJWuHB2nPKrs1OZCQlbKC4NlQuO+WCQQxnywVEXveA/Ubzngij1LkNloToyFVi2h1yML3VxjJm7mdE5W/7/x2UvDu7V1g5njbYbeDCIIF1MKIoLwcm/uhOoUrWV54KlVEXy6dIOgbM3lA0zoJzx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PjuDEr2R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715156536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WECjWQs8mty4SiAVTCtSfnAeiyCSuc/uRnEzCXqgsoI=;
	b=PjuDEr2RSg4nALYsYflfPBPT6xMlnEfNI2kBNSfIml1lfMXSezKngYJDtZmkGezYyxUO7y
	6NWf2lroAN0QqrvuNXMGxj9MfW3tr2ppLcsc5CIioB8C5GiwPR2qqTBo9scLCMYre/Agh0
	HxbnDEkkzmRp7imVPH6u3vELq1DWiig=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-5a0d1AYSMCSatKPCQ5dYTg-1; Wed, 08 May 2024 04:22:15 -0400
X-MC-Unique: 5a0d1AYSMCSatKPCQ5dYTg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a599dbd2b6aso242539366b.2
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 01:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715156534; x=1715761334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WECjWQs8mty4SiAVTCtSfnAeiyCSuc/uRnEzCXqgsoI=;
        b=nVzoZy9eyLSmopYb4DNR1AhgiEwqkWdk1ovIOQ/BSGotU6Czn/TGgutialhCH4Hy0d
         Neq40mVHrvI6xsvEu9Sg1gTvSV85XxQVvXRqtGm4gRf8n4YL4nXzD2DDowb9R/T+FPow
         JYfDHp3bCLypZ3uSeAOVuvXc0V8bqt831XKJAsO6b6tHWl1IxqVP7T4lqtYUy9iPk6+p
         hPEoJAorr4BJ2aRnGNNs2/FMpXRZYSGWSj5GzO+Eicr6AVI6vbCa9ZcdXLN+fkCKCDgm
         k7agEsNbFTirok/himBjbVCbAd5d+Op/4cjxOtAzR4XR+6BbGgdfcLygca4DDddMHUdB
         AXhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQh9sp69dZV7Sz4Ewt+SbzWkbxHcE5nl1s2wN2Vl5RipOD4h4akG0uiCEB7lu9ZvRAX7PxIBcQJjyQgzf8MsWvOx7G
X-Gm-Message-State: AOJu0YwA6olHkgBBoYL9rRj8w/d98nLAWVI8jLXAvjsCUIqUvGwa9Fcq
	XUxe874wL10NV4Hx7OvojTmUsID38cnlOVG9CxphHvbGntJrV+xlkQqGpWyCP3hKnTvoQ95+dKY
	TXPaUaKjNnHp3zVavl96eZEn9LhMIzio4NvCagHXmUUm682eF7g==
X-Received: by 2002:a17:906:74d:b0:a59:bb20:9964 with SMTP id a640c23a62f3a-a59fb94b8f0mr124741766b.23.1715156534167;
        Wed, 08 May 2024 01:22:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHU9a/9Dj60z9UWENRsQNKFMOX3GbrPe06GNksU418kuNjSLQfi4iB448HOWm6NjY8xN34DpA==
X-Received: by 2002:a17:906:74d:b0:a59:bb20:9964 with SMTP id a640c23a62f3a-a59fb94b8f0mr124740166b.23.1715156533853;
        Wed, 08 May 2024 01:22:13 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-56.business.telecomitalia.it. [87.12.25.56])
        by smtp.gmail.com with ESMTPSA id cf14-20020a170906b2ce00b00a59ef203579sm1645424ejb.138.2024.05.08.01.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 01:22:13 -0700 (PDT)
Date: Wed, 8 May 2024 10:22:09 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: mst@redhat.com, xuanzhuo@linux.alibaba.com, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kuba@kernel.org, stefanha@redhat.com, 
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com, kvm@vger.kernel.org, 
	jasowang@redhat.com, Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v2 1/3] vsock: add support for SIOCOUTQ ioctl
 for all vsock socket types.
Message-ID: <t752lxu3kwqypmdgr36nrd63pfigdgi22xhjawitr6mhjz2u4g@7xa3ucifp2sc>
References: <20240408133749.510520-1-luigi.leonardi@outlook.com>
 <AS2P194MB21708B8955BEC4C0D2EF822B9A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AS2P194MB21708B8955BEC4C0D2EF822B9A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Mon, Apr 08, 2024 at 03:37:47PM GMT, Luigi Leonardi wrote:
>This add support for ioctl(s) for SOCK_STREAM SOCK_SEQPACKET and SOCK_DGRAM
>in AF_VSOCK.
>The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
>of unsent bytes in the socket. This information is transport-specific
>and is delegated to them using a callback.
>
>Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> include/net/af_vsock.h   |  3 +++
> net/vmw_vsock/af_vsock.c | 51 +++++++++++++++++++++++++++++++++++++---
> 2 files changed, 51 insertions(+), 3 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 535701efc1e5..7d67faa7bbdb 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -169,6 +169,9 @@ struct vsock_transport {
> 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
> 	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
>
>+	/* SIOCOUTQ ioctl */
>+	int (*unsent_bytes)(struct vsock_sock *vsk);
>+
> 	/* Shutdown. */
> 	int (*shutdown)(struct vsock_sock *, int);
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 54ba7316f808..fc108283409a 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -112,6 +112,7 @@
> #include <net/sock.h>
> #include <net/af_vsock.h>
> #include <uapi/linux/vm_sockets.h>
>+#include <uapi/asm-generic/ioctls.h>
>
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
>@@ -1292,6 +1293,50 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> }
> EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>
>+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
>+			  int __user *arg)
>+{
>+	struct sock *sk = sock->sk;
>+	struct vsock_sock *vsk;
>+	int retval;
>+
>+	vsk = vsock_sk(sk);
>+
>+	switch (cmd) {
>+	case SIOCOUTQ: {
>+		int n_bytes;
>+
>+		if (vsk->transport->unsent_bytes) {

Should we also check the `vsk->transport` is not null?

I also suggest an early return, or to have the shortest branch on top
for readability:

		if (!vsk->transport || !vsk->transport->unsent_bytes) {
			retval = -EOPNOTSUPP;
			break;
		}

Thanks,
Stefano

>+			if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
>+				retval = -EINVAL;
>+				break;
>+			}
>+
>+			n_bytes = vsk->transport->unsent_bytes(vsk);
>+			if (n_bytes < 0) {
>+				retval = n_bytes;
>+				break;
>+			}
>+
>+			retval = put_user(n_bytes, arg);
>+		} else {
>+			retval = -EOPNOTSUPP;
>+		}
>+		break;
>+	}
>+	default:
>+		retval = -ENOIOCTLCMD;
>+	}
>+
>+	return retval;
>+}
>+
>+static int vsock_ioctl(struct socket *sock, unsigned int cmd,
>+		       unsigned long arg)
>+{
>+	return vsock_do_ioctl(sock, cmd, (int __user *)arg);
>+}
>+
> static const struct proto_ops vsock_dgram_ops = {
> 	.family = PF_VSOCK,
> 	.owner = THIS_MODULE,
>@@ -1302,7 +1347,7 @@ static const struct proto_ops vsock_dgram_ops = {
> 	.accept = sock_no_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = sock_no_listen,
> 	.shutdown = vsock_shutdown,
> 	.sendmsg = vsock_dgram_sendmsg,
>@@ -2286,7 +2331,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
> 	.setsockopt = vsock_connectible_setsockopt,
>@@ -2308,7 +2353,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
> 	.setsockopt = vsock_connectible_setsockopt,
>-- 
>2.34.1
>


