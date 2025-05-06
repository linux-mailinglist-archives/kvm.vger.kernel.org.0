Return-Path: <kvm+bounces-45586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B86AAC07D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF4E31C22ACA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0D02749FA;
	Tue,  6 May 2025 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mwiq0lH0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C026AA8F
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746525245; cv=none; b=hgBPxWL/Ehkkp3mkJxnxXn/fRtPM6YmN2KTpSn33kL45ovUxO1UeTzc9s76A3BU/DamDP2/Q8/ENqPrhEnUNOsoCUgLPw/KuqUNDRc0U+y+jf/WkVzJ6+veAvMGz4XkuzIlsx4mA+o5M0kSai8geiFzYzN72ZoWULRhZVNEmY30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746525245; c=relaxed/simple;
	bh=WZ64pm8mCn6WauOvEK5LHUkaP/YAEqtWPN8ZVB3/f58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOE/L430c/yrhllRw8yHAvbU9hUjHBCHAN6QWdgaRKsnSAWfAmJMU0zlxl7ob4vhtcSJ4ec1kZoax2ZW4iyjlQtumHIgektqrlQz5QNedGR3gd5nl0ECg1HpbG9MpRnPuEmgFR1qsnxDKO6jOJNokAV3snTKOXF+GDuZg7NEbHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mwiq0lH0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746525242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E6B1xjoScf7bsPJTh7xEGagDYN0nDoGDFYe9DHlpFOg=;
	b=Mwiq0lH0P4jffVY+V/d3llJPsV8wIedPkaMJTpKOGI2DHmTpHGW/2xMFJKJ7Zm9AMThwSA
	TEaZEwEsYVes1jkx1BPSbMxfJIlZbJdHEGKqPBSuBO3lErmX+UtpzKlXhaOTmIps7fk08/
	aW8kENlmHIQVjjL/Qtrn8lBJNYIECdU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-XPm_-seTNe6qlBQpKLdl3g-1; Tue, 06 May 2025 05:54:01 -0400
X-MC-Unique: XPm_-seTNe6qlBQpKLdl3g-1
X-Mimecast-MFC-AGG-ID: XPm_-seTNe6qlBQpKLdl3g_1746525240
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ac3c219371bso437258966b.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 02:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746525240; x=1747130040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6B1xjoScf7bsPJTh7xEGagDYN0nDoGDFYe9DHlpFOg=;
        b=CNWQKINCJoP8o1AQMxhXcIohg+VrqkqWJIbeeL33W2O9tBrx0h7dBzge8c7pcud0I+
         zsZf6rF13aj/uodaj1vzmZQZUfWBcybGOmq+g5kso6mUMiIrpdEO44hnpAwkKpJYxZ+F
         lFGFXRulorcUdqAvnBAzyglmU0QkOyXK81+NgvuHgF2BCF9yGx+g8AFS8N+c4AUh8ayh
         ylMFetYYb/sszlXDMD6sezt8krpikNEOmA5ReyjjWsXQ3TR8UgR0BxCrH0h972bXZ0tu
         ej/TDK5W7g5IVjNrryuFiiQJytV9tcUK2p89VDcCOVuIHwi2j5KYCU0S+sj8qnz9feu1
         XLyg==
X-Forwarded-Encrypted: i=1; AJvYcCVMqWsdjxQeyvME5iraNc8WvIWFosrkLG/qwGJgaFaATsN9Ev+itSsuWC8OUxgBWH6adj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdQP2QcZU1+BXkK2bwpxeji2csKOAVKFrWad2Lxk5Vtzh2JKBZ
	FSRTpgH+tMf2QYV0RVCs2fpI9HbaNOqymqNxCrfj35pw57vE7W+mkXLUEyToU0xJqFnGP4Q30Y4
	29MqO1XpuTv1rw9XRUA9+wMQVhI/sRQhF6hLm8ZR0tXCjwmY1HtL5zDYRXg==
X-Gm-Gg: ASbGncuWKO1r2Zhka+cEll/j5ESWOVqvjT5ouTGg7BVnCdPl55iVTjI+6SgWPIHFCDF
	QpGaPL+L0HCTrtLUPEPrfwNRcgCBPH3nPGPCSpEyoHBw2g3eE6Q5lmJ7gxYpQnqYKuZ+Ta2y4R6
	HxPFdURAc1L1yh5043o1gwNIfL2BL2611zF8Iy+0E9OnoWRaYB+y63BpKOIRl3Dw9gYBXZqAxgZ
	IvyTDv7sS9ZL6NUEmy2dXm3Ngimd3G0EN81bobi1u7+WyBBHRQSdsyfYNCgeCvrr0qtkUo6c07s
	FUTmyCAZt5M1tGUIWg==
X-Received: by 2002:a17:907:8d87:b0:aca:de15:f2ad with SMTP id a640c23a62f3a-ad1d46ddad0mr219299766b.60.1746525239838;
        Tue, 06 May 2025 02:53:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/1oV0zciKaW3O1wacg9c1zps+3AHOJS/RUO5rgbV5p2b2yw5R1zfs8RHPWnIxlOh3Hh5OJQ==
X-Received: by 2002:a17:907:8d87:b0:aca:de15:f2ad with SMTP id a640c23a62f3a-ad1d46ddad0mr219295266b.60.1746525239247;
        Tue, 06 May 2025 02:53:59 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.219.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fa77b8fe52sm7425752a12.55.2025.05.06.02.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 02:53:58 -0700 (PDT)
Date: Tue, 6 May 2025 11:53:51 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] vsock: Move lingering logic to af_vsock
 core
Message-ID: <hcme242wm3h33zvbo6g6xinhbsjkeaawhsjjutxrhkjoh6xhin@gm5yvzv4ao7k>
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-2-beabbd8a0847@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250501-vsock-linger-v4-2-beabbd8a0847@rbox.co>

On Thu, May 01, 2025 at 10:05:23AM +0200, Michal Luczaj wrote:
>Lingering should be transport-independent in the long run. In preparation
>for supporting other transports, as well the linger on shutdown(), move
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
> net/vmw_vsock/af_vsock.c                | 30 ++++++++++++++++++++++++++++++
> net/vmw_vsock/virtio_transport_common.c | 23 ++---------------------
> 3 files changed, 33 insertions(+), 21 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 9e85424c834353d016a527070dd62e15ff3bfce1..d56e6e135158939087d060dfcf65d3fdaea53bf3 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
> 				     void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock 
> *psk);
> bool vsock_find_cid(unsigned int cid);
>+void vsock_linger(struct sock *sk);
>
> /**** TAP ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..a31ad6b141cd38d1806df4b5d417924bb8607e32 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1013,6 +1013,36 @@ static int vsock_getname(struct socket *sock,
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
>+	/* unsent_bytes() may be unimplemented. */

This comment IMO should be enriched, as it is now it doesn't add much to 
the code. I'm thinking on something like this:
     Transports must implement `unsent_bytes` if they want to support
     SOCK_LINGER through `vsock_linger()` since we use it to check when
     the socket can be closed.

The rest LGTM!

Thanks,
Stefano

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
>index 
>045ac53f69735e1979162aea8c9ab5961407640c..aa308f285bf1bcf4c689407033de854c6f85a639 
>100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1192,25 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
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
>@@ -1280,8 +1261,8 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
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


