Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C042C611DF5
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJ1XKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJ1XJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:09:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99324237F92
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666998475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yxaGnxgWwzjJebtBd1nQHTLTDvjc6TK6JIF1/9n4sCM=;
        b=Ong4kfPCPg/pZb3by5b1op7t2UFLwm76YXIhH9137LJugzcbqzrasHvzz2YruE5ecCx/xB
        50zpJ7+V+/XmV1yrtRau1Zwsxhk7DW8WZnkigcAtTsyP1Lipud8cDp9K6xmKLqBE0LDjCo
        GdFooRdSeh+s2MPnmr/tKXw2NUUcu9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-sj8gcml3MlyQrmCzAV4eZg-1; Fri, 28 Oct 2022 19:07:51 -0400
X-MC-Unique: sj8gcml3MlyQrmCzAV4eZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19CBF81172A;
        Fri, 28 Oct 2022 23:07:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D78A640C6E15;
        Fri, 28 Oct 2022 23:07:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, jpoimboe@kernel.org
Subject: [PATCH 1/7] KVM: VMX: remove regs argument of __vmx_vcpu_run
Date:   Fri, 28 Oct 2022 19:07:17 -0400
Message-Id: <20221028230723.3254250-2-pbonzini@redhat.com>
In-Reply-To: <20221028230723.3254250-1-pbonzini@redhat.com>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Registers are reachable through vcpu_vmx, no need to pass
a separate pointer to the regs[] array.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/asm-offsets.c |  1 +
 arch/x86/kvm/vmx/nested.c     |  3 +-
 arch/x86/kvm/vmx/vmenter.S    | 58 +++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.c        |  3 +-
 arch/x86/kvm/vmx/vmx.h        |  3 +-
 5 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index cb50589a7102..90da275ad223 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -111,6 +111,7 @@ static void __used common(void)
 
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
 		BLANK();
+		OFFSET(VMX_vcpu_arch_regs, vcpu_vmx, vcpu.arch.regs);
 		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
 	}
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61a2e551640a..3f62bdaffb0b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3094,8 +3094,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				 __vmx_vcpu_run_flags(vmx));
+	vm_fail = __vmx_vcpu_run(vmx, __vmx_vcpu_run_flags(vmx));
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 63b4ad54331b..1362fe5859f9 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -11,24 +11,24 @@
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
-#define VCPU_RAX	__VCPU_REGS_RAX * WORD_SIZE
-#define VCPU_RCX	__VCPU_REGS_RCX * WORD_SIZE
-#define VCPU_RDX	__VCPU_REGS_RDX * WORD_SIZE
-#define VCPU_RBX	__VCPU_REGS_RBX * WORD_SIZE
+#define VCPU_RAX	(VMX_vcpu_arch_regs + __VCPU_REGS_RAX * WORD_SIZE)
+#define VCPU_RCX	(VMX_vcpu_arch_regs + __VCPU_REGS_RCX * WORD_SIZE)
+#define VCPU_RDX	(VMX_vcpu_arch_regs + __VCPU_REGS_RDX * WORD_SIZE)
+#define VCPU_RBX	(VMX_vcpu_arch_regs + __VCPU_REGS_RBX * WORD_SIZE)
 /* Intentionally omit RSP as it's context switched by hardware */
-#define VCPU_RBP	__VCPU_REGS_RBP * WORD_SIZE
-#define VCPU_RSI	__VCPU_REGS_RSI * WORD_SIZE
-#define VCPU_RDI	__VCPU_REGS_RDI * WORD_SIZE
+#define VCPU_RBP	(VMX_vcpu_arch_regs + __VCPU_REGS_RBP * WORD_SIZE)
+#define VCPU_RSI	(VMX_vcpu_arch_regs + __VCPU_REGS_RSI * WORD_SIZE)
+#define VCPU_RDI	(VMX_vcpu_arch_regs + __VCPU_REGS_RDI * WORD_SIZE)
 
 #ifdef CONFIG_X86_64
