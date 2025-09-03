Return-Path: <kvm+bounces-56694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E33FB428C6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 20:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FF571BA7FA3
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 18:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCD33680A4;
	Wed,  3 Sep 2025 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="S/nI+8UA"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9453629B8;
	Wed,  3 Sep 2025 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756924553; cv=none; b=ORE/TU7Hvlpfib3M3JfSzbQutI0Twy1Zyd8C8ttNclObkKZal54SOuBjoABhQk9xh+8yw6jG7yqLKXFJjWm5oBKdxzmFjPycRkB/dvTggjrCTY1lnCUOXUC2mcIE7SvmSVeaGPmuFCpCoMbCqQQgKEAtb9OzTrwf7BNXq2B+dhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756924553; c=relaxed/simple;
	bh=7CxDRWpb5torW5UwqUmMDtS55zZkyHgBohxIpCgTqH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jFam6WtgK50ej1ufskwBx2s9BiFgskeec4ZGnzthxxwsLgMIy3VnYFTbLSWJbX4E3LM/u/7gUyvWt9Ti6WQ40RoV1xh1mKkv9X2r8ZXfaMojsKsrZJwCb1Jpoo9oxgDg8C2vV0361CzNcgabjshtmCP6yXvo3CBEkCpoLa2qUh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=S/nI+8UA; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (pd9eaae6b.dip0.t-ipconnect.de [217.234.174.107])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 583IZkXr011583
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Sep 2025 20:35:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756924547;
	bh=7CxDRWpb5torW5UwqUmMDtS55zZkyHgBohxIpCgTqH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S/nI+8UAvrumliQ5UoNRW8b94SZ+X+lBBoXjP9w2hemiKDS+T2mv912n7FT2vfKIq
	 aNky0170uSg/V3lWjA8wW213dVmUg9jL7M9IE01of1JLsfchOKPIm6lFaiZ2sMlKKr
	 8MtTgL7RS42MHmwz8v5P4RGwABvB71Bm9cndRduk=
Message-ID: <40916cac-1237-4b7a-976d-3b62c85c895b@tu-dortmund.de>
Date: Wed, 3 Sep 2025 20:35:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/4] netdev queue flow control for TUN
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, jasowang@redhat.com,
        mst@redhat.com, eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
 <willemdebruijn.kernel.243baccfedc16@gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <willemdebruijn.kernel.243baccfedc16@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Willem de Bruijn wrote:
> Simon Schippers wrote:
>> The netdev queue is stopped in tun_net_xmit after inserting an SKB into
>> the ring buffer if the ring buffer became full because of that. If the
>> insertion into the ptr_ring fails, the netdev queue is also stopped and
>> the SKB is dropped. However, this never happened in my testing.
> 
> Indeed, since the last successful insertion will always pause the
> queue before this can happen. Since this cannot be reached, no need
> to add the code defensively. If in doubt, maybe add a
> NET_DEBUG_WARN_ON_ONCE.
> 
>> To ensure
>> that the ptr_ring change is available to the consumer before the netdev
>> queue stop, an smp_wmb() is used.
>>
>> Then in tun_ring_recv, the new helper wake_netdev_queue is called in the
>> blocking wait queue and after consuming an SKB from the ptr_ring. This
>> helper first checks if the netdev queue has stopped. Then with the paired
>> smp_rmb() it is known that tun_net_xmit will not produce SKBs anymore.
>> With that knowledge, the helper can then wake the netdev queue if there is
>> at least a single spare slot in the ptr_ring by calling ptr_ring_spare
>> with cnt=1.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  drivers/net/tun.c | 33 ++++++++++++++++++++++++++++++---
>>  1 file changed, 30 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index cc6c50180663..735498e221d8 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1060,13 +1060,21 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  
>>  	nf_reset_ct(skb);
>>  
>> -	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
>> +	queue = netdev_get_tx_queue(dev, txq);
>> +	if (unlikely(ptr_ring_produce(&tfile->tx_ring, skb))) {
>> +		/* Paired with smp_rmb() in wake_netdev_queue. */
>> +		smp_wmb();
>> +		netif_tx_stop_queue(queue);
>>  		drop_reason = SKB_DROP_REASON_FULL_RING;
>>  		goto drop;
>>  	}
>> +	if (ptr_ring_full(&tfile->tx_ring)) {
>> +		/* Paired with smp_rmb() in wake_netdev_queue. */
>> +		smp_wmb();
>> +		netif_tx_stop_queue(queue);
>> +	}
>>  
>>  	/* dev->lltx requires to do our own update of trans_start */
>> -	queue = netdev_get_tx_queue(dev, txq);
>>  	txq_trans_cond_update(queue);
>>  
>>  	/* Notify and wake up reader process */
>> @@ -2110,6 +2118,24 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>  	return total;
>>  }
>>  
>> +static inline void wake_netdev_queue(struct tun_file *tfile)
>> +{
>> +	struct netdev_queue *txq;
>> +	struct net_device *dev;
>> +
>> +	rcu_read_lock();
>> +	dev = rcu_dereference(tfile->tun)->dev;
>> +	txq = netdev_get_tx_queue(dev, tfile->queue_index);
>> +
>> +	if (netif_tx_queue_stopped(txq)) {
>> +		/* Paired with smp_wmb() in tun_net_xmit. */
>> +		smp_rmb();
>> +		if (ptr_ring_spare(&tfile->tx_ring, 1))
>> +			netif_tx_wake_queue(txq);
>> +	}
>> +	rcu_read_unlock();
>> +}
>> +
>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>  {
>>  	DECLARE_WAITQUEUE(wait, current);
>> @@ -2139,7 +2165,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>  			error = -EFAULT;
>>  			break;
>>  		}
>> -
>> +		wake_netdev_queue(tfile);
> 
> Why wake when no entry was consumed?

I do it because the queue may not have been woken the last time after
consuming an SKB. However, I am not sure if it is still absolutely
necessary after all the changes in the code. Still, I think it is wise to
do it to avoid being stuck in the wait queue under any circumstances.

> 
> Also keep the empty line.
>

Okay :)

>>  		schedule();
>>  	}
>>  
>> @@ -2147,6 +2173,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>  	remove_wait_queue(&tfile->socket.wq.wait, &wait);
>>  
>>  out:
>> +	wake_netdev_queue(tfile);
>>  	*err = error;
>>  	return ptr;
>>  }
>> -- 
>> 2.43.0
>>
> 
> 

