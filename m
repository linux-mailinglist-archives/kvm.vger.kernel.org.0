Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EADD75D7F8
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGUX4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjGUX4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:56:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFA530E3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:56:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b9de3e7fb1so14387605ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689983804; x=1690588604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6NovDKEkmf62QTHUp16tEbCQYBqsRkwO6qPZcwM/IpM=;
        b=m9yRmOB/Hl+eRWXlUq0DfSY9BX2JKqXoKRjMwugp1FJVPEFn93LjV6RVFg/EBIDRq0
         kUIqf3rVoLK3ExOqmuBX6Ej15HkRRSG2WqUMgTSUsE0tHSGGCrDDv0BvQ+/mm89rgG13
         EbG5ufx35VHeUaFsAAQ6Cy3F6RXAaWVTR27OQUnyTVrGJbqs572X2E8gU4+LMSlTBEJo
         HokuL0vl3+hXvBzruH9I1upAvq6rpHNMHneaScnzPm2SjV8MIpoN64z5De8wAcu4joLp
         6iu51nyZC3uAHvoZqfN59Y/hNmHRnb8TEln7bsByO79MJCCH8eMDCnAzGMqxAb8EDGcE
         USwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689983804; x=1690588604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6NovDKEkmf62QTHUp16tEbCQYBqsRkwO6qPZcwM/IpM=;
        b=Ht51NiNAsENIlDqVZmi3J8K+3atRHBq76BCxoksfVdHSjUecqJElvmY+3+NMv6A61L
         O7/n9Xx4g2DP8rtnjBxggpXf3QzOG63g+q61vyQMfZme40NTf7q1RPXqq0dqF3557adr
         SWASC3lhqRMRT9qYeOrdimcDftl8wkJx8ZSNKnOBgZZc/Uq2+glnG+cz0vSGTjC4MEi8
         rQvFQ2euVEfMOPq0DGBEEMnQcgFFG0x13JxSKSi6hmbng6pxAK/dtUIVElatv13un6kx
         kcceSm+hHQKBbcGH2RSjMdCiBFETvs+nBhj4+aixJGWy8mKxgaSILJaChxkCZ7anp6jj
         25sw==
X-Gm-Message-State: ABy/qLbqdgPGQWbesux1SWYdSuvtObgG1iie8zP3yj2ggIicUzesjrVU
        A2m6y5s2qS8Irts+jkQWTNRZbw9n/Qw=
X-Google-Smtp-Source: APBJJlHq2HLtrqVyzDIl2SIFChpZIefwP2c8PssvQNkMR6eG1BRg1s9c4iFFHAe+btgzVPNBBcBkMjzRNjE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce83:b0:1b9:ce2c:3bb0 with SMTP id
 f3-20020a170902ce8300b001b9ce2c3bb0mr13551plg.3.1689983803804; Fri, 21 Jul
 2023 16:56:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:56:36 -0700
In-Reply-To: <20230721235637.2345403-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721235637.2345403-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721235637.2345403-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: VMX: Make VMREAD error path play nice with noinstr
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Su Hui <suhui@nfschina.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark vmread_error_trampoline() as noinstr, and add a second trampoline
for the CONFIG_CC_HAS_ASM_GOTO_OUTPUT=n case to enable instrumentation
when handling VM-Fail on VMREAD.  VMREAD is used in various noinstr
flows, e.g. immediately after VM-Exit, and objtool rightly complains that
the call to the error trampoline leaves a no-instrumentation section
without annotating that it's safe to do so.

  vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0xc9:
  call to vmread_error_trampoline() leaves .noinstr.text section

Note, strictly speaking, enabling instrumentation in the VM-Fail path
isn't exactly safe, but if VMREAD fails the kernel/system is likely hosed
anyways, and logging that there is a fatal error is more important than
*maybe* encountering slightly unsafe instrumentation.

Reported-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmenter.S |  8 ++++----
 arch/x86/kvm/vmx/vmx.c     | 18 ++++++++++++++----
 arch/x86/kvm/vmx/vmx_ops.h |  9 ++++++++-
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 07e927d4d099..be275a0410a8 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -303,10 +303,8 @@ SYM_FUNC_START(vmx_do_nmi_irqoff)
 	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
 SYM_FUNC_END(vmx_do_nmi_irqoff)
 
-
-.section .text, "ax"
-
 #ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+
 /**
  * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
  * @field:	VMCS field encoding that failed
@@ -335,7 +333,7 @@ SYM_FUNC_START(vmread_error_trampoline)
 	mov 3*WORD_SIZE(%_ASM_BP), %_ASM_ARG2
 	mov 2*WORD_SIZE(%_ASM_BP), %_ASM_ARG1
 
-	call vmread_error
+	call vmread_error_trampoline2
 
 	/* Zero out @fault, which will be popped into the result register. */
 	_ASM_MOV $0, 3*WORD_SIZE(%_ASM_BP)
@@ -357,6 +355,8 @@ SYM_FUNC_START(vmread_error_trampoline)
 SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
+.section .text, "ax"
+
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
 	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..d7cf35edda1b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -441,13 +441,23 @@ do {					\
 	pr_warn_ratelimited(fmt);	\
 } while (0)
 
-void vmread_error(unsigned long field, bool fault)
+noinline void vmread_error(unsigned long field)
 {
-	if (fault)
+	vmx_insn_failed("vmread failed: field=%lx\n", field);
+}
+
+#ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+noinstr void vmread_error_trampoline2(unsigned long field, bool fault)
+{
+	if (fault) {
 		kvm_spurious_fault();
-	else
-		vmx_insn_failed("vmread failed: field=%lx\n", field);
+	} else {
+		instrumentation_begin();
+		vmread_error(field);
+		instrumentation_end();
+	}
 }
+#endif
 
 noinline void vmwrite_error(unsigned long field, unsigned long value)
 {
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index ce47dc265f89..5fa74779a37a 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -10,7 +10,7 @@
 #include "vmcs.h"
 #include "../x86.h"
 
-void vmread_error(unsigned long field, bool fault);
+void vmread_error(unsigned long field);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
@@ -31,6 +31,13 @@ void invept_error(unsigned long ext, u64 eptp, gpa_t gpa);
  * void vmread_error_trampoline(unsigned long field, bool fault);
  */
 extern unsigned long vmread_error_trampoline;
+
+/*
+ * The second VMREAD error trampoline, called from the assembly trampoline,
+ * exists primarily to enable instrumentation for the VM-Fail path.
+ */
+void vmread_error_trampoline2(unsigned long field, bool fault);
+
 #endif
 
 static __always_inline void vmcs_check16(unsigned long field)
-- 
2.41.0.487.g6d72f3e995-goog

