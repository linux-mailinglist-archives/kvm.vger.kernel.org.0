Return-Path: <kvm+bounces-58620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9B7B98B4B
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 09:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0741316FBFD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F130C28643F;
	Wed, 24 Sep 2025 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ReA3fDVS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2180027FD68
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 07:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758700200; cv=none; b=b/Xy3934umjJd0MqCG9BLnp8rZp0fJsR+mSXXJIfHA+7fV00sTvIrFuF0SJ9VeAhOl4TYPpRHCPRnBOltXsoQYNL6kL0pwFIOIfkNYOSwEIEWzWJa726OedoV96Y99ayP7RrXbv5aRI5t5gImzbCOYqyA3ooUpvos1w4huUQalQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758700200; c=relaxed/simple;
	bh=uc6ISieAaXFT4aav6NNM2tVosCA7b7yxzr213CmqjSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFQK8ptmm4gceoOxfoW+pEeHmekdYPmazGSTjjwPWENL5W8YnoAMfbhZRWPjh0EdacP4+/U5LPf8Dp0E3a4HIij5KF8Q1Ftr5tiYXhFgL0YWFxP8EO+rF0PF6nmF0ii/F73JMvlgpwDhfZMjjgRpcqjlPV43C7n8XroG5g98YIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ReA3fDVS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758700197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdMx3QVWSZ6LKmjhlJB1nzhhz5UUzIgjxX638ayHrZQ=;
	b=ReA3fDVSGxGOdkK78gdIXjkthUy7FadJhc79wBkfr8ICi4BWIzMA2SWN3aez3fnc/z2vtr
	Qlc04amyz18YATgvuQbCrlQTaRguO5kFrfZvZ4kmKX5bDSNCtsJflPRG5VfUHVNoV4NUDV
	eeXFyWyw9M2JWDAeaprsruIB0ajQfEU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-WW6t0_RbPyKwAqnvGCUNuQ-1; Wed, 24 Sep 2025 03:49:55 -0400
X-MC-Unique: WW6t0_RbPyKwAqnvGCUNuQ-1
X-Mimecast-MFC-AGG-ID: WW6t0_RbPyKwAqnvGCUNuQ_1758700195
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ed9557f976so5428058f8f.3
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 00:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758700194; x=1759304994;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdMx3QVWSZ6LKmjhlJB1nzhhz5UUzIgjxX638ayHrZQ=;
        b=YEw6wx4xxLz47Xe8mwGrIebDLPR31c4suLIXx3rynPEXils6MvGGKSb0T0uoOyN0kx
         LaJ6yyZ3Q146iTW3wUTB8AGhgGSavlyTdpv3uc8BXNQIqaRJ/5D62LUO1CjuF/e/K6tD
         g79+faSVbN4KXiBzzzzvw4rjpssga6+tE9mv/INRzRyHSsw9q3tgVIJyh0kTCIOoH+M8
         uSa1IKFAELWmSttzJvPi4HlDqmzHzAuScOO0TGHlME7cWpXpvisjOYNyWq+0WZpe/CrD
         ID4ISDv7B0R9BvJrHtSHlUAsfAqf8Y4s7Woj6RVP7zi6BqSPk04D9O5YzvXH2MlmXuDF
         wvQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrF1JNYn1GprU/sbIVTrRa7bvwQ69/azYUN5CryV2g3etvIexwkeB5LZnzmXtmrBxmHec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+BZR+KS0/aUhMS+0QK+tAbqp+nHcTHgs9+PtSli4VpFugA78L
	qb5j4zJpoYxTKgM/uLZbHlNR47ktrXunhMfh2Cfnms2T78CTXvbg7p7AE5cRxa+1kuuzpLvjFOK
	LALXkIFFUYcDPauRWlv/bgtEipHJbQ3kcYQkoEZUNfzsY5aZ2g7LwoA==
X-Gm-Gg: ASbGncudpFf7rtcWNxkJZlxUfXMV6Yt6kcxSEXO98D2qa3pG5jbisOC3hKzPxSx+pNr
	4bPp/XUPBNOn254W/g3cuzEkaTOeAoFGdrdooKz4no2O0rKbSTLS1nmwikyb3Zo+bTAMZ+J+OgI
	WZG+EPNR8Kqqz7oOSPXg2JzWfoE9B0XrRPH0yBBtWxfWOhxXS+NdRPlmVpck9aI5zymTRlaG+mp
	GTT2rvfsselp8oe0I+6YoEhzCUQsPgw4zJjXKtiUgp+yzoWEbobA/s0EN1kuSYqiMJvLWBZ2Eyq
	owXDf/a9Dzi5t2J5pbqiD1Dw1DG5dC+Qrt8=
