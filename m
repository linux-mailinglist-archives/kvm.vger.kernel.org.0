Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD000260303
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgIGRlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:41:01 -0400
Received: from 8bytes.org ([81.169.241.247]:43586 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgIGNR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:17:59 -0400
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id B351B127E;
        Mon,  7 Sep 2020 15:17:05 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v7 46/72] x86/sev-es: Add Runtime #VC Exception Handler
Date:   Mon,  7 Sep 2020 15:15:47 +0200
Message-Id: <20200907131613.12703-47-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907131613.12703-1-joro@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add the handlers for #VC exceptions invoked at runtime.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/idtentry.h |   6 +
 arch/x86/kernel/idt.c           |  11 +-
 arch/x86/kernel/sev-es.c        | 246 +++++++++++++++++++++++++++++++-
 3 files changed, 255 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 5ce67113a761..3d2572760ce4 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -318,6 +318,7 @@ static __always_inline void __##func(struct pt_regs *regs)
  */
 #define DECLARE_IDTENTRY_VC(vector, func)				\
 	DECLARE_IDTENTRY_RAW_ERRORCODE(vector, func);			\
+	__visible noinstr void ist_##func(struct pt_regs *regs, unsigned long error_code);	\
 	__visible noinstr void safe_stack_##func(struct pt_regs *regs, unsigned long error_code)
 
 /**
@@ -608,6 +609,11 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_DB,	xenpv_exc_debug);
 /* #DF */
 DECLARE_IDTENTRY_DF(X86_TRAP_DF,	exc_double_fault);
 
+/* #VC */
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+DECLARE_IDTENTRY_VC(X86_TRAP_VC,	exc_vmm_communication);
+#endif
+
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_XENCB(X86_TRAP_OTHER,	exc_xen_hypervisor_callback);
 #endif
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 4bb4e3d6099e..e29a6c728001 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -229,11 +229,14 @@ static const __initconst struct idt_data early_pf_idts[] = {
  * cpu_init() when the TSS has been initialized.
  */
 static const __initconst struct idt_data ist_idts[] = {
-	ISTG(X86_TRAP_DB,	asm_exc_debug,		IST_INDEX_DB),
-	ISTG(X86_TRAP_NMI,	asm_exc_nmi,		IST_INDEX_NMI),
-	ISTG(X86_TRAP_DF,	asm_exc_double_fault,	IST_INDEX_DF),
+	ISTG(X86_TRAP_DB,	asm_exc_debug,			IST_INDEX_DB),
+	ISTG(X86_TRAP_NMI,	asm_exc_nmi,			IST_INDEX_NMI),
+	ISTG(X86_TRAP_DF,	asm_exc_double_fault,		IST_INDEX_DF),
 #ifdef CONFIG_X86_MCE
-	ISTG(X86_TRAP_MC,	asm_exc_machine_check,	IST_INDEX_MCE),
+	ISTG(X86_TRAP_MC,	asm_exc_machine_check,		IST_INDEX_MCE),
+#endif
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	ISTG(X86_TRAP_VC,	asm_exc_vmm_communication,	IST_INDEX_VC),
 #endif
 };
 
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 69c55f0fdf6a..cb2f6236a98e 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -7,9 +7,12 @@
  * Author: Joerg Roedel <jroedel@suse.de>
  */
 
+#define pr_fmt(fmt)	"SEV-ES: " fmt
+
 #include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/percpu-defs.h>
 #include <linux/mem_encrypt.h>
+#include <linux/lockdep.h>
 #include <linux/printk.h>
 #include <linux/mm_types.h>
 #include <linux/set_memory.h>
@@ -22,8 +25,8 @@
 #include <asm/insn-eval.h>
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
-#include <asm/trap_pf.h>
-#include <asm/trapnr.h>
+#include <asm/realmode.h>
+#include <asm/traps.h>
 #include <asm/svm.h>
 
 /* For early boot hypervisor communication in SEV-ES enabled guests */
@@ -48,11 +51,43 @@ struct sev_es_runtime_data {
 	 * interrupted stack in the #VC entry code.
 	 */
 	char fallback_stack[EXCEPTION_STKSZ] __aligned(PAGE_SIZE);
+
+	/*
+	 * Reserve one page per CPU as backup storage for the unencrypted GHCB.
+	 * It is needed when an NMI happens while the #VC handler uses the real
+	 * GHCB, and the NMI handler itself is causing another #VC exception. In
+	 * that case the GHCB content of the first handler needs to be backed up
+	 * and restored.
+	 */
+	struct ghcb backup_ghcb;
+
+	/*
+	 * Mark the per-cpu GHCBs as in-use to detect nested #VC exceptions.
+	 * There is no need for it to be atomic, because nothing is written to
+	 * the GHCB between the read and the write of ghcb_active. So it is safe
+	 * to use it when a nested #VC exception happens before the write.
+	 *
+	 * This is necessary for example in the #VC->NMI->#VC case when the NMI
+	 * happens while the first #VC handler uses the GHCB. When the NMI code
+	 * raises a second #VC handler it might overwrite the contents of the
+	 * GHCB written by the first handler. To avoid this the content of the
+	 * GHCB is saved and restored when the GHCB is detected to be in use
+	 * already.
+	 */
+	bool ghcb_active;
+	bool backup_ghcb_active;
+};
+
+struct ghcb_state {
+	struct ghcb *ghcb;
 };
 
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 
+/* Needed in vc_early_forward_exception */
+void do_early_exception(struct pt_regs *regs, int trapnr);
+
 static void __init setup_vc_stacks(int cpu)
 {
 	struct sev_es_runtime_data *data;
@@ -123,8 +158,52 @@ void noinstr __sev_es_ist_exit(void)
 	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *(unsigned long *)ist);
 }
 
