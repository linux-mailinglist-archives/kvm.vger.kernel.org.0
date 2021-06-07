Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D6539DBEC
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFGMKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 08:10:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhFGMKF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 08:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623067693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QGLdO+kv/jW8ufpWMkRJSndfrnRcVbvYkVOClFgST8=;
        b=BwtmI726ZJ2e9n60rw6LcFgFfw4yT/KX9y2aaJvz2HHhHmMNzH8OnIcd5H83kmZ8/Cyurd
        yKYaUDv358FtWeXmuTjSKBGHPuoz+CiJKq0RVMxdD6b9zQ+lPWELr7PSQ+RyPTPVYkIS28
        Ys6kUBzgllZO3u6T2UkUosV+KH16DIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-VnwgPKSSNWOcqeBkRaLJpg-1; Mon, 07 Jun 2021 08:08:11 -0400
X-MC-Unique: VnwgPKSSNWOcqeBkRaLJpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 208601084854;
        Mon,  7 Jun 2021 12:07:54 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6A27756C8;
        Mon,  7 Jun 2021 12:07:50 +0000 (UTC)
Message-ID: <1f0697693e956b1a136209b874771efe96226365.camel@redhat.com>
Subject: Re: [PATCH v6 09/11] KVM: X86: Add vendor callbacks for writing the
 TSC multiplier
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 07 Jun 2021 15:07:49 +0300
In-Reply-To: <20210607105438.16541-1-ilstam@amazon.com>
References: <20210607105438.16541-1-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-07 at 11:54 +0100, Ilias Stamatis wrote:
> Currently vmx_vcpu_load_vmcs() writes the TSC_MULTIPLIER field of the
> VMCS every time the VMCS is loaded. Instead of doing this, set this
> field from common code on initialization and whenever the scaling ratio
> changes.
> 
> Additionally remove vmx->current_tsc_ratio. This field is redundant as
> vcpu->arch.tsc_scaling_ratio already tracks the current TSC scaling
> ratio. The vmx->current_tsc_ratio field is only used for avoiding
> unnecessary writes but it is no longer needed after removing the code
> from the VMCS load path.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
> 
> Just moved the kvm_set_tsc_khz() call further within kvm_arch_vcpu_create()
> (instead of kvm_arch_vcpu_postcreate() like in v5) as Sean suggested.

I just reviewed the V5. Oh well, I won't bother with any more nitpicks.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!
Best regards,
	Maxim Levitsky

