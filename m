Return-Path: <kvm+bounces-35930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CCCBA16547
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 03:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70DFA161F0D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 02:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A68374F1;
	Mon, 20 Jan 2025 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DiFAWBQo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46414A1E
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 02:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737338586; cv=none; b=p1BToB7YwGyv8Y64e3gvqc6gwuCfrsk7ngL1F5GvxX4Ibb17tZHS6/9YuDzUZFSZKyTRXze42e5FuMvKfcuILR7/yZgrnu+9mXQ5QKSqE6Mwc0YsD/N4b1n5N+MVDwuarId5qpSNOcSSuqBJfidNo9Ka7tX0t9eC4lNGLm94vU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737338586; c=relaxed/simple;
	bh=0z4cbhMnkxncNNXCbF03BoE6UR+EjC6H9L0HibqMEuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VuNbLMG4YNFiQcLuXb0ScDKAn5hwD/WZMqbOSLL910JXAFwVamMkd5uU3RvsJyIbIS9cPhg9kmhRGrZukT0iom2KtOFDuEdCaQoxXmV3/yacWH5K+gHoGl7oHlzzx5eTPBuOcgUK3RJNvFet3SPrC/aieO+LGtnWeZWb3BNRzzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DiFAWBQo; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737338584; x=1768874584;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0z4cbhMnkxncNNXCbF03BoE6UR+EjC6H9L0HibqMEuw=;
  b=DiFAWBQoH81BmfR/VBmQE+Z8Zgi/MZJLVLzolPHMWI+WanqRBCtzIcTT
   qVhq5rn7PLS5lRYXU+VzLIuNV8gm0qPK9sjEwOmSsaTYmtOGo6lFxuWJM
   eEH7sXjF0KU+yWDfMXbG3NuOhXMWnExSFG5bk69rJI3XEH/nZ9MlikXIv
   0zZeJrSQSyyuQTZEss8ZEY1eodDkGsOKX1G0JoWzOs/vNKeuI0IOGqhVq
   iJiF/t3ImyHntWz3XLw9rDXHsf28/TF1hG2N7IHpCRDTMQRp38VeTXn9A
   oGkbTnh7KzcpZEqg1RhUWQjRkCHBh1PmASTYnFpInp89IgReLJ9u/puEg
   g==;
X-CSE-ConnectionGUID: R0/QOJ8LT4yfr8zF/KkNMg==
X-CSE-MsgGUID: 3RZ6s/9YRaWOG4Mr4L2nyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="49105603"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="49105603"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 18:03:03 -0800
X-CSE-ConnectionGUID: tWMMw5tnS0ivjm3eVTfqHQ==
X-CSE-MsgGUID: weCGu2cUQBqEX0X9dmEz4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="111319713"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 18:03:00 -0800
Message-ID: <c1ce77cd-8921-402d-87b2-fd3fa11add4d@linux.intel.com>
Date: Mon, 20 Jan 2025 10:02:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [KVM] 7803339fa9:
 kernel-selftests.kvm.pmu_counters_test.fail
To: Sean Christopherson <seanjc@google.com>
Cc: kernel test robot <oliver.sang@intel.com>, g@google.com,
 oe-lkp@lists.linux.dev, lkp@intel.com, Maxim Levitsky <mlevitsk@redhat.com>,
 kvm@vger.kernel.org, xudong.hao@intel.com
References: <202501141009.30c629b4-lkp@intel.com>
 <Z4a_PmUVVmUtOd4p@google.com>
 <a2adf1b8-c394-4741-a42b-32288657b07e@linux.intel.com>
 <6c23d536-484f-4c4b-aa85-3e0b9544611a@linux.intel.com>
 <Z4qPWNscnU9-b30n@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z4qPWNscnU9-b30n@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 1/18/2025 1:11 AM, Sean Christopherson wrote:
