Return-Path: <kvm+bounces-59800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 531FCBCF2DF
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 11:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51709405C46
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 09:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84A8244669;
	Sat, 11 Oct 2025 09:15:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6605122CBF1;
	Sat, 11 Oct 2025 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760174114; cv=none; b=KBTiXa4qBIEg9uO3bxjOBmAXDEWmn5l39BGTfF05utP8rpK7dB9BMtcCvlxUxireBbdBL3OsWWB4dN8Lp5kq10Qc77cjAmLOYqaqZWl+D1lI+iu/udReMQs1IpeslPt+EWzS0/9Y6XNML4YvEWtsB761eZCvM+MjSjMZhD5VquE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760174114; c=relaxed/simple;
	bh=Ju9tKnQUkAu/ViD6U/X2mTleMwjgiTF1ChocYUuMIjE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=EqjvGUzu9gP1x3NHMZvrdbZL8Zn6HODO0jwE7fId33Eki9xHbINF9gqLl4lHlHn6N7UAIu2Mhs++yM2/eP71y4hHUhS3otE+OKMTo0EuMraa4CeTVAtM8IfM2gWIx03Fr4Gml+ur1tkBHK7UoCwMWDfavwy+fvXq3d5e5zOIxGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 59B9F0Q1023991
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 11 Oct 2025 11:15:00 +0200 (CEST)
Message-ID: <c26f7e6f-af90-4a5c-a064-34b4e25ee7c3@tu-dortmund.de>
Date: Sat, 11 Oct 2025 11:15:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after consuming
 an entry
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, leiyang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-5-simon.schippers@tu-dortmund.de>
 <20250923123101-mutt-send-email-mst@kernel.org>
 <4dde6d41-2a26-47b8-aef1-4967f7fc94ab@tu-dortmund.de>
 <20250928182445-mutt-send-email-mst@kernel.org>
 <b901efef-2dc8-4de3-8f87-22f8c9c1cbc6@tu-dortmund.de>
