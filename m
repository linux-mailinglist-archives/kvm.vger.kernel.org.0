Return-Path: <kvm+bounces-32232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5C59D45BA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 964D3B21F05
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 02:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795AD70802;
	Thu, 21 Nov 2024 02:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Od3lXT9z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797A319A;
	Thu, 21 Nov 2024 02:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732156068; cv=none; b=sqG9grz74sgD8zMoNBVbqs0o3aQItQqUQuCV5PoL7W9n59mV5MtRvjQ9K5KMlRHQ0mZZJNjtCQ8TnVV2jz1rEolOjOX5FzwlUiOkUpzb14IIPN7zd/VVPXKOtn1X9f8czGCfgOFpYxcJZoLPOYt5kP+MBGHcWDmmPOy2gUFEHgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732156068; c=relaxed/simple;
	bh=eCj6uHDa+5octspOeYFmOuOHvTUjj+XdOehtLO6B0Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PE+JMJSTCOFId97iPhSkdDu6GQGAIIFWv9nIEv3EOLE3HWaMuslrBbH0EIrJdcSJ+PHoZj8tS/x6g8RQwnRO/IH39v4HP6yHqbH4XPJkPQ8DABhfmxgxGKd1JU2QJCAazVh0UoaRdFy6pVIlUTLU0uSkqnEEZt/RihgelaRvYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Od3lXT9z; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732156066; x=1763692066;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eCj6uHDa+5octspOeYFmOuOHvTUjj+XdOehtLO6B0Hc=;
  b=Od3lXT9zCkr+vMe4AVuLMgA82VR62VRFSWdvrh3Y6bAdLsYuMEOqcWd0
   d1jabMUeAnwsY2ODfPOQYw60OCEH72kSFkW9MssLozrSzOPAv5eOgYWF3
   WJQt9SrD9glpdnK1FMU61NKU5Mnvia/QPSPS/kDUtcm5/topgcQL0+twm
   JcrWsyWA/4C6uf1VHZuaCdgUXCtXXhVPLrOXGFKwWvR3h4IZonpb8Gh3b
   Pt/N0Uiuy1AlP7RMQMWdGsYSNP7qGTwkifcDN5w0rfZaJOVmriIJyXiGK
   XenygOp6AjVkEjoECDopdRhjtbalfe/1EmWs2Jsb0vTKaUW2sZ/QFYVGT
   A==;
X-CSE-ConnectionGUID: j6WYiarKT+ue+ErY6feA/g==
X-CSE-MsgGUID: 9IL7N91JQzWlyOSmX53X7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32177542"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="32177542"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:27:46 -0800
X-CSE-ConnectionGUID: yww0pjE+Qn2y8H041xVQCw==
X-CSE-MsgGUID: LV8Emal/R6yQu9YLWzWzsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90271704"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:27:40 -0800
Message-ID: <a6ee6477-0961-40d2-8098-a4b1d0a14140@linux.intel.com>
Date: Thu, 21 Nov 2024 10:27:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 44/58] KVM: x86/pmu: Implement emulated counter
 increment for passthrough PMU
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
 <20240801045907.4010984-45-mizhang@google.com> <Zz5DBddNFb-gZra1@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5DBddNFb-gZra1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 4:13 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Implement emulated counter increment for passthrough PMU under KVM_REQ_PMU.
