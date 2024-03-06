Return-Path: <kvm+bounces-11099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20719872D78
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 04:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DC7A1F26060
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8506614263;
	Wed,  6 Mar 2024 03:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IUQwDYVz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411ABD531;
	Wed,  6 Mar 2024 03:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709695393; cv=none; b=HLCYbzNzoo4FauP7OIQxEvwIk49jFITfRfU66B6M1AvCfUAFtE+zfeMuwiN0TKqKarBtTfnFrHFArC0QrbJs+wXhFyPbFP0T+9yVp+WW4HgzrdAoo3o1p3EpyNmCmBeaSb1QWOpM96ASpSRW85Wprs5seWlMnVxW/5fqAhvzq5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709695393; c=relaxed/simple;
	bh=Uwcz4/A4IoODdZkF+3IOgv9IdbSd6g8+7aQ4xutr+FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvGGLqc7xQxNar9NZAs4/GDGO9vl31VTgwLL4LrFXpUqf+ibchzrQ3lqWRgxAp+h6I6jHTv1u5faXUrp+igvySFU5zfXh55XxwKdalkl4xY7RysLgdJIVI/Nt0JVhbVUX3tn6qaDTY5Seygx6yma2pbjzlvLCO9OxPzrvxZmgQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IUQwDYVz; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc3b4b9b62so3387805ad.1;
        Tue, 05 Mar 2024 19:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709695391; x=1710300191; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I7SSg8AIgzKewqZCSzR0RY/+oUCNKfZMo17+FX3RYsA=;
        b=IUQwDYVzKzXzlrkOm1AovbIEp9JwKf4gq7qTUwIyrpK21WD5G+RYHMrNv6mndOGJxx
         h+saVfOChkOrcutkpmGckZJAg6mwtGHgaTHQtp7OVbpwtCtOtobYe+qTGLBH3zM/dLJR
         PHXwcMtGCqTHOSD4YJ7QIXnjGkS5/1FZnulRqGtA3l0ehM7xHvpTkJZ5K0haN0WoUHIT
         IJ9kKykjp7q3+tvjhlqIE8WNZ0kG8zWMUnykgp14RP5WjKdPVkKcKIZgZtNSUMuZgqTA
         RgGut26hOCwMCyZI+YdeR8wM35pxgEwaoBGPqtZ2XZJmDdh2ztPwWLIy0WYHZojaahV9
         DtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709695391; x=1710300191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7SSg8AIgzKewqZCSzR0RY/+oUCNKfZMo17+FX3RYsA=;
        b=uWIIDaj34HAMcaX6elVAh8Ls9pBadREFQh7CA1TvQ5si26PYXfLJUlwuNZZi2GWSfp
         b/E9nOOmt8KmmtUtjvL5Z6AlhT8eUzwp0WUbug1ZxoRPkdXu1YEF64T5zj9ip2ZOfp0+
         /N/jjiRLD2OBEbeqhJKpbwg4Q1nrzijLnXXUhKhuki4rT4YbCFeXxvQkeFy+jhVBW2r0
         A7QkOIFd7emMYAEExZ3WY4pEzl/ymyTER8NwBRhDiTLOIu2D7oK4KKiSrfYg9HNvuDYs
         KXRFg8J4YJTgdNIzQYqH/tke4YIiewFlcKV+u2Vb1VhUgo5ZIR2ypTZKlGYFi5lt3Trl
         T45g==
X-Forwarded-Encrypted: i=1; AJvYcCUHBd9Z5Hhxkivx24Ee9epsteOkXRnRC84JecDuBRNQBHhr2IRjJ+bkcLpv2Zx6fmX3sGfSDhmFgQNojGjEZatDEfBA9+XE8JNxZWUr8RZMW/B5GpNvna0yjKKLn0FBbDTG
X-Gm-Message-State: AOJu0YzCd7nRmMU1id4ThoPo95X7jQiBIBwxR0J+GpnMw+AR96L1SFnV
	+IVcedvpwQ2JSqq9etUKrL9YvQcZtpZhYjgS/Bvn6IqP2CbsuNTZ
X-Google-Smtp-Source: AGHT+IGK1Mb12jjGGbSWsxZ4/QCn/reyE21HqNjeoJjIxV99sIfG4cZGI3vG+fvpgBvn+AqBXVhztw==
X-Received: by 2002:a17:902:e886:b0:1dc:6071:60ad with SMTP id w6-20020a170902e88600b001dc607160admr5838812plg.24.1709695391252;
        Tue, 05 Mar 2024 19:23:11 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d48500b001db9cb62f7bsm11400580plg.153.2024.03.05.19.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 19:23:10 -0800 (PST)
