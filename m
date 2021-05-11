Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E942537B2D0
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 01:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhEKXz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 19:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKXz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 19:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620777289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJ9npD1rbA7F89PpG04Ums16Ro3sxWMBXXN6oqoNyHI=;
        b=EV/7Zp6CZjmZoFTLlVcqpdhwrBpPgq6tEurBtlOCxDp+2AdmMHNmY21OTN8fW17tBRVc8z
        S4hjlCPJXupKt4KrHP4IxFh7gI5RO+Y51idrYgxPnpkHt+5TqyJkgv/oH7K5VW8lsGbSLr
        1luKNfApKtbJDLRFGglX3mkF6/pnDdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-ZW-UZz5iPLqE28U-J3Dryw-1; Tue, 11 May 2021 19:54:48 -0400
X-MC-Unique: ZW-UZz5iPLqE28U-J3Dryw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 239EB6D241;
        Tue, 11 May 2021 23:54:47 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53EE55D6A8;
        Tue, 11 May 2021 23:54:36 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8303443F79CA; Tue, 11 May 2021 20:51:24 -0300 (-03)
Date:   Tue, 11 May 2021 20:51:24 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210511235124.GA187296@fuller.cnet>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
 <YJr4ravpCjz2M4bp@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YJr4ravpCjz2M4bp@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 05:35:41PM -0400, Peter Xu wrote:
