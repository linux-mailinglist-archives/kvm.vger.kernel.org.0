Return-Path: <kvm+bounces-20200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCFF9118C4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 04:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 908F41F22AA7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB33284E0B;
	Fri, 21 Jun 2024 02:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R4Y8ZR/i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC6AB65D;
	Fri, 21 Jun 2024 02:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718937314; cv=none; b=V4dGyZsVf1QAHd0zG72yqkHoy+tZO7T+Hiw1saMAkG9aPPNY+AxjR9bZZni37OjtY46CQmWZvX0ESf2WmUMoCGN6auYo6P5D/GEEdE6VyE/YDxfRVMVFPFmLobK+TPgAB/2YdUHjg/Y3TXv4QeRMP0g4HsnclBydHcTIdxB49/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718937314; c=relaxed/simple;
	bh=w8HpJs4mPUMmNvptnNHOsaZh4VS8SUO/0nFuF/PdTAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=haNBhfv45T+Vz7+xaUOc6cdq+n1d2IaHh+epV23LOqukrQc2ng+zmV1WoXDYA4Rb2PlhC/JFt5BRqZgNdkFhs0p4vr9AZ8OssBrb90LNwQwydYKAq0fq9lVngEXEDrLaDBpcuDgP8KVBwZz2Hvw91//m/+N4DzN0caBWblIwZLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R4Y8ZR/i; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718937312; x=1750473312;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w8HpJs4mPUMmNvptnNHOsaZh4VS8SUO/0nFuF/PdTAw=;
  b=R4Y8ZR/ilL1qw/25u7lFtpzbNq3ywdd4CwTL/Q369G1x2jeSrHNzAFt5
   y1BLT0g5za6ga8QDVd20RZHCSvwKfVDDGq0hnXjFddQwFwbnhfoD3dwsr
   BK1iGKZOLbSsXMK1AbqzHKvrtO/AYHpOsAFFN+dHj+pmkePZBhz7ROx71
   XfPApoOP/Nc/OWdfwgW3fZOlmzXYKdGMPnfU+bDcC1T/KlR8OUSM2Wn7Y
   vWa3ESV19p7eEXh2KpTfaZELHUV2jMolEpQrZB7D1TXEfhyDkHiOnqRZC
   ZLXgG3RXslgfAXqo5KUSDnTfNONpYLTc6ul/uYxs+8I7NKtAlGR/JZQGo
   A==;
X-CSE-ConnectionGUID: hJ3cHKU9T7W/0zkNNVYkFg==
X-CSE-MsgGUID: SjzrjoSUSAyhqe0qQEiAwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16098470"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="16098470"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 19:35:12 -0700
X-CSE-ConnectionGUID: dpSaqV5vT52yXRHFp4Guhw==
X-CSE-MsgGUID: bDz7oTLlQ6mMkgM0qQtcJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42526012"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 19:35:08 -0700
Message-ID: <4b57f565-25b0-4b97-ac78-4913a8b1d225@linux.intel.com>
Date: Fri, 21 Jun 2024 10:35:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Define KVM_PMC_MAX_GENERIC for platform
 independence
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
 <20240619182128.4131355-2-dapeng1.mi@linux.intel.com>
 <ZnRV6XrKkVwZB2TN@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZnRV6XrKkVwZB2TN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/21/2024 12:16 AM, Sean Christopherson wrote:
