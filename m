Return-Path: <kvm+bounces-9869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D708678BB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB3FB2933F3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3567A12AAFF;
	Mon, 26 Feb 2024 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKDaXNJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5612EBE4;
	Mon, 26 Feb 2024 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958099; cv=none; b=d4ttrkBHZz8M8kSTc4ahwu6oOv+N/jIQyDGTyUNl0i29efuJnd6rcPI/zBLEuxcxs9I78+VsEmnsH/uT8CYf8PB5L8NhFHMJ1DN4psYJ5YmowhkXOBlxdWwXdBdC0SuElPNGsKrQDqSWHckMhThC4+LqsBFMYRl9T6iVN8hGRsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958099; c=relaxed/simple;
	bh=v3oWR+P39CKvhNF+pOmX56rjrg+9Z/2sF3YtAzYOJl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qYHTNQGD6VV5n5htWP/OSITzCPlOaLnYhCxhuo+Q6/mqsqj9fDuC6ibJoKW+ZqXFBFEm7QESJ+AGGYdHBDhu2HhGaOB8Matz0q74C6tLhMOadUh89IONSD/iHc64/6O28y+jMy/H9Cl/cwFLh280b6m2n67Z5Ul2rUJBgg/jaiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKDaXNJq; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e4f49c5632so593126b3a.0;
        Mon, 26 Feb 2024 06:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958097; x=1709562897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvdApW2xM6ZV/9SNM/xsyM+VYex7z3fSCZ3wCP7fJoU=;
        b=bKDaXNJq7EZijQfePY8pdbChonxnJZrUtjA8Eg6xXe7t3LL3/2HtTyKrnxBuUBFjB/
         oWpAkCamh1/obaWlHfXuL/lbAQi4LRxYlHpBdVmU78Wm7WLdKu99Js9Ehqs8POIS9ziM
         2Xf9K/reTpKvk5IJBvGBZYbdYknJlsupmVExwdXH+mKh8Z4FVXItg8hq9veOz6cV2CPI
         DsAmm7P+47UPU62opQNM9w2V1E0+BiX9ECD8Q6Y3x9li1OP32xEUx/kl7VClvvfL89pJ
         NXrEX5EV1iTPL4LSKnhP7txqWnyTDdsJ2/JhU6Q+uFMtlAoZdK/9nnO7IKkr0T+Ih9hh
         ktGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958097; x=1709562897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvdApW2xM6ZV/9SNM/xsyM+VYex7z3fSCZ3wCP7fJoU=;
        b=L4WDLmKr/0XylKU/9bH7fVYR/FWb/OcwR0HHK1LOwC2NgGKiR9AllFwHteY3pi9w2c
         qRQAm2Ds2VES7dHYdU1kUYW2joWS80tESUPSxWvOPFxnkGqG1JJqzYNKr87vqqUxnYYE
         t5IImaCN4IZt0MWAIg6GBCM4rtj1kaVB8HqaG0gukYu3GPUgYD2o0cU5J0voZLRYpu1e
         JEMSpwtKKyURVJht1BaPE48D/aas8NTyPj4zuft8HIPimI9xEdCAalKhQIr92G/6QBZg
         m6nFZ5CzUusesQZ9kTXI4MDsB0Qc5uEvK4lbX38mjrSlBUSMC5EwuushxvZbJ4+9c7Lh
         SZCA==
X-Forwarded-Encrypted: i=1; AJvYcCXewQWiTFJTUbU8uaC8B7JsGESz/WbFOo/vYGL6/4Cx86QlzR0H7w1N+5tAqJ8w+N8oQFXxnFu4gakY8qmvaXScWCWE
X-Gm-Message-State: AOJu0Yw5UA/p5XpUEKFFT5Cpvp1lBsmvxm6sgm+s3Qg9MOYoes7xeo00
	VGySRCKtdW0bPzlPLYR9OB3NArdjJlXKuOnlH1tP+y6fCfYP3TNy12gpKXHJ
