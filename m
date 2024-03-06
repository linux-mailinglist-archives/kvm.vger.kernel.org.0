Return-Path: <kvm+bounces-11111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A73EF873253
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 10:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09D06B2D33D
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 09:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273BF604B9;
	Wed,  6 Mar 2024 09:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMf1fJEx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF175FB8E;
	Wed,  6 Mar 2024 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709715804; cv=none; b=XMSmzphiiV0srLh0ENTUNSC+wkd3HjDcXS8zzMc6ttX7q5iV+sHp1YyawmpslM9uCTvJmmh0xJJFZ9UdPRVYmDY92hYmYspRiD+1RKceacwbqUVE2eOW8MNJSAsr6qXTMHt4/mfGirHZKb4yLxb2cqTgj2Vig63MZYLYcAVJ+4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709715804; c=relaxed/simple;
	bh=bhuGP+1KPBJFnljRgP7OPZu2wAtpksJ/+vFr4V0XksY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFt8C9seYVVzoIBiPFVCkTFryuMf3iohl5UZHW1ko4CNTMgsqV7wFWGoPzHsxlFSHs2Bf3ifYLbtK+RCFh3+oSstgPR1qkWcf+8wvPgaWVGkhuPih7UivaTjpPfu5DWPzdrBsfJ/GHMIghE/qQ7mLMKVenvTgLRtZLfYGNXsMco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMf1fJEx; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc49b00bdbso59815895ad.3;
        Wed, 06 Mar 2024 01:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709715802; x=1710320602; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xlDITtlvgl4U+B/J92cv6/cTJ0Y0RVmdTfRjOVcQc+4=;
        b=AMf1fJExrSyLkwgK3bl7NacVsiFHOtnBpoh2AWF6kDfy0n7SIid4u8ckIX3v4YEUw/
         4sVb+ZpNugsm3JaBQJVu0Idg+2S4uteMEygE8+n24UIdQIP69iZ9n5FJXb1ZL1LJ8ibz
         dTvA7iydaMO8lGm0tReIr3jd+dkMpD6hPSxg9wSSEKhbffv/4/wEW/7mHmvemRAp2FKL
         IQ31ewRp40fYTRBOYFzTIjAR6Q3VcaAzOgBIWkDVJNLIG0uiUdiPhUG8Bk5ylDFZAaP+
         t3dMgQ9V5xVHaULWbQd5KLO76prZqxANQy1W0zhNRyKVVA0NdDUoyb990xnT5ArUUO5R
         tvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709715802; x=1710320602;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlDITtlvgl4U+B/J92cv6/cTJ0Y0RVmdTfRjOVcQc+4=;
        b=LW+3EBCKwH0c9170Dst8pYh37ptF0+MrZ6gTJHLa5tppmq/FbP9eTr1snZNRRuIYEN
         U65krs5O3HIrdhsUn3jRjV1wBhyAFMlT7lCeixbRNha9ovsH4/VWAbHqWaQtlVD/PjMj
         PF/DYATx76b8Ew1W4TlQTldoOEjelgNMoXn9A73+4F2ZjALXXWRwzcw8Ce3gV+OD5Nmo
         dWn4rJ6DcqIIuaeZR8hv/bdhXcxF80GHafLAxYUat1ttQrUWkdyINIjWfGsQKEkzGyF0
         P3Wg6+Obb+fJXqdZ37Nxh5JISnJpsuV9zVSqLPEEXih4wvC3JTL73Prd7TiMHC7jrKh7
         4XXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcmrCsLrQQNeVYpHcoGt/QFMZ5rn/3QM9+APZ7dt+Uj7aIBgOPEixdZBepGmnIyQ/huZqG0mjPXoAjKPgly49DgumxVdiezerWQdBZEGXBwIl+P49YAJO2XRPrCb3lH2Ksbmqoi28VxblpXJlxYjVIw1ncJc0UX+jJs51f0NzayEVCzw==
X-Gm-Message-State: AOJu0YyED5c4go65cKUlCO01iNHcHI/aVEhbW3yMYg28TWxpc1O5mN11
	cMDhZBQORv3WWoZjOYCwuu6q3Vg1jvwRDRALr/GZaTsuA0r0n+Dd
