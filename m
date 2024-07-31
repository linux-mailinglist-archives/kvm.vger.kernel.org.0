Return-Path: <kvm+bounces-22733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F7A94283C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 652171F23317
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401391A76CD;
	Wed, 31 Jul 2024 07:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Os4iKP1g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD618DF63
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 07:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722411602; cv=none; b=EgUp8YDHnxxCMEAjhxjiWy4hXYWLuXO/GnjP9cmNF5a+6OWLrHnsya1zaYVjNR1eMu3SRE0xwqjzcsApNLRvu1SV2rWYu98PrDmbx0XR+Qdc0hTZO7PgNG352rKOJNinDMVOOvVbZV9TTdpkWLo4kviRKVLfqnYEbHc4dxgJbXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722411602; c=relaxed/simple;
	bh=BaxCt27OZsHcMWoUAgXJmK2Vffoa7dbbJn3AJYpv87s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkWvPDJlxkTd1KHMNBAN38NDjh56HPJzHp9uFhPNidaht4+LeH+UTgYYZhADpt+a2YuEFTM8T6R1zLUw532AJh3HomG7kOdzEc1KHM73JGu0aN8c06hw0NmGId/b58iWIMRX+fMisRPCaKeRsSA7V+HH4Mz/Hq+7p3XGA2zVeRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Os4iKP1g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722411599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHg5YCh5BA7hqCWyo1rRiqsfxT+DXFPGHFeuupOZS4M=;
	b=Os4iKP1gn/oyHQ8epkSQxIviDxyGHuRfWC3KPIMwEckq+jWRMWcAZMgbt2NIzrxHSvZoxB
	Kgm/fb5P2mgTcHRd9/8pws8FfB3Eb16voGYE1zsB8JyXlygeNH0lwLWcdV66WV1ot1qI6E
	G2oEO/sVnGIMOoiPtci5TmYCZHIYeBs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-7UZ6Jc-qPHe4jQnz1Fl83w-1; Wed, 31 Jul 2024 03:39:58 -0400
X-MC-Unique: 7UZ6Jc-qPHe4jQnz1Fl83w-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ef311ad4bcso54106771fa.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 00:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722411596; x=1723016396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHg5YCh5BA7hqCWyo1rRiqsfxT+DXFPGHFeuupOZS4M=;
        b=cnT/0pAjPyCMLvwoiwZJD9n38kpRHNuBcJplWPaFD3goqsXx/eM/9s2GzB62ucLPBO
         lORywyHNTnz52x4B004+xBkqdUgRFSqrPi//lL0PXwumn+B6UZzdZlmbj92txqufDu24
         ksn9KaG+KE/tbTY/6KbvISb7yevmMhuABpedZrS4Z8tsePeTGP8dk45GcnEdq8iTIrBL
         jD1SNK9RNXXyHtUtOt3o87Qh/ahxNWM98t26BDc+jp9RINWmsPekI5NHJlqdHUNXrR62
         qNfJxEE8XcZSwObWSCC55yccfyVhBH4EKt3abJ9QEGkB1wto1gAFY2JnYX1WjtLopsRS
         iMkA==
X-Forwarded-Encrypted: i=1; AJvYcCVF56HRfESRTOCIP78crsmjLu74LSFadfJnv9gDJVhQchOMRANwiAmtYFaBEtSkavi5Vkd9jPcKWpB6KVbIzJEKHzWZ
X-Gm-Message-State: AOJu0YybH4rC5zmowSTHfdvGKW9iOU0PklCZyfm6Pe3QPlVvd4TNJZgm
	DigN2pHC9SVCMDJY8PzIImJfI5HC9abI7FI4Ir2SdSpPjsCrts3jyLdi2WZOPZRJWyil/NueCzb
	3Miv6wsrQoA0Y0SGaUltZAb9miR4epwoUbtlg3q/NOxt9PLVR1Mspcb6giA==
X-Received: by 2002:a2e:9687:0:b0:2ef:23ec:9357 with SMTP id 38308e7fff4ca-2f12ea9b35bmr88693071fa.0.1722411596255;
        Wed, 31 Jul 2024 00:39:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQrkoDxw+l0VIlIR0+Qgk+955MiL63klXTLU5DFu/vj4R5NQt4RkfZvM7Q37gJtl9EWRqz2w==
X-Received: by 2002:a2e:9687:0:b0:2ef:23ec:9357 with SMTP id 38308e7fff4ca-2f12ea9b35bmr88692741fa.0.1722411595293;
        Wed, 31 Jul 2024 00:39:55 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-79.retail.telecomitalia.it. [82.57.51.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282bb6403bsm10938855e9.35.2024.07.31.00.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 00:39:54 -0700 (PDT)
Date: Wed, 31 Jul 2024 09:39:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: luigi.leonardi@outlook.com
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marco Pinna <marco.pinn95@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] vsock/virtio: avoid queuing packets when
 intermediate queue is empty