-/* Needed in vc_early_forward_exception */
-void do_early_exception(struct pt_regs *regs, int trapnr);
+static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
+{
+	struct sev_es_runtime_data *data;
+	struct ghcb *ghcb;
+
+	data = this_cpu_read(runtime_data);
+	ghcb = &data->ghcb_page;
+
+	if (unlikely(data->ghcb_active)) {
+		/* GHCB is already in use - save its contents */
+
+		if (unlikely(data->backup_ghcb_active))
+			return NULL;
+
+		/* Mark backup_ghcb active before writing to it */
+		data->backup_ghcb_active = true;
+
+		state->ghcb = &data->backup_ghcb;
+
+		/* Backup GHCB content */
+		*state->ghcb = *ghcb;
+	} else {
+		state->ghcb = NULL;
+		data->ghcb_active = true;
+	}
+
+	return ghcb;
+}
+
+static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+{
+	struct sev_es_runtime_data *data;
+	struct ghcb *ghcb;
+
+	data = this_cpu_read(runtime_data);
+	ghcb = &data->ghcb_page;
+
+	if (state->ghcb) {
+		/* Restore GHCB from Backup */
+		*ghcb = *state->ghcb;
+		data->backup_ghcb_active = false;
+		state->ghcb = NULL;
+	} else {
+		data->ghcb_active = false;
+	}
+}
 
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
@@ -316,6 +395,9 @@ static void __init init_ghcb(int cpu)
 		panic("Can not map GHCBs unencrypted");
 
 	memset(&data->ghcb_page, 0, sizeof(data->ghcb_page));
+
+	data->ghcb_active = false;
+	data->backup_ghcb_active = false;
 }
 
 void __init sev_es_init_vc_handling(void)
@@ -336,6 +418,9 @@ void __init sev_es_init_vc_handling(void)
 		init_ghcb(cpu);
 		setup_vc_stacks(cpu);
 	}
+
+	/* Secondary CPUs use the runtime #VC handler */
+	initial_vc_handler = (unsigned long)safe_stack_exc_vmm_communication;
 }
 
 static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
@@ -366,6 +451,159 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	return result;
 }
 
