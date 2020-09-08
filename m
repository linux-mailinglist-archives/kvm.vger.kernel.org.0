Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C7D260F92
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 12:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgIHKY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 06:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgIHKY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 06:24:26 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38433C061573;
        Tue,  8 Sep 2020 03:24:24 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 328E0344; Tue,  8 Sep 2020 12:24:18 +0200 (CEST)
Date:   Tue, 8 Sep 2020 12:24:16 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v7.1 40/72] x86/sev-es: Setup GHCB based boot #VC handler
Message-ID: <20200908102416.GB12638@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-41-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907131613.12703-41-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add the infrastructure to handle #VC exceptions when the kernel runs
on virtual addresses and has a GHCB mapped. This handler will be used
until the runtime #VC handler takes over.

Since the handler runs very early, disable instrumentation for sev-es.c.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/realmode.h |   3 +
 arch/x86/include/asm/segment.h  |   2 +-
 arch/x86/include/asm/sev-es.h   |   2 +
 arch/x86/kernel/Makefile        |   2 +
 arch/x86/kernel/head64.c        |   8 +++
 arch/x86/kernel/head_64.S       |  36 ++++++++++
 arch/x86/kernel/sev-es-shared.c |  14 ++--
 arch/x86/kernel/sev-es.c        | 116 ++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c           |   1 +
 9 files changed, 176 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index b35030eeec36..96118fb041b8 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -57,6 +57,9 @@ extern unsigned char real_mode_blob_end[];
 extern unsigned long initial_code;
 extern unsigned long initial_gs;
 extern unsigned long initial_stack;
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+extern unsigned long initial_vc_handler;
+#endif
 
 extern unsigned char real_mode_blob[];
 extern unsigned char real_mode_relocs[];
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 517920928989..7fdd4facfce7 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -226,7 +226,7 @@
 #define NUM_EXCEPTION_VECTORS		32
 
 /* Bitmask of exception vectors which push an error code on the stack: */
-#define EXCEPTION_ERRCODE_MASK		0x00027d00
+#define EXCEPTION_ERRCODE_MASK		0x20027d00
 
 #define GDT_SIZE			(GDT_ENTRIES*8)
 #define GDT_ENTRY_TLS_ENTRIES		3
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 7175d432ebfe..9fbeedaa66ee 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -75,5 +75,7 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
 
 /* Early IDT entry points for #VC handler */
 extern void vc_no_ghcb(void);
+extern void vc_boot_ghcb(void);
+extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 #endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3bcdd8d2bbdd..04ceea8f4a89 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -20,6 +20,7 @@ CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
+CFLAGS_REMOVE_sev-es.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o				:= n
@@ -27,6 +28,7 @@ KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
 KASAN_SANITIZE_stacktrace.o				:= n
 KASAN_SANITIZE_paravirt.o				:= n
+KASAN_SANITIZE_sev-es.o					:= n
 
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 5683bbb555ef..530e055e231b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -406,6 +406,10 @@ void __init do_early_exception(struct pt_regs *regs, int trapnr)
 	    early_make_pgtable(native_read_cr2()))
 		return;
 
+	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT) &&
+	    trapnr == X86_TRAP_VC && handle_vc_boot_ghcb(regs))
+		return;
+
 	early_fixup_exception(regs, trapnr);
 }
 
@@ -573,6 +577,10 @@ static void startup_64_load_idt(unsigned long physbase)
 /* This is used when running on kernel addresses */
 void early_setup_idt(void)
 {
+	/* VMM Communication Exception */
+	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
+		set_bringup_idt_handler(X86_TRAP_VC, vc_boot_ghcb);
+
 	bringup_idt_descr.address = (unsigned long)bringup_idt_table;
 	native_load_idt(&bringup_idt_descr);
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 6e68bca64ae4..1a71d0d4d575 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -279,6 +279,39 @@ SYM_CODE_START(start_cpu0)
 	movq	initial_stack(%rip), %rsp
 	jmp	.Ljump_to_C_code
 SYM_CODE_END(start_cpu0)
+#endif
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+/*
+ * VC Exception handler used during early boot when running on kernel
+ * addresses, but before the switch to the idt_table can be made.
+ * The early_idt_handler_array can't be used here because it calls into a lot
+ * of __init code and this handler is also used during CPU offlining/onlining.
+ * Therefore this handler ends up in the .text section so that it stays around
+ * when .init.text is freed.
+ */
+SYM_CODE_START_NOALIGN(vc_boot_ghcb)
+	UNWIND_HINT_IRET_REGS offset=8
+
+	/* Build pt_regs */
+	PUSH_AND_CLEAR_REGS
+
+	/* Call C handler */
+	movq    %rsp, %rdi
+	movq	ORIG_RAX(%rsp), %rsi
+	movq	initial_vc_handler(%rip), %rax
+	ANNOTATE_RETPOLINE_SAFE
+	call	*%rax
+
+	/* Unwind pt_regs */
+	POP_REGS
+
+	/* Remove Error Code */
+	addq    $8, %rsp
+
+	/* Pure iret required here - don't use INTERRUPT_RETURN */
+	iretq
+SYM_CODE_END(vc_boot_ghcb)
 #endif
 
 	/* Both SMP bootup and ACPI suspend change these variables */
@@ -286,6 +319,9 @@ SYM_CODE_END(start_cpu0)
 	.balign	8
 SYM_DATA(initial_code,	.quad x86_64_start_kernel)
 SYM_DATA(initial_gs,	.quad INIT_PER_CPU_VAR(fixed_percpu_data))
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
+#endif
 
 /*
  * The SIZEOF_PTREGS gap is a convention which helps the in-kernel unwinder
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index 18619279a46f..aa77f2eb8d88 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -9,7 +9,7 @@
  * and is included directly into both code-bases.
  */
 
-static void __maybe_unused sev_es_terminate(unsigned int reason)
+static void sev_es_terminate(unsigned int reason)
 {
 	u64 val = GHCB_SEV_TERMINATE;
 
@@ -27,7 +27,7 @@ static void __maybe_unused sev_es_terminate(unsigned int reason)
 		asm volatile("hlt\n" : : : "memory");
 }
 
-static bool __maybe_unused sev_es_negotiate_protocol(void)
+static bool sev_es_negotiate_protocol(void)
 {
 	u64 val;
 
@@ -46,7 +46,7 @@ static bool __maybe_unused sev_es_negotiate_protocol(void)
 	return true;
 }
 
-static void __maybe_unused vc_ghcb_invalidate(struct ghcb *ghcb)
+static void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -58,9 +58,9 @@ static bool vc_decoding_needed(unsigned long exit_code)
 		 exit_code <= SVM_EXIT_LAST_EXCP);
 }
 
