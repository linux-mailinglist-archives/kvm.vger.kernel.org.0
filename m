Return-Path: <kvm+bounces-58610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 468BDB9854B
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F40754C353C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 06:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C184E241673;
	Wed, 24 Sep 2025 05:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="W9850TNI"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EA8C141;
	Wed, 24 Sep 2025 05:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758693596; cv=none; b=BGp0t6Lnl0e3QuEebDkmWXhLEOD+q6+xnDKWL6rD7dvm958Oy17CbS4yLC9UceUr4y8hJP47Z6jj0B5DdqTuxO6ykJKS7nV549/Ysod1zAwGyXvZbY+FjU4q4xm1GR1wSh0XU/JGt7dCFJQK6vme4KVPQbI7yGuYWU9B0+z0Dhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758693596; c=relaxed/simple;
	bh=N2MGgVh3FQGohtqhW0fhGVQOd6N06pK4oL5dFsa3MZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=udhG4LUz1lg8qHNCmcZM5Up7j8LY0XHIj481LUUyxpTTe/BD/fqqvyKkHzPMqw43kC8AiJYU42eneNUeVavlhwHtUQj8IiNfVy3rm1l+qtC/y4J2/uZZKaGHaGLZLjYJkdKv8zxzAXkY1v3GgaxDpUF2tS9RL7BldJ818FNn9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=W9850TNI; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [IPV6:2a01:599:c11:dc72:32f8:2997:5bae:168a] (tmo-123-4.customers.d1-online.com [80.187.123.4])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58O5xkO8020717
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 07:59:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758693587;
	bh=N2MGgVh3FQGohtqhW0fhGVQOd6N06pK4oL5dFsa3MZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W9850TNIaMIc0VoXTP2OIKP2SMr62bBBkcBJxATnh10lO6SaJrvucmmzYGEH9J1fa
	 WjL92bHKsvKmMhntMlNzps1dqcW4CIOlec4c9Vd8uIITOl+PSJ8+2CWT49N2w8WcLh
	 L1mGHE423T54HZHRSbjqqIDzp3uAkQpx3/CohHYU=
Message-ID: <96058e18-bb1e-46d1-99aa-9fdffb965e44@tu-dortmund.de>
Date: Wed, 24 Sep 2025 07:59:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, leiyang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250923105531-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20250923105531-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23.09.25 16:55, Michael S. Tsirkin wrote:
> On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
>> This patch series deals with TUN, TAP and vhost_net which drop incoming 
>> SKBs whenever their internal ptr_ring buffer is full. Instead, with this 
>> patch series, the associated netdev queue is stopped before this happens. 
>> This allows the connected qdisc to function correctly as reported by [1] 
>> and improves application-layer performance, see our paper [2]. Meanwhile 
>> the theoretical performance differs only slightly:
>>
>> +------------------------+----------+----------+
>> | pktgen benchmarks      | Stock    | Patched  |
>> | i5 6300HQ, 20M packets |          |          |
>> +------------------------+----------+----------+
>> | TAP                    | 2.10Mpps | 1.99Mpps |
>> +------------------------+----------+----------+
>> | TAP+vhost_net          | 6.05Mpps | 6.14Mpps |
>> +------------------------+----------+----------+
>> | Note: Patched had no TX drops at all,        |
>> | while stock suffered numerous drops.         |
>> +----------------------------------------------+
>>
>> This patch series includes TUN, TAP, and vhost_net because they share 
>> logic. Adjusting only one of them would break the others. Therefore, the 
>> patch series is structured as follows:
>> 1+2: New ptr_ring helpers for 3 & 4
>> 3: TUN & TAP: Stop netdev queue upon reaching a full ptr_ring
> 
> 
> so what happens if you only apply patches 1-3?
> 

The netdev queue of vhost_net would be stopped by tun_net_xmit but will
never be woken again.

