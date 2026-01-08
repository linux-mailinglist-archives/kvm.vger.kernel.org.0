Return-Path: <kvm+bounces-67358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD749D01DDD
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 10:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5D88A310F1C5
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 08:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA5839446E;
	Thu,  8 Jan 2026 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="UMp9Of1z"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0649366DAE;
	Thu,  8 Jan 2026 08:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767859347; cv=none; b=BPGA1UJ7/Nh/r3u9/+vGkXwf51RhC4f1umGVnePymQMpSLah0hS7jceye4FP+pFd+oO3ehLxe+ZFAgPP3UANNMEAD9DIfoooRTtTxrnh5t9IvOXJn/Z/Lm5PbRCK2IClVDFhTPdUVsfovxohfYTs7yyw2++Ut2dFGLAdpR0JmQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767859347; c=relaxed/simple;
	bh=IFeuOjD8hRs56JH5OH6esmLiSoXTdFIyx1pB3qoK6bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TGG3H/7AxgY7Okn0ZP4ROAXfY2kTUKmOfig9Aw4mnYgR6j+QGDx3IeNs7Io8EIXWF8SMfo3oay9PpljRHzgVpENz/NCa5Oz5sw8o0Ej/mTcdq1o3Y+eE+Vha8C1pcdJZa9rKY7zmHBeiTYXDDvaLSKfx1D1NGDHnsGMk2RVbpJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=UMp9Of1z; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.121] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 60881WCM021689
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 09:01:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767859294;
	bh=IFeuOjD8hRs56JH5OH6esmLiSoXTdFIyx1pB3qoK6bk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UMp9Of1z8yVW4cY2rEJpK3EGpW1/RoUxI0k4i9OCigiMcwa/J25XxWuqi8v1om9we
	 j2sInzMtZ8Qdfmajlhej7l3o3RcuV0OGG+0D8ArEX64f2pc5T2FXX6A0vYEN+wsvjC
	 CNCZYwfZ6A6nbKV2nATUZH0efC7h7+31qUw5VFdg=
Message-ID: <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
Date: Thu, 8 Jan 2026 09:01:32 +0100
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
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/8/26 05:37, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> This commit prevents tail-drop when a qdisc is present and the ptr_ring
>> becomes full. Once an entry is successfully produced and the ptr_ring
>> reaches capacity, the netdev queue is stopped instead of dropping
>> subsequent packets.
>>
>> If producing an entry fails anyways, the tun_net_xmit returns
>> NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected because
>> LLTX is enabled and the transmit path operates without the usual locking.
>> As a result, concurrent calls to tun_net_xmit() are not prevented.
>>
>> The existing __{tun,tap}_ring_consume functions free space in the
>> ptr_ring and wake the netdev queue. Races between this wakeup and the
>> queue-stop logic could leave the queue stopped indefinitely. To prevent
>> this, a memory barrier is enforced (as discussed in a similar
>> implementation in [1]), followed by a recheck that wakes the queue if
>> space is already available.
>>
>> If no qdisc is present, the previous tail-drop behavior is preserved.
>>
>> +-------------------------+-----------+---------------+----------------+
>> | pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
>> | Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
>> | 10M packets             |           |               |                |
>> +-----------+-------------+-----------+---------------+----------------+
>> | TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps       |
>> |           +-------------+-----------+---------------+----------------+
>> |           | Lost        | 1618 Kpps | 1556 Kpps     | 0              |
>> +-----------+-------------+-----------+---------------+----------------+
>> | TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps       |
>> |  +        +-------------+-----------+---------------+----------------+
>> | vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0              |
>> +-----------+-------------+-----------+---------------+----------------+
>>
>> [1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel.org/
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
>>  1 file changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 71b6981d07d7..74d7fd09e9ba 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>         struct netdev_queue *queue;
>>         struct tun_file *tfile;
>>         int len = skb->len;
>> +       bool qdisc_present;
>> +       int ret;
>>
>>         rcu_read_lock();
>>         tfile = rcu_dereference(tun->tfiles[txq]);
>> @@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>
>>         nf_reset_ct(skb);
>>
>> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
>> +       queue = netdev_get_tx_queue(dev, txq);
>> +       qdisc_present = !qdisc_txq_has_no_queue(queue);
>> +
>> +       spin_lock(&tfile->tx_ring.producer_lock);
>> +       ret = __ptr_ring_produce(&tfile->tx_ring, skb);
>> +       if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_present) {
>> +               netif_tx_stop_queue(queue);
>> +               /* Avoid races with queue wake-up in
>> +                * __{tun,tap}_ring_consume by waking if space is
>> +                * available in a re-check.
>> +                * The barrier makes sure that the stop is visible before
>> +                * we re-check.
>> +                */
>> +               smp_mb__after_atomic();
>> +               if (!__ptr_ring_produce_peek(&tfile->tx_ring))
>> +                       netif_tx_wake_queue(queue);
> 
> I'm not sure I will get here, but I think those should be moved to the
> following if(ret) check. If __ptr_ring_produce() succeed, there's no
> need to bother with those queue stop/wake logic?

There is a need for that. If __ptr_ring_produce_peek() returns -ENOSPC,
we stop the queue proactively.

I believe what you are aiming for is to always stop the queue if(ret),
which I can agree with. In that case, I would simply change the condition
to:

if (qdisc_present && (ret || __ptr_ring_produce_peek(&tfile->tx_ring)))

> 
>> +       }
>> +       spin_unlock(&tfile->tx_ring.producer_lock);
>> +
>> +       if (ret) {
>> +               /* If a qdisc is attached to our virtual device,
>> +                * returning NETDEV_TX_BUSY is allowed.
>> +                */
>> +               if (qdisc_present) {
>> +                       rcu_read_unlock();
>> +                       return NETDEV_TX_BUSY;
>> +               }
>>                 drop_reason = SKB_DROP_REASON_FULL_RING;
>>                 goto drop;
>>         }
>>
>>         /* dev->lltx requires to do our own update of trans_start */
>> -       queue = netdev_get_tx_queue(dev, txq);
>>         txq_trans_cond_update(queue);
>>
>>         /* Notify and wake up reader process */
>> --
>> 2.43.0
>>
> 
> Thanks
> 

