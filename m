Return-Path: <kvm+bounces-1296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 242087E6492
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DFA71C209A4
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD15DF6A;
	Thu,  9 Nov 2023 07:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xi6ri2eG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DDEDDDB
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:43:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBDD271F;
	Wed,  8 Nov 2023 23:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699515793; x=1731051793;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jqubs9fYJv686NaIUFg20xBqeod3EjBkKJaXMFTyavM=;
  b=Xi6ri2eGBstP7hKRJRKqj+6LgRPlcVjrtCD3Vw7/zHFkpVCVC288utdh
   p10d5ajZgNp3osG8K6F55tFdBsdE/Nw2YQXEETWqwjmA2aU6R8akYpHXC
   aqxt+b5ksGDZs5nYgStbRZ8m0UlpD0pLiuhblTo/5Ccwsq+cIXptDGFhY
   n2PirGt8QW4AM8wAOjPbpZomBqmLFfikZDYXdM+vOvHZQ2PMaAIwUmbzD
   c6v8OfsSv8QXHFWIGyEA8vOka7VPSUCALvlw2aHaPqIErHnYo0FEHI4pL
   WTHDiyjarYENP5LR6sNb4soa3fVLzP+vBWvFw0LsJK9XvffaCK94lJIRZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="389740358"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="389740358"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:43:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766910589"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="766910589"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:43:10 -0800
Message-ID: <cb38a9c5-f068-45be-b018-fb9bcd7243d4@linux.intel.com>
Date: Thu, 9 Nov 2023 15:43:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/19] KVM: selftests: Expand PMU counters test to
 verify LLC events
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-15-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231108003135.546002-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/8/2023 8:31 AM, Sean Christopherson wrote:
> Expand the PMU counters test to verify that LLC references and misses have
> non-zero counts when the code being executed while the LLC event(s) is
> active is evicted via CFLUSH{,OPT}.  Note, CLFLUSH{,OPT} requires a fence
> of some kind to ensure the cache lines are flushed before execution
> continues.  Use MFENCE for simplicity (performance is not a concern).
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 59 +++++++++++++------
>   1 file changed, 40 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index b9c073d3ade9..90381382c51f 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -14,9 +14,9 @@
>   /*
>    * Number of "extra" instructions that will be counted, i.e. the number of
>    * instructions that are needed to set up the loop and then disabled the
> - * counter.  2 MOV, 2 XOR, 1 WRMSR.
> + * counter.  1 CLFLUSH/CLFLUSHOPT/NOP, 1 MFENCE, 2 MOV, 2 XOR, 1 WRMSR.
>    */
> -#define NUM_EXTRA_INSNS		5
> +#define NUM_EXTRA_INSNS		7
>   #define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
>   
>   static uint8_t kvm_pmu_version;
> @@ -107,6 +107,12 @@ static void guest_assert_event_count(uint8_t idx,
>   	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
>   		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
>   		break;
> +	case INTEL_ARCH_LLC_REFERENCES_INDEX:
> +	case INTEL_ARCH_LLC_MISSES_INDEX:
> +		if (!this_cpu_has(X86_FEATURE_CLFLUSHOPT) &&
> +		    !this_cpu_has(X86_FEATURE_CLFLUSH))
> +			break;
> +		fallthrough;
>   	case INTEL_ARCH_CPU_CYCLES_INDEX:
>   	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
>   		GUEST_ASSERT_NE(count, 0);
> @@ -123,29 +129,44 @@ static void guest_assert_event_count(uint8_t idx,
>   	GUEST_ASSERT_EQ(_rdpmc(pmc), 0xdead);
>   }
>   
> +/*
> + * Enable and disable the PMC in a monolithic asm blob to ensure that the
> + * compiler can't insert _any_ code into the measured sequence.  Note, ECX
> + * doesn't need to be clobbered as the input value, @pmc_msr, is restored
> + * before the end of the sequence.
> + *
> + * If CLFUSH{,OPT} is supported, flush the cacheline containing (at least) the
> + * start of the loop to force LLC references and misses, i.e. to allow testing
> + * that those events actually count.
> + */
> +#define GUEST_MEASURE_EVENT(_msr, _value, clflush)				\
> +do {										\
> +	__asm__ __volatile__("wrmsr\n\t"					\
> +			     clflush "\n\t"					\
> +			     "mfence\n\t"					\
> +			     "1: mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
> +			     "loop .\n\t"					\
> +			     "mov %%edi, %%ecx\n\t"				\
> +			     "xor %%eax, %%eax\n\t"				\
> +			     "xor %%edx, %%edx\n\t"				\
> +			     "wrmsr\n\t"					\
> +			     :: "a"((uint32_t)_value), "d"(_value >> 32),	\
> +				"c"(_msr), "D"(_msr)				\
> +	);									\
> +} while (0)
> +
>   static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
>   				    uint32_t pmc, uint32_t pmc_msr,
>   				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
>   {
>   	wrmsr(pmc_msr, 0);
>   
> -	/*
> -	 * Enable and disable the PMC in a monolithic asm blob to ensure that
> -	 * the compiler can't insert _any_ code into the measured sequence.
> -	 * Note, ECX doesn't need to be clobbered as the input value, @pmc_msr,
> -	 * is restored before the end of the sequence.
> -	 */
> -	__asm__ __volatile__("wrmsr\n\t"
> -			     "mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"
> -			     "loop .\n\t"
> -			     "mov %%edi, %%ecx\n\t"
> -			     "xor %%eax, %%eax\n\t"
> -			     "xor %%edx, %%edx\n\t"
> -			     "wrmsr\n\t"
> -			     :: "a"((uint32_t)ctrl_msr_value),
> -				"d"(ctrl_msr_value >> 32),
> -				"c"(ctrl_msr), "D"(ctrl_msr)
> -			     );
> +	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))
> +		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "clflushopt 1f");
> +	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
> +		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "clflush 1f");
> +	else
> +		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "nop");
>   
>   	guest_assert_event_count(idx, event, pmc, pmc_msr);
>   }


Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


