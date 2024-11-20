Return-Path: <kvm+bounces-32139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9949D380C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 11:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2494E1F21F7A
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 10:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B785E19D89B;
	Wed, 20 Nov 2024 10:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HzHTM30m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A941990C0;
	Wed, 20 Nov 2024 10:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732097549; cv=none; b=SX7rEoZ7tb5fX3QCDKJSF9JeoauudNK9LFXFIoocf1YT9hm/QGC5wrZczAwIWkcO4UNXT2wM3RfqittnC8RriQGsnBNKGnGH1ZfWKaBmxwUSrftvmaFk481TGMJBDat/L52sRCV7lngOCNMUMjZdCP/DDxP+EpYvBWMaBhYJIns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732097549; c=relaxed/simple;
	bh=1iq5LwZDW/dQe89CPqcHPntXsHFqWx0E8SZYJTsVF9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GSDLAta4Rohc3oZzknLMHLA1qTkxDlooBg6EEz65dWZeQkEW7Nt/rAXK8gyvDokLQZqpI3vVT85B2ieHDXU4BgF9RjCIQNfC7hS7RHq4rYMSKmM6ortEdKLuxvHelawOTqQHAJwiEYbfq//tADOW9G2niGfxb9ta0Y3EB4Vkm5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HzHTM30m; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732097548; x=1763633548;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1iq5LwZDW/dQe89CPqcHPntXsHFqWx0E8SZYJTsVF9g=;
  b=HzHTM30mpi2nkbDkn7YT0+gKe1ySPH0hGDtzzlCODhUh58uhadfKo7+8
   CIb2vs63ySxkj9VUJbBYJIeikrEH40ZZoqVVS6noWz+ZdUSOAsfAODdq+
   T4lPWelawHTP5UdzDHbWu2YQrPJNjobhD5tVbcc/pzL9D1Fo+4vVtLhC5
   RuurR4qHLH8mmCKYI7aLjdoYnqsUUyLz2JiaZAWr+SGm5SESXj9XPbtjr
   8xiSnFcJFgbB9JvTcnXb/L6hoPzNG1EnoPSRWhd7ExnYH9FkCrl2BISEf
   QIkETxb2YbewoEMaXqs41HZRwn1upd4FVMYBVGSokiIqEv78p9c2O0Tvt
   Q==;
X-CSE-ConnectionGUID: w/qfTOd9T06u7emJyuYTvw==
X-CSE-MsgGUID: ryADAcHMQZurXRY1jwdndw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32205819"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="32205819"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 02:12:26 -0800
X-CSE-ConnectionGUID: l0GEebiuQESySZnmbSKkNw==
X-CSE-MsgGUID: sum2nflCQ0mC0ZhxUsEOgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="120803198"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 02:12:22 -0800
Message-ID: <787182e1-75af-43dc-b7dd-179664022170@linux.intel.com>
Date: Wed, 20 Nov 2024 18:12:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 28/58] KVM: x86/pmu: Add
 intel_passthrough_pmu_msrs() to pass-through PMU MSRs
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-29-mizhang@google.com> <ZzzX0g0LtF_qHggI@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzzX0g0LtF_qHggI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 2:24 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 02c9019c6f85..737de5bf1eee 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -740,6 +740,52 @@ static bool intel_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
>>  	return true;
>>  }
>>  
>> +/*
>> + * Setup PMU MSR interception for both mediated passthrough vPMU and legacy
>> + * emulated vPMU. Note that this function is called after each time userspace
>> + * set CPUID.
>> + */
>> +static void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> Function verb is misleading.  This doesn't always "passthrough" MSRs, it's also
> responsible for enabling interception as needed.  intel_pmu_update_msr_intercepts()?

Yes, it's better. Thanks.


>
>> +{
>> +	bool msr_intercept = !is_passthrough_pmu_enabled(vcpu);
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	int i;
>> +
>> +	/*
>> +	 * Unexposed PMU MSRs are intercepted by default. However,
>> +	 * KVM_SET_CPUID{,2} may be invoked multiple times. To ensure MSR
>> +	 * interception is correct after each call of setting CPUID, explicitly
>> +	 * touch msr bitmap for each PMU MSR.
>> +	 */
>> +	for (i = 0; i < kvm_pmu_cap.num_counters_gp; i++) {
>> +		if (i >= pmu->nr_arch_gp_counters)
>> +			msr_intercept = true;
> Hmm, I like the idea and that y'all remembered to intercept unsupported MSRs, but
> it's way, way too easy to clobber msr_intercept and fail to re-initialize across
> for-loops.
>
> Rather than update the variable mid-loop, how about this?
>
> 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, intercept);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW,
> 					  intercept || !fw_writes_is_enabled(vcpu));
> 	}
> 	for ( ; i < kvm_pmu_cap.num_counters_gp; i++) {
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, true);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, true);
> 	}
>
> 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> 		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, intercept);
> 	for ( ; i < kvm_pmu_cap.num_counters_fixed; i++)
> 		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, true);

Yeah, it's indeed better.


>
>
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, msr_intercept);
>> +		if (fw_writes_is_enabled(vcpu))
>> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, msr_intercept);
>> +		else
>> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, true);
>> +	}
>> +
>> +	msr_intercept = !is_passthrough_pmu_enabled(vcpu);
>> +	for (i = 0; i < kvm_pmu_cap.num_counters_fixed; i++) {
>> +		if (i >= pmu->nr_arch_fixed_counters)
>> +			msr_intercept = true;
>> +		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, msr_intercept);
>> +	}
>> +
>> +	if (pmu->version > 1 && is_passthrough_pmu_enabled(vcpu) &&
> Don't open code kvm_pmu_has_perf_global_ctrl().

Oh, yes.


>
>> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
>> +	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed)
>> +		msr_intercept = false;
>> +	else
>> +		msr_intercept = true;
> This reinforces that checking PERF_CAPABILITIES for PERF_METRICS is likely doomed
> to fail, because doesn't PERF_GLOBAL_CTRL need to be intercepted, strictly speaking,
> to prevent setting EN_PERF_METRICS?

Sean, do you mean we need to check if guest supports PERF_METRICS here? If
not, we need to set global MSRs to interception and then avoid guest tries
to enable guest PERF_METRICS, right?



>
>> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_STATUS, MSR_TYPE_RW, msr_intercept);
>> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, MSR_TYPE_RW, msr_intercept);
>> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, msr_intercept);
>> +}
>> +
>>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>>  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
>> @@ -752,6 +798,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>  	.deliver_pmi = intel_pmu_deliver_pmi,
>>  	.cleanup = intel_pmu_cleanup,
>>  	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
>> +	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
>>  	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
>>  	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
>>  	.MIN_NR_GP_COUNTERS = 1,
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