Message-ID: <yrw4u5lwsiovb36i2vhc7qtwcai2us5uoqhb5zpabfqgxp267g@nmqtvj4oqndc>
References: <20240730-pinna-v4-0-5c9179164db5@outlook.com>
 <20240730-pinna-v4-2-5c9179164db5@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240730-pinna-v4-2-5c9179164db5@outlook.com>

On Tue, Jul 30, 2024 at 09:47:32PM GMT, Luigi Leonardi via B4 Relay wrote:
>From: Luigi Leonardi <luigi.leonardi@outlook.com>
>
>When the driver needs to send new packets to the device, it always
>queues the new sk_buffs into an intermediate queue (send_pkt_queue)
>and schedules a worker (send_pkt_work) to then queue them into the
>virtqueue exposed to the device.
>
>This increases the chance of batching, but also introduces a lot of
>latency into the communication. So we can optimize this path by
>adding a fast path to be taken when there is no element in the
>intermediate queue, there is space available in the virtqueue,
>and no other process that is sending packets (tx_lock held).
>
>The following benchmarks were run to check improvements in latency and
>throughput. The test bed is a host with Intel i7-10700KF CPU @ 3.80GHz
>and L1 guest running on QEMU/KVM with vhost process and all vCPUs
>pinned individually to pCPUs.
>
>- Latency
>   Tool: Fio version 3.37-56
>   Mode: pingpong (h-g-h)
>   Test runs: 50
>   Runtime-per-test: 50s
>   Type: SOCK_STREAM
>
>In the following fio benchmark (pingpong mode) the host sends
>a payload to the guest and waits for the same payload back.
>
>fio process pinned both inside the host and the guest system.
>
>Before: Linux 6.9.8
>
>Payload 64B:
>
>	1st perc.	overall		99th perc.
>Before	12.91		16.78		42.24		us
>After	9.77		13.57		39.17		us
>
>Payload 512B:
>
>	1st perc.	overall		99th perc.
>Before	13.35		17.35		41.52		us
>After	10.25		14.11		39.58		us
>
>Payload 4K:
>
>	1st perc.	overall		99th perc.
>Before	14.71		19.87		41.52		us
>After	10.51		14.96		40.81		us
>
>- Throughput
>   Tool: iperf-vsock
>
>The size represents the buffer length (-l) to read/write
>P represents the number of parallel streams
>
>P=1
>	4K	64K	128K
>Before	6.87	29.3	29.5 Gb/s
>After	10.5	39.4	39.9 Gb/s
>
>P=2
>	4K	64K	128K
>Before	10.5	32.8	33.2 Gb/s
>After	17.8	47.7	48.5 Gb/s
>
>P=4
>	4K	64K	128K
>Before	12.7	33.6	34.2 Gb/s
>After	16.9	48.1	50.5 Gb/s

Great improvement! Thanks again for this work!

>
>The performance improvement is related to this optimization,
>I used a ebpf kretprobe on virtio_transport_send_skb to check
>that each packet was sent directly to the virtqueue
>
>Co-developed-by: Marco Pinna <marco.pinn95@gmail.com>
>Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> net/vmw_vsock/virtio_transport.c | 39 +++++++++++++++++++++++++++++++++++----
> 1 file changed, 35 insertions(+), 4 deletions(-)

All my comments have been resolved. I let iperf run bidirectionally for 
a long time and saw no problems, so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index f641e906f351..f992f9a216f0 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -208,6 +208,28 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>+/* Caller need to hold RCU for vsock.
>+ * Returns 0 if the packet is successfully put on the vq.
>+ */
>+static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struct sk_buff *skb)
>+{
>+	struct virtqueue *vq = vsock->vqs[VSOCK_VQ_TX];
>+	int ret;
>+
>+	/* Inside RCU, can't sleep! */
>+	ret = mutex_trylock(&vsock->tx_lock);
>+	if (unlikely(ret == 0))
>+		return -EBUSY;
>+
>+	ret = virtio_transport_send_skb(skb, vq, vsock);
>+	if (ret == 0)
>+		virtqueue_kick(vq);
>+
>+	mutex_unlock(&vsock->tx_lock);
>+
>+	return ret;
>+}
>+
> static int
> virtio_transport_send_pkt(struct sk_buff *skb)
> {
>@@ -231,11 +253,20 @@ virtio_transport_send_pkt(struct sk_buff *skb)
> 		goto out_rcu;
> 	}
>
>-	if (virtio_vsock_skb_reply(skb))
>-		atomic_inc(&vsock->queued_replies);
>+	/* If send_pkt_queue is empty, we can safely bypass this queue
>+	 * because packet order is maintained and (try) to put the packet
>+	 * on the virtqueue using virtio_transport_send_skb_fast_path.
>+	 * If this fails we simply put the packet on the intermediate
>+	 * queue and schedule the worker.
>+	 */
>+	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
>+	    virtio_transport_send_skb_fast_path(vsock, skb)) {
>+		if (virtio_vsock_skb_reply(skb))
>+			atomic_inc(&vsock->queued_replies);
>
>-	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
>-	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>+		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
>+		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>+	}
>
> out_rcu:
> 	rcu_read_unlock();
>
>-- 
>2.45.2
>
>