X-Google-Smtp-Source: AGHT+IF1HWQpwmNIokh+etIWHwc/ZM1A5RDLvvVbDiJng+VTsHDOjSVxGJxiTaxlg0eYbwbQ7MaxYw==
X-Received: by 2002:a05:6a20:d80f:b0:1a0:a882:950c with SMTP id iv15-20020a056a20d80f00b001a0a882950cmr7295333pzb.18.1708958096561;
        Mon, 26 Feb 2024 06:34:56 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902dcc500b001dc6b99af70sm4008687pll.108.2024.02.26.06.34.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:56 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 06/73] KVM: x86: Move VMX interrupt/nmi handling into kvm.ko
Date: Mon, 26 Feb 2024 22:35:23 +0800
Message-Id: <20240226143630.33643-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Similar to VMX, hardware interrupts/NMI during guest running in PVM will
trigger VM exit and should be handled by host interrupt/NMI handlers.
Therefore, move VMX interrupt/NMI handling into kvm.ko for common usage.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Co-developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/idtentry.h | 12 ++++----
 arch/x86/kernel/nmi.c           |  8 +++---
 arch/x86/kvm/Makefile           |  2 +-
 arch/x86/kvm/host_entry.S       | 50 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmenter.S      | 43 ----------------------------
 arch/x86/kvm/vmx/vmx.c          | 14 ++-------
 arch/x86/kvm/x86.c              |  3 ++
 arch/x86/kvm/x86.h              | 18 ++++++++++++
 8 files changed, 85 insertions(+), 65 deletions(-)
 create mode 100644 arch/x86/kvm/host_entry.S

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 13639e57e1f8..8aab0b50431a 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -586,14 +586,14 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 
 /* NMI */
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_KVM)
 /*
- * Special entry point for VMX which invokes this on the kernel stack, even for
- * 64-bit, i.e. without using an IST.  asm_exc_nmi() requires an IST to work
- * correctly vs. the NMI 'executing' marker.  Used for 32-bit kernels as well
- * to avoid more ifdeffery.
+ * Special entry point for VMX/PVM which invokes this on the kernel stack, even
+ * for 64-bit, i.e. without using an IST.  asm_exc_nmi() requires an IST to
+ * work correctly vs. the NMI 'executing' marker.  Used for 32-bit kernels as
+ * well to avoid more ifdeffery.
  */
-DECLARE_IDTENTRY(X86_TRAP_NMI,		exc_nmi_kvm_vmx);
+DECLARE_IDTENTRY(X86_TRAP_NMI,		exc_nmi_kvm);
 #endif
 
 DECLARE_IDTENTRY_NMI(X86_TRAP_NMI,	exc_nmi);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 17e955ab69fe..265e6b38cc58 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -568,13 +568,13 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 		mds_user_clear_cpu_buffers();
 }
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
-DEFINE_IDTENTRY_RAW(exc_nmi_kvm_vmx)
+#if IS_ENABLED(CONFIG_KVM)
+DEFINE_IDTENTRY_RAW(exc_nmi_kvm)
 {
 	exc_nmi(regs);
 }
-#if IS_MODULE(CONFIG_KVM_INTEL)
-EXPORT_SYMBOL_GPL(asm_exc_nmi_kvm_vmx);
+#if IS_MODULE(CONFIG_KVM)
+EXPORT_SYMBOL_GPL(asm_exc_nmi_kvm);
 #endif
 #endif
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..97bad203b1b1 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,7 +9,7 @@ endif
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
+kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o host_entry.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
 			   mmu/spte.o
