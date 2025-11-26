Return-Path: <kvm+bounces-64684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0676BC8AD11
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 84C504ED957
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39DE33D6C6;
	Wed, 26 Nov 2025 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="IRFNm+rG"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D732C13B;
	Wed, 26 Nov 2025 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764173088; cv=none; b=DGDCcwHzHbeIuj6zWCG2eSYFEkbe9dvptpiomAkuyXHnPPX3hccoUL7i4lwGRtrTuzk9eXerjjxIMogduAyzO9BmRtdkXFT521HGZTVkEeRZKg+1uXIhPmLVEYlGTYIH94fhMk4YZp/arZXFHyailMDcOcnakkX3sw5CX557sQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764173088; c=relaxed/simple;
	bh=ScIjvDQM0tIm6p0ZsQW1B/rH8dMtLMvsxViZMEtoW9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rvVOj/gNzqRVAgJjhSv0MngfxbX4S5CJTdYo6zWGc5/IsIXhv5MDFC71hl7xnwsdrSqjmIyJa96LEGbMg3KCj7JmVcV8wrH0bbKu7wgNpXXutABKNxPsZ9hlZPoBNwG5Jh8UPySnzdI3P27MrKuluQv/Ngl5I53M/ZiXuOVNAL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=IRFNm+rG; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [172.31.100.153] ([172.31.100.153])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.15/8.18.1.15) with ESMTPSA id 5AQG4PN6025014
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 17:04:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1764173067;
	bh=ScIjvDQM0tIm6p0ZsQW1B/rH8dMtLMvsxViZMEtoW9c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IRFNm+rGytp+ISpV6CwIJ0zuac9Fx7rM/wcTaCHG6iyk8fB4h+sVjqAdxFtXNRcwX
	 3fFQHh2LO62L+bfs0b8PCAAHroG1ebAPhXYeHdO7gMKWqxt1ZEY8p04wa6i9gIWgIT
	 zsDLB597xk77JyQCo2MmXyFyzM4L1PDrta5Ns8gQ=
Message-ID: <c0fc512a-5bee-48da-9dfb-2b8101f3dec6@tu-dortmund.de>
Date: Wed, 26 Nov 2025 17:04:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 3/8] tun/tap: add synchronized ring
 produce/consume with queue management
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-4-simon.schippers@tu-dortmund.de>
 <20251125100655-mutt-send-email-mst@kernel.org>
 <4db234bd-ebd7-4325-9157-e74eccb58616@tu-dortmund.de>
 <20251126100007-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20251126100007-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 16:25, Michael S. Tsirkin wrote:
> On Wed, Nov 26, 2025 at 10:23:50AM +0100, Simon Schippers wrote:
>> On 11/25/25 17:54, Michael S. Tsirkin wrote:
>>> On Thu, Nov 20, 2025 at 04:29:08PM +0100, Simon Schippers wrote:
>>>> Implement new ring buffer produce and consume functions for tun and tap
>>>> drivers that provide lockless producer-consumer synchronization and
>>>> netdev queue management to prevent ptr_ring tail drop and permanent
>>>> starvation.
>>>>
>>>> - tun_ring_produce(): Produces packets to the ptr_ring with proper memory
>>>>   barriers and proactively stops the netdev queue when the ring is about
>>>>   to become full.
>>>>
>>>> - __tun_ring_consume() / __tap_ring_consume(): Internal consume functions
>>>>   that check if the netdev queue was stopped due to a full ring, and wake
>>>>   it when space becomes available. Uses memory barriers to ensure proper
>>>>   ordering between producer and consumer.
>>>>
>>>> - tun_ring_consume() / tap_ring_consume(): Wrapper functions that acquire
>>>>   the consumer lock before calling the internal consume functions.
>>>>
>>>> Key features:
>>>> - Proactive queue stopping using __ptr_ring_full_next() to stop the queue
>>>>   before it becomes completely full.
>>>> - Not stopping the queue when the ptr_ring is full already, because if
>>>>   the consumer empties all entries in the meantime, stopping the queue
>>>>   would cause permanent starvation.
>>>
>>> what is permanent starvation? this comment seems to answer this
>>> question:
>>>
>>>
>>> 	/* Do not stop the netdev queue if the ptr_ring is full already.
>>> 	 * The consumer could empty out the ptr_ring in the meantime
>>> 	 * without noticing the stopped netdev queue, resulting in a
>>> 	 * stopped netdev queue and an empty ptr_ring. In this case the
>>> 	 * netdev queue would stay stopped forever.
>>> 	 */
>>>
>>>
>>> why having a single entry in
>>> the ring we never use helpful to address this?
>>>
>>>
>>>
>>>
>>> In fact, all your patch does to solve it, is check
>>> netif_tx_queue_stopped on every consumed packet.
>>>
>>>
>>> I already proposed:
>>>
>>> static inline int __ptr_ring_peek_producer(struct ptr_ring *r)
>>> {
>>>         if (unlikely(!r->size) || r->queue[r->producer])
>>>                 return -ENOSPC;
>>>         return 0;
>>> }
>>>
>>> And with that, why isn't avoiding the race as simple as
>>> just rechecking after stopping the queue?
>>  
>> I think you are right and that is quite similar to what veth [1] does.
>> However, there are two differences:
>>
>> - Your approach avoids returning NETDEV_TX_BUSY by already stopping
>>   when the ring becomes full (and not when the ring is full already)
>> - ...and the recheck of the producer wakes on !full instead of empty.
>>
>> I like both aspects better than the veth implementation.
> 
> Right.
> 
> Though frankly, someone should just fix NETDEV_TX_BUSY already
> at least with the most popular qdiscs.
> 
> It is a common situation and it is just annoying that every driver has
> to come up with its own scheme.

I can not judge it, but yes, it would have made this patchset way
simpler.

> 
> 
> 
> 
> 
>> Just one thing: like the veth implementation, we probably need a
>> smp_mb__after_atomic() after netif_tx_stop_queue() as they also discussed
>> in their v6 [2].
> 
> yea makes sense.
> 
>>
>> On the consumer side, I would then just do:
>>
>> __ptr_ring_consume();
>> if (unlikely(__ptr_ring_consume_created_space()))
>>     netif_tx_wake_queue(txq);
>>
>> Right?
>>
>> And for the batched consume method, I would just call this in a loop.
> 
> Well tun does not use batched consume does it?

tun does not but vhost-net does.

Since vhost-net also uses tun_net_xmit() as its ndo_start_xmit in a
tap+vhost-net setup, its consumer must also be changed. Else
tun_net_xmit() would stop the queue, but it would never be woken again.

> 
> 
>> Thank you!
>>
>> [1] Link: https://lore.kernel.org/netdev/174559288731.827981.8748257839971869213.stgit@firesoul/T/#m2582fcc48901e2e845b20b89e0e7196951484e5f
>> [2] Link: https://lore.kernel.org/all/174549933665.608169.392044991754158047.stgit@firesoul/T/#m63f2deb86ffbd9ff3a27e1232077a3775606c14d
>>
>>>
>>> __ptr_ring_produce();
>>> if (__ptr_ring_peek_producer())
>>> 	netif_tx_stop_queue
>>
>> smp_mb__after_atomic(); // Right here
>>
>>> 	if (!__ptr_ring_peek_producer())
>>> 		netif_tx_wake_queue(txq);
>>>
>>>
>>>
>>>
>>>
>>>
>>>
> 

