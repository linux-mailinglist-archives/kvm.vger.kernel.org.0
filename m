Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8226752C12
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 23:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjGMVXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 17:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbjGMVXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 17:23:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB282D54
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 14:23:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c4f27858e4eso1016410276.1
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 14:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689283381; x=1691875381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SEmAISENfYHTJKgnXdwIxtBUkx7mCSHbnBBJfH7pL2g=;
        b=u8nkfY1vHs9c5gFN7pdsZSU9AwzMe55h9X7xE08rkWFz7RUmhLWm89CDqXfoZa8NCG
         m3+0uhS/oEAsoU0SRFOX0kAbfRdmPz3r9Q6k9UhwOFWrg/JRJ2zhgW9y5OWIFctOdPKE
         DiW8Mf2RWMcMXZaQsYq1B6lctQLt8zs9FeMNW9/VQtiHGFBHD5IxVBLvZjcErv+iI0KW
         T+9xR57S//vKrTfbaV0cq2M3nm/6Dom3Wo9MQwOMFBYfnioisjaTtbYQYjFVZ82UpEM0
         omFWgVpd2s4m4pVtieE/yFWVH/aqXbdXBy5vRlorJDXDwruNqsJ4zodjbin0FOOCS4eZ
         ZzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689283381; x=1691875381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SEmAISENfYHTJKgnXdwIxtBUkx7mCSHbnBBJfH7pL2g=;
        b=X5JgBb3UrmPWwCfNahIHK9OXPPg3JnyebYBcGgpOgodf6dkzwYhMjcswa3tKzDtTTg
         onWlDD2LvdEl8NBKmLOEH0IjqHZd3W02Pc1ha5p1SdUggamuR6JtK/rSPlm6xGs4TSEA
         HUT0WnRdmNg3GHQH+Hb4RiwnWC0IPpILrw9FTbq3yHbtiZTx/BdOgRDH4y4ucAidUl4u
         YZGY+IHPTEyiphkMfMU5AdY8kpZxm1Xo2vDLxvMml98+D0OCkCK2apL+0z8x9uEg0aoS
         yEynnC5bBU2qUDw7hjwHIxQKVDHIG/23SqTMqnZbQ0AqOuVFjWZzG1wYdeFnHiKQuWZ8
         aDfQ==
X-Gm-Message-State: ABy/qLYWrr/NzTA22r1PNWchvTAgeH/4KQSWm0LHyZFrvOaO/DHs48U+
        OG3bOAqPGQ/hLCDyspi1J8fdG/LI7iE=
X-Google-Smtp-Source: APBJJlE3/XVfrwiQqHAyGw253Fijs3SxSmSR4x7PtFKj69SSHPH+HO1wN9+aba7au/mGkC1/tN0tCNAkTSY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1741:b0:cb6:bcb4:5465 with SMTP id
 bz1-20020a056902174100b00cb6bcb45465mr7786ybb.12.1689283381565; Thu, 13 Jul
 2023 14:23:01 -0700 (PDT)
Date:   Thu, 13 Jul 2023 14:22:59 -0700
In-Reply-To: <20230707084328.2563454-1-suhui@nfschina.com>
Mime-Version: 1.0
References: <20230707084328.2563454-1-suhui@nfschina.com>
Message-ID: <ZLBrM+Dee9okUmvc@google.com>
Subject: Re: [PATCH] KVM: VMX: Avoid noinstr warning
From:   Sean Christopherson <seanjc@google.com>
To:     Su Hui <suhui@nfschina.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023, Su Hui wrote:
> vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0x2d8:
> call to vmread_error_trampoline() leaves .noinstr.text section
> 
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---
>  arch/x86/kvm/vmx/vmx_ops.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> index ce47dc265f89..54f86ce2ad60 100644
> --- a/arch/x86/kvm/vmx/vmx_ops.h
> +++ b/arch/x86/kvm/vmx/vmx_ops.h
> @@ -112,6 +112,7 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
>  
>  #else /* !CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
>  
> +	instrumentation_begin();
>  	asm volatile("1: vmread %2, %1\n\t"
>  		     ".byte 0x3e\n\t" /* branch taken hint */
>  		     "ja 3f\n\t"
> @@ -139,6 +140,7 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
>  		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_ONE_REG, %1)
>  
>  		     : ASM_CALL_CONSTRAINT, "=&r"(value) : "r"(field) : "cc");
> +	instrumentation_end();

Tagging the entire thing as instrumentable is not correct, e.g. instrumentation
isn't magically safe when doing VMREAD immediately after VM-Exit.  Enabling
instrumentation for VM-Fail paths isn't exactly safe either, but odds are very
good that the system has major issue if a VMX instruction (other than VMLAUNCH/VMRESUME)
gets VM-Fail, in which case logging the error takes priority.

Compile tested only, but I think the below is the least awful solution.  That will
also allow the CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y case to use vmread_error() instead
of open coding an equivalent (hence the "PATCH 1/2").

I'll post patches after testing.

Thanks!

From: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Jul 2023 13:45:35 -0700
Subject: [PATCH 1/2] KVM: VMX: Make VMREAD error path play nice with noinstr

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

base-commit: 255006adb3da71bb75c334453786df781b415f54
-- 

