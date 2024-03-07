Return-Path: <kvm+bounces-11251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD108746C8
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 04:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 481331F22433
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C0B17BAB;
	Thu,  7 Mar 2024 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFaVdReH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9A114F78;
	Thu,  7 Mar 2024 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709782083; cv=none; b=C3hHtY7AzSc1QI7Rz3oPgMir10L5ptAHcA6L2mQaedvPApCV80crteY1pGb8/s41YikAX3bMJ+6OOy4NvnjHr+wE0T8fbIsZH4NeJgdYadrdCw6UpkcKL3/l18AL6MJMLrUW03v/xO6TJ/sgwGt94YXfZMIxsW7K5kHwE8j5/3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709782083; c=relaxed/simple;
	bh=KHdr03Dz9D0+bk1OD9MB4zgKTO/IXrHrWWSkxIyLymQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EroQ+rIo2IValz7vORUuCBBuzAWPwX3yHLnnpG3VFpaPrJfojN4q7BoOzqT6HpjLD79Ks2Jmy/9QzYx64A9XEhE5STwak9SAqbqEfrbzCpdysIk/cXjTpnQBf78M4TWFXETxbVpfBaA730W2+w2n22P/7+JN+yn4iaS0TPa+gbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFaVdReH; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dbae7b8ff2so3657265ad.3;
        Wed, 06 Mar 2024 19:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709782081; x=1710386881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RoMrqob6XzKrx2l68g3uNby2pIPa2rZQW8xZRw2X/0M=;
        b=BFaVdReHGQSWivGSP3GqzHgms4/COs0wxpsp1UxcT0pfVmP3WemBX60wJcziHYNOwF
         /95mTXb36EEEI+bIdqlZB/8fPbiB7rry+9fAwqC4ATlOUwRauu1oLv2awdADmoNGtFkH
         ZaZoOQ8vLkw11zwAqtUMFc89f/3eTwZU9malOappUNFUR1TtHGk6thrYyB3lUR0Zqsaf
         Sk5sZx71uRtERXOyhl2nb0OgPM38bD5iLt1MCmApewE62LgVzPNlN8nNN5eShi5tl7Vz
         GkRranR9C2xmywBUdUv+GatW69+t2mMibsMOj0kT4NxK4dA+A3bOlnTbGns0wzNHaEOX
         AySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709782081; x=1710386881;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoMrqob6XzKrx2l68g3uNby2pIPa2rZQW8xZRw2X/0M=;
        b=XNXnSdhmsa/6UCByKDso/jhlzWG34A1Z2YHhhxPwcAWCpUACHh5ns/6JR00FJZLbLG
         qDZp/kLh+1N34g/KM/ron9fbZl6zugj7gUrXdPjidxSijT2+CxneoqdntFlLIzS1mRqJ
         +HVcx+o2/D6SVRbZaojBiBa3939+uoH/eddDpqJkv2P0I++7eOUi5G2ZTVbufsjvq/So
         JbVRHh3u3OFdTYqKGYkGgprO9BbyFxkhX2Ib5A5o8NCt+mDfQ5gSlXcWqckB9H4qC400
         HLwHy9b4KViwe9jgTIQBEfH1btBTMQj1f4DG6vtA+P0bRqQCO4s4ZI5Rl7E2K21tXdPc
         yLUA==
X-Forwarded-Encrypted: i=1; AJvYcCW0B/Omkr8T9DA2O0M07K/NYnyklltVbRU4gj2rZRPIMHzjQh+1kF2edDHuW0YKsmAfPsl+RvGEdNvWfvq0kg1bjpfEw/YjZfzdPXvowPZRy5NvR9cZPYa40yfCn0ts9YLOe5mtqQ1ZAI/mfcF/aiehUxCVK9yPgzMmNJyhxwyrFlr39g==
X-Gm-Message-State: AOJu0YxnG3u3Oq/pLn3fR79G3nE5G4wTCuUbX0qSC34lgf6jMIJ3StId
	fp7E5AcqkrL03FSZDhFWkNQC2S94Vw+9jBYAePaLULypTGzzj+JO
X-Google-Smtp-Source: AGHT+IF3jPKeUektLW+KNlDJ+Jd7EPB4xUij5sBZpclzvJfCYK52Km8Efp8bXa3IaLLUQKm3r7KFpw==
X-Received: by 2002:a17:902:ecd1:b0:1dc:8c27:9a07 with SMTP id a17-20020a170902ecd100b001dc8c279a07mr8455112plh.31.1709782080902;
        Wed, 06 Mar 2024 19:28:00 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902784800b001da001aed18sm13593993pln.54.2024.03.06.19.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 19:28:00 -0800 (PST)