> On Fri, Jan 17, 2025, Dapeng Mi wrote:
>> On 1/15/2025 10:44 AM, Mi, Dapeng wrote:
>>> On 1/15/2025 3:47 AM, Sean Christopherson wrote:
>>>>> # Testing fixed counters, PMU version 0, perf_caps = 2000
>>>>> # Testing arch events, PMU version 1, perf_caps = 0
>>>>> # ==== Test Assertion Failure ====
>>>>> #   x86/pmu_counters_test.c:129: count >= (10 * 4 + 5)
>>>>> #   pid=6278 tid=6278 errno=4 - Interrupted system call
>>>>> #      1	0x0000000000411281: assert_on_unhandled_exception at processor.c:625
>>>>> #      2	0x00000000004075d4: _vcpu_run at kvm_util.c:1652
>>>>> #      3	 (inlined by) vcpu_run at kvm_util.c:1663
>>>>> #      4	0x0000000000402c5e: run_vcpu at pmu_counters_test.c:62
>>>>> #      5	0x0000000000402e4d: test_arch_events at pmu_counters_test.c:315
>>>>> #      6	0x0000000000402663: test_arch_events at pmu_counters_test.c:304
>>>>> #      7	 (inlined by) test_intel_counters at pmu_counters_test.c:609
>>>>> #      8	 (inlined by) main at pmu_counters_test.c:642
>>>>> #      9	0x00007f3b134f9249: ?? ??:0
>>>>> #     10	0x00007f3b134f9304: ?? ??:0
>>>>> #     11	0x0000000000402900: _start at ??:?
>>>>> #   count >= NUM_INSNS_RETIRED
>>>> The failure is on top-down slots.  I modified the assert to actually print the
>>>> count (I'll make sure to post a patch regardless of where this goes), and based
>>>> on the count for failing vs. passing, I'm pretty sure the issue is not the extra
>>>> instruction, but instead is due to changing the target of the CLFUSH from the
>>>> address of the code to the address of kvm_pmu_version.
>>>>
>>>> However, I think the blame lies with the assertion itself, i.e. with commit
>>>> 4a447b135e45 ("KVM: selftests: Test top-down slots event in x86's pmu_counters_test").
>>>> Either that or top-down slots is broken on the Lakes.
>>>>
>>>> By my rudimentary measurements, tying the number of available slots to the number
>>>> of instructions *retired* is fundamentally flawed.  E.g. on the Lakes (SKX is more
>>>> or less identical to CLX), omitting the CLFLUSHOPT entirely results in *more*
>>>> slots being available throughout the lifetime of the measured section.
>>>>
>>>> My best guess is that flushing the cache line use for the data load causes the
>>>> backend to saturate its slots with prefetching data, and as a result the number
>>>> of slots that are available goes down.
>>>>
>>>>         CLFLUSHOPT .    | CLFLUSHOPT [%m]       | NOP
>>>> CLX     350-100         | 20-60[*]              | 135-150  
>>>> SPR     49000-57000     | 32500-41000           | 6760-6830
>>>>
>>>> [*] CLX had a few outliers in the 200-400 range, but the majority of runs were
>>>>     in the 20-60 range.
>>>>
>>>> Reading through more (and more and more) of the TMA documentation, I don't think
>>>> we can assume anything about the number of available slots, beyond a very basic
>>>> assertion that it's practically impossible for there to never be an available
>>>> slot.  IIUC, retiring an instruction does NOT require an available slot, rather
>>>> it requires the opposite: an occupied slot for the uop(s).
>>> I'm not quite sure about this. IIUC, retiring an instruction may not need a
>>> cycle, but it needs a slot at least except the instruction is macro-fused.
>>> Anyway, let me double check with our micro-architecture and perf experts.
>> Hi Sean,
>>
>> Just double check with our perf experts, the understanding that "retiring
>> an instruction needs a slot at least except the instruction is macro-fused"
>> is correct. The reason of this error is that the architectural topdown
>> slots event is just introduced from Ice lake platform and it's not
>> supported on skylake and cascade lake platforms. On these earlier platforms
>> the event 0x01a4 is another event which counts different thing instead of
>> topdown slots. On these earlier platforms, the slots event is derived from
>> 0x3c event.
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/events/intel/core.c#n466
>>
>>
>> I don't understand why current pmu_counters_test code would validate an
>> architectural event which KVM (HW) doesn't support, it's not reasonable and
>> could cause misleading.
>>
>>         /*
>>          * Force iterating over known arch events regardless of whether or not
>>          * KVM/hardware supports a given event.
>>          */
>>         nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events,
>> NR_INTEL_ARCH_EVENTS);
> /facepalm
>
> That's hilariously obvious in hindsight.
>
>> I would provide a patch to fix this.
> Testing "unsupproted" arch events is intentional.  The idea is to validate that
> KVM programs the requested event selector irrespective of whether or not the
> architectural event is *enumerated* to the guest (old KVM incorrectly "filtered"
> such events).
>
> The flaw in the test is that it doesn't check if the architectural event is
> supported in *hardware* when validating the count.  But it's still desirable to
> program the event selector in that case, i.e. only the validation of the count
> should be skipped.  Diff at the bottom to address this (needs to be spread
> over multiple patches).

