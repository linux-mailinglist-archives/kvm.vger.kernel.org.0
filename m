Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E996636B72
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 21:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbiKWUnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 15:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbiKWUm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 15:42:58 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9035511474
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:42:56 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n17so17723014pgh.9
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Jcy3UuErFEL/uxbNGmrLvWKbMJqvOa2yNcvcH8igpg=;
        b=ZLiw78UQJAxB7mQsrvnaGSNRr5DMKmak5zi+VeO48Wfj0qfU9Ktx+DM5+1oBhmDMXA
         J8vpxu4xzLXaacGdmPlzJe0QgG1VEfmI5omBlvCbcdwRGtgZ1SWDyniBMRd2LxdQWEIy
         1hFQaA1DeG1GOSfWXtzejQ5tMpjw6MmGtOVWN01k2PqkLHhjjUZ6vqxqnMUNHbFKg2xn
         epMZsKnzPIGFT5ivk3eDfUmn9s0Nn5SLd1r8ZL5HyhliGC3f6bTseQmNCR8LilQgkCAG
         hPQm0YBNwPUe6GJYlneJPIJReHfJPjPUCqH1gg85R7tLwifjnl4cqUiqtciAWhvHxXax
         LuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Jcy3UuErFEL/uxbNGmrLvWKbMJqvOa2yNcvcH8igpg=;
        b=78qYTVEENS9w3AF6Bn7EbRSIczq2lEW9yuWYDB5vCQ3OUPUADgYvI+G//JNFO5mhHN
         XL+agoJ5hZQzIpGdtfrya6KexODgUFwG2sGIieLQCHoCL+fQlMVmssu3l9C8aX4BOrVY
         W+UVinpaT1zPBxk7BE4+rxZq9Ys/f8WLaYVj6s9XeqlAI6UfCOTuJrkGR1FBuPwywDk+
         bjTNLYD7uaqpJMDAeb1PPKjHTGxFnuHVkT0bHxrrV2oSSuWnOiwQH2BuutOonyQFpDoo
         IsASZ/R0mlsWg+fxQBhwpuFbuihyMxtZRZKg5ue/YinvOTHHkNHSwOuhdNpi8ENRPPba
         Ml8w==
X-Gm-Message-State: ANoB5pn5bq5hiQL3leGk7XjCkOdsfnfNca1JRiAzKDI2haQ8j9jjOex8
        puXZGxZpKXgM7SIy7awY2e+RmQ==
X-Google-Smtp-Source: AA0mqf6xewa7deFrmzxk0nn3+ek/4dYZ32RtvPLDTB/bMHU7pHRJ1eVjgh/I0MNhPWiOl0lubi0g2A==
X-Received: by 2002:a63:dc45:0:b0:44e:46f9:7eeb with SMTP id f5-20020a63dc45000000b0044e46f97eebmr9659477pgj.3.1669236175467;
        Wed, 23 Nov 2022 12:42:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7950d000000b0056bc742d21esm13488945pfp.176.2022.11.23.12.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:42:55 -0800 (PST)
Date:   Wed, 23 Nov 2022 20:42:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y36Fy/OYO5u0AzEG@google.com>
References: <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y302kxLEhcp20d65@google.com>
 <BN6PR1101MB216162F44664713802201FAFA80C9@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB216162F44664713802201FAFA80C9@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022, Li, Xin3 wrote:
> > Actually, SVM already enables NMIs far earlier, which means the probability of
> > breaking something by moving NMI handling earlier is lower.  Not zero, as I
> > don't trust that SVM gets all the corner right, but definitely low.

Duh.  Moving NMI handling much earlier in VMX's VM-Exit path _must_ be safe,
otherwise we already have problems.  On VMX, NMIs are enabled right up until
VM-Enter (VMLAUNCH/VMRESUME), and unless the VM-Exit is due to an NMI, NMIs are
enabled immediately after VM-Exit.

This case is problematic because the CPU can end up running the NMI handler with
NMIs enabled, not because it might run with incorrect state loaded.

> > E.g. this should be doable
> 
> Do we need to recover *all* host states before switching to NMI stack and
> handler?  

As above, no.

> if not what is the minimal set?

The absolute minimal set is what is context switched via the VMCS.

> If we restore the minimal set and do "int $2" as early as possible, is it a
> quick and dirty approach?

No, it is simply "the approach".  If there are other problems with respect to
noinstr, then they can/should be fixed separately.

> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > cea8c07f5229..2fec93f38960 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7249,6 +7249,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu
> > *vcpu)
> >         if (unlikely(vmx->exit_reason.failed_vmentry))
> >                 return EXIT_FASTPATH_NONE;
> > 
> > +       <handle NMIs here>
> > +
> >         vmx->loaded_vmcs->launched = 1;
> > 
> >         vmx_recover_nmi_blocking(vmx);
> > 
> > 
> > thouh we'd like want a fair bit of refactoring so that all of vmx_vcpu_run() and
> > svm_vcpu_run() don't need to be noinstr.

