Return-Path: <kvm+bounces-43161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3F6A85F67
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 15:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23CBA7B490A
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 13:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EF61EFFB8;
	Fri, 11 Apr 2025 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hgOuO29A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3908020EB
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744379035; cv=none; b=PkCsqObET4m2NG6NOgviqMHUNWZU9rdaSm2zS854jXJE1O61H1VQS8sEVdN6NAC3uJ4KvWcykK07szwzLj94wCD+X6xu5E4xnF6LsiDztm/wk1VhjbUIA9PAAOxgaIGfUwi1ePTaWbPTs41v/EmB2OdvXobU0KskcrlWpFL3P94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744379035; c=relaxed/simple;
	bh=pqHaLPJDGFUQgp5UFALTBo7XsWRP1YBGfAfNOrlRGRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Grbi6mK2rKECu9LlegSYIsY1Q0I27gm4iWH/qlDdunPu/QnagftiwKvWIvcffB4W3Ot6/D17AWSQswBCkXkz5PI44oyTLG3moLKvLe3ntZYsRJYIewsDu6z4yfdR4U+PwqYho9AagYRgO2pgM9I8XE+PWR9Zop98SXz8xJmFK7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hgOuO29A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744379032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8eQRfu1SwDMTUD65YYbxtLcJcUUvfPEbGonaBHeDlEw=;
	b=hgOuO29A71ipuu42/DFk6PyC9OrAAdFwFhL67XWrVYgSq5HcHTCPNhfggPbp8piFn1PYA7
	vc790b3qLgjMHpNrV5xSljLjTqZuZMxmrTtZKHlYPJoqnyKqYNmCtB69PTRovmXoSdioxx
	Eo795f0vS1qFzg0JqgwqwOlR/Wz8wdc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-OG4Y1UJTMAmTvzuqokw_eg-1; Fri, 11 Apr 2025 09:43:50 -0400
X-MC-Unique: OG4Y1UJTMAmTvzuqokw_eg-1
X-Mimecast-MFC-AGG-ID: OG4Y1UJTMAmTvzuqokw_eg_1744379030
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e5c76fd898so1750325a12.1
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 06:43:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744379029; x=1744983829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eQRfu1SwDMTUD65YYbxtLcJcUUvfPEbGonaBHeDlEw=;
        b=lnBtVmDZwxxScFXrnGEVJdUNZMHdljn0C5d6zzPDUhS9zYpB+WG0D9o+qPPSk/VJMm
         Jfed/J1/Iq/Hrb1iFPdMM7hrVANt4BT77WWUQtaqr5ISopJ3sG2cr7ENx7ESb5YcLY6V
         xXrnmau0Qxn9GTpT56b6m96q5i9oL3zKzBa+hTsUuk46QKlMPBUuecqLbIe/xt/t+Vcj
         /VaViH5BMXKRe9yTXkdb3wHk2nGZ6ytJGXnM6trMoj17hrlmFJQXTjuxmm4shAgkvDV+
         lEOUNQn2+2E2s4URs86ldzh60021NwSwsMJ3BxRm66fHSwfTgLuKnsvqo8RcGCI6af/S
         zpew==
X-Forwarded-Encrypted: i=1; AJvYcCWnyupxgrTNqkSnWT9JXSlQqurMdSud55xs5omOp9+OweKIof3mRvO9ABrhjBTflZSy5W8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtmnrvH9oe4xalkGbZ1NGSeWgG6UMCVxUPsL83lku3e5acYR0J
	AlXsEkjMymQ7GnxrXC7sSHfYuDtq0ZT0WOWeBW0Asik9Vken3g07za5F/TZcUOkXHLSjAxWdYU5
	exPi4KpL1XbJvLy2ogoVS2DXiwrZhFl8b0KEaL3qQfv7yRKdsVA==
X-Gm-Gg: ASbGncv/Lt3A2mLciKVml18GjhcdEmfpni/MxlXApawuYMtPCZxmlENXIWo3DvMteVW
	nJ+GRdB9j0TT43lWs4GSb16+gt2dwHAK9Na9OAsw2CJ8KVUE5nG2IOeYrVvIJeCfp8KUam0O5mf
	HB4z/H6JRItJRRhq42h7GDqyzf0gqo3tJ1oHqFgJEeIwa7PvH85nkI9Bs3boT72GH+/6DPtqxAH
	Qfb4omxvozZgD/kNMOcLYACpfNt0OSskJmjyiLdQZiIAJfZVh7YbMi8fDYFQa3r5iFFIxG1jizD
	B4ul3yXHFo0ZaZEoIA9Ax0nEl+upwcoEDqR3Gk3iNie05/Ot1jBV64R+FyUu
X-Received: by 2002:a05:6402:40d5:b0:5e5:437b:74a7 with SMTP id 4fb4d7f45d1cf-5f36f6441c8mr2464155a12.8.1744379029532;
        Fri, 11 Apr 2025 06:43:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqX68Cv7buhlNWQ6yUC3SFUYIPHgd82ovG6x6fn05G9UUk87m/Y4qhNVGifIURWeZGKX/Zgw==