> 
> https://lore.kernel.org/kvm/9caefa1ad707fdb61448234b37716f89643aca86.camel@amazon.com/T/
> 
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/svm/svm.c             |  6 ++++++
>  arch/x86/kvm/vmx/nested.c          |  9 ++++-----
>  arch/x86/kvm/vmx/vmx.c             | 11 ++++++-----
>  arch/x86/kvm/vmx/vmx.h             |  8 --------
>  arch/x86/kvm/x86.c                 | 30 +++++++++++++++++++++++-------
>  7 files changed, 41 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 029c9615378f..34ad7a17458a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -90,6 +90,7 @@ KVM_X86_OP_NULL(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
>  KVM_X86_OP(write_tsc_offset)
> +KVM_X86_OP(write_tsc_multiplier)
>  KVM_X86_OP(get_exit_info)
>  KVM_X86_OP(check_intercept)
>  KVM_X86_OP(handle_exit_irqoff)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f099277b993d..a334ce7741ab 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1308,6 +1308,7 @@ struct kvm_x86_ops {
>  	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
>  	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
>  	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
> +	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
>  
>  	/*
>  	 * Retrieve somewhat arbitrary exit information.  Intended to be used
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8dfb2513b72a..cb701b42b08b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1103,6 +1103,11 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
>  }
>  
> +static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
> +{
> +	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
> +}
> +
>  /* Evaluate instruction intercepts that depend on guest CPUID features. */
>  static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
>  					      struct vcpu_svm *svm)
> @@ -4528,6 +4533,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
>  	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
>  	.write_tsc_offset = svm_write_tsc_offset,
> +	.write_tsc_multiplier = svm_write_tsc_multiplier,
>  
>  	.load_mmu_pgd = svm_load_mmu_pgd,
> 

>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6058a65a6ede..239154d3e4e7 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2533,9 +2533,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	}
>  
>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> -
>  	if (kvm_has_tsc_control)
> -		decache_tsc_multiplier(vmx);
> +		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
>  
>  	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
>  
> @@ -4501,12 +4500,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> +	if (kvm_has_tsc_control)
> +		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
> +
>  	if (vmx->nested.l1_tpr_threshold != -1)
>  		vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);
>  
> -	if (kvm_has_tsc_control)
> -		decache_tsc_multiplier(vmx);
> -
>  	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
>  		vmx->nested.change_vmcs01_virtual_apic_mode = false;
>  		vmx_set_virtual_apic_mode(vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4b70431c2edd..bf845a08995e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1390,11 +1390,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>  
>  		vmx->loaded_vmcs->cpu = cpu;
>  	}
> -
> -	/* Setup TSC multiplier */
> -	if (kvm_has_tsc_control &&
> -	    vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
> -		decache_tsc_multiplier(vmx);
>  }
>  
>  /*
> @@ -1813,6 +1808,11 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  	vmcs_write64(TSC_OFFSET, offset);
>  }
>  
> +static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
> +{
> +	vmcs_write64(TSC_MULTIPLIER, multiplier);
> +}
> +
>  /*
>   * nested_vmx_allowed() checks whether a guest should be allowed to use VMX
>   * instructions and MSRs (i.e., nested VMX). Nested VMX is disabled for
> @@ -7707,6 +7707,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
>  	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
>  	.write_tsc_offset = vmx_write_tsc_offset,
> +	.write_tsc_multiplier = vmx_write_tsc_multiplier,
>  
>  	.load_mmu_pgd = vmx_load_mmu_pgd,
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index aa97c82e3451..3eaa86a0ba3e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -322,8 +322,6 @@ struct vcpu_vmx {
>  	/* apic deadline value in host tsc */
>  	u64 hv_deadline_tsc;
>  
> -	u64 current_tsc_ratio;
> -
>  	unsigned long host_debugctlmsr;
>  
>  	/*
> @@ -532,12 +530,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
>  			      GFP_KERNEL_ACCOUNT);
>  }
>  
> -static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
> -{
> -	vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
> -	vmcs_write64(TSC_MULTIPLIER, vmx->current_tsc_ratio);
> -}
> -
>  static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
>  {
>  	return vmx->secondary_exec_control &
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 801fa1e8e915..b56afc2f6724 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2179,14 +2179,15 @@ static u32 adjust_tsc_khz(u32 khz, s32 ppm)
>  	return v;
>  }
>  
> +static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier);
> +
>  static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  {
>  	u64 ratio;
>  
>  	/* Guest TSC same frequency as host TSC? */
>  	if (!scale) {
> -		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> -		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> +		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
>  		return 0;
>  	}
>  
> @@ -2212,7 +2213,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  		return -1;
>  	}
>  
> -	vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
> +	kvm_vcpu_write_tsc_multiplier(vcpu, ratio);
>  	return 0;
>  }
>  
> @@ -2224,8 +2225,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
>  	/* tsc_khz can be zero if TSC calibration fails */
>  	if (user_tsc_khz == 0) {
>  		/* set tsc_scaling_ratio to a safe value */
> -		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> -		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
> +		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
>  		return -1;
>  	}
>  
> @@ -2383,6 +2383,23 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
>  	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
>  }
>  
> +static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
> +{
> +	vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
> +
> +	/* Userspace is changing the multiplier while L2 is active */
> +	if (is_guest_mode(vcpu))
> +		vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
> +			l1_multiplier,
> +			static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu));
> +	else
> +		vcpu->arch.tsc_scaling_ratio = l1_multiplier;
> +
> +	if (kvm_has_tsc_control)
> +		static_call(kvm_x86_write_tsc_multiplier)(
> +			vcpu, vcpu->arch.tsc_scaling_ratio);
> +}
> +
>  static inline bool kvm_check_tsc_unstable(void)
>  {
>  #ifdef CONFIG_X86_64
> @@ -10343,8 +10360,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	else
>  		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
>  
> -	kvm_set_tsc_khz(vcpu, max_tsc_khz);
> -
>  	r = kvm_mmu_create(vcpu);
>  	if (r < 0)
>  		return r;
> @@ -10412,6 +10427,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>  	kvm_vcpu_mtrr_init(vcpu);
>  	vcpu_load(vcpu);
> +	kvm_set_tsc_khz(vcpu, max_tsc_khz);
>  	kvm_vcpu_reset(vcpu, false);
>  	kvm_init_mmu(vcpu, false);
>  	vcpu_put(vcpu);