>> Defer the counter increment to KVM_REQ_PMU handler because counter
>> increment requests come from kvm_pmu_trigger_event() which can be triggered
>> within the KVM_RUN inner loop or outside of the inner loop. This means the
>> counter increment could happen before or after PMU context switch.
>>
>> So process counter increment in one place makes the implementation simple.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/kvm/pmu.c | 41 +++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 39 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 5cc539bdcc7e..41057d0122bd 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -510,6 +510,18 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>>  				     eventsel & ARCH_PERFMON_EVENTSEL_INT);
>>  }
>>  
>> +static void kvm_pmu_handle_event_in_passthrough_pmu(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +
>> +	static_call_cond(kvm_x86_pmu_set_overflow)(vcpu);
>> +
>> +	if (atomic64_read(&pmu->__reprogram_pmi)) {
>> +		kvm_make_request(KVM_REQ_PMI, vcpu);
>> +		atomic64_set(&pmu->__reprogram_pmi, 0ull);
>> +	}
>> +}
>> +
>>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>>  {
>>  	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
>> @@ -517,6 +529,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>>  	struct kvm_pmc *pmc;
>>  	int bit;
>>  
>> +	if (is_passthrough_pmu_enabled(vcpu))
>> +		return kvm_pmu_handle_event_in_passthrough_pmu(vcpu);
>> +
>>  	bitmap_copy(bitmap, pmu->reprogram_pmi, X86_PMC_IDX_MAX);
>>  
>>  	/*
>> @@ -848,6 +863,17 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>>  	kvm_pmu_reset(vcpu);
>>  }
>>  
>> +static void kvm_passthrough_pmu_incr_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>> +{
>> +	if (static_call(kvm_x86_pmu_incr_counter)(pmc)) {
> This is absurd.  It's the same ugly code in both Intel and AMD.
>
> static bool intel_incr_counter(struct kvm_pmc *pmc)
> {
> 	pmc->counter += 1;
> 	pmc->counter &= pmc_bitmask(pmc);
>
> 	if (!pmc->counter)
> 		return true;
>
> 	return false;
> }
>
> static bool amd_incr_counter(struct kvm_pmc *pmc)
> {
> 	pmc->counter += 1;
> 	pmc->counter &= pmc_bitmask(pmc);
>
> 	if (!pmc->counter)
> 		return true;
>
> 	return false;
> }
>
>> +		__set_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->global_status);
> Using __set_bit() is unnecessary, ugly, and dangerous.  KVM uses set_bit(), no
> underscores, for things like reprogram_pmi because the updates need to be atomic.
>
> The downside of __set_bit() and friends is that if pmc->idx is garbage, KVM will
> clobber memory, whereas BIT_ULL(pmc->idx) is "just" undefined behavior.  But
> dropping the update is far better than clobbering memory, and can be detected by
> UBSAN (though I doubt anyone is hitting this code with UBSAN).
>
> For this code, a regular ol' bitwise-OR will suffice.  
>
>> +		kvm_make_request(KVM_REQ_PMU, vcpu);
>> +
>> +		if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT)
>> +			set_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
> This is badly in need of a comment, and the ordering is unnecessarily weird.
> Set bits in reprogram_pmi *before* making the request.  It doesn't matter here
> since this is all on the same vCPU, but it's good practice since KVM_REQ_XXX
> provides the necessary barriers to allow for safe, correct cross-CPU updates.
>
> That said, why on earth is the mediated PMU using KVM_REQ_PMU?  Set global_status
> and KVM_REQ_PMI, done.
>
>> +	}
>> +}
>> +
>>  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>>  {
>>  	pmc->emulated_counter++;
>> @@ -880,7 +906,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>>  	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
>>  }
>>  
>> -void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>> +static void __kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel,
>> +				    bool is_passthrough)
>>  {
>>  	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
>>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -914,9 +941,19 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>>  		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
>>  			continue;
>>  
>> -		kvm_pmu_incr_counter(pmc);
>> +		if (is_passthrough)
>> +			kvm_passthrough_pmu_incr_counter(vcpu, pmc);
>> +		else
>> +			kvm_pmu_incr_counter(pmc);
>>  	}
>>  }
>> +
>> +void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>> +{
>> +	bool is_passthrough = is_passthrough_pmu_enabled(vcpu);
>> +
>> +	__kvm_pmu_trigger_event(vcpu, eventsel, is_passthrough);
> Using an inner helper for this is silly, even if the mediated information were
> snapshot per-vCPU.  Just grab the snapshot in a local variable.  Using a param
> adds no value and unnecessarily obfuscates the code.
>
> That's all a moot point though, because (a) KVM can check enable_mediated_pmu
> directy and (b) pivoting on behavior belongs in kvm_pmu_incr_counter(), not here.
>
> And I am leaning towards having the mediated vs. perf-based code live in the same
> function, unless one or both is "huge", so that it's easier to understand and
> appreciate the differences in the implementations.
>
> Not an action item for y'all, but this is also a great time to add comments, which
> are sorely lacking in the code.  I am more than happy to do that, as it helps me
> understand (and thus review) the code.  I'll throw in suggestions here and there
> as I review.
>
> Anyways, this?
>
> static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
> {
> 	/*
> 	 * For perf-based PMUs, accumulate software-emulated events separately
> 	 * from pmc->counter, as pmc->counter is offset by the count of the
> 	 * associated perf event.  Request reprogramming, which will consult
> 	 * both emulated and hardware-generated events to detect overflow.
> 	 */
> 	if (!enable_mediated_pmu) {
> 		pmc->emulated_counter++;
> 		kvm_pmu_request_counter_reprogram(pmc);
> 		return;
> 	}
>
> 	/*
> 	 * For mediated PMUs, pmc->counter is updated when the vCPU's PMU is
> 	 * put, and will be loaded into hardware when the PMU is loaded.  Simply
> 	 * increment the counter and signal overflow if it wraps to zero.
> 	 */
> 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
> 	if (!pmc->counter) {
> 		pmc_to_pmu(pmc)->global_status) |= BIT_ULL(pmc->idx);
> 		kvm_make_request(KVM_REQ_PMI, vcpu);
> 	}
> }

Yes, thanks.




