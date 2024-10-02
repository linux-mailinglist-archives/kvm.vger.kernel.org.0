Return-Path: <kvm+bounces-27800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9985098D903
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9D35B2170D
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EEE71D0DF5;
	Wed,  2 Oct 2024 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKOLNm7X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FA81D07B2
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877741; cv=none; b=EZ/JVvEGsihii4QABuhf0mgBVyI3jWyeDsOEs19L06iDmZnjovWMzcd6EH8Qc5KjMIF+0agHQBj7zerW1tLlfGEh4DiUilwqvHQDT8LNOF0ZkUEAe3w9Z8qWHHDroys/apyAisW6W/LBJZFBGJ1CzUynXflaurMFKM+tE5oX6yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877741; c=relaxed/simple;
	bh=Frk2jjcDRjJQq7k8VaiE06LgSr0fC3zHmucqxnAwl2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2GQmDRIbBoEN+bWAv5E23EhdNi0nEytHWVtfOAxtK9oM2oVPHPfvLQ7pAWlJTz79W84MKJK5vF2TZQqrK/LGcpehNIbVzNAxjOlnHtAWoXA7JXxVV9HfZIoY9J/zCdeKNbdXYCyxUtAt4n27KiYfHryvR/70Q9NJj24aXoQB+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKOLNm7X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727877738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkyE5n67+2FhEmvlc1Gz1kCYfCQ3DT7+FsW83fvB9to=;
	b=UKOLNm7XQthxqycj0I6AbmEgGlzsBf/GwWRZ8REgThyRuxrm/U4dtcjTe/fXbGkkrBhvS2
	/oi3cUD0ynyZYG5Wxp8w4Luoc9whR33JFlVQf+TnzrjEp/tCSQ4AAa6IBZFcX1Qj/j0zQz
	+/KuQrmLQ5WMNbLm/6BPM/EbR4EfjdU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-qpKnbh8-OPatDKgd2qHkBw-1; Wed, 02 Oct 2024 10:02:15 -0400
X-MC-Unique: qpKnbh8-OPatDKgd2qHkBw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a8a7463c3d0so33354966b.2
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 07:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727877733; x=1728482533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkyE5n67+2FhEmvlc1Gz1kCYfCQ3DT7+FsW83fvB9to=;
        b=GE/IEP35yE1mxiBVe1OTsDjHtjdVgksw3h1GQFBpFmOk7WFbu+H3EkjLffCjoZgz9R
         1CfXxnzwHeSZx8geaTikMzI9RrkpFUtQ3hMTvFyieKSXFMHAMX5dXyDwnm65MQMmOxhd
         GlKks93tsbSsr3whI92kyMiqVFERXyr4gtH4e3MNss+lx1wzKYM/ngL+lffZ4/sLayBp
         1BwsNWvYFWLAsCv9gk9qSDJgeIrtDWfqYrFyfcqEspkkBBmacGV4eodVW8KiUGZfn8lG
         wFAPbKwzgNanPNVr/WqiuBMmxFFmkpkCCKWQ8U/H/LDC4Ka9ZBcelYzqJ9fd9KMLSjj3
         gQPg==
X-Forwarded-Encrypted: i=1; AJvYcCVkuyzOqvwAnLCIaeL8cV5lxV+OX39+VOblKyOr2kGY0Y1H7Yf/iWJ/5IyT/IzQcHgseKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZEc9kKS6ryzbggs5IyhpLO0fUDH7xoJpktBHSLSsIExGHhqe4
	n6Irg7p1rP/MFzIGV9qoFYHqgk7lSGmw79LY0LfInVS61pimASJh9CI3u/y1lG30U3AyvTeD+lm
	N13L8A1Sc9nWmyanAqbrlV4xx2owWI/UDE9lwJXYKD2m//+Ed2A==
X-Received: by 2002:a17:907:7ba1:b0:a7d:e956:ad51 with SMTP id a640c23a62f3a-a98f82450b8mr290196466b.21.1727877732691;
        Wed, 02 Oct 2024 07:02:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGelE8fxwK/xwgNE2Rv74byuFA2F7hxuFV/ZEUjU6Gi3oxGwmQvv3Bi4arRb61wV4RR9t3zOw==
X-Received: by 2002:a17:907:7ba1:b0:a7d:e956:ad51 with SMTP id a640c23a62f3a-a98f82450b8mr290190266b.21.1727877731869;
        Wed, 02 Oct 2024 07:02:11 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-231.retail.telecomitalia.it. [79.46.200.231])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c299aca5sm873146366b.224.2024.10.02.07.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 07:02:11 -0700 (PDT)
Date: Wed, 2 Oct 2024 16:02:06 +0200
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
Message-ID: <jfajjomq7wla2gf2cf2zwzyslxmnnrkxn6kvewwkexqwig52b4@fwh5mtjcdile>
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>

On Wed, Oct 02, 2024 at 09:41:42AM GMT, Michael S. Tsirkin wrote:
>virtio_transport_send_pkt in now called on transport fast path,
>under RCU read lock. In that case, we have a bug: virtio_add_sgs
>is called with GFP_KERNEL, and might sleep.
>
>Pass the gfp flags as an argument, and use GFP_ATOMIC on
>the fast path.
>
>Link: https://lore.kernel.org/all/hfcr2aget2zojmqpr4uhlzvnep4vgskblx5b6xf2ddosbsrke7@nt34bxgp7j2x
>Fixes: efcd71af38be ("vsock/virtio: avoid queuing packets when intermediate queue is empty")
>Reported-by: Christian Brauner <brauner@kernel.org>
>Cc: Stefano Garzarella <sgarzare@redhat.com>
>Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
>
>Lightly tested. Christian, could you pls confirm this fixes the problem
>for you? Stefano, it's a holiday here - could you pls help test!

Sure, thanks for the quick fix! I was thinking something similar ;-)

>Thanks!
>
>
> net/vmw_vsock/virtio_transport.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index f992f9a216f0..0cd965f24609 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -96,7 +96,7 @@ static u32 virtio_transport_get_local_cid(void)
>
> /* Caller need to hold vsock->tx_lock on vq */
> static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
>-				     struct virtio_vsock *vsock)
>+				     struct virtio_vsock *vsock, gfp_t gfp)
> {
> 	int ret, in_sg = 0, out_sg = 0;
> 	struct scatterlist **sgs;
>@@ -140,7 +140,7 @@ static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
> 		}
> 	}
>
>-	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>+	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, gfp);
> 	/* Usually this means that there is no more space available in
> 	 * the vq
> 	 */
>@@ -178,7 +178,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 		reply = virtio_vsock_skb_reply(skb);
>
>-		ret = virtio_transport_send_skb(skb, vq, vsock);
>+		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
> 		if (ret < 0) {
> 			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 			break;
>@@ -221,7 +221,7 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
> 	if (unlikely(ret == 0))
> 		return -EBUSY;
>
>-	ret = virtio_transport_send_skb(skb, vq, vsock);

nit: maybe we can add a comment here:
         /* GFP_ATOMIC because we are in RCU section, so we can't sleep */
>+	ret = virtio_transport_send_skb(skb, vq, vsock, GFP_ATOMIC);
> 	if (ret == 0)
> 		virtqueue_kick(vq);
>
>-- 
>MST
>

I'll run some tests and come back with R-b when it's done.

Thanks,
Stefano


