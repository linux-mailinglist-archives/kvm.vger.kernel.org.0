Return-Path: <kvm+bounces-31087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F949C0218
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47EFE1F21BD7
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF271EBA1B;
	Thu,  7 Nov 2024 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DRKhWJKM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729C1E6DD5
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974654; cv=none; b=Iil15Y39Z67I3ZZxwnmtdX1U3Wnp1/YEZ5heYKTdSpL4ajvIpv0g1OknIu2KdfkOSWwVdZXFMu59hvcBILI/vDdBtkxoN3pzP8MqrRg/ckN8tssdsiMTIlxB+noAn2nqmFo6LUFO0fLjLwg8KXCC29Su3tORMShTheYs39SIOAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974654; c=relaxed/simple;
	bh=i2bWLU6m00p8TlV+OMcgPPhsJkVRY5pKKD5A+R1u5eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxSpXFmkcsMnMY1LGnToZLX6WBV74/V841eYvDT+H7QbEG9j9guYnQRYSroiVw+p0BuELC5L6Eq61gOX4niXsZCrqpFB4i+ueIz3qLrp/7E7VPz3w4JTt/qPWBqLGpxJRc34z9KHH9ZzTCbfkaUvRz7uL0D/uiV7B9LG2k8ROBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DRKhWJKM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730974652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RT+TotpfDd8T0LMPg0eVo1dThYn+tyWQ9cxcGi4C2c0=;
	b=DRKhWJKMHOjKbdZVornnyvuaj+QEnNnqQgtetfU+aQvjrhWr5aPVr26wwOVu05f8cinBJP
	GCMgSgPZAQ0eKN3BZc629fr1s9FBGCJy0excguGRMiYVb72Ue6ZOtQYoKY+t13eXgxzVH3
	OOtXTSIMXa49PgC8+PDbiBKWP0JPizU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-p3e0p2JcNgGiLn1ETIomTA-1; Thu, 07 Nov 2024 05:17:30 -0500
X-MC-Unique: p3e0p2JcNgGiLn1ETIomTA-1
X-Mimecast-MFC-AGG-ID: p3e0p2JcNgGiLn1ETIomTA
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b15d3cd6dcso90516085a.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 02:17:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730974650; x=1731579450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RT+TotpfDd8T0LMPg0eVo1dThYn+tyWQ9cxcGi4C2c0=;
        b=IjC77TyJ/Kd6LSfr9K+TIByF7+pLAdKojedpuHMtqBm9sAMROUYBO1uMMLoWQFvmtB
         3gldBFo1PKzsjZWkg6wr2BDbMA6Um2E1uRggX2Of94rLTj50J2OGfJqkIp5w44AiX15X
         bHobgGC3CEujU/JMqKtpilhASB/FKPpbttBNnSo6EVmAtJrUqBRSp6vw9Xu0rJJyTdqS
         1/JFK00bSi7x0UGfzlGd18z14P2pYz1le+eTQtjY6gW5uqc0huCI3YYhAkvzCGZXInj8
         n1DZUuE41DkbvTeF9JtTqZbNuqwaZoltlW5W1aVJdLKzT6IM6BFMg7ZCpelsSLVGvsDT
         xs0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGYMgIFa3+jNPaq6s7DkUvAOQd9zIaqa4D+0WOUYPoFJpRun7WZS9RkGpUN4wgd8EXWEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwE2JCaNbzQsN8Ik0QBQjEX7N9I3Clu5aUEK+es27wQVKmBsxOt
	FXdXSrUHFLq3ymAhJx8pbIbfF0cK9Qu8bT+oPVpJYFoL76RQYvRvxY02CTp2XJucrE66UV3S2FI
	jdlwWbEYDYZh1MHGqXJlLyOp7Agba1nXbvVKjqp9GrcBy3iAy5g==
