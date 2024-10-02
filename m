Return-Path: <kvm+bounces-27816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F6398E118
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 18:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C23351C21C02
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091641D12E7;
	Wed,  2 Oct 2024 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CyinNNWW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6581D0E08
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727887388; cv=none; b=R3BDljcSmgq5aatdlVMdhitjK+Ti9XlBOerW62pqo7sc8+tNGrQ18bzm8OragQXrKfMAhW4OnyOgguNOEp8R+HFKdslxAyTclcOkhcPi1FwIqRiZ3oMgGfM+2mA7CQSc7NKWiSfo7i/ezCGaZtTjyR9xfRDkODUxfq3R7HUnm+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727887388; c=relaxed/simple;
	bh=RnZ5G5/umQ/ayd1tzXzxgN1t4G6NyUkZHDT0/1Et3qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkgMKN8eTr1Cq4vIG9LSBaNfNHwWX/DqV9LgC0fFWA2ReRdgPMsaBZ9S6qcKN2JJaCN8Jozwt6DVQHQInJH2uE1Dqf9D4i2oOHs34vkEUFqf2H3/kH/LRVQhT1fmvTM+EouuQsNpGSn52uAbR5/vQlPCNaEJ86BMrpC5fGjHu5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CyinNNWW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727887384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JYRsHIOR2+c4zlZHyS1UaHYCd7Y4/yu6uoJitE/pKB8=;
	b=CyinNNWWfogYYGcDlWaymTC5Gi3r1G0AaLDvRln0OxdT4A4awZ9kUGKai1OSR2382F42/v
	+XI233HPWYjiidPMcIcYcnj54JbDhK0b2toOsaB6u0+RJfSteb5z0+bzerzmt1R6t46QU0
	rt7TDKsSAjHysHNYip2fliBBVK3D0o8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-mmABdF4SOvaTEM0XHrQlEw-1; Wed, 02 Oct 2024 12:43:03 -0400
X-MC-Unique: mmABdF4SOvaTEM0XHrQlEw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2fac076e8f6so27539151fa.1
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 09:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727887382; x=1728492182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYRsHIOR2+c4zlZHyS1UaHYCd7Y4/yu6uoJitE/pKB8=;
        b=m1vy1S+tFnI/Jk97HCRxoomSaCYHwvz8olFPLm7Hh9jDGc3/fmkGXlMiZeZwjP/Ari
         GHqlw22yEEnBmN6Isvp3vGAPfe+wKBkjmTLJ4FxOB1xJzAAekKuxvPAxznLcfBXJsLyu
         7tAp//Sile9Ah2FzdmaaNFAZ0WZVWkzgzx3zx6UaKcL4pQW/CURD/8PfYkAdrMN69D2N
         tVm4K5ZYgZMz1xrRdEnnwr5OIv7HgHJ2f1qo2tVUdo+3zGYoaSoIPtUbv3/Q2DdqolOE
         OgGP4DUw1/KIt1lZdC9/lQrdIrjBHRP+YD2Am2aDNN7pciCavK9eMpWEbL7r5NA/I7Gc
         dGZw==
X-Forwarded-Encrypted: i=1; AJvYcCWLwjFBVgbuGhqEFxMeYWDosrmtixrwlBxyMWJ0CJuFSk0dkSqCtiL8HZlJ9nBFDPUuY34=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEF2QKf6k1LZ07FraN31nX0y3m3alDtv2awD/NVNLfaEpf06Ii
	BkBqmOiYALl3dW70Xa11ZKCWW57u5W54KaPP5Q4mV227jbVizj7M20orIEPlEFnm9j9yjSww+ss
	n/RsuWJDFrVS00xTF8evEwqPrzyL71B4BrQ0Z7T6kwntNiV5UlA==
X-Received: by 2002:a05:651c:1990:b0:2fa:d4ef:f234 with SMTP id 38308e7fff4ca-2fae10228c8mr36941921fa.1.1727887381546;
        Wed, 02 Oct 2024 09:43:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFT5mKidzu2rgKWaTQAOjO8wX/Bxb4NGZ38Te/mpGdwgMkg96XMmyTzKATP3+Zb3ClEjcS5uA==
