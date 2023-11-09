Return-Path: <kvm+bounces-1292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 457407E6452
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61EF01C20A86
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5083EDF58;
	Thu,  9 Nov 2023 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQMfyA0T"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3283DDAC
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:30:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6C42726;
	Wed,  8 Nov 2023 23:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699515007; x=1731051007;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ah6awO6TJYPqEBY79QJnkjDCK8oLzOlTj/Ln8MgS0Ps=;
  b=mQMfyA0TNodx/h4pGG+8um+Zbg7xhnkXLO44+KT0DoV3CmYJyqUj2LPa
   pD2VmUhcFjla9BqPhmix8OC/vjy2SQ48MUSAI6UC7uCFPiG4C0zNkEVzE
   MiqWVJEWYaHrFyL1UygDyYXeaibJ456kJaaAlj3f7CSHO3yNaW99jiakE
   RXcH5B62sjwZMNuVLHlUZWI6YXmULqf8BmNmxDHgvmEJMtHksx2xJI2zg
   39Q1oK5juAfoBb3dwQPC7KsrCe/m8FRnail/ea2TbHWCTg/YUtuSd3dh/
   RPs39vi2tu7UKA5yZhQVHx+7zUgZ7/7kD9O3Og1oKbJRhBDicAThFjOZy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="387098407"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="387098407"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:30:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="11062966"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:30:05 -0800
Message-ID: <ab10f933-b4ae-4784-a56c-b5d3bc2e3271@linux.intel.com>
Date: Thu, 9 Nov 2023 15:30:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/19] KVM: selftests: Test Intel PMU architectural
 events on fixed counters
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-11-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231108003135.546002-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/8/2023 8:31 AM, Sean Christopherson wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
>
> Extend the PMU counters test to validate architectural events using fixed
> counters.  The core logic is largely the same, the biggest difference
> being that if a fixed counter exists, its associated event is available
> (the SDM doesn't explicitly state this to be true, but it's KVM's ABI and
> letting software program a fixed counter that doesn't actually count would
> be quite bizarre).
>
> Note, fixed counters rely on PERF_GLOBAL_CTRL.
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 +++++++++++++++----
>   1 file changed, 45 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 5b8687bb4639..9cd308417aeb 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -150,26 +150,46 @@ static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature even
>   	guest_assert_event_count(idx, event, pmc, pmc_msr);
>   }
>   
> +#define X86_PMU_FEATURE_NULL						\
> +({									\
> +	struct kvm_x86_pmu_feature feature = {};			\
> +									\
> +	feature;							\
> +})
> +
> +static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
> +{
> +	return !(*(u64 *)&event);
> +}
> +
>   static void guest_test_arch_event(uint8_t idx)
>   {
>   	const struct {
>   		struct kvm_x86_pmu_feature gp_event;
> +		struct kvm_x86_pmu_feature fixed_event;
>   	} intel_event_to_feature[] = {
> -		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES },
> -		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED },
> -		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES },
> -		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES },
> -		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES },
> -		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
> -		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
> -		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS },
> +		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
> +		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
> +		/*
> +		 * Note, the fixed counter for reference cycles is NOT the same
> +		 * as the general purpose architectural event.  The fixed counter
> +		 * explicitly counts at the same frequency as the TSC, whereas
> +		 * the GP event counts at a fixed, but uarch specific, frequency.
> +		 * Bundle them here for simplicity.
> +		 */
> +		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
> +		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
>   	};
>   
>   	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>   	uint32_t pmu_version = guest_get_pmu_version();
>   	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
>   	bool guest_has_perf_global_ctrl = pmu_version >= 2;
> -	struct kvm_x86_pmu_feature gp_event;
> +	struct kvm_x86_pmu_feature gp_event, fixed_event;
>   	uint32_t base_pmc_msr;
>   	unsigned int i;
>   
> @@ -199,6 +219,22 @@ static void guest_test_arch_event(uint8_t idx)
>   		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
>   					MSR_P6_EVNTSEL0 + i, eventsel);
>   	}
> +
> +	if (!guest_has_perf_global_ctrl)
> +		return;
> +
> +	fixed_event = intel_event_to_feature[idx].fixed_event;
> +	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
> +		return;
> +
> +	i = fixed_event.f.bit;
> +
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
> +
> +	__guest_test_arch_event(idx, fixed_event, FIXED_PMC_RDPMC_BASE + i,
> +				MSR_CORE_PERF_FIXED_CTR0 + i,
> +				MSR_CORE_PERF_GLOBAL_CTRL,
> +				FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
>   }
>   
>   static void guest_test_arch_events(void)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


