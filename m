Return-Path: <kvm+bounces-13449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 201C78969C4
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 11:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BC901F2A834
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 09:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5796FE3B;
	Wed,  3 Apr 2024 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hm5nBFe/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B397B6CDDB
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 09:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712134815; cv=none; b=kPA9REtbI56Yz2a2uQn9+hTUuqtfEqwJ67cIP4zjHCUGK3H1LIJy3huVxbPVjK3fenIDREHFFhI1AC+ogJG7KlkAKexuZ8RTtXcD8NI1M7PjCgemJXKknlTYCZQ8ryzAVU8MHIw9pM49N3YpVZQxHnxGp3ortU9JesGgxlpC5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712134815; c=relaxed/simple;
	bh=2d6ZUsBlgzR4T8JBDYxCVmRmClrqIlJvH/JnSOyemxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQTcPfu1LXP2POUUQx+Z3iuUClnR5Q0AhmPix1N6CcQ2zCdkWTmZPZJP2/QuNhWTC76M/78eQ4X9nUzaOlOUtt1jYgnNUMo94ILwaHWcuFyYt+74pfKBlTIRCBNt4ZuzN7d6v/8qPP/rdA1KcGNGiQPSHEmQgoXe5cjZXHZhg1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hm5nBFe/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712134812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JE5CsJ7kL74rep0BkNPkoZkZLlxXhnrOBkLMW12RKB8=;
	b=hm5nBFe/j7Wfqqf2ICSXT3b8DRDmfZxXhZG6jYs/nNetJzAWmUjSed57TkHokWslcC0ew0
	hw4+m1Acf4NqD9qDeUAwIcWVi2UpDj9bYk+pN+pZMCiitEVUuYAuLKfIc2vGOyKHSwQvYr
	8VBB1p6apo402yzsnVjekcqAGmrNFDE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-FE-NvibiPju-8_iDaCdRyQ-1; Wed, 03 Apr 2024 05:00:10 -0400
X-MC-Unique: FE-NvibiPju-8_iDaCdRyQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3436eadd01cso807711f8f.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 02:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712134809; x=1712739609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JE5CsJ7kL74rep0BkNPkoZkZLlxXhnrOBkLMW12RKB8=;
        b=H/qQL7h4pXE3F2X1cD42565LhO/2zhgnvznfDqTJqXIcHl1SiXdCj3QX0m9M1VXTzi
         ulHlNXhynT8Y0o5TYAk1oSWi/Im+sqSE/UBd7bHrluYcBSoLRPnQhNKhQgU+5/sS27bL
         n3UyD/6FsXCZovHMZIBYNKNgbDAJbf0vkR8qVM1mNnk/lZnhfBIQtZd1VYbRV9LCBchE
         p5qzoKfglN7KoYO93nkem79sKh7aHAVJ0vgoMT9rC4VipfHuCl/1lfNPoRcUr7+6hl1X
         0evIjYhBj5GSL1na/Y2mXVlOByoeuHHRLqmzuC59Vuk8TqbTxxvaUUKTEM9hlMZ8Cdq2
         T7iw==
X-Gm-Message-State: AOJu0YyI6LGZFnCgUEtGrywz4p10ZjRggGF1YyL0ys8RUupknYuhGshd
	yl4XFbsgD6HoKvA45GK+9ifTRbrXMuB5SQ83Mf+tmdYfOdU3q+zBFORjVzl8o2gckZU1HpjS5oK
	Mf1EiBXlYyS9LblPjMu+wy09asGO9/JqnseBeRmReJ1+wVNgV4A==
X-Received: by 2002:a5d:4a41:0:b0:341:cf18:70b3 with SMTP id v1-20020a5d4a41000000b00341cf1870b3mr12886244wrs.27.1712134809630;
        Wed, 03 Apr 2024 02:00:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0zdlwMZAbcSiFAU8KPHuLmc2v4KW+Pzfncb+ilq5cKvWI91wzQJ6twEst7GvvlCd18xMZYg==
