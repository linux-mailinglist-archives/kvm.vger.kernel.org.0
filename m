Return-Path: <kvm+bounces-44879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21603AA46F9
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2291B1BA4F5B
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651F2231856;
	Wed, 30 Apr 2025 09:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pibo+tnp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB96923183C
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746005230; cv=none; b=rwWQlwFabL+J61jIe6LK80mIs/XygzTwmLIjEGk4wLsA+hq8pWLjGYLYdUKIrkcC0WVG1iMBylVEF18N2IgjfAHuK9q5CNWT1zBQ0b8FmJtP/M2+K5jjyUfBttulQ0yyEVtAof4O0vVSryryHXRHMEq65b/KSKHcMEAc88HPs/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746005230; c=relaxed/simple;
	bh=kjb/2qlRokzw4V64RKekB6zLbCzs3UmMCafUrdMO+5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWFPjmnaM37QFaku3xpQNFp0iZlfRwtd3oPCaCZQUtW6OICT0pZUWgU+XJQ5ymQclBtyIQhK5+XgewPEvaU87BNljTaJyprwMMJH969zFdQEFIwbOUqwRizvtWrwqG4xQ39hKhc6GcOXrqz339I/aFvJQKEGgBukRCNjxR5jbF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pibo+tnp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746005227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BnGE355VKh8cwgKuDwR0kb5tI61AXcZQbhXFxQc6RqM=;
	b=Pibo+tnpQS2AmL4YzChF5unANdCDon7pI8mcnAk7va3BN+ztA4AeVa8qjrkh19kducQK+D
	dDQr5MzxU81SXts17mJTVPA3RQJAMgoAM2hdKFv3ZgyX/ZYbLtLauXwKpFt4X25Nz5oXXZ
	H1G3olNPVSEC4KFpasqX6ujLcnQWuCo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-yjj_Bb_pNfGmOUZhx4hEVA-1; Wed, 30 Apr 2025 05:27:05 -0400
X-MC-Unique: yjj_Bb_pNfGmOUZhx4hEVA-1
X-Mimecast-MFC-AGG-ID: yjj_Bb_pNfGmOUZhx4hEVA_1746005225
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ace942ab877so381341766b.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 02:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746005225; x=1746610025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnGE355VKh8cwgKuDwR0kb5tI61AXcZQbhXFxQc6RqM=;
        b=CzGUElU2KG/I+s5rS5dRtuPtB8VPMUjAb5+oSDzKtykOdXzVUBZx7iBS2h7DhWtA1k
         I2PypuKZrAFfRPVfIh5sCRW2I8RQbt2UQir8bdmGnaV/CghinBcAxBvcjj/W6E0UIMYc
         g+kVjlyFWrIxgwrjO/iRtR0z0RvOLnM8zFw8m8WAR18B0o2Cg3QrEjxCQyn4iLbzhIBw
         SztUy8JYckYWn0mi4DQvd4uYVzFCStp+SR6tbgCyx0w6gtdXp53UzKFlV1ztacpQPA5X
         N13lVI7q177lHEnjLHLl7gDjT2SQKVG28+eBicDMgU1E8pyBjKfbNB1lYTOo3ya54cVb
         OQgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOO1bBs25u0mT2s/BwD0CEap1lI8MsHA6GxeOQysEmEHFEvSfy6bDeYSdVmlUrH58UxB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhY6BcpY6BiKK2RdTUevCWzEWWhtTq30eyEtGt80uMWQqzkvoZ
	KyFfn5A9Lwjn1bYxG0mB02GFToH9ySe/crMOfoarIxQ3yw67T4X+Wo5wrtZ4I7BEsjKVZBHUg4f
	VodxezKnjCEeB81bx+1C7UBMjEw7RwrOvmIYsQkqgVgHpFvbzuQ==
X-Gm-Gg: ASbGncv0LxqqUpLe10ogObYGzZDU4QcYaLp6Iu1IsM3vcrs+DQrtLHZiGz21HDLpm+h
	56Jfko9zC2TuYmVzjX0HGhgS1HiQSkCgXKhcZvTqoixb/8+H3YTb3aRGWWww2Kip4GO6y8iC34h
	FGv+0D/TyWU0JCCyqgf4W/1AlCYB5yI5+PULO2mpzxB2BAL+CskZ0at1q+bXVw8/cn4qWdddghD
	og8AusSQk98b3bh6xnYMYT1XXbazyFeWEJY2pFmoUyi0BHjyUcIUYfYuJRw6tjcHwiDEMKS3lNF
	TbHJ2KSa0x7HRO1MsQ==
X-Received: by 2002:a17:907:6d22:b0:acb:6081:14ec with SMTP id a640c23a62f3a-acee26469f2mr167110166b.61.1746005224719;
        Wed, 30 Apr 2025 02:27:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpWzcCN+MPKS91oqLZ/RURiVcQD7mwDZdTf3RoSbMle6jXy5M9/HSlwH5Kk6tGLLsNJHDLYA==
X-Received: by 2002:a17:907:6d22:b0:acb:6081:14ec with SMTP id a640c23a62f3a-acee26469f2mr167105766b.61.1746005224017;
        Wed, 30 Apr 2025 02:27:04 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.220.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e70b0sm895358966b.43.2025.04.30.02.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 02:27:03 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:26:55 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] vsock/virtio: Linger on unsent data
Message-ID: <x3kkxnrqujqjkrtptr2qdd3227ncof2vb7jbrcg3aibvwjfqxa@hbinpxjuk3qe>
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-1-ddbe73b53457@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250430-vsock-linger-v3-1-ddbe73b53457@rbox.co>

On Wed, Apr 30, 2025 at 11:10:27AM +0200, Michal Luczaj wrote:
>Currently vsock's lingering effectively boils down to waiting (or timing
>out) until packets are consumed or dropped by the peer; be it by receiving
>the data, closing or shutting down the connection.
>
>To align with the semantics described in the SO_LINGER section of man
>socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>of a lingering close(): instead of waiting for all data to be handled,
>block until data is considered sent from the vsock's transport point of
>view. That is until worker picks the packets for processing and decrements
>virtio_vsock_sock::bytes_unsent down to 0.
>
>Note that (some interpretation of) lingering was always limited to
>transports that called virtio_transport_wait_close() on transport release.
>This does not change, i.e. under Hyper-V and VMCI no lingering would be
>observed.
>
>The implementation does not adhere strictly to man page's interpretation of
>SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d8809655fe522749fbbc9025df71f071bd..49c6617b467195ba385cc3db86caa4321b422d7a 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1196,12 +1196,16 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
> {
> 	if (timeout) {
> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+		ssize_t (*unsent)(struct vsock_sock *vsk);
>+		struct vsock_sock *vsk = vsock_sk(sk);
>+
>+		unsent = vsk->transport->unsent_bytes;

Just use `virtio_transport_unsent_bytes`, we don't need to be generic on 
transport here.

>
> 		add_wait_queue(sk_sleep(sk), &wait);
>
> 		do {
>-			if (sk_wait_event(sk, &timeout,
>-					  sock_flag(sk, SOCK_DONE), &wait))
>+			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0,
>+					  &wait))
> 				break;
> 		} while (!signal_pending(current) && timeout);
>
>
>-- 
>2.49.0
>