-static enum es_result __maybe_unused vc_init_em_ctxt(struct es_em_ctxt *ctxt,
-						     struct pt_regs *regs,
-						     unsigned long exit_code)
+static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
+				      struct pt_regs *regs,
+				      unsigned long exit_code)
 {
 	enum es_result ret = ES_OK;
 
@@ -73,7 +73,7 @@ static enum es_result __maybe_unused vc_init_em_ctxt(struct es_em_ctxt *ctxt,
 	return ret;
 }
 
-static void __maybe_unused vc_finish_insn(struct es_em_ctxt *ctxt)
+static void vc_finish_insn(struct es_em_ctxt *ctxt)
 {
 	ctxt->regs->ip += ctxt->insn.length;
 }
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 0b698b653c0b..bb3e702a71eb 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -7,7 +7,9 @@
  * Author: Joerg Roedel <jroedel@suse.de>
  */
 
+#include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/mm.h>
 
 #include <asm/sev-es.h>
@@ -18,6 +20,18 @@
 #include <asm/trapnr.h>
 #include <asm/svm.h>
 
+/* For early boot hypervisor communication in SEV-ES enabled guests */
+static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
+
+/*
+ * Needs to be in the .data section because we need it NULL before bss is
+ * cleared
+ */
+static struct ghcb __initdata *boot_ghcb;
+
+/* Needed in vc_early_forward_exception */
+void do_early_exception(struct pt_regs *regs, int trapnr);
+
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
 	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
@@ -161,3 +175,105 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
+
+/*
+ * This function runs on the first #VC exception after the kernel
+ * switched to virtual addresses.
+ */
+static bool __init sev_es_setup_ghcb(void)
+{
+	/* First make sure the hypervisor talks a supported protocol. */
+	if (!sev_es_negotiate_protocol())
+		return false;
+
+	/*
+	 * Clear the boot_ghcb. The first exception comes in before the bss
+	 * section is cleared.
+	 */
+	memset(&boot_ghcb_page, 0, PAGE_SIZE);
+
+	/* Alright - Make the boot-ghcb public */
+	boot_ghcb = &boot_ghcb_page;
+
+	return true;
+}
+
+static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
+{
+	int trapnr = ctxt->fi.vector;
+
+	if (trapnr == X86_TRAP_PF)
+		native_write_cr2(ctxt->fi.cr2);
+
+	ctxt->regs->orig_ax = ctxt->fi.error_code;
+	do_early_exception(ctxt->regs, trapnr);
+}
+
+static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
+					 struct ghcb *ghcb,
+					 unsigned long exit_code)
+{
+	enum es_result result;
+
+	switch (exit_code) {
+	default:
+		/*
+		 * Unexpected #VC exception
+		 */
+		result = ES_UNSUPPORTED;
+	}
+
+	return result;
+}
+
+bool __init handle_vc_boot_ghcb(struct pt_regs *regs)
+{
+	unsigned long exit_code = regs->orig_ax;
+	struct es_em_ctxt ctxt;
+	enum es_result result;
+
+	/* Do initial setup or terminate the guest */
+	if (unlikely(boot_ghcb == NULL && !sev_es_setup_ghcb()))
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+	vc_ghcb_invalidate(boot_ghcb);
+
+	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	if (result == ES_OK)
+		result = vc_handle_exitcode(&ctxt, boot_ghcb, exit_code);
+
+	/* Done - now check the result */
+	switch (result) {
+	case ES_OK:
+		vc_finish_insn(&ctxt);
+		break;
+	case ES_UNSUPPORTED:
+		early_printk("PANIC: Unsupported exit-code 0x%02lx in early #VC exception (IP: 0x%lx)\n",
+				exit_code, regs->ip);
+		goto fail;
+	case ES_VMM_ERROR:
+		early_printk("PANIC: Failure in communication with VMM (exit-code 0x%02lx IP: 0x%lx)\n",
+				exit_code, regs->ip);
+		goto fail;
+	case ES_DECODE_FAILED:
+		early_printk("PANIC: Failed to decode instruction (exit-code 0x%02lx IP: 0x%lx)\n",
+				exit_code, regs->ip);
+		goto fail;
+	case ES_EXCEPTION:
+		vc_early_forward_exception(&ctxt);
+		break;
+	case ES_RETRY:
+		/* Nothing to do */
+		break;
+	default:
+		BUG();
+	}
+
+	return true;
+
+fail:
+	show_regs(regs);
+
+	while (true)
+		halt();
+}
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 1d6cb07f4f86..3966749d07ac 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -5,6 +5,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/internal.h>
+#include <asm/sev-es.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
 
-- 
2.28.0

