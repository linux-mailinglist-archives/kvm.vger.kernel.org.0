Return-Path: <kvm+bounces-11297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29662874E53
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50531B245A2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 11:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45553129A75;
	Thu,  7 Mar 2024 11:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K0hESy+M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8BB85643;
	Thu,  7 Mar 2024 11:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709812471; cv=none; b=YME++eR9E+1zSYPxY6bBOdvpB2KPUnN+CG5Ykns8NROG1FMhT1qqZU6cwBCCGJ0ZTOrUC6Km6vbxGUAp6QwIBd+wMbAioJf/tpSLCldVKIRGqs3nnHIDrYW9dX8EcK1FSvbYfjHJkEGOeSSkImJl/YSzzGjg0onUer+qCthKtMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709812471; c=relaxed/simple;
	bh=ZoHup6PxCiPCdbMekXdQYIgF9/nTzfaulQLHQy55yoA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=s3f+EtN8zQRt0aj7aJZLjw5MMoKGyy/bPprfnlo1V4K+0gN8CVsPDX/EVuC6L5f/Vr6ssjuNuGz4gMnwcw5R4/HGnd2ufOJeyBHja29EapswOvw5WRboNNp5ZcTJk3aotj2pITU2y+eEZTx/ddFbBBH07BSohHryyjYgI7oRJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K0hESy+M; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709812469; x=1741348469;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ZoHup6PxCiPCdbMekXdQYIgF9/nTzfaulQLHQy55yoA=;
  b=K0hESy+M4XrjbKE5pmeTHE4jyxaUE4aeWRYHiR/yTrnidFxzXuKx5Cnf
   2sYrB7EIJfkKSs88v1AKMIdC86qwtM9RmMunR0hGDtdfcK6QJ+BOpEPo8
   Ybb1Z800U4DeiVbKqbvBSPYxBhiqO7ot4CzdvKsV3pzgM8X0z6v0WoYGr
   1Eb7o0Zix4MUMMjFGZEyBaOQ3Fxzbzp8OF9o4dlfKcePM/50zCDlzXMtd
   YCHnuwlb6ogkOKSuO1Qw3a4/q08HeCrtsqdWXNJQ2fty6GV+1/G1+HSry
   822EKsoWUqyH0Khx8ohf+b6v4JnnmDYF/vLaUSQF4RFFQ56DEP6WTLbEI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4356424"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="4356424"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 03:54:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="10064222"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 03:54:26 -0800
Message-ID: <7e737b76-a9f8-4591-aefa-8b8670cb1f87@linux.intel.com>
Date: Thu, 7 Mar 2024 19:54:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with
 macros
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kan Liang
 <kan.liang@linux.intel.com>, Like Xu <likexu@tencent.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Mingwei Zhang <mizhang@google.com>
References: <20230824020546.1108516-1-dapeng1.mi@linux.intel.com>
 <ZeepGjHCeSfadANM@google.com>
 <37b3bb47-059e-4524-a7d8-1aa28099cc94@linux.intel.com>
