Return-Path: <kvm+bounces-57271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F030B52629
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 03:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7C5E16BB6D
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93EE8221540;
	Thu, 11 Sep 2025 01:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNjdQ33z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0615E2F37;
	Thu, 11 Sep 2025 01:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757555709; cv=none; b=dJJ9OADlG/dAjAiAEU6K/JNMSVN1aJUqAartf5UeXv6beDNU3/LZ2t6bO8nYSJvfB5HDRqZxT58EaoUiRnsOp5ArRhW7AXnGj//+y9XlkeiamA8lgormpnVh87FNpKEglKyiIxt4ePY+jnul+DqvDjPWKx2tg7+MEz85DAEmemk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757555709; c=relaxed/simple;
	bh=VFp+TFmJefXu6LxHJ7v4Ubd4DEmavG6MCcTryr3zGjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NY+DDrMdY+L0hhW6lri5UCkBeYgG8wjqk1LAfvUGNPhIHYqKIDdiJU9C8K00b+z65uJ+nF/fggCmSMsvL/Wllp+lrmeEeoZ5pixjIWye2vtwL/HANTcCsKq6BvPDg3wSDUjF6npD5heL9il9qVXiOYpgDY8iw+XCSBTUWy52T8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNjdQ33z; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757555708; x=1789091708;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VFp+TFmJefXu6LxHJ7v4Ubd4DEmavG6MCcTryr3zGjM=;
  b=fNjdQ33z5MzImNCO3kAVAuVz7d7yf0oE8sFunxc0QNlBAxNWRgq8yLRs
   SM55RofSBdJ8IH7QRUoiOSxpMpAw2n5cuuw/O01o+16FGXLHNfoAqNMFA
   CKqC3btnD4VW9lomppJlWzX9zym0eievLsz1o8JUFD94kDKUUwxNGunuW
   qzeVFjXTAHJo2IgppuiTt4QF9G6ursua/pGkCnjNbJ9RCMX76VEEM10sd
   JbE49/tO4RKtabsxOLPzlPGNKzarRuMI0TJr8jRd6M+Dv4G+kCu58kxAD
   5NR0VAjCE4cE56o2OiyRzTbU3ir/1z/OZpupIpsdFzeYnyJ86mc/NHu6U
   g==;
X-CSE-ConnectionGUID: Y/oOh1okT96duXazdHkWlA==
X-CSE-MsgGUID: JeKBbTMiQFG5ubMd4OqK+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="77486562"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="77486562"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:55:07 -0700
X-CSE-ConnectionGUID: MhBEvX5bQQWj3EI40PbqmA==
X-CSE-MsgGUID: 3PZN1mznTjaBPBmMVZapyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="173997464"
Received: from unknown (HELO [10.238.3.254]) ([10.238.3.254])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:55:05 -0700
Message-ID: <b476b348-e803-46c2-a068-26a694019d4d@linux.intel.com>
Date: Thu, 11 Sep 2025 09:55:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: selftests: Relax precise event count
 validation as overcount issue
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 dongsheng <dongsheng.x.zhang@intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
 <20250718001905.196989-5-dapeng1.mi@linux.intel.com>
 <aMIQRGRg59dvcHaP@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aMIQRGRg59dvcHaP@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 9/11/2025 7:56 AM, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Dapeng Mi wrote:
>> From: dongsheng <dongsheng.x.zhang@intel.com>
>>
>> For Intel Atom CPUs, the PMU events "Instruction Retired" or
>> "Branch Instruction Retired" may be overcounted for some certain
>> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
>> and complex SGX/SMX/CSTATE instructions/flows.
>>
>> The detailed information can be found in the errata (section SRF7):
>> https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
>>
>> For the Atom platforms before Sierra Forest (including Sierra Forest),
>> Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
>> be overcounted on these certain instructions, but for Clearwater Forest
>> only "Instruction Retired" event is overcounted on these instructions.
>>
>> As the overcount issue on VM-Exit/VM-Entry, it has no way to validate
>> the precise count for these 2 events on these affected Atom platforms,
>> so just relax the precise event count check for these 2 events on these
>> Atom platforms.
>>
>> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
>> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yi Lai <yi1.lai@intel.com>
>> ---
> ...
>
>> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
>> index 342a72420177..074cdf323406 100644
>> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
>> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
>> @@ -52,6 +52,9 @@ struct kvm_intel_pmu_event {
>>  	struct kvm_x86_pmu_feature fixed_event;
>>  };
>>  
>> +
>> +static uint8_t inst_overcount_flags;
>> +
>>  /*
>>   * Wrap the array to appease the compiler, as the macros used to construct each
>>   * kvm_x86_pmu_feature use syntax that's only valid in function scope, and the
>> @@ -163,10 +166,18 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
>>  
>>  	switch (idx) {
>>  	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
>> -		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
>> +		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
>> +		if (inst_overcount_flags & INST_RETIRED_OVERCOUNT)
>> +			GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
>> +		else
>> +			GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
>>  		break;
>>  	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
>> -		GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
>> +		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
>> +		if (inst_overcount_flags & BR_RETIRED_OVERCOUNT)
>> +			GUEST_ASSERT(count >= NUM_BRANCH_INSNS_RETIRED);
>> +		else
>> +			GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
>>  		break;
>>  	case INTEL_ARCH_LLC_REFERENCES_INDEX:
>>  	case INTEL_ARCH_LLC_MISSES_INDEX:
>> @@ -335,6 +346,7 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
>>  				length);
>>  	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
>>  				unavailable_mask);
>> +	sync_global_to_guest(vm, inst_overcount_flags);
> Rather than force individual tests to sync_global_to_guest(), and to cache the
> value, I think it makes sense to handle this automatically in kvm_arch_vm_post_create(),
> similar to things like host_cpu_is_intel and host_cpu_is_amd.

Yeah,  that is the better place.


>
> And explicitly call these out as errata, so that it's super clear that we're
> working around PMU/CPU flaws, not KVM bugs.  With some shenanigans, we can even
> reuse the this_pmu_has()/this_cpu_has(0 terminology as this_pmu_has_errata(), and
> hide the use of a bitmask too.

Agree.


>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index d4f90f5ec5b8..046d992c5940 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -163,10 +163,18 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
>  
>         switch (idx) {
>         case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
> -               GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
> +               /* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
> +               if (this_pmu_has_errata(INSTRUCTIONS_RETIRED_OVERCOUNT))
> +                       GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
> +               else
> +                       GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
>                 break;
>         case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
> -               GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
> +               /* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
> +               if (this_pmu_has_errata(BRANCHES_RETIRED_OVERCOUNT))
> +                       GUEST_ASSERT(count >= NUM_BRANCH_INSNS_RETIRED);
> +               else
> +                       GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
>                 break;
>         case INTEL_ARCH_LLC_REFERENCES_INDEX:
>         case INTEL_ARCH_LLC_MISSES_INDEX:
> diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> index c15513cd74d1..1c5b7611db24 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> @@ -214,8 +214,10 @@ static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
>  do {                                                                                   \
>         uint64_t br = pmc_results.branches_retired;                                     \
>         uint64_t ir = pmc_results.instructions_retired;                                 \
> +       bool br_matched = this_pmu_has_errata(BRANCHES_RETIRED_OVERCOUNT) ?             \
> +                         br >= NUM_BRANCHES : br == NUM_BRANCHES;                      \
>                                                                                         \
> -       if (br && br != NUM_BRANCHES)                                                   \
> +       if (br && !br_matched)                                                          \
>                 pr_info("%s: Branch instructions retired = %lu (expected %u)\n",        \
>                         __func__, br, NUM_BRANCHES);                                    \
>         TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",         \

Looks good to me.



