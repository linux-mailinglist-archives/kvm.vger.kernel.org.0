Return-Path: <kvm+bounces-64087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0153C78303
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 10:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id D3AB532F9D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795403081C6;
	Fri, 21 Nov 2025 09:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="IuvGVpB0"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571E533C519;
	Fri, 21 Nov 2025 09:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717012; cv=none; b=Y5qtItLOa47Ygq8y4TvfayHM61im1ijlfyq4gLPSC/cu0uFZNoyM+u5T2NgVqVpvfGgf8LTX7coUOHUNUZbNp/UzCl2nXGJb+LrdGDYuD+aS+/wc6UK5ETdef+EENipyM4mFul8oX50FOBna68bzacAScnr0aqtaDT/7gsYNoiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717012; c=relaxed/simple;
	bh=+5r5M+XjdNfDZF30/xVMNjtVt/AXHifID6EEEYPo0vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EbraUMHeGy8wQGuF+9pIARlPaAhKSOMfamQetOvdeZ4Gsyq7Z9VVrGrjrbqHv+T3yXsrHiNdOUxb9U1jZJcNvRG+SVqWUGXknbElAFW1VBId2ITEHOr/YQiMUE1hAqz3Z/7/hBET8zTb9Cxx5JSPB6bVm2lgScbhZW56lQra7ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=IuvGVpB0; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.248] ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AL9MsJG001806
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 21 Nov 2025 10:22:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1763716975;
	bh=+5r5M+XjdNfDZF30/xVMNjtVt/AXHifID6EEEYPo0vo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IuvGVpB07VG27ZINKrgDMTA4P73PHOzA7V25P23FKBnR1i0KwG7h4v4TSjlXncbtI
	 cloKvi/kJwGyEFemOy1PI9PuLbuPhzYEKQJRm73haUYW/qO9NHu/I/n4GSIIAcvO9H
	 4rusZGlWB2wfvEDid7EQo4nTgG6UEex29KfcDhZ4=
Message-ID: <b9fff8e1-fb96-4b1f-9767-9d89adf31060@tu-dortmund.de>
Date: Fri, 21 Nov 2025 10:22:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v6 0/8] tun/tap & vhost-net: netdev queue flow
 control to avoid ptr_ring tail drop
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <CACGkMEuboys8sCJFUTGxHUeouPFnVqVLGQBefvmxYDe4ooLfLg@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEuboys8sCJFUTGxHUeouPFnVqVLGQBefvmxYDe4ooLfLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/21/25 07:19, Jason Wang wrote:
> On Thu, Nov 20, 2025 at 11:30 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> This patch series deals with tun/tap and vhost-net which drop incoming
>> SKBs whenever their internal ptr_ring buffer is full. Instead, with this
>> patch series, the associated netdev queue is stopped before this happens.
>> This allows the connected qdisc to function correctly as reported by [1]
>> and improves application-layer performance, see our paper [2]. Meanwhile
>> the theoretical performance differs only slightly:
>>
>> +--------------------------------+-----------+----------+
>> | pktgen benchmarks to Debian VM | Stock     | Patched  |
>> | i5 6300HQ, 20M packets         |           |          |
>> +-----------------+--------------+-----------+----------+
>> | TAP             | Transmitted  | 195 Kpps  | 183 Kpps |
>> |                 +--------------+-----------+----------+
>> |                 | Lost         | 1615 Kpps | 0 pps    |
>> +-----------------+--------------+-----------+----------+
>> | TAP+vhost_net   | Transmitted  | 589 Kpps  | 588 Kpps |
>> |                 +--------------+-----------+----------+
>> |                 | Lost         | 1164 Kpps | 0 pps    |
>> +-----------------+--------------+-----------+----------+
> 

Hi Jason,

thank you for your reply!

> PPS drops somehow for TAP, any reason for that?

I have no explicit explanation for that except general overheads coming
with this implementation.

> 
> Btw, I had some questions:
> 
> 1) most of the patches in this series would introduce non-trivial
> impact on the performance, we probably need to benchmark each or split
> the series. What's more we need to run TCP benchmark
> (throughput/latency) as well as pktgen see the real impact

What could be done, IMO, is to activate tun_ring_consume() /
tap_ring_consume() before enabling tun_ring_produce(). Then we could see
if this alone drops performance.

For TCP benchmarks, you mean userspace performance like iperf3 between a
host and a guest system?

> 
> 2) I see this:
> 
>         if (unlikely(tun_ring_produce(&tfile->tx_ring, queue, skb))) {
>                 drop_reason = SKB_DROP_REASON_FULL_RING;
>                 goto drop;
>         }
> 
> So there could still be packet drop? Or is this related to the XDP path?

Yes, there can be packet drops after a ptr_ring resize or a ptr_ring
unconsume. Since those two happen so rarely, I figured we should just
drop in this case.

> 
> 3) The LLTX change would have performance implications, but the
> benmark doesn't cover the case where multiple transmission is done in
> parallel

Do you mean multiple applications that produce traffic and potentially
run on different CPUs?

> 
> 4) After the LLTX change, it seems we've lost the synchronization with
> the XDP_TX and XDP_REDIRECT path?

I must admit I did not take a look at XDP and cannot really judge if/how
lltx has an impact on XDP. But from my point of view, __netif_tx_lock()
instead of __netif_tx_acquire(), is executed before the tun_net_xmit()
call and I do not see the impact for XDP, which calls its own methods.
> 
> 5) The series introduces various ptr_ring helpers with lots of
> ordering stuff which is complicated, I wonder if we first have a
> simple patch to implement the zero packet loss

I personally don't see how a simpler patch is possible without using
discouraged practices like returning NETDEV_TX_BUSY in tun_net_xmit or
spin locking between producer and consumer. But I am open for
suggestions :)

> 
>>
>> This patch series includes tun/tap, and vhost-net because they share
>> logic. Adjusting only one of them would break the others. Therefore, the
>> patch series is structured as follows:
>> 1+2: new ptr_ring helpers for 3
>> 3: tun/tap: tun/tap: add synchronized ring produce/consume with queue
>> management
>> 4+5+6: tun/tap: ptr_ring wrappers and other helpers to be called by
>> vhost-net
>> 7: tun/tap & vhost-net: only now use the previous implemented functions to
>> not break git bisect
>> 8: tun/tap: drop get ring exports (not used anymore)
>>
>> Possible future work:
>> - Introduction of Byte Queue Limits as suggested by Stephen Hemminger
> 
> This seems to be not easy. The tx completion depends on the userspace behaviour.

I agree, but I really would like to reduce the buffer bloat caused by the
default 500 TUN / 1000 TAP packet queue without losing performance.

> 
>> - Adaption of the netdev queue flow control for ipvtap & macvtap
>>
>> [1] Link: https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
>> [2] Link: https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf
>>
> 
> Thanks
> 

Thanks! :)