> On Tue, May 11, 2021 at 02:18:10PM -0300, Marcelo Tosatti wrote:
> > On Tue, May 11, 2021 at 12:19:56PM -0400, Peter Xu wrote:
> > > On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> > > > On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > > > > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > > > > 
> > > > > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > > > > {
> > > > > >         int ret = -EINTR;
> > > > > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > > > 
> > > > > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > > > > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > > > > >                 goto out;
> > > > > >         }
> > > > > > 
> > > > > > Don't want to unhalt the vcpu.
> > > > > 
> > > > > Could you elaborate?  It's not obvious to me why we can't do that if
> > > > > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > > > > shouldn't we stop halting?  Thanks!
> > > > 
> > > > pi_test_on() only returns true when an interrupt is signalled by the
> > > > device. But the sequence of events is:
> > > > 
> > > > 
> > > > 1. pCPU idles without notification vector configured to wakeup vector.
> > > > 
> > > > 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> > > > 
> > > > <arbitrary amount of time>
> > > > 
> > > > 3. device generates interrupt, sets ON bit to true in the posted
> > > > interrupt descriptor.
> > > > 
> > > > We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> > > > is not set).
> > > 
> > > Ah yes.. thanks.
> > > 
> > > Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
> > > define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):
> > > 
> > > #define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
> > > 
> > > We can set it in vmx_pi_start_assignment(), then check+clear it in
> > > kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).
> > 
> > Can't check it in kvm_vcpu_has_events() because that will set
> > KVM_REQ_UNHALT (which we don't want).
> 
> I thought it was okay to break the guest HLT? 

Intel:

"HLT-HALT

Description

Stops instruction execution and places the processor in a HALT state. An enabled interrupt (including NMI and
SMI), a debug exception, the BINIT# signal, the INIT# signal, or the RESET# signal will resume execution. If an
interrupt (including NMI) is used to resume execution after a HLT instruction, the saved instruction pointer
(CS:EIP) points to the instruction following the HLT instruction."

AMD:

"6.5 Processor Halt
The processor halt instruction (HLT) halts instruction execution, leaving the processor in the halt state.
No registers or machine state are modified as a result of executing the HLT instruction. The processor
remains in the halt state until one of the following occurs:
• A non-maskable interrupt (NMI).
• An enabled, maskable interrupt (INTR).
• Processor reset (RESET).
• Processor initialization (INIT).
• System-management interrupt (SMI)."

The KVM_REQ_UNBLOCK patch will resume execution even any such event
occuring. So the behaviour would be different from baremetal.

> As IMHO the guest code should
> always be able to re-run the HLT when interrupted?  As IIUC HLT can easily be
> interrupted by e.g., SMIs, according to SDM Vol.2.  

CPU will by default return to HLT'ed state, not continue to the
instruction following HLT, on SMI:

34.10 AUTO HALT RESTART
If the processor is in a HALT state (due to the prior execution of a HLT instruction) when it receives an SMI, the
processor records the fact in the auto HALT restart flag in the saved processor state (see Figure 34-3). (This flag is
located at offset 7F02H and bit 0 in the state save area of the SMRAM.)
If the processor sets the auto HALT restart flag upon entering SMM (indicating that the SMI occurred when the
processor was in the HALT state), the SMI handler has two options:
* It can leave the auto HALT restart flag set, which instructs the RSM instruction to return program control to the
HLT instruction. This option in effect causes the processor to re-enter the HALT state after handling the SMI.
(This is the default operation.)
* It can clear the auto HALT restart flag, which instructs the RSM instruction to return program control to the
instruction following the HLT instruction.

> Not to mention vfio hotplug
> should be rare, and we'll only trigger this once for the 1st device.
> 
> > 
> > I think KVM_REQ_UNBLOCK will add more lines of code.
> 
> It's very possible I overlooked something above... but if breaking HLT
> unregularly is okay, I attached one patch that is based on your v3 series, just
> dropped the vcpu_check_block() but use KVM_REQ_UNBLOCK (no compile test even,
> just to satisfy my own curiosity on how many loc we can save.. :), it gives me:
> 
>  7 files changed, 5 insertions(+), 41 deletions(-)
> 
> But again, I could have missed something...
> 
> Thanks,
> 
> > 
> > > The thing is current vmx_vcpu_check_block() is mostly a sanity check and
> > > copy-paste of the pi checks on a few items, so maybe cleaner to use
> > > KVM_REQ_UNBLOCK, as it might be reused in the future for re-evaluating of
> > > pre-block for similar purpose?
> > > 
> > > No strong opinion, though.
> > 
> > Hum... IMHO v3 is quite clean already (although i don't object to your
> > suggestion).
> > 
> > Paolo, what do you think?
> > 
> > 
> > 
> 
> -- 
> Peter Xu

> >From 1131248f3c8f1f2715dd49d439c9fab25b4db9b8 Mon Sep 17 00:00:00 2001
> From: Peter Xu <peterx@redhat.com>
> Date: Tue, 11 May 2021 17:33:21 -0400
> Subject: [PATCH] replace vcpu_check_block() hook with KVM_REQ_UNBLOCK
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 -
>  arch/x86/include/asm/kvm_host.h    | 12 +-----------
>  arch/x86/kvm/svm/svm.c             |  1 -
>  arch/x86/kvm/vmx/posted_intr.c     | 27 +--------------------------
>  arch/x86/kvm/vmx/posted_intr.h     |  1 -
>  arch/x86/kvm/vmx/vmx.c             |  1 -
>  arch/x86/kvm/x86.c                 |  3 +++
>  7 files changed, 5 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index fc99fb779fd21..e7bef91cee04a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -98,7 +98,6 @@ KVM_X86_OP_NULL(pre_block)
>  KVM_X86_OP_NULL(post_block)
>  KVM_X86_OP_NULL(vcpu_blocking)
>  KVM_X86_OP_NULL(vcpu_unblocking)
> -KVM_X86_OP_NULL(vcpu_check_block)
>  KVM_X86_OP_NULL(update_pi_irte)
>  KVM_X86_OP_NULL(start_assignment)
>  KVM_X86_OP_NULL(apicv_post_state_restore)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5bf7bd0e59582..74ab042e9b146 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -91,6 +91,7 @@
>  #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
>  #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
>  	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> @@ -1350,8 +1351,6 @@ struct kvm_x86_ops {
>  	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
>  	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
>  
> -	int (*vcpu_check_block)(struct kvm_vcpu *vcpu);
> -
>  	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
>  			      uint32_t guest_irq, bool set);
>  	void (*start_assignment)(struct kvm *kvm);
> @@ -1835,15 +1834,6 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
>  		irq->delivery_mode == APIC_DM_LOWEST);
>  }
>  
> -#define __KVM_HAVE_ARCH_VCPU_CHECK_BLOCK
> -static inline int kvm_arch_vcpu_check_block(struct kvm_vcpu *vcpu)
> -{
> -	if (kvm_x86_ops.vcpu_check_block)
> -		return static_call(kvm_x86_vcpu_check_block)(vcpu);
> -
> -	return 0;
> -}
> -
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
>  	static_call_cond(kvm_x86_vcpu_blocking)(vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cda5ccb4d9d1b..8b03795cfcd11 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4459,7 +4459,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.vcpu_put = svm_vcpu_put,
>  	.vcpu_blocking = svm_vcpu_blocking,
>  	.vcpu_unblocking = svm_vcpu_unblocking,
> -	.vcpu_check_block = NULL,
>  
>  	.update_exception_bitmap = svm_update_exception_bitmap,
>  	.get_msr_feature = svm_get_msr_feature,
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 2d0d009965530..0b74d598ebcbd 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -203,32 +203,6 @@ void pi_post_block(struct kvm_vcpu *vcpu)
>  	local_irq_enable();
>  }
>  
> -/*
> - * Bail out of the block loop if the VM has an assigned
> - * device, but the blocking vCPU didn't reconfigure the
> - * PI.NV to the wakeup vector, i.e. the assigned device
> - * came along after the initial check in vcpu_block().
> - */
> -
> -int vmx_vcpu_check_block(struct kvm_vcpu *vcpu)
> -{
> -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -
> -	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> -		return 0;
> -
> -	if (!kvm_vcpu_apicv_active(vcpu))
> -		return 0;
> -
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm))
> -		return 0;
> -
> -	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR)
> -		return 0;
> -
> -	return 1;
> -}
> -
>  /*
>   * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
>   */
> @@ -278,6 +252,7 @@ void vmx_pi_start_assignment(struct kvm *kvm)
>  		if (!kvm_vcpu_apicv_active(vcpu))
>  			continue;
>  
> +		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
>  		kvm_vcpu_wake_up(vcpu);
>  	}
>  }
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index 2aa082fd1c7ab..7f7b2326caf53 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -96,6 +96,5 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
>  		   bool set);
>  void vmx_pi_start_assignment(struct kvm *kvm);
> -int vmx_vcpu_check_block(struct kvm_vcpu *vcpu);
>  
>  #endif /* __KVM_X86_VMX_POSTED_INTR_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ab68fed8b7e43..639ec3eba9b80 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7716,7 +7716,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.pre_block = vmx_pre_block,
>  	.post_block = vmx_post_block,
> -	.vcpu_check_block = vmx_vcpu_check_block,
>  
>  	.pmu_ops = &intel_pmu_ops,
>  	.nested_ops = &vmx_nested_ops,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e6fee59b5dab6..739e1bd59e8a9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11177,6 +11177,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
>  		return true;
>  
> +	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
> +		return true;
> +
>  	if (kvm_arch_interrupt_allowed(vcpu) &&
>  	    (kvm_cpu_has_interrupt(vcpu) ||
>  	    kvm_guest_apic_has_interrupt(vcpu)))
> -- 
> 2.31.1
> 