Content-Language: en-US
In-Reply-To: <b901efef-2dc8-4de3-8f87-22f8c9c1cbc6@tu-dortmund.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29.09.25 11:43, Simon Schippers wrote:
> On 29.09.25 00:33, Michael S. Tsirkin wrote:
>> On Sun, Sep 28, 2025 at 11:27:25PM +0200, Simon Schippers wrote:
>>> On 23.09.25 18:36, Michael S. Tsirkin wrote:
>>>> On Tue, Sep 23, 2025 at 12:15:49AM +0200, Simon Schippers wrote:
>>>>> The new wrappers tun_ring_consume/tap_ring_consume deal with consuming an
>>>>> entry of the ptr_ring and then waking the netdev queue when entries got
>>>>> invalidated to be used again by the producer.
>>>>> To avoid waking the netdev queue when the ptr_ring is full, it is checked
>>>>> if the netdev queue is stopped before invalidating entries. Like that the
>>>>> netdev queue can be safely woken after invalidating entries.
>>>>>
>>>>> The READ_ONCE in __ptr_ring_peek, paired with the smp_wmb() in
>>>>> __ptr_ring_produce within tun_net_xmit guarantees that the information
>>>>> about the netdev queue being stopped is visible after __ptr_ring_peek is
>>>>> called.
>>>>>
>>>>> The netdev queue is also woken after resizing the ptr_ring.
>>>>>
>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>> ---
>>>>>  drivers/net/tap.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>>>>>  drivers/net/tun.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
>>>>>  2 files changed, 88 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>> index 1197f245e873..f8292721a9d6 100644
>>>>> --- a/drivers/net/tap.c
>>>>> +++ b/drivers/net/tap.c
>>>>> @@ -753,6 +753,46 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>>  	return ret ? ret : total;
>>>>>  }
>>>>>  
>>>>> +static struct sk_buff *tap_ring_consume(struct tap_queue *q)
>>>>> +{
>>>>> +	struct netdev_queue *txq;
>>>>> +	struct net_device *dev;
>>>>> +	bool will_invalidate;
>>>>> +	bool stopped;
>>>>> +	void *ptr;
>>>>> +
>>>>> +	spin_lock(&q->ring.consumer_lock);
>>>>> +	ptr = __ptr_ring_peek(&q->ring);
>>>>> +	if (!ptr) {
>>>>> +		spin_unlock(&q->ring.consumer_lock);
>>>>> +		return ptr;
>>>>> +	}
>>>>> +
>>>>> +	/* Check if the queue stopped before zeroing out, so no ptr get
>>>>> +	 * produced in the meantime, because this could result in waking
>>>>> +	 * even though the ptr_ring is full.
>>>>
>>>> So what? Maybe it would be a bit suboptimal? But with your design, I do
>>>> not get what prevents this:
>>>>
>>>>
>>>> 	stopped? -> No
>>>> 		ring is stopped
>>>> 	discard
>>>>
>>>> and queue stays stopped forever
>>>>
>>>
>>> I think I found a solution to this problem, see below:
>>>
>>>>
>>>>> The order of the operations
>>>>> +	 * is ensured by barrier().
>>>>> +	 */
>>>>> +	will_invalidate = __ptr_ring_will_invalidate(&q->ring);
>>>>> +	if (unlikely(will_invalidate)) {
>>>>> +		rcu_read_lock();
>>>>> +		dev = rcu_dereference(q->tap)->dev;
>>>>> +		txq = netdev_get_tx_queue(dev, q->queue_index);
>>>>> +		stopped = netif_tx_queue_stopped(txq);
>>>>> +	}
>>>>> +	barrier();
>>>>> +	__ptr_ring_discard_one(&q->ring, will_invalidate);
>>>>> +
>>>>> +	if (unlikely(will_invalidate)) {
>>>
>>> Here I just check for
>>>
>>> 	if (will_invalidate || __ptr_ring_empty(&q->ring)) {
>>>
>>> instead because, if the ptr_ring is empty and the netdev queue stopped,
>>> the race must have occurred. Then it is safe to wake the netdev queue,
>>> because it is known that space in the ptr_ring was freed when the race
>>> occurred. Also, it is guaranteed that tap_ring_consume is called at least
>>> once after the race, because a new entry is generated by the producer at
>>> the race.
>>> In my adjusted implementation, it tests fine with pktgen without any lost
>>> packets.
>>
>>
>> what if it is not empty and ring is stopped?
>>
> 
> Then it can not be assumed that there is free space in the ptr_ring,
> because __ptr_ring_discard_one may only create space after one of the
> upcoming entries that it will consume. Only if the ptr_ring is empty
> (which will obviously happen after some time) it is guaranteed that there
> is free space in the ptr_ring, either because the race occurred
> previously or __ptr_ring_discard_one freed entries right before.
> 
>>>
>>> Generally now I think that the whole implementation can be fine without
>>> using spinlocks at all. I am currently adjusting the implementation
>>> regarding SMP memory barrier pairings, and I have a question:
>>> In the v4 you mentioned "the stop -> wake bounce involves enough barriers
>>> already". Does it, for instance, mean that netif_tx_wake_queue already
>>> ensures memory ordering, and I do not have to use an smp_wmb() in front of
>>> netif_tx_wake_queue() and smp_rmb() in front of the ptr_ring operations
>>> in tun_net_xmit?
>>> I dug through net/core/netdevice.h and dev.c but could not really
>>> answer this question by myself...
>>> Thanks :)
>>
>> Only if it wakes up something, I think.
>>
>> Read:
>>
>> SLEEP AND WAKE-UP FUNCTIONS
>>
>>
>> in Documentation/memory-barriers.txt
>>
>>
>> IIUC this is the same.
>>
>>
> 
> Thanks, I will look into it! :)
> 

I do not see how the netdev queue flow control follows a setup with a
sleeper and a waker as described in SLEEP AND WAKE-UP FUNCTIONS.

Yes, there is netif_tx_wake_queue, but it does not call a waker function
like complete() or wake_up(). And I do not see how there is a sleeper
that calls schedule() somewhere.

Do I misunderstand something?

For now I would instead use an additional smp_wmb() in front of
netif_tx_wake_queue for the consumer and an smp_rmb() in front of all
ptr_ring operations for the producer. This ensures that space, which is
freed by the consumer that woke up the netdev queue, is visible for the
producer.

Thanks! :)