Message-ID: <8475706a-c6ba-45a2-b2ee-a4dc7f4621c5@gmail.com>
Date: Thu, 7 Mar 2024 11:27:55 +0800
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
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Kan Liang <kan.liang@linux.intel.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20230824020546.1108516-1-dapeng1.mi@linux.intel.com>
 <ZeepGjHCeSfadANM@google.com>
 <2677739b-bc84-43ee-ba56-a5e243148ceb@gmail.com>
 <CALMp9eQ531ZC-8-Y+gwLer9mCK-hZ9yVNQZAFE6z76RXkMNnPA@mail.gmail.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eQ531ZC-8-Y+gwLer9mCK-hZ9yVNQZAFE6z76RXkMNnPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/2024 11:09 pm, Jim Mattson wrote:
> On Wed, Mar 6, 2024 at 1:11 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 6/3/2024 7:22 am, Sean Christopherson wrote:
>>> +Mingwei
>>>
>>> On Thu, Aug 24, 2023, Dapeng Mi wrote:
>>>    diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>>> index 7d9ba301c090..ffda2ecc3a22 100644
>>>> --- a/arch/x86/kvm/pmu.h
>>>> +++ b/arch/x86/kvm/pmu.h
>>>> @@ -12,7 +12,8 @@
>>>>                                         MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>>>>
>>>>    /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
>>>> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
>>>> +#define fixed_ctrl_field(ctrl_reg, idx) \
>>>> +    (((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
>>>>
>>>>    #define VMWARE_BACKDOOR_PMC_HOST_TSC               0x10000
>>>>    #define VMWARE_BACKDOOR_PMC_REAL_TIME              0x10001
>>>> @@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>>>>
>>>>       if (pmc_is_fixed(pmc))
>>>>               return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>>>> -                                    pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>>>> +                                    pmc->idx - INTEL_PMC_IDX_FIXED) &
>>>> +                                    (INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
>>>>
>>>>       return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>>>>    }
>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>> index f2efa0bf7ae8..b0ac55891cb7 100644
>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>> @@ -548,8 +548,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>               setup_fixed_pmc_eventsel(pmu);
>>>>       }
>>>>
>>>> -    for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>>>> -            pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
>>>> +    for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>>> +            pmu->fixed_ctr_ctrl_mask &=
>>>> +                     ~intel_fixed_bits_by_idx(i,
>>>> +                                              INTEL_FIXED_0_KERNEL |
>>>> +                                              INTEL_FIXED_0_USER |
>>>> +                                              INTEL_FIXED_0_ENABLE_PMI);
>>>> +    }
>>>>       counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
>>>>               (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
>>>>       pmu->global_ctrl_mask = counter_mask;
>>>> @@ -595,7 +600,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>                       pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
>>>>                       for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>>>>                               pmu->fixed_ctr_ctrl_mask &=
>>>> -                                    ~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
>>>
>>> OMG, this might just win the award for most obfuscated PMU code in KVM, which is
>>> saying something.  The fact that INTEL_PMC_IDX_FIXED happens to be 32, the same
>>> bit number as ICL_FIXED_0_ADAPTIVE, is 100% coincidence.  Good riddance.
>>>
>>> Argh, and this goofy code helped introduce a real bug.  reprogram_fixed_counters()
>>> doesn't account for the upper 32 bits of IA32_FIXED_CTR_CTRL.
>>>
>>> Wait, WTF?  Nothing in KVM accounts for the upper bits.  This can't possibly work.
>>>
>>> IIUC, because KVM _always_ sets precise_ip to a non-zero bit for PEBS events,
>>> perf will _always_ generate an adaptive record, even if the guest requested a
>>> basic record.  Ugh, and KVM will always generate adaptive records even if the
>>> guest doesn't support them.  This is all completely broken.  It probably kinda
>>> sorta works because the Basic info is always stored in the record, and generating
>>> more info requires a non-zero MSR_PEBS_DATA_CFG, but ugh.
>>
>> Yep, it works at least on machines with both adaptive and pebs_full features.
>>
>> I remember one generation of Atom core (? GOLDMONT) that didn't have both
>> above PEBS sub-features, so we didn't set x86_pmu.pebs_ept on that platform.
>>
>> Mingwei or others are encouraged to construct use cases in KUT::pmu_pebs.flat
>> that violate guest-pebs rules (e.g., leak host state), as we all recognize that
>> testing
>> is the right way to condemn legacy code, not just lengthy emails.
>>
>>>
>>> Oh great, and it gets worse.  intel_pmu_disable_fixed() doesn't clear the upper
>>> bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set.  Unless I'm misreading the code,
>>> intel_pmu_enable_fixed() effectively doesn't clear ICL_FIXED_0_ADAPTIVE either,
>>> as it only modifies the bit when it wants to set ICL_FIXED_0_ADAPTIVE.
>>>
>>> *sigh*
>>>
>>> I'm _very_ tempted to disable KVM PEBS support for the current PMU, and make it
>>> available only when the so-called passthrough PMU is available[*].  Because I
>>> don't see how this is can possibly be functionally correct, nor do I see a way
>>> to make it functionally correct without a rather large and invasive series.
>>
>> Considering that I've tried the idea myself, I have no inclination towards
>> "passthrough PMU", and I'd like to be able to take the time to review that
>> patchset while we all wait for a clear statement from that perf-core man,
>> who don't really care about virtualization and don't want to lose control
>> of global hardware resources.
>>
>> Before we actually get to that ideal state you want, we have to deal with
>> some intermediate state and face to any users that rely on the current code,
>> you had urged to merge in a KVM document for vPMU, not sure how far
>> along that part of the work is.
>>
>>>
>>> Ouch.  And after chatting with Mingwei, who asked the very good question of
>>> "can this leak host state?", I am pretty sure that yes, this can leak host state.
>>
>> The Basic Info has a tsc field, I suspect it's the host-state-tsc.
>>
>>>
>>> When PERF_CAP_PEBS_BASELINE is enabled for the guest, i.e. when the guest has
>>> access to adaptive records, KVM gives the guest full access to MSR_PEBS_DATA_CFG
>>>
>>>        pmu->pebs_data_cfg_mask = ~0xff00000full;
>>>
>>> which makes sense in a vacuum, because AFAICT the architecture doesn't allow
>>> exposing a subset of the four adaptive controls.
>>>
>>> GPRs and XMMs are always context switched and thus benign, but IIUC, Memory Info
>>> provides data that might now otherwise be available to the guest, e.g. if host
>>> userspace has disallowed equivalent events via KVM_SET_PMU_EVENT_FILTER.
>>
>> Indeed, KVM_SET_PMU_EVENT_FILTER doesn't work in harmony with
>> guest-pebs, and I believe there is a big problem here, especially with the
>> lack of targeted testing.
>>
>> One reason for this is that we don't use this cockamamie API in our
>> large-scale production environments, and users of vPMU want to get real
>> runtime information about physical cpus, not just virtualised hardware
>> architecture interfaces.
>>
>>>
>>> And unless I'm missing something, LBRs are a full leak of host state.  Nothing
>>> in the SDM suggests that PEBS records honor MSR intercepts, so unless KVM is
>>> also passing through LBRs, i.e. is context switching all LBR MSRs, the guest can
>>> use PEBS to read host LBRs at will.
>>
>> KVM is also passing through LBRs when guest uses LBR but not at the
>> granularity of vm-exit/entry. I'm not sure if the LBR_EN bit is required
>> to get LBR information via PEBS, also not confirmed whether PEBS-lbr
>> can be enabled at the same time as independent LBR;
>>
>> I recall that PEBS-assist, per cpu-arch, would clean up this part of the
>> record when crossing root/non-root boundaries, or not generate record.
>>
>> We're looking forward to the tests that will undermine this perception.
>>
>> There are some devilish details during the processing of vm-exit and
>> the generation of host/guest pebs, and those interested can delve into
>> the short description in this SDM section "20.9.5 EPT-Friendly PEBS".
>>
>>>
>>> Unless someone chimes in to point out how PEBS virtualization isn't a broken mess,
>>> I will post a patch to effectively disable PEBS virtualization.
>>
>> There are two factors that affect the availability of guest-pebs:
>>
>> 1. the technical need to use core-PMU in both host/guest worlds;
>> (I don't think Googlers are paying attention to this part of users' needs)
> 
> Let me clear up any misperceptions you might have that Google alone is
> foisting the pass-through PMU on the world. The work so far has been a
> collaboration between Google and Intel. Now, AMD has joined the
> collaboration as well. Mingwei is taking the lead on the project, but
> Googlers are outnumbered by the x86 CPU vendors ten to one.

This is such great news.

> 
> The pass-through PMU allows both the host and guest worlds to use the
> core PMU, more so than the existing vPMU implementation. I assume your

Can I further confirm that in any case, host/guest can use PMU resources,
such as some special more accurate counters ? Is there an end of story
for that static partitioning scheme ?

> complaint is about the desire for host software to monitor guest
> behavior with core PMU events while the guest is running. Today,
> Google Cloud does this for fleet management, and losing this
> capability is not something we are looking forward to. However, the
> writing is on the wall: Coco is going to take this capability away
> from us anyway.

Coco pays a corresponding performance cost, and it's a paradox to hide
any performance trace of coco-guests from host's point of view.

Thanks for the input, Jim. Let me try to help.

> 
>> 2. guest-pebs is temporarily disabled in the case of cross-mapping counter,
>> which reduces the number of performance samples collected by guest;
>>
>>>
>>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>>> index 41a4533f9989..a2f827fa0ca1 100644
>>> --- a/arch/x86/kvm/vmx/capabilities.h
>>> +++ b/arch/x86/kvm/vmx/capabilities.h
>>> @@ -392,7 +392,7 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>>
>>>    static inline bool vmx_pebs_supported(void)
>>>    {
>>> -       return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>>> +       return false;
>>
>> As you know, user-space VMM may disable guest-pebs by filtering out the
>> MSR_IA32_PERF_CAPABILITIE.PERF_CAP_PEBS_FORMAT or CPUID.PDCM.
>>
>> In the end, if our great KVM maintainers insist on doing this,
>> there is obviously nothing I can do about it.
>>
>> Hope you have a good day.
>>
>>>    }
>>>
>>>    static inline bool cpu_has_notify_vmexit(void)
>>>
>>

