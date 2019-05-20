Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFF23C55
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392239AbfETPjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:39:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731091AbfETPjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:39:08 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B3DDE3D7F03C0B6C5253;
        Mon, 20 May 2019 23:38:55 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 May 2019
 23:38:46 +0800
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
CC:     <christoffer.dall@arm.com>, <eric.auger@redhat.com>,
        <james.morse@arm.com>, <julien.thierry@arm.com>,
        <suzuki.poulose@arm.com>, <kvmarm@lists.cs.columbia.edu>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <kvm@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
 <86o969z42z.wl-marc.zyngier@arm.com>
 <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
 <20190515173832.62afdd90@donnerap.cambridge.arm.com>
 <864l5u7tla.wl-marc.zyngier@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f61ed9f7-2bfc-8d6d-fac7-efc6329e9726@huawei.com>
Date:   Mon, 20 May 2019 23:31:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <864l5u7tla.wl-marc.zyngier@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2019/5/16 15:21, Marc Zyngier wrote:
> Hi Andre,
> 
> On Wed, 15 May 2019 17:38:32 +0100,
> Andre Przywara <andre.przywara@arm.com> wrote:
>>
>> On Mon, 18 Mar 2019 13:30:40 +0000
>> Marc Zyngier <marc.zyngier@arm.com> wrote:
>>
>> Hi,
>>
>>> On Sun, 17 Mar 2019 19:35:48 +0000
>>> Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>
>>> [...]
>>>
>>>> A first approach would be to keep a small cache of the last few
>>>> successful translations for this ITS, cache that could be looked-up by
>>>> holding a spinlock instead. A hit in this cache could directly be
>>>> injected. Any command that invalidates or changes anything (DISCARD,
>>>> INV, INVALL, MAPC with V=0, MAPD with V=0, MOVALL, MOVI) should nuke
>>>> the cache altogether.
>>>
>>> And to explain what I meant with this, I've pushed a branch[1] with a
>>> basic prototype. It is good enough to get a VM to boot, but I wouldn't
>>> trust it for anything serious just yet.
>>>
>>> If anyone feels like giving it a go and check whether it has any
>>> benefit performance wise, please do so.
>>
>> So I took a stab at the performance aspect, and it took me a while to find
>> something where it actually makes a difference. The trick is to create *a
>> lot* of interrupts. This is my setup now:
>> - GICv3 and ITS
>> - 5.1.0 kernel vs. 5.1.0 plus Marc's rebased "ITS cache" patches on top
>> - 4 VCPU guest on a 4 core machine
>> - passing through a M.2 NVMe SSD (or a USB3 controller) to the guest
>> - running FIO in the guest, with:
>>    - 4K block size, random reads, queue depth 16, 4 jobs (small)
>>    - 1M block size, sequential reads, QD 1, 1 job (big)
>>
>> For the NVMe disk I see a whopping 19% performance improvement with Marc's
>> series (for the small blocks). For a SATA SSD connected via USB3.0 I still
>> see 6% improvement. For NVMe there were 50,000 interrupts per second on
>> the host, the USB3 setup came only up to 10,000/s. For big blocks (with
>> IRQs in the low thousands/s) the win is less, but still a measurable
>> 3%.
> 
> Thanks for having a go at this, and identifying the case where it
> actually matters (I would have hoped that the original reporter would
> have helped with this, but hey, never mind). The results are pretty
> impressive (more so than I anticipated), and I wonder whether we could
> improve things further (50k interrupts/s is not that high -- I get
> more than 100k on some machines just by playing with their sdcard...).

I think the "original reporter" must feel embarrassed now.
Actually, we had tested your patches (based on about 5.1.0-rc2) but
failed to see performance improvement. And I stopped to move on, and
then two months had gone... Oh sorry!

We retest your patches on 5.1.0, the result is as below.

Test setup:
- GICv3 and ITS (on Taishan 2280, D05)
- two 4-VCPU guests with vhost-net interface
- run iperf in guests:
    - guest1: iperf -s
    - guest2: iperf -c guest1-IP -t 10
- pin vcpu threads and vhost threads on the same NUMA node

Result:
+-----------------+--------------+-----------------------+
| Result          | interrupts/s | bandwidth (Gbits/sec) |
+-----------------+--------------+-----------------------+
| 5.1.0           |    25+ k     |    10.6 Gbits/sec     |
+-----------------+--------------+-----------------------+
| 5.1.0 (patched) |    40+ k     |    10.2 Gbits/sec     |
+-----------------+--------------+-----------------------+

We get "interrupts/s" from /proc/interrupts on iperf server, with stable
measured results. And we get "bandwidth" directly from iperf, but the
results are somewhat *instable*. And the results really confused me --
we received more interrupts but get a slight lower performance, why?

We configure the vhost-net interface with only one queue, so I think we
can rule out the spin-lock influence. And 'perf lock' confirmed this.
This is all that I can provide now, sorry if it's useless.

Also, one minor nit in code:
In vgic_its_cache_translation(), we use vgic_put_irq() to evict the LRU
cache entry, while we're already holding the lpi_list_lock. A deadlock
will be caused here. But this is easy to fix.


Anyway, we always have enough environments (e.g., D05, D06, ...) to do
some tests. If you want to do further tests on our boards, please let me
know :)


thanks,
zenghui

> Could you describe how many interrupt sources each device has? The
> reason I'm asking is that the cache size is pretty much hardcoded at
> the moment (4 entries per vcpu), and that could have an impact on
> performance if we keep evicting entries in the cache (note to self:
> add some statistics for that).
> 
> Another area where we can improve things is that I think the
> invalidation mechanism is pretty trigger happy (MOVI really doesn't
> need to invalidate the cache). On the other hand, I'm not sure your
> guest does too much of that.
> 
> Finally, the single cache spin-lock is bound to be a bottleneck of its
> own at high interrupt rates, and I wonder whether we should move the
> whole thing over to an RCU friendly data structure (the vgic_irq
> structure really isn't that friendly). It'd be good to find out how
> contended that spinlock is on your system.
> 
>> Now that I have the setup, I can rerun experiments very quickly (given I
>> don't loose access to the machine), so let me know if someone needs
>> further tests.
> 
> Another useful data point would be the delta with bare-metal: how much
> overhead do we have with KVM, with and without this patch series. Oh,
> and for easier comparison, please write it as a table that we can dump
> in the cover letter when I actually post the series! ;-)
> 
> Thanks,
> 
> 	M.
> 

