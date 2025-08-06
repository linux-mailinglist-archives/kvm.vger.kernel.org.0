Return-Path: <kvm+bounces-54087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A6DB1C150
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0127018C00C4
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8CD21ABB0;
	Wed,  6 Aug 2025 07:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3y9lrwB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35C72639;
	Wed,  6 Aug 2025 07:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465304; cv=none; b=Yi9UCcWj6nP18wKdIL1/h36UIjW88fQPD2HXIP1D1XpUGJgZ9h4KuoFLTDF4KJLlrR2ccehIaAhGV/4jUfefPrcZxoYQeIRPMFiJbiViNvDVvZmhNVVFTp5lWKbp9bHH8jx9cCSU7TDJb2BrtCtZReTtxGQa31M+kwGLFWgO9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465304; c=relaxed/simple;
	bh=650raWchrSWRUx800gcvjjUK1G/JfwlwMC9g8/yL2h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikwZEDY+Akklk+43XDxJ4SEUDAECzx169mzaTVPPQ/wU3Qg95jetnz3OIUjf2Sf3QBeOO9aTYqKiKSmb1MeEj20EEtg+IV9P4NQhsODmkLZBQlTs2o6uKWp4WkAmUZrfU2SEfH2x7pzKmaTXJ6gjo1qSgpB0KcZvwEUy4elGRtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N3y9lrwB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465303; x=1786001303;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=650raWchrSWRUx800gcvjjUK1G/JfwlwMC9g8/yL2h8=;
  b=N3y9lrwBuf1NLnPHfhngOhauK+4JmSdWtZJxUUJ5Z/KXN0803+RFOY0s
   yR8zDLbAfBNCYZrVlVFFmGEMiOZhhSPQj04adWUymtSj+dbPqeoYADHrX
   fCKKd3w88RMKvIqJArIFsnYN0SIkSepJNFipGI16OCPVo+EqcNko079lH
   Ch6hSECmOWklDaxv3VTqSYDDhs74VUlJOk0wiBdcKC5Sv5FziG8A+ZAxQ
   cUo7iPsND3o/Yy37FOzyV5b1ysuBdEq95uFyHcZwXfDqfjp1attmMPjZj
   ZnxC1UJLj33GgRENZt4pDWyXssza6Fubr6c5xg6esIW64rAClNCpZg7Ay
   w==;
X-CSE-ConnectionGUID: uuNVtSKySTmxA6uSJbocBQ==
X-CSE-MsgGUID: iqcR+D/mSHCHJnp8qNPzDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="55809701"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="55809701"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:28:22 -0700
X-CSE-ConnectionGUID: /ScpE/9CSTGHfUqEy8prYQ==
X-CSE-MsgGUID: FaG8iS7bRWOqqIOU/zSJJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="164720449"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:28:21 -0700
Message-ID: <d5da58b3-6010-46c5-bca0-818b2cee16d7@linux.intel.com>
Date: Wed, 6 Aug 2025 15:28:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/18] KVM: x86/pmu: Calculate set of to-be-emulated PMCs
 at time of WRMSRs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-12-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Calculate and track PMCs that are counting instructions/branches retired