X-Received: by 2002:a05:6402:40d5:b0:5e5:437b:74a7 with SMTP id 4fb4d7f45d1cf-5f36f6441c8mr2464099a12.8.1744379028891;
        Fri, 11 Apr 2025 06:43:48 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-213.retail.telecomitalia.it. [79.53.30.213])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36f505744sm1008727a12.57.2025.04.11.06.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 06:43:48 -0700 (PDT)
Date: Fri, 11 Apr 2025 15:43:44 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] vsock: Linger on unsent data
Message-ID: <p5toijsqhehc4kp7gztto3nmrqa33f62duozoxn7u5hh6d2xpe@lfzy6kdszegf>
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
 <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>

On Mon, Apr 07, 2025 at 08:41:43PM +0200, Michal Luczaj wrote:
>Change the behaviour of a lingering close(): instead of waiting for all
>data to be consumed, block until data is considered sent, i.e. until worker
>picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.
>
>Do linger on shutdown() just as well.

I think this should go in a separate patch.

>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> include/net/af_vsock.h                  |  1 +
> net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
> net/vmw_vsock/virtio_transport_common.c | 25 +++----------------------
> 3 files changed, 29 insertions(+), 22 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 9e85424c834353d016a527070dd62e15ff3bfce1..bd8b88d70423051dd05fc445fe37971af631ba03 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
> 				     void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
> bool vsock_find_cid(unsigned int cid);
>+void vsock_linger(struct sock *sk, long timeout);
>
> /**** TAP ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..383c6644d047589035c0439c47d1440273e67ea9 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1013,6 +1013,29 @@ static int vsock_getname(struct socket *sock,
> 	return err;
> }
>
>+void vsock_linger(struct sock *sk, long timeout)
>+{
>+	if (timeout) {

I would prefer to avoid a whole nested block and return immediately
in such a case. (It's pre-existing, but since we are moving this code
I'd fix it).

	if (!timeout)
		return;

>+		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+		ssize_t (*unsent)(struct vsock_sock *vsk);
>+		struct vsock_sock *vsk = vsock_sk(sk);
>+

transport->unsent_bytes can be NULL, this will panic with hyperv or
vmci transport, especially because we now call this function in
vsock_shutdown().

I'd skip that call if transports don't implement it, but please add
a comment on top of this function about that.

>+		unsent = vsk->transport->unsent_bytes;
>+		if (!unsent)
>+			return;
>+
>+		add_wait_queue(sk_sleep(sk), &wait);
>+
>+		do {
>+			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>+				break;
>+		} while (!signal_pending(current) && timeout);
>+
>+		remove_wait_queue(sk_sleep(sk), &wait);
>+	}
>+}
>+EXPORT_SYMBOL_GPL(vsock_linger);
>+
> static int vsock_shutdown(struct socket *sock, int mode)
> {
> 	int err;
>@@ -1056,6 +1079,8 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 		if (sock_type_connectible(sk->sk_type)) {
> 			sock_reset_flag(sk, SOCK_DONE);
> 			vsock_send_shutdown(sk, mode);
>+			if (sock_flag(sk, SOCK_LINGER))
>+				vsock_linger(sk, sk->sk_lingertime);
> 		}
> 	}
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d8809655fe522749fbbc9025df71f071bd..66ff2e694e474ad16f70248cc1dc235f4e1ebaa1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1192,23 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
> 	vsock_remove_sock(vsk);
> }
>
>-static void virtio_transport_wait_close(struct sock *sk, long timeout)
>-{
>-	if (timeout) {
>-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>-
>-		add_wait_queue(sk_sleep(sk), &wait);
>-
>-		do {
>-			if (sk_wait_event(sk, &timeout,
>-					  sock_flag(sk, SOCK_DONE), &wait))
>-				break;
>-		} while (!signal_pending(current) && timeout);
>-
>-		remove_wait_queue(sk_sleep(sk), &wait);
>-	}
>-}

Anyway in this patch we are doing 3 things:
1. check unsent_bytes during wait_close()
2. move wait_close in af_vsock.c adding vsock_linger()
3. call vsock_linger() also during vsock_shutdown()

I think this is a clear signal that we need to split it into at least
3 patches.

>-
> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
> 					       bool cancel_timeout)
> {
>@@ -1279,15 +1262,13 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
> 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
>
> 	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
>-		virtio_transport_wait_close(sk, sk->sk_lingertime);
>+		vsock_linger(sk, sk->sk_lingertime);

Might it make sense, as you did for vsock_shutdown(), to move this
to af_vsock.c (in another patch) so that we support it for all
transports?

>
>-	if (sock_flag(sk, SOCK_DONE)) {
>+	if (sock_flag(sk, SOCK_DONE))
> 		return true;
>-	}

Please avoid this unrelated changes, if you really want to fix them,
add another patch in the series where to fix them.

>
> 	sock_hold(sk);
>-	INIT_DELAYED_WORK(&vsk->close_work,
>-			  virtio_transport_close_timeout);
>+	INIT_DELAYED_WORK(&vsk->close_work, virtio_transport_close_timeout);

Ditto.

These 2 could go together in a single `cleanup` patch, although I
usually avoid it so that `git blame` makes sense. But if we want to
make checkpatch happy, that's fine.

Thanks,
Stefano

> 	vsk->close_work_scheduled = true;
> 	schedule_delayed_work(&vsk->close_work, VSOCK_CLOSE_TIMEOUT);
> 	return false;
>
>-- 
>2.49.0
>


