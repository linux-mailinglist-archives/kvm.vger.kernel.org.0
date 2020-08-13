Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFAA243DF1
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 19:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHMRDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 13:03:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:37565 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgHMRDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 13:03:35 -0400
IronPort-SDR: qZ/dgxqC7E3TXZRvcN2t54m10xI00cr0xmxkVann7RWcWIZHm0ugyZuiesoGK+sAygRF7Q7/HP
 oPjGVw25XArA==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="141901830"
X-IronPort-AV: E=Sophos;i="5.76,309,1592895600"; 
   d="scan'208";a="141901830"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 10:03:33 -0700
IronPort-SDR: uuZN4DkiROVmRIt5Q3fZkQZgpNsXfGJ8IazaePqCu6bKOHBgYXecq+RoHrn5ib1ZeMJzDCIBQC
 ryQcIf4nXFZA==
X-IronPort-AV: E=Sophos;i="5.76,309,1592895600"; 
   d="scan'208";a="470288986"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 10:03:33 -0700
Date:   Thu, 13 Aug 2020 10:03:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
Message-ID: <20200813170331.GI29439@linux.intel.com>
References: <20200616224305.44242-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616224305.44242-1-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 10:43:05PM +0000, Oliver Upton wrote:
> It is possible for the instruction emulator to decode a different
> instruction from what was implied by the VM-exit information provided by
> hardware in vmcs02. Such is the case when the TLB entry for the guest's
> IP is out of sync with the appropriate page-table mapping if page
> installation isn't followed with a TLB flush.
> 
> Currently, KVM refuses to emulate in these scenarios, instead injecting
> a #UD into L2. While this does address the security risk of
> CVE-2020-2732, it could result in spurious #UDs to the L2 guest. Fix
> this by instead flushing the TLB then resuming L2, allowing hardware to
> generate the appropriate VM-exit to be reflected into L1.
> 
> Exceptional handling is also required for RSM and RDTSCP instructions.
> RDTSCP could be emulated on hardware which doesn't support it,
> therefore hardware will not generate a RDTSCP VM-exit on L2 resume. The
> dual-monitor treatment of SMM is not supported in nVMX, which implies
> that L0 should never handle a RSM instruction. Resuming the guest will
> only result in another #UD. Avoid getting stuck in a loop with these
> instructions by injecting a #UD for RSM and the appropriate VM-exit for
> RDTSCP.
> 
> Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/emulate.c     |  2 ++
>  arch/x86/kvm/kvm_emulate.h |  1 +
>  arch/x86/kvm/vmx/vmx.c     | 68 ++++++++++++++++++++++++++++----------
>  arch/x86/kvm/x86.c         |  2 +-
>  4 files changed, 55 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0e2825ae617..6e56e7a29ba1 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5812,6 +5812,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  	}
>  	if (rc == X86EMUL_INTERCEPTED)
>  		return EMULATION_INTERCEPTED;
> +	if (rc == X86EMUL_RETRY_INSTR)
> +		return EMULATION_RETRY_INSTR;
>  
>  	if (rc == X86EMUL_CONTINUE)
>  		writeback_registers(ctxt);
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 43c93ffa76ed..5bfab8d65cd1 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -496,6 +496,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
>  #define EMULATION_OK 0
>  #define EMULATION_RESTART 1
>  #define EMULATION_INTERCEPTED 2
> +#define EMULATION_RETRY_INSTR 3
>  void init_decode_cache(struct x86_emulate_ctxt *ctxt);
>  int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
>  int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 08e26a9518c2..ebfafd7837ba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7329,12 +7329,11 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
>  	to_vmx(vcpu)->req_immediate_exit = true;
>  }
>  
> -static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> -				  struct x86_instruction_info *info)
> +static bool vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> +				   struct x86_instruction_info *info)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	unsigned short port;
> -	bool intercept;
>  	int size;
>  
>  	if (info->intercept == x86_intercept_in ||
> @@ -7354,13 +7353,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
>  	 * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
>  	 */
>  	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
> -		intercept = nested_cpu_has(vmcs12,
> -					   CPU_BASED_UNCOND_IO_EXITING);
> -	else
> -		intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
> +		return nested_cpu_has(vmcs12,
> +				      CPU_BASED_UNCOND_IO_EXITING);
>  
> -	/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> -	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
> +	return nested_vmx_check_io_bitmaps(vcpu, port, size);

It might be a slightly bigger patch, but I think it'll be cleaner code in the
end if this section is reordered to:

        /*
         * If the 'use IO bitmaps' VM-execution control is 1, IO instruction
         * VM-exits are controlled by the IO bitmaps, otherwise they depend
         * on the 'unconditional IO exiting' VM-execution control.
         */
        if (nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
                return nested_vmx_check_io_bitmaps(vcpu, port, size);

        return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);

>  }
>  
>  static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> @@ -7369,6 +7365,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>  			       struct x86_exception *exception)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	bool intercepted;
>  
>  	switch (info->intercept) {
>  	/*
> @@ -7381,13 +7378,27 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>  			exception->error_code_valid = false;
>  			return X86EMUL_PROPAGATE_FAULT;
>  		}
> +
> +		intercepted = nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING);
> +
> +		/*
> +		 * RDTSCP could be emulated on a CPU which doesn't support it.
> +		 * As such, flushing the TLB and resuming L2 will result in
> +		 * another #UD rather than a VM-exit to reflect into L1.
> +		 * Instead, synthesize the VM-exit here.
> +		 */
> +		if (intercepted) {
> +			nested_vmx_vmexit(vcpu, EXIT_REASON_RDTSCP, 0, 0);
> +			return X86EMUL_INTERCEPTED;
> +		}

Maybe this instead?

                if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
                        exception->vector = UD_VECTOR;
                        exception->error_code_valid = false;
                        return X86EMUL_PROPAGATE_FAULT;
                } else if (nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING)) {
                        /*
                         * RDTSCP could be emulated on a CPU which doesn't
                         * support it.  As such, flushing the TLB and resuming
                         * L2 will result in another #UD rather than a VM-exit
                         * to reflect into L1.  Instead, synthesize the VM-exit
                         * here.
                         */
                        nested_vmx_vmexit(vcpu, EXIT_REASON_RDTSCP, 0, 0);
                        return X86EMUL_INTERCEPTED;
                }
                intercepted = false;


