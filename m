Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F171A47E3
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDJPfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 11:35:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:54397 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgDJPfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 11:35:39 -0400
IronPort-SDR: wNCj1aBuv82jBABk6SduVyGxaclEuovYgNezRJk/3gKbpiBZAVd09UVDji56/Rrb6elFtdSbrT
 ZAj9BVi5GXEA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 08:35:39 -0700
IronPort-SDR: 0qzb4equE8alWcIEYcRDAw7+hsh0diCKuAveWpvUzI5ER2F+uodgLsjmVyarxAR0pnBOZ0BneQ
 LBsRsmROXsZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="240969201"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 10 Apr 2020 08:35:39 -0700
Date:   Fri, 10 Apr 2020 08:35:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
Message-ID: <20200410153539.GD22482@linux.intel.com>
References: <1586480607-5408-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586480607-5408-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 09:03:27AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> IPI and Timer cause the main MSRs write vmexits in cloud environment 
> observation, let's optimize virtual IPI latency more aggressively to 
> inject target IPI as soon as possible.
> 
> Running kvm-unit-tests/vmexit.flat IPI testing on SKX server, disable 
> adaptive advance lapic timer and adaptive halt-polling to avoid the 
> interference, this patch can give another 7% improvement.
> 
> w/o fastpath -> fastpath            4238 -> 3543  16.4%
> fastpath     -> ultra fastpath      3543 -> 3293     7%
> w/o fastpath -> ultra fastpath      4238 -> 3293  22.3% 
> 
> This also revises the performance data in commit 1e9e2622a1 (KVM: VMX: 
> FIXED+PHYSICAL mode single target IPI fastpath), that testing adds
> --overcommit cpu-pm=on to kvm-unit-tests guest which is unnecessary.
> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * rebase on latest kvm/queue
>  * update patch description
> 
>  arch/x86/include/asm/kvm_host.h |  6 +++---
>  arch/x86/kvm/svm/svm.c          | 21 ++++++++++++++-------
>  arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++------
>  arch/x86/kvm/x86.c              |  4 ++--
>  4 files changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c7da23a..e667cf3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1124,7 +1124,8 @@ struct kvm_x86_ops {
>  	 */
>  	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
>  
> -	void (*run)(struct kvm_vcpu *vcpu);
> +	void (*run)(struct kvm_vcpu *vcpu,
> +		enum exit_fastpath_completion *exit_fastpath);
>  	int (*handle_exit)(struct kvm_vcpu *vcpu,
>  		enum exit_fastpath_completion exit_fastpath);
>  	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> @@ -1174,8 +1175,7 @@ struct kvm_x86_ops {
>  			       struct x86_instruction_info *info,
>  			       enum x86_intercept_stage stage,
>  			       struct x86_exception *exception);
> -	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
> -		enum exit_fastpath_completion *exit_fastpath);
> +	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
>  
>  	int (*check_nested_events)(struct kvm_vcpu *vcpu);
>  	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 27f4684..c019332 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3283,9 +3283,20 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  	svm_complete_interrupts(svm);
>  }
>  
> +static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
> +{
> +	if (!is_guest_mode(vcpu) &&
> +	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
> +	    to_svm(vcpu)->vmcb->control.exit_info_1)
> +		return handle_fastpath_set_msr_irqoff(vcpu);
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>  
> -static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> +static void svm_vcpu_run(struct kvm_vcpu *vcpu,
> +	enum exit_fastpath_completion *exit_fastpath)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -3388,6 +3399,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	kvm_load_host_xsave_state(vcpu);
>  	stgi();
>  
> +	*exit_fastpath = svm_exit_handlers_fastpath(vcpu);
>  	/* Any pending NMI will happen here */
>  
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
> @@ -3719,13 +3731,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> -	enum exit_fastpath_completion *exit_fastpath)
> +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
> -	if (!is_guest_mode(vcpu) &&
> -	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
> -	    to_svm(vcpu)->vmcb->control.exit_info_1)
> -		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>  }
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1d2bb57..61a1725 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6354,8 +6354,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  }
>  STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>  
> -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> -	enum exit_fastpath_completion *exit_fastpath)
> +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> @@ -6363,9 +6362,6 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
>  		handle_external_interrupt_irqoff(vcpu);
>  	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
>  		handle_exception_nmi_irqoff(vmx);
> -	else if (!is_guest_mode(vcpu) &&
> -		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> -		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>  }
>  
>  static bool vmx_has_emulated_msr(int index)
> @@ -6570,9 +6566,19 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  	}
>  }
>  
> +static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
> +{
> +	if (!is_guest_mode(vcpu) &&
> +		to_vmx(vcpu)->exit_reason == EXIT_REASON_MSR_WRITE)

Bad indentation.

> +		return handle_fastpath_set_msr_irqoff(vcpu);
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>  
> -static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> +static void vmx_vcpu_run(struct kvm_vcpu *vcpu,
> +	enum exit_fastpath_completion *exit_fastpath)

Why pass a pointer instead of returning the enum?

>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long cr3, cr4;
> @@ -6737,6 +6743,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	vmx->idt_vectoring_info = 0;
>  
>  	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
> +	*exit_fastpath = vmx_exit_handlers_fastpath(vcpu);

IMO, this should come at the very end of vmx_vcpu_run().  At a minimum, it
needs to be moved below the #MC handling and below

	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
		return;

KVM more or less assumes vmx->idt_vectoring_info is always valid, and it's
not obvious that a generic fastpath call can safely run before
vmx_complete_interrupts(), e.g. the kvm_clear_interrupt_queue() call.

In a normal scenario, the added latency is <50 cycles.  ~30 for the VMREAD
of IDT_VECTORING_INFO_FIELD, a handful of zeroing instructions, and a few
CMP+Jcc style uops to skip NMI blocking and interrupt completion.

And if the result is returned, it means VMX won't need a local variable, e.g.:

	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
		kvm_machine_check();

	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
		return EXIT_FASTPATH_NONE;

	vmx->loaded_vmcs->launched = 1;
	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);

	vmx_recover_nmi_blocking(vmx);
	vmx_complete_interrupts(vmx);

	return vmx_exit_handlers_fastpath(vcpu);
}

>  	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
>  		kvm_machine_check();
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3089aa4..eed31e2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8409,7 +8409,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
>  	}
>  
> -	kvm_x86_ops.run(vcpu);
> +	kvm_x86_ops.run(vcpu, &exit_fastpath);

Pretty sre 
>  
>  	/*
>  	 * Do this here before restoring debug registers on the host.  And
> @@ -8441,7 +8441,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	vcpu->mode = OUTSIDE_GUEST_MODE;
>  	smp_wmb();
>  
> -	kvm_x86_ops.handle_exit_irqoff(vcpu, &exit_fastpath);
> +	kvm_x86_ops.handle_exit_irqoff(vcpu);
>  
>  	/*
>  	 * Consume any pending interrupts, including the possible source of
> -- 
> 2.7.4
> 
