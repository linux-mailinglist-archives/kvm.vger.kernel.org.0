Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DDD2F609C
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbhANL53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:57:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbhANL52 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 06:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610625360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HuSkgGk92m7vvq3yaj6Z7qRk9idenQoli+8X8G00Pw=;
        b=AeNfKL4PnTAPfAFeZUsm3EqiADLhhcXF70GID7RzXuognjSdjh3hK+nOLiBBJ7S5C3Ze2M
        owKs9b+91KTAd1393axmlCflL5o3mcZfejGOmHOi2jm84oBidKj+5HQTs7rSOLeLe0dBY0
        XZjPZOALCtxuxvTc8uJ/mb8WbB6MFQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-kve9aYs-PsmuOhfhRO8m3Q-1; Thu, 14 Jan 2021 06:55:56 -0500
X-MC-Unique: kve9aYs-PsmuOhfhRO8m3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 302D815720;
        Thu, 14 Jan 2021 11:55:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1839560657;
        Thu, 14 Jan 2021 11:55:46 +0000 (UTC)
Message-ID: <8ada613c5c9c5e407e3a2cb3f9e9ab09e8c1de95.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered
 by VM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com
Date:   Thu, 14 Jan 2021 13:55:45 +0200
In-Reply-To: <20210112063703.539893-1-wei.huang2@amd.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-12 at 00:37 -0600, Wei Huang wrote:
> From: Bandan Das <bsd@redhat.com>
> 
> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> before checking VMCB's instruction intercept. If EAX falls into such
> memory areas, #GP is triggered before VMEXIT. This causes problem under
> nested virtualization. To solve this problem, KVM needs to trap #GP and
> check the instructions triggering #GP. For VM execution instructions,
> KVM emulates these instructions; otherwise it re-injects #GP back to
> guest VMs.
> 
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Co-developed-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   8 +-
>  arch/x86/kvm/mmu.h              |   1 +
>  arch/x86/kvm/mmu/mmu.c          |   7 ++
>  arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
>  arch/x86/kvm/svm/svm.h          |   8 ++
>  arch/x86/kvm/vmx/vmx.c          |   2 +-
>  arch/x86/kvm/x86.c              |  37 +++++++-
>  7 files changed, 146 insertions(+), 74 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3d6616f6f6ef..0ddc309f5a14 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
>   *			     due to an intercepted #UD (see EMULTYPE_TRAP_UD).
>   *			     Used to test the full emulator from userspace.
>   *
> - * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware
> + * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VMware
I would prefer to see this change in a separate patch.


