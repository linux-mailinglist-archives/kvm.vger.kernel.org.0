Return-Path: <kvm+bounces-56695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C276B428E6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 20:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B47DB567BD2
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 18:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D61E3680B5;
	Wed,  3 Sep 2025 18:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="irlYrNXv"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A4536809A;
	Wed,  3 Sep 2025 18:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756924879; cv=none; b=c4DDgGVfxpql/stysxNbo/Wpches84ifr8yagxAj2tMxoUMZZVc9EGn6B12ccmUErYoDzABFzgGDdw/c0ZQ1ubD3vCLUO2Ox50AL5sEOiyaPmRI95qgpelQo4MjX/pEZbEBa1XkT/yswVRoT9cSwGgtD4wkvqtysG3vGcH99cyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756924879; c=relaxed/simple;
	bh=Ip015v/MOLOEKjzsQleLXVJ1B2w11tmT7ymbH/ex5X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUiLx99aOCjHngeDS7uoZM8uz4zbU96ZWDoklK3AWXM824hLq6CsHUHAXkLaMUITBsFGXz/Ka3c6ZwhCiXnoMMR1e1isB3D/ZSS6eWDMVkEyYAg4jFxFeE5kPUe0fDSxz25MvKM3CHM30ga0N0aE2Ipfkio4GKxenOHdxmWDgTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=irlYrNXv; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (pd9eaae6b.dip0.t-ipconnect.de [217.234.174.107])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 583IfCfw016435
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Sep 2025 20:41:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756924873;
	bh=Ip015v/MOLOEKjzsQleLXVJ1B2w11tmT7ymbH/ex5X8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=irlYrNXvXhk+mYZTYLn0JyKYnWyFM0YHnpSr6APPUnsEDopxKyipnePqVF3vSi+YA
	 7kdLVtNKxJjXewgkSFmlBRvg/7+N3QMB1ujSQO5ph3+np4C5ufE/jaIylc4hI7UeMZ
	 aQ3RlPoLqGpTmFYHFV6Od8P57v5T3OFzMULpI2n4=
Message-ID: <c0f1aa5d-88b2-4e7e-801b-b4a7c8679aa9@tu-dortmund.de>
Date: Wed, 3 Sep 2025 20:41:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/4] netdev queue flow control for TUN
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, mst@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
 <CACGkMEssRJDZht3vTR1KRArQLWi-rLU4b5_8+kAgz4uc0wuQgA@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEssRJDZht3vTR1KRArQLWi-rLU4b5_8+kAgz4uc0wuQgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Jason Wang wrote:
> On Tue, Sep 2, 2025 at 4:10 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> The netdev queue is stopped in tun_net_xmit after inserting an SKB into
>> the ring buffer if the ring buffer became full because of that. If the
>> insertion into the ptr_ring fails, the netdev queue is also stopped and
>> the SKB is dropped. However, this never happened in my testing.
> 
> You can reach this by using pktgen on TUN.
> 

Yes, and I think it could also be reached after ptr_ring_unconsume is
called in vhost_net.

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
>>         nf_reset_ct(skb);
>>
>> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
>> +       queue = netdev_get_tx_queue(dev, txq);
>> +       if (unlikely(ptr_ring_produce(&tfile->tx_ring, skb))) {
>> +               /* Paired with smp_rmb() in wake_netdev_queue. */
>> +               smp_wmb();
>> +               netif_tx_stop_queue(queue);
> 
> The barrier looks odd since it requires the driver to care about the
> ordering, can you elaborate more on this?
> 
> There's a WRITE_ONCE + mb() in netif_tx_stop_queue already:
> 
> static __always_inline void netif_tx_stop_queue(struct netdev_queue *dev_queue)
> {
>         /* Paired with READ_ONCE() from dev_watchdog() */
>         WRITE_ONCE(dev_queue->trans_start, jiffies);
> 
>         /* This barrier is paired with smp_mb() from dev_watchdog() */
>         smp_mb__before_atomic();
> 
>         /* Must be an atomic op see netif_txq_try_stop() */
>         set_bit(__QUEUE_STATE_DRV_XOFF, &dev_queue->state);
> }
> 
>>                 drop_reason = SKB_DROP_REASON_FULL_RING;
>>                 goto drop;
>>         }
>> +       if (ptr_ring_full(&tfile->tx_ring)) {
>> +               /* Paired with smp_rmb() in wake_netdev_queue. */
>> +               smp_wmb();
>> +               netif_tx_stop_queue(queue);
>> +       }
>>
>>         /* dev->lltx requires to do our own update of trans_start */
>> -       queue = netdev_get_tx_queue(dev, txq);
>>         txq_trans_cond_update(queue);
>>
>>         /* Notify and wake up reader process */
>> @@ -2110,6 +2118,24 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>         return total;
>>  }
>>
>> +static inline void wake_netdev_queue(struct tun_file *tfile)
> 
> Let's rename this to tun_wake_xxx.
>

Okay. I will rename wake_netdev_queue to tun_wake_netdev_queue and
tap_wake_netdev_queue respectively and remove inline. Then vhost_net just
calls these methods in vhost_net_buf_produce with file->private_data.

>> +{
>> +       struct netdev_queue *txq;
>> +       struct net_device *dev;
>> +
>> +       rcu_read_lock();
>> +       dev = rcu_dereference(tfile->tun)->dev;
>> +       txq = netdev_get_tx_queue(dev, tfile->queue_index);
>> +
>> +       if (netif_tx_queue_stopped(txq)) {
>> +               /* Paired with smp_wmb() in tun_net_xmit. */
>> +               smp_rmb();
>> +               if (ptr_ring_spare(&tfile->tx_ring, 1))
> 
> I wonder if there would be a case that will use cnt > 1. If not a
> ptr_ring_can_produce() should be sufficient.
> 
>> +                       netif_tx_wake_queue(txq);
>> +       }
>> +       rcu_read_unlock();
>> +}
>> +
>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>  {
>>         DECLARE_WAITQUEUE(wait, current);
>> @@ -2139,7 +2165,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>                         error = -EFAULT;
>>                         break;
>>                 }
>> -
>> +               wake_netdev_queue(tfile);
>>                 schedule();
>>         }
>>
>> @@ -2147,6 +2173,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>         remove_wait_queue(&tfile->socket.wq.wait, &wait);
>>
>>  out:
>> +       wake_netdev_queue(tfile);
>>         *err = error;
>>         return ptr;
>>  }
>> --
>> 2.43.0
>>
> 
> Thanks
> 

