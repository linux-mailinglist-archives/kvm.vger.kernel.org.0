Return-Path: <kvm+bounces-54086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 291AFB1C144
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5243618526C
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DE5219E8F;
	Wed,  6 Aug 2025 07:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DSu5/tJk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3112020468E;
	Wed,  6 Aug 2025 07:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465114; cv=none; b=srfYePOPXDfSwj4tYY5VmtRKImqjFN/gaZxy1hA/7Rt3oRdwBtZr4MoA9uEH94CmcchusGiMgiEBv6gnbeFikl08CVHA4S1nXa0jtneJonOYo/xOxrZEPlEnA/R1vpgjhkpkXuXZv4NlfoEVZWsUJWJ29e0dH+2zkKk3Hc4U3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465114; c=relaxed/simple;
	bh=FReDocDPYCnAv9Lw8bKXkH6S2UNEamnQtGsEnUKJ3D8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sJNnVHKfZxXYdfIb10PFBDuyfZZ78XOv8FY1WidYTbXpcmbxU4OMdyyq+beuGj/Igxd4jvBXyc1hcBiAUspTxVfUYpPQrlIF4kMqXv+TPGJ50aZy4i4fE9zpX2ZILQEkEAxFj4de21FnP/SHF4BkA8EB4AZVntMACwWyHqdfFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DSu5/tJk; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465113; x=1786001113;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FReDocDPYCnAv9Lw8bKXkH6S2UNEamnQtGsEnUKJ3D8=;
  b=DSu5/tJkvGkuKyHBpi02xOcp5yTfcFKvWdaXpZx7kEFl34QJLDRs9F3T
   oLoPdn5SaKE+tr1xCnfyNhptTLaNsAnHChHi1xqcwnlIa/N88SNzs3rgm
   yVws5OIWRPhw91PfX255bUr+OnpDFeEthNmlpvvgmZ9NjHZnWfDnYo6ID
   12jcoR6DoYPC3vz2WGFnyx6+qpX3mktTOCyjuABmX2L7HLK4+DTu8y7tj
   5sTEkHtztv4sKAiDjh/EoHOsUbfgPjISIWDkOn1wWaP7UmWAM9j6L8Gy3
   O2/NLiGHh+E0SGkMrcqHAtkBE3s7zkWfFvzCqggNrJJ/QpUI96Zasrgkx
   Q==;
X-CSE-ConnectionGUID: aGR/q+pcT3CxQgZOb4iCLg==
X-CSE-MsgGUID: sfZFEDW9S+6vZtHu45qy7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56910088"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56910088"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:25:13 -0700
X-CSE-ConnectionGUID: gTev9yaiSRWFyf7RjThVZg==
X-CSE-MsgGUID: BvyXXFSgTiik9NjtJaUQjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="195667189"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:25:11 -0700
Message-ID: <06607e2f-f785-4d62-9bdd-9874aa665341@linux.intel.com>
Date: Wed, 6 Aug 2025 15:25:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/18] KVM: x86/pmu: Add wrappers for counting emulated
 instructions/branches
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-11-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Add wrappers for triggering instruction retired and branch retired PMU
> events in anticipation of reworking the internal mechanisms to track
> which PMCs need to be evaluated, e.g. to avoid having to walk and check
> every PMC.
>
> Opportunistically bury "struct kvm_pmu_emulated_event_selectors" in pmu.c.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c        | 22 ++++++++++++++++++----
>  arch/x86/kvm/pmu.h        |  9 ++-------
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/x86.c        |  6 +++---
>  4 files changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index eb17d90916ea..e1911b366c43 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -29,8 +29,11 @@
>  struct x86_pmu_capability __read_mostly kvm_pmu_cap;
>  EXPORT_SYMBOL_GPL(kvm_pmu_cap);
>  
> -struct kvm_pmu_emulated_event_selectors __read_mostly kvm_pmu_eventsel;
> -EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
> +struct kvm_pmu_emulated_event_selectors {
> +	u64 INSTRUCTIONS_RETIRED;
> +	u64 BRANCH_INSTRUCTIONS_RETIRED;
> +};
> +static struct kvm_pmu_emulated_event_selectors __read_mostly kvm_pmu_eventsel;
>  
>  /* Precise Distribution of Instructions Retired (PDIR) */
>  static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
> @@ -907,7 +910,7 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>  							 select_user;
>  }
>  
> -void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
> +static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>  {
>  	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -944,7 +947,18 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>  		kvm_pmu_incr_counter(pmc);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
> +
> +void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu)
> +{
> +	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
> +}
> +EXPORT_SYMBOL_GPL(kvm_pmu_instruction_retired);
> +
> +void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu)
> +{
> +	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
> +}
> +EXPORT_SYMBOL_GPL(kvm_pmu_branch_retired);
>  
>  static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
>  {
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 13477066eb40..740af816af37 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -23,11 +23,6 @@
>  
>  #define KVM_FIXED_PMC_BASE_IDX INTEL_PMC_IDX_FIXED
>  
> -struct kvm_pmu_emulated_event_selectors {
> -	u64 INSTRUCTIONS_RETIRED;
> -	u64 BRANCH_INSTRUCTIONS_RETIRED;
> -};
> -
>  struct kvm_pmu_ops {
>  	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
>  		unsigned int idx, u64 *mask);
> @@ -178,7 +173,6 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>  }
>  
>  extern struct x86_pmu_capability kvm_pmu_cap;
> -extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
>  
>  void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
>  
> @@ -227,7 +221,8 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
>  void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
>  void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
>  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
> -void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
> +void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
> +void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
>  
>  bool is_vmware_backdoor_pmc(u32 pmc_idx);
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b8ea1969113d..db2fd4eedc90 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3690,7 +3690,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		return 1;
>  	}
>  
> -	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
> +	kvm_pmu_branch_retired(vcpu);
>  
>  	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
>  		return nested_vmx_failInvalid(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a4441f036929..f2b2eaaec6f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8824,7 +8824,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	if (unlikely(!r))
>  		return 0;
>  
> -	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
> +	kvm_pmu_instruction_retired(vcpu);
>  
>  	/*
>  	 * rflags is the old, "raw" value of the flags.  The new value has
> @@ -9158,9 +9158,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		 */
>  		if (!ctxt->have_exception ||
>  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
> -			kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
> +			kvm_pmu_instruction_retired(vcpu);
>  			if (ctxt->is_branch)
> -				kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
> +				kvm_pmu_branch_retired(vcpu);
>  			kvm_rip_write(vcpu, ctxt->eip);
>  			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
>  				r = kvm_vcpu_do_singlestep(vcpu);

LGTM. Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



