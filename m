Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBEC1590F1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgBKN4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:56:36 -0500
Received: from 8bytes.org ([81.169.241.247]:52450 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbgBKNxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:25 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4561DE6F; Tue, 11 Feb 2020 14:53:13 +0100 (CET)
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
Subject: [PATCH 34/62] x86/sev-es: Setup GHCB based boot #VC handler
Date:   Tue, 11 Feb 2020 14:52:28 +0100
Message-Id: <20200211135256.24617-35-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add the infrastructure to handle #VC exceptions when the kernel runs
on virtual addresses and has a GHCB mapped. This handler will be used
until the runtime #VC handler takes over.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/segment.h  |   2 +-
 arch/x86/include/asm/sev-es.h   |   1 +
 arch/x86/kernel/head64.c        |   5 ++
 arch/x86/kernel/sev-es-shared.c |  15 ++---
 arch/x86/kernel/sev-es.c        | 116 ++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c           |   1 +
 6 files changed, 131 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 6669164abadc..5b648066504c 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -230,7 +230,7 @@
 #define NUM_EXCEPTION_VECTORS		32
 
 /* Bitmask of exception vectors which push an error code on the stack: */
-#define EXCEPTION_ERRCODE_MASK		0x00027d00
+#define EXCEPTION_ERRCODE_MASK		0x20027d00
 
 #define GDT_SIZE			(GDT_ENTRIES*8)
 #define GDT_ENTRY_TLS_ENTRIES		3
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index caa29f75ce41..a2d0c77dabc3 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -76,5 +76,6 @@ static inline u64 copy_lower_bits(u64 out, u64 in, unsigned int bits)
 }
 
 extern void early_vc_handler(void);
+extern int boot_vc_exception(struct pt_regs *regs);
 
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index eab04ac260d4..14e0699b2692 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -390,6 +390,11 @@ void __init early_exception(struct pt_regs *regs, int trapnr)
 		cr2 = native_read_cr2();
 		r = early_make_pgtable(cr2);
 		break;
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	case X86_TRAP_VC:
+		r = boot_vc_exception(regs);
+		break;
+#endif
 	default:
 		r = 1;
 	}
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index ad2a6c964217..57c29c91fe87 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -9,7 +9,7 @@
  * and is included directly into both code-bases.
  */
 
-static void __maybe_unused terminate(unsigned int reason)
+static void terminate(unsigned int reason)
 {
 	/* Request Guest Termination from Hypvervisor */
 	write_ghcb_msr(GHCB_SEV_TERMINATE);
@@ -19,7 +19,7 @@ static void __maybe_unused terminate(unsigned int reason)
 		asm volatile("hlt\n" : : : "memory");
 }
 
-static bool __maybe_unused sev_es_negotiate_protocol(void)
+static bool sev_es_negotiate_protocol(void)
 {
 	u64 val;
 
@@ -38,7 +38,7 @@ static bool __maybe_unused sev_es_negotiate_protocol(void)
 	return true;
 }
 
-static void __maybe_unused ghcb_invalidate(struct ghcb *ghcb)
+static void ghcb_invalidate(struct ghcb *ghcb)
 {
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -80,10 +80,9 @@ static bool decoding_needed(unsigned long exit_code)
 		 exit_code <= SVM_EXIT_LAST_EXCP);
 }
 
-static enum es_result __maybe_unused
-init_em_ctxt(struct es_em_ctxt *ctxt,
-	     struct pt_regs *regs,
-	     unsigned long exit_code)
+static enum es_result init_em_ctxt(struct es_em_ctxt *ctxt,
+				   struct pt_regs *regs,
+				   unsigned long exit_code)
 {
 	enum es_result ret = ES_OK;
 
@@ -96,7 +95,7 @@ init_em_ctxt(struct es_em_ctxt *ctxt,
 	return ret;
 }
 
-static void __maybe_unused finish_insn(struct es_em_ctxt *ctxt)
+static void finish_insn(struct es_em_ctxt *ctxt)
 {
 	ctxt->regs->ip += ctxt->insn.length;
 }
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 33ab7fe8b6a0..0e0b28477627 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -7,15 +7,30 @@
  * Author: Joerg Roedel <jroedel@suse.de>
  */
 
+#include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/mm.h>
 
 #include <asm/trap_defs.h>
 #include <asm/sev-es.h>
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
+#include <asm/trap_defs.h>
 #include <asm/svm.h>
 
+/* For early boot hypervisor communication in SEV-ES enabled guests */
+struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
+
+/*
+ * Needs to be in the .data section because we need it NULL before bss is
+ * cleared
+ */
+struct ghcb __initdata *boot_ghcb;
+
+/* Needed in early_forward_exception */
+extern void early_exception(struct pt_regs *regs, int trapnr);
+
 static inline u64 read_ghcb_msr(void)
 {
 	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
@@ -96,3 +111,104 @@ static phys_addr_t es_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
 
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
+
+/*
+ * This function runs on the first #VC exception after the kernel
+ * switched to virtual addresses.
+ */
+static bool __init setup_ghcb(void)
+{
+	/* First make sure the hypervisor talks a supported protocol. */
+	if (!sev_es_negotiate_protocol())
+		return false;
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
+static void __init early_forward_exception(struct es_em_ctxt *ctxt)
+{
+	int trapnr = ctxt->fi.vector;
+
+	if (trapnr == X86_TRAP_PF)
+		native_write_cr2(ctxt->fi.cr2);
+
+	ctxt->regs->orig_ax = ctxt->fi.error_code;
+	early_exception(ctxt->regs, trapnr);
+}
+
+static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
+		struct ghcb *ghcb,
+		unsigned long exit_code)
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
+int __init boot_vc_exception(struct pt_regs *regs)
+{
+	unsigned long exit_code = regs->orig_ax;
+	struct es_em_ctxt ctxt;
+	enum es_result result;
+
+	/* Do initial setup or terminate the guest */
+	if (unlikely(boot_ghcb == NULL && !setup_ghcb()))
+		terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+	ghcb_invalidate(boot_ghcb);
+	result = init_em_ctxt(&ctxt, regs, exit_code);
+
+	if (result == ES_OK)
+		result = handle_vc_exception(&ctxt, boot_ghcb, exit_code);
+
+	/* Done - now check the result */
+	switch (result) {
+	case ES_OK:
+		finish_insn(&ctxt);
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
+		early_forward_exception(&ctxt);
+		break;
+	case ES_RETRY:
+		/* Nothing to do */
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+
+fail:
+	show_regs(regs);
+
+	while (true)
+		halt();
+}
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 30bb0bd3b1b8..cd440a9cf422 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -5,6 +5,7 @@
 #include <xen/xen.h>
 
 #include <asm/fpu/internal.h>
+#include <asm/sev-es.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
 
-- 
2.17.1

