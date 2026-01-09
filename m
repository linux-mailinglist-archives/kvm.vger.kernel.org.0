Return-Path: <kvm+bounces-67551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 257D3D087A0
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 11:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FDAD303F0E5
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 10:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6223382E4;
	Fri,  9 Jan 2026 10:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="GXP9kHST"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EA632E732;
	Fri,  9 Jan 2026 10:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767953706; cv=none; b=qCSTNUajhmk79XHYFc/YzB6S3yrj2U5nhyk2kqEirUqkKykJxVrsbB4FPobU8FhO4e/1dDPwjh0pEmGMac5FQWFCQMpXFSQ1FgBHGt8JYyTNBsePtEk1t+XpAZt1n7FLZIzzjdNbIGBgafn6zd9XIC7EdjrsXlx58Ntkh4oJGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767953706; c=relaxed/simple;
	bh=o7JZKnKjaE69MTIhA9EF55nlKQYXzW6zANd0/gTwhds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qde/nN9w/72DnEgL+K48A+d8i8GzuiC6BHYuFwXQYmJYZHsgPoHrU3NPH9RAbBd+HdrBwRV+EVcNZllMotgTrm9PhPUewb+gHrien31R/8pzCSeLWNOyjC6U5hKS4fZs6QJF4WdMePeRXQL2MbSfYAJoIdtug8kME2voMOGoLSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=GXP9kHST; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.165] ([129.217.186.165])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 609AEsWt003313
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Jan 2026 11:14:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767953695;
	bh=o7JZKnKjaE69MTIhA9EF55nlKQYXzW6zANd0/gTwhds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GXP9kHSTN96tyHIbLuG+YZD3/mt0iz1I0EFcEetx3SCrvbAGGmoA+xpesYfSArqss
	 9Rtv1DtbTrhfUSQRhy3+zRbDYgaOpeaoG8FYzTwplvLFhAXTMAyavRGimTtYAfovAU
	 qTAMhF85wHOtgLHFSDFyWj+cBM2+CT5bpXDYk1EI=
Message-ID: <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>
Date: Fri, 9 Jan 2026 11:14:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 9/9] tun/tap & vhost-net: avoid ptr_ring tail-drop
 when qdisc is present
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
 <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
 <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
 <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/9/26 07:09, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 4:02 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> On 1/8/26 05:37, Jason Wang wrote:
>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>
>>>> This commit prevents tail-drop when a qdisc is present and the ptr_ring
>>>> becomes full. Once an entry is successfully produced and the ptr_ring
>>>> reaches capacity, the netdev queue is stopped instead of dropping
>>>> subsequent packets.
>>>>
>>>> If producing an entry fails anyways, the tun_net_xmit returns
>>>> NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected because
>>>> LLTX is enabled and the transmit path operates without the usual locking.
>>>> As a result, concurrent calls to tun_net_xmit() are not prevented.
>>>>
>>>> The existing __{tun,tap}_ring_consume functions free space in the
>>>> ptr_ring and wake the netdev queue. Races between this wakeup and the
>>>> queue-stop logic could leave the queue stopped indefinitely. To prevent
>>>> this, a memory barrier is enforced (as discussed in a similar
>>>> implementation in [1]), followed by a recheck that wakes the queue if
>>>> space is already available.
>>>>
>>>> If no qdisc is present, the previous tail-drop behavior is preserved.
>>>>
>>>> +-------------------------+-----------+---------------+----------------+
>>>> | pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
>>>> | Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
>>>> | 10M packets             |           |               |                |
>>>> +-----------+-------------+-----------+---------------+----------------+
>>>> | TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps       |
>>>> |           +-------------+-----------+---------------+----------------+
>>>> |           | Lost        | 1618 Kpps | 1556 Kpps     | 0              |
>>>> +-----------+-------------+-----------+---------------+----------------+
>>>> | TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps       |
>>>> |  +        +-------------+-----------+---------------+----------------+
>>>> | vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0              |
>>>> +-----------+-------------+-----------+---------------+----------------+
>>>>
>>>> [1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel.org/
>>>>
>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>> ---
>>>>  drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
>>>>  1 file changed, 29 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>> index 71b6981d07d7..74d7fd09e9ba 100644
>>>> --- a/drivers/net/tun.c
>>>> +++ b/drivers/net/tun.c
>>>> @@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>         struct netdev_queue *queue;
>>>>         struct tun_file *tfile;
>>>>         int len = skb->len;
>>>> +       bool qdisc_present;
>>>> +       int ret;
>>>>
>>>>         rcu_read_lock();
>>>>         tfile = rcu_dereference(tun->tfiles[txq]);
>>>> @@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>
>>>>         nf_reset_ct(skb);
>>>>
>>>> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
>>>> +       queue = netdev_get_tx_queue(dev, txq);
>>>> +       qdisc_present = !qdisc_txq_has_no_queue(queue);
>>>> +
>>>> +       spin_lock(&tfile->tx_ring.producer_lock);
>>>> +       ret = __ptr_ring_produce(&tfile->tx_ring, skb);
>>>> +       if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_present) {
>>>> +               netif_tx_stop_queue(queue);
>>>> +               /* Avoid races with queue wake-up in
>>>> +                * __{tun,tap}_ring_consume by waking if space is
>>>> +                * available in a re-check.
>>>> +                * The barrier makes sure that the stop is visible before
>>>> +                * we re-check.
>>>> +                */
>>>> +               smp_mb__after_atomic();
>>>> +               if (!__ptr_ring_produce_peek(&tfile->tx_ring))
>>>> +                       netif_tx_wake_queue(queue);
>>>
>>> I'm not sure I will get here, but I think those should be moved to the
>>> following if(ret) check. If __ptr_ring_produce() succeed, there's no
>>> need to bother with those queue stop/wake logic?
>>
>> There is a need for that. If __ptr_ring_produce_peek() returns -ENOSPC,
>> we stop the queue proactively.
> 
> This seems to conflict with the following NETDEV_TX_BUSY. Or is
> NETDEV_TX_BUSY prepared for the xdp_xmit?

Am I not allowed to stop the queue and then return NETDEV_TX_BUSY?
And I do not understand the connection with xdp_xmit.

> 
>>
>> I believe what you are aiming for is to always stop the queue if(ret),
>> which I can agree with. In that case, I would simply change the condition
>> to:
>>
>> if (qdisc_present && (ret || __ptr_ring_produce_peek(&tfile->tx_ring)))
>>
>>>
>>>> +       }
>>>> +       spin_unlock(&tfile->tx_ring.producer_lock);
>>>> +
>>>> +       if (ret) {
>>>> +               /* If a qdisc is attached to our virtual device,
>>>> +                * returning NETDEV_TX_BUSY is allowed.
>>>> +                */
>>>> +               if (qdisc_present) {
>>>> +                       rcu_read_unlock();
>>>> +                       return NETDEV_TX_BUSY;
>>>> +               }
>>>>                 drop_reason = SKB_DROP_REASON_FULL_RING;
>>>>                 goto drop;
>>>>         }
>>>>
>>>>         /* dev->lltx requires to do our own update of trans_start */
>>>> -       queue = netdev_get_tx_queue(dev, txq);
>>>>         txq_trans_cond_update(queue);
>>>>
>>>>         /* Notify and wake up reader process */
>>>> --
>>>> 2.43.0
>>>>
>>>
>>> Thanks
>>>
>>
> 
> Thanks
> 

