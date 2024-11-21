Return-Path: <kvm+bounces-32228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 191539D452A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 01:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7456283661
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B227639FCE;
	Thu, 21 Nov 2024 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/sVbyAd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181EE230985;
	Thu, 21 Nov 2024 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732150573; cv=none; b=s7Kuv6dSj5moEW3ETY/LTLvULaXITKLWaJ2NeSdqb0FLaxZCELDq1xpqfOVlJAtExn3fwU4uAn9CX9PaGOxdmW9zHxDjcGAesSGQCb1vtsAzowpCLpjsQqXzs54T6WKBR/oN0ZC215qJrStU3rLiIZuETErVJuizrF07jkrYqmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732150573; c=relaxed/simple;
	bh=wp8y51ikTxFILk/YOttk603dlAU0m7y9CC1/E9YA9jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P4Kzy4I0f3MoIEf+/BWgd/NMkZr+yhNAfrDNufR9dH9NNsDtbYXgmSX+R6co0mxqBMq1nd4tPVaDV/5Hto3+sRilipg3cukqbzc++Tkpl1OQCToiiE1c1yOPnuFKpaDXcqx7oikplKz/wKfw4urQVaKqbfiOfnYn3GMlPQ1MNRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/sVbyAd; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732150572; x=1763686572;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wp8y51ikTxFILk/YOttk603dlAU0m7y9CC1/E9YA9jI=;
  b=i/sVbyAdgPt7UvVyN2x6StcDIWt39A8CyRhGIw5nhsfJaxKI6L44cbUj
   6DfOb8N6PBBdZDm3R7eDAkKAZK8tu3AViEwtmSkmTnRADFyJl3B5Xq6k8
   2w9PDv9Dn+KhvAoKHM/4iupQlKkGTv2lAHSt1V6FhTyb09IzhzUOknEw/
   DMD2cjn0ee2avku71KRKlTAjLj2RstAkIIZOuF2kzSsfl/YE2LeafGmRJ
   HSTDq/+M39gNlmqoaAQL0vnPLk+BXolC4tjcwArjUOLqqPiS0zQug2Msk
   0l2BY3VXtCqNVpf7epYyzQ9bMBIHZrfXt2I4eqO5d64O5+RR19oxhhTSc
   w==;
X-CSE-ConnectionGUID: x8IYlS9qQ3ukpnd+8DFZZw==
X-CSE-MsgGUID: MRMHUUqqSVurwQlgSMbCKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32487998"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="32487998"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:56:11 -0800
X-CSE-ConnectionGUID: yk3P3JtZQ+6j7uQP+Kvp5Q==
X-CSE-MsgGUID: kiVniXDaR2iln6k6ZuM8nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90486051"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:56:03 -0800
Message-ID: <ac97cd9e-9ddf-4796-ae40-3d50791548e9@linux.intel.com>
Date: Thu, 21 Nov 2024 08:56:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 31/58] KVM: x86/pmu: Add counter MSR and selector
 MSR index into struct kvm_pmc
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
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
 <20240801045907.4010984-32-mizhang@google.com> <ZzzfwXefHP7SG-Vy@google.com>
 <01b6dc80-8cb6-4b13-9d0f-db3a07672532@linux.intel.com>
 <Zz4cuXfFtXzRAWvC@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz4cuXfFtXzRAWvC@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 1:30 AM, Sean Christopherson wrote:
> On Wed, Nov 20, 2024, Dapeng Mi wrote:
>> On 11/20/2024 2:58 AM, Sean Christopherson wrote:
>>> Please squash this with the patch that does the actual save/load.  Hmm, maybe it
>>> should be put/load, now that I think about it more?  That's more consitent with
>>> existing KVM terminology.
>> Sure. I ever noticed that this in-consistence, but "put" seem not so
>> intuitionistic as "save", so didn't change it.
> Yeah, "put" isn't perfect, but neither is "save", because the save/put path also
> purges hardware state.
>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 4b3ce6194bdb..603727312f9c 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -522,6 +522,8 @@ struct kvm_pmc {
>>>>  	 */
>>>>  	u64 emulated_counter;
>>>>  	u64 eventsel;
>>>> +	u64 msr_counter;
>>>> +	u64 msr_eventsel;
>>> There's no need to track these per PMC, the tracking can be per PMU, e.g.
>>>
>>> 	u64 gp_eventsel_base;
>>> 	u64 gp_counter_base;
>>> 	u64 gp_shift;
>>> 	u64 fixed_base;
>>>
>>> Actually, there's no need for a per-PMU fixed base, as that can be shoved into
>>> kvm_pmu_ops.  LOL, and the upcoming patch hardcodes INTEL_PMC_FIXED_RDPMC_BASE.
>>> Naughty, naughty ;-)
>>>
>>> It's not pretty, but 16 bytes per PMC isn't trivial. 
>>>
>>> Hmm, actually, scratch all that.  A better alternative would be to provide a
>>> helper to put/load counter/selector MSRs, and call that from vendor code.  Ooh,
>>> I think there's a bug here.  On AMD, the guest event selector MSRs need to be
>>> loaded _before_ PERF_GLOBAL_CTRL, no?  I.e. enable the guest's counters only
>>> after all selectors have been switched AMD64_EVENTSEL_GUESTONLY.  Otherwise there
>>> would be a brief window where KVM could incorrectly enable counters in the host.
>>> And the reverse that for put().
>>>
>>> But Intel has the opposite ordering, because MSR_CORE_PERF_GLOBAL_CTRL needs to
>>> be cleared before changing event selectors.
>> Not quite sure about AMD platforms, but it seems both Intel and AMD
>> platforms follow below sequence to manipulated PMU MSRs.
>>
>> disable PERF_GLOBAL_CTRL MSR
>>
>> manipulate counter-level PMU MSR
>>
>> enable PERF_GLOBAL_CTRL MSR
> Nope.  kvm_pmu_restore_pmu_context() does:
>
> 	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
>
>
> 	/*
> 	 * No need to zero out unexposed GP/fixed counters/selectors since RDPMC
> 	 * in this case will be intercepted. Accessing to these counters and
> 	 * selectors will cause #GP in the guest.
> 	 */
> 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> 		pmc = &pmu->gp_counters[i];
> 		wrmsrl(pmc->msr_counter, pmc->counter);
> 		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel_hw);
> 	}
>
> 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> 		pmc = &pmu->fixed_counters[i];
> 		wrmsrl(pmc->msr_counter, pmc->counter);
> 	}
>
> And amd_restore_pmu_context() does:
>
> 	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
> 	rdmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, global_status);
>
> 	/* Clear host global_status MSR if non-zero. */
> 	if (global_status)
> 		wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, global_status);
>
> 	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, pmu->global_status);
>
> 	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, pmu->global_ctrl);
>
> So the sequence on AMD is currently:
>
>   disable PERF_GLOBAL_CTRL
>
>   save host PERF_GLOBAL_STATUS 
>
>   load guest PERF_GLOBAL_STATUS (clear+set)
>
>   load guest PERF_GLOBAL_CTRL
>
>   load guest per-counter MSRs

Checked again, yes, indeed. So the better way to handle this is to define a
common helper to manipulate counters MSR in the common code, but call this
common helper in the vendor specific callback.




