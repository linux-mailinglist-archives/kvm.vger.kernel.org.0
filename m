Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776B81BC308
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgD1PVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:21:17 -0400
Received: from 8bytes.org ([81.169.241.247]:37386 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgD1PSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:12 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1B858F2D; Tue, 28 Apr 2020 17:17:51 +0200 (CEST)
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
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 47/75] x86/sev-es: Add Runtime #VC Exception Handler
Date:   Tue, 28 Apr 2020 17:16:57 +0200
Message-Id: <20200428151725.31091-48-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add the handler for #VC exceptions invoked at runtime.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/entry/entry_64.S    |   4 +
 arch/x86/include/asm/traps.h |   7 ++
 arch/x86/kernel/idt.c        |   4 +-
 arch/x86/kernel/sev-es.c     | 167 ++++++++++++++++++++++++++++++++++-
 4 files changed, 180 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 0e9504fabe52..4c392eb2f063 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1210,6 +1210,10 @@ idtentry async_page_fault	do_async_page_fault	has_error_code=1	read_cr2=1
 idtentry machine_check		do_mce			has_error_code=0	paranoid=1
 #endif
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+idtentry vmm_communication	do_vmm_communication	has_error_code=1	paranoid=1 shift_ist=IST_INDEX_VC ist_offset=VC_STACK_OFFSET
+#endif
+
 /*
  * Save all registers in pt_regs, and switch gs if needed.
  * Use slow, but surefire "are we in kernel?" check.
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 104991c05425..37f6e86ac53a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -35,6 +35,9 @@ asmlinkage void alignment_check(void);
 #ifdef CONFIG_X86_MCE
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+asmlinkage void vmm_communication(void);
+#endif
 asmlinkage void simd_coprocessor_error(void);
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_XEN_PV)
@@ -83,6 +86,10 @@ dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *regs, long error_co
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code);
 dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code);
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *regs, long error_code);
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+dotraplinkage void do_vmm_communication_error(struct pt_regs *regs,
+					      long error_code);
+#endif
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code);
 #endif
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 135d208a2d38..e32cc5f3fa94 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -88,7 +88,6 @@ static const __initconst struct idt_data def_idts[] = {
 #ifdef CONFIG_X86_MCE
 	INTG(X86_TRAP_MC,		&machine_check),
 #endif
-
 	SYSG(X86_TRAP_OF,		overflow),
 #if defined(CONFIG_IA32_EMULATION)
 	SYSG(IA32_SYSCALL_VECTOR,	entry_INT80_compat),
@@ -185,6 +184,9 @@ static const __initconst struct idt_data ist_idts[] = {
 #ifdef CONFIG_X86_MCE
 	ISTG(X86_TRAP_MC,	&machine_check,	IST_INDEX_MCE),
 #endif
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	ISTG(X86_TRAP_VC,	vmm_communication, IST_INDEX_VC),
+#endif
 };
 
 /*
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index a4fa7f351bf2..bc3a58427028 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -10,6 +10,7 @@
 #include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/percpu-defs.h>
 #include <linux/mem_encrypt.h>
+#include <linux/lockdep.h>
 #include <linux/printk.h>
 #include <linux/mm_types.h>
 #include <linux/set_memory.h>
@@ -25,7 +26,7 @@
 #include <asm/insn-eval.h>
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
-#include <asm/trap_defs.h>
+#include <asm/traps.h>
 #include <asm/svm.h>
 
 /* For early boot hypervisor communication in SEV-ES enabled guests */
