Return-Path: <kvm+bounces-63124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C77C5AB75
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 43F6E4E6004
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB07A1FDE31;
	Fri, 14 Nov 2025 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jCvHnZJK"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDDF1DB95E
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763078982; cv=none; b=Gb08FPjtp7wSP4LVcRcioa24sxgCwQ4blMp0CBHT7DEE+pGk3r6wruf+ugpaR5wRQFHaqgeC+gIzNgH6EYIS2ljvlF7yxSEYeNqPHLecM61or+2mSRTCsHDZxLMR0IQmgfLYgilrLqlEXmCBjYIoyaci1lgFQuO184ZwCPt4bC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763078982; c=relaxed/simple;
	bh=mIdP33LYIOLKVK1OLZZShibIchxNhDS4H2aTLnDUZ7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDCTXS5fkMUUcHR1TWqo1w3L7hpprO36vcTfg6WwSLcozTNvmMKDMXAXlVGRrCEtkxBWKPNOun2g9p5duY/P+7//zj6gwTEa25211jVjL7Eo5EwEm59JxuHYoBzIR4B/l8eq5tU/7cuYJrkUptmAnnqS0teoEB3jRJrLe1aIuRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jCvHnZJK; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 00:08:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763078975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4sp+ynMqQL//MeVZDram3HCrytcmSfwNg2N4vs0/nUg=;
	b=jCvHnZJKcSqRXS80tkKVsDG1vuCOrb/HQivZQ9XfqenN91GgehDM+Fk5E8dsxQfxJ/akam
	gTG7OZAirMEETi9MdGUmlHBHB1y/T3ylCuLztcZugamYnVmo6mpynuEQykwTTpfA6KcsT0
	OtJVVn6IRyvq6dQb5HSDelr/aCU/QCw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit
 value through all of KVM