diff --git a/arch/x86/kvm/host_entry.S b/arch/x86/kvm/host_entry.S
new file mode 100644
index 000000000000..6bdf0df06eb0
--- /dev/null
+++ b/arch/x86/kvm/host_entry.S
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/nospec-branch.h>
+#include <asm/segment.h>
+
+.macro KVM_DO_EVENT_IRQOFF call_insn call_target
+	/*
+	 * Unconditionally create a stack frame, getting the correct RSP on the
+	 * stack (for x86-64) would take two instructions anyways, and RBP can
+	 * be used to restore RSP to make objtool happy (see below).
+	 */
+	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
+	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
+	 */
+	and  $-16, %rsp
+	push $__KERNEL_DS
+	push %rbp
+#endif
+	pushf
+	push $__KERNEL_CS
+	\call_insn \call_target
+
+	/*
+	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
+	 * the correct value.  objtool doesn't know the callee will IRET and,
+	 * without the explicit restore, thinks the stack is getting walloped.
+	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
+	 */
+	mov %_ASM_BP, %_ASM_SP
+	pop %_ASM_BP
+	RET
+.endm
+
+.section .noinstr.text, "ax"
+
+SYM_FUNC_START(kvm_do_host_nmi_irqoff)
+	KVM_DO_EVENT_IRQOFF call asm_exc_nmi_kvm
+SYM_FUNC_END(kvm_do_host_nmi_irqoff)
+
+.section .text, "ax"
+
+SYM_FUNC_START(kvm_do_host_interrupt_irqoff)
+	KVM_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
+SYM_FUNC_END(kvm_do_host_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 906ecd001511..12b7b99a9dd8 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -31,39 +31,6 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
-.macro VMX_DO_EVENT_IRQOFF call_insn call_target
-	/*
-	 * Unconditionally create a stack frame, getting the correct RSP on the
-	 * stack (for x86-64) would take two instructions anyways, and RBP can
-	 * be used to restore RSP to make objtool happy (see below).
-	 */
-	push %_ASM_BP
-	mov %_ASM_SP, %_ASM_BP
-
-#ifdef CONFIG_X86_64
-	/*
-	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
-	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
-	 */
-	and  $-16, %rsp
-	push $__KERNEL_DS
-	push %rbp
-#endif
-	pushf
-	push $__KERNEL_CS
-	\call_insn \call_target
-
-	/*
-	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
-	 * the correct value.  objtool doesn't know the callee will IRET and,
-	 * without the explicit restore, thinks the stack is getting walloped.
-	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
-	 */
-	mov %_ASM_BP, %_ASM_SP
-	pop %_ASM_BP
-	RET
-.endm
-
 .section .noinstr.text, "ax"
 
 /**
@@ -299,10 +266,6 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 
 SYM_FUNC_END(__vmx_vcpu_run)
 
-SYM_FUNC_START(vmx_do_nmi_irqoff)
-	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
-SYM_FUNC_END(vmx_do_nmi_irqoff)
-
 #ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
 /**
@@ -354,9 +317,3 @@ SYM_FUNC_START(vmread_error_trampoline)
 	RET
 SYM_FUNC_END(vmread_error_trampoline)
 #endif
-
-.section .text, "ax"
-
-SYM_FUNC_START(vmx_do_interrupt_irqoff)
-	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
-SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..fca47304506e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6920,9 +6920,6 @@ static void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_irqoff(unsigned long entry);
-void vmx_do_nmi_irqoff(void);
-
 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -6968,9 +6965,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
-	kvm_after_interrupt(vcpu);
+	kvm_do_interrupt_irqoff(vcpu, gate_offset(desc));
 
 	vcpu->arch.at_instruction_boundary = true;
 }
@@ -7260,11 +7255,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
-	    is_nmi(vmx_get_intr_info(vcpu))) {
-		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
-		kvm_after_interrupt(vcpu);
-	}
+	    is_nmi(vmx_get_intr_info(vcpu)))
+		kvm_do_nmi_irqoff(vcpu);
 
 out:
 	guest_state_exit_irqoff();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35ad6dd5eaf6..96f3913f7fc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13784,6 +13784,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+EXPORT_SYMBOL_GPL(kvm_do_host_nmi_irqoff);
+EXPORT_SYMBOL_GPL(kvm_do_host_interrupt_irqoff);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5184fde1dc54..4d1430f8874b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -491,6 +491,24 @@ static inline void kvm_machine_check(void)
 #endif
 }
 
+void kvm_do_host_nmi_irqoff(void);
+void kvm_do_host_interrupt_irqoff(unsigned long entry);
+
+static __always_inline void kvm_do_nmi_irqoff(struct kvm_vcpu *vcpu)
+{
+	kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+	kvm_do_host_nmi_irqoff();
+	kvm_after_interrupt(vcpu);
+}
+
+static inline void kvm_do_interrupt_irqoff(struct kvm_vcpu *vcpu,
+					   unsigned long entry)
+{
+	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
+	kvm_do_host_interrupt_irqoff(entry);
+	kvm_after_interrupt(vcpu);
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.19.1.6.gb485710b