For the record, svm_vcpu_run() is fine, at least as far as NMIs are concerned.

> This sounds reasonable to me, however from Documentation/core-api/entry.rst,
> we do need it. 

Why do you say that?


I believe this is what we should end up with.  Compile tested only, and needs to
split up into 4+ patches.  I'll test and massage this into a proper series next
week (US holiday the rest of this week).

---
 arch/x86/kvm/kvm_cache_regs.h | 16 +++++------
 arch/x86/kvm/vmx/vmenter.S    |  4 +--
 arch/x86/kvm/vmx/vmx.c        | 51 ++++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h        |  2 +-
 arch/x86/kvm/x86.h            |  6 ++---
 5 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index c09174f73a34..af9bd0374915 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -50,26 +50,26 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
  * 1	  0	  register in vcpu->arch
  * 1	  1	  register in vcpu->arch, needs to be stored back
  */
-static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
-					     enum kvm_reg reg)
+static __always_inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
+						      enum kvm_reg reg)
 {
 	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
-static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
-					 enum kvm_reg reg)
+static __always_inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
+						  enum kvm_reg reg)
 {
 	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
 
-static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
-					       enum kvm_reg reg)
+static __always_inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
+							enum kvm_reg reg)
 {
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
-static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
-					   enum kvm_reg reg)
+static __always_inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
+						    enum kvm_reg reg)
 {
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0b5db4de4d09..b104dfd282ed 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -318,7 +318,7 @@ SYM_FUNC_START(vmread_error_trampoline)
 	RET
 SYM_FUNC_END(vmread_error_trampoline)
 
-SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
+SYM_FUNC_START(vmx_do_interrupt_irqoff)
 	/*
 	 * Unconditionally create a stack frame, getting the correct RSP on the
 	 * stack (for x86-64) would take two instructions anyways, and RBP can
@@ -349,4 +349,4 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	mov %_ASM_BP, %_ASM_SP
 	pop %_ASM_BP
 	RET
-SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
+SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cea8c07f5229..b721fde4f5af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5064,8 +5064,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx_get_intr_info(vcpu);
 
+	/*
+	 * Machine checks are handled by handle_exception_irqoff(), or by
+	 * vmx_vcpu_run() if a #MC occurs on VM-Entry.  NMIs are handled by
+	 * vmx_vcpu_enter_exit().
+	 */
 	if (is_machine_check(intr_info) || is_nmi(intr_info))
-		return 1; /* handled by handle_exception_nmi_irqoff() */
+		return 1;
 
 	/*
 	 * Queue the exception here instead of in handle_nm_fault_irqoff().
@@ -6755,18 +6760,6 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
-
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
-					unsigned long entry)
-{
-	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
-
-	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
-	vmx_do_interrupt_nmi_irqoff(entry);
-	kvm_after_interrupt(vcpu);
-}
-
 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -6787,9 +6780,8 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_irqoff(struct vcpu_vmx *vmx)
 {
-	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
@@ -6801,11 +6793,10 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
-	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
 }
 
+void vmx_do_interrupt_irqoff(unsigned long entry);
+
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
@@ -6816,7 +6807,10 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
+	vmx_do_interrupt_irqoff(gate_offset(desc));
+	kvm_after_interrupt(vcpu);
+
 	vcpu->arch.at_instruction_boundary = true;
 }
 
@@ -6830,7 +6824,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_nmi_irqoff(vmx);
+		handle_exception_irqoff(vmx);
 }
 
 /*
@@ -7091,6 +7085,18 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vmx_enable_fb_clear(vmx);
 
+	if (unlikely(vmx->fail))
+		vmx->exit_reason.full = 0xdead;
+	else
+		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+
+	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	    is_nmi(vmx_get_intr_info(vcpu))) {
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+		asm("int $2");
+		kvm_after_interrupt(vcpu);
+	}
+
 	guest_state_exit_irqoff();
 }
 
@@ -7232,12 +7238,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	vmx->idt_vectoring_info = 0;
 
-	if (unlikely(vmx->fail)) {
-		vmx->exit_reason.full = 0xdead;
+	if (unlikely(vmx->fail))
 		return EXIT_FASTPATH_NONE;
-	}
 
-	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..eb52cfde5ec2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -680,7 +680,7 @@ static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 	return vmx->exit_qualification;
 }
 
-static inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
+static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9de72586f406..44d1827f0a30 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -382,13 +382,13 @@ enum kvm_intr_type {
 	KVM_HANDLING_NMI,
 };
 
-static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
-					enum kvm_intr_type intr)
+static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
+						 enum kvm_intr_type intr)
 {
 	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, (u8)intr);
 }
 
-static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
+static __always_inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 {
 	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 0);
 }

base-commit: 0fa32dad1e78629cb42999dacd82489503fdf4c2
-- 

