Return-Path: <kvm+bounces-22729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7639594279A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EEE928458C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B8B1A6190;
	Wed, 31 Jul 2024 07:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BtpsglQm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACF1381D5
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 07:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722410059; cv=none; b=U+qq8ZEdyr3h32emTi0S3xNukug6vT/zvByFGS8K5YLV2Uv9S6d6XRXLrQNHj5oLE5/in26QqJPkRaqASJRkDg5KnKqN44etHcjBptduQm39OQ2RGTdGz32DgtOK6man5cUpDzFdq6kl8ZqHMYBjdjcFXagXJTSFBaqsMaLEz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722410059; c=relaxed/simple;
	bh=DFaSIMLeOwLIqKDhfXsm+CzJw6oi2I2Zp7gYG/9j2qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ei2U3qJ90tNVmF02bJ86ShE7uY2tOpJJtp+2Eu1Gg3SD/jrQ1vplrwEnlOvyAtDUTGGi2mePsZLpzbIZjwBapOvBW3rl/3X1zC0XhidRgMaNKseRFM6SDQrzehpijZxUgkanp0+m0tNh/6SaawnraTYVd1P92KwcUyvUGCFO2l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BtpsglQm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722410055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t/nl+e6vaRZ78PI4+ibEbjJ97p6P9Y0eAgdFv5fCQo0=;
	b=BtpsglQmtHB9aSwvA7wgItWXDugttA8Y2TfEFjYG/vmGzBKDb1OatlnBFabhUuEdHK5p7K
	mT12Hd33MNIKV8euD723jQ12lMCkOfhfqVhTY5i1AcNth/prfiwc+vM8yZpKRJobSojwIR
	WzStxS/UKXExXVYUj3XtqUIl1IXVaL4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-adiM3KCoMpmusJtSrxs1zA-1; Wed, 31 Jul 2024 03:14:11 -0400
X-MC-Unique: adiM3KCoMpmusJtSrxs1zA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-428207daff2so18885455e9.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 00:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722410050; x=1723014850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/nl+e6vaRZ78PI4+ibEbjJ97p6P9Y0eAgdFv5fCQo0=;
        b=ELMkimBBjZ1KxPKechi6Y/GpRroH3t3oYpo7Qzed8/yjHapuXiUh/43XLOvRFucPao
         LyuT+x0WX0JhsXNgl+kLRMn+lRWT/7dlK77DdO19a63cdcxm6VK3tqfaebbKVmBCVYu4
         l3O56GoLU47majQPqoFky91cHtR7gTW99yYrptlf5jBKj0hzc04bJMKkDliejXdYA7oN
         89JSDUBFOo2LIsOEq3ukJ90Bl87q0VeDFgzIJtslGyWwfufsOAfB5J9Sdt96bRzpycMA
         AfRnUX9Ip0Kb1L9j5PJM39XOuvDlZqV5PsJfje7GNrBWQ/jj8s3OYEMSF/Jq7cCPbEkV
         EXqA==
X-Forwarded-Encrypted: i=1; AJvYcCUBOhnjr/dYbVql39FBnmsv3DkMKBKWif9Eq8tUWrY4hm870iXcfEzNxCqz+/GsAJ1otagW81RtGldNUoWCS41IJrsR
X-Gm-Message-State: AOJu0YytX4rwcpVwMqCh1ud7HLQEV7v/M6IuPueBJoldeo/Xh5gG3exD
	jZrMuFN3GoMVP5QqIz/EyNon5W6GfWJbeIFA8UyZvYBzGpYRxBguXvOw8VtKtRX4mUI5RhDrUYr
	h9UwyebZSWodgiCB10UsNij6DqrTk61WluiMoK1EnIPfoSe/grg==
X-Received: by 2002:adf:e708:0:b0:368:72c6:99c4 with SMTP id ffacd0b85a97d-36b5cee2d27mr10280313f8f.10.1722410050045;
        Wed, 31 Jul 2024 00:14:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6jSeb18RuPmbGirWKCJrktRGOmYgiWhv8GsuwSZXyrcvukngIBWVpZXtCAeXpiAo/LIVg5g==
X-Received: by 2002:adf:e708:0:b0:368:72c6:99c4 with SMTP id ffacd0b85a97d-36b5cee2d27mr10280268f8f.10.1722410049236;
        Wed, 31 Jul 2024 00:14:09 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-79.retail.telecomitalia.it. [82.57.51.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367c067esm16215525f8f.20.2024.07.31.00.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 00:14:08 -0700 (PDT)
Date: Wed, 31 Jul 2024 09:14:04 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: luigi.leonardi@outlook.com
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v4 1/3] vsock: add support for SIOCOUTQ ioctl
Message-ID: <g3ufcvs6nkwujosuopyulvtnmtbheknp7wnnzwvhrrpnaw4jed@zaisttr2hmmx>
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
 <20240730-ioctl-v4-1-16d89286a8f0@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240730-ioctl-v4-1-16d89286a8f0@outlook.com>

On Tue, Jul 30, 2024 at 09:43:06PM GMT, Luigi Leonardi via B4 Relay wrote:
>From: Luigi Leonardi <luigi.leonardi@outlook.com>
>
>Add support for ioctl(s) in AF_VSOCK.
>The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
>of unsent bytes in the socket. This information is transport-specific
>and is delegated to them using a callback.
>
>Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> include/net/af_vsock.h   |  3 +++
> net/vmw_vsock/af_vsock.c | 58 +++++++++++++++++++++++++++++++++++++++++++++---
> 2 files changed, 58 insertions(+), 3 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 535701efc1e5..fc504d2da3d0 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -169,6 +169,9 @@ struct vsock_transport {
> 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
> 	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
>
>+	/* SIOCOUTQ ioctl */
>+	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
>+
> 	/* Shutdown. */
> 	int (*shutdown)(struct vsock_sock *, int);
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 4b040285aa78..58e639e82942 100644
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
>@@ -1292,6 +1293,57 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> }
> EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>
>+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
>+			  int __user *arg)
>+{
>+	struct sock *sk = sock->sk;
>+	struct vsock_sock *vsk;
>+	int ret;
>+
>+	vsk = vsock_sk(sk);
>+
>+	switch (cmd) {
>+	case SIOCOUTQ: {
>+		ssize_t n_bytes;
>+
>+		if (!vsk->transport || !vsk->transport->unsent_bytes) {
>+			ret = -EOPNOTSUPP;
>+			break;
>+		}
>+
>+		if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
>+			ret = -EINVAL;
>+			break;
>+		}
>+
>+		n_bytes = vsk->transport->unsent_bytes(vsk);
>+		if (n_bytes < 0) {
>+			ret = n_bytes;
>+			break;
>+		}
>+
>+		ret = put_user(n_bytes, arg);
>+		break;
>+	}
>+	default:
>+		ret = -ENOIOCTLCMD;
>+	}
>+
>+	return ret;
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
>@@ -1302,7 +1354,7 @@ static const struct proto_ops vsock_dgram_ops = {
> 	.accept = sock_no_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = sock_no_listen,
> 	.shutdown = vsock_shutdown,
> 	.sendmsg = vsock_dgram_sendmsg,
>@@ -2286,7 +2338,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
> 	.setsockopt = vsock_connectible_setsockopt,
>@@ -2308,7 +2360,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
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


