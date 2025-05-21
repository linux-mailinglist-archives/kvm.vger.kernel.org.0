Return-Path: <kvm+bounces-47271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB25EABF7F8
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A0AE7AE211
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32EB1DB346;
	Wed, 21 May 2025 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpvYP0KK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC501D5CF2
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838278; cv=none; b=GR1gEir7gwfiynFCb+a+4UBnkCk9vh4O93PXI7rCh6PBjtBGCIRT5UAoACKncw6ONSiW+4IMBPxmuYEvlUM0rGcF9F0DgGlHR0dmE/Z2/xbUEsGqp3FxfOvP0Cx168nKmX0a3q2V/eLH46xDY/cOL5aJlkBonWUyxl//fb3le6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838278; c=relaxed/simple;
	bh=GFUbTHLvPIWpijBbnDKGJjSbviGkpIHpV+2P6Mrxv6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bYRvz2D9+hfPqVDgB71yNq1deWgdOJVbod8GZe0QGRZqA/R6kJFFAoPHCbcnWdYDJGyj31jOSQFfTC5YPC+0n9bLQePBzkQMf2VXQxZID1HXm3/EaxeiYvSYm0zf5jl48lILodyfH9cnrzWbbSWbOU8Z69OiWCW3Ic4SfL+PDP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpvYP0KK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747838275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+9bOe+sk+QP6ubHHUgYc4TBiMH2pb9AHt05w4STzZg=;
	b=fpvYP0KK6BnnB9CZsbQd+0j7ryAARJPDxKpvY8ULSvEq4OzQ1XHFjFFEwf1nOPmge7sqsy
	ZSzG3ATGbuU/aTkC8VIyIrTOai0OZSfWXfUYmO9iBSRaPFwf7j4vl/xZBk2ziKrgl8/MY0
	M8aFahoxWxFVdO8gHAay1qDfhsBAJJc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-jSFKjnR4NuC6KzLS4qdX_Q-1; Wed, 21 May 2025 10:37:54 -0400
X-MC-Unique: jSFKjnR4NuC6KzLS4qdX_Q-1
X-Mimecast-MFC-AGG-ID: jSFKjnR4NuC6KzLS4qdX_Q_1747838273
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-acbbb000796so508874566b.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747838273; x=1748443073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+9bOe+sk+QP6ubHHUgYc4TBiMH2pb9AHt05w4STzZg=;
        b=s+/+yXy3EdBZPKgrAyuEg0JSfDqfc/KKB4GXDnIB7H3FWxMEYmZZTsbWWT9Llk2O6Q
         vuQKC3bH0H6BFTmNJK9e8UoJ5Te6H/sQOjXl23Tt+VOZEPKaYvvlQC9ApRovmtQ4aLDU
         EuefDHXbTualVd3zuqWxtGn4IYnAmnGO8/4XcA/6+6G61gKo3ft3qAmVYObKJv5Y3GTC
         Z316VwuopacU+NBln4/wrlLxaOiA75zohXYAmIRLftNTgRNBuMSuhrtaoFydTq+5+KC6
         c942n3yprwY4ZHgb3v73Mum0IyULOfcU1VSsPaY/ra3bY1HYRi3uA8ea4yjl3OO4hNLa
         QmEA==
X-Forwarded-Encrypted: i=1; AJvYcCWxQyGBPUu1Ki7fMNiWpt6OPDP3uKkt4TDzE3VNNKF1UG7dv6j8o4NTeDhNr/BNBASry78=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjtJ94EdpMvuNQDZpA5ekQikDDvAGbMev1zF/W1Nrly4eQSdBZ
	OuC/dnrMxW7cGwUuRfsRirU0y7KV4NoA4HuqsMiUeZD9d230IKZKbDI4SLQYiuOwv+FtOtlN4nc
	QaX0pBcNR66ao+SfgkjKiEoWzD54DyrJWUnwjqAePzv6lKx4StfMZPQ==
X-Gm-Gg: ASbGnctnT8b+mDnJYPfYsdlm6nyO7lw1fr10q9nRCQmQOr/W3Qzq05RdC+8k2bVsWPl
	q0GcjNbveexj1w/K82gH4mYrx6n3eqpillrMJaqnARJM1AD9ysHd0N3dPDNfd1Y4RJBNntqL3K5
	HzQ1ue6loR3ORgBue6jt4sCV5H3j+FH+HVCgFenVJhlJheRPSt0e6u21hEjxZZUzCaqkADVDcqP
	PkQqJsOlzuXQjJiG0NJtuett191XNSBz5fRyDtcFkMb0Yu9487U0CpkSEFkexL7FE1F6aEpO2wZ
	+rlYrzHdEX7WY8lfEIB7D//Mgzd58/LA3El0c/0RbuMZkrlaOVNWqHqO92qB