>   *			backdoor emulation, which is opt in via module param.
>   *			VMware backoor emulation handles select instructions
> - *			and reinjects the #GP for all other cases.
> + *			and reinjects #GP for all other cases. This also
> + *			handles other cases where #GP condition needs to be
> + *			handled and emulated appropriately
>   *
>   * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
>   *		 case the CR2/GPA value pass on the stack is valid.
> @@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
>  #define EMULTYPE_SKIP		    (1 << 2)
>  #define EMULTYPE_ALLOW_RETRY_PF	    (1 << 3)
>  #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
> -#define EMULTYPE_VMWARE_GP	    (1 << 5)
> +#define EMULTYPE_PARAVIRT_GP	    (1 << 5)
>  #define EMULTYPE_PF		    (1 << 6)
>  
>  int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 581925e476d6..1a2fff4e7140 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>  
>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> +bool kvm_is_host_reserved_region(u64 gpa);
>  
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481aa29d..c5c4aaf01a1a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -50,6 +50,7 @@
>  #include <asm/io.h>
>  #include <asm/vmx.h>
>  #include <asm/kvm_page_track.h>
> +#include <asm/e820/api.h>
>  #include "trace.h"
>  
>  extern bool itlb_multihit_kvm_mitigation;
> @@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>  
> +bool kvm_is_host_reserved_region(u64 gpa)
> +{
> +	return e820__mapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
> +}
> +EXPORT_SYMBOL_GPL(kvm_is_host_reserved_region);
> +
>  void kvm_mmu_zap_all(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef171790d02..74620d32aa82 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -288,6 +288,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  		if (!(efer & EFER_SVME)) {
>  			svm_leave_nested(svm);
>  			svm_set_gif(svm, true);
> +			clr_exception_intercept(svm, GP_VECTOR);
Wouldn't that be wrong if we intercept #GP due to the vmware backdoor?

I would add a flag that will be true when the workaround for the errata is enabled,
and use it together with flag that enables vmware backdoor for decisions
such as the above.

The flag can even be a module param to allow users to disable it if they
really want to.

>  
>  			/*
>  			 * Free the nested guest state, unless we are in SMM.
> @@ -309,6 +310,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> +	/* Enable GP interception for SVM instructions if needed */
> +	if (efer & EFER_SVME)
> +		set_exception_intercept(svm, GP_VECTOR);
> +
>  	return 0;
>  }
>  
> @@ -1957,22 +1962,104 @@ static int ac_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int vmload_interception(struct vcpu_svm *svm)
> +{
> +	struct vmcb *nested_vmcb;
> +	struct kvm_host_map map;
> +	int ret;
> +
> +	if (nested_svm_check_permissions(svm))
> +		return 1;
> +
> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> +	if (ret) {
> +		if (ret == -EINVAL)
> +			kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	}
> +
> +	nested_vmcb = map.hva;
> +
> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> +
> +	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
> +	return ret;
> +}
> +
> +static int vmsave_interception(struct vcpu_svm *svm)
> +{
> +	struct vmcb *nested_vmcb;
> +	struct kvm_host_map map;
> +	int ret;
> +
> +	if (nested_svm_check_permissions(svm))
> +		return 1;
> +
> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> +	if (ret) {
> +		if (ret == -EINVAL)
> +			kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	}
> +
> +	nested_vmcb = map.hva;
> +
> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> +
> +	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
> +	return ret;
> +}
> +
> +static int vmrun_interception(struct vcpu_svm *svm)
> +{
> +	if (nested_svm_check_permissions(svm))
> +		return 1;
> +
> +	return nested_svm_vmrun(svm);
> +}

I would prefer the move of these functions (I didn't check
if you changed them as well) to be done in a separate patch.

> +
> +/* Emulate SVM VM execution instructions */
> +static int svm_emulate_vm_instr(struct kvm_vcpu *vcpu, u8 modrm)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	switch (modrm) {
> +	case 0xd8: /* VMRUN */
> +		return vmrun_interception(svm);
> +	case 0xda: /* VMLOAD */
> +		return vmload_interception(svm);
> +	case 0xdb: /* VMSAVE */
> +		return vmsave_interception(svm);
> +	default:
> +		/* inject a #GP for all other cases */
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return 1;
> +	}
> +}
> +
>  static int gp_interception(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	u32 error_code = svm->vmcb->control.exit_info_1;
> -
> -	WARN_ON_ONCE(!enable_vmware_backdoor);
The warning could be kept with extended condition.

> +	int rc;
>  
>  	/*
> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> +	 * Only VMware backdoor and SVM VME errata are handled. Neither of
> +	 * them has non-zero error codes.
Could be great to mention (once published) the link to the errata
here or somewhere so readers understand what it is all about.

>  	 */
>  	if (error_code) {
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  		return 1;
>  	}
> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> +
> +	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
> +	if (rc > 1)
> +		rc = svm_emulate_vm_instr(vcpu, rc);
> +	return rc;
As others mentioned in the review, I also would try to use something
else that passing the mod/reg/rm byte in the return value.
Otherwise it will backfire sooner or later.


>  }
>  
>  static bool is_erratum_383(void)
> @@ -2113,66 +2200,6 @@ static int vmmcall_interception(struct vcpu_svm *svm)
>  	return kvm_emulate_hypercall(&svm->vcpu);
>  }
>  
> -static int vmload_interception(struct vcpu_svm *svm)
> -{
> -	struct vmcb *nested_vmcb;
> -	struct kvm_host_map map;
> -	int ret;
> -
> -	if (nested_svm_check_permissions(svm))
> -		return 1;
> -
> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> -	if (ret) {
> -		if (ret == -EINVAL)
> -			kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	}
> -
> -	nested_vmcb = map.hva;
> -
> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> -
> -	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -	return ret;
> -}
> -
> -static int vmsave_interception(struct vcpu_svm *svm)
> -{
> -	struct vmcb *nested_vmcb;
> -	struct kvm_host_map map;
> -	int ret;
> -
> -	if (nested_svm_check_permissions(svm))
> -		return 1;
> -
> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> -	if (ret) {
> -		if (ret == -EINVAL)
> -			kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	}
> -
> -	nested_vmcb = map.hva;
> -
> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> -
> -	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -	return ret;
> -}
> -
> -static int vmrun_interception(struct vcpu_svm *svm)
> -{
> -	if (nested_svm_check_permissions(svm))
> -		return 1;
> -
> -	return nested_svm_vmrun(svm);
> -}
> -
>  void svm_set_gif(struct vcpu_svm *svm, bool value)
>  {
>  	if (value) {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..d5dffcf59afa 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -350,6 +350,14 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
>  	recalc_intercepts(svm);
>  }
>  
> +static inline bool is_exception_intercept(struct vcpu_svm *svm, u32 bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	WARN_ON_ONCE(bit >= 32);
> +	return vmcb_is_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
> +}
This function doesn't seem to be used anywhere.

> +
>  static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
>  {
>  	struct vmcb *vmcb = get_host_vmcb(svm);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2af05d3b0590..5fac2f7cba24 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4774,7 +4774,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  			return 1;
>  		}
> -		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> +		return kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
>  	}
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a6dd06..c3662fc3b1bc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7014,7 +7014,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
> -	if (emulation_type & EMULTYPE_VMWARE_GP) {
> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>  		return 1;
>  	}
> @@ -7267,6 +7267,28 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>  	return false;
>  }
>  
> +static int is_vm_instr_opcode(struct x86_emulate_ctxt *ctxt)
> +{
> +	unsigned long rax;
> +
> +	if (ctxt->b != 0x1)
> +		return 0;
Don't you also want to check that 'ctxt->opcode_len == 2'?
Prefixes? AMD's PRM doesn't mention if these are allowed/ignored/etc.

I guess they are ignored but this should be double checked vs real hardware.

> +
> +	switch (ctxt->modrm) {
> +	case 0xd8: /* VMRUN */
> +	case 0xda: /* VMLOAD */
> +	case 0xdb: /* VMSAVE */
> +		rax = kvm_register_read(emul_to_vcpu(ctxt), VCPU_REGS_RAX);
> +		if (!kvm_is_host_reserved_region(rax))
> +			return 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return ctxt->modrm;
> +}
> +
>  static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
>  {
>  	switch (ctxt->opcode_len) {
> @@ -7305,6 +7327,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	bool writeback = true;
>  	bool write_fault_to_spt;
> +	int vminstr;
>  
>  	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, insn, insn_len)))
>  		return 1;
> @@ -7367,10 +7390,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		}
>  	}
>  
> -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> -	    !is_vmware_backdoor_opcode(ctxt)) {
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -		return 1;
> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
> +		vminstr = is_vm_instr_opcode(ctxt);

As I said above, I would add some flag if workaround for the errata is used,
and use it here.

> +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +			return 1;
> +		}
> +		if (vminstr)
> +			return vminstr;
>  	}
>  
>  	/*

Best regards,
	Maxim Levitsky