>>>
>>>>> +		if (stopped)
>>>>> +			netif_tx_wake_queue(txq);
>>>>> +		rcu_read_unlock();
>>>>> +	}
>>>>
>>>>
>>>> After an entry is consumed, you can detect this by checking
>>>>
>>>> 	                r->consumer_head >= r->consumer_tail
>>>>
>>>>
>>>> so it seems you could keep calling regular ptr_ring_consume
>>>> and check afterwards?
>>>>
>>>>
>>>>
>>>>
>>>>> +	spin_unlock(&q->ring.consumer_lock);
>>>>> +
>>>>> +	return ptr;
>>>>> +}
>>>>> +
>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>>  			   struct iov_iter *to,
>>>>>  			   int noblock, struct sk_buff *skb)
>>>>> @@ -774,7 +814,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>>  					TASK_INTERRUPTIBLE);
>>>>>  
>>>>>  		/* Read frames from the queue */
>>>>> -		skb = ptr_ring_consume(&q->ring);
>>>>> +		skb = tap_ring_consume(q);
>>>>>  		if (skb)
>>>>>  			break;
>>>>>  		if (noblock) {
>>>>> @@ -1207,6 +1247,8 @@ int tap_queue_resize(struct tap_dev *tap)
>>>>>  	ret = ptr_ring_resize_multiple_bh(rings, n,
>>>>>  					  dev->tx_queue_len, GFP_KERNEL,
>>>>>  					  __skb_array_destroy_skb);
>>>>> +	if (netif_running(dev))
>>>>> +		netif_tx_wake_all_queues(dev);
>>>>>  
>>>>>  	kfree(rings);
>>>>>  	return ret;
>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>> index c6b22af9bae8..682df8157b55 100644
>>>>> --- a/drivers/net/tun.c
>>>>> +++ b/drivers/net/tun.c
>>>>> @@ -2114,13 +2114,53 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>>  	return total;
>>>>>  }
>>>>>  
>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>>> +{
>>>>> +	struct netdev_queue *txq;
>>>>> +	struct net_device *dev;
>>>>> +	bool will_invalidate;
>>>>> +	bool stopped;
>>>>> +	void *ptr;
>>>>> +
>>>>> +	spin_lock(&tfile->tx_ring.consumer_lock);
>>>>> +	ptr = __ptr_ring_peek(&tfile->tx_ring);
>>>>> +	if (!ptr) {
>>>>> +		spin_unlock(&tfile->tx_ring.consumer_lock);
>>>>> +		return ptr;
>>>>> +	}
>>>>> +
>>>>> +	/* Check if the queue stopped before zeroing out, so no ptr get
>>>>> +	 * produced in the meantime, because this could result in waking
>>>>> +	 * even though the ptr_ring is full. The order of the operations
>>>>> +	 * is ensured by barrier().
>>>>> +	 */
>>>>> +	will_invalidate = __ptr_ring_will_invalidate(&tfile->tx_ring);
>>>>> +	if (unlikely(will_invalidate)) {
>>>>> +		rcu_read_lock();
>>>>> +		dev = rcu_dereference(tfile->tun)->dev;
>>>>> +		txq = netdev_get_tx_queue(dev, tfile->queue_index);
>>>>> +		stopped = netif_tx_queue_stopped(txq);
>>>>> +	}
>>>>> +	barrier();
>>>>> +	__ptr_ring_discard_one(&tfile->tx_ring, will_invalidate);
>>>>> +
>>>>> +	if (unlikely(will_invalidate)) {
>>>>> +		if (stopped)
>>>>> +			netif_tx_wake_queue(txq);
>>>>> +		rcu_read_unlock();
>>>>> +	}
>>>>> +	spin_unlock(&tfile->tx_ring.consumer_lock);
>>>>> +
>>>>> +	return ptr;
>>>>> +}
>>>>> +
>>>>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>>>>  {
>>>>>  	DECLARE_WAITQUEUE(wait, current);
>>>>>  	void *ptr = NULL;
>>>>>  	int error = 0;
>>>>>  
>>>>> -	ptr = ptr_ring_consume(&tfile->tx_ring);
>>>>> +	ptr = tun_ring_consume(tfile);
>>>>>  	if (ptr)
>>>>>  		goto out;
>>>>>  	if (noblock) {
>>>>> @@ -2132,7 +2172,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>>>>  
>>>>>  	while (1) {
>>>>>  		set_current_state(TASK_INTERRUPTIBLE);
>>>>> -		ptr = ptr_ring_consume(&tfile->tx_ring);
>>>>> +		ptr = tun_ring_consume(tfile);
>>>>>  		if (ptr)
>>>>>  			break;
>>>>>  		if (signal_pending(current)) {
>>>>> @@ -3621,6 +3661,9 @@ static int tun_queue_resize(struct tun_struct *tun)
>>>>>  					  dev->tx_queue_len, GFP_KERNEL,
>>>>>  					  tun_ptr_free);
>>>>>  
>>>>> +	if (netif_running(dev))
>>>>> +		netif_tx_wake_all_queues(dev);
>>>>> +
>>>>>  	kfree(rings);
>>>>>  	return ret;
>>>>>  }
>>>>> -- 
>>>>> 2.43.0
>>>>
>>

