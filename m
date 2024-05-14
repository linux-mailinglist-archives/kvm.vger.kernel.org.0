Return-Path: <kvm+bounces-17370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BAF98C4D7D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 10:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EA171C2128A
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 08:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F732182B5;
	Tue, 14 May 2024 08:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kh0x0zVB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B549810949;
	Tue, 14 May 2024 08:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715674103; cv=none; b=TaGiKp4hgqwuAGilMLtUyCfPQdUhNeYLb28ddvVEwvIS41tdJaUc1pSBfIachELS9Er+Zpy/NyQjS19BbRlKjq1wZQhUP2tQCzlZNcqMYRp2pcLMPTjmQjqj8I2kZmdsnEzoxdOIa+hmgylq8nzje/mARwdoV+u2yajHBV5sThs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715674103; c=relaxed/simple;
	bh=5WfZjxrYSw7zoXzdLkztv43J1D68SxBg97H0MZSYreQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FowxKYhypj08BCqPGXgymMuLhKFs9SqPkAmi7+VPxrRgk4QzMQROIG3vwsp5ZEHIYjYSli3uu8umaN0qeX2lJfA5pO2oE9w54JnqRyuOyTtOjq9iZuOUJkw+o3OH+fhyYyN8D87wTnkBkJxni4tuhnHK7BRtmO3kPq5tY/jIAkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kh0x0zVB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715674102; x=1747210102;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5WfZjxrYSw7zoXzdLkztv43J1D68SxBg97H0MZSYreQ=;
  b=Kh0x0zVBLb6mRPTQq8FfZebqvKTQpVnvG5CDncNbLhqQ00E06S1iiZ1i
   oJ4U/DG/7m/N520m+BcnZgWymyiuTTA1Bxu0cxoE7t8IFnGfeu+SqPf+u
   eHB9khSqcUWBv0hpdhtmRUhxhuiufpzevI2r1nnZHLjn6XwYOb3Vd2PRh
   R5wkoYcQmneAyT9PoIU2IpJ0lDewGAukkK/cChuu0ojEbw13iKBt+vvxh
   0KUs8x1wF7e1PV7oDC6wsF3Y5Ii7I5dbhr2FQDh5nW4/CbDN80LdOXw67
   l/WUZWp/TwlJPSEooaApVwHkFxlFFwZ0TRHeKhakRDJPeSnADwm6plHO9
   w==;
X-CSE-ConnectionGUID: 5ODAVHnkSD2FVpdRh722AQ==
X-CSE-MsgGUID: CK3ZzsHXQBeMs6Fb1FepTw==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11586469"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11586469"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 01:08:21 -0700
X-CSE-ConnectionGUID: IXGLHMD/Q4GuYScI6e7hmQ==
X-CSE-MsgGUID: kksJ9NqFQ+yHVxnzPNncoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30618676"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 01:08:14 -0700
Message-ID: <719d8331-331b-46b2-a2ff-fe5ff7fa4b5e@linux.intel.com>
Date: Tue, 14 May 2024 16:08:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 30/54] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-31-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240506053020.3911940-31-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/6/2024 1:29 PM, Mingwei Zhang wrote:
> Implement the save/restore of PMU state for pasthrough PMU in Intel. In
> passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
> the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
> and gains the full HW PMU ownership. On the contrary, host regains the
> ownership of PMU HW from KVM when control flow leaves the scope of
> passthrough PMU.
>
> Implement PMU context switches for Intel CPUs and opptunistically use
> rdpmcl() instead of rdmsrl() when reading counters since the former has
> lower latency in Intel CPUs.

It looks rdpmcl() optimization is removed from this patch, right? The
description is not identical with code.


>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>

The commit tags doesn't follow the rules in Linux document, we need to
change it in next version.

https://docs.kernel.org/process/submitting-patches.html#:~:text=Co%2Ddeveloped%2Dby%3A%20states,work%20on%20a%20single%20patch.

