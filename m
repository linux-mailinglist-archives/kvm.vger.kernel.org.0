Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF87864AFA6
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiLMGJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiLMGJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:09:51 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFC11AF20
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:28 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b16-20020a17090a10d000b00221653b4526so1344027pje.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FqdJjiwJ+3KBa9yJbuoyosmHEFIdRQ7rtSq2Gl3y3sA=;
        b=L0uRFcqMg4zxrXLXzS5agUTJtSHNHZaZB/Umstjib0KDLbzEMDkaIE5IYILiNh4ihO
         Ks61vZYMKGfYWtht5ScwwNerE+C+y6uWagJ0CcBgoMLA2MHnwrngn38QzloYlobOUjZ2
         LyWEcAhE8EP0Ftp6XZJM/ey9/GhxkepiJvO7Zdo3G+MDxVA6RcDRZc9XqkSiJ0pa5KsN
         GjAVmtse3/tNYkngK2mewx7lLyeujrbP9aRghooZ2FUrMr++mTifKKsdKXJjGPNfl4VC
         EVTOIpaCOflVepNg538v55OTMIVlEOvHsRVJ0ZKCh92IxSJ3cgUee0q54Mfe68Bz0vwf
         ej5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FqdJjiwJ+3KBa9yJbuoyosmHEFIdRQ7rtSq2Gl3y3sA=;
        b=0H6ngrH8W/Snf8ubriLXReCsAqZCdJuOzvLL6v6IBcxZ9J215GyLaIYTLiA9ufvujh
         rd4VR/Di+5nCDqCWeeEMHSjEmw3mWj/npfKZI711oT4L0TjWjorwipvi7/E/8y2/0OlC
         9TOQNtF7VLlWcUWRR3QqeFwuo1Y8JDCHjb8gvvcDRCkd9mdRDhO8j3FIAjrobPMZp23U
         geXkyUYCsgE/uXZ3biRpfi9LJrICBjSzp1GzWuopRxYItB2r7AIRRb9wXcpRnEFobO/C
         gsh6865crLXoYlt9IjRz2Ic8EcJfNCXfcU2PW/dbeaAvULM+rOCDSRm8fQWn/MkluHm2
         mG4w==
X-Gm-Message-State: ANoB5pmtpUgNpXnIL4De5/I750i8omknDmDnatd51o5gGb/szPaaydxZ
        YB32jyB+dIGioxiebkKa2DngViQ3sDk=
X-Google-Smtp-Source: AA0mqf68WNGPX3LjDP06mA0PiEMAKBsyVZ5/dIfSh6Ot3lsLIv8000phHCdV7ZPecbA8WXpdCc4Ktcn+8wY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:85d9:0:b0:577:53a9:836c with SMTP id
 z25-20020aa785d9000000b0057753a9836cmr10672135pfn.5.1670911768146; Mon, 12
 Dec 2022 22:09:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:09:12 +0000
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213060912.654668-8-seanjc@google.com>
Subject: [PATCH 7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move VMX's handling of NMI VM-Exits into vmx_vcpu_enter_exit() so that
the NMI is handled prior to leaving the safety of noinstr.  Handling the
NMI after leaving noinstr exposes the kernel to potential ordering
problems as an instrumentation-induced fault, e.g. #DB, #BP, #PF, etc.
will unblock NMIs when IRETing back to the faulting instruction.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmcs.h    |  4 ++--
 arch/x86/kvm/vmx/vmenter.S |  8 ++++----
 arch/x86/kvm/vmx/vmx.c     | 34 +++++++++++++++++++++-------------
 arch/x86/kvm/x86.h         |  6 +++---
 4 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index ac290a44a693..7c1996b433e2 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -75,7 +75,7 @@ struct loaded_vmcs {
 	struct vmcs_controls_shadow controls_shadow;
 };
 
-static inline bool is_intr_type(u32 intr_info, u32 type)
+static __always_inline bool is_intr_type(u32 intr_info, u32 type)
 {
 	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK;
 
@@ -146,7 +146,7 @@ static inline bool is_icebp(u32 intr_info)
 	return is_intr_type(intr_info, INTR_TYPE_PRIV_SW_EXCEPTION);
 }
 
-static inline bool is_nmi(u32 intr_info)
+static __always_inline bool is_nmi(u32 intr_info)
 {
 	return is_intr_type(intr_info, INTR_TYPE_NMI_INTR);
 }
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 9d987e7e48c4..059243085211 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -299,6 +299,10 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 
 SYM_FUNC_END(__vmx_vcpu_run)
 
+SYM_FUNC_START(vmx_do_nmi_irqoff)
+	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
+SYM_FUNC_END(vmx_do_nmi_irqoff)
+
 
 .section .text, "ax"
 
@@ -353,10 +357,6 @@ SYM_FUNC_START(vmread_error_trampoline)
 SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
-SYM_FUNC_START(vmx_do_nmi_irqoff)
-	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
-SYM_FUNC_END(vmx_do_nmi_irqoff)
-
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
 	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c242e2591896..b03020ca1840 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5095,8 +5095,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
@@ -6809,7 +6814,7 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_irqoff(struct vcpu_vmx *vmx)
 {
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
@@ -6822,12 +6827,6 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
-	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info)) {
-		kvm_before_interrupt(&vmx->vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
-		kvm_after_interrupt(&vmx->vcpu);
-	}
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
@@ -6857,7 +6856,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_nmi_irqoff(vmx);
+		handle_exception_irqoff(vmx);
 }
 
 /*
@@ -7119,6 +7118,18 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vmx_enable_fb_clear(vmx);
 
+	if (unlikely(vmx->fail))
+		vmx->exit_reason.full = 0xdead;
+	else
+		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+
+	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	    is_nmi(vmx_get_intr_info(vcpu))) {
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+		vmx_do_nmi_irqoff();
+		kvm_after_interrupt(vcpu);
+	}
+
 	guest_state_exit_irqoff();
 }
 
@@ -7260,12 +7271,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	vmx->idt_vectoring_info = 0;
 
-	if (unlikely(vmx->fail)) {
-		vmx->exit_reason.full = 0xdead;
+	if (unlikely(vmx->fail))
 		return EXIT_FASTPATH_NONE;
-	}
 
-	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
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
-- 
2.39.0.rc1.256.g54fd8350bd-goog

