Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BE83388B1
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 10:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhCLJaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 04:30:08 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13883 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhCLJ3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 04:29:47 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DxgTR1Pjnz8x4g;
        Fri, 12 Mar 2021 17:27:55 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 17:29:35 +0800
Subject: Re: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device
 MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210122083650.21812-1-zhukeqian1@huawei.com>
 <87y2euf5d2.wl-maz@kernel.org>
 <e2a36913-2ded-71ff-d3ed-f7f8d831447c@huawei.com>
 <87o8fog3et.wl-maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <e0859e30-a4ca-7456-385e-c9efd914e1e4@huawei.com>
Date:   Fri, 12 Mar 2021 17:29:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87o8fog3et.wl-maz@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/3/12 16:52, Marc Zyngier wrote:
> On Thu, 11 Mar 2021 14:28:17 +0000,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>> Hi Marc,
>>
>> On 2021/3/11 16:43, Marc Zyngier wrote:
>>> Digging this patch back from my Inbox...
>> Yeah, thanks ;-)
>>
>>>
>>> On Fri, 22 Jan 2021 08:36:50 +0000,
>>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>>>
>>>> The MMIO region of a device maybe huge (GB level), try to use block
>>>> mapping in stage2 to speedup both map and unmap.
[...]

>>>>  			break;
>>>>  
>>>> -		pa += PAGE_SIZE;
>>>> +		pa += pgsize;
>>>>  	}
>>>>  
>>>>  	kvm_mmu_free_memory_cache(&cache);
>>>
>>> There is one issue with this patch, which is that it only does half
>>> the job. A VM_PFNMAP VMA can definitely be faulted in dynamically, and
>>> in that case we force this to be a page mapping. This conflicts with
>>> what you are doing here.
>> Oh yes, these two paths should keep a same mapping logic.
>>
>> I try to search the "force_pte" and find out some discussion [1]
>> between you and Christoffer.  And I failed to get a reason about
>> forcing pte mapping for device MMIO region (expect that we want to
>> keep a same logic with the eager mapping path). So if you don't
>> object to it, I will try to implement block mapping for device MMIO
>> in user_mem_abort().
>>
>>>
>>> There is also the fact that if we can map things on demand, why are we
>>> still mapping these MMIO regions ahead of time?
>>
>> Indeed. Though this provides good *startup* performance for guest
>> accessing MMIO, it's hard to keep the two paths in sync. We can keep
>> this minor optimization or delete it to avoid hard maintenance,
>> which one do you prefer?
> 
> I think we should be able to get rid of the startup path. If we can do
> it for memory, I see no reason not to do it for MMIO.
OK, I will do.

> 
>> BTW, could you please have a look at my another patch series[2]
>> about HW/SW combined dirty log? ;)
> 
> I will eventually, but while I really appreciate your contributions in
> terms of features and bug fixes, I would really *love* it if you were
> a bit more active on the list when it comes to reviewing other
> people's code.
> 
> There is no shortage of patches that really need reviewing, and just
> pointing me in the direction of your favourite series doesn't really
> help. I have something like 200+ patches that need careful reviewing
> in my inbox, and they all deserve the same level of attention.
> 
> To make it short, help me to help you!
My apologies, and I can't agree more.

I have noticed this, and have reviewed several patches of IOMMU community.
For that some patches are with much background knowledge, so it's hard to
review. I will dig into them in the future.

Thanks for your valuable advice. :)

Thanks,
Keqian


> 
> Thanks,
> 
> 	M.
> 
