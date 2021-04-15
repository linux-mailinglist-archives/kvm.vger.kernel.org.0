Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954E636001D
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 04:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhDOCt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 22:49:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3085 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhDOCtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 22:49:55 -0400
Received: from dggeml405-hub.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FLNxq2WfRzWX7d;
        Thu, 15 Apr 2021 10:45:51 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggeml405-hub.china.huawei.com (10.3.17.49) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 15 Apr 2021 10:49:30 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 10:49:30 +0800
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     "Xu, Like" <like.xu@intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
 <60701165.3060000@huawei.com>
 <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
 <607700F2.9080409@huawei.com>
 <76467c36-3399-a123-d582-92affadc4d73@intel.com>
CC:     <andi@firstfloor.org>, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wei.w.wang@intel.com>,
        <x86@kernel.org>, Like Xu <like.xu@linux.intel.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <6077A9AE.2090705@huawei.com>
Date:   Thu, 15 Apr 2021 10:49:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <76467c36-3399-a123-d582-92affadc4d73@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/15 9:38, Xu, Like wrote:
> On 2021/4/14 22:49, Liuxiangdong wrote:
>> Hi Like,
>>
>> On 2021/4/9 16:46, Like Xu wrote:
>>> Hi Liuxiangdong,
>>>
>>> On 2021/4/9 16:33, Liuxiangdong (Aven, Cloud Infrastructure Service 
>>> Product Dept.) wrote:
>>>> Do you have any comments or ideas about it ?
>>>>
>>>> https://lore.kernel.org/kvm/606E5EF6.2060402@huawei.com/
>>>
>>> My expectation is that there may be many fewer PEBS samples
>>> on Skylake without any soft lockup.
>>>
>>> You may need to confirm the statement
>>>
>>> "All that matters is that the EPT pages don't get
>>> unmapped ever while PEBS is active"
>>>
>>> is true in the kernel level.
>>>
>>> Try "-overcommit mem-lock=on" for your qemu.
>>>
>>
>> Sorry, in fact, I don't quite understand
>> "My expectation is that there may be many fewer PEBS samples on 
>> Skylake without any soft lockup. "
>
> For testcase: perf record -e instructions:pp ./workload
>
> We can get 2242 samples on the ICX guest, but
> only 17 samples or less on the Skylake guest.
>
> In my testcase on Skylake, neither the host nor the guest triggered 
> the soft lock.
>

Thanks for your explanation！
Could you please show your complete qemu command and qemu version used 
on Skylake?
I hope I can test it again according to your qemu cmd and version.


>>
>> And, I have used "-overcommit mem-lock=on"  when soft lockup happens.
>
> I misunderstood the use of "mem-lock=on". It is not the same as the
> guest mem pin and I believe more kernel patches are needed.
>
>>
>>
>> Now, I have tried to configure 1G-hugepages for 2G-mem vm. Each of 
>> guest numa nodes has 1G mem.
>> When I use pebs(perf record -e cycles:pp) in guest, there are 
>> successful pebs samples just for a while and
>> then I cannot get pebs samples. Host doesn't soft lockup in this 
>> process.
>
> In the worst case, no samples are expected.
>
>>
>> Are there something wrong on skylake for we can only get a few 
>> samples? IRQ?  Or using hugepage is not effecitve?
>
> The few samples comes from hardware limitation.
> The Skylake doesn't have this "EPT-Friendly PEBS" capabilityand
> some PEBS records will be lost when used by guests.
>
>>
>> Thanks!
>>
>>>>
>>>>
>>>> On 2021/4/6 13:14, Xu, Like wrote:
>>>>> Hi Xiangdong,
>>>>>
>>>>> On 2021/4/6 11:24, Liuxiangdong (Aven, Cloud Infrastructure 
>>>>> Service Product Dept.) wrote:
>>>>>> Hi，like.
>>>>>> Some questions about this new pebs patches set：
>>>>>> https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/ 
>>>>>>
>>>>>>
>>>>>> The new hardware facility supporting guest PEBS is only available
>>>>>> on Intel Ice Lake Server platforms for now.
>>>>>
>>>>> Yes, we have documented this "EPT-friendly PEBS" capability in the 
>>>>> SDM
>>>>> 18.3.10.1 Processor Event Based Sampling (PEBS) Facility
>>>>>
>>>>> And again, this patch set doesn't officially support guest PEBS on 
>>>>> the Skylake.
>>>>>
>>>>>>
>>>>>>
>>>>>> AFAIK， Icelake supports adaptive PEBS and extended PEBS which 
>>>>>> Skylake doesn't.
>>>>>> But we can still use IA32_PEBS_ENABLE MSR to indicate 
>>>>>> general-purpose counter in Skylake.
>>>>>
>>>>> For Skylake, only the PMC0-PMC3 are valid for PEBS and you may
>>>>> mask the other unsupported bits in the pmu->pebs_enable_mask.
>>>>>
>>>>>> Is there anything else that only Icelake supports in this patches 
>>>>>> set?
>>>>>
>>>>> The PDIR counter on the Ice Lake is the fixed counter 0
>>>>> while the PDIR counter on the Sky Lake is the gp counter 1.
>>>>>
>>>>> You may also expose x86_pmu.pebs_vmx for Skylake in the 1st patch.
>>>>>
>>>>>>
>>>>>>
>>>>>> Besides, we have tried this patches set in Icelake.  We can use 
>>>>>> pebs(eg: "perf record -e cycles:pp")
>>>>>> when guest is kernel-5.11, but can't when kernel-4.18. Is there a 
>>>>>> minimum guest kernel version requirement?
>>>>>
>>>>> The Ice Lake CPU model has been added since v5.4.
>>>>>
>>>>> You may double check whether the stable tree(s) code has
>>>>> INTEL_FAM6_ICELAKE in the arch/x86/include/asm/intel-family.h.
>>>>>
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Xiangdong Liu
>>>>>
>>>>
>>>
>>
>

