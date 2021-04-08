Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F379357996
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 03:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhDHBkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 21:40:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3078 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhDHBkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 21:40:21 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FG3l946rvzWQJW;
        Thu,  8 Apr 2021 09:36:37 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 8 Apr 2021 09:40:07 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 09:40:07 +0800
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     "Xu, Like" <like.xu@intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
CC:     <andi@firstfloor.org>, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wei.w.wang@intel.com>,
        <x86@kernel.org>
From:   "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Message-ID: <606E5EF6.2060402@huawei.com>
Date:   Thu, 8 Apr 2021 09:40:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/6 13:14, Xu, Like wrote:
> Hi Xiangdong,
>
> On 2021/4/6 11:24, Liuxiangdong (Aven, Cloud Infrastructure Service 
> Product Dept.) wrote:
>> Hi，like.
>> Some questions about this new pebs patches set：
>> https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/ 
>>
>>
>> The new hardware facility supporting guest PEBS is only available
>> on Intel Ice Lake Server platforms for now.
>
> Yes, we have documented this "EPT-friendly PEBS" capability in the SDM
> 18.3.10.1 Processor Event Based Sampling (PEBS) Facility
>
> And again, this patch set doesn't officially support guest PEBS on the 
> Skylake.
>
>>
>>
>> AFAIK， Icelake supports adaptive PEBS and extended PEBS which 
>> Skylake doesn't.
>> But we can still use IA32_PEBS_ENABLE MSR to indicate general-purpose 
>> counter in Skylake.
>
> For Skylake, only the PMC0-PMC3 are valid for PEBS and you may
> mask the other unsupported bits in the pmu->pebs_enable_mask.
>
>> Is there anything else that only Icelake supports in this patches set?
>
> The PDIR counter on the Ice Lake is the fixed counter 0
> while the PDIR counter on the Sky Lake is the gp counter 1.
>
> You may also expose x86_pmu.pebs_vmx for Skylake in the 1st patch.
>

Yes. In fact, I have tried using this patch set in Skylake after these 
modifications:
1.  Expose x86_pmu.pebs_vmx for Skylake.
2.  Use PMC0-PMC3 for pebs
     2.1 Replace "INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed" with 
"x86_pmu.max_pebs_events" in "x86_pmu_handle_guest_pebs"
     2.2 Unmask other unsupported bits in the pmu->pebs_enable_mask. 
IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14]
           is always 0 in Skylake, so pmu->pebs_enable_mask equals 
`((1ull << pmu->nr_arch_gp_counters)-1).
     2.3  Replace "pmc->idx == 32 " with "pmc->idx == 1" because the 
PDIR counter on the Skylake is the gp counter 1.
3.  Shield patch-09 because Skylake does not support adaptive pebs.
4.  Shield all cpu check code in this patch set just for test.


But, unfortunately, guest will record only a few seconds and then host 
will certainly soft lockup .
Is there anything wrong?

>>
>>
>> Besides, we have tried this patches set in Icelake.  We can use 
>> pebs(eg: "perf record -e cycles:pp")
>> when guest is kernel-5.11, but can't when kernel-4.18.  Is there a 
>> minimum guest kernel version requirement?
>
> The Ice Lake CPU model has been added since v5.4.
>
> You may double check whether the stable tree(s) code has
> INTEL_FAM6_ICELAKE in the arch/x86/include/asm/intel-family.h.
>
>>
>>
>> Thanks,
>> Xiangdong Liu
>

