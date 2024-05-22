Return-Path: <kvm+bounces-17959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 747D08CC32B
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 16:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E55101F22E23
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 14:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28414141981;
	Wed, 22 May 2024 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJ/6dq45"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061541DA24;
	Wed, 22 May 2024 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716387822; cv=none; b=m8SrIczBdNiVR4El8Ns0rwGeTRU8eKw1GIS5SKwYAfa+Ce3SpgouaJBvXUwfqzCKCUNnQME4dM0OZ7AZP6/9rMn/Sd6MQHXtlM4sQ8+vDgsHLBQoXj7ZVh8gajK0eerGrsqYL4krOfx9JWkXA1NlqJ7GforqiIsKCaBsGOsfoX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716387822; c=relaxed/simple;
	bh=Eb/RxZdx4vS9nLLJUopim4liBTrE/JlAK+oShhTetfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFJhWMG6HDAYTik8sE/xVgfVXsk3+R3L41YUq0nD50FTm689Q3jVoskNflSO6o1eRCat49apVLn7TX0eX3armSK+DixUaEdL9b+rUNiK0AyvLdSdiTU73zcJCLU+jUcJ/bDM+fwU3FHoIrajWtwew+JNyV3q2IA20/IeiaXHn8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJ/6dq45; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716387820; x=1747923820;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Eb/RxZdx4vS9nLLJUopim4liBTrE/JlAK+oShhTetfQ=;
  b=HJ/6dq45Bbw4JNaeOHKFCq6QmiSA2SJLh0xnChiE6Ur9ZfXHXvNP/4Gz
   W9F66x7WncnHU71dbMnY7hDhwib7e76W+2zSmGkebhYX9du2JX7BqUW+C
   k0gU9t1+eCSpslIG20dH9Wlasl4pWEclk/JscrEH72RdRuoIiu9UlBjTQ
   kV7ZliMFr3Pzvg+q2l5gVFuq7Ri1ZVNv5FJqjahETM1/g/oHRRsB/vFVg
   AoqjmH4uOWUQDsewBWTESumYzCZY5S7vDsCJ23ey+ezz8PT359UM35D09
   D0W1TIjmtxXKBVyOK98ZTANwk51eYVovwJ2F/S8DYUsHhs+DcnN7YivGN
   Q==;
