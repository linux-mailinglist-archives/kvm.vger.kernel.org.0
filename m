Return-Path: <kvm+bounces-63183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED57EC5B900
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 07:34:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3047A3BF607
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9551B2F5A39;
	Fri, 14 Nov 2025 06:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k/sRb67W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE002F25FA;
	Fri, 14 Nov 2025 06:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101745; cv=none; b=rtsJcRrdGKJRTtUelbTTVjj+nNl03uHjBztEumqQyNJ1fVgwbZB2VliJx1zV2gJgQj2wN4HEyB7eokKfl6tP0WrpbGSP/h4A002HFNxvtucpIxlxtk/Le9fNboa6D9ERUg8yoliHRaqX3XOnxy/7NSZfvhyTlYh4zPPUA4QN4S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101745; c=relaxed/simple;
	bh=c0jhX0WGaCse9Y/i3Ym6g50JD/iePAUdihTKy+wNNG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p/SiYWZZkrCJM8sn1vtdQbbZp06kFsQrLNpah+ov0zMClVqbiOBzcuFN3asz+YXEOgjYX23BylK8X/Sm5LVCofvt41UnBQKXJOyY8u2bKRt0jeeExgklqTITKwyZPQm4bsVe/R0aP+/BAjar+VOp9boi0gMYZ1WyjL6tCt98UIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k/sRb67W; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763101743; x=1794637743;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c0jhX0WGaCse9Y/i3Ym6g50JD/iePAUdihTKy+wNNG8=;
  b=k/sRb67WeI8ab5ZQDwzwGDX8+F9JFq3cU/Ai0k072C5mcTg3CQL6vgzT
   ZMzi+88aSzDJwdWDjnjVZUTBai6DaCiAsVkCgQh6DSWKQLYVioO0md1yH
   HnwpDP24ReWQOypbZmNLbh6D7B8tBD2tdQLQ7AJIUjHkKpQe/Amdk4loN
   nfW/bC7BdDsUdtYyXhT23W6j5fn9IJp8VY3AWgfFL3j546IScV0TtgZJ6
   rLoZ4KdFp0/ShVQhaXoIO0VwKo1/QJI06DrPf8j/EQxNn0lbrVe6R4MHp
   bL5QpK60zkVrls/iH793Mdt4Zzyrsg3L5IcBJOzyZE+olpqj+bZc/628y
   A==;
X-CSE-ConnectionGUID: 4Gy9nfsGQ6a5l9yy6bScqA==
X-CSE-MsgGUID: 1fyaDsOaSEStC5x5GScxiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76652732"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="76652732"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:29:01 -0800
X-CSE-ConnectionGUID: OkgXPN5nS4a1n57WRnXVtw==
X-CSE-MsgGUID: mvhYYMxDTl+8xZ7RPk1mVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="190121909"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.232.65]) ([10.124.232.65])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:28:57 -0800
Message-ID: <9919b426-4ce6-4651-b1f2-367c4f79474d@linux.intel.com>
Date: Fri, 14 Nov 2025 14:28:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/7] KVM: x86/pmu: Add support for hardware
 virtualized PMUs
To: Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Kan Liang <kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Manali Shukla
 <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
 Ananth Narayan <ananth.narayan@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
 <b83d93a3e677fecdbdd2c159e85de4bca2165b79.1762960531.git.sandipan.das@amd.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <b83d93a3e677fecdbdd2c159e85de4bca2165b79.1762960531.git.sandipan.das@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/13/2025 2:18 PM, Sandipan Das wrote:
> Extend the Mediated PMU framework to support hardware virtualized PMUs.
> The key differences with Mediated PMU are listed below.
>   * Hardware saves and restores the guest PMU state on world switches.
>   * The guest PMU state is saved in vendor-specific structures (such as
>     VMCB or VMCS) instead of struct kvm_pmu.
>   * Hardware relies on interrupt virtualization (such as VNMI or AVIC)
>     to notify guests about counter overflows instead of receiving
>     interrupts in host context after switching the delivery mode in
>     LVTPC and then injecting them back in to the guest (KVM_REQ_PMI).
>
> Parts of the original PMU load and put functionality are reused as the
> active host events still need to be scheduled in and out in preparation
> for world switches.
>
> Event filtering and instruction emulation require the ability to change
> the guest PMU state in software. Since struct kvm_pmu no longer has the
> correct state, make use of host-initiated MSR accesses for accessing
> MSR states directly from vendor-specific structures.
>
> RDPMC is intercepted for legacy guests which do not have access to all
> counters. Host-initiated MSR accesses are also used in such cases to
> read the latest counter value from vendor-specific structures.
>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> ---
>  arch/x86/kvm/pmu.c           | 94 +++++++++++++++++++++++++++++-------
>  arch/x86/kvm/pmu.h           |  6 +++
>  arch/x86/kvm/svm/pmu.c       |  1 +
>  arch/x86/kvm/vmx/pmu_intel.c |  1 +
>  arch/x86/kvm/x86.c           |  4 ++
>  arch/x86/kvm/x86.h           |  1 +
>  6 files changed, 89 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 0e5048ae86fa..1453fb3a60a2 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -168,6 +168,43 @@ void kvm_handle_guest_mediated_pmi(void)
>  	kvm_make_request(KVM_REQ_PMI, vcpu);
>  }
>  
> +static __always_inline u32 fixed_counter_msr(u32 idx)
> +{
> +	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
> +}
> +
> +static __always_inline u32 gp_counter_msr(u32 idx)
> +{
> +	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
> +}
> +
> +static __always_inline u32 gp_eventsel_msr(u32 idx)
> +{
> +	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
> +}
> +
> +static void kvm_pmu_get_msr_state(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +{
> +	struct msr_data msr_info;
> +
> +	msr_info.index = index;
> +	msr_info.host_initiated = true;
> +
> +	KVM_BUG_ON(kvm_pmu_call(get_msr)(vcpu, &msr_info), vcpu->kvm);
> +	*data = msr_info.data;
> +}
> +
> +static void kvm_pmu_set_msr_state(struct kvm_vcpu *vcpu, u32 index, u64 data)
> +{
> +	struct msr_data msr_info;
> +
> +	msr_info.data = data;
> +	msr_info.index = index;
> +	msr_info.host_initiated = true;
> +
> +	KVM_BUG_ON(kvm_pmu_call(set_msr)(vcpu, &msr_info), vcpu->kvm);
> +}

With these 2 new helpers, suppose the helpers
write_global_ctrl()/read_global_ctrl() could be retired. 


> +
>  static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -520,19 +557,22 @@ static bool pmc_is_event_allowed(struct kvm_pmc *pmc)
>  
>  static void kvm_mediated_pmu_refresh_event_filter(struct kvm_pmc *pmc)
>  {
> -	bool allowed = pmc_is_event_allowed(pmc);
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +	struct kvm_vcpu *vcpu = pmc->vcpu;
>  
>  	if (pmc_is_gp(pmc)) {
>  		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
> -		if (allowed)
> +		if (pmc_is_event_allowed(pmc))
>  			pmc->eventsel_hw |= pmc->eventsel &
>  					    ARCH_PERFMON_EVENTSEL_ENABLE;
> +
> +		if (kvm_vcpu_has_virtualized_pmu(vcpu))
> +			kvm_pmu_set_msr_state(vcpu, gp_eventsel_msr(pmc->idx), pmc->eventsel_hw);
>  	} else {
>  		u64 mask = intel_fixed_bits_by_idx(pmc->idx - KVM_FIXED_PMC_BASE_IDX, 0xf);
>  
>  		pmu->fixed_ctr_ctrl_hw &= ~mask;
> -		if (allowed)
> +		if (pmc_is_event_allowed(pmc))
>  			pmu->fixed_ctr_ctrl_hw |= pmu->fixed_ctr_ctrl & mask;
>  	}
>  }
> @@ -740,6 +780,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	    kvm_is_cr0_bit_set(vcpu, X86_CR0_PE))
>  		return 1;
>  
> +	if (kvm_vcpu_has_virtualized_pmu(pmc->vcpu))
> +		kvm_pmu_get_msr_state(pmc->vcpu, gp_counter_msr(pmc->idx), &pmc->counter);
> +
>  	*data = pmc_read_counter(pmc) & mask;
>  	return 0;
>  }
> @@ -974,6 +1017,9 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  	    (kvm_pmu_has_perf_global_ctrl(pmu) || kvm_vcpu_has_mediated_pmu(vcpu)))
>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>  
> +	if (kvm_vcpu_has_virtualized_pmu(vcpu))
> +		kvm_pmu_set_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_CTRL, pmu->global_ctrl);
> +
>  	if (kvm_vcpu_has_mediated_pmu(vcpu))
>  		kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
>  
> @@ -1099,6 +1145,11 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  	if (bitmap_empty(event_pmcs, X86_PMC_IDX_MAX))
>  		return;
>  
> +	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
> +		kvm_pmu_get_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_CTRL, &pmu->global_ctrl);
> +		kvm_pmu_get_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_STATUS, &pmu->global_status);
> +	}
> +
>  	if (!kvm_pmu_has_perf_global_ctrl(pmu))
>  		bitmap_copy(bitmap, event_pmcs, X86_PMC_IDX_MAX);
>  	else if (!bitmap_and(bitmap, event_pmcs,
> @@ -1107,11 +1158,21 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> +		if (kvm_vcpu_has_virtualized_pmu(vcpu))
> +			kvm_pmu_get_msr_state(vcpu, gp_counter_msr(pmc->idx), &pmc->counter);
> +
>  		if (!pmc_is_event_allowed(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  
>  		kvm_pmu_incr_counter(pmc);
> +
> +		if (kvm_vcpu_has_virtualized_pmu(vcpu))
> +			kvm_pmu_set_msr_state(vcpu, gp_counter_msr(pmc->idx), pmc->counter);
>  	}
> +
> +	if (kvm_vcpu_has_virtualized_pmu(vcpu))
> +		kvm_pmu_set_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_STATUS, pmu->global_status);
> +
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  }
>  
> @@ -1270,21 +1331,6 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	return r;
>  }
>  
> -static __always_inline u32 fixed_counter_msr(u32 idx)
> -{
> -	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
> -}
> -
> -static __always_inline u32 gp_counter_msr(u32 idx)
> -{
> -	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
> -}
> -
> -static __always_inline u32 gp_eventsel_msr(u32 idx)
> -{
> -	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
> -}
> -
>  static void kvm_pmu_load_guest_pmcs(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -1319,6 +1365,12 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_irqs_disabled();
>  
> +	/* Guest PMU state is restored by hardware at VM-Entry */
> +	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
> +		perf_load_guest_context(0);
> +		return;
> +	}
> +
>  	perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
>  
>  	/*
> @@ -1372,6 +1424,12 @@ void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_irqs_disabled();
>  
> +	/* Guest PMU state is saved by hardware at VM-Exit */
> +	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
> +		perf_put_guest_context();
> +		return;
> +	}
> +
>  	/*
>  	 * Defer handling of PERF_GLOBAL_CTRL to vendor code.  On Intel, it's
>  	 * atomically cleared on VM-Exit, i.e. doesn't need to be clear here.
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index a0cd42cbea9d..55f0679b522d 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -47,6 +47,7 @@ struct kvm_pmu_ops {
>  	const int MIN_NR_GP_COUNTERS;
>  
>  	const u32 PERF_GLOBAL_CTRL;
> +	const u32 PERF_GLOBAL_STATUS;
>  	const u32 GP_EVENTSEL_BASE;
>  	const u32 GP_COUNTER_BASE;
>  	const u32 FIXED_COUNTER_BASE;
> @@ -76,6 +77,11 @@ static inline bool kvm_vcpu_has_mediated_pmu(struct kvm_vcpu *vcpu)
>  	return enable_mediated_pmu && vcpu_to_pmu(vcpu)->version;
>  }
>  
> +static inline bool kvm_vcpu_has_virtualized_pmu(struct kvm_vcpu *vcpu)
> +{
> +	return enable_virtualized_pmu && vcpu_to_pmu(vcpu)->version;
> +}
> +
>  /*
>   * KVM tracks all counters in 64-bit bitmaps, with general purpose counters
>   * mapped to bits 31:0 and fixed counters mapped to 63:32, e.g. fixed counter 0
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index c03720b30785..8a32e1a9c07d 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -278,6 +278,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
>  
>  	.PERF_GLOBAL_CTRL = MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
> +	.PERF_GLOBAL_STATUS = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
>  	.GP_EVENTSEL_BASE = MSR_F15H_PERF_CTL0,
>  	.GP_COUNTER_BASE = MSR_F15H_PERF_CTR0,
>  	.FIXED_COUNTER_BASE = 0,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 41a845de789e..9685af27c15c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -845,6 +845,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.MIN_NR_GP_COUNTERS = 1,
>  
>  	.PERF_GLOBAL_CTRL = MSR_CORE_PERF_GLOBAL_CTRL,
> +	.PERF_GLOBAL_STATUS = MSR_CORE_PERF_GLOBAL_STATUS,
>  	.GP_EVENTSEL_BASE = MSR_P6_EVNTSEL0,
>  	.GP_COUNTER_BASE = MSR_IA32_PMC0,
>  	.FIXED_COUNTER_BASE = MSR_CORE_PERF_FIXED_CTR0,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6bdf7ef0b535..750535a53a30 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -191,6 +191,10 @@ module_param(enable_pmu, bool, 0444);
>  bool __read_mostly enable_mediated_pmu;
>  EXPORT_SYMBOL_GPL(enable_mediated_pmu);
>  
> +/* Enable/disable hardware PMU virtualization. */
> +bool __read_mostly enable_virtualized_pmu;
> +EXPORT_SYMBOL_GPL(enable_virtualized_pmu);
> +
>  bool __read_mostly eager_page_split = true;
>  module_param(eager_page_split, bool, 0644);
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index bd1149768acc..8cca48d1eed7 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -446,6 +446,7 @@ extern struct kvm_host_values kvm_host;
>  
>  extern bool enable_pmu;
>  extern bool enable_mediated_pmu;
> +extern bool enable_virtualized_pmu;
>  
>  /*
>   * Get a filtered version of KVM's supported XCR0 that strips out dynamic