>  		break;
>  
>  	case x86_intercept_in:
>  	case x86_intercept_ins:
>  	case x86_intercept_out:
>  	case x86_intercept_outs:
> -		return vmx_check_intercept_io(vcpu, info);
> +		intercepted = vmx_check_intercept_io(vcpu, info);
> +		break;
>  
>  	case x86_intercept_lgdt:
>  	case x86_intercept_lidt:
> @@ -7397,18 +7408,41 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>  	case x86_intercept_sidt:
>  	case x86_intercept_sldt:
>  	case x86_intercept_str:
> -		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
> -			return X86EMUL_CONTINUE;
> -
> -		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> +		intercepted = nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC);
>  		break;
>  
> -	/* TODO: check more intercepts... */
> +	/*
> +	 * The dual-monitor treatment of SMM is not supported in nVMX. As such,
> +	 * L0 will never handle the RSM instruction nor should it retry
> +	 * instruction execution. Instead, a #UD should be injected into the
> +	 * guest for the execution of RSM outside of SMM.
> +	 */
> +	case x86_intercept_rsm:
> +		exception->vector = UD_VECTOR;
> +		exception->error_code_valid = false;
> +		return X86EMUL_PROPAGATE_FAULT;

Why does RSM need special treatment?  Won't it just naturally #UD if we fall
through to the flush-and-retry path?

>  	default:
> -		break;
> +		intercepted = true;
>  	}
>  
> -	return X86EMUL_UNHANDLEABLE;
> +	if (!intercepted)
> +		return X86EMUL_CONTINUE;
> +
> +	/*
> +	 * The only uses of the emulator in VMX for instructions which may be
> +	 * intercepted are port IO instructions, descriptor-table accesses, and
> +	 * the RDTSCP instruction. As such, if the emulator has decoded an

I wouldn't list out the individual cases, it's pretty obvious what can be
emulated by looking at the above code, and inevitably something will be added
that requires updating this comment.

> +	 * instruction that is different from the VM-exit provided by hardware
> +	 * it is likely that the TLB entry and page-table mapping for the

Probaby better to avoid talking about "page-table mapping", because it's not
clear which page tables are being referenced. 

> +	 * guest's RIP are out of sync.

Maybe something like:

	/*
	 * There are very few instructions that KVM will emulate for L2 and can
	 * also be intercepted by l1.  If the emulator decoded an instruction
	 * that is different from the VM-exit provided by hardware, the TLB
	 * entry for guest's RIP is likely stale.  Rather than synthesizing a
	 * VM-exit into L1 for every possible instruction, just flush the TLB,
	 * resume L2, and let hardware generate the appropriate VM-exit.
	 */

> +	 *
> +	 * Rather than synthesizing a VM-exit into L1 for every possible
> +	 * instruction just flush the TLB, resume L2, and let hardware generate
> +	 * the appropriate VM-exit.
> +	 */
> +	vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));

This is wrong, it should flush kvm_get_linear_rip(vcpu).
 
> +	return X86EMUL_RETRY_INSTR;
>  }
>  
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..2ab47485100f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6967,7 +6967,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  	r = x86_emulate_insn(ctxt);
>  
> -	if (r == EMULATION_INTERCEPTED)
> +	if (r == EMULATION_INTERCEPTED || r == EMULATION_RETRY_INSTR)
>  		return 1;
>  
>  	if (r == EMULATION_FAILED) {
> -- 
> 2.27.0.290.gba653c62da-goog
> 