X-CSE-ConnectionGUID: gV2qFDxJRPyUkQ2NOR9scg==
X-CSE-MsgGUID: wSWb7UoVRRSDkKN6ypZYZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="23310976"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="23310976"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 07:23:39 -0700
X-CSE-ConnectionGUID: IIZZvptXSEi4zXdmG3keEw==
X-CSE-MsgGUID: pZxeQPYdQjG0uvdB/LgbVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33293430"
Received: from yzhou73-mobl1.ccr.corp.intel.com (HELO [10.124.224.51]) ([10.124.224.51])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 07:23:36 -0700
Message-ID: <8de7b84a-ba77-4df0-9cec-8478f56222bb@linux.intel.com>
Date: Wed, 22 May 2024 22:23:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 36/49] KVM: x86: Rename "governed features" helpers to
 use "guest_cpu_cap"
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-37-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240517173926.965351-37-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/18/2024 1:39 AM, Sean Christopherson wrote:
> As the first step toward replacing KVM's so-called "governed features"
> framework with a more comprehensive, less poorly named implementation,
> replace the "kvm_governed_feature" function prefix with "guest_cpu_cap"
> and rename guest_can_use() to guest_cpu_cap_has().
>
> The "guest_cpu_cap" naming scheme mirrors that of "kvm_cpu_cap", and
> provides a more clear distinction between guest capabilities, which are
> KVM controlled (heh, or one might say "governed"), and guest CPUID, which
> with few exceptions is fully userspace controlled.
>
> Opportunistically rewrite the comment about XSS passthrough for SEV-ES
> guests to avoid referencing so many functions, as such comments are prone
> to becoming stale (case in point...).
>
> No functional change intended.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c      |  2 +-
>   arch/x86/kvm/cpuid.h      | 16 ++++++++--------
>   arch/x86/kvm/mmu.h        |  2 +-
>   arch/x86/kvm/mmu/mmu.c    |  4 ++--
>   arch/x86/kvm/svm/nested.c | 22 +++++++++++-----------
>   arch/x86/kvm/svm/sev.c    | 17 ++++++++---------
>   arch/x86/kvm/svm/svm.c    | 26 +++++++++++++-------------
>   arch/x86/kvm/svm/svm.h    |  4 ++--
>   arch/x86/kvm/vmx/nested.c |  6 +++---
>   arch/x86/kvm/vmx/vmx.c    | 16 ++++++++--------
>   arch/x86/kvm/x86.c        |  4 ++--
>   11 files changed, 59 insertions(+), 60 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 16bb873188d6..286abefc93d5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -407,7 +407,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
>   				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
>   	if (allow_gbpages)
> -		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
> +		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
>   
>   	best = kvm_find_cpuid_entry(vcpu, 1);
>   	if (best && apic) {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index d68b7d879820..e021681f34ac 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -256,8 +256,8 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
>   	return kvm_governed_feature_index(x86_feature) >= 0;
>   }
>   
> -static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
> -						     unsigned int x86_feature)
> +static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
> +					      unsigned int x86_feature)
>   {
>   	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
>   
> @@ -265,15 +265,15 @@ static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
>   		  vcpu->arch.governed_features.enabled);
>   }
>   
> -static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
> -							       unsigned int x86_feature)
> +static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> +							unsigned int x86_feature)
>   {
>   	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
> -		kvm_governed_feature_set(vcpu, x86_feature);
> +		guest_cpu_cap_set(vcpu, x86_feature);
>   }
>   
> -static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
> -					  unsigned int x86_feature)
> +static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> +					      unsigned int x86_feature)
>   {
>   	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
>   
> @@ -283,7 +283,7 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
>   
>   static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   {
> -	if (guest_can_use(vcpu, X86_FEATURE_LAM))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LAM))
>   		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
>   
>   	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index dc80e72e4848..cf95ea5fe29d 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -150,7 +150,7 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>   
>   static inline unsigned long kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
>   {
> -	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LAM))
>   		return 0;
>   
>   	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5095fb46713e..e18a10c59431 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4966,7 +4966,7 @@ static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>   	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
>   				vcpu->arch.reserved_gpa_bits,
>   				context->cpu_role.base.level, is_efer_nx(context),
> -				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
> +				guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES),
>   				is_cr4_pse(context),
>   				guest_cpuid_is_amd_compatible(vcpu));
>   }
> @@ -5043,7 +5043,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
>   	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
>   				context->root_role.level,
>   				context->root_role.efer_nx,
> -				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
> +				guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES),
>   				is_pse, is_amd);
>   
>   	if (!shadow_me_mask)
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 55b9a6d96bcf..2900a8e21257 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -107,7 +107,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
>   
>   static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
>   {
> -	if (!guest_can_use(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
> +	if (!guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
>   		return true;
>   
>   	if (!nested_npt_enabled(svm))
> @@ -590,7 +590,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>   		vmcb_mark_dirty(vmcb02, VMCB_DR);
>   	}
>   
> -	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> +	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>   		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
>   		/*
>   		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
> @@ -647,7 +647,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
>   	 */
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_VGIF) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VGIF) &&
>   	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
>   		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>   	else
> @@ -685,7 +685,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   
>   	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR) &&
>   	    svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio)
>   		nested_svm_update_tsc_ratio_msr(vcpu);
>   
> @@ -706,7 +706,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
>   	 * prior to injecting the event).
>   	 */
> -	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>   		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
>   	else if (boot_cpu_has(X86_FEATURE_NRIPS))
>   		vmcb02->control.next_rip    = vmcb12_rip;
> @@ -716,7 +716,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   		svm->soft_int_injected = true;
>   		svm->soft_int_csbase = vmcb12_csbase;
>   		svm->soft_int_old_rip = vmcb12_rip;
> -		if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>   			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
>   		else
>   			svm->soft_int_next_rip = vmcb12_rip;
> @@ -724,18 +724,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   
>   	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
>   					      LBR_CTL_ENABLE_MASK;
> -	if (guest_can_use(vcpu, X86_FEATURE_LBRV))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV))
>   		vmcb02->control.virt_ext  |=
>   			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
>   
>   	if (!nested_vmcb_needs_vls_intercept(svm))
>   		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_PAUSEFILTER))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
>   		pause_count12 = svm->nested.ctl.pause_filter_count;
>   	else
>   		pause_count12 = 0;
> -	if (guest_can_use(vcpu, X86_FEATURE_PFTHRESHOLD))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PFTHRESHOLD))
>   		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
>   	else
>   		pause_thresh12 = 0;
> @@ -1022,7 +1022,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
>   		nested_save_pending_event_to_vmcb12(svm, vmcb12);
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>   		vmcb12->control.next_rip  = vmcb02->control.next_rip;
>   
>   	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> @@ -1061,7 +1061,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	if (!nested_exit_on_intr(svm))
>   		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>   
> -	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> +	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>   		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
>   		svm_copy_lbrs(vmcb12, vmcb02);
>   		svm_update_lbrv(vcpu);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 57c2c8025547..7640dedc2ddc 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4409,16 +4409,15 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
>   	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
>   	 * the host/guest supports its use.
>   	 *
> -	 * guest_can_use() checks a number of requirements on the host/guest to
> -	 * ensure that MSR_IA32_XSS is available, but it might report true even
> -	 * if X86_FEATURE_XSAVES isn't configured in the guest to ensure host
> -	 * MSR_IA32_XSS is always properly restored. For SEV-ES, it is better
> -	 * to further check that the guest CPUID actually supports
> -	 * X86_FEATURE_XSAVES so that accesses to MSR_IA32_XSS by misbehaved
> -	 * guests will still get intercepted and caught in the normal
> -	 * kvm_emulate_rdmsr()/kvm_emulated_wrmsr() paths.
> +	 * KVM treats the guest as being capable of using XSAVES even if XSAVES
> +	 * isn't enabled in guest CPUID as there is no intercept for XSAVES,
> +	 * i.e. the guest can use XSAVES/XRSTOR to read/write XSS if XSAVE is
> +	 * exposed to the guest and XSAVES is supported in hardware.  Condition
> +	 * full XSS passthrough on the guest being able to use XSAVES *and*
> +	 * XSAVES being exposed to the guest so that KVM can at least honor
> +	 * guest CPUID for RDMSR and WRMSR.
>   	 */
> -	if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>   	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
>   	else
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3d0549ca246f..2acd2e3bb1b0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1039,7 +1039,7 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
>   	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
> -			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> +			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>   			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>   
>   	if (enable_lbrv == current_enable_lbrv)
> @@ -2841,7 +2841,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	switch (msr_info->index) {
>   	case MSR_AMD64_TSC_RATIO:
>   		if (!msr_info->host_initiated &&
> -		    !guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR))
> +		    !guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR))
>   			return 1;
>   		msr_info->data = svm->tsc_ratio_msr;
>   		break;
> @@ -2991,7 +2991,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   	switch (ecx) {
>   	case MSR_AMD64_TSC_RATIO:
>   
> -		if (!guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR)) {
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR)) {
>   
>   			if (!msr->host_initiated)
>   				return 1;
> @@ -3013,7 +3013,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   
>   		svm->tsc_ratio_msr = data;
>   
> -		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR) &&
>   		    is_guest_mode(vcpu))
>   			nested_svm_update_tsc_ratio_msr(vcpu);
>   
> @@ -4342,11 +4342,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
>   	    boot_cpu_has(X86_FEATURE_XSAVES) &&
>   	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
> +		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
>   
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LBRV);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
>   
>   	/*
>   	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
> @@ -4354,12 +4354,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 * SVM on Intel is bonkers and extremely unlikely to work).
>   	 */
>   	if (!guest_cpuid_is_intel(vcpu))
> -		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> +		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>   
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VGIF);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VNMI);
>   
>   	svm_recalc_instruction_intercepts(vcpu, svm);
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 97b3683ea324..08fd788d08df 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -487,7 +487,7 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>   
>   static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
>   {
> -	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
> +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VGIF) &&
>   	       (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
>   }
>   
> @@ -539,7 +539,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>   
>   static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
>   {
> -	return guest_can_use(&svm->vcpu, X86_FEATURE_VNMI) &&
> +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
>   	       (svm->nested.ctl.int_ctl & V_NMI_ENABLE_MASK);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d5b832126e34..fb7eec29681d 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6488,7 +6488,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>   	vmx = to_vmx(vcpu);
>   	vmcs12 = get_vmcs12(vcpu);
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_VMX) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX) &&
>   	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
>   		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
>   		kvm_state.hdr.vmx.vmcs12_pa = vmx->nested.current_vmptr;
> @@ -6629,7 +6629,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
>   			return -EINVAL;
>   	} else {
> -		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>   			return -EINVAL;
>   
>   		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
> @@ -6663,7 +6663,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   		return -EINVAL;
>   
>   	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
> -	    (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
> +	    (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX) ||
>   	     !vmx->nested.enlightened_vmcs_enabled))
>   			return -EINVAL;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 51b2cd13250a..1bc56596d653 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2050,7 +2050,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
>   		break;
>   	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
> -		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>   			return 1;
>   		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>   				    &msr_info->data))
> @@ -2360,7 +2360,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>   		if (!msr_info->host_initiated)
>   			return 1; /* they are read-only */
> -		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>   			return 1;
>   		return vmx_set_vmx_msr(vcpu, msr_index, data);
>   	case MSR_IA32_RTIT_CTL:
> @@ -4571,7 +4571,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>   												\
>   	if (cpu_has_vmx_##name()) {								\
>   		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
> -			__enabled = guest_can_use(__vcpu, X86_FEATURE_##feat_name);		\
> +			__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);		\
>   		else										\
>   			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
>   		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
> @@ -7838,10 +7838,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 */
>   	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
>   	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
> +		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_XSAVES);
>   
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VMX);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LAM);
>   
>   	vmx_setup_uret_msrs(vmx);
>   
> @@ -7849,7 +7849,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		vmcs_set_secondary_exec_control(vmx,
>   						vmx_secondary_exec_control(vmx));
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_VMX))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>   		vmx->msr_ia32_feature_control_valid_bits |=
>   			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>   			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> @@ -7858,7 +7858,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>   			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
>   
> -	if (guest_can_use(vcpu, X86_FEATURE_VMX))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>   		nested_vmx_cr_fixed1_bits_update(vcpu);
>   
>   	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7160c5ab8e3e..4ca9651b3f43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1026,7 +1026,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>   		if (vcpu->arch.xcr0 != host_xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>   
> -		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>   		    vcpu->arch.ia32_xss != host_xss)
>   			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>   	}
> @@ -1057,7 +1057,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>   		if (vcpu->arch.xcr0 != host_xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
>   
> -		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>   		    vcpu->arch.ia32_xss != host_xss)
>   			wrmsrl(MSR_IA32_XSS, host_xss);
>   	}


