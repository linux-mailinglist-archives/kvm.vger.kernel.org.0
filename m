Return-Path: <kvm+bounces-42554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CEFDA79E25
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 10:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AEAB1892C36
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8683B24291E;
	Thu,  3 Apr 2025 08:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+XA+igo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF75241672
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 08:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743668835; cv=none; b=g2zsPdxyJS2Nb1Ko5DU2bW0lRlyoQSKw7fyWMscAvGpKoMuv1d4+CxZvtyXEHQs0zhiJo1y4Jc9ofITbMQ9EWUsBAy+Svzb57Uv3J5+L7ZA4je3FhnoMMdP0bJtWKDVE3aJxlXdDQk1IRGk3IfqN+PFocA+vQY8LmeHrWdCba1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743668835; c=relaxed/simple;
	bh=mBEnZJfbHssNSwDuQ4ZoDefTpQJ0psPNYc+XIeueAiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXINlG6BWHwvo+RmOPKgWwfkJ+vWTUhqRT/uSHL3UHmXAIE8T8vW4eIVV7G3MRMeMpLRdrbWJPaqKd74OcSR+ymQczUhu7p+2mp5qGboCnN0hPmcDlPrIv9x0XKdUhdjwredOqdrnj0AykPr/OenHGAiJl58UemAWkL7oCk3nfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I+XA+igo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743668831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8H3/cfOpLLMF7vHGtp8a2sFO6dkZAsrx2IPt+e+ewfY=;
	b=I+XA+igoaZibTp6iKCIujc4ZP5GT5kZLZqcrCop2QpTtXf9aa0j22TvRYFpV+5y7m+1plY
	GCaeqf0ryCn9fjR2soUX7Y2SeZOz8HtMQ7GylKMGrVMh7Vdn8oeH7VUfn5jPy184GObQyM
	xCkOYE9H4znKFCPUUzwlYtP3x2sdndk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-jnkbpDRnNCGuLeJ7Mam38w-1; Thu, 03 Apr 2025 04:27:10 -0400
X-MC-Unique: jnkbpDRnNCGuLeJ7Mam38w-1
X-Mimecast-MFC-AGG-ID: jnkbpDRnNCGuLeJ7Mam38w_1743668829
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912fe32b08so390481f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 01:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743668829; x=1744273629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8H3/cfOpLLMF7vHGtp8a2sFO6dkZAsrx2IPt+e+ewfY=;
        b=cA0K37kFcRI6QpZgFX19w2wpfcWCo43kLCFDLcK4Rst/r36uhizmWw6eOfEtsSEXdO
         W6rvHgrnKdxv1mJblo95xsC0kcPdn8M7EkjkZ2q6QxSqRxqHyMfsG3+2x+ofjHIxtpt5
         sPOuv+bo9YDWO8fBdpgjr9RGUrbO0wSxb+Z2l/n/9TFzCKt418EDTts3VMhW/MUhYEu7
         xwgG9TYeUfuEG5ozkSVD8nmeDrAWqfgSxwhVYXWKCPvS30TwyNucbcS0owwFCdSkHgk0
         x2177AgASki+EBGPuYrhpurhhzSRSY19s8cqRweYyNaT1ryo+PiSaaKLQG0X7B8KnmjT
         T4Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUABfyrDWansO9juhyfen+kjrl/BIcfC7niS00/3CJpORxi8WW359DAh0OlVfxovfUfl8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJlCDF64Z1wVTV3JF2+M3cuzErsKQXAsGYKQVbyRrRhb24s9gP
	ZpWEPaDEIl/KlBx+aWPY0rPYz/oYIQt+Iu3ZEPGnfIAskJ6B1m8JN1s5MiD91pB8gsyt/QFll7h
	WIBQjzihPqTp9k90UncWcvhOXP0i0f69zRu0naoR0sR0+YMCBcA==
X-Gm-Gg: ASbGncujGKjwDit9A8TM3i7ga/U4xbioELj33KGDtxer4NiafYUQUPdKXUcA6QOuGsH
	2kvyRBa5KRxS1ptdxl2Kxe3ac4A87CyisOJ/TaIKR0okKmFsgtNKts7EOlpwvxL70xm+K2hiav4
	4ob1LQZlwSplGtSZ9g+KshtUNAMUVDs7PbmkPCqjkV2V3a1HgEvJttrtlyBT+JaOa9/R2XLqos/
	mVxWdaLreTS9YHj/9ZanvAWmHfLkHIsonhrW7Io3Dp2LwLiTmP9CsulQsXrMvyUWKZv1MgNfyUK
	4AuNQRSDBnr3UuqHGWZSH1wb7ZDLDkg/UvjHsYY536QSz5ojnhGttvHZLL4=