X-Received: by 2002:a05:620a:190c:b0:7b1:3fe8:8f11 with SMTP id af79cd13be357-7b2fb982995mr3303736485a.33.1730974650101;
        Thu, 07 Nov 2024 02:17:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxQk+y8ShdAUuI0XQTmhaMq5PkmFGd1rW8NElHzMk7ilpzQEiLfRkwxbgbYsdg4ZaY/uBVng==
X-Received: by 2002:a05:620a:190c:b0:7b1:3fe8:8f11 with SMTP id af79cd13be357-7b2fb982995mr3303733985a.33.1730974649719;
        Thu, 07 Nov 2024 02:17:29 -0800 (PST)
Received: from sgarzare-redhat ([5.77.70.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac57c9bsm49118885a.54.2024.11.07.02.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:17:29 -0800 (PST)
Date: Thu, 7 Nov 2024 11:17:20 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jia He <justin.he@arm.com>, Arseniy Krasnov <avkrasnov@salutedevices.com>, 
	Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
	George Zhang <georgezhang@vmware.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Subject: Re: [PATCH net 2/4] virtio/vsock: Fix sk_error_queue memory leak
Message-ID: <vxc6tv6433tnyfhdq2gsh7edhuskawwh4g6ehafvrt2ca3cqf2@q3kxjlygq366>
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-2-8f4ffc3099e6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241106-vsock-mem-leaks-v1-2-8f4ffc3099e6@rbox.co>

On Wed, Nov 06, 2024 at 06:51:19PM +0100, Michal Luczaj wrote:
>Kernel queues MSG_ZEROCOPY completion notifications on the error queue.
>Where they remain, until explicitly recv()ed. To prevent memory leaks,
>clean up the queue when the socket is destroyed.
>
>unreferenced object 0xffff8881028beb00 (size 224):
>  comm "vsock_test", pid 1218, jiffies 4294694897
>  hex dump (first 32 bytes):
>    90 b0 21 17 81 88 ff ff 90 b0 21 17 81 88 ff ff  ..!.......!.....
>    00 00 00 00 00 00 00 00 00 b0 21 17 81 88 ff ff  ..........!.....
>  backtrace (crc 6c7031ca):
>    [<ffffffff81418ef7>] kmem_cache_alloc_node_noprof+0x2f7/0x370
>    [<ffffffff81d35882>] __alloc_skb+0x132/0x180
>    [<ffffffff81d2d32b>] sock_omalloc+0x4b/0x80
>    [<ffffffff81d3a8ae>] msg_zerocopy_realloc+0x9e/0x240
>    [<ffffffff81fe5cb2>] virtio_transport_send_pkt_info+0x412/0x4c0
>    [<ffffffff81fe6183>] virtio_transport_stream_enqueue+0x43/0x50
>    [<ffffffff81fe0813>] vsock_connectible_sendmsg+0x373/0x450
>    [<ffffffff81d233d5>] ____sys_sendmsg+0x365/0x3a0
>    [<ffffffff81d246f4>] ___sys_sendmsg+0x84/0xd0
>    [<ffffffff81d26f47>] __sys_sendmsg+0x47/0x80
>    [<ffffffff820d3df3>] do_syscall_64+0x93/0x180
>    [<ffffffff8220012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/af_vsock.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 35681adedd9aaec3565495158f5342b8aa76c9bc..dfd29160fe11c4675f872c1ee123d65b2da0dae6 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -836,6 +836,9 @@ static void vsock_sk_destruct(struct sock *sk)
> {
> 	struct vsock_sock *vsk = vsock_sk(sk);
>
>+	/* Flush MSG_ZEROCOPY leftovers. */
>+	__skb_queue_purge(&sk->sk_error_queue);
>+

It is true that for now this is supported only in the virtio transport, 
but it's more related to the core, so please remove `virtio` from the 
commit title.

The rest LGTM.

Thanks,
Stefano

> 	vsock_deassign_transport(vsk);
>
> 	/* When clearing these addresses, there's no need to set the family and
>
>-- 
>2.46.2
>


