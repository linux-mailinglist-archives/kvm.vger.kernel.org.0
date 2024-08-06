Return-Path: <kvm+bounces-23315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A69F1948A1C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA1E11C232FA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 07:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67E7166F2F;
	Tue,  6 Aug 2024 07:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nU10mcLX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B70164A;
	Tue,  6 Aug 2024 07:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722929265; cv=none; b=TB8Oam5N0kRmlmF8LFRHXH1kwQyPf6vTsyP21lpoZBD3WCHFEqK/p1Sfy4iR5LXsr8BTlQCRpQNqJEmUQBtJDa6q78pQ+Lhl2aSfI7MMygdbiK1U8dm6z4sLuDvu18u1eDu7ESqByNHMRru0rzf3l6yx2sgf7XINf2+4cX0cOmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722929265; c=relaxed/simple;
	bh=gKPYLL0r0hx9riaoaOLeME5DEZsLltEzisu7gtaBBNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ce9AO/UGvDbMRTpHIBChXXAznj7XQiomgvXyFR/sTawwUL9WWVNwtTnkuxof9KEH9s6qJA4JryBHY1zVWf5nJKQu4wQ9NwUYaQSIFCnaqVLfNJRehslqTREhaDbEHh3+vw9O4AUwEDvFTYQ0AFDuNfyxQ2p0ZMTsZp9jBCMfimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nU10mcLX; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722929263; x=1754465263;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gKPYLL0r0hx9riaoaOLeME5DEZsLltEzisu7gtaBBNw=;
  b=nU10mcLXkid35p0iWwjaIXTyDO/T0wf0VHwyaCX9hbpRmdz7kupxOG31
   OswIFO4dytxA28bNmSn06bPMs0Jz3HYeLg4v8tVH68bMJwkP8YHilF8EL
   2yZsScm4lAQBwv6fGK0WlR7y9xMoufeVCMn6H6307EuxSWZLRwH+Tsjs5
   BNsAZ5mw5sle2LSk/YjhMJb6F6hLxsyZot9uIs9tD8SswQB4j43H5okJL
   vyeWLJiZ8KlHNiqogFJMs5X/vguSexL0p4tXDp/zqWMsVQ34Qiw2DudTw
   DYq1rMV8pcOYqCeQpbXpBeu8Y5rAM9588x2CWxItC/YpIs3WwkEGiJey8
   g==;
X-CSE-ConnectionGUID: 9ij3mqigS56E84Rr456RTg==
X-CSE-MsgGUID: A5wwdduuR5WqAuWL3L1Iyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="20802692"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="20802692"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 00:27:43 -0700
X-CSE-ConnectionGUID: JU0Yp/hxR7ata3PJTD38kg==
X-CSE-MsgGUID: HFencd3iQiuK1GzOv02hdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="57124637"
Received: from unknown (HELO [10.238.3.66]) ([10.238.3.66])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 00:27:38 -0700
Message-ID: <602b71db-821d-40af-8ec2-d255f465b060@linux.intel.com>
Date: Tue, 6 Aug 2024 15:27:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 33/58] KVM: x86/pmu: Implement the save/restore of
 PMU state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-34-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-34-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
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
>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/kvm/pmu.c           | 46 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c | 41 +++++++++++++++++++++++++++++++-
>  2 files changed, 86 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 782b564bdf96..9bb733384069 100644
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
> +		rdpmcl(i, pmc->counter);
> +		rdmsrl(pmc->msr_eventsel, pmc->eventsel);
> +		if (pmc->counter)
> +			wrmsrl(pmc->msr_counter, 0);
> +		if (pmc->eventsel)
> +			wrmsrl(pmc->msr_eventsel, 0);
> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
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

pmu->gp_counters[i].eventsel  -> pmc->eventsel


> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +		wrmsrl(pmc->msr_counter, pmc->counter);
> +	}
>  }
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 0de918dc14ea..89c8f73a48c8 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -572,7 +572,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	}
>  
>  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> -		pmu->fixed_counters[i].msr_eventsel = MSR_CORE_PERF_FIXED_CTR_CTRL;
> +		pmu->fixed_counters[i].msr_eventsel = 0;

Seems unnecessary to clear msr_eventsel for fixed counters. Why?


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

