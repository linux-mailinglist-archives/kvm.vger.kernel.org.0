Return-Path: <kvm+bounces-2854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6001C7FEAA7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0DF1B2105A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF21333988;
	Thu, 30 Nov 2023 08:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TcAFb0bd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736AD9A
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701333062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uvwklizxttywrNQn/HzGf7D1oVOeCG+xDam5mVjOLQ0=;
	b=TcAFb0bdbqbkE78I9x2Gi4rdarMA3VvD1GTPt2wadhFGgmICBxdFGxIKBSoTmo2RcyQxjd
	WEEUcoGFCvv7L7xopwaiytj3jsN3TnR8zKNJJ+GeyPYk5siKAv34GBn7CBZ+sQ1hI+w/lf
	oA4IM3/TPfaxv1j1FEq78ezOFgbdjz0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-3TntjE2COJKaX1G7v6EXTQ-1; Thu, 30 Nov 2023 03:31:00 -0500
X-MC-Unique: 3TntjE2COJKaX1G7v6EXTQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c9b18161b6so7214811fa.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701333059; x=1701937859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvwklizxttywrNQn/HzGf7D1oVOeCG+xDam5mVjOLQ0=;
        b=atb/EwD1pxTfnwsjiyjH27E6qTo7ppnzbuNmFHIoo2jAME8f9sxDfYqL/XckBxEdxt
         BjB00/NbE4ttN41lZeBnM4P0fdGhRA8fM1R/XQDtHVqfgIVi4NRKFL/0YXt9W6FahDFC
         w0hyDQM2DJjyidstAW9V/XFyT9TBtYtNplm21ls5+8iG6odcMb6pi6+xuOw6Mj3pZw0g
         aYGKBXqvTt2dRypBpwkYzrsJASOhz0yXGnvZMFngk3fxyrOF8nq8mohm3zZMUYFrjkd7
         JKtRZKhy6UkyLZDJFN9BLJVcWnXdZyW3dk41tihkxRuYqkBT5eHCLg+a6ks1gMPHyLJL
         pSAg==
X-Gm-Message-State: AOJu0YwRySVZqdhhBwMwSblpKHuOGHiDspLuh9jNohEwaUtn4LkBGG2p
	A+U4xQQJAoS3nkQO7HKnL2ETBE1aGC1iJvrOSnIFw3K/q9EMiMwj6MJrwhwbLV5kV1RwIaDZQ8l
	/lXyjzj+zIRYs
X-Received: by 2002:a05:6512:3b87:b0:50b:c6c7:1e60 with SMTP id g7-20020a0565123b8700b0050bc6c71e60mr3510708lfv.29.1701333059230;
        Thu, 30 Nov 2023 00:30:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZPXMRUFPQjq9fdK7LoNwx6iK0sPnSJoC33Kzjoq8NkyT67Yp84Aiz14LjSlhXSudqjwUSpQ==
X-Received: by 2002:a05:6512:3b87:b0:50b:c6c7:1e60 with SMTP id g7-20020a0565123b8700b0050bc6c71e60mr3510684lfv.29.1701333058851;
        Thu, 30 Nov 2023 00:30:58 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id r5-20020a05600c35c500b0040b54335d57sm4368784wmq.17.2023.11.30.00.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 00:30:58 -0800 (PST)
Date: Thu, 30 Nov 2023 09:30:54 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 1/3] vsock: update SO_RCVLOWAT setting callback
Message-ID: <pewqjb3y45q4s5ffqxwavss5hz2ub5eeucms7egopbfpjq4bnr@rnjezpz2xgsu>
References: <20231129212519.2938875-1-avkrasnov@salutedevices.com>
 <20231129212519.2938875-2-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231129212519.2938875-2-avkrasnov@salutedevices.com>

On Thu, Nov 30, 2023 at 12:25:17AM +0300, Arseniy Krasnov wrote:
>Do not return if transport callback for SO_RCVLOWAT is set (only in
>error case). In this case we don't need to set 'sk_rcvlowat' field in
>each transport - only in 'vsock_set_rcvlowat()'. Also, if 'sk_rcvlowat'
>is now set only in af_vsock.c, change callback name from 'set_rcvlowat'
>to 'notify_set_rcvlowat'.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v3 -> v4:
>  * Rename 'set_rcvlowat' to 'notify_set_rcvlowat'.
>  * Commit message updated.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
> include/net/af_vsock.h           | 2 +-
> net/vmw_vsock/af_vsock.c         | 9 +++++++--
> net/vmw_vsock/hyperv_transport.c | 4 ++--
> 3 files changed, 10 insertions(+), 5 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index e302c0e804d0..535701efc1e5 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -137,7 +137,6 @@ struct vsock_transport {
> 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>-	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
>
> 	/* SEQ_PACKET. */
> 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>@@ -168,6 +167,7 @@ struct vsock_transport {
> 		struct vsock_transport_send_notify_data *);
> 	/* sk_lock held by the caller */
> 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
>+	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
>
> 	/* Shutdown. */
> 	int (*shutdown)(struct vsock_sock *, int);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 816725af281f..54ba7316f808 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
>
> 	transport = vsk->transport;
>
>-	if (transport && transport->set_rcvlowat)
>-		return transport->set_rcvlowat(vsk, val);
>+	if (transport && transport->notify_set_rcvlowat) {
>+		int err;
>+
>+		err = transport->notify_set_rcvlowat(vsk, val);
>+		if (err)
>+			return err;
>+	}
>
> 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
> 	return 0;
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index 7cb1a9d2cdb4..e2157e387217 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -816,7 +816,7 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
> }
>
> static
>-int hvs_set_rcvlowat(struct vsock_sock *vsk, int val)
>+int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
> {
> 	return -EOPNOTSUPP;
> }
>@@ -856,7 +856,7 @@ static struct vsock_transport hvs_transport = {
> 	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
> 	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
>
>-	.set_rcvlowat             = hvs_set_rcvlowat
>+	.notify_set_rcvlowat      = hvs_notify_set_rcvlowat
> };
>
> static bool hvs_check_transport(struct vsock_sock *vsk)
>-- 
>2.25.1
>