> when the PMC's event selector (or fixed counter control) is modified
> instead evaluating the event selector on-demand.  Immediately recalc a
> PMC's configuration on writes to avoid false negatives/positives when
> KVM skips an emulated WRMSR, which is guaranteed to occur before the
> main run loop processes KVM_REQ_PMU.
>
> Out of an abundance of caution, and because it's relatively cheap, recalc
> reprogrammed PMCs in kvm_pmu_handle_event() as well.  Recalculating in
> response to KVM_REQ_PMU _should_ be unnecessary, but for now be paranoid
> to avoid introducing easily-avoidable bugs in edge cases.  The code can be
> removed in the future if necessary, e.g. in the unlikely event that the
> overhead of recalculating to-be-emulated PMCs is noticeable.
>
> Note!  Deliberately don't check the PMU event filters, as doing so could
> result in KVM consuming stale information.
>
> Tracking which PMCs are counting branches/instructions will allow grabbing
> SRCU in the fastpath VM-Exit handlers if and only if a PMC event might be
> triggered (to consult the event filters), and will also allow the upcoming
> mediated PMU to do the right thing with respect to counting instructions
> (the mediated PMU won't be able to update PMCs in the VM-Exit fastpath).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++
>  arch/x86/kvm/pmu.c              | 75 ++++++++++++++++++++++++---------
>  arch/x86/kvm/pmu.h              |  4 ++
>  3 files changed, 61 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..d7680612ba1e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -579,6 +579,9 @@ struct kvm_pmu {
>  	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
>  	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
>  
> +	DECLARE_BITMAP(pmc_counting_instructions, X86_PMC_IDX_MAX);
> +	DECLARE_BITMAP(pmc_counting_branches, X86_PMC_IDX_MAX);
> +
>  	u64 ds_area;
>  	u64 pebs_enable;
>  	u64 pebs_enable_rsvd;
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e1911b366c43..b0f0275a2c2e 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -542,6 +542,47 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>  				     eventsel & ARCH_PERFMON_EVENTSEL_INT);
>  }
>  
> +static bool pmc_is_event_match(struct kvm_pmc *pmc, u64 eventsel)
> +{
> +	/*
> +	 * Ignore checks for edge detect (all events currently emulated by KVM
> +	 * are always rising edges), pin control (unsupported by modern CPUs),
> +	 * and counter mask and its invert flag (KVM doesn't emulate multiple
> +	 * events in a single clock cycle).
> +	 *
> +	 * Note, the uppermost nibble of AMD's mask overlaps Intel's IN_TX (bit
> +	 * 32) and IN_TXCP (bit 33), as well as two reserved bits (bits 35:34).
> +	 * Checking the "in HLE/RTM transaction" flags is correct as the vCPU
> +	 * can't be in a transaction if KVM is emulating an instruction.
> +	 *
> +	 * Checking the reserved bits might be wrong if they are defined in the
> +	 * future, but so could ignoring them, so do the simple thing for now.
> +	 */
> +	return !((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB);
> +}
> +
> +void kvm_pmu_recalc_pmc_emulation(struct kvm_pmu *pmu, struct kvm_pmc *pmc)
> +{
> +	bitmap_clear(pmu->pmc_counting_instructions, pmc->idx, 1);
> +	bitmap_clear(pmu->pmc_counting_branches, pmc->idx, 1);
> +
> +	/*
> +	 * Do NOT consult the PMU event filters, as the filters must be checked
> +	 * at the time of emulation to ensure KVM uses fresh information, e.g.
> +	 * omitting a PMC from a bitmap could result in a missed event if the
> +	 * filter is changed to allow counting the event.
> +	 */
> +	if (!pmc_speculative_in_use(pmc))
> +		return;
> +
> +	if (pmc_is_event_match(pmc, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED))
> +		bitmap_set(pmu->pmc_counting_instructions, pmc->idx, 1);
> +
> +	if (pmc_is_event_match(pmc, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED))
> +		bitmap_set(pmu->pmc_counting_branches, pmc->idx, 1);
> +}
> +EXPORT_SYMBOL_GPL(kvm_pmu_recalc_pmc_emulation);
> +
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  {
>  	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
> @@ -577,6 +618,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  	 */
>  	if (unlikely(pmu->need_cleanup))
>  		kvm_pmu_cleanup(vcpu);
> +
> +	kvm_for_each_pmc(pmu, pmc, bit, bitmap)
> +		kvm_pmu_recalc_pmc_emulation(pmu, pmc);
>  }
>  
>  int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
> @@ -910,7 +954,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>  							 select_user;
>  }
>  
> -static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
> +static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
> +				  const unsigned long *event_pmcs)
>  {
>  	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -919,29 +964,17 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>  
>  	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE != X86_PMC_IDX_MAX);
>  
> +	if (bitmap_empty(event_pmcs, X86_PMC_IDX_MAX))
> +		return;
> +
>  	if (!kvm_pmu_has_perf_global_ctrl(pmu))
> -		bitmap_copy(bitmap, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
> -	else if (!bitmap_and(bitmap, pmu->all_valid_pmc_idx,
> +		bitmap_copy(bitmap, event_pmcs, X86_PMC_IDX_MAX);
> +	else if (!bitmap_and(bitmap, event_pmcs,
>  			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
>  		return;
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> -		/*
> -		 * Ignore checks for edge detect (all events currently emulated
> -		 * but KVM are always rising edges), pin control (unsupported
> -		 * by modern CPUs), and counter mask and its invert flag (KVM
> -		 * doesn't emulate multiple events in a single clock cycle).
> -		 *
> -		 * Note, the uppermost nibble of AMD's mask overlaps Intel's
> -		 * IN_TX (bit 32) and IN_TXCP (bit 33), as well as two reserved
> -		 * bits (bits 35:34).  Checking the "in HLE/RTM transaction"
> -		 * flags is correct as the vCPU can't be in a transaction if
> -		 * KVM is emulating an instruction.  Checking the reserved bits
> -		 * might be wrong if they are defined in the future, but so
> -		 * could ignoring them, so do the simple thing for now.
> -		 */
> -		if (((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB) ||
> -		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
> +		if (!pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  
>  		kvm_pmu_incr_counter(pmc);
> @@ -950,13 +983,13 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>  
>  void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu)
>  {
> -	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
> +	kvm_pmu_trigger_event(vcpu, vcpu_to_pmu(vcpu)->pmc_counting_instructions);
>  }
>  EXPORT_SYMBOL_GPL(kvm_pmu_instruction_retired);
>  
>  void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu)
>  {
> -	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
> +	kvm_pmu_trigger_event(vcpu, vcpu_to_pmu(vcpu)->pmc_counting_branches);
>  }
>  EXPORT_SYMBOL_GPL(kvm_pmu_branch_retired);
>  
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 740af816af37..cb93a936a177 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -176,8 +176,12 @@ extern struct x86_pmu_capability kvm_pmu_cap;
>  
>  void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
>  
> +void kvm_pmu_recalc_pmc_emulation(struct kvm_pmu *pmu, struct kvm_pmc *pmc);
> +
>  static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>  {
> +	kvm_pmu_recalc_pmc_emulation(pmc_to_pmu(pmc), pmc);
> +
>  	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>  	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  }

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