Message-ID: <hrgt3ysu3gphcmzo3ec2go3btbug4yqkju4trotqkjoywpgyqq@qwj5l4wha6wb>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113225621.1688428-8-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 02:56:19PM -0800, Sean Christopherson wrote:
> Fix KVM's long-standing buggy handling of SVM's exit_code as a 32-bit
> value.  Per the APM and Xen commit d1bd157fbc ("Big merge the HVM
> full-virtualisation abstractions.") (which is arguably more trustworthy
> than KVM), offset 0x70 is a single 64-bit value:
> 
>   070h 63:0 EXITCODE
> 
> Track exit_code as a single u64 to prevent reintroducing bugs where KVM
> neglects to correctly set bits 63:32.
> 
> Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/include/asm/svm.h      |  3 +--
>  arch/x86/include/uapi/asm/svm.h | 32 ++++++++++++++---------------
>  arch/x86/kvm/svm/hyperv.c       |  1 -
>  arch/x86/kvm/svm/nested.c       | 13 +++---------
>  arch/x86/kvm/svm/sev.c          | 36 +++++++++++----------------------
>  arch/x86/kvm/svm/svm.c          |  7 ++-----
>  arch/x86/kvm/svm/svm.h          |  4 +---
>  arch/x86/kvm/trace.h            |  2 +-
>  include/hyperv/hvgdk.h          |  2 +-
>  9 files changed, 37 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index e69b6d0dedcf..66b22cffedfc 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -136,8 +136,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u32 int_vector;
>  	u32 int_state;
>  	u8 reserved_3[4];
> -	u32 exit_code;
> -	u32 exit_code_hi;
> +	u64 exit_code;
>  	u64 exit_info_1;
>  	u64 exit_info_2;
>  	u32 exit_int_info;
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 650e3256ea7d..010a45c9f614 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -103,38 +103,38 @@
>  #define SVM_EXIT_VMGEXIT       0x403
>  
>  /* SEV-ES software-defined VMGEXIT events */
> -#define SVM_VMGEXIT_MMIO_READ			0x80000001
> -#define SVM_VMGEXIT_MMIO_WRITE			0x80000002
> -#define SVM_VMGEXIT_NMI_COMPLETE		0x80000003
> -#define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
> -#define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
> +#define SVM_VMGEXIT_MMIO_READ			0x80000001ull
> +#define SVM_VMGEXIT_MMIO_WRITE			0x80000002ull
> +#define SVM_VMGEXIT_NMI_COMPLETE		0x80000003ull
> +#define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004ull
> +#define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005ull
>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
> -#define SVM_VMGEXIT_PSC				0x80000010
> -#define SVM_VMGEXIT_GUEST_REQUEST		0x80000011
> -#define SVM_VMGEXIT_EXT_GUEST_REQUEST		0x80000012
> -#define SVM_VMGEXIT_AP_CREATION			0x80000013
> +#define SVM_VMGEXIT_PSC				0x80000010ull
> +#define SVM_VMGEXIT_GUEST_REQUEST		0x80000011ull
> +#define SVM_VMGEXIT_EXT_GUEST_REQUEST		0x80000012ull
> +#define SVM_VMGEXIT_AP_CREATION			0x80000013ull
>  #define SVM_VMGEXIT_AP_CREATE_ON_INIT		0
>  #define SVM_VMGEXIT_AP_CREATE			1
>  #define SVM_VMGEXIT_AP_DESTROY			2
> -#define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
> -#define SVM_VMGEXIT_SAVIC			0x8000001a
> +#define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018ull
> +#define SVM_VMGEXIT_SAVIC			0x8000001aull
>  #define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
>  #define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
>  #define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
> -#define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
> -#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
> +#define SVM_VMGEXIT_HV_FEATURES			0x8000fffdull
> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffeull
>  #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
>  	/* SW_EXITINFO1[3:0] */					\
>  	(((((u64)reason_set) & 0xf)) |				\
>  	/* SW_EXITINFO1[11:4] */				\
>  	((((u64)reason_code) & 0xff) << 4))
> -#define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
> +#define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffffull
>  
>  /* Exit code reserved for hypervisor/software use */
> -#define SVM_EXIT_SW				0xf0000000
> +#define SVM_EXIT_SW				0xf0000000ull
>  
> -#define SVM_EXIT_ERR           -1
> +#define SVM_EXIT_ERR           -1ull
>  
>  #define SVM_EXIT_REASONS \
>  	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> index 088f6429b24c..3ec580d687f5 100644
> --- a/arch/x86/kvm/svm/hyperv.c
> +++ b/arch/x86/kvm/svm/hyperv.c
> @@ -11,7 +11,6 @@ void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
> -	svm->vmcb->control.exit_code_hi = 0;
>  	svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
>  	svm->vmcb->control.exit_info_2 = 0;
>  	nested_svm_vmexit(svm);
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8070e20ed5a7..89120245cd22 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -45,7 +45,6 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>  		 * correctly fill in the high bits of exit_info_1.
>  		 */
>  		vmcb->control.exit_code = SVM_EXIT_NPF;
> -		vmcb->control.exit_code_hi = 0;
>  		vmcb->control.exit_info_1 = (1ULL << 32);
>  		vmcb->control.exit_info_2 = fault->address;
>  	}
> @@ -421,7 +420,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->int_vector          = from->int_vector;
>  	to->int_state           = from->int_state;
>  	to->exit_code           = from->exit_code;
> -	to->exit_code_hi        = from->exit_code_hi;
>  	to->exit_info_1         = from->exit_info_1;
>  	to->exit_info_2         = from->exit_info_2;
>  	to->exit_int_info       = from->exit_int_info;
> @@ -727,8 +725,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	enter_guest_mode(vcpu);
>  
>  	/*
> -	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
> -	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
> +	 * Filled at exit: exit_code, exit_info_1, exit_info_2, exit_int_info,
> +	 * exit_int_info_err, next_rip, insn_len, insn_bytes.
>  	 */
>  
>  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VGIF) &&
> @@ -985,7 +983,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	if (!nested_vmcb_check_save(vcpu) ||
>  	    !nested_vmcb_check_controls(vcpu)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> -		vmcb12->control.exit_code_hi = -1u;
>  		vmcb12->control.exit_info_1  = 0;
>  		vmcb12->control.exit_info_2  = 0;
>  		goto out;
> @@ -1018,7 +1015,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	svm->soft_int_injected = false;
>  
>  	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> -	svm->vmcb->control.exit_code_hi = -1u;
>  	svm->vmcb->control.exit_info_1  = 0;
>  	svm->vmcb->control.exit_info_2  = 0;
>  
> @@ -1130,7 +1126,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	vmcb12->control.int_state         = vmcb02->control.int_state;
>  	vmcb12->control.exit_code         = vmcb02->control.exit_code;
> -	vmcb12->control.exit_code_hi      = vmcb02->control.exit_code_hi;
>  	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
>  	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
>  
> @@ -1422,7 +1417,7 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
>  
>  static int nested_svm_intercept(struct vcpu_svm *svm)
>  {
> -	u32 exit_code = svm->vmcb->control.exit_code;
> +	u64 exit_code = svm->vmcb->control.exit_code;
>  	int vmexit = NESTED_EXIT_HOST;
>  
>  	if (svm_is_vmrun_failure(exit_code))
> @@ -1494,7 +1489,6 @@ static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
>  	struct vmcb *vmcb = svm->vmcb;
>  
>  	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + ex->vector;
> -	vmcb->control.exit_code_hi = 0;
>  
>  	if (ex->has_error_code)
>  		vmcb->control.exit_info_1 = ex->error_code;
> @@ -1669,7 +1663,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>  	dst->int_vector           = from->int_vector;
>  	dst->int_state            = from->int_state;
>  	dst->exit_code            = from->exit_code;
> -	dst->exit_code_hi         = from->exit_code_hi;
>  	dst->exit_info_1          = from->exit_info_1;
>  	dst->exit_info_2          = from->exit_info_2;
>  	dst->exit_int_info        = from->exit_int_info;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0835c664fbfd..5aedd07194aa 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3264,11 +3264,6 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>  		kvfree(svm->sev_es.ghcb_sa);
>  }
>  
> -static u64 kvm_get_cached_sw_exit_code(struct vmcb_control_area *control)
> -{
> -	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
> -}
> -
>  static void dump_ghcb(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -3290,7 +3285,7 @@ static void dump_ghcb(struct vcpu_svm *svm)
>  	 */
>  	pr_err("GHCB (GPA=%016llx) snapshot:\n", svm->vmcb->control.ghcb_gpa);
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
> -	       kvm_get_cached_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
> +	       control->exit_code, kvm_ghcb_sw_exit_code_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
>  	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
> @@ -3324,7 +3319,6 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	struct ghcb *ghcb = svm->sev_es.ghcb;
> -	u64 exit_code;
>  
>  	/*
>  	 * The GHCB protocol so far allows for the following data
> @@ -3358,9 +3352,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(svm));
>  
>  	/* Copy the GHCB exit information into the VMCB fields */
> -	exit_code = kvm_ghcb_get_sw_exit_code(svm);
> -	control->exit_code = lower_32_bits(exit_code);
> -	control->exit_code_hi = upper_32_bits(exit_code);
> +	control->exit_code = kvm_ghcb_get_sw_exit_code(svm);
>  	control->exit_info_1 = kvm_ghcb_get_sw_exit_info_1(svm);
>  	control->exit_info_2 = kvm_ghcb_get_sw_exit_info_2(svm);
>  	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm);
> @@ -3373,15 +3365,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	u64 exit_code;
>  	u64 reason;
>  
> -	/*
> -	 * Retrieve the exit code now even though it may not be marked valid
> -	 * as it could help with debugging.
> -	 */
> -	exit_code = kvm_get_cached_sw_exit_code(control);
> -
>  	/* Only GHCB Usage code 0 is supported */
>  	if (svm->sev_es.ghcb->ghcb_usage) {
>  		reason = GHCB_ERR_INVALID_USAGE;
> @@ -3395,7 +3380,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	    !kvm_ghcb_sw_exit_info_2_is_valid(svm))
>  		goto vmgexit_err;
>  
> -	switch (exit_code) {
> +	switch (control->exit_code) {
>  	case SVM_EXIT_READ_DR7:
>  		break;
>  	case SVM_EXIT_WRITE_DR7:
> @@ -3496,15 +3481,19 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	return 0;
>  
>  vmgexit_err:
> +	/*
> +	 * Print the exit code even though it may not be marked valid as it
> +	 * could help with debugging.
> +	 */
>  	if (reason == GHCB_ERR_INVALID_USAGE) {
>  		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
>  			    svm->sev_es.ghcb->ghcb_usage);
>  	} else if (reason == GHCB_ERR_INVALID_EVENT) {
>  		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
> -			    exit_code);
> +			    control->exit_code);
>  	} else {
>  		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
> -			    exit_code);
> +			    control->exit_code);
>  		dump_ghcb(svm);
>  	}
>  
> @@ -4343,7 +4332,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> -	u64 ghcb_gpa, exit_code;
> +	u64 ghcb_gpa;
>  	int ret;
>  
>  	/* Validate the GHCB */
> @@ -4385,8 +4374,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  
>  	svm_vmgexit_success(svm, 0);
>  
> -	exit_code = kvm_get_cached_sw_exit_code(control);
> -	switch (exit_code) {
> +	switch (control->exit_code) {
>  	case SVM_VMGEXIT_MMIO_READ:
>  		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
>  		if (ret)
> @@ -4478,7 +4466,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		ret = -EINVAL;
>  		break;
>  	default:
> -		ret = svm_invoke_exit_handler(vcpu, exit_code);
> +		ret = svm_invoke_exit_handler(vcpu, control->exit_code);
>  	}
>  
>  	return ret;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3b05476296d0..85bc99f93275 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2433,7 +2433,6 @@ static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
>  
>  	if (cr0 ^ val) {
>  		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
> -		svm->vmcb->control.exit_code_hi = 0;
>  		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
>  	}
>  
> @@ -3265,7 +3264,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
>  	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
>  	pr_err("%-20s%08x\n", "int_state:", control->int_state);
> -	pr_err("%-20s%08x\n", "exit_code:", control->exit_code);
> +	pr_err("%-20s%016llx\n", "exit_code:", control->exit_code);
>  	pr_err("%-20s%016llx\n", "exit_info1:", control->exit_info_1);
>  	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
>  	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
> @@ -3515,7 +3514,6 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_run *kvm_run = vcpu->run;
> -	u32 exit_code = svm->vmcb->control.exit_code;
>  
>  	/* SEV-ES guests must use the CR write traps to track CR registers. */
>  	if (!sev_es_guest(vcpu->kvm)) {
> @@ -3551,7 +3549,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	if (exit_fastpath != EXIT_FASTPATH_NONE)
>  		return 1;
>  
> -	return svm_invoke_exit_handler(vcpu, exit_code);
> +	return svm_invoke_exit_handler(vcpu, svm->vmcb->control.exit_code);
>  }
>  
>  static int pre_svm_run(struct kvm_vcpu *vcpu)
> @@ -4618,7 +4616,6 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  	if (static_cpu_has(X86_FEATURE_NRIPS))
>  		vmcb->control.next_rip  = info->next_rip;
>  	vmcb->control.exit_code = icpt_info.exit_code;
> -	vmcb->control.exit_code_hi = 0;
>  	vmexit = nested_svm_exit_handled(svm);
>  
>  	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6b35925e3a33..31ee4f65dcc2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -162,8 +162,7 @@ struct vmcb_ctrl_area_cached {
>  	u32 int_ctl;
>  	u32 int_vector;
>  	u32 int_state;
> -	u32 exit_code;
> -	u32 exit_code_hi;
> +	u64 exit_code;
>  	u64 exit_info_1;
>  	u64 exit_info_2;
>  	u32 exit_int_info;
> @@ -769,7 +768,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm);
>  static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
>  {
>  	svm->vmcb->control.exit_code	= exit_code;
> -	svm->vmcb->control.exit_code_hi	= 0;
>  	svm->vmcb->control.exit_info_1	= 0;
>  	svm->vmcb->control.exit_info_2	= 0;
>  	return nested_svm_vmexit(svm);
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e79bc9cb7162..4c7a5cd10990 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -781,7 +781,7 @@ TRACE_EVENT_KVM_EXIT(kvm_nested_vmexit);
>   * Tracepoint for #VMEXIT reinjected to the guest
>   */
>  TRACE_EVENT(kvm_nested_vmexit_inject,
> -	    TP_PROTO(__u32 exit_code,
> +	    TP_PROTO(__u64 exit_code,
>  		     __u64 exit_info1, __u64 exit_info2,
>  		     __u32 exit_int_info, __u32 exit_int_info_err, __u32 isa),
>  	    TP_ARGS(exit_code, exit_info1, exit_info2,
> diff --git a/include/hyperv/hvgdk.h b/include/hyperv/hvgdk.h
> index dd6d4939ea29..56b695873a72 100644
> --- a/include/hyperv/hvgdk.h
> +++ b/include/hyperv/hvgdk.h
> @@ -281,7 +281,7 @@ struct hv_vmcb_enlightenments {
>  #define HV_VMCB_NESTED_ENLIGHTENMENTS		31
>  
>  /* Synthetic VM-Exit */
> -#define HV_SVM_EXITCODE_ENL			0xf0000000
> +#define HV_SVM_EXITCODE_ENL			0xf0000000u
>  #define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH	(1)
>  
>  /* VM_PARTITION_ASSIST_PAGE */
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