X-Google-Smtp-Source: AGHT+IGiW//UQN4r2XqU5QACWeGHLzkXZS+B6PHy7ty9yPr0C6knLVm23dYoF7fBkDjxo/qxzMWmSg==
X-Received: by 2002:a17:903:230b:b0:1dc:a00c:5442 with SMTP id d11-20020a170903230b00b001dca00c5442mr5462695plh.43.1709715801772;
        Wed, 06 Mar 2024 01:03:21 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001d9641003cfsm11041675plf.142.2024.03.06.01.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 01:03:21 -0800 (PST)
Message-ID: <2677739b-bc84-43ee-ba56-a5e243148ceb@gmail.com>
Date: Wed, 6 Mar 2024 17:03:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with
 macros
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kan Liang
 <kan.liang@linux.intel.com>, Like Xu <likexu@tencent.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20230824020546.1108516-1-dapeng1.mi@linux.intel.com>
 <ZeepGjHCeSfadANM@google.com>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZeepGjHCeSfadANM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/2024 7:22 am, Sean Christopherson wrote:
> +Mingwei
> 
> On Thu, Aug 24, 2023, Dapeng Mi wrote:
>   diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 7d9ba301c090..ffda2ecc3a22 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -12,7 +12,8 @@
>>   					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>>   
>>   /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
>> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
>> +#define fixed_ctrl_field(ctrl_reg, idx) \
>> +	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
>>   
>>   #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
>>   #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
>> @@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>>   
>>   	if (pmc_is_fixed(pmc))
>>   		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>> -					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>> +					pmc->idx - INTEL_PMC_IDX_FIXED) &
>> +					(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
>>   
>>   	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>>   }
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index f2efa0bf7ae8..b0ac55891cb7 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -548,8 +548,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   		setup_fixed_pmc_eventsel(pmu);
>>   	}
>>   
>> -	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>> -		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
>> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +		pmu->fixed_ctr_ctrl_mask &=
>> +			 ~intel_fixed_bits_by_idx(i,
>> +						  INTEL_FIXED_0_KERNEL |
>> +						  INTEL_FIXED_0_USER |
>> +						  INTEL_FIXED_0_ENABLE_PMI);
>> +	}
>>   	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
>>   		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
>>   	pmu->global_ctrl_mask = counter_mask;
>> @@ -595,7 +600,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
>>   			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>   				pmu->fixed_ctr_ctrl_mask &=
>> -					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
> 
> OMG, this might just win the award for most obfuscated PMU code in KVM, which is
> saying something.  The fact that INTEL_PMC_IDX_FIXED happens to be 32, the same
> bit number as ICL_FIXED_0_ADAPTIVE, is 100% coincidence.  Good riddance.
> 
> Argh, and this goofy code helped introduce a real bug.  reprogram_fixed_counters()
> doesn't account for the upper 32 bits of IA32_FIXED_CTR_CTRL.
> 
> Wait, WTF?  Nothing in KVM accounts for the upper bits.  This can't possibly work.
> 
> IIUC, because KVM _always_ sets precise_ip to a non-zero bit for PEBS events,
> perf will _always_ generate an adaptive record, even if the guest requested a
> basic record.  Ugh, and KVM will always generate adaptive records even if the
> guest doesn't support them.  This is all completely broken.  It probably kinda
> sorta works because the Basic info is always stored in the record, and generating
> more info requires a non-zero MSR_PEBS_DATA_CFG, but ugh.

Yep, it works at least on machines with both adaptive and pebs_full features.

I remember one generation of Atom core (? GOLDMONT) that didn't have both
above PEBS sub-features, so we didn't set x86_pmu.pebs_ept on that platform.

Mingwei or others are encouraged to construct use cases in KUT::pmu_pebs.flat
that violate guest-pebs rules (e.g., leak host state), as we all recognize that 
testing
is the right way to condemn legacy code, not just lengthy emails.

