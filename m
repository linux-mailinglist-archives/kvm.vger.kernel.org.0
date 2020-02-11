Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8541590ED
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgBKN4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:56:37 -0500
Received: from 8bytes.org ([81.169.241.247]:52410 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbgBKNxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:24 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D9E7DE64; Tue, 11 Feb 2020 14:53:12 +0100 (CET)
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
Subject: [PATCH 32/62] x86/sev-es: Compile early handler code into kernel image
Date:   Tue, 11 Feb 2020 14:52:26 +0100
Message-Id: <20200211135256.24617-33-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Setup sev-es.c and include the code from the
pre-decompression stage to also build it into the image of the running
kernel. Temporarily add __maybe_unused annotations to avoid build
warnings until the functions get used.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/Makefile        |  1 +
 arch/x86/kernel/sev-es-shared.c | 24 ++++----
 arch/x86/kernel/sev-es.c        | 98 +++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/kernel/sev-es.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b294c13809a..b11bb52e2603 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -143,6 +143,7 @@ obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
+obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev-es.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index 14693eff9614..ad2a6c964217 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -9,7 +9,7 @@
  * and is included directly into both code-bases.
  */
 
-static void terminate(unsigned int reason)
+static void __maybe_unused terminate(unsigned int reason)
 {
 	/* Request Guest Termination from Hypvervisor */
 	write_ghcb_msr(GHCB_SEV_TERMINATE);
@@ -19,7 +19,7 @@ static void terminate(unsigned int reason)
 		asm volatile("hlt\n" : : : "memory");
 }
 
-static bool sev_es_negotiate_protocol(void)
+static bool __maybe_unused sev_es_negotiate_protocol(void)
 {
 	u64 val;
 
@@ -38,7 +38,7 @@ static bool sev_es_negotiate_protocol(void)
 	return true;
 }
 
-static void ghcb_invalidate(struct ghcb *ghcb)
+static void __maybe_unused ghcb_invalidate(struct ghcb *ghcb)
 {
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -80,9 +80,10 @@ static bool decoding_needed(unsigned long exit_code)
 		 exit_code <= SVM_EXIT_LAST_EXCP);
 }
 
-static enum es_result init_em_ctxt(struct es_em_ctxt *ctxt,
-				   struct pt_regs *regs,
-				   unsigned long exit_code)
+static enum es_result __maybe_unused
+init_em_ctxt(struct es_em_ctxt *ctxt,
+	     struct pt_regs *regs,
+	     unsigned long exit_code)
 {
 	enum es_result ret = ES_OK;
 
@@ -95,7 +96,7 @@ static enum es_result init_em_ctxt(struct es_em_ctxt *ctxt,
 	return ret;
 }
 
-static void finish_insn(struct es_em_ctxt *ctxt)
+static void __maybe_unused finish_insn(struct es_em_ctxt *ctxt)
 {
 	ctxt->regs->ip += ctxt->insn.length;
 }
@@ -358,7 +359,8 @@ static enum es_result ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	return ES_OK;
 }
 
-static enum es_result handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result __maybe_unused
+handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
 	u64 exit_info_1, exit_info_2;
@@ -450,7 +452,8 @@ static enum es_result handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
-static enum es_result handle_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result __maybe_unused
+handle_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
 	u32 cr4 = native_read_cr4();
@@ -656,7 +659,8 @@ static enum es_result handle_mmio_twobyte_ops(struct ghcb *ghcb,
 	return ret;
 }
 
-static enum es_result handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result __maybe_unused
+handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct insn *insn = &ctxt->insn;
 	unsigned int bytes = 0;
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
new file mode 100644
index 000000000000..33ab7fe8b6a0
--- /dev/null
+++ b/arch/x86/kernel/sev-es.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Memory Encryption Support
+ *
+ * Copyright (C) 2019 SUSE
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+
+#include <asm/trap_defs.h>
+#include <asm/sev-es.h>
+#include <asm/fpu/internal.h>
+#include <asm/processor.h>
+#include <asm/svm.h>
+
+static inline u64 read_ghcb_msr(void)
+{
+	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
+}
+
+static inline void write_ghcb_msr(u64 val)
+{
+	u32 low, high;
+
+	low  = (u32)(val);
+	high = (u32)(val >> 32);
+
+	native_write_msr(MSR_AMD64_SEV_ES_GHCB, low, high);
+}
+
+static bool check_kernel(struct pt_regs *regs)
+{
+	return regs->cs == __KERNEL_CS;
+}
+
+static enum es_result es_fetch_insn_byte(struct es_em_ctxt *ctxt,
+					 unsigned int offset,
+					 char *buffer)
+{
+	char *rip = (char *)ctxt->regs->ip;
+
+	/* More checks are needed when we boot to user-space */
+	if (!check_kernel(ctxt->regs))
+		return ES_UNSUPPORTED;
+
+	buffer[offset] = rip[offset];
+
+	return ES_OK;
+}
+
+static enum es_result es_write_mem(struct es_em_ctxt *ctxt,
+				   void *dst, char *buf, size_t size)
+{
+	/* More checks are needed when we boot to user-space */
+	if (!check_kernel(ctxt->regs))
+		return ES_UNSUPPORTED;
+
+	memcpy(dst, buf, size);
+
+	return ES_OK;
+}
+
+static enum es_result es_read_mem(struct es_em_ctxt *ctxt,
+				  void *src, char *buf, size_t size)
+{
+	/* More checks are needed when we boot to user-space */
+	if (!check_kernel(ctxt->regs))
+		return ES_UNSUPPORTED;
+
+	memcpy(buf, src, size);
+
+	return ES_OK;
+}
+
+static phys_addr_t es_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
+{
+	unsigned long va = (unsigned long)vaddr;
+	unsigned int level;
+	phys_addr_t pa;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	pgd = pgd_offset(current->active_mm, va);
+	pte = lookup_address_in_pgd(pgd, va, &level);
+	if (!pte)
+		return 0;
+
+	pa = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
+	pa |= va & ~page_level_mask(level);
+
+	return pa;
+}
+
+/* Include code shared with pre-decompression boot stage */
+#include "sev-es-shared.c"
-- 
2.17.1

