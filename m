Return-Path: <kvm+bounces-58626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92856B98EFD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 10:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 312943A9798
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965B228DB56;
	Wed, 24 Sep 2025 08:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="Ztajcb9d"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFEB28851F;
	Wed, 24 Sep 2025 08:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758703210; cv=none; b=TYiufZ8HpUy26QAGdrviF9zk0Sxm/sQqbZv/GGQQlwiAzY5p8ErjWUsHQ/0R9fobP50g8aEXJL6qH06oqy/FjlnmVShrQKzQdnqAjZysEyLZ4kFjTKAPR4HQwklKIUkiZy/YQfjJ77RwW+rUI0s9PtzZy2X0NWHAb1bPbjvQgj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758703210; c=relaxed/simple;
	bh=hyUuaDTnDR9cZMfkUVTucVAIu2XBYzlqLT3CmCKBVSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YaV+yzfEQdZ1zcj1aZrRnBCrywxMO0SDMRUOuDcnGKDyTP9sjLsldnJ/fFfrTzglTuCRU6LyiGxhHmrZH3+FdWLpx4EWrXcZy7I++bXmi3qCm5buQ1VPYXNtQ7FDOKepk4/ZCvCglLlcrSQPrdcEfQIuhe5Bi8VecSCzMWXOA7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=Ztajcb9d; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.216] ([129.217.186.216])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58O8e4Eb029808
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 10:40:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758703204;
	bh=hyUuaDTnDR9cZMfkUVTucVAIu2XBYzlqLT3CmCKBVSE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ztajcb9dz5YlFnKabmJtwjyMweiXxm8goOwG5M6LqKD2L2dSlDVA/XUS6Me8zcUGF
	 0VmhJXzXc9NZEJ5TD3YEuxkCiVNeiweVMhlsUtnlU2+eYyghVTMujknpn+zbp5OxI8
	 TZUF1zvf8JQIkD8o/qqMpg3A72s+ip/mqR4vQx2A=
Message-ID: <9e7b0931-afde-4b14-8a6e-372bda6cf95e@tu-dortmund.de>
Date: Wed, 24 Sep 2025 10:40:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after
 consuming an entry
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, leiyang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-5-simon.schippers@tu-dortmund.de>
 <20250923123101-mutt-send-email-mst@kernel.org>
 <aacb449c-ad20-48b0-aa0f-b3866a3ed7f6@tu-dortmund.de>
 <20250924024416-mutt-send-email-mst@kernel.org>
 <a16b643a-3cfe-4b95-b76a-100f512cdb79@tu-dortmund.de>
 <20250924034534-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20250924034534-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 24.09.25 09:49, Michael S. Tsirkin wrote:
> On Wed, Sep 24, 2025 at 09:42:45AM +0200, Simon Schippers wrote:
>> On 24.09.25 08:55, Michael S. Tsirkin wrote:
>>> On Wed, Sep 24, 2025 at 07:56:33AM +0200, Simon Schippers wrote:
>>>> On 23.09.25 18:36, Michael S. Tsirkin wrote:
>>>>> On Tue, Sep 23, 2025 at 12:15:49AM +0200, Simon Schippers wrote:
>>>>>> The new wrappers tun_ring_consume/tap_ring_consume deal with consuming an
>>>>>> entry of the ptr_ring and then waking the netdev queue when entries got
>>>>>> invalidated to be used again by the producer.
>>>>>> To avoid waking the netdev queue when the ptr_ring is full, it is checked
>>>>>> if the netdev queue is stopped before invalidating entries. Like that the
>>>>>> netdev queue can be safely woken after invalidating entries.
>>>>>>
>>>>>> The READ_ONCE in __ptr_ring_peek, paired with the smp_wmb() in
>>>>>> __ptr_ring_produce within tun_net_xmit guarantees that the information
>>>>>> about the netdev queue being stopped is visible after __ptr_ring_peek is
>>>>>> called.
>>>>>>
>>>>>> The netdev queue is also woken after resizing the ptr_ring.
>>>>>>
>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>>> ---
>>>>>>  drivers/net/tap.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>>>>>>  drivers/net/tun.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
>>>>>>  2 files changed, 88 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>>> index 1197f245e873..f8292721a9d6 100644
>>>>>> --- a/drivers/net/tap.c
>>>>>> +++ b/drivers/net/tap.c
>>>>>> @@ -753,6 +753,46 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>>>  	return ret ? ret : total;
>>>>>>  }
>>>>>>  
>>>>>> +static struct sk_buff *tap_ring_consume(struct tap_queue *q)
>>>>>> +{
>>>>>> +	struct netdev_queue *txq;
>>>>>> +	struct net_device *dev;
>>>>>> +	bool will_invalidate;
>>>>>> +	bool stopped;
>>>>>> +	void *ptr;
>>>>>> +
>>>>>> +	spin_lock(&q->ring.consumer_lock);
>>>>>> +	ptr = __ptr_ring_peek(&q->ring);
>>>>>> +	if (!ptr) {
>>>>>> +		spin_unlock(&q->ring.consumer_lock);
>>>>>> +		return ptr;
>>>>>> +	}
>>>>>> +
>>>>>> +	/* Check if the queue stopped before zeroing out, so no ptr get
>>>>>> +	 * produced in the meantime, because this could result in waking
>>>>>> +	 * even though the ptr_ring is full.
>>>>>
>>>>> So what? Maybe it would be a bit suboptimal? But with your design, I do
>>>>> not get what prevents this:
>>>>>
>>>>>
>>>>> 	stopped? -> No
>>>>> 		ring is stopped
>>>>> 	discard
>>>>>
>>>>> and queue stays stopped forever
>>>>>
>>>>>
>>>>
>>>> I totally missed this (but I am not sure why it did not happen in my 
>>>> testing with different ptr_ring sizes..).
>>>>
>>>> I guess you are right, there must be some type of locking.
>>>> It probably makes sense to lock the netdev txq->_xmit_lock whenever the 
>>>> consumer invalidates old ptr_ring entries (so when r->consumer_head >= 
>>>> r->consumer_tail). The producer holds this lock with dev->lltx=false. Then 
>>>> the consumer is able to wake the queue safely.
>>>>
>>>> So I would now just change the implementation to:
>>>> tun_net_xmit:
>>>> ...
>>>> if ptr_ring_produce
>>>>     // Could happen because of unproduce in vhost_net..
>>>>     netif_tx_stop_queue
>>>>     ...
>>>>     goto drop
>>>>
>>>> if ptr_ring_full
>>>>     netif_tx_stop_queue
>>>> ...
>>>>
>>>> tun_ring_recv/tap_do_read (the implementation for the batched methods 
>>>> would be done in the similar way):
>>>> ...
>>>> ptr_ring_consume
>>>> if r->consumer_head >= r->consumer_tail
>>>>     __netif_tx_lock_bh
>>>>     netif_tx_wake_queue
>>>>     __netif_tx_unlock_bh
>>>>
>>>> This implementation does not need any new ptr_ring helpers and no fancy 
>>>> ordering tricks.
>>>> Would this implementation be sufficient in your opinion?
>>>
>>>
>>> Maybe you mean == ? Pls don't poke at ptr ring internals though.
>>> What are we testing for here?
>>> I think the point is that a batch of entries was consumed?
>>> Maybe __ptr_ring_consumed_batch ? and a comment explaining
>>> this returns true when last successful call to consume
>>> freed up a batch of space in the ring for producer to make
>>> progress.
>>>
>>
>> Yes, I mean ==.
>>
>> Having a dedicated helper for this purpose makes sense. I just find
>> the name __ptr_ring_consumed_batch a bit confusing next to
>> __ptr_ring_consume_batched, since they both refer to different kinds of
>> batches.
> 
> __ptr_ring_consume_created_space ?
> 
> /* Previous call to ptr_ring_consume created some space.
>  *
>  * NB: only refers to the last call to __ptr_ring_consume,
>  * if you are calling ptr_ring_consume multiple times, you
>  * have to check this multiple times.
>  * Accordingly, do not use this after __ptr_ring_consume_batched.
>  */
>

Sounds good.

Regarding __ptr_ring_consume_batched:
Theoretically the consumer_tail before and after calling the method could
be compared to avoid calling __ptr_ring_consume_created_space at each
iteration. But I guess it is also fine calling it at each iteration.

>>>
>>> consumer_head == consumer_tail also happens rather a lot,
>>> though thankfully not on every entry.
>>> So taking tx lock each time this happens, even if queue
>>> is not stopped, seems heavyweight.
>>>
>>>
>>
>> Yes, I agree — but avoiding locking probably requires some fancy
>> ordering tricks again..
>>
>>
>>>
>>>
>>>
>>>>>> The order of the operations
>>>>>> +	 * is ensured by barrier().
>>>>>> +	 */
>>>>>> +	will_invalidate = __ptr_ring_will_invalidate(&q->ring);
>>>>>> +	if (unlikely(will_invalidate)) {
>>>>>> +		rcu_read_lock();
>>>>>> +		dev = rcu_dereference(q->tap)->dev;
>>>>>> +		txq = netdev_get_tx_queue(dev, q->queue_index);
>>>>>> +		stopped = netif_tx_queue_stopped(txq);
>>>>>> +	}
>>>>>> +	barrier();
>>>>>> +	__ptr_ring_discard_one(&q->ring, will_invalidate);
>>>>>> +
>>>>>> +	if (unlikely(will_invalidate)) {
>>>>>> +		if (stopped)
>>>>>> +			netif_tx_wake_queue(txq);
>>>>>> +		rcu_read_unlock();
>>>>>> +	}
>>>>>
>>>>>
>>>>> After an entry is consumed, you can detect this by checking
>>>>>
>>>>> 	                r->consumer_head >= r->consumer_tail
>>>>>
>>>>>
>>>>> so it seems you could keep calling regular ptr_ring_consume
>>>>> and check afterwards?
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>> +	spin_unlock(&q->ring.consumer_lock);
>>>>>> +
>>>>>> +	return ptr;
>>>>>> +}
>>>>>> +
>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>  			   struct iov_iter *to,
>>>>>>  			   int noblock, struct sk_buff *skb)
>>>>>> @@ -774,7 +814,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>  					TASK_INTERRUPTIBLE);
>>>>>>  
>>>>>>  		/* Read frames from the queue */
>>>>>> -		skb = ptr_ring_consume(&q->ring);
>>>>>> +		skb = tap_ring_consume(q);
>>>>>>  		if (skb)
>>>>>>  			break;
>>>>>>  		if (noblock) {
>>>>>> @@ -1207,6 +1247,8 @@ int tap_queue_resize(struct tap_dev *tap)
>>>>>>  	ret = ptr_ring_resize_multiple_bh(rings, n,
>>>>>>  					  dev->tx_queue_len, GFP_KERNEL,
>>>>>>  					  __skb_array_destroy_skb);
>>>>>> +	if (netif_running(dev))
>>>>>> +		netif_tx_wake_all_queues(dev);
>>>>>>  
>>>>>>  	kfree(rings);
>>>>>>  	return ret;
>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>> index c6b22af9bae8..682df8157b55 100644
>>>>>> --- a/drivers/net/tun.c
>>>>>> +++ b/drivers/net/tun.c
>>>>>> @@ -2114,13 +2114,53 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>>>  	return total;
>>>>>>  }
>>>>>>  
>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>>>> +{
>>>>>> +	struct netdev_queue *txq;
>>>>>> +	struct net_device *dev;
>>>>>> +	bool will_invalidate;
>>>>>> +	bool stopped;
>>>>>> +	void *ptr;
>>>>>> +
>>>>>> +	spin_lock(&tfile->tx_ring.consumer_lock);
>>>>>> +	ptr = __ptr_ring_peek(&tfile->tx_ring);
>>>>>> +	if (!ptr) {
>>>>>> +		spin_unlock(&tfile->tx_ring.consumer_lock);
>>>>>> +		return ptr;
>>>>>> +	}
>>>>>> +
>>>>>> +	/* Check if the queue stopped before zeroing out, so no ptr get
>>>>>> +	 * produced in the meantime, because this could result in waking
>>>>>> +	 * even though the ptr_ring is full. The order of the operations
>>>>>> +	 * is ensured by barrier().
>>>>>> +	 */
>>>>>> +	will_invalidate = __ptr_ring_will_invalidate(&tfile->tx_ring);
>>>>>> +	if (unlikely(will_invalidate)) {
>>>>>> +		rcu_read_lock();
>>>>>> +		dev = rcu_dereference(tfile->tun)->dev;
>>>>>> +		txq = netdev_get_tx_queue(dev, tfile->queue_index);
>>>>>> +		stopped = netif_tx_queue_stopped(txq);
>>>>>> +	}
>>>>>> +	barrier();
>>>>>> +	__ptr_ring_discard_one(&tfile->tx_ring, will_invalidate);
>>>>>> +
>>>>>> +	if (unlikely(will_invalidate)) {
>>>>>> +		if (stopped)
>>>>>> +			netif_tx_wake_queue(txq);
>>>>>> +		rcu_read_unlock();
>>>>>> +	}
>>>>>> +	spin_unlock(&tfile->tx_ring.consumer_lock);
>>>>>> +
>>>>>> +	return ptr;
>>>>>> +}
>>>>>> +
>>>>>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>>>>>  {
>>>>>>  	DECLARE_WAITQUEUE(wait, current);
>>>>>>  	void *ptr = NULL;
>>>>>>  	int error = 0;
>>>>>>  
>>>>>> -	ptr = ptr_ring_consume(&tfile->tx_ring);
>>>>>> +	ptr = tun_ring_consume(tfile);
>>>>>>  	if (ptr)
>>>>>>  		goto out;
>>>>>>  	if (noblock) {
>>>>>> @@ -2132,7 +2172,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>>>>>  
>>>>>>  	while (1) {
>>>>>>  		set_current_state(TASK_INTERRUPTIBLE);
>>>>>> -		ptr = ptr_ring_consume(&tfile->tx_ring);
>>>>>> +		ptr = tun_ring_consume(tfile);
>>>>>>  		if (ptr)
>>>>>>  			break;
>>>>>>  		if (signal_pending(current)) {
>>>>>> @@ -3621,6 +3661,9 @@ static int tun_queue_resize(struct tun_struct *tun)
>>>>>>  					  dev->tx_queue_len, GFP_KERNEL,
>>>>>>  					  tun_ptr_free);
>>>>>>  
>>>>>> +	if (netif_running(dev))
>>>>>> +		netif_tx_wake_all_queues(dev);
>>>>>> +
>>>>>>  	kfree(rings);
>>>>>>  	return ret;
>>>>>>  }
>>>>>> -- 
>>>>>> 2.43.0
>>>>>
>>>
> 