> 
> Oh great, and it gets worse.  intel_pmu_disable_fixed() doesn't clear the upper
> bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set.  Unless I'm misreading the code,
> intel_pmu_enable_fixed() effectively doesn't clear ICL_FIXED_0_ADAPTIVE either,
> as it only modifies the bit when it wants to set ICL_FIXED_0_ADAPTIVE.
> 
> *sigh*
> 
> I'm _very_ tempted to disable KVM PEBS support for the current PMU, and make it
> available only when the so-called passthrough PMU is available[*].  Because I
> don't see how this is can possibly be functionally correct, nor do I see a way
> to make it functionally correct without a rather large and invasive series.

Considering that I've tried the idea myself, I have no inclination towards
"passthrough PMU", and I'd like to be able to take the time to review that
patchset while we all wait for a clear statement from that perf-core man,
who don't really care about virtualization and don't want to lose control
of global hardware resources.

Before we actually get to that ideal state you want, we have to deal with
some intermediate state and face to any users that rely on the current code,
you had urged to merge in a KVM document for vPMU, not sure how far
along that part of the work is.

> 
> Ouch.  And after chatting with Mingwei, who asked the very good question of
> "can this leak host state?", I am pretty sure that yes, this can leak host state.

The Basic Info has a tsc field, I suspect it's the host-state-tsc.

> 
> When PERF_CAP_PEBS_BASELINE is enabled for the guest, i.e. when the guest has
> access to adaptive records, KVM gives the guest full access to MSR_PEBS_DATA_CFG
> 
> 	pmu->pebs_data_cfg_mask = ~0xff00000full;
> 
> which makes sense in a vacuum, because AFAICT the architecture doesn't allow
> exposing a subset of the four adaptive controls.
> 
> GPRs and XMMs are always context switched and thus benign, but IIUC, Memory Info
> provides data that might now otherwise be available to the guest, e.g. if host
> userspace has disallowed equivalent events via KVM_SET_PMU_EVENT_FILTER.

Indeed, KVM_SET_PMU_EVENT_FILTER doesn't work in harmony with
guest-pebs, and I believe there is a big problem here, especially with the
lack of targeted testing.

One reason for this is that we don't use this cockamamie API in our
large-scale production environments, and users of vPMU want to get real
runtime information about physical cpus, not just virtualised hardware
architecture interfaces.

> 
> And unless I'm missing something, LBRs are a full leak of host state.  Nothing
> in the SDM suggests that PEBS records honor MSR intercepts, so unless KVM is
> also passing through LBRs, i.e. is context switching all LBR MSRs, the guest can
> use PEBS to read host LBRs at will.

KVM is also passing through LBRs when guest uses LBR but not at the
granularity of vm-exit/entry. I'm not sure if the LBR_EN bit is required
to get LBR information via PEBS, also not confirmed whether PEBS-lbr
can be enabled at the same time as independent LBR;

I recall that PEBS-assist, per cpu-arch, would clean up this part of the
record when crossing root/non-root boundaries, or not generate record.

We're looking forward to the tests that will undermine this perception.

There are some devilish details during the processing of vm-exit and
the generation of host/guest pebs, and those interested can delve into
the short description in this SDM section "20.9.5 EPT-Friendly PEBS".

> 
> Unless someone chimes in to point out how PEBS virtualization isn't a broken mess,
> I will post a patch to effectively disable PEBS virtualization.

There are two factors that affect the availability of guest-pebs:

1. the technical need to use core-PMU in both host/guest worlds;
(I don't think Googlers are paying attention to this part of users' needs)

2. guest-pebs is temporarily disabled in the case of cross-mapping counter,
which reduces the number of performance samples collected by guest;

> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 41a4533f9989..a2f827fa0ca1 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -392,7 +392,7 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>   
>   static inline bool vmx_pebs_supported(void)
>   {
> -       return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> +       return false;

As you know, user-space VMM may disable guest-pebs by filtering out the
MSR_IA32_PERF_CAPABILITIE.PERF_CAP_PEBS_FORMAT or CPUID.PDCM.

In the end, if our great KVM maintainers insist on doing this,
there is obviously nothing I can do about it.

Hope you have a good day.

>   }
>   
>   static inline bool cpu_has_notify_vmexit(void)
> 