> ---
>  arch/x86/kvm/pmu.c           | 46 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c | 41 +++++++++++++++++++++++++++++++-
>  2 files changed, 86 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 782b564bdf96..13197472e31d 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -1068,14 +1068,60 @@ void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>  
>  void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	u32 i;
> +
>  	lockdep_assert_irqs_disabled();
>  
>  	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
> +
> +	/*
> +	 * Clear hardware selector MSR content and its counter to avoid
> +	 * leakage and also avoid this guest GP counter get accidentally
> +	 * enabled during host running when host enable global ctrl.
> +	 */
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		pmc = &pmu->gp_counters[i];
> +		rdmsrl(pmc->msr_counter, pmc->counter);

I understood we want to use common code to manipulate PMU MSRs as much as
possible, but I don't think we should sacrifice performance. rdpmcl() has
better performance than rdmsrl(). If AMD CPUs doesn't support rdpmc
instruction, I think we should move this into vendor specific
xxx_save/restore_pmu_context helpers().


> +		rdmsrl(pmc->msr_eventsel, pmc->eventsel);
> +		if (pmc->counter)
> +			wrmsrl(pmc->msr_counter, 0);
> +		if (pmc->eventsel)
> +			wrmsrl(pmc->msr_eventsel, 0);
> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		rdmsrl(pmc->msr_counter, pmc->counter);
> +		if (pmc->counter)
> +			wrmsrl(pmc->msr_counter, 0);
> +	}
>  }
>  
>  void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	int i;
> +
>  	lockdep_assert_irqs_disabled();
>  
>  	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
> +
> +	/*
> +	 * No need to zero out unexposed GP/fixed counters/selectors since RDPMC
> +	 * in this case will be intercepted. Accessing to these counters and
> +	 * selectors will cause #GP in the guest.
> +	 */
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		pmc = &pmu->gp_counters[i];
> +		wrmsrl(pmc->msr_counter, pmc->counter);
> +		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel);
> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		wrmsrl(pmc->msr_counter, pmc->counter);
> +	}
>  }
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 7852ba25a240..a23cf9ca224e 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -572,7 +572,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	}
>  
>  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> -		pmu->fixed_counters[i].msr_eventsel = MSR_CORE_PERF_FIXED_CTR_CTRL;
> +		pmu->fixed_counters[i].msr_eventsel = 0;
Why to initialize msr_eventsel to 0 instead of the real MSR address here?
>  		pmu->fixed_counters[i].msr_counter = MSR_CORE_PERF_FIXED_CTR0 + i;
>  	}
>  }
> @@ -799,6 +799,43 @@ static void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>  	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, msr_intercept);
>  }
>  
> +static void intel_save_guest_pmu_context(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	/* Global ctrl register is already saved at VM-exit. */
> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
> +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
> +	if (pmu->global_status)
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
> +
> +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> +	/*
> +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
> +	 * also avoid these guest fixed counters get accidentially enabled
> +	 * during host running when host enable global ctrl.
> +	 */
> +	if (pmu->fixed_ctr_ctrl)
> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> +}
> +
> +static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	u64 global_status, toggle;
> +
> +	/* Clear host global_ctrl MSR if non-zero. */
> +	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
> +	toggle = pmu->global_status ^ global_status;
> +	if (global_status & toggle)
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status & toggle);
> +	if (pmu->global_status & toggle)
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
> +
> +	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> +}
> +
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
> @@ -812,6 +849,8 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.cleanup = intel_pmu_cleanup,
>  	.is_rdpmc_passthru_allowed = intel_is_rdpmc_passthru_allowed,
>  	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
> +	.save_pmu_context = intel_save_guest_pmu_context,
> +	.restore_pmu_context = intel_restore_guest_pmu_context,
>  	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
>  	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
>  	.MIN_NR_GP_COUNTERS = 1,