I see. Thanks for explaining the history.


>
>> BTW, currently KVM doesn't check if user space sets a valid pmu version in
>> kvm_check_cpuid(). The user space could set KVM a PMU version which is
>> larger than KVM supported maximum PMU version, just like currently
>> pmu_counters_test does. This is not correct.
> It's "correct" in the sense that KVM typically doesn't restrict what userspace
> enumerates to the guest through CPUID.  KVM needs to protect the host against
> doing bad things based on a funky guest CPUID, e.g. KVM needs t
>
>> I originally intent to fix this with the mediated vPMU patch series, but It
>> looks we can send the patches just with this fix together, then the issue can
>> be fixed earlier.
> I suspect that if there's a flaw in KVM, it only affects the mediated PMU.  Because
> perf manages MSRs/hardware with the current PMU, advertising a bogus PMU version
> to the guest is "fine" because even if KVM thinks it's legal for the *guest* to
> write MSRs that don't exist in hardware, KVM/perf will never try to propagate the
> guest values to non-existent hardware.

Hmm, yeah, I think you're right. In theory, it should only impact mediated
vPMU since perf-based vPMU doesn't manipulate HW directly. Thanks.


>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index accd7ecd3e5f..124051ea50be 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -29,10 +29,60 @@
>  /* Total number of instructions retired within the measured section. */
>  #define NUM_INSNS_RETIRED		(NUM_LOOPS * NUM_INSNS_PER_LOOP + NUM_EXTRA_INSNS)
>  
> +/* Track which architectural events are supported by hardware. */
> +static uint32_t hardware_pmu_arch_events;
>  
>  static uint8_t kvm_pmu_version;
>  static bool kvm_has_perf_caps;
>  
> +
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
> +struct kvm_intel_pmu_event {
> +	struct kvm_x86_pmu_feature gp_event;
> +	struct kvm_x86_pmu_feature fixed_event;
> +};
> +
> +/*
> + * Wrap the array to appease the compiler, as the macros used to construct each
> + * kvm_x86_pmu_feature use syntax that's only valid in function scope, and the
> + * compiler often thinks the feature definitions aren't compile-time constants.
> + */
> +static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
> +{
> +	const struct kvm_intel_pmu_event __intel_event_to_feature[] = {
> +		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
> +		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
> +		/*
> +		* Note, the fixed counter for reference cycles is NOT the same as the
> +		* general purpose architectural event.  The fixed counter explicitly
> +		* counts at the same frequency as the TSC, whereas the GP event counts
> +		* at a fixed, but uarch specific, frequency.  Bundle them here for
> +		* simplicity.
> +		*/
> +		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
> +		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
> +		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
> +	};
> +
> +	kvm_static_assert(ARRAY_SIZE(__intel_event_to_feature) == NR_INTEL_ARCH_EVENTS);
> +
> +	return __intel_event_to_feature[idx];
> +}
> +
>  static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>  						  void *guest_code,
>  						  uint8_t pmu_version,
> @@ -42,6 +92,7 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>  
>  	vm = vm_create_with_one_vcpu(vcpu, guest_code);
>  	sync_global_to_guest(vm, kvm_pmu_version);
> +	sync_global_to_guest(vm, hardware_pmu_arch_events);
>  
>  	/*
>  	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
> @@ -98,14 +149,12 @@ static uint8_t guest_get_pmu_version(void)
>   * Sanity check that in all cases, the event doesn't count when it's disabled,
>   * and that KVM correctly emulates the write of an arbitrary value.
>   */
> -static void guest_assert_event_count(uint8_t idx,
> -				     struct kvm_x86_pmu_feature event,
> -				     uint32_t pmc, uint32_t pmc_msr)
> +static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr)
>  {
>  	uint64_t count;
>  
>  	count = _rdpmc(pmc);
> -	if (!this_pmu_has(event))
> +	if (!(hardware_pmu_arch_events & BIT(idx)))
>  		goto sanity_checks;
>  
>  	switch (idx) {
> @@ -126,7 +175,9 @@ static void guest_assert_event_count(uint8_t idx,
>  		GUEST_ASSERT_NE(count, 0);
>  		break;
>  	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
> -		GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
> +		__GUEST_ASSERT(count < NUM_INSNS_RETIRED,

shouldn't be "__GUEST_ASSERT(count >= NUM_INSNS_RETIRED," ?


> +			       "Expected top-down slots >= %u, got count = %lu",
> +			       NUM_INSNS_RETIRED, count);
>  		break;
>  	default:
>  		break;
> @@ -173,7 +224,7 @@ do {										\
>  	);									\
>  } while (0)
>  
> -#define GUEST_TEST_EVENT(_idx, _event, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)	\
> +#define GUEST_TEST_EVENT(_idx, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)		\
>  do {										\
>  	wrmsr(_pmc_msr, 0);							\
>  										\
> @@ -184,54 +235,20 @@ do {										\
>  	else									\
>  		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
>  										\
> -	guest_assert_event_count(_idx, _event, _pmc, _pmc_msr);			\
> +	guest_assert_event_count(_idx, _pmc, _pmc_msr);				\
>  } while (0)
>  
> -static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
> -				    uint32_t pmc, uint32_t pmc_msr,
> +static void __guest_test_arch_event(uint8_t idx, uint32_t pmc, uint32_t pmc_msr,
>  				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
>  {
> -	GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
> +	GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
>  
>  	if (is_forced_emulation_enabled)
> -		GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
> -}
> -
> -#define X86_PMU_FEATURE_NULL						\
> -({									\
> -	struct kvm_x86_pmu_feature feature = {};			\
> -									\
> -	feature;							\
> -})
> -
> -static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
> -{
> -	return !(*(u64 *)&event);
> +		GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
>  }
>  
>  static void guest_test_arch_event(uint8_t idx)
>  {
> -	const struct {
> -		struct kvm_x86_pmu_feature gp_event;
> -		struct kvm_x86_pmu_feature fixed_event;
> -	} intel_event_to_feature[] = {
> -		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
> -		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
> -		/*
> -		 * Note, the fixed counter for reference cycles is NOT the same
> -		 * as the general purpose architectural event.  The fixed counter
> -		 * explicitly counts at the same frequency as the TSC, whereas
> -		 * the GP event counts at a fixed, but uarch specific, frequency.
> -		 * Bundle them here for simplicity.
> -		 */
> -		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
> -		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
> -		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
> -		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
> -		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
> -		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
> -	};
> -
>  	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>  	uint32_t pmu_version = guest_get_pmu_version();
>  	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
> @@ -249,7 +266,7 @@ static void guest_test_arch_event(uint8_t idx)
>  	else
>  		base_pmc_msr = MSR_IA32_PERFCTR0;
>  
> -	gp_event = intel_event_to_feature[idx].gp_event;
> +	gp_event = intel_event_to_feature(idx).gp_event;
>  	GUEST_ASSERT_EQ(idx, gp_event.f.bit);
>  
>  	GUEST_ASSERT(nr_gp_counters);
> @@ -263,14 +280,14 @@ static void guest_test_arch_event(uint8_t idx)
>  		if (guest_has_perf_global_ctrl)
>  			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
>  
> -		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
> +		__guest_test_arch_event(idx, i, base_pmc_msr + i,
>  					MSR_P6_EVNTSEL0 + i, eventsel);
>  	}
>  
>  	if (!guest_has_perf_global_ctrl)
>  		return;
>  
> -	fixed_event = intel_event_to_feature[idx].fixed_event;
> +	fixed_event = intel_event_to_feature(idx).fixed_event;
>  	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
>  		return;
>  
> @@ -278,7 +295,7 @@ static void guest_test_arch_event(uint8_t idx)
>  
>  	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
>  
> -	__guest_test_arch_event(idx, fixed_event, i | INTEL_RDPMC_FIXED,
> +	__guest_test_arch_event(idx, i | INTEL_RDPMC_FIXED,
>  				MSR_CORE_PERF_FIXED_CTR0 + i,
>  				MSR_CORE_PERF_GLOBAL_CTRL,
>  				FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
> @@ -546,7 +563,6 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
>  
>  static void test_intel_counters(void)
>  {
> -	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
>  	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
>  	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>  	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
> @@ -568,18 +584,26 @@ static void test_intel_counters(void)
>  
>  	/*
>  	 * Detect the existence of events that aren't supported by selftests.
> -	 * This will (obviously) fail any time the kernel adds support for a
> -	 * new event, but it's worth paying that price to keep the test fresh.
> +	 * This will (obviously) fail any time hardware adds support for a new
> +	 * event, but it's worth paying that price to keep the test fresh.
>  	 */
> -	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
> +	TEST_ASSERT(this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH) <= NR_INTEL_ARCH_EVENTS,
>  		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
> -		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> +		    this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH),
> +		    this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
>  
>  	/*
> -	 * Force iterating over known arch events regardless of whether or not
> -	 * KVM/hardware supports a given event.
> +	 * Iterate over known arch events irrespective of KVM/hardware support
> +	 * to verify that KVM doesn't reject programming of events just because
> +	 * the *architectural* encoding is unsupported.  Track which events are
> +	 * supported in hardware; the guest side will validate supported events
> +	 * count correctly, even if *enumeration* of the event is unsupported
> +	 * by KVM and/or isn't exposed to the guest.
>  	 */
> -	nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL_ARCH_EVENTS);
> +	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
> +		if (this_pmu_has(intel_event_to_feature(i).gp_event))
> +			hardware_pmu_arch_events |= BIT(i);
> +	}
>  
>  	for (v = 0; v <= max_pmu_version; v++) {
>  		for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
> @@ -595,8 +619,8 @@ static void test_intel_counters(void)
>  			 * vector length.
>  			 */
>  			if (v == pmu_version) {
> -				for (k = 1; k < (BIT(nr_arch_events) - 1); k++)
> -					test_arch_events(v, perf_caps[i], nr_arch_events, k);
> +				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
> +					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
>  			}
>  			/*
>  			 * Test single bits for all PMU version and lengths up
> @@ -605,11 +629,11 @@ static void test_intel_counters(void)
>  			 * host length).  Explicitly test a mask of '0' and all
>  			 * ones i.e. all events being available and unavailable.
>  			 */
> -			for (j = 0; j <= nr_arch_events + 1; j++) {
> +			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
>  				test_arch_events(v, perf_caps[i], j, 0);
>  				test_arch_events(v, perf_caps[i], j, 0xff);
>  
> -				for (k = 0; k < nr_arch_events; k++)
> +				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
>  					test_arch_events(v, perf_caps[i], j, BIT(k));
>  			}
>

