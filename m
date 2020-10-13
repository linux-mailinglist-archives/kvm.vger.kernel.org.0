Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927CF28D120
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389271AbgJMPTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 11:19:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:18332 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgJMPTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 11:19:23 -0400
IronPort-SDR: /gLuTYnlYlXaab2Ep5CFRwEKgWN3pWiW5PaAeycjr2mD8i9Kx985Bjsh2I6HXe6MCrtKVUvsCR
 P3Ue31MuGkOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="153758526"
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="153758526"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 08:19:23 -0700
IronPort-SDR: 68v83ePltu6fCpHLnKAtzuDojhuDtqYXFse292zQmKpbBF38Vlbmz6OE1xgG7XI4zstI/qfXnz
 jtIQsHXe39vA==
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="463524379"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 08:19:22 -0700
Date:   Tue, 13 Oct 2020 08:19:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM/nVMX: Move nested_vmx_check_vmentry_hw inline
 assembly to vmenter.S
Message-ID: <20201013150921.GB13936@linux.intel.com>
References: <20201007144312.55203-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007144312.55203-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 04:43:12PM +0200, Uros Bizjak wrote:
> Move the big inline assembly block from nested_vmx_check_vmentry_hw
> to vmenter.S assembly file, taking into account all ABI requirements.
> 
> The new function is modelled after __vmx_vcpu_run, and also calls
> vmx_update_host_rsp instead of open-coding the function in assembly.

Is there specific motivation for this change?  The inline asm is ugly, but
it's contained.

If we really want to get rid of the inline asm, I'd probably vote to simply
use __vmx_vcpu_run() instead of adding another assembly helper.  The (double)
GPR save/restore is wasteful, but this flow is basically anti-performance
anyways.  Outside of KVM developers, I doubt anyone actually enables this path.

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/nested.c  | 32 +++-----------------------------
>  arch/x86/kvm/vmx/vmenter.S | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 1bb6b31eb646..7b26e983e31c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3012,6 +3012,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +bool __nested_vmx_check_vmentry_hw(struct vcpu_vmx *vmx, bool launched);
> +
>  static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3050,35 +3052,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  		vmx->loaded_vmcs->host_state.cr4 = cr4;
>  	}
>  
> -	asm(
> -		"sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
> -		"cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
> -		"je 1f \n\t"
> -		__ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
> -		"mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
> -		"1: \n\t"
> -		"add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
> -
> -		/* Check if vmlaunch or vmresume is needed */
> -		"cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
> -
> -		/*
> -		 * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
> -		 * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
> -		 * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
> -		 * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
> -		 */
> -		"call vmx_vmenter\n\t"
> -
> -		CC_SET(be)
> -	      : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
> -	      :	[HOST_RSP]"r"((unsigned long)HOST_RSP),
> -		[loaded_vmcs]"r"(vmx->loaded_vmcs),
> -		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
> -		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
> -		[wordsize]"i"(sizeof(ulong))
> -	      : "memory"
> -	);
> +	vm_fail = __nested_vmx_check_vmentry_hw(vmx, vmx->loaded_vmcs->launched);
>  
>  	if (vmx->msr_autoload.host.nr)
>  		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 799db084a336..9fdcbd9320dc 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -234,6 +234,42 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	jmp 1b
>  SYM_FUNC_END(__vmx_vcpu_run)
>  
> +/**
> + * __nested_vmx_check_vmentry_hw - Run a vCPU via a transition to
> + *				   a nested VMX guest mode

This function comment is incorrect, this helper doesn't run the vCPU, it
simply executes VMLAUNCH or VMRESUME, which are expected to fail (and we're
in BUG_ON territory if they don't).

> + * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
> + * @launched:	%true if the VMCS has been launched
> + *
> + * Returns:
> + *	0 on VM-Exit, 1 on VM-Fail
> + */
> +SYM_FUNC_START(__nested_vmx_check_vmentry_hw)
> +	push %_ASM_BP
> +	mov  %_ASM_SP, %_ASM_BP
> +
> +	push %_ASM_BX
> +
> +	/* Copy @launched to BL, _ASM_ARG2 is volatile. */
> +	mov %_ASM_ARG2B, %bl
> +
> +	/* Adjust RSP to account for the CALL to vmx_vmenter(). */
> +	lea -WORD_SIZE(%_ASM_SP), %_ASM_ARG2
> +	call vmx_update_host_rsp
> +
> +	/* Check if vmlaunch or vmresume is needed */
> +	cmpb $0, %bl
> +
> +	/* Enter guest mode */
> +	call vmx_vmenter
> +
> +	/* Return 0 on VM-Exit, 1 on VM-Fail */
> +	setbe %al
> +
> +	pop %_ASM_BX
> +
> +	pop %_ASM_BP
> +	ret
> +SYM_FUNC_END(__nested_vmx_check_vmentry_hw)
>  
>  .section .text, "ax"
>  
> -- 
> 2.26.2
> 
