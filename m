Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027108827A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407436AbfHISbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 14:31:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:7052 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436791AbfHISbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 14:31:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:31:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="374570158"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 09 Aug 2019 11:31:47 -0700
Date:   Fri, 9 Aug 2019 11:31:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 2/7] x86: kvm: svm: propagate errors from
 skip_emulated_instruction()
Message-ID: <20190809183146.GD10541@linux.intel.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
 <20190808173051.6359-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808173051.6359-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 07:30:46PM +0200, Vitaly Kuznetsov wrote:
> On AMD, kvm_x86_ops->skip_emulated_instruction(vcpu) can, in theory,
> fail: in !nrips case we call kvm_emulate_instruction(EMULTYPE_SKIP).
> Currently, we only do printk(KERN_DEBUG) when this happens and this
> is not ideal. Propagate the error up the stack.
> 
> On VMX, skip_emulated_instruction() doesn't fail, we have two call
> sites calling it explicitly: handle_exception_nmi() and
> handle_task_switch(), we can just ignore the result.
> 
> On SVM, we also have two explicit call sites:
> svm_queue_exception() and it seems we don't need to do anything there as
> we check if RIP was advanced or not. In task_switch_interception(),
> however, we are better off not proceeding to kvm_task_switch() in case
> skip_emulated_instruction() failed.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 074385c86c09..2579e7a6d59d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1473,7 +1473,7 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
>  }
>  
>  
> -static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
> +static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long rip;
>  
> @@ -1483,6 +1483,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  
>  	/* skipping an emulated instruction also counts */
>  	vmx_set_interrupt_shadow(vcpu, 0);
> +
> +	return EMULATE_DONE;
>  }
>  
>  static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
> @@ -4547,7 +4549,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>  			vcpu->arch.dr6 |= dr6 | DR6_RTM;
>  			if (is_icebp(intr_info))
> -				skip_emulated_instruction(vcpu);
> +				(void)skip_emulated_instruction(vcpu);
>  
>  			kvm_queue_exception(vcpu, DB_VECTOR);
>  			return 1;
> @@ -5057,7 +5059,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
>  	if (!idt_v || (type != INTR_TYPE_HARD_EXCEPTION &&
>  		       type != INTR_TYPE_EXT_INTR &&
>  		       type != INTR_TYPE_NMI_INTR))
> -		skip_emulated_instruction(vcpu);
> +		(void)skip_emulated_instruction(vcpu);

Maybe a silly idea, but what if we squash the return value in a dedicated
helper, with a big "DO NOT USE" comment above the int-returning function, e.g.:

static int __skip_emulated_instruction(struct kvm_vcpu *vcpu)
{
	unsigned long rip;

	rip = kvm_rip_read(vcpu);
	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
	kvm_rip_write(vcpu, rip);

	/* skipping an emulated instruction also counts */
	vmx_set_interrupt_shadow(vcpu, 0);

	return EMULATE_DONE;
}

static inline void skip_emulated_instruction(struct kvm_vcpu *vcpu)
{
	(void)__skip_emulated_instruction(vcpu);
}


Alternatively, the inner function could be void, but on my system that
adds an extra call in the wrapper, i.e. in the kvm_skip_emulated...()
path.  The above approach generates the same code as your patch, e.g.
allows the compiler to decide whether or not to inline the meat of the
code.

>  	if (kvm_task_switch(vcpu, tss_selector,
>  			    type == INTR_TYPE_SOFT_INTR ? idt_index : -1, reason,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6d951cbd76c..a97818b1111d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6383,9 +6383,11 @@ static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> -	int r = EMULATE_DONE;
> +	int r;
>  
> -	kvm_x86_ops->skip_emulated_instruction(vcpu);
> +	r = kvm_x86_ops->skip_emulated_instruction(vcpu);
> +	if (r != EMULATE_DONE)

This should probably be wrapped with unlikely.

> +		return 0;
>  
>  	/*
>  	 * rflags is the old, "raw" value of the flags.  The new value has
> -- 
> 2.20.1
> 