> On Thu, Jun 20, 2024, Dapeng Mi wrote:
>> The existing macro, KVM_INTEL_PMC_MAX_GENERIC, ambiguously represents the
>> maximum supported General Purpose (GP) counter number for both Intel and
>> AMD platforms. This could lead to issues if AMD begins to support more GP
>> counters than Intel.
>>
>> To resolve this, a new platform-independent macro, KVM_PMC_MAX_GENERIC,
>> is introduced to represent the maximum GP counter number across all x86
>> platforms.
>>
>> No logic changes are introduced in this patch.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 9 +++++----
>>  arch/x86/kvm/svm/pmu.c          | 2 +-
>>  arch/x86/kvm/vmx/pmu_intel.c    | 2 ++
>>  3 files changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 57440bda4dc4..18137be6504a 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -534,11 +534,12 @@ struct kvm_pmc {
>>  
>>  /* More counters may conflict with other existing Architectural MSRs */
>>  #define KVM_INTEL_PMC_MAX_GENERIC	8
>> -#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
>> -#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
>> +#define KVM_AMD_PMC_MAX_GENERIC	6
>> +#define KVM_PMC_MAX_GENERIC		KVM_INTEL_PMC_MAX_GENERIC
> Since we're changing the macro, maybe take the opportunity to use a better name?
> E.g. KVM_MAX_NR_GP_COUNTERS?  And then in a follow-up patch, give fixed counters
> the same treatment, e.g. KVM_MAX_NR_FIXED_COUNTERS.  Or maybe KVM_MAX_NR_GP_PMCS
> and KVM_MAX_NR_FIXED_PMCS?

Yeah, would change to KVM_MAX_NR_GP_COUNTERS and KVM_MAX_NR_FIXED_COUNTERS
in next version.


>
>> +#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_PMC_MAX_GENERIC - 1)
>> +#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_PMC_MAX_GENERIC - 1)
> And I'm very, very tempted to say we should simply delete these two, along with
> MSR_ARCH_PERFMON_FIXED_CTR_MAX, and just open code the "end" MSR in the one user.
> Especially since "KVM" doesn't appear anyone in the name, i.e. because the names
> misrepresent KVM's semi-arbitrary max as the *architectural* max.

Agree. MSR_ARCH_PERFMON_PERFCTR_MAX indeed brings some misleading which
make users think it's a HW's limitation instead of KVM's limitation.


>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6ad19d913d31..547dfe40d017 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7432,17 +7432,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>                      intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2))
>                         return;
>                 break;
> -       case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
> +       case MSR_ARCH_PERFMON_PERFCTR0 ...
> +            MSR_ARCH_PERFMON_PERFCTR0 + KVM_MAX_NR_GP_COUNTERS - 1:
>                 if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
>                     kvm_pmu_cap.num_counters_gp)
>                         return;
>                 break;
> -       case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
> +       case MSR_ARCH_PERFMON_EVENTSEL0 ...
> +            MSR_ARCH_PERFMON_EVENTSEL0 + KVM_MAX_NR_GP_COUNTERS - 1:
>                 if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
>                     kvm_pmu_cap.num_counters_gp)
>                         return;
>                 break;
> -       case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
> +       case MSR_ARCH_PERFMON_FIXED_CTR0 ...
> +            MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_MAR_NR_FIXED_COUNTERS - 1:
>                 if (msr_index - MSR_ARCH_PERFMON_FIXED_CTR0 >=
>                     kvm_pmu_cap.num_counters_fixed)
>                         return;

Thanks.


>
>>  #define KVM_PMC_MAX_FIXED	3
>>  #define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
>> -#define KVM_AMD_PMC_MAX_GENERIC	6
>>  
>>  struct kvm_pmu {
>>  	u8 version;
>> @@ -554,7 +555,7 @@ struct kvm_pmu {
>>  	u64 global_status_rsvd;
>>  	u64 reserved_bits;
>>  	u64 raw_event_mask;
>> -	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
>> +	struct kvm_pmc gp_counters[KVM_PMC_MAX_GENERIC];
>>  	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
>>  
>>  	/*
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index 6e908bdc3310..2fca247798eb 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -218,7 +218,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
>>  	int i;
>>  
>>  	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > AMD64_NUM_COUNTERS_CORE);
>> -	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
>> +	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
>>  
>>  	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
>>  		pmu->gp_counters[i].type = KVM_PMC_GP;
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index fb5cbd6cbeff..a4b0bee04596 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -570,6 +570,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>  	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>  
>> +	BUILD_BUG_ON(KVM_INTEL_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
> Rather than BUILD_BUG_ON() for both Intel and AMD, can't we just do?
>
> #define KVM_MAX_NR_GP_COUNTERS max(KVM_INTEL_PMC_MAX_GENERIC, KVM_AMD_PMC_MAX_GENERIC)

Actually I tried this, but compiler would report the below error since
KVM_PMC_MAX_GENERIC would used to define the array
gp_counters[KVM_PMC_MAX_GENERIC];

./include/linux/minmax.h:48:50: error: braced-group within expression
allowed only inside a function

>
>> +
>>  	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
>>  		pmu->gp_counters[i].type = KVM_PMC_GP;
>>  		pmu->gp_counters[i].vcpu = vcpu;
>> -- 
>> 2.34.1
>>