>> 4: TUN & TAP: Wake netdev queue after consuming an entry
>> 5+6+7: TUN & TAP: ptr_ring wrappers and other helpers to be called by 
>> vhost_net
>> 8: vhost_net: Call the wrappers & helpers
>>
>> Possible future work:
>> - Introduction of Byte Queue Limits as suggested by Stephen Hemminger
>> - Adaption of the netdev queue flow control for ipvtap & macvtap
>>
>> [1] Link: 
>> https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
>> [2] Link: 
>> https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf
>>
>> Links to previous versions:
>> V4: 
>> https://lore.kernel.org/netdev/20250902080957.47265-1-simon.schippers@tu-dortmund.de/T/#u
>> V3: 
>> https://lore.kernel.org/netdev/20250825211832.84901-1-simon.schippers@tu-dortmund.de/T/#u
>> V2: 
>> https://lore.kernel.org/netdev/20250811220430.14063-1-simon.schippers@tu-dortmund.de/T/#u
>> V1: 
>> https://lore.kernel.org/netdev/20250808153721.261334-1-simon.schippers@tu-dortmund.de/T/#u
>>
>> Changelog:
>> V4 -> V5:
>> - Stop the netdev queue prior to producing the final fitting ptr_ring entry
>> -> Ensures the consumer has the latest netdev queue state, making it safe 
>> to wake the queue
>> -> Resolves an issue in vhost_net where the netdev queue could remain 
>> stopped despite being empty
>> -> For TUN/TAP, the netdev queue no longer needs to be woken in the 
>> blocking loop
>> -> Introduces new helpers __ptr_ring_full_next and 
>> __ptr_ring_will_invalidate for this purpose
>>
>> - vhost_net now uses wrappers of TUN/TAP for ptr_ring consumption rather 
>> than maintaining its own rx_ring pointer
>>
>> V3 -> V4:
>> - Target net-next instead of net
>> - Changed to patch series instead of single patch
>> - Changed to new title from old title
>> "TUN/TAP: Improving throughput and latency by avoiding SKB drops"
>> - Wake netdev queue with new helpers wake_netdev_queue when there is any 
>> spare capacity in the ptr_ring instead of waiting for it to be empty
>> - Use tun_file instead of tun_struct in tun_ring_recv as a more consistent 
>> logic
>> - Use smp_wmb() and smp_rmb() barrier pair, which avoids any packet drops 
>> that happened rarely before
>> - Use safer logic for vhost_net using RCU read locks to access TUN/TAP data
>>
>> V2 -> V3: Added support for TAP and TAP+vhost_net.
>>
>> V1 -> V2: Removed NETDEV_TX_BUSY return case in tun_net_xmit and removed 
>> unnecessary netif_tx_wake_queue in tun_ring_recv.
>>
>> Thanks,
>> Simon :)
>>
>> Simon Schippers (8):
>>   __ptr_ring_full_next: Returns if ring will be full after next
>>     insertion
>>   Move the decision of invalidation out of __ptr_ring_discard_one
>>   TUN, TAP & vhost_net: Stop netdev queue before reaching a full
>>     ptr_ring
>>   TUN & TAP: Wake netdev queue after consuming an entry
>>   TUN & TAP: Provide ptr_ring_consume_batched wrappers for vhost_net
>>   TUN & TAP: Provide ptr_ring_unconsume wrappers for vhost_net
>>   TUN & TAP: Methods to determine whether file is TUN/TAP for vhost_net
>>   vhost_net: Replace rx_ring with calls of TUN/TAP wrappers
>>
>>  drivers/net/tap.c        | 115 +++++++++++++++++++++++++++++++--
>>  drivers/net/tun.c        | 136 +++++++++++++++++++++++++++++++++++----
>>  drivers/vhost/net.c      |  90 +++++++++++++++++---------
>>  include/linux/if_tap.h   |  15 +++++
>>  include/linux/if_tun.h   |  18 ++++++
>>  include/linux/ptr_ring.h |  54 +++++++++++++---
>>  6 files changed, 367 insertions(+), 61 deletions(-)
>>
>> -- 
>> 2.43.0
> 