+static __always_inline void vc_forward_exception(struct es_em_ctxt *ctxt)
+{
+	long error_code = ctxt->fi.error_code;
+	int trapnr = ctxt->fi.vector;
+
+	ctxt->regs->orig_ax = ctxt->fi.error_code;
+
+	switch (trapnr) {
+	case X86_TRAP_GP:
+		exc_general_protection(ctxt->regs, error_code);
+		break;
+	case X86_TRAP_UD:
+		exc_invalid_op(ctxt->regs);
+		break;
+	default:
+		pr_emerg("Unsupported exception in #VC instruction emulation - can't continue\n");
+		BUG();
+	}
+}
+
+static __always_inline bool on_vc_fallback_stack(struct pt_regs *regs)
+{
+	unsigned long sp = (unsigned long)regs;
+
+	return (sp >= __this_cpu_ist_bottom_va(VC2) && sp < __this_cpu_ist_top_va(VC2));
+}
+
+/*
+ * Main #VC exception handler. It is called when the entry code was able to
+ * switch off the IST to a safe kernel stack.
+ *
+ * With the current implementation it is always possible to switch to a safe
+ * stack because #VC exceptions only happen at known places, like intercepted
+ * instructions or accesses to MMIO areas/IO ports. They can also happen with
+ * code instrumentation when the hypervisor intercepts #DB, but the critical
+ * paths are forbidden to be instrumented, so #DB exceptions currently also
+ * only happen in safe places.
+ */
+DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
+{
+	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result result;
+	struct ghcb *ghcb;
+
+	lockdep_assert_irqs_disabled();
+	instrumentation_begin();
+
+	/*
+	 * This is invoked through an interrupt gate, so IRQs are disabled. The
+	 * code below might walk page-tables for user or kernel addresses, so
+	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
+	 */
+
+	ghcb = sev_es_get_ghcb(&state);
+	if (!ghcb) {
+		/*
+		 * Mark GHCBs inactive so that panic() is able to print the
+		 * message.
+		 */
+		data->ghcb_active        = false;
+		data->backup_ghcb_active = false;
+
+		panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
+	}
+
+	vc_ghcb_invalidate(ghcb);
+	result = vc_init_em_ctxt(&ctxt, regs, error_code);
+
+	if (result == ES_OK)
+		result = vc_handle_exitcode(&ctxt, ghcb, error_code);
+
+	sev_es_put_ghcb(&state);
+
+	/* Done - now check the result */
+	switch (result) {
+	case ES_OK:
+		vc_finish_insn(&ctxt);
+		break;
+	case ES_UNSUPPORTED:
+		pr_err_ratelimited("Unsupported exit-code 0x%02lx in early #VC exception (IP: 0x%lx)\n",
+				   error_code, regs->ip);
+		goto fail;
+	case ES_VMM_ERROR:
+		pr_err_ratelimited("Failure in communication with VMM (exit-code 0x%02lx IP: 0x%lx)\n",
+				   error_code, regs->ip);
+		goto fail;
+	case ES_DECODE_FAILED:
+		pr_err_ratelimited("Failed to decode instruction (exit-code 0x%02lx IP: 0x%lx)\n",
+				   error_code, regs->ip);
+		goto fail;
+	case ES_EXCEPTION:
+		vc_forward_exception(&ctxt);
+		break;
+	case ES_RETRY:
+		/* Nothing to do */
+		break;
+	default:
+		pr_emerg("Unknown result in %s():%d\n", __func__, result);
+		/*
+		 * Emulating the instruction which caused the #VC exception
+		 * failed - can't continue so print debug information
+		 */
+		BUG();
+	}
+
+out:
+	instrumentation_end();
+
+	return;
+
+fail:
+	if (user_mode(regs)) {
+		/*
+		 * Do not kill the machine if user-space triggered the
+		 * exception. Send SIGBUS instead and let user-space deal with
+		 * it.
+		 */
+		force_sig_fault(SIGBUS, BUS_OBJERR, (void __user *)0);
+	} else {
+		pr_emerg("PANIC: Unhandled #VC exception in kernel space (result=%d)\n",
+			 result);
+
+		/* Show some debug info */
+		show_regs(regs);
+
+		/* Ask hypervisor to sev_es_terminate */
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+		/* If that fails and we get here - just panic */
+		panic("Returned from Terminate-Request to Hypervisor\n");
+	}
+
+	goto out;
+}
+
+/* This handler runs on the #VC fall-back stack. It can cause further #VC exceptions */
+DEFINE_IDTENTRY_VC_IST(exc_vmm_communication)
+{
+	instrumentation_begin();
+	panic("Can't handle #VC exception from unsupported context\n");
+	instrumentation_end();
+}
+
+DEFINE_IDTENTRY_VC(exc_vmm_communication)
+{
+	if (likely(!on_vc_fallback_stack(regs)))
+		safe_stack_exc_vmm_communication(regs, error_code);
+	else
+		ist_exc_vmm_communication(regs, error_code);
+}
+
 bool __init handle_vc_boot_ghcb(struct pt_regs *regs)
 {
 	unsigned long exit_code = regs->orig_ax;
-- 
2.28.0

