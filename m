Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D301E1948
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 04:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388524AbgEZCJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 22:09:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388351AbgEZCJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 22:09:12 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F30B0F64F7B95E6413C3;
        Tue, 26 May 2020 10:09:10 +0800 (CST)
Received: from [10.173.221.230] (10.173.221.230) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Tue, 26 May 2020 10:09:04 +0800
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Support stage2 hardware DBM
To:     Marc Zyngier <maz@kernel.org>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
 <4b8a939172395bf38e581634abecf925@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <zhengxiang9@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <66deb797-726f-242b-82fb-0ddee975ef15@huawei.com>
Date:   Tue, 26 May 2020 10:08:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <4b8a939172395bf38e581634abecf925@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/5/25 23:44, Marc Zyngier wrote:
> On 2020-05-25 12:23, Keqian Zhu wrote:
>> This patch series add support for stage2 hardware DBM, and it is only
>> used for dirty log for now.
>>
>> It works well under some migration test cases, including VM with 4K
>> pages or 2M THP. I checked the SHA256 hash digest of all memory and
>> they keep same for source VM and destination VM, which means no dirty
>> pages is missed under hardware DBM.
>>
>> However, there are some known issues not solved.
>>
>> 1. Some mechanisms that rely on "write permission fault" become invalid,
>>    such as kvm_set_pfn_dirty and "mmap page sharing".
>>
>>    kvm_set_pfn_dirty is called in user_mem_abort when guest issues write
>>    fault. This guarantees physical page will not be dropped directly when
>>    host kernel recycle memory. After using hardware dirty management, we
>>    have no chance to call kvm_set_pfn_dirty.
> 
> Then you will end-up with memory corruption under memory pressure.
> This also breaks things like CoW, which we depend on.
>
Yes, these problems looks knotty. But I think x86 PML support will face these
problems too. I believe there must be some methods to solve them.
>>
>>    For "mmap page sharing" mechanism, host kernel will allocate a new
>>    physical page when guest writes a page that is shared with other page
>>    table entries. After using hardware dirty management, we have no chance
>>    to do this too.
>>
>>    I need to do some survey on how stage1 hardware DBM solve these problems.
>>    It helps if anyone can figure it out.
>>
>> 2. Page Table Modification Races: Though I have found and solved some data
>>    races when kernel changes page table entries, I still doubt that there
>>    are data races I am not aware of. It's great if anyone can figure them out.
>>
>> 3. Performance: Under Kunpeng 920 platform, for every 64GB memory, KVM
>>    consumes about 40ms to traverse all PTEs to collect dirty log. It will
>>    cause unbearable downtime for migration if memory size is too big. I will
>>    try to solve this problem in Patch v1.
> 
> This, in my opinion, is why Stage-2 DBM is fairly useless.
> From a performance perspective, this is the worse possible
> situation. You end up continuously scanning page tables, at
> an arbitrary rate, without a way to evaluate the fault rate.
> 
> One thing S2-DBM would be useful for is SVA, where a device
> write would mark the S2 PTs dirty as they are shared between
> CPU and SMMU. Another thing is SPE, which is essentially a DMA
> agent using the CPU's PTs.
> 
> But on its own, and just to log the dirty pages, S2-DBM is
> pretty rubbish. I wish arm64 had something like Intel's PML,
> which looks far more interesting for the purpose of tracking
> accesses.

Sure, PML is a better solution on hardware management of dirty state.
However, compared to optimizing hardware, optimizing software is with
shorter cycle time.

Here I have an optimization in mind to solve it. Scanning page tables
can be done parallel, which can greatly reduce time consumption. For there
is no communication between parallel CPUs, we can achieve high speedup
ratio.


> 
> Thanks,
> 
>         M.
Thanks,
Keqian