X-Received: by 2002:a05:6000:1787:b0:38d:badf:9df5 with SMTP id ffacd0b85a97d-39c2975344dmr5198685f8f.17.1743668829068;
        Thu, 03 Apr 2025 01:27:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkJasUVCkOzYkOOW0hF0pl3+LvSOwHmjYa1Gj63xQYPYwtDCufaqDLic/I99b7VKxwX6pLBg==
X-Received: by 2002:a05:6000:1787:b0:38d:badf:9df5 with SMTP id ffacd0b85a97d-39c2975344dmr5198641f8f.17.1743668828602;
        Thu, 03 Apr 2025 01:27:08 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-59.retail.telecomitalia.it. [87.11.6.59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec364ce6esm11031055e9.30.2025.04.03.01.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 01:27:07 -0700 (PDT)
Date: Thu, 3 Apr 2025 10:27:03 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	Asias He <asias@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>, 
	nh-open-source@amazon.com, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v3] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <qmhbvdned3ozt366ndshqkrc4p3d22wuo5obpziuaj5oqfwvw7@4cxvxilmt4du>
References: <20250402150646.42855-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250402150646.42855-1-graf@amazon.com>

On Wed, Apr 02, 2025 at 03:06:46PM +0000, Alexander Graf wrote:
>Ever since the introduction of the virtio vsock driver, it included
>pushback logic that blocks it from taking any new RX packets until the
>TX queue backlog becomes shallower than the virtqueue size.
>
>This logic works fine when you connect a user space application on the
>hypervisor with a virtio-vsock target, because the guest will stop
>receiving data until the host pulled all outstanding data from the VM.
>
>With Nitro Enclaves however, we connect 2 VMs directly via vsock:
>
>  Parent      Enclave
>
>    RX -------- TX
>    TX -------- RX
>
>This means we now have 2 virtio-vsock backends that both have the pushback
>logic. If the parent's TX queue runs full at the same time as the
>Enclave's, both virtio-vsock drivers fall into the pushback path and
>no longer accept RX traffic. However, that RX traffic is TX traffic on
>the other side which blocks that driver from making any forward
>progress. We're now in a deadlock.
>
>To resolve this, let's remove that pushback logic altogether and rely on
>higher levels (like credits) to ensure we do not consume unbounded
>memory.
>
>RX and TX queues share the same work queue. To prevent starvation of TX
>by an RX flood and vice versa now that the pushback logic is gone, let's
>deliberately reschedule RX and TX work after a fixed threshold (256) of
>packets to process.
>
>Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>Signed-off-by: Alexander Graf <graf@amazon.com>

There is a good point from Stefan on v2:
https://lore.kernel.org/virtualization/20250402161424.GA305204@fedora/

So, I'm not sure we can merge this as it is.

Thanks,
Stefano

