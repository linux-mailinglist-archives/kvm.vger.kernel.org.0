Return-Path: <kvm+bounces-42553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8666FA79E14
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 10:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3347188AA0B
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D8224293D;
	Thu,  3 Apr 2025 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SmxcnBwz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6CB2417EE
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 08:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743668684; cv=none; b=cj4Pm6VwqSeCMFUUJ6S1mOSWyZ7sjSciJeo85jcco+GjkDl8rsSY81s1iFCqlyL8mIJX2xOxwYPkJ09vnxOl2wd0mmthF1nkYRvJKGZ0OBQTa3wxkk9X12KukWCoi4NgOUX1gNKLXK3//NXfvJTk8OLWKxLoucccE+1nOSe6tYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743668684; c=relaxed/simple;
	bh=bqXLdyehYUYa7iugMoNsDrU5wqyxF2kAUPh12MXOU8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqLCvlXwn6kpBVbWBMzmyGPxAVPviKeszkuqgErgwGy8XTjehB/36G03U3pLSjSXQx+UlfDfshPTB/JB0EfUs9qmyWAP0mzGiReNI1YBQb+ByM4gKzQvRc//DonSPlk4kczp/Tt2T6Xd/nShowpYkhL2PqIc7vmv1p0TBgy0GHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SmxcnBwz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743668681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4QfRiYe5GXVmwZ4tJaWZHVzY2m09t34SISzB5r0Dv9k=;
	b=SmxcnBwzkJTcon0DoC3FPQkPekcgxkGYKY1uQepu69cjsJZLRwPQOuqBkfUZtQWf1BGT0x
	NjwpkDhhcUWX9JEFwWxWRvuzE4NhaS53KsbSj1Ce4W3Uim1tov0VU0R4LJmI0QiRWsEkzk
	16Kc3AtNiy9dS2Bf6Rx0dAFcvSfxHVw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-HP9aUZfRM7GxXcL17WXGcg-1; Thu, 03 Apr 2025 04:24:37 -0400
X-MC-Unique: HP9aUZfRM7GxXcL17WXGcg-1
X-Mimecast-MFC-AGG-ID: HP9aUZfRM7GxXcL17WXGcg_1743668677
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-39abdadb0f0so370848f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 01:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743668677; x=1744273477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QfRiYe5GXVmwZ4tJaWZHVzY2m09t34SISzB5r0Dv9k=;
        b=JEqyQmm033Br1UlMruCF6RGQa25t78S55I5M1K8loDGd9xOnz3IDhZ0W6UCMurWGkY
         m8e7dYcXd9Ox1zgFxjitwP9z3d0c7cUVudy5D0JsCNpLFal9nUQDlkm6KCoHYa76CHpR
         p+Iy0OMVrIz5fuUHzlYaqZiva+0KkWg5mR/BhkZ6B3y4zrjtjeNHWUuH/UBAYSxttIlH
         uuaSRxNxAgARdSzy/Z7T+NI+aY8uoYVgUGUH0zPSv843rRDGL6iCf5tyRFejC9G1dnM8
         nXOiGoNwC08m+AfJeN0ptQxh4XPnrZEfLla9T1hKODPNT8LOFFTZwagnMW4PFncQ6GLt
         LarQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeaLSwS+Y0e8kE/yb/LFoSfhkile0EbfT69PIC1QvEajCgRbAzOrOxYtSdMDTl+Dpu/iY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVa/xj0NBoJwpZyOs4XQkf+DuipZv4kpcbWhiq+I/VRVfR07uc
	hclKuGJRJCQ6Oppz9nU6jKUScbe/rRg2iNbvxwQ9FYcANeHT0eJQuhCAii5Ig57Gwbv+g1BEFv2
	V9oa5i92fwfOU1rH7gx6/swzehR2rwzWN5cH9pnnOhJb6ef3RsQ==
X-Gm-Gg: ASbGnctqWgFQ9EmKEhej7/OG4c7zFYKz+xa9P6HBWfnByeQrOyJsN3aUfpnPRMKnsgm
	G6XA78BA16D26L/8HN5Gn2KvwhG2DIdw5huxj9P4Xbk3RfIihUNFkewIrODQZKA3Q23ocSrlZ6o
	6XhapC3IdvU5lsP1b3Qdrfh7PIb/Wl2v7JHXwuNe8C+SiS81P4eIV1vN0V8OIa6eEUe++cQ5ZxE
	SQospchMRfYxyiF2wn21tMtzHuL6Xxx7nF/wcJYZSxKcaL9U8UIBxJkqKCJLiP7K2p7ACRAuvlz
	KAWgiQnUaw7wE1bxxK5Ho/UFOBEuIH3xkKamC92Krsrc2S/Su6wc02CrjdU=