X-Received: by 2002:a05:651c:1990:b0:2fa:d4ef:f234 with SMTP id 38308e7fff4ca-2fae10228c8mr36941601fa.1.1727887380801;
        Wed, 02 Oct 2024 09:43:00 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-231.retail.telecomitalia.it. [79.46.200.231])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c27c70fesm882025966b.57.2024.10.02.09.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 09:43:00 -0700 (PDT)
Date: Wed, 2 Oct 2024 18:42:56 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Luigi Leonardi <luigi.leonardi@outlook.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Marco Pinna <marco.pinn95@gmail.com>, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Message-ID: <rnehgb4kcntzebpzgpofhavo2la5eqjek3ej4gjm6tl5fb55wp@l4vroereu5ws>
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
 <jfajjomq7wla2gf2cf2zwzyslxmnnrkxn6kvewwkexqwig52b4@fwh5mtjcdile>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <jfajjomq7wla2gf2cf2zwzyslxmnnrkxn6kvewwkexqwig52b4@fwh5mtjcdile>

On Wed, Oct 02, 2024 at 04:02:06PM GMT, Stefano Garzarella wrote:
>On Wed, Oct 02, 2024 at 09:41:42AM GMT, Michael S. Tsirkin wrote:
>>virtio_transport_send_pkt in now called on transport fast path,
>>under RCU read lock. In that case, we have a bug: virtio_add_sgs
>>is called with GFP_KERNEL, and might sleep.
>>
>>Pass the gfp flags as an argument, and use GFP_ATOMIC on
>>the fast path.
>>
>>Link: https://lore.kernel.org/all/hfcr2aget2zojmqpr4uhlzvnep4vgskblx5b6xf2ddosbsrke7@nt34bxgp7j2x
>>Fixes: efcd71af38be ("vsock/virtio: avoid queuing packets when intermediate queue is empty")
>>Reported-by: Christian Brauner <brauner@kernel.org>
>>Cc: Stefano Garzarella <sgarzare@redhat.com>
>>Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
>>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>---
>>
>>Lightly tested. Christian, could you pls confirm this fixes the problem
>>for you? Stefano, it's a holiday here - could you pls help test!
>
>Sure, thanks for the quick fix! I was thinking something similar ;-)
>
>>Thanks!
>>
>>
>>net/vmw_vsock/virtio_transport.c | 8 ++++----
>>1 file changed, 4 insertions(+), 4 deletions(-)
>>
>>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>index f992f9a216f0..0cd965f24609 100644
>>--- a/net/vmw_vsock/virtio_transport.c
>>+++ b/net/vmw_vsock/virtio_transport.c
>>@@ -96,7 +96,7 @@ static u32 virtio_transport_get_local_cid(void)
>>
>>/* Caller need to hold vsock->tx_lock on vq */
>>static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
>>-				     struct virtio_vsock *vsock)
>>+				     struct virtio_vsock *vsock, gfp_t gfp)
>>{
>>	int ret, in_sg = 0, out_sg = 0;
>>	struct scatterlist **sgs;
>>@@ -140,7 +140,7 @@ static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
>>		}
>>	}
>>
>>-	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>>+	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, gfp);
>>	/* Usually this means that there is no more space available in
>>	 * the vq
>>	 */
>>@@ -178,7 +178,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>
>>		reply = virtio_vsock_skb_reply(skb);
>>
>>-		ret = virtio_transport_send_skb(skb, vq, vsock);
>>+		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
>>		if (ret < 0) {
>>			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, 
>>			skb);
>>			break;
>>@@ -221,7 +221,7 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
>>	if (unlikely(ret == 0))
>>		return -EBUSY;
>>
>>-	ret = virtio_transport_send_skb(skb, vq, vsock);
>
>nit: maybe we can add a comment here:
>        /* GFP_ATOMIC because we are in RCU section, so we can't sleep */
>>+	ret = virtio_transport_send_skb(skb, vq, vsock, GFP_ATOMIC);
>>	if (ret == 0)
>>		virtqueue_kick(vq);
>>
>>-- 
>>MST
>>
>
>I'll run some tests and come back with R-b when it's done.

I replicated the issue enabling CONFIG_DEBUG_ATOMIC_SLEEP.

With that enabled, as soon as I run iperf-vsock, dmesg is flooded with 
those messages. With this patch applied instead everything is fine.

I also ran the usual tests with various debugging options enabled and 
everything seems okay.

With or without adding the comment I suggested in the previous email:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


