Return-Path: <kvm+bounces-20656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4283491BB26
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECD3028632C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8D9153800;
	Fri, 28 Jun 2024 09:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsifPcFn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6378A152DE0
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719565763; cv=none; b=mptvUQw6HTaq9VgzKIMRXXlO7PDrkduJABpA2bQkMtA+tBYTJuAZhir8XUbaTOriJ+9Uizg82sawYvgGrciz3HW+A1pNfIduzf5+xWCQMD0PJSm8Ni6+/Vct3MxcdJLvYeyM2c0rIoAVlhn3zgxpusOnzZE2Nyh+Ddiz5n1mIyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719565763; c=relaxed/simple;
	bh=SIySpQCkV++Gn01uCQqrsxns8iu5uDxRGSSIfvZ6WqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0L4GImobdvQdFPryWt78Re2Yz1/9RLMxvTO0uK76WC2nYtzdhhq1JbybyzDvVenyEdrmo/jSVsznuqs2hFPgjfIsKWDswQeF4YDpeuS0a38DwYadgJXp5Rs+ZRjpuClkcLfToVUflPTie1SlCcMdsAZADzYcKDVOvx32alQBJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VsifPcFn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719565760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9yWBbb3piCGdDy7HD6ZzfPnqrZTOJPMpN0iR2xh32w0=;
	b=VsifPcFn+H7KiB6cunIidud6ZM5LD3s9BL2pUWT0e/r3QTn313+FFmsZfqXmxkXltHOwgN
	/SYQN0RKsO0aLTRGLBSQvyNVkXLr8vosuMCVI4l27fTYmZTtaAqlEffmgT6Q1XJxWsaFO1
	zPimsbMmTsTPHqV7NiLEP/y7PAiIg6E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-4Wu2P1O1NNiu122EBe97FA-1; Fri, 28 Jun 2024 05:09:19 -0400
X-MC-Unique: 4Wu2P1O1NNiu122EBe97FA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-421179fd82bso3733835e9.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 02:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719565758; x=1720170558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yWBbb3piCGdDy7HD6ZzfPnqrZTOJPMpN0iR2xh32w0=;
        b=Uo9C8Qx/AUaybLncOOpBZUy7NIpSOxiLdOPp2pPjE5sG+lyooaKcfMcHJGomz9INlD
         jGbeB3HE3U62N96t/gP4SynwCYoNtaXOrfiNxLeP7olZKGoWcOpF/6qkQuL2bdEn0PUG
         XCX1MA2K506lVwjlH1a4VAoc8R1hAUGYuxwNRxwrW9z4WPoGvISkGI/pMCcRHr38F2IK
         R5jd+oW9PxVPLfOpFAZvybFwjHV0GOwiR1ky0BwH8PhxPAbreJysZ3eA7xWi41wDnjKw
         5XlMS0a/KORGQYVsFeEJ3FeTCygc+L/nCW/EdA5Hu8rnEcDM+421XesLBTZ2c3wSvdKl
         vKLA==
X-Forwarded-Encrypted: i=1; AJvYcCUwSPepZwI2P7AS80Gr543AaM0TzYXR43XiLDZBD0Cn0JtEfB0A5BN+fRNXtQmSvH7FCHrMKcK1GxGpxvY2vn6cXsNF
X-Gm-Message-State: AOJu0YwybA4VdYslnfRoUrn/jYCHD6uHcqrUeCmsUvJTcN+HxvjhimTE
	i8R2PArzAYZz1e7cZUBpkNtDWGNDmWxYYOEzxL7lEpLq5Tt3AWUfHIwIwbxnvVK6BurSXFeGGlo
	6y8ciqsO3QkWYAjZ59shtcGuNr588URICEhLhANj29Ku8RiRVbhkg04Z0MjrU
X-Received: by 2002:a05:600c:2e16:b0:425:5f25:c926 with SMTP id 5b1f17b1804b1-4255f25ca11mr49899715e9.19.1719565757848;
        Fri, 28 Jun 2024 02:09:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLU+57BTTkzFmhEgyrNonqIAqaUPJ6LrIcPsHkgfDROh96pQSfJWSfs9ZVKQcYxxBa29DKHg==
X-Received: by 2002:a05:600c:2e16:b0:425:5f25:c926 with SMTP id 5b1f17b1804b1-4255f25ca11mr49899415e9.19.1719565757149;
        Fri, 28 Jun 2024 02:09:17 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.132.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256b0c0fb3sm25546245e9.40.2024.06.28.02.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 02:09:16 -0700 (PDT)
Date: Fri, 28 Jun 2024 11:09:09 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: luigi.leonardi@outlook.com
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl
 for all vsock socket types.
Message-ID: <nasvwizxcxeu64dux7yop3bwxdpbneu2bts6ob6ahwwietoxh6@wtffmxmiq5g3>
References: <20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com>
 <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>

nit: in theory in this patch we don't support it for any of the 
transports, so I wouldn't confuse and take that part out of the title.

WDYT with someting like:

     vsock: add support for SIOCOUTQ ioctl

On Wed, Jun 26, 2024 at 02:08:35PM GMT, Luigi Leonardi via B4 Relay 
wrote:
>From: Luigi Leonardi <luigi.leonardi@outlook.com>
>
>Add support for ioctl(s) for SOCK_STREAM SOCK_SEQPACKET and SOCK_DGRAM
>in AF_VSOCK.
>The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
>of unsent bytes in the socket. This information is transport-specific
>and is delegated to them using a callback.
>
>Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> include/net/af_vsock.h   |  3 +++
> net/vmw_vsock/af_vsock.c | 60 +++++++++++++++++++++++++++++++++++++++++++++---
> 2 files changed, 60 insertions(+), 3 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 535701efc1e5..7b5375ae7827 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -169,6 +169,9 @@ struct vsock_transport {
> 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
> 	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
>
>+	/* SIOCOUTQ ioctl */
>+	size_t (*unsent_bytes)(struct vsock_sock *vsk);

If you want to return also errors, maybe better returning ssize_t.
This should fix one of the error reported by kernel bots.

>+
> 	/* Shutdown. */
> 	int (*shutdown)(struct vsock_sock *, int);
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 4b040285aa78..d6140d73d122 100644
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
>@@ -1292,6 +1293,59 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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
>+		size_t n_bytes;
>+
>+		if (!vsk->transport || !vsk->transport->unsent_bytes) {
>+			retval = -EOPNOTSUPP;
>+			break;
>+		}
>+
>+		if (vsk->transport->unsent_bytes) {

This if is not necessary after the check we did earlier, right?

Removing it should fix the other issue reported by the bot.

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
>+	int ret;
>+
>+	lock_sock(sock->sk);
>+	ret = vsock_do_ioctl(sock, cmd, (int __user *)arg);
>+	release_sock(sock->sk);
>+
>+	return ret;
>+}
>+
> static const struct proto_ops vsock_dgram_ops = {
> 	.family = PF_VSOCK,
> 	.owner = THIS_MODULE,
>@@ -1302,7 +1356,7 @@ static const struct proto_ops vsock_dgram_ops = {
> 	.accept = sock_no_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = sock_no_listen,
> 	.shutdown = vsock_shutdown,
> 	.sendmsg = vsock_dgram_sendmsg,
>@@ -2286,7 +2340,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
> 	.setsockopt = vsock_connectible_setsockopt,
>@@ -2308,7 +2362,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
> 	.setsockopt = vsock_connectible_setsockopt,
>
>-- 
>2.45.2
>
>
>