X-Received: by 2002:a05:6000:2204:b0:3e7:65a6:dbf with SMTP id ffacd0b85a97d-405c5ccc9d5mr4161803f8f.6.1758700194518;
        Wed, 24 Sep 2025 00:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAd953qSH8hZIgDHBwYLoc8FquXuXRMDSqiFyKFFPq3vdIpLOnAbvFV8zHb6qxjx8ZavCtZw==
X-Received: by 2002:a05:6000:2204:b0:3e7:65a6:dbf with SMTP id ffacd0b85a97d-405c5ccc9d5mr4161779f8f.6.1758700194045;
        Wed, 24 Sep 2025 00:49:54 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f9c62d083esm15058456f8f.32.2025.09.24.00.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 00:49:53 -0700 (PDT)
Date: Wed, 24 Sep 2025 03:49:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after
 consuming an entry
Message-ID: <20250924034534-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-5-simon.schippers@tu-dortmund.de>
 <20250923123101-mutt-send-email-mst@kernel.org>
 <aacb449c-ad20-48b0-aa0f-b3866a3ed7f6@tu-dortmund.de>
 <20250924024416-mutt-send-email-mst@kernel.org>
 <a16b643a-3cfe-4b95-b76a-100f512cdb79@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a16b643a-3cfe-4b95-b76a-100f512cdb79@tu-dortmund.de>

