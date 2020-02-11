Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99B51590B0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgBKNyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:54:05 -0500
Received: from 8bytes.org ([81.169.241.247]:52450 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbgBKNxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:31 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 42FC6EB1; Tue, 11 Feb 2020 14:53:18 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 62/62] x86/sev-es: Add NMI state tracking
Date:   Tue, 11 Feb 2020 14:52:56 +0100
Message-Id: <20200211135256.24617-63-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Keep NMI state in SEV-ES code so the kernel can re-enable NMIs for the
vCPU when it reaches IRET.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/entry/entry_64.S       | 48 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/sev-es.h   | 27 +++++++++++++++++++
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kernel/nmi.c           |  8 ++++++
 arch/x86/kernel/sev-es.c        | 28 ++++++++++++++++++-
 5 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 729876d368c5..355470b36896 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -38,6 +38,7 @@
 #include <asm/export.h>
 #include <asm/frame.h>
 #include <asm/nospec-branch.h>
+#include <asm/sev-es.h>
 #include <linux/err.h>
 
 #include "calling.h"
@@ -629,6 +630,13 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
 	ud2
 1:
 #endif
+
+	/*
+	 * This code path is used by the NMI handler, so check if NMIs
+	 * need to be re-enabled when running as an SEV-ES guest.
+	 */
+	SEV_ES_IRET_CHECK
+
 	POP_REGS pop_rdi=0
 
 	/*
@@ -1474,6 +1482,8 @@ SYM_CODE_START(nmi)
 	movq	$-1, %rsi
 	call	do_nmi
 
+	SEV_ES_NMI_COMPLETE
+
 	/*
 	 * Return back to user mode.  We must *not* do the normal exit
 	 * work, because we don't want to enable interrupts.
@@ -1599,6 +1609,7 @@ nested_nmi_out:
 	popq	%rdx
 
 	/* We are returning to kernel mode, so this cannot result in a fault. */
+	SEV_ES_NMI_COMPLETE
 	iretq
 
 first_nmi:
@@ -1687,6 +1698,12 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	do_nmi
 
+	/*
+	 * When running as an SEV-ES guest, jump to the SEV-ES NMI IRET
+	 * path.
+	 */
+	SEV_ES_NMI_COMPLETE
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
@@ -1715,6 +1732,9 @@ nmi_restore:
 	std
 	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
 
+nmi_return:
+	UNWIND_HINT_IRET_REGS
+
 	/*
 	 * iretq reads the "iret" frame and exits the NMI stack in a
 	 * single instruction.  We are returning to kernel mode, so this
@@ -1724,6 +1744,34 @@ nmi_restore:
 	iretq
 SYM_CODE_END(nmi)
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+SYM_CODE_START(sev_es_iret_user)
+	UNWIND_HINT_IRET_REGS offset=8
+	/*
+	 * The kernel jumps here directly from
+	 * swapgs_restore_regs_and_return_to_usermode. %rsp points already to
+	 * trampoline stack, but %cr3 is still from kernel. User-regs are live
+	 * except %rdi. Switch to user CR3, restore user %rdi and user gs_base
+	 * and single-step over IRET
+	 */
+	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
+	popq	%rdi
+	SWAPGS
+	/*
+	 * Enable single-stepping and execute IRET. When IRET is
+	 * finished the resulting #DB exception will cause a #VC
+	 * exception to be raised. The #VC exception handler will send a
+	 * NMI-complete message to the hypervisor to re-open the NMI
+	 * window.
+	 */
+sev_es_iret_kernel:
+	pushf
+	btsq $X86_EFLAGS_TF_BIT, (%rsp)
+	popf
+	iretq
+SYM_CODE_END(sev_es_iret_user)
+#endif
+
 #ifndef CONFIG_IA32_EMULATION
 /*
  * This handles SYSCALL from 32-bit code.  There is no way to program
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index a4d7574c5c6a..22f45782149e 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -8,6 +8,8 @@
 #ifndef __ASM_ENCRYPTED_STATE_H
 #define __ASM_ENCRYPTED_STATE_H
 
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <asm/insn.h>
 
@@ -82,11 +84,36 @@ struct real_mode_header;
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
+void sev_es_nmi_enter(void);
 #else /* CONFIG_AMD_MEM_ENCRYPT */
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
 {
 	return 0;
 }