X-Received: by 2002:a5d:4a41:0:b0:341:cf18:70b3 with SMTP id v1-20020a5d4a41000000b00341cf1870b3mr12886219wrs.27.1712134809235;
        Wed, 03 Apr 2024 02:00:09 -0700 (PDT)
Received: from sgarzare-redhat ([185.95.145.60])
        by smtp.gmail.com with ESMTPSA id by7-20020a056000098700b0033ec94c6277sm16729642wrb.115.2024.04.03.02.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 02:00:08 -0700 (PDT)
Date: Wed, 3 Apr 2024 11:00:02 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: kvm@vger.kernel.org, jasowang@redhat.com, 
	virtualization@lists.linux.dev, mst@redhat.com, kuba@kernel.org, xuanzhuo@linux.alibaba.com, 
	netdev@vger.kernel.org, stefanha@redhat.com, pabeni@redhat.com, davem@davemloft.net, 
	edumazet@google.com, Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next 1/3] vsock: add support for SIOCOUTQ ioctl for
 all vsock socket types.
Message-ID: <weigxhmoj4qoiqz45eklm3n5c3gw75l7ml3pt2seq3jiip7xw6@alqavbovpdoy>
References: <20240402150539.390269-1-luigi.leonardi@outlook.com>
 <AS2P194MB2170C0FC43DDA2CB637CE6B29A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AS2P194MB2170C0FC43DDA2CB637CE6B29A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Tue, Apr 02, 2024 at 05:05:37PM +0200, Luigi Leonardi wrote:
>This add support for ioctl(s) for SOCK_STREAM SOCK_SEQPACKET and SOCK_DGRAM
>in AF_VSOCK.
>The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
>of unsent bytes in the socket. This information is transport-specific
>and is delegated to them using a callback.
>
>Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 42 +++++++++++++++++++++++++++++++++++++---
> 2 files changed, 40 insertions(+), 3 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 535701efc1e5..cd4311abd3c9 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -137,6 +137,7 @@ struct vsock_transport {
> 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>+	int (*stream_bytes_unsent)(struct vsock_sock *vsk);
>
> 	/* SEQ_PACKET. */
> 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 54ba7316f808..991e9edfa743 100644
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
>@@ -1292,6 +1293,41 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> }
> EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>
>+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
>+			  int __user *arg)
>+{
>+	struct sock *sk = sock->sk;
>+	int retval = -EOPNOTSUPP;
>+	struct vsock_sock *vsk;
>+
>+	vsk = vsock_sk(sk);
>+
>+	switch (cmd) {
>+	case SIOCOUTQ:
>+		if (vsk->transport->stream_bytes_unsent) {
>+			if (sk->sk_state == TCP_LISTEN)

Maybe we should do this check only if
`sock_type_connectible(sk->sk_type)` is true.

>+				return -EINVAL;
>+			retval = vsk->transport->stream_bytes_unsent(vsk);

IIUC `stream_bytes_unsent()` is used for any type of socket, so I
suggest using a name more generic, something like `unsent_bytes()`.

>+		}
>+		break;
>+	default:
>+		retval = -EOPNOTSUPP;

Should we return -ENOIOCTLCMD in this case?

>+	}
>+
>+	if (retval >= 0) {

IMHO mixing the the ioctl() return value and the value itself is
confusing.

I also suggest to move the put_user() in the `case SIOCOUTQ`,
other ioctls may no needs any value to copy to userspace.

>+		put_user(retval, arg);

put_user() can fail, we should return the failure to the user.

>+		retval = 0;
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
>@@ -1302,7 +1338,7 @@ static const struct proto_ops vsock_dgram_ops = {
> 	.accept = sock_no_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = sock_no_listen,
> 	.shutdown = vsock_shutdown,
> 	.sendmsg = vsock_dgram_sendmsg,
>@@ -2286,7 +2322,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
> 	.poll = vsock_poll,
>-	.ioctl = sock_no_ioctl,
>+	.ioctl = vsock_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
> 	.setsockopt = vsock_connectible_setsockopt,
>@@ -2308,7 +2344,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
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


