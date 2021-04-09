Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37002359836
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhDIIqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:46:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:53137 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231761AbhDIIqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:46:32 -0400
IronPort-SDR: 9Bt4obJ6BJJn0wn3Cdbil/DjlOmHfFmqYaNsZdmR5IWH85h5y0LbK9U+7x/nWVOTKHMyGapvUm
 jdtobrfGrJtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="193833043"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="193833043"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 01:46:19 -0700
IronPort-SDR: Mhhfh7z7iKhmGuFBdLM45XFcjK7W3LplRNuEwS4b7XhWxNy7WUsej2JhidJSTEu0/GoPgb14OA
 M30xOyJNR3yA==
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="416179263"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 01:46:16 -0700
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     andi@firstfloor.org, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.w.wang@intel.com, x86@kernel.org,
        "Xu, Like" <like.xu@intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
 <60701165.3060000@huawei.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
Date:   Fri, 9 Apr 2021 16:46:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <60701165.3060000@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liuxiangdong,

On 2021/4/9 16:33, Liuxiangdong (Aven, Cloud Infrastructure Service Product 
Dept.) wrote:
> Do you have any comments or ideas about it ?
> 
> https://lore.kernel.org/kvm/606E5EF6.2060402@huawei.com/

My expectation is that there may be many fewer PEBS samples
on Skylake without any soft lockup.

You may need to confirm the statement

"All that matters is that the EPT pages don't get
unmapped ever while PEBS is active"

is true in the kernel level.

Try "-overcommit mem-lock=on" for your qemu.

> 
> 
> On 2021/4/6 13:14, Xu, Like wrote:
>> Hi Xiangdong,
>>
>> On 2021/4/6 11:24, Liuxiangdong (Aven, Cloud Infrastructure Service 
>> Product Dept.) wrote:
>>> Hi，like.
>>> Some questions about this new pebs patches set：
>>> https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/ 
>>>
>>>
>>> The new hardware facility supporting guest PEBS is only available
>>> on Intel Ice Lake Server platforms for now.
>>
>> Yes, we have documented this "EPT-friendly PEBS" capability in the SDM
>> 18.3.10.1 Processor Event Based Sampling (PEBS) Facility
>>
>> And again, this patch set doesn't officially support guest PEBS on the 
>> Skylake.
>>
>>>
>>>
>>> AFAIK， Icelake supports adaptive PEBS and extended PEBS which Skylake 
>>> doesn't.
>>> But we can still use IA32_PEBS_ENABLE MSR to indicate general-purpose 
>>> counter in Skylake.
>>
>> For Skylake, only the PMC0-PMC3 are valid for PEBS and you may
>> mask the other unsupported bits in the pmu->pebs_enable_mask.
>>
>>> Is there anything else that only Icelake supports in this patches set?
>>
>> The PDIR counter on the Ice Lake is the fixed counter 0
>> while the PDIR counter on the Sky Lake is the gp counter 1.
>>
>> You may also expose x86_pmu.pebs_vmx for Skylake in the 1st patch.
>>
>>>
>>>
>>> Besides, we have tried this patches set in Icelake.  We can use pebs(eg: 
>>> "perf record -e cycles:pp")
>>> when guest is kernel-5.11, but can't when kernel-4.18.  Is there a 
>>> minimum guest kernel version requirement?
>>
>> The Ice Lake CPU model has been added since v5.4.
>>
>> You may double check whether the stable tree(s) code has
>> INTEL_FAM6_ICELAKE in the arch/x86/include/asm/intel-family.h.
>>
>>>
>>>
>>> Thanks,
>>> Xiangdong Liu
>>
> 

