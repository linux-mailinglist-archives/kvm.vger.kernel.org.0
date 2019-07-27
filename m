Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D887772B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 08:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfG0GOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 02:14:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34968 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfG0GOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 02:14:01 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 08A0BF04ED6C5744E314;
        Sat, 27 Jul 2019 14:13:59 +0800 (CST)
Received: from [127.0.0.1] (10.177.19.122) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 27 Jul 2019
 14:13:56 +0800
Subject: Re: [PATCH 1/3] KVM: arm/arm64: vgic-its: Introduce multiple LPI
 translation caches
To:     Marc Zyngier <marc.zyngier@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
 <20190724090437.49952-2-xiexiangyou@huawei.com>
 <a8b74b25-8c92-4aad-f94d-8371126798ef@arm.com>
 <c0f441b5-2ba2-0482-6736-eb7835a24f0a@huawei.com>
 <86blxhne2s.wl-marc.zyngier@arm.com>
From:   Xiangyou Xie <xiexiangyou@huawei.com>
Message-ID: <0db37e66-4a5c-f6e7-65e2-c95fcbc4ee3b@huawei.com>
Date:   Sat, 27 Jul 2019 14:13:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <86blxhne2s.wl-marc.zyngier@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Adding a new lpi to lpi_list, the contents of the caches will not be 
updated immediately until the irq is injected.

Irq's reference count will be increased when synchronized to each cache, 
and reduced after deleting from each cache. Only when irq is removed 
from all caches, the reference count is reduced to 0, which is allowed 
to be removed from lpi_list.

So I think that the reference count of IRQ can guarantee the consistency 
of lpi_list and cache, is right?

When multiple CPUs inject different lpi interrupts at the same time, 
which may result in different sorts of interrupts in different caches, 
even some interrupts of a certain cache are overflowed.
Eg:
The contents of the cache at a certain moment：
cache 0: c->b->a
cache 1: a->b->c

Then, inject two interrupts "d,e" simultaneously, the following results 
may occur:
cache 0: e->d->c
cache 1: d->e->a

But this is no problem, just make sure that the irq found is correct.

In addition, about Locking order:
kvm->lock (mutex)
   its->cmd_lock (mutex)
     its->its_lock (mutex)
       vgic_cpu->ap_list_lock
         cache->lpi_cache_lock  /**/
            kvm->lpi_list_lock	
              vgic_irq->irq_lock	

Thanks,

Xiangyou.

On 2019/7/26 21:02, Marc Zyngier wrote:
> On Fri, 26 Jul 2019 13:35:20 +0100,
> Xiangyou Xie <xiexiangyou@huawei.com> wrote:
>>
>> Hi Marc,
>>
>> Sorry, the test data was not posted in the previous email.
>>
>> I tested the impact of virtual interrupt injection time-consuming：
>> Run the iperf command to send UDP packets to the VM:
>> 	iperf -c $IP -u -b 40m -l 64 -t 6000&
>> The vm just receive UDP traffic. When configure multiple NICs, each
>> NIC receives the above iperf UDP traffic, This may reflect the
>> performance impact of shared resource competition, such as lock.
>>
>> Observing the delay of virtual interrupt injection: the time spent by
>> the "irqfd_wakeup", "irqfd_inject" function, and kworker context
>> switch.
>> The less the better.
>>
>> ITS translation cache greatly reduces the delay of interrupt injection
>> compared to kworker thread, because it eliminate wakeup and uncertain
>> scheduling delay:
>>                    kworker              ITS translation cache    improved
>>    1 NIC           6.692 us                 1.766 us
>> 73.6%
>>   10 NICs          7.536 us                 2.574 us
>> 65.8%
> 
> OK, that's pretty interesting. It would have been good to post such
> data in reply to the ITS cache series.
> 
>>
>> Increases the number of lpi_translation_cache reduce lock competition.
>> Multi-interrupt concurrent injections perform better:
>>
>>              ITS translation cache      with patch             improved
>>     1 NIC        1.766 us                 1.694 us                4.1%
>>   10 NICs        2.574 us                 1.848 us               28.2%
> 
> 
> That's sort off interesting too, but it doesn't answer any of the
> questions I had in response to your patch: How do you ensure mutual
> exclusion with the LPI list being concurrently updated? How does the
> new locking fit in the current locking scheme?
> 
> Thanks,
> 
> 	M.
> 
>> Regards,
>>
>> Xiangyou
>>
>> On 2019/7/24 19:09, Marc Zyngier wrote:
>>> Hi Xiangyou,
>>>
>>> On 24/07/2019 10:04, Xiangyou Xie wrote:
>>>> Because dist->lpi_list_lock is a perVM lock, when a virtual machine
>>>> is configured with multiple virtual NIC devices and receives
>>>> network packets at the same time, dist->lpi_list_lock will become
>>>> a performance bottleneck.
>>>
>>> I'm sorry, but you'll have to show me some real numbers before I
>>> consider any of this. There is a reason why the original series still
>>> isn't in mainline, and that's because people don't post any numbers.
>>> Adding more patches is not going to change that small fact.
>>>
>>>> This patch increases the number of lpi_translation_cache to eight,
>>>> hashes the cpuid that executes irqfd_wakeup, and chooses which
>>>> lpi_translation_cache to use.
>>>
>>> So you've now switched to a per-cache lock, meaning that the rest of the
>>> ITS code can manipulate the the lpi_list without synchronization with
>>> the caches. Have you worked out all the possible races? Also, how does
>>> this new lock class fits in the whole locking hierarchy?
>>>
>>> If you want something that is actually scalable, do it the right way.
>>> Use a better data structure than a list, switch to using RCU rather than
>>> the current locking strategy. But your current approach looks quite fragile.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>
> 