+static inline void sev_es_nmi_enter(void) { }
+#endif /* CONFIG_AMD_MEM_ENCRYPT*/
+
+#else /* !__ASSEMBLY__ */
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+#define SEV_ES_NMI_COMPLETE		\
+	ALTERNATIVE	"", "callq sev_es_nmi_complete", X86_FEATURE_SEV_ES_GUEST
+
+.macro	SEV_ES_IRET_CHECK
+	ALTERNATIVE	"jmp	.Lend_\@", "", X86_FEATURE_SEV_ES_GUEST
+	movq	PER_CPU_VAR(sev_es_in_nmi), %rdi
+	testq	%rdi, %rdi
+	jz	.Lend_\@
+	callq	sev_es_nmi_complete
+.Lend_\@:
+.endm
+
+#else  /* CONFIG_AMD_MEM_ENCRYPT */
+#define	SEV_ES_NMI_RETURN
+.macro	SEV_ES_IRET_CHECK
+.endm
 #endif /* CONFIG_AMD_MEM_ENCRYPT*/
 
+#endif /* __ASSEMBLY__ */
+
 #endif
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 20a05839dd9a..0f837339db66 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -84,6 +84,7 @@
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
 #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
+#define SVM_VMGEXIT_NMI_COMPLETE		0x80000003
 #define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 54c21d6abd5a..7312a6d4d50f 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -37,6 +37,7 @@
 #include <asm/reboot.h>
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
+#include <asm/sev-es.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -510,6 +511,13 @@ NOKPROBE_SYMBOL(is_debug_stack);
 dotraplinkage notrace void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	/*
+	 * For SEV-ES the kernel needs to track whether NMIs are blocked until
+	 * IRET is reached, even when the CPU is offline.
+	 */
+	if (sev_es_active())
+		sev_es_nmi_enter();
+
 	if (IS_ENABLED(CONFIG_SMP) && cpu_is_offline(smp_processor_id()))
 		return;
 
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 755708f72824..c90d250c767e 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -36,6 +36,7 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  */
 struct ghcb __initdata *boot_ghcb;
 static DEFINE_PER_CPU(unsigned long, cached_dr7) = DR7_RESET_VALUE;
+static DEFINE_PER_CPU(bool, sev_es_in_nmi) = false;
 /* Needed before per-cpu access is set up */
 static unsigned long early_dr7 = DR7_RESET_VALUE;
 
@@ -144,6 +145,28 @@ static phys_addr_t es_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
+void sev_es_nmi_enter(void)
+{
+	this_cpu_write(sev_es_in_nmi, true);
+}
+
+void sev_es_nmi_complete(void)
+{
+	struct ghcb *ghcb;
+
+	ghcb = this_cpu_ptr(&ghcb_page);
+
+	ghcb_invalidate(ghcb);
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_NMI_COMPLETE);
+	ghcb_set_sw_exit_info_1(ghcb, 0);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	write_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	this_cpu_write(sev_es_in_nmi, false);
+}
+
 static u64 sev_es_get_jump_table_addr(void)
 {
 	unsigned long flags;
@@ -485,7 +508,10 @@ static enum es_result handle_vmmcall(struct ghcb *ghcb,
 static enum es_result handle_db_exception(struct ghcb *ghcb,
 					  struct es_em_ctxt *ctxt)
 {
-	do_debug(ctxt->regs, 0);
+	if (this_cpu_read(sev_es_in_nmi))
+		sev_es_nmi_complete();
+	else
+		do_debug(ctxt->regs, 0);
 
 	/* Exception event, do not advance RIP */
 	return ES_RETRY;
-- 
2.17.1

