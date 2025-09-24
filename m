Return-Path: <kvm+bounces-58606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D629AB984BE
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD064C1D3C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 05:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E797F23908B;
	Wed, 24 Sep 2025 05:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="m0SCUKtU"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A6722F75B;
	Wed, 24 Sep 2025 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758692498; cv=none; b=jEriHN/eOVftmDr2CAOHtHvz5xhXIjoYVuf/d8YflymspJS0brQC8Myxl7/hhtwe2eTQg6w2SsUpLd2Al271swKGmhKFfcxvz5tYc16M2SuJNLeNNLslwUPd7w5FJ+D0MrARaDMftNiH+DohvHUP31CbmDqDfwPapZB8KjNyQuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758692498; c=relaxed/simple;
	bh=b5/KwQIxRa2W6DBLHfGTOY25AMH2zO7MTbk5nBe4IDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IYM6rKQMp6JQfIhj3NFdzOMeSGfIqIe5pxVfMshL1C04joJ3Ol9mGH72Jan4dzSrW+0gNaDCjH2TGQ4v/cbvaPQQARxZsWO6Rff08o1cfZBYj9UlQYBOXvIzmfIBz67ozThuOruW6j1GBPbWO1eyRz2U9vOjiqYpKIn1MA1/NCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=m0SCUKtU; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [IPV6:2a01:599:c11:dc72:32f8:2997:5bae:168a] (tmo-123-4.customers.d1-online.com [80.187.123.4])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58O5fTOL005992
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 07:41:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758692491;
	bh=b5/KwQIxRa2W6DBLHfGTOY25AMH2zO7MTbk5nBe4IDE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m0SCUKtUrzBbqH9oQ86ECQavDI2kae9gX8/D1JceqLnNBz5Phhc0fQhtqpD7N91Lx
	 LIyXAzG7rLByKiP3zBjd1HpiieWzySa9VKwipIACvDm+oT/WaaTq8Qrgd96DnVZIpR
	 c3ldEEu73A8o6++sAte/3YQN4Jpgv74nkouqD/84=
Message-ID: <71afbe18-3a5a-44ca-bb3b-b018f73ae8c6@tu-dortmund.de>
Date: Wed, 24 Sep 2025 07:41:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v5 3/8] TUN, TAP & vhost_net: Stop netdev queue
 before reaching a full ptr_ring
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, leiyang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-4-simon.schippers@tu-dortmund.de>
 <20250923104348-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20250923104348-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,
first of all thank you very much for your detailed replies! :)

On 23.09.25 16:47, Michael S. Tsirkin wrote:
> On Tue, Sep 23, 2025 at 12:15:48AM +0200, Simon Schippers wrote:
>> Stop the netdev queue ahead of __ptr_ring_produce when
>> __ptr_ring_full_next signals the ring is about to fill. Due to the
>> smp_wmb() of __ptr_ring_produce the consumer is guaranteed to be able to
>> notice the stopped netdev queue after seeing the new ptr_ring entry. As
>> both __ptr_ring_full_next and __ptr_ring_produce need the producer_lock,
>> the lock is held during the execution of both methods.
>>
>> dev->lltx is disabled to ensure that tun_net_xmit is not called even
>> though the netdev queue is stopped (which happened in my testing,
>> resulting in rare packet drops). Consequently, the update of trans_start
>> in tun_net_xmit is also removed.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  drivers/net/tun.c | 16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 86a9e927d0ff..c6b22af9bae8 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -931,7 +931,7 @@ static int tun_net_init(struct net_device *dev)
>>  	dev->vlan_features = dev->features &
>>  			     ~(NETIF_F_HW_VLAN_CTAG_TX |
>>  			       NETIF_F_HW_VLAN_STAG_TX);
>> -	dev->lltx = true;
>> +	dev->lltx = false;
>>  
>>  	tun->flags = (tun->flags & ~TUN_FEATURES) |
>>  		      (ifr->ifr_flags & TUN_FEATURES);
>> @@ -1060,14 +1060,18 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  
>>  	nf_reset_ct(skb);
>>  
>> -	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
>> +	queue = netdev_get_tx_queue(dev, txq);
>> +
>> +	spin_lock(&tfile->tx_ring.producer_lock);
>> +	if (__ptr_ring_full_next(&tfile->tx_ring))
>> +		netif_tx_stop_queue(queue);
>> +
>> +	if (unlikely(__ptr_ring_produce(&tfile->tx_ring, skb))) {
>> +		spin_unlock(&tfile->tx_ring.producer_lock);
>>  		drop_reason = SKB_DROP_REASON_FULL_RING;
>>  		goto drop;
>>  	}
> 
> The comment makes it sound like you always keep one slot free
> in the queue but that is not the case - you just
> check before calling __ptr_ring_produce.
> 

I agree.

> 
> But it is racy isn't it? So first of all I suspect you
> are missing an mb before netif_tx_stop_queue.
> 

I don’t really get this point right now.

> Second it's racy because more entries can get freed
> afterwards. Which maybe is ok in this instance?
> But it really should be explained in more detail, if so.
> 

Will be covered in the next mail.

> 
> 
> Now - why not just check ring full *after* __ptr_ring_produce?
> Why do we need all these new APIs, and we can
> use existing ones which at least are not so hard to understand.
> 
> 

You convinced me about changing my implementation anyway but here my (old) 
idea:
I did this in V1-V4. The problem is that vhost_net is only called on 
EPOLLIN triggered by tun_net_xmit. Then, after consuming a batch from the 
ptr_ring, it must be able to see if the netdev queue stopped or not. If 
this is not the case the ptr_ring might get empty and vhost_net is not 
able to wake the queue again (because it is not stopped from its POV), 
which happened in my testing in my V4.

This is the reason why, now in the V5, in tun_net_xmit I stop the netdev 
queue before producing. With that I exploit the smp_wmb() in 
__ptr_ring_produce which is paired with the READ_ONCE in __ptr_ring_peek 
to ensure that the consumer in vhost_net sees that the netdev queue 
stopped after consuming a batch.

> 
> 
>> -
>> -	/* dev->lltx requires to do our own update of trans_start */
>> -	queue = netdev_get_tx_queue(dev, txq);
>> -	txq_trans_cond_update(queue);
>> +	spin_unlock(&tfile->tx_ring.producer_lock);
>>  
>>  	/* Notify and wake up reader process */
>>  	if (tfile->flags & TUN_FASYNC)
>> -- 
>> 2.43.0
> 