-#define VCPU_R8		__VCPU_REGS_R8  * WORD_SIZE
-#define VCPU_R9		__VCPU_REGS_R9  * WORD_SIZE
-#define VCPU_R10	__VCPU_REGS_R10 * WORD_SIZE
-#define VCPU_R11	__VCPU_REGS_R11 * WORD_SIZE
-#define VCPU_R12	__VCPU_REGS_R12 * WORD_SIZE
-#define VCPU_R13	__VCPU_REGS_R13 * WORD_SIZE
-#define VCPU_R14	__VCPU_REGS_R14 * WORD_SIZE
-#define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
+#define VCPU_R8		(VMX_vcpu_arch_regs + __VCPU_REGS_R8  * WORD_SIZE)
+#define VCPU_R9		(VMX_vcpu_arch_regs + __VCPU_REGS_R9  * WORD_SIZE)
+#define VCPU_R10	(VMX_vcpu_arch_regs + __VCPU_REGS_R10 * WORD_SIZE)
+#define VCPU_R11	(VMX_vcpu_arch_regs + __VCPU_REGS_R11 * WORD_SIZE)
+#define VCPU_R12	(VMX_vcpu_arch_regs + __VCPU_REGS_R12 * WORD_SIZE)
+#define VCPU_R13	(VMX_vcpu_arch_regs + __VCPU_REGS_R13 * WORD_SIZE)
+#define VCPU_R14	(VMX_vcpu_arch_regs + __VCPU_REGS_R14 * WORD_SIZE)
+#define VCPU_R15	(VMX_vcpu_arch_regs + __VCPU_REGS_R15 * WORD_SIZE)
 #endif
 
 .section .noinstr.text, "ax"
@@ -36,7 +36,6 @@
 /**
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
  * @vmx:	struct vcpu_vmx *
- * @regs:	unsigned long * (to guest registers)
  * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
  *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
  *
@@ -61,22 +60,19 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	push %_ASM_ARG1
 
 	/* Save @flags for SPEC_CTRL handling */
-	push %_ASM_ARG3
-
-	/*
-	 * Save @regs, _ASM_ARG2 may be modified by vmx_update_host_rsp() and
-	 * @regs is needed after VM-Exit to save the guest's register values.
-	 */
 	push %_ASM_ARG2
 
-	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
-	mov %_ASM_ARG3B, %bl
+	/* Copy @flags to BL, _ASM_ARG2 is volatile. */
+	mov %_ASM_ARG2B, %bl
 
 	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
 	ALTERNATIVE "jmp .Lspec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL
 
+	/* Reload @vmx, _ASM_ARG1 may be modified by vmx_update_host_rsp().  */
+	mov WORD_SIZE(%_ASM_SP), %_ASM_DI
+
 	/*
 	 * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
 	 * host's, write the MSR.
@@ -85,7 +81,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * there must not be any returns or indirect branches between this code
 	 * and vmentry.
 	 */
-	mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
 	movl VMX_spec_ctrl(%_ASM_DI), %edi
 	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
 	cmp %edi, %esi
@@ -102,8 +97,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * an LFENCE to stop speculation from skipping the wrmsr.
 	 */
 
-	/* Load @regs to RAX. */
-	mov (%_ASM_SP), %_ASM_AX
+	/* Load @vmx to RAX. */
+	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
 	testb $VMX_RUN_VMRESUME, %bl
@@ -125,7 +120,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_R14(%_ASM_AX), %r14
 	mov VCPU_R15(%_ASM_AX), %r15
 #endif
-	/* Load guest RAX.  This kills the @regs pointer! */
+	/* Load guest RAX.  This kills the @vmx pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Check EFLAGS.ZF from 'testb' above */
@@ -163,8 +158,8 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	/* Temporarily save guest's RAX. */
 	push %_ASM_AX
 
-	/* Reload @regs to RAX. */
-	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
+	/* Reload @vmx to RAX. */
+	mov 2*WORD_SIZE(%_ASM_SP), %_ASM_AX
 
 	/* Save all guest registers, including RAX from the stack */
 	pop           VCPU_RAX(%_ASM_AX)
@@ -189,9 +184,6 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	xor %ebx, %ebx
 
 .Lclear_regs:
-	/* Discard @regs.  The register is irrelevant, it just can't be RBX. */
-	pop %_ASM_AX
-
 	/*
 	 * Clear all general purpose registers except RSP and RBX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 05a747c9a9ff..42cda7a5c009 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7084,8 +7084,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
 
-	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   flags);
+	vmx->fail = __vmx_vcpu_run(vmx, flags);
 
 	vcpu->arch.cr2 = native_read_cr2();
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..d90cdbea0e4c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -422,8 +422,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
-		    unsigned int flags);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned int flags);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
-- 
2.31.1