>
>---
>
>v1 -> v2:
>
>  - Rework to use fixed threshold
>
>v2 -> v3:
>
>  - Remove superfluous reply variable
>---
> net/vmw_vsock/virtio_transport.c | 73 +++++++++-----------------------
> 1 file changed, 19 insertions(+), 54 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index f0e48e6911fc..6ae30bf8c85c 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -26,6 +26,12 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
> static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> static struct virtio_transport virtio_transport; /* forward declaration */
>
>+/*
>+ * Max number of RX packets transferred before requeueing so we do
>+ * not starve TX traffic because they share the same work queue.
>+ */
>+#define VSOCK_MAX_PKTS_PER_WORK 256
>+
> struct virtio_vsock {
> 	struct virtio_device *vdev;
> 	struct virtqueue *vqs[VSOCK_VQ_MAX];
>@@ -44,8 +50,6 @@ struct virtio_vsock {
> 	struct work_struct send_pkt_work;
> 	struct sk_buff_head send_pkt_queue;
>
>-	atomic_t queued_replies;
>-
> 	/* The following fields are protected by rx_lock.  vqs[VSOCK_VQ_RX]
> 	 * must be accessed with rx_lock held.
> 	 */
>@@ -158,7 +162,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 		container_of(work, struct virtio_vsock, send_pkt_work);
> 	struct virtqueue *vq;
> 	bool added = false;
>-	bool restart_rx = false;
>+	int pkts = 0;
>
> 	mutex_lock(&vsock->tx_lock);
>
>@@ -169,32 +173,24 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 	for (;;) {
> 		struct sk_buff *skb;
>-		bool reply;
> 		int ret;
>
>+		if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
>+			/* Allow other works on the same queue to run */
>+			queue_work(virtio_vsock_workqueue, work);
>+			break;
>+		}
>+
> 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
> 		if (!skb)
> 			break;
>
>-		reply = virtio_vsock_skb_reply(skb);
>-
> 		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
> 		if (ret < 0) {
> 			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 			break;
> 		}
>
>-		if (reply) {
>-			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
>-			int val;
>-
>-			val = atomic_dec_return(&vsock->queued_replies);
>-
>-			/* Do we now have resources to resume rx processing? */
>-			if (val + 1 == virtqueue_get_vring_size(rx_vq))
>-				restart_rx = true;
>-		}
>-
> 		added = true;
> 	}
>
>@@ -203,9 +199,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> out:
> 	mutex_unlock(&vsock->tx_lock);
>-
>-	if (restart_rx)
>-		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
> /* Caller need to hold RCU for vsock.
>@@ -261,9 +254,6 @@ virtio_transport_send_pkt(struct sk_buff *skb)
> 	 */
> 	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
> 	    virtio_transport_send_skb_fast_path(vsock, skb)) {
>-		if (virtio_vsock_skb_reply(skb))
>-			atomic_inc(&vsock->queued_replies);
>-
> 		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
> 		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
> 	}
>@@ -277,7 +267,7 @@ static int
> virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock *vsock;
>-	int cnt = 0, ret;
>+	int ret;
>
> 	rcu_read_lock();
> 	vsock = rcu_dereference(the_virtio_vsock);
>@@ -286,17 +276,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> 		goto out_rcu;
> 	}
>
>-	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>-
>-	if (cnt) {
>-		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
>-		int new_cnt;
>-
>-		new_cnt = atomic_sub_return(cnt, &vsock->queued_replies);
>-		if (new_cnt + cnt >= virtqueue_get_vring_size(rx_vq) &&
>-		    new_cnt < virtqueue_get_vring_size(rx_vq))
>-			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>-	}
>+	virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>
> 	ret = 0;
>
>@@ -367,18 +347,6 @@ static void virtio_transport_tx_work(struct work_struct *work)
> 		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
> }
>
>-/* Is there space left for replies to rx packets? */
>-static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
>-{
>-	struct virtqueue *vq = vsock->vqs[VSOCK_VQ_RX];
>-	int val;
>-
>-	smp_rmb(); /* paired with atomic_inc() and atomic_dec_return() */
>-	val = atomic_read(&vsock->queued_replies);
>-
>-	return val < virtqueue_get_vring_size(vq);
>-}
>-
> /* event_lock must be held */
> static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
> 				       struct virtio_vsock_event *event)
>@@ -613,6 +581,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
> 	struct virtio_vsock *vsock =
> 		container_of(work, struct virtio_vsock, rx_work);
> 	struct virtqueue *vq;
>+	int pkts = 0;
>
> 	vq = vsock->vqs[VSOCK_VQ_RX];
>
>@@ -627,11 +596,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
> 			struct sk_buff *skb;
> 			unsigned int len;
>
>-			if (!virtio_transport_more_replies(vsock)) {
>-				/* Stop rx until the device processes already
>-				 * pending replies.  Leave rx virtqueue
>-				 * callbacks disabled.
>-				 */
>+			if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
>+				/* Allow other works on the same queue to run */
>+				queue_work(virtio_vsock_workqueue, work);
> 				goto out;
> 			}
>
>@@ -675,8 +642,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> 	vsock->rx_buf_max_nr = 0;
> 	mutex_unlock(&vsock->rx_lock);
>
>-	atomic_set(&vsock->queued_replies, 0);
>-
> 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
> 	if (ret < 0)
> 		return ret;
>-- 
>2.47.1
>
>