On Wed, Sep 24, 2025 at 09:42:45AM +0200, Simon Schippers wrote:
> On 24.09.25 08:55, Michael S. Tsirkin wrote:
> > On Wed, Sep 24, 2025 at 07:56:33AM +0200, Simon Schippers wrote:
> >> On 23.09.25 18:36, Michael S. Tsirkin wrote:
> >>> On Tue, Sep 23, 2025 at 12:15:49AM +0200, Simon Schippers wrote:
> >>>> The new wrappers tun_ring_consume/tap_ring_consume deal with consuming an
> >>>> entry of the ptr_ring and then waking the netdev queue when entries got
> >>>> invalidated to be used again by the producer.
> >>>> To avoid waking the netdev queue when the ptr_ring is full, it is checked
> >>>> if the netdev queue is stopped before invalidating entries. Like that the
> >>>> netdev queue can be safely woken after invalidating entries.
> >>>>
> >>>> The READ_ONCE in __ptr_ring_peek, paired with the smp_wmb() in
> >>>> __ptr_ring_produce within tun_net_xmit guarantees that the information
> >>>> about the netdev queue being stopped is visible after __ptr_ring_peek is
> >>>> called.
> >>>>
> >>>> The netdev queue is also woken after resizing the ptr_ring.
> >>>>
> >>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >>>> ---
> >>>>  drivers/net/tap.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
> >>>>  drivers/net/tun.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
> >>>>  2 files changed, 88 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>> index 1197f245e873..f8292721a9d6 100644
> >>>> --- a/drivers/net/tap.c
> >>>> +++ b/drivers/net/tap.c
> >>>> @@ -753,6 +753,46 @@ static ssize_t tap_put_user(struct tap_queue *q,
> >>>>  	return ret ? ret : total;
> >>>>  }
> >>>>  
> >>>> +static struct sk_buff *tap_ring_consume(struct tap_queue *q)
> >>>> +{
> >>>> +	struct netdev_queue *txq;
> >>>> +	struct net_device *dev;
> >>>> +	bool will_invalidate;
> >>>> +	bool stopped;
> >>>> +	void *ptr;
> >>>> +
> >>>> +	spin_lock(&q->ring.consumer_lock);
> >>>> +	ptr = __ptr_ring_peek(&q->ring);
> >>>> +	if (!ptr) {
> >>>> +		spin_unlock(&q->ring.consumer_lock);
> >>>> +		return ptr;
> >>>> +	}
> >>>> +
> >>>> +	/* Check if the queue stopped before zeroing out, so no ptr get
> >>>> +	 * produced in the meantime, because this could result in waking
> >>>> +	 * even though the ptr_ring is full.
> >>>
> >>> So what? Maybe it would be a bit suboptimal? But with your design, I do
> >>> not get what prevents this:
> >>>
> >>>
> >>> 	stopped? -> No
> >>> 		ring is stopped
> >>> 	discard
> >>>
> >>> and queue stays stopped forever
> >>>
> >>>
> >>
> >> I totally missed this (but I am not sure why it did not happen in my 
> >> testing with different ptr_ring sizes..).
> >>
> >> I guess you are right, there must be some type of locking.
> >> It probably makes sense to lock the netdev txq->_xmit_lock whenever the 
> >> consumer invalidates old ptr_ring entries (so when r->consumer_head >= 
> >> r->consumer_tail). The producer holds this lock with dev->lltx=false. Then 
> >> the consumer is able to wake the queue safely.
> >>
> >> So I would now just change the implementation to:
> >> tun_net_xmit:
> >> ...
> >> if ptr_ring_produce
> >>     // Could happen because of unproduce in vhost_net..
> >>     netif_tx_stop_queue
> >>     ...
> >>     goto drop
> >>
> >> if ptr_ring_full
> >>     netif_tx_stop_queue
> >> ...
> >>
> >> tun_ring_recv/tap_do_read (the implementation for the batched methods 
> >> would be done in the similar way):
> >> ...
> >> ptr_ring_consume
> >> if r->consumer_head >= r->consumer_tail
> >>     __netif_tx_lock_bh
> >>     netif_tx_wake_queue
> >>     __netif_tx_unlock_bh
> >>
> >> This implementation does not need any new ptr_ring helpers and no fancy 
> >> ordering tricks.
> >> Would this implementation be sufficient in your opinion?
> > 
> > 
> > Maybe you mean == ? Pls don't poke at ptr ring internals though.
> > What are we testing for here?
> > I think the point is that a batch of entries was consumed?
> > Maybe __ptr_ring_consumed_batch ? and a comment explaining
> > this returns true when last successful call to consume
> > freed up a batch of space in the ring for producer to make
> > progress.
> >
> 
> Yes, I mean ==.
> 
> Having a dedicated helper for this purpose makes sense. I just find
> the name __ptr_ring_consumed_batch a bit confusing next to
> __ptr_ring_consume_batched, since they both refer to different kinds of
> batches.

__ptr_ring_consume_created_space ?

/* Previous call to ptr_ring_consume created some space.
 *
 * NB: only refers to the last call to __ptr_ring_consume,
 * if you are calling ptr_ring_consume multiple times, you
 * have to check this multiple times.
 * Accordingly, do not use this after __ptr_ring_consume_batched.
 */

> > 
> > consumer_head == consumer_tail also happens rather a lot,
> > though thankfully not on every entry.
> > So taking tx lock each time this happens, even if queue
> > is not stopped, seems heavyweight.
> > 
> > 
> 
> Yes, I agree — but avoiding locking probably requires some fancy
> ordering tricks again..
> 
> 
> > 
> > 
> > 
> >>>> The order of the operations
> >>>> +	 * is ensured by barrier().
> >>>> +	 */
> >>>> +	will_invalidate = __ptr_ring_will_invalidate(&q->ring);
> >>>> +	if (unlikely(will_invalidate)) {
> >>>> +		rcu_read_lock();
> >>>> +		dev = rcu_dereference(q->tap)->dev;
> >>>> +		txq = netdev_get_tx_queue(dev, q->queue_index);
> >>>> +		stopped = netif_tx_queue_stopped(txq);
> >>>> +	}
> >>>> +	barrier();
> >>>> +	__ptr_ring_discard_one(&q->ring, will_invalidate);
> >>>> +
> >>>> +	if (unlikely(will_invalidate)) {
> >>>> +		if (stopped)
> >>>> +			netif_tx_wake_queue(txq);
> >>>> +		rcu_read_unlock();
> >>>> +	}
> >>>
> >>>
> >>> After an entry is consumed, you can detect this by checking
> >>>
> >>> 	                r->consumer_head >= r->consumer_tail
> >>>
> >>>
> >>> so it seems you could keep calling regular ptr_ring_consume
> >>> and check afterwards?
> >>>
> >>>
> >>>
> >>>
> >>>> +	spin_unlock(&q->ring.consumer_lock);
> >>>> +
> >>>> +	return ptr;
> >>>> +}
> >>>> +
> >>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>  			   struct iov_iter *to,
> >>>>  			   int noblock, struct sk_buff *skb)
> >>>> @@ -774,7 +814,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
> >>>>  					TASK_INTERRUPTIBLE);
> >>>>  
> >>>>  		/* Read frames from the queue */
> >>>> -		skb = ptr_ring_consume(&q->ring);
> >>>> +		skb = tap_ring_consume(q);
> >>>>  		if (skb)
> >>>>  			break;
> >>>>  		if (noblock) {
> >>>> @@ -1207,6 +1247,8 @@ int tap_queue_resize(struct tap_dev *tap)
> >>>>  	ret = ptr_ring_resize_multiple_bh(rings, n,
> >>>>  					  dev->tx_queue_len, GFP_KERNEL,
> >>>>  					  __skb_array_destroy_skb);
> >>>> +	if (netif_running(dev))
> >>>> +		netif_tx_wake_all_queues(dev);
> >>>>  
> >>>>  	kfree(rings);
> >>>>  	return ret;
> >>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>> index c6b22af9bae8..682df8157b55 100644
> >>>> --- a/drivers/net/tun.c
> >>>> +++ b/drivers/net/tun.c
> >>>> @@ -2114,13 +2114,53 @@ static ssize_t tun_put_user(struct tun_struct *tun,
> >>>>  	return total;
> >>>>  }
> >>>>  
> >>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>> +{
> >>>> +	struct netdev_queue *txq;
> >>>> +	struct net_device *dev;
> >>>> +	bool will_invalidate;
> >>>> +	bool stopped;
> >>>> +	void *ptr;
> >>>> +
> >>>> +	spin_lock(&tfile->tx_ring.consumer_lock);
> >>>> +	ptr = __ptr_ring_peek(&tfile->tx_ring);
> >>>> +	if (!ptr) {
> >>>> +		spin_unlock(&tfile->tx_ring.consumer_lock);
> >>>> +		return ptr;
> >>>> +	}
> >>>> +
> >>>> +	/* Check if the queue stopped before zeroing out, so no ptr get
> >>>> +	 * produced in the meantime, because this could result in waking
> >>>> +	 * even though the ptr_ring is full. The order of the operations
> >>>> +	 * is ensured by barrier().
> >>>> +	 */
> >>>> +	will_invalidate = __ptr_ring_will_invalidate(&tfile->tx_ring);
> >>>> +	if (unlikely(will_invalidate)) {
> >>>> +		rcu_read_lock();
> >>>> +		dev = rcu_dereference(tfile->tun)->dev;
> >>>> +		txq = netdev_get_tx_queue(dev, tfile->queue_index);
> >>>> +		stopped = netif_tx_queue_stopped(txq);
> >>>> +	}
> >>>> +	barrier();
> >>>> +	__ptr_ring_discard_one(&tfile->tx_ring, will_invalidate);
> >>>> +
> >>>> +	if (unlikely(will_invalidate)) {
> >>>> +		if (stopped)
> >>>> +			netif_tx_wake_queue(txq);
> >>>> +		rcu_read_unlock();
> >>>> +	}
> >>>> +	spin_unlock(&tfile->tx_ring.consumer_lock);
> >>>> +
> >>>> +	return ptr;
> >>>> +}
> >>>> +
> >>>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
> >>>>  {
> >>>>  	DECLARE_WAITQUEUE(wait, current);
> >>>>  	void *ptr = NULL;
> >>>>  	int error = 0;
> >>>>  
> >>>> -	ptr = ptr_ring_consume(&tfile->tx_ring);
> >>>> +	ptr = tun_ring_consume(tfile);
> >>>>  	if (ptr)
> >>>>  		goto out;
> >>>>  	if (noblock) {
> >>>> @@ -2132,7 +2172,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
> >>>>  
> >>>>  	while (1) {
> >>>>  		set_current_state(TASK_INTERRUPTIBLE);
> >>>> -		ptr = ptr_ring_consume(&tfile->tx_ring);
> >>>> +		ptr = tun_ring_consume(tfile);
> >>>>  		if (ptr)
> >>>>  			break;
> >>>>  		if (signal_pending(current)) {
> >>>> @@ -3621,6 +3661,9 @@ static int tun_queue_resize(struct tun_struct *tun)
> >>>>  					  dev->tx_queue_len, GFP_KERNEL,
> >>>>  					  tun_ptr_free);
> >>>>  
> >>>> +	if (netif_running(dev))
> >>>> +		netif_tx_wake_all_queues(dev);
> >>>> +
> >>>>  	kfree(rings);
> >>>>  	return ret;
> >>>>  }
> >>>> -- 
> >>>> 2.43.0
> >>>
> > 