X-Received: by 2002:a17:907:928e:b0:ad3:f3dc:e36d with SMTP id a640c23a62f3a-ad536f28227mr1817060966b.50.1747838272781;
        Wed, 21 May 2025 07:37:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmBHIw8ATBsd2tGBCezkRlBguAVth09UuV27A0TTDuqx7nQd0qtkGTs7YUjEcenVWi3uB5IA==
X-Received: by 2002:a17:907:928e:b0:ad3:f3dc:e36d with SMTP id a640c23a62f3a-ad536f28227mr1817056266b.50.1747838272225;
        Wed, 21 May 2025 07:37:52 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d4967c9sm908215766b.129.2025.05.21.07.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 07:37:51 -0700 (PDT)
Date: Wed, 21 May 2025 16:37:49 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/5] vsock: Move lingering logic to af_vsock
 core
Message-ID: <iotcme6uict3ny5eztqmrkp2odewv35vtbv2x5hmpyd3rjjrlc@tcv5gf5motsm>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
 <20250521-vsock-linger-v5-2-94827860d1d6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250521-vsock-linger-v5-2-94827860d1d6@rbox.co>

On Wed, May 21, 2025 at 12:55:20AM +0200, Michal Luczaj wrote:
>Lingering should be transport-independent in the long run. In preparation
>for supporting other transports, as well as the linger on shutdown(), move
>code to core.
>
>Generalize by querying vsock_transport::unsent_bytes(), guard against the
>callback being unimplemented. Do not pass sk_lingertime explicitly. Pull
>SOCK_LINGER check into vsock_linger().
>
>Flatten the function. Remove the nested block by inverting the condition:
>return early on !timeout.
>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> include/net/af_vsock.h                  |  1 +
> net/vmw_vsock/af_vsock.c                | 33 +++++++++++++++++++++++++++++++++
> net/vmw_vsock/virtio_transport_common.c | 23 ++---------------------
> 3 files changed, 36 insertions(+), 21 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 9e85424c834353d016a527070dd62e15ff3bfce1..d56e6e135158939087d060dfcf65d3fdaea53bf3 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
> 				     void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
> bool vsock_find_cid(unsigned int cid);
>+void vsock_linger(struct sock *sk);
>
> /**** TAP ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..2e7a3034e965db30b6ee295370d866e6d8b1c341 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1013,6 +1013,39 @@ static int vsock_getname(struct socket *sock,
> 	return err;
> }
>
>+void vsock_linger(struct sock *sk)
>+{
>+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+	ssize_t (*unsent)(struct vsock_sock *vsk);
>+	struct vsock_sock *vsk = vsock_sk(sk);
>+	long timeout;
>+
>+	if (!sock_flag(sk, SOCK_LINGER))
>+		return;
>+
>+	timeout = sk->sk_lingertime;
>+	if (!timeout)
>+		return;
>+
>+	/* Transports must implement `unsent_bytes` if they want to support
>+	 * SOCK_LINGER through `vsock_linger()` since we use it to check when
>+	 * the socket can be closed.
>+	 */
>+	unsent = vsk->transport->unsent_bytes;
>+	if (!unsent)
>+		return;
>+
>+	add_wait_queue(sk_sleep(sk), &wait);
>+
>+	do {
>+		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>+			break;
>+	} while (!signal_pending(current) && timeout);
>+
>+	remove_wait_queue(sk_sleep(sk), &wait);
>+}
>+EXPORT_SYMBOL_GPL(vsock_linger);
>+
> static int vsock_shutdown(struct socket *sock, int mode)
> {
> 	int err;
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index f2f1b166731b1bf2baa3db2854de19aa331128ea..7897fd970dd867bd2c97a2147e3a5c853fb514af 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1191,25 +1191,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
> 	vsock_remove_sock(vsk);
> }
>
>-static void virtio_transport_wait_close(struct sock *sk, long timeout)
>-{
>-	if (timeout) {
>-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>-		struct vsock_sock *vsk = vsock_sk(sk);
>-
>-		add_wait_queue(sk_sleep(sk), &wait);
>-
>-		do {
>-			if (sk_wait_event(sk, &timeout,
>-					  virtio_transport_unsent_bytes(vsk) == 0,
>-					  &wait))
>-				break;
>-		} while (!signal_pending(current) && timeout);
>-
>-		remove_wait_queue(sk_sleep(sk), &wait);
>-	}
>-}
>-
> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
> 					       bool cancel_timeout)
> {
>@@ -1279,8 +1260,8 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
> 	if ((sk->sk_shutdown & SHUTDOWN_MASK) != SHUTDOWN_MASK)
> 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
>
>-	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
>-		virtio_transport_wait_close(sk, sk->sk_lingertime);
>+	if (!(current->flags & PF_EXITING))
>+		vsock_linger(sk);
>
> 	if (sock_flag(sk, SOCK_DONE)) {
> 		return true;
>
>-- 
>2.49.0
>


