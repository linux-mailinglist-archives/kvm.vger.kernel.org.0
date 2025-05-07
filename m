Return-Path: <kvm+bounces-45689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9DAAAD501
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEB5E468597
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 05:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11A81E8348;
	Wed,  7 May 2025 05:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WyB8ehr0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39C31DF252;
	Wed,  7 May 2025 05:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746595034; cv=none; b=Z5R0SCFsYq4BUk5/3Dd+242uvcMJrwRSatTuSZMCQiPR0zE5qjEp28jo64VxxoXkUruXjw54ke2L4Zn9cYWzH+Olmd7zfibyGYZUcfk7ySv1emZRt1euAyGzFSYL7wic0KDTAqPvqfGC6wf+DAlUpQ9s2dUZcGvwF4bluALami0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746595034; c=relaxed/simple;
	bh=12IwskIPhu6oGfNdKGzLFMEBm5EiP9FaKcKTQO4HPAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4aqN4yNnlWkFbLbCmbeNRIJcreEua+5ctsnYNcL1zgqW5/3mIPhbRDymcQbdl9ZvZHAjPPlqLn0k2cI7e3kCZ+4fkCjiXmivXT5has9U7cJNF3az16vUyZv9I1RzRC6m3qbrxTOJDOYM8ikTzsGJUPPaMrINGaA6KOAjclumbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WyB8ehr0; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746595032; x=1778131032;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=12IwskIPhu6oGfNdKGzLFMEBm5EiP9FaKcKTQO4HPAY=;
  b=WyB8ehr0o1KknEhdaxwhJg75fyA86x9K/WiMuHzSb0Fs81bqCfcWmVOa
   RiiKCRQGU+sc1T5tBCO/EETKjfzM1xpva6KiIUnv33VeVkKKIgm+pcc1R
   DHEpttG1ptvzgZ7yuQkiNwQQUwy2OEgs42XVJlbVcyt2/9FCtt7UudXGX
   3HajIx5Ezb2tz23KgIP63sGMTxe9IASYJZJr+RygNNOrzhpfHpNKf0vbJ
   n7U1gFzcdLDqbBJf6Vru45q7KANYEySJLAplb4tCmpLBWsv60soAgWQBJ
   u8urZgRtDybfpsIVjHp2fj8Ke1owUmCKbxJu5dxQYjqItISiQOeh1geH0
   w==;
X-CSE-ConnectionGUID: U3iYqsOARHO5GZamphOsEw==
X-CSE-MsgGUID: bHjBrh29Qm2n/PBsGlZgjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47400509"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47400509"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:17:11 -0700
X-CSE-ConnectionGUID: 02f5Ksq8TaS7odhxSO8Kpw==
X-CSE-MsgGUID: 3A7aY4KwSPGVig9mHadwXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="140954642"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:17:07 -0700
Message-ID: <86f9b2f0-533c-478d-ac9a-dbee11537dac@linux.intel.com>
Date: Wed, 7 May 2025 13:17:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write
 with access functions
To: mlevitsk@redhat.com, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
 <20250416002546.3300893-2-mlevitsk@redhat.com>
 <1a0325af-f264-47de-b9f7-da9721366c20@linux.intel.com>
 <517ee0b7ba1a68a63e9e1068ec2570c62471d695.camel@redhat.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <517ee0b7ba1a68a63e9e1068ec2570c62471d695.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/2/2025 4:34 AM, mlevitsk@redhat.com wrote:
> On Wed, 2025-04-23 at 17:51 +0800, Mi, Dapeng wrote:
>> The shortlog "x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write with
>> access functions" doesn't follow Sean's suggestion
>> (https://github.com/kvm-x86/linux/blob/next/Documentation/process/maintainer-kvm-x86.rst#shortlog).
>> Please modify. Thanks.
>>
>>
>> On 4/16/2025 8:25 AM, Maxim Levitsky wrote:
>>> Instead of reading and writing GUEST_IA32_DEBUGCTL vmcs field directly,
>>> wrap the logic with get/set functions.
>>>
>>> Also move the checks that the guest's supplied value is valid to the new
>>> 'set' function.
>>>
>>> In particular, the above change fixes a minor security issue in which L1
>>> hypervisor could set the GUEST_IA32_DEBUGCTL, and eventually the host's
>>> MSR_IA32_DEBUGCTL to any value by performing a VM entry to L2 with
>>> VM_ENTRY_LOAD_DEBUG_CONTROLS set.
>>>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>  arch/x86/kvm/vmx/nested.c    | 15 +++++++---
>>>  arch/x86/kvm/vmx/pmu_intel.c |  9 +++---
>>>  arch/x86/kvm/vmx/vmx.c       | 58 +++++++++++++++++++++++-------------
>>>  arch/x86/kvm/vmx/vmx.h       |  3 ++
>>>  4 files changed, 57 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index e073e3008b16..b7686569ee09 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -2641,6 +2641,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>  	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
>>>  	bool load_guest_pdptrs_vmcs12 = false;
>>> +	u64 new_debugctl;
>>>  
>>>  	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
>>>  		prepare_vmcs02_rare(vmx, vmcs12);
>>> @@ -2653,11 +2654,17 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>>  	if (vmx->nested.nested_run_pending &&
>>>  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
>>>  		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
>>> -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
>>> +		new_debugctl = vmcs12->guest_ia32_debugctl;
>>>  	} else {
>>>  		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
>>> -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
>>> +		new_debugctl = vmx->nested.pre_vmenter_debugctl;
>>>  	}
>>> +
>>> +	if (CC(!vmx_set_guest_debugctl(vcpu, new_debugctl, false))) {
>>> +		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>>> +		return -EINVAL;
>>> +	}
>>> +
>>>  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>>>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>>>  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
>>> @@ -3520,7 +3527,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>>>  
>>>  	if (!vmx->nested.nested_run_pending ||
>>>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
>>> -		vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>> +		vmx->nested.pre_vmenter_debugctl = vmx_get_guest_debugctl(vcpu);
>>>  	if (kvm_mpx_supported() &&
>>>  	    (!vmx->nested.nested_run_pending ||
>>>  	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>>> @@ -4788,7 +4795,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>>>  	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
>>>  
>>>  	kvm_set_dr(vcpu, 7, 0x400);
>>> -	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
>>> +	vmx_set_guest_debugctl(vcpu, 0, false);
>>>  
>>>  	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
>>>  				vmcs12->vm_exit_msr_load_count))
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>> index 8a94b52c5731..f6f448adfb80 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -19,6 +19,7 @@
>>>  #include "lapic.h"
>>>  #include "nested.h"
>>>  #include "pmu.h"
>>> +#include "vmx.h"
>>>  #include "tdx.h"
>>>  
>>>  /*
>>> @@ -652,11 +653,11 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>>>   */
>>>  static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>>>  {
>>> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>> +	u64 data = vmx_get_guest_debugctl(vcpu);
>>>  
>>>  	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>>>  		data &= ~DEBUGCTLMSR_LBR;
>>> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>> +		vmx_set_guest_debugctl(vcpu, data, true);
>> Two questions. 
>>
>> 1. why to call vmx_set_guest_debugctl() to do the extra check? currently
>> IA32_DEBUGCTL MSR is always intercepted and it's already checked at
>> vmx_set_msr() and seems unnecessary to check here again.
> Hi,
>
>
> I wanted this to be consistent. KVM has plenty of functions that can be both
> guest triggered and internally triggered. For example kvm_set_cr4()
>
> Besides the vmx_set_guest_debugctl also notes the value the guest wrote
> to be able to return it back to the guest if we choose to overide some
> bits of the MSR, so it made sense to have one common function to set the msr.
>
> Do you think that can affect performance? 

hmm, since only DEBUGCTLMSR_LBR bit is changed here, it's safe to skip this
check and write guest debug_ctrl directly. I have no idea how much
performance impact this check would bring in high sampling frequency, but
why not to eliminate it if it can?


>
>
>> 2. why the argument "host_initiated" is true? It looks the data is not from
>> host.
> This is my mistake.
>
>>
>>>  	}
>>>  }
>>>  
>>> @@ -729,7 +730,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>>>  
>>>  	if (!lbr_desc->event) {
>>>  		vmx_disable_lbr_msrs_passthrough(vcpu);
>>> -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
>>> +		if (vmx_get_guest_debugctl(vcpu) & DEBUGCTLMSR_LBR)
>>>  			goto warn;
>>>  		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>>>  			goto warn;
>>> @@ -751,7 +752,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>>>  
>>>  static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>>>  {
>>> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
>>> +	if (!(vmx_get_guest_debugctl(vcpu) & DEBUGCTLMSR_LBR))
>>>  		intel_pmu_release_guest_lbr_event(vcpu);
>>>  }
>>>  
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index ef2d7208dd20..4237422dc4ed 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -2154,7 +2154,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>>>  		break;
>>>  	case MSR_IA32_DEBUGCTLMSR:
>>> -		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>> +		msr_info->data = vmx_get_guest_debugctl(vcpu);
>>>  		break;
>>>  	default:
>>>  	find_uret_msr:
>>> @@ -2194,6 +2194,41 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>>>  	return debugctl;
>>>  }
>>>  
>>> +u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>>> +{
>>> +	return vmcs_read64(GUEST_IA32_DEBUGCTL);
>>> +}
>>> +
>>> +static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
>>> +{
>>> +	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>> +}
>> IMO,  it seems unnecessary to add these 2  wrappers since the original code
>> is already intuitive enough and simple. But if you want, please add
>> "inline" before these 2 wrappers.
> The __vmx_set_guest_debugctl in the next patch will store the written value in
> a field, this is why I did it this way.
>
> The vmx_get_guest_debugctl will read this value instead, also in the next patch.
>
> I thought it would be cleaner to first introduce the trivial wrappers and then
> extend them.
>
>>
>>> +
>>> +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
>> Since most of code in this function checks guest debugctl, better to rename
>> it to "vmx_check_and_set_guest_debugctl".
> I don't mind doing so.
>
>>
>>> +{
>>> +	u64 invalid = data & ~vmx_get_supported_debugctl(vcpu, host_initiated);
>>> +
>>> +	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
>>> +		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
>>> +		data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>>> +		invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>> Add space around above 3 "|".
> I copied this code "as is" from the wrmsr code. I can add this though.
>
> Best regards,
> 	Maxim Levitsky
>
>>
>>> +	}
>>> +
>>> +	if (invalid)
>>> +		return false;
>>> +
>>> +	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
>>> +					VM_EXIT_SAVE_DEBUG_CONTROLS))
>>> +		get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>>> +
>>> +	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>>> +	    (data & DEBUGCTLMSR_LBR))
>>> +		intel_pmu_create_guest_lbr_event(vcpu);
>>> +
>>> +	__vmx_set_guest_debugctl(vcpu, data);
>>> +	return true;
>>> +}
>>> +
>>>  /*
>>>   * Writes msr value into the appropriate "register".
>>>   * Returns 0 on success, non-0 otherwise.
>>> @@ -2263,26 +2298,9 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>  		vmcs_writel(GUEST_SYSENTER_ESP, data);
>>>  		break;
>>>  	case MSR_IA32_DEBUGCTLMSR: {
>>> -		u64 invalid;
>>> -
>>> -		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
>>> -		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
>>> -			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
>>> -			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>>> -			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>>> -		}
>>> -
>>> -		if (invalid)
>>> +		if (!vmx_set_guest_debugctl(vcpu, data, msr_info->host_initiated))
>>>  			return 1;
>>>  
>>> -		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
>>> -						VM_EXIT_SAVE_DEBUG_CONTROLS)
>>> -			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>>> -
>>> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>> -		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>>> -		    (data & DEBUGCTLMSR_LBR))
>>> -			intel_pmu_create_guest_lbr_event(vcpu);
>>>  		return 0;
>>>  	}
>>>  	case MSR_IA32_BNDCFGS:
>>> @@ -4795,7 +4813,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>>  	vmcs_write32(GUEST_SYSENTER_CS, 0);
>>>  	vmcs_writel(GUEST_SYSENTER_ESP, 0);
>>>  	vmcs_writel(GUEST_SYSENTER_EIP, 0);
>>> -	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
>>> +	__vmx_set_guest_debugctl(&vmx->vcpu, 0);
>>>  
>>>  	if (cpu_has_vmx_tpr_shadow()) {
>>>  		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>> index 6d1e40ecc024..8ac46fb47abd 100644
>>> --- a/arch/x86/kvm/vmx/vmx.h
>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>> @@ -404,6 +404,9 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>>  
>>>  gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
>>>  
>>> +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
>>> +u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu);
>>> +
>>>  static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>>>  					     int type, bool value)
>>>  {

