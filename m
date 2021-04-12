Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3046035C512
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 13:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhDLL1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 07:27:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3939 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbhDLL1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 07:27:19 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FJmbw5YBVz5qZy;
        Mon, 12 Apr 2021 19:24:44 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 12 Apr 2021 19:26:59 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 19:26:59 +0800
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     Like Xu <like.xu@linux.intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
 <60701165.3060000@huawei.com>
 <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
CC:     <andi@firstfloor.org>, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wei.w.wang@intel.com>,
        <x86@kernel.org>, "Xu, Like" <like.xu@intel.com>
From:   "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Message-ID: <60742E82.5010607@huawei.com>
Date:   Mon, 12 Apr 2021 19:26:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/9 16:46, Like Xu wrote:
> Hi Liuxiangdong,
>
> On 2021/4/9 16:33, Liuxiangdong (Aven, Cloud Infrastructure Service 
> Product Dept.) wrote:
>> Do you have any comments or ideas about it ?
>>
>> https://lore.kernel.org/kvm/606E5EF6.2060402@huawei.com/
>
> My expectation is that there may be many fewer PEBS samples
> on Skylake without any soft lockup.
>
> You may need to confirm the statement
>
> "All that matters is that the EPT pages don't get
> unmapped ever while PEBS is active"
>
> is true in the kernel level.
>
> Try "-overcommit mem-lock=on" for your qemu.
>

We have used "-overcommit mem-lock=on" for qemu when soft lockup.

It seems that ept violation happens when we use pebs.

[ 5199.056246] Call Trace:
[ 5199.056248]  _raw_spin_lock+0x1b/0x20[ 5199.056251] 
follow_page_pte+0xf5/0x580
[ 5199.056258]  __get_user_pages+0x1d6/0x750[ 5199.056262] 
get_user_pages_unlocked+0xdc/0x310
[ 5199.056265]  __gfn_to_pfn_memslot+0x12d/0x4d0 [kvm]
[ 5199.056304]  try_async_pf+0xcc/0x250 [kvm]
[ 5199.056337]  direct_page_fault+0x413/0xa90 [kvm]
[ 5199.056367]  kvm_mmu_page_fault+0x77/0x5e0 [kvm]
[ 5199.056395]  ? vprintk_emit+0xa2/0x240
[ 5199.056399]  ? vmx_vmexit+0x1d/0x40 [kvm_intel]
[ 5199.056407]  ? vmx_vmexit+0x11/0x40 [kvm_intel]
[ 5199.056412]  vmx_handle_exit+0xfe/0x640 [kvm_intel]
[ 5199.056418]  vcpu_enter_guest+0x904/0x1450 [kvm]
[ 5199.056445]  ? kvm_apic_has_interrupt+0x44/0x80 [kvm]
[ 5199.056472]  ? apic_has_interrupt_for_ppr+0x62/0x90 [kvm]
[ 5199.056498]  ? kvm_arch_vcpu_ioctl_run+0xeb/0x550 [kvm]
[ 5199.056523]  kvm_arch_vcpu_ioctl_run+0xeb/0x550 [kvm]
[ 5199.056547]  kvm_vcpu_ioctl+0x23e/0x5b0 [kvm]
[ 5199.056568]  __x64_sys_ioctl+0x8e/0xd0
[ 5199.056571]  do_syscall_64+0x33/0x40
[ 5199.056574]  entry_SYSCALL_64_after_hwframe+0x44/0xae


SDM 17.4.9.2 "Setting Up the DS Save Area" says:

The recording of branch records in the BTS buffer (or PEBS records in 
the PEBS buffer) may not operate
properly if accesses to the linear addresses in any of the three DS save 
area sections cause page faults, VM
exits, or the setting of accessed or dirty flags in the paging 
structures (ordinary or EPT). For that reason,
system software should establish paging structures (both ordinary and 
EPT) to prevent such occurrences.
Implications of this may be that an operating system should allocate 
this memory from a non-paged pool and
that system software cannot do “lazy” page-table entry propagation for 
these pages. Some newer processor
generations support “lazy” EPT page-table entry propagation for PEBS; 
see Section 18.3.10.1 and Section
18.9.5 for more information. A virtual-machine monitor may choose to 
allow use of PEBS by guest software
only if EPT maps all guest-physical memory as present and read/write.


The reason why soft lockup happens may be the unmapped EPT pages. So, do 
we have a way to map all gpa
before we use pebs on Skylake?


>>
>>
>> On 2021/4/6 13:14, Xu, Like wrote:
>>> Hi Xiangdong,
>>>
>>> On 2021/4/6 11:24, Liuxiangdong (Aven, Cloud Infrastructure Service 
>>> Product Dept.) wrote:
>>>> Hi，like.
>>>> Some questions about this new pebs patches set：
>>>> https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/ 
>>>>
>>>>
>>>> The new hardware facility supporting guest PEBS is only available
>>>> on Intel Ice Lake Server platforms for now.
>>>
>>> Yes, we have documented this "EPT-friendly PEBS" capability in the SDM
>>> 18.3.10.1 Processor Event Based Sampling (PEBS) Facility
>>>
>>> And again, this patch set doesn't officially support guest PEBS on 
>>> the Skylake.
>>>
>>>>
>>>>
>>>> AFAIK， Icelake supports adaptive PEBS and extended PEBS which 
>>>> Skylake doesn't.
>>>> But we can still use IA32_PEBS_ENABLE MSR to indicate 
>>>> general-purpose counter in Skylake.
>>>
>>> For Skylake, only the PMC0-PMC3 are valid for PEBS and you may
>>> mask the other unsupported bits in the pmu->pebs_enable_mask.
>>>
>>>> Is there anything else that only Icelake supports in this patches set?
>>>
>>> The PDIR counter on the Ice Lake is the fixed counter 0
>>> while the PDIR counter on the Sky Lake is the gp counter 1.
>>>
>>> You may also expose x86_pmu.pebs_vmx for Skylake in the 1st patch.
>>>
>>>>
>>>>
>>>> Besides, we have tried this patches set in Icelake.  We can use 
>>>> pebs(eg: "perf record -e cycles:pp")
>>>> when guest is kernel-5.11, but can't when kernel-4.18.  Is there a 
>>>> minimum guest kernel version requirement?
>>>
>>> The Ice Lake CPU model has been added since v5.4.
>>>
>>> You may double check whether the stable tree(s) code has
>>> INTEL_FAM6_ICELAKE in the arch/x86/include/asm/intel-family.h.
>>>
>>>>
>>>>
>>>> Thanks,
>>>> Xiangdong Liu
>>>
>>
>