X-Received: by 2002:a05:6000:4383:b0:39c:1404:312f with SMTP id ffacd0b85a97d-39c2f8c6371mr1428515f8f.1.1743668676619;
        Thu, 03 Apr 2025 01:24:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEAZGAoNM13vK521/2jz+2sSbIX6WGto477kdtw5LD+g4dYvVQaOt1ETkS34SAS4HIRNgFdw==
X-Received: by 2002:a05:6000:4383:b0:39c:1404:312f with SMTP id ffacd0b85a97d-39c2f8c6371mr1428477f8f.1.1743668676004;
        Thu, 03 Apr 2025 01:24:36 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-59.retail.telecomitalia.it. [87.11.6.59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec163107csm14698525e9.3.2025.04.03.01.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 01:24:35 -0700 (PDT)
Date: Thu, 3 Apr 2025 10:24:30 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
	Alexander Graf <graf@amazon.com>, "Michael S . Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	"David S . Miller" <davem@davemloft.net>, nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <5l2xvaamvvoayrz3vlof4rarp5hkeig5sljhsqzypo6xx4fcip@3bhjnwe5g7ha>
References: <20250401201349.23867-1-graf@amazon.com>
 <20250402161424.GA305204@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250402161424.GA305204@fedora>

On Wed, Apr 02, 2025 at 12:14:24PM -0400, Stefan Hajnoczi wrote:
>On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
>> Ever since the introduction of the virtio vsock driver, it included
>> pushback logic that blocks it from taking any new RX packets until the
>> TX queue backlog becomes shallower than the virtqueue size.
>>
>> This logic works fine when you connect a user space application on the
>> hypervisor with a virtio-vsock target, because the guest will stop
>> receiving data until the host pulled all outstanding data from the VM.
>>
>> With Nitro Enclaves however, we connect 2 VMs directly via vsock:
>>
>>   Parent      Enclave
>>
>>     RX -------- TX
>>     TX -------- RX
>>
>> This means we now have 2 virtio-vsock backends that both have the pushback
>> logic. If the parent's TX queue runs full at the same time as the
>> Enclave's, both virtio-vsock drivers fall into the pushback path and
>> no longer accept RX traffic. However, that RX traffic is TX traffic on
>> the other side which blocks that driver from making any forward
>> progress. We're now in a deadlock.
>>
>> To resolve this, let's remove that pushback logic altogether and rely on
>> higher levels (like credits) to ensure we do not consume unbounded
>> memory.
>
>The reason for queued_replies is that rx packet processing may emit tx
>packets. Therefore tx virtqueue space is required in order to process
>the rx virtqueue.
>
>queued_replies puts a bound on the amount of tx packets that can be
>queued in memory so the other side cannot consume unlimited memory. Once
>that bound has been reached, rx processing stops until the other side
>frees up tx virtqueue space.
>
>It's been a while since I looked at this problem, so I don't have a
>solution ready. In fact, last time I thought about it I wondered if the
>design of virtio-vsock fundamentally suffers from deadlocks.
>
>I don't think removing queued_replies is possible without a replacement
>for the bounded memory and virtqueue exhaustion issue though. Credits
>are not a solution - they are about socket buffer space, not about
>virtqueue space, which includes control packets that are not accounted
>by socket buffer space.

This is a very good point that I missed, I need to add a comment in the 
code to explain it, because it wasn't clear to me! Thank you very much 
Stefan!

So, IIUC, with this patch, a host or a sibling VM (e.g.  enclave, 
parent), can flood the VM with requests like VIRTIO_VSOCK_OP_REQUEST 
(even for example with a random port that is not open) that require a 
response. If the peer that is sending the requests, using the RX 
virtqueue, does not consume the TX virtqueue, it easily causes a 
consumption of all the memory on the other peer, which initially starts 
filling up the TX virtqueue, but when it becomes full starts using the 
internal queue indiscriminately.

I agree, if we want to get rid of queued_replies, we should find some 
other way to avoid this. So far I can't think of anything other than to 
stop the consumption of the virtqueue and wait for the other peer to 
consume the other one.

Any other ideas?

Thanks,
Stefano


>
>>
>> RX and TX queues share the same work queue. To prevent starvation of TX
>> by an RX flood and vice versa now that the pushback logic is gone, let's
>> deliberately reschedule RX and TX work after a fixed threshold (256) of
>> packets to process.
>>
>> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>> ---
>>  net/vmw_vsock/virtio_transport.c | 70 +++++++++-----------------------
>>  1 file changed, 19 insertions(+), 51 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index f0e48e6911fc..54030c729767 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -26,6 +26,12 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
>>  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>>  static struct virtio_transport virtio_transport; /* forward declaration */
>>
>> +/*
>> + * Max number of RX packets transferred before requeueing so we do
>> + * not starve TX traffic because they share the same work queue.
>> + */
>> +#define VSOCK_MAX_PKTS_PER_WORK 256
>> +
>>  struct virtio_vsock {
>>  	struct virtio_device *vdev;
>>  	struct virtqueue *vqs[VSOCK_VQ_MAX];
>> @@ -44,8 +50,6 @@ struct virtio_vsock {
>>  	struct work_struct send_pkt_work;
>>  	struct sk_buff_head send_pkt_queue;
>>
>> -	atomic_t queued_replies;
>> -
>>  	/* The following fields are protected by rx_lock.  vqs[VSOCK_VQ_RX]
>>  	 * must be accessed with rx_lock held.
>>  	 */
>> @@ -158,7 +162,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>  		container_of(work, struct virtio_vsock, send_pkt_work);
>>  	struct virtqueue *vq;
>>  	bool added = false;
>> -	bool restart_rx = false;
>> +	int pkts = 0;
>>
>>  	mutex_lock(&vsock->tx_lock);
>>
>> @@ -172,6 +176,12 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>  		bool reply;
>>  		int ret;
>>
>> +		if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
>> +			/* Allow other works on the same queue to run */
>> +			queue_work(virtio_vsock_workqueue, work);
>> +			break;
>> +		}
>> +
>>  		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
>>  		if (!skb)
>>  			break;
>> @@ -184,17 +194,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>  			break;
>>  		}
>>
>> -		if (reply) {
>> -			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
>> -			int val;
>> -
>> -			val = atomic_dec_return(&vsock->queued_replies);
>> -
>> -			/* Do we now have resources to resume rx processing? */
>> -			if (val + 1 == virtqueue_get_vring_size(rx_vq))
>> -				restart_rx = true;
>> -		}
>> -
>>  		added = true;
>>  	}
>>
>> @@ -203,9 +202,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>
>>  out:
>>  	mutex_unlock(&vsock->tx_lock);
>> -
>> -	if (restart_rx)
>> -		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>>  }
>>
>>  /* Caller need to hold RCU for vsock.
>> @@ -261,9 +257,6 @@ virtio_transport_send_pkt(struct sk_buff *skb)
>>  	 */
>>  	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
>>  	    virtio_transport_send_skb_fast_path(vsock, skb)) {
>> -		if (virtio_vsock_skb_reply(skb))
>> -			atomic_inc(&vsock->queued_replies);
>> -
>>  		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
>>  		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>>  	}
>> @@ -277,7 +270,7 @@ static int
>>  virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>>  {
>>  	struct virtio_vsock *vsock;
>> -	int cnt = 0, ret;
>> +	int ret;
>>
>>  	rcu_read_lock();
>>  	vsock = rcu_dereference(the_virtio_vsock);
>> @@ -286,17 +279,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>>  		goto out_rcu;
>>  	}
>>
>> -	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>> -
>> -	if (cnt) {
>> -		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
>> -		int new_cnt;
>> -
>> -		new_cnt = atomic_sub_return(cnt, &vsock->queued_replies);
>> -		if (new_cnt + cnt >= virtqueue_get_vring_size(rx_vq) &&
>> -		    new_cnt < virtqueue_get_vring_size(rx_vq))
>> -			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>> -	}
>> +	virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>>
>>  	ret = 0;
>>
>> @@ -367,18 +350,6 @@ static void virtio_transport_tx_work(struct work_struct *work)
>>  		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>>  }
>>
>> -/* Is there space left for replies to rx packets? */
>> -static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
>> -{
>> -	struct virtqueue *vq = vsock->vqs[VSOCK_VQ_RX];
>> -	int val;
>> -
>> -	smp_rmb(); /* paired with atomic_inc() and atomic_dec_return() */
>> -	val = atomic_read(&vsock->queued_replies);
>> -
>> -	return val < virtqueue_get_vring_size(vq);
>> -}
>> -
>>  /* event_lock must be held */
>>  static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
>>  				       struct virtio_vsock_event *event)
>> @@ -613,6 +584,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
>>  	struct virtio_vsock *vsock =
>>  		container_of(work, struct virtio_vsock, rx_work);
>>  	struct virtqueue *vq;
>> +	int pkts = 0;
>>
>>  	vq = vsock->vqs[VSOCK_VQ_RX];
>>
>> @@ -627,11 +599,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
>>  			struct sk_buff *skb;
>>  			unsigned int len;
>>
>> -			if (!virtio_transport_more_replies(vsock)) {
>> -				/* Stop rx until the device processes already
>> -				 * pending replies.  Leave rx virtqueue
>> -				 * callbacks disabled.
>> -				 */
>> +			if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
>> +				/* Allow other works on the same queue to run */
>> +				queue_work(virtio_vsock_workqueue, work);
>>  				goto out;
>>  			}
>>
>> @@ -675,8 +645,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>  	vsock->rx_buf_max_nr = 0;
>>  	mutex_unlock(&vsock->rx_lock);
>>
>> -	atomic_set(&vsock->queued_replies, 0);
>> -
>>  	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
>>  	if (ret < 0)
>>  		return ret;
>> --
>> 2.47.1
>>