In-Reply-To: <37b3bb47-059e-4524-a7d8-1aa28099cc94@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/6/2024 3:55 PM, Mi, Dapeng wrote:
>
> On 3/6/2024 7:22 AM, Sean Christopherson wrote:
>> +Mingwei
>>
>> On Thu, Aug 24, 2023, Dapeng Mi wrote:
>>   diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>> index 7d9ba301c090..ffda2ecc3a22 100644
>>> --- a/arch/x86/kvm/pmu.h
>>> +++ b/arch/x86/kvm/pmu.h
>>> @@ -12,7 +12,8 @@
>>>                         MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>>>     /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
>>> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) 
>>> & 0xf)
>>> +#define fixed_ctrl_field(ctrl_reg, idx) \
>>> +    (((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & 
>>> INTEL_FIXED_BITS_MASK)
>>>     #define VMWARE_BACKDOOR_PMC_HOST_TSC        0x10000
>>>   #define VMWARE_BACKDOOR_PMC_REAL_TIME        0x10001
>>> @@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct 
>>> kvm_pmc *pmc)
>>>         if (pmc_is_fixed(pmc))
>>>           return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>>> -                    pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>>> +                    pmc->idx - INTEL_PMC_IDX_FIXED) &
>>> +                    (INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
>>>         return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>>>   }
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c 
>>> b/arch/x86/kvm/vmx/pmu_intel.c
>>> index f2efa0bf7ae8..b0ac55891cb7 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -548,8 +548,13 @@ static void intel_pmu_refresh(struct kvm_vcpu 
>>> *vcpu)
>>>           setup_fixed_pmc_eventsel(pmu);
>>>       }
>>>   -    for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>>> -        pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
>>> +    for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>> +        pmu->fixed_ctr_ctrl_mask &=
>>> +             ~intel_fixed_bits_by_idx(i,
>>> +                          INTEL_FIXED_0_KERNEL |
>>> +                          INTEL_FIXED_0_USER |
>>> +                          INTEL_FIXED_0_ENABLE_PMI);
>>> +    }
>>>       counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
>>>           (((1ull << pmu->nr_arch_fixed_counters) - 1) << 
>>> INTEL_PMC_IDX_FIXED));
>>>       pmu->global_ctrl_mask = counter_mask;
>>> @@ -595,7 +600,7 @@ static void intel_pmu_refresh(struct kvm_vcpu 
>>> *vcpu)
>>>               pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
>>>               for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>>                   pmu->fixed_ctr_ctrl_mask &=
>>> -                    ~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
>> OMG, this might just win the award for most obfuscated PMU code in 
>> KVM, which is
>> saying something.  The fact that INTEL_PMC_IDX_FIXED happens to be 
>> 32, the same
>> bit number as ICL_FIXED_0_ADAPTIVE, is 100% coincidence.  Good riddance.
>>
>> Argh, and this goofy code helped introduce a real bug. 
>> reprogram_fixed_counters()
>> doesn't account for the upper 32 bits of IA32_FIXED_CTR_CTRL.
>>
>> Wait, WTF?  Nothing in KVM accounts for the upper bits.  This can't 
>> possibly work.
>>
>> IIUC, because KVM _always_ sets precise_ip to a non-zero bit for PEBS 
>> events,
>> perf will _always_ generate an adaptive record, even if the guest 
>> requested a
>> basic record.  Ugh, and KVM will always generate adaptive records 
>> even if the
>> guest doesn't support them.  This is all completely broken.  It 
>> probably kinda
>> sorta works because the Basic info is always stored in the record, 
>> and generating
>> more info requires a non-zero MSR_PEBS_DATA_CFG, but ugh.
>>
>> Oh great, and it gets worse.  intel_pmu_disable_fixed() doesn't clear 
>> the upper
>> bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set.  Unless I'm 
>> misreading the code,
>> intel_pmu_enable_fixed() effectively doesn't clear 
>> ICL_FIXED_0_ADAPTIVE either,
>> as it only modifies the bit when it wants to set ICL_FIXED_0_ADAPTIVE.
>
>
> Currently the host PMU driver would always set the "Adaptive_Record" 
> bit in PERFEVTSELx and FIXED_CNTR_CTR MSRs as long as HW supports the 
> adaptive PEBS feature (See details in helpers intel_pmu_pebs_enable() 
> and intel_pmu_enable_fixed()).
>
> It looks perf system doesn't export a interface to enable/disable the 
> adaptive PEBS.  I suppose that's why KVM doesn't handle the 
> "Adaptive_Record" bit in ERFEVTSELx and FIXED_CNTR_CTR MSRs.
>
>
>>
>> *sigh*
>>
>> I'm _very_ tempted to disable KVM PEBS support for the current PMU, 
>> and make it
>> available only when the so-called passthrough PMU is available[*].  
>> Because I
>> don't see how this is can possibly be functionally correct, nor do I 
>> see a way
>> to make it functionally correct without a rather large and invasive 
>> series.
>>
>> Ouch.  And after chatting with Mingwei, who asked the very good 
>> question of
>> "can this leak host state?", I am pretty sure that yes, this can leak 
>> host state.
>>
>> When PERF_CAP_PEBS_BASELINE is enabled for the guest, i.e. when the 
>> guest has
>> access to adaptive records, KVM gives the guest full access to 
>> MSR_PEBS_DATA_CFG
>>
>>     pmu->pebs_data_cfg_mask = ~0xff00000full;
>>
>> which makes sense in a vacuum, because AFAICT the architecture 
>> doesn't allow
>> exposing a subset of the four adaptive controls.
>>
>> GPRs and XMMs are always context switched and thus benign, but IIUC, 
>> Memory Info
>> provides data that might now otherwise be available to the guest, 
>> e.g. if host
>> userspace has disallowed equivalent events via KVM_SET_PMU_EVENT_FILTER.
>>
>> And unless I'm missing something, LBRs are a full leak of host 
>> state.  Nothing
>> in the SDM suggests that PEBS records honor MSR intercepts, so unless 
>> KVM is
>> also passing through LBRs, i.e. is context switching all LBR MSRs, 
>> the guest can
>> use PEBS to read host LBRs at will.
>
> Not sure If I missed something, but I don't see there is leak of host 
> state. All perf events created by KVM would set "exclude_host" 
> attribute, that would leads to all guest counters including the PEBS 
> enabling counters would be disabled immediately by VMX once vm exits, 
> and so the PEBS engine would stop as well. I don't see a PEBS record 
> contains host state is possible to be written into guest DS area.


Jut think twice, it looks the host LBR stack could really be possible to 
leak into guest since LBR stack is not cleared or switched in VM-entry 
even though the captured guest LBR record may overwrite the LBR stack 
gradually after vm-entry.


>
>
>>
>> Unless someone chimes in to point out how PEBS virtualization isn't a 
>> broken mess,
>> I will post a patch to effectively disable PEBS virtualization.
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h 
>> b/arch/x86/kvm/vmx/capabilities.h
>> index 41a4533f9989..a2f827fa0ca1 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -392,7 +392,7 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>     static inline bool vmx_pebs_supported(void)
>>   {
>> -       return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>> +       return false;
>>   }
>>     static inline bool cpu_has_notify_vmexit(void)