Message-ID: <b7d8ea1b-7c43-4807-b589-092272c5679a@gmail.com>
Date: Wed, 6 Mar 2024 11:23:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Content-Language: en-US
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Sandipan Das <sandipan.das@amd.com>, pbonzini@redhat.com,
 mizhang@google.com, jmattson@google.com, ravi.bangoria@amd.com,
 nikunj.dadhania@amd.com, santosh.shukla@amd.com, manali.shukla@amd.com,
 babu.moger@amd.com, kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
 <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
 <ZedUwKWW7PNkvUH1@google.com> <ZedepdnKSl6oFNUq@google.com>
 <9f7f5e0b-de05-49f1-941f-29349d1b9280@linux.intel.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <9f7f5e0b-de05-49f1-941f-29349d1b9280@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/3/2024 10:32 am, Mi, Dapeng wrote:
> 
> On 3/6/2024 2:04 AM, Sean Christopherson wrote:
>> On Tue, Mar 05, 2024, Sean Christopherson wrote:
>>> On Tue, Mar 05, 2024, Like Xu wrote:
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index 87cc6c8809ad..f61ce26aeb90 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>>>    */
>>>   void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>>   {
>>> +    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> +
>>>       if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
>>>           return;
>>> @@ -750,8 +752,18 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>>        */
>>>       kvm_pmu_reset(vcpu);
>>> -    bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>>> +    bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>>>       static_call(kvm_x86_pmu_refresh)(vcpu);
>>> +
>>> +    /*
>>> +     * At RESET, both Intel and AMD CPUs set all enable bits for general
>>> +     * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
>>> +     * was written for v1 PMUs don't unknowingly leave GP counters disabled
>>> +     * in the global controls).  Emulate that behavior when refreshing the
>>> +     * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>>> +     */
>>> +    if (kvm_pmu_has_perf_global_ctrl(pmu))
>>> +        pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>>>   }
>> Doh, this is based on kvm/kvm-uapi, I'll rebase to kvm-x86/next before posting.
>>
>> I'll also update the changelog to call out that KVM has always clobbered 
>> global_ctrl
>> during PMU refresh, i.e. there is no danger of breaking existing setups by
>> clobbering a value set by userspace, e.g. during live migration.
>>
>> Lastly, I'll also update the changelog to call out that KVM *did* actually set
>> the general purpose counter enable bits in global_ctrl at "RESET" until v6.0,
>> and that KVM intentionally removed that behavior because of what appears to be
>> an Intel SDM bug.
>>
>> Of course, in typical KVM fashion, that old code was also broken in its own way
>> (the history of this code is a comedy of errors).  Initial vPMU support in commit
>> f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests") *almost*
>> got it right, but for some reason only set the bits if the guest PMU was
>> advertised as v1:
>>
>>          if (pmu->version == 1) {
>>                  pmu->global_ctrl = (1 << pmu->nr_arch_gp_counters) - 1;
>>                  return;
>>          }
>>
>>
>> Commit f19a0c2c2e6a ("KVM: PMU emulation: GLOBAL_CTRL MSR should be enabled on
>> reset") then tried to remedy that goof, but botched things and also enabled the
>> fixed counters:
>>
>>          pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
>>                  (((1ull << pmu->nr_arch_fixed_counters) - 1) << 
>> X86_PMC_IDX_FIXED);
>>          pmu->global_ctrl_mask = ~pmu->global_ctrl;
>>
>> Which was KVM's behavior up until commit c49467a45fe0 ("KVM: x86/pmu: Don't 
>> overwrite
>> the pmu->global_ctrl when refreshing") incorrectly removed *everything*.  Very
>> ironically, that commit came from Like.
>>
>> Author: Like Xu <likexu@tencent.com>
>> Date:   Tue May 10 12:44:07 2022 +0800
>>
>>      KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing
>>      Assigning a value to pmu->global_ctrl just to set the value of
>>      pmu->global_ctrl_mask is more readable but does not conform to the
>>      specification. The value is reset to zero on Power up and Reset but
>>      stays unchanged on INIT, like most other MSRs.
>>
>> But wait, it gets even better.  Like wasn't making up that behavior, Intel's SDM
>> circa December 2022 states that "Global Perf Counter Controls" is '0' at Power-Up
>> and RESET.  But then the March 2023 SDM rolls out and says
>>
>>    IA32_PERF_GLOBAL_CTRL: Sets bits n-1:0 and clears the upper bits.
>>
>> So presumably someone at Intel noticed that what their CPUs do and what the
>> documentation says didn't match.

This reminds me quite a bit of the past, where this kind of thing happened
occasionally (e.g. some pmu events don't count as expected, and ucode
updates often sneak in to change hardware behaviour). Sometimes we have
to rely on hardware behaviour, sometimes we have to trust the documentation
specification, my experience has been to find a balance that is more
favourable to the end-user and to force the hardware vendors to make
more careful documentation and implementation. :D

> 
> It's a really long story... thanks for figuring it out.
> 
>>
>> *sigh* >>
> 