@@ -46,10 +47,26 @@ struct sev_es_runtime_data {
 
 	/* Physical storage for the per-cpu IST stacks of the #VC handler */
 	struct vmm_exception_stacks vc_stacks __aligned(PAGE_SIZE);
+
+	/* Reserve on page per CPU as backup storage for the unencrypted GHCB */
+	struct ghcb backup_ghcb;
+
+	/*
+	 * Mark the per-cpu GHCBs as in-use to detect nested #VC exceptions.
+	 * There is no need for it to be atomic, because nothing is written to
+	 * the GHCB between the read and the write of ghcb_active. So it is safe
+	 * to use it when a nested #VC exception happens before the write.
+	 */
+	bool ghcb_active;
+	bool backup_ghcb_active;
 };
 
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 
+struct ghcb_state {
+	struct ghcb *ghcb;
+};
+
 /*
  * Shift/Unshift the IST entry for the #VC handler during
  * nmi_enter()/nmi_exit().  This is needed when an NMI hits in the #VC handlers
@@ -70,6 +87,53 @@ void sev_es_nmi_exit(void)
 	tss->x86_tss.ist[IST_INDEX_VC] += VC_STACK_OFFSET;
 }
 
+static struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
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
+static void sev_es_put_ghcb(struct ghcb_state *state)
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
+
 /* Needed in vc_early_vc_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
@@ -263,6 +327,9 @@ static void __init sev_es_init_ghcb(int cpu)
 		panic("Can not map GHCBs unencrypted");
 
 	memset(&data->ghcb_page, 0, sizeof(data->ghcb_page));
+
+	data->ghcb_active = false;
+	data->backup_ghcb_active = false;
 }
 
 static void __init init_vc_stack_names(void)
@@ -367,6 +434,104 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	return result;
 }
 
+static void vc_forward_exception(struct es_em_ctxt *ctxt)
+{
+	long error_code = ctxt->fi.error_code;
+	int trapnr = ctxt->fi.vector;
+
+	ctxt->regs->orig_ax = ctxt->fi.error_code;
+
+	switch (trapnr) {
+	case X86_TRAP_GP:
+		do_general_protection(ctxt->regs, error_code);
+		break;
+	case X86_TRAP_UD:
+		do_invalid_op(ctxt->regs, 0);
+		break;
+	default:
+		pr_emerg("ERROR: Unsupported exception in #VC instruction emulation - can't continue\n");
+		BUG();
+	}
+}
+
+dotraplinkage void do_vmm_communication(struct pt_regs *regs,
+					unsigned long exit_code)
+{
+	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result result;
+	struct ghcb *ghcb;
+
+	lockdep_assert_irqs_disabled();
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
+	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+
+	if (result == ES_OK)
+		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
+
+	sev_es_put_ghcb(&state);
+
+	/* Done - now check the result */
+	switch (result) {
+	case ES_OK:
+		vc_finish_insn(&ctxt);
+		break;
+	case ES_UNSUPPORTED:
+		pr_emerg("PANIC: Unsupported exit-code 0x%02lx in early #VC exception (IP: 0x%lx)\n",
+			 exit_code, regs->ip);
+		goto fail;
+	case ES_VMM_ERROR:
+		pr_emerg("PANIC: Failure in communication with VMM (exit-code 0x%02lx IP: 0x%lx)\n",
+			 exit_code, regs->ip);
+		goto fail;
+	case ES_DECODE_FAILED:
+		pr_emerg("PANIC: Failed to decode instruction (exit-code 0x%02lx IP: 0x%lx)\n",
+			 exit_code, regs->ip);
+		goto fail;
+	case ES_EXCEPTION:
+		vc_forward_exception(&ctxt);
+		break;
+	case ES_RETRY:
+		/* Nothing to do */
+		break;
+	default:
+		pr_emerg("PANIC: Unknown result in %s():%d\n", __func__, result);
+		/*
+		 * Emulating the instruction which caused the #VC exception
+		 * failed - can't continue so print debug information
+		 */
+		BUG();
+	}
+
+	return;
+
+fail:
+	show_regs(regs);
+
+	while (true)
+		halt();
+}
+
 bool __init vc_boot_ghcb(struct pt_regs *regs)
 {
 	unsigned long exit_code = regs->orig_ax;
-- 
2.17.1

