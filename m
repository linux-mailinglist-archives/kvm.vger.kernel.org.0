Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C170318AF96
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgCSJR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:17:56 -0400
Received: from 8bytes.org ([81.169.241.247]:52700 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgCSJOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:37 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 464737A7; Thu, 19 Mar 2020 10:14:23 +0100 (CET)
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
Subject: [PATCH 37/70] x86/sev-es: Compile early handler code into kernel image
Date:   Thu, 19 Mar 2020 10:13:34 +0100
Message-Id: <20200319091407.1481-38-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
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
 arch/x86/kernel/Makefile        |   1 +
 arch/x86/kernel/sev-es-shared.c |  21 +++--
 arch/x86/kernel/sev-es.c        | 162 ++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/kernel/sev-es.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0ebcf4b9f3..28b4a2ebba25 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -147,6 +147,7 @@ obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
+obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev-es.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index a632b8f041ec..7a6e4db669f0 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -9,7 +9,7 @@
  * and is included directly into both code-bases.
  */
 
-static void sev_es_terminate(unsigned int reason)
+static void __maybe_unused sev_es_terminate(unsigned int reason)
 {
 	/* Request Guest Termination from Hypvervisor */
 	sev_es_wr_ghcb_msr(GHCB_SEV_TERMINATE);
@@ -19,7 +19,7 @@ static void sev_es_terminate(unsigned int reason)
 		asm volatile("hlt\n" : : : "memory");
 }
 
-static bool sev_es_negotiate_protocol(void)
+static bool __maybe_unused sev_es_negotiate_protocol(void)
 {
 	u64 val;
 
@@ -38,7 +38,7 @@ static bool sev_es_negotiate_protocol(void)
 	return true;
 }
 
-static void vc_ghcb_invalidate(struct ghcb *ghcb)
+static void __maybe_unused vc_ghcb_invalidate(struct ghcb *ghcb)
 {
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -50,9 +50,9 @@ static bool vc_decoding_needed(unsigned long exit_code)
 		 exit_code <= SVM_EXIT_LAST_EXCP);
 }
 
-static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
-				      struct pt_regs *regs,
-				      unsigned long exit_code)
+static enum es_result __maybe_unused vc_init_em_ctxt(struct es_em_ctxt *ctxt,
+						     struct pt_regs *regs,
+						     unsigned long exit_code)
 {
 	enum es_result ret = ES_OK;
 
@@ -65,7 +65,7 @@ static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
 	return ret;
 }
 
-static void vc_finish_insn(struct es_em_ctxt *ctxt)
+static void __maybe_unused vc_finish_insn(struct es_em_ctxt *ctxt)
 {
 	ctxt->regs->ip += ctxt->insn.length;
 }
@@ -312,7 +312,8 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	return ES_OK;
 }
 
-static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result __maybe_unused
+vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
 	u64 exit_info_1, exit_info_2;
@@ -408,8 +409,8 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
-static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
-				      struct es_em_ctxt *ctxt)
+static enum es_result __maybe_unused vc_handle_cpuid(struct ghcb *ghcb,
+						     struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
 	u32 cr4 = native_read_cr4();
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
new file mode 100644
index 000000000000..27fdef6b3700
--- /dev/null
+++ b/arch/x86/kernel/sev-es.c
@@ -0,0 +1,162 @@
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
+#include <asm/insn-eval.h>
+#include <asm/fpu/internal.h>
+#include <asm/processor.h>
+#include <asm/svm.h>
+
+static inline u64 sev_es_rd_ghcb_msr(void)
+{
+	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
+}
+
+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	u32 low, high;
+
+	low  = (u32)(val);
+	high = (u32)(val >> 32);
+
+	native_write_msr(MSR_AMD64_SEV_ES_GHCB, low, high);
+}
+
+static int vc_fetch_insn_kernel(struct es_em_ctxt *ctxt,
+				unsigned char *buffer)
+{
+	return probe_kernel_read(buffer, (unsigned char *)ctxt->regs->ip,
+				 MAX_INSN_SIZE);
+}
+
+static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
+{
+	char buffer[MAX_INSN_SIZE];
+	enum es_result ret;
+	int res;
+
+	res = vc_fetch_insn_kernel(ctxt, buffer);
+	if (unlikely(res == -EFAULT)) {
+		ctxt->fi.vector     = X86_TRAP_PF;
+		ctxt->fi.error_code = 0;
+		ctxt->fi.cr2        = ctxt->regs->ip;
+		return ES_EXCEPTION;
+	}
+
+	insn_init(&ctxt->insn, buffer, MAX_INSN_SIZE - res, 1);
+	insn_get_length(&ctxt->insn);
+
+	ret = ctxt->insn.immediate.got ? ES_OK : ES_DECODE_FAILED;
+
+	return ret;
+}
+
+static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
+				   char *dst, char *buf, size_t size)
+{
+	unsigned long error_code = X86_PF_PROT | X86_PF_WRITE;
+	unsigned char *target = dst;
+	u64 d8;
+	u32 d4;
+	u16 d2;
+	u8  d1;
+
+	switch (size) {
+	case 1:
+		memcpy(&d1, buf, 1);
+		if (put_user(d1, target))
+			goto fault;
+		break;
+	case 2:
+		memcpy(&d2, buf, 2);
+		if (put_user(d2, target))
+			goto fault;
+		break;
+	case 4:
+		memcpy(&d4, buf, 4);
+		if (put_user(d4, target))
+			goto fault;
+		break;
+	case 8:
+		memcpy(&d8, buf, 8);
+		if (put_user(d8, target))
+			goto fault;
+		break;
+	default:
+		WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
+		return ES_UNSUPPORTED;
+	}
+
+	return ES_OK;
+
+fault:
+	if (user_mode(ctxt->regs))
+		error_code |= X86_PF_USER;
+
+	ctxt->fi.vector = X86_TRAP_PF;
+	ctxt->fi.error_code = error_code;
+	ctxt->fi.cr2 = (unsigned long)dst;
+
+	return ES_EXCEPTION;
+}
+
+static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
+				  char *src, char *buf, size_t size)
+{
+	unsigned long error_code = X86_PF_PROT;
+	u64 d8;
+	u32 d4;
+	u16 d2;
+	u8  d1;
+
+	switch (size) {
+	case 1:
+		if (get_user(d1, src))
+			goto fault;
+		memcpy(buf, &d1, 1);
+		break;
+	case 2:
+		if (get_user(d2, src))
+			goto fault;
+		memcpy(buf, &d2, 2);
+		break;
+	case 4:
+		if (get_user(d4, src))
+			goto fault;
+		memcpy(buf, &d4, 4);
+		break;
+	case 8:
+		if (get_user(d8, src))
+			goto fault;
+		memcpy(buf, &d8, 8);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
+		return ES_UNSUPPORTED;
+	}
+
+	return ES_OK;
+
+fault:
+	if (user_mode(ctxt->regs))
+		error_code |= X86_PF_USER;
+
+	ctxt->fi.vector = X86_TRAP_PF;
+	ctxt->fi.error_code = error_code;
+	ctxt->fi.cr2 = (unsigned long)src;
+
+	return ES_EXCEPTION;
+}
+
+/* Include code shared with pre-decompression boot stage */
+#include "sev-es-shared.c"
-- 
2.17.1

