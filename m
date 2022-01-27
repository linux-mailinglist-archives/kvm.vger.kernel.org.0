Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0817849DEE2
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 11:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiA0KLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 05:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiA0KL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 05:11:26 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6639C061748;
        Thu, 27 Jan 2022 02:11:25 -0800 (PST)
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 4FE5FD07;
        Thu, 27 Jan 2022 11:11:23 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, hpa@zytor.com,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v3 08/10] x86/sev: Add MMIO handling support to boot/compressed/ code
Date:   Thu, 27 Jan 2022 11:10:42 +0100
Message-Id: <20220127101044.13803-9-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127101044.13803-1-joro@8bytes.org>
References: <20220127101044.13803-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Move the code for MMIO handling in the #VC handler to sev-shared.c so
that it can be used in the decompressor code. The decompressor needs
to handle MMIO events for writing to the VGA framebuffer.

When the kernel is booted via UEFI the VGA console is not enabled that
early, but a kexec boot will enable it and the decompressor needs MMIO
support to write to the frame buffer.

This also requires to share some code from lib/insn-eval.c. Since
insn-eval.c can't be included into the decompressor code directly,
move the relevant parts into lib/insn-eval-shared.c and include that
file.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/sev.c  |  45 +-
 arch/x86/kernel/sev-shared.c    | 192 +++++++
 arch/x86/kernel/sev.c           | 192 -------
 arch/x86/lib/insn-eval-shared.c | 906 +++++++++++++++++++++++++++++++
 arch/x86/lib/insn-eval.c        | 909 +-------------------------------
 5 files changed, 1128 insertions(+), 1116 deletions(-)
 create mode 100644 arch/x86/lib/insn-eval-shared.c

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 28bcf04c022e..f4c0af184b17 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -26,25 +26,6 @@
 struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
 struct ghcb *boot_ghcb;
 
-/*
- * Copy a version of this function here - insn-eval.c can't be used in
- * pre-decompression code.
- */
-static bool insn_has_rep_prefix(struct insn *insn)
-{
-	insn_byte_t p;
-	int i;
-
-	insn_get_prefixes(insn);
-
-	for_each_insn_prefix(insn, i, p) {
-		if (p == 0xf2 || p == 0xf3)
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * Only a dummy for insn_get_seg_base() - Early boot-code is 64bit only and
  * doesn't use segments.
@@ -54,6 +35,16 @@ static unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx)
 	return 0UL;
 }
 
+static int get_seg_base_limit(struct insn *insn, struct pt_regs *regs,
+			      int regoff, unsigned long *base,
+			      unsigned long *limit)
+{
+	if (base)
+		*base = 0ULL;
+	if (limit)
+		*limit = ~0ULL;
+}
+
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
 	unsigned long low, high;
@@ -105,6 +96,14 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 	return ES_OK;
 }
 
+static enum es_result vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
+					   unsigned long vaddr, phys_addr_t *paddr)
+{
+	*paddr = (phys_addr_t)vaddr;
+
+	return ES_OK;
+}
+
 #undef __init
 #undef __pa
 #define __init
@@ -112,9 +111,14 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 
 #define __BOOT_COMPRESSED
 
+#undef WARN_ONCE
+#define WARN_ONCE(condition, format...)
+
 /* Basic instruction decoding support needed */
+#include <asm/insn-eval.h>
 #include "../../lib/inat.c"
 #include "../../lib/insn.c"
+#include "../../lib/insn-eval-shared.c"
 
 /* Include code for early handlers */
 #include "../../kernel/sev-shared.c"
@@ -193,6 +197,9 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 	case SVM_EXIT_CPUID:
 		result = vc_handle_cpuid(boot_ghcb, &ctxt);
 		break;
+	case SVM_EXIT_NPF:
+		result = vc_handle_mmio(boot_ghcb, &ctxt);
+		break;
 	default:
 		result = ES_UNSUPPORTED;
 		break;
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 4468150a42bb..b12fb063a30e 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -570,3 +570,195 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 
 	return ES_OK;
 }
+
+static long *vc_insn_get_rm(struct es_em_ctxt *ctxt)
+{
+	long *reg_array;
+	int offset;
+
+	reg_array = (long *)ctxt->regs;
+	offset    = insn_get_modrm_rm_off(&ctxt->insn, ctxt->regs);
+
+	if (offset < 0)
+		return NULL;
+
+	offset /= sizeof(long);
+
+	return reg_array + offset;
+}
+static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
+				 unsigned int bytes, bool read)
+{
+	u64 exit_code, exit_info_1, exit_info_2;
+	unsigned long ghcb_pa = __pa(ghcb);
+	enum es_result res;
+	phys_addr_t paddr;
+	void __user *ref;
+
+	ref = insn_get_addr_ref(&ctxt->insn, ctxt->regs);
+	if (ref == (void __user *)-1L)
+		return ES_UNSUPPORTED;
+
+	exit_code = read ? SVM_VMGEXIT_MMIO_READ : SVM_VMGEXIT_MMIO_WRITE;
+
+	res = vc_slow_virt_to_phys(ghcb, ctxt, (unsigned long)ref, &paddr);
+	if (res != ES_OK) {
+		if (res == ES_EXCEPTION && !read)
+			ctxt->fi.error_code |= X86_PF_WRITE;
+
+		return res;
+	}
+
+	exit_info_1 = paddr;
+	/* Can never be greater than 8 */
+	exit_info_2 = bytes;
+
+	ghcb_set_sw_scratch(ghcb, ghcb_pa + offsetof(struct ghcb, shared_buffer));
+
+	return sev_es_ghcb_hv_call(ghcb, true, ctxt, exit_code, exit_info_1, exit_info_2);
+}
+
+/*
+ * The MOVS instruction has two memory operands, which raises the
+ * problem that it is not known whether the access to the source or the
+ * destination caused the #VC exception (and hence whether an MMIO read
+ * or write operation needs to be emulated).
+ *
+ * Instead of playing games with walking page-tables and trying to guess
+ * whether the source or destination is an MMIO range, split the move
+ * into two operations, a read and a write with only one memory operand.
+ * This will cause a nested #VC exception on the MMIO address which can
+ * then be handled.
+ *
+ * This implementation has the benefit that it also supports MOVS where
+ * source _and_ destination are MMIO regions.
+ *
+ * It will slow MOVS on MMIO down a lot, but in SEV-ES guests it is a
+ * rare operation. If it turns out to be a performance problem the split
+ * operations can be moved to memcpy_fromio() and memcpy_toio().
+ */
+static enum es_result vc_handle_mmio_movs(struct es_em_ctxt *ctxt,
+					  unsigned int bytes)
+{
+	unsigned long ds_base, es_base;
+	unsigned char *src, *dst;
+	unsigned char buffer[8];
+	enum es_result ret;
+	bool rep;
+	int off;
+
+	ds_base = insn_get_seg_base(ctxt->regs, INAT_SEG_REG_DS);
+	es_base = insn_get_seg_base(ctxt->regs, INAT_SEG_REG_ES);
+
+	if (ds_base == -1L || es_base == -1L) {
+		ctxt->fi.vector = X86_TRAP_GP;
+		ctxt->fi.error_code = 0;
+		return ES_EXCEPTION;
+	}
+
+	src = ds_base + (unsigned char *)ctxt->regs->si;
+	dst = es_base + (unsigned char *)ctxt->regs->di;
+
+	ret = vc_read_mem(ctxt, src, buffer, bytes);
+	if (ret != ES_OK)
+		return ret;
+
+	ret = vc_write_mem(ctxt, dst, buffer, bytes);
+	if (ret != ES_OK)
+		return ret;
+
+	if (ctxt->regs->flags & X86_EFLAGS_DF)
+		off = -bytes;
+	else
+		off =  bytes;
+
+	ctxt->regs->si += off;
+	ctxt->regs->di += off;
+
+	rep = insn_has_rep_prefix(&ctxt->insn);
+	if (rep)
+		ctxt->regs->cx -= 1;
+
+	if (!rep || ctxt->regs->cx == 0)
+		return ES_OK;
+	else
+		return ES_RETRY;
+}
+
+static enum es_result vc_handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	struct insn *insn = &ctxt->insn;
+	unsigned int bytes = 0;
+	enum mmio_type mmio;
+	enum es_result ret;
+	u8 sign_byte;
+	long *reg_data;
+
+	mmio = insn_decode_mmio(insn, &bytes);
+	if (mmio == MMIO_DECODE_FAILED)
+		return ES_DECODE_FAILED;
+
+	if (mmio != MMIO_WRITE_IMM && mmio != MMIO_MOVS) {
+		reg_data = insn_get_modrm_reg_ptr(insn, ctxt->regs);
+		if (!reg_data)
+			return ES_DECODE_FAILED;
+	}
+
+	switch (mmio) {
+	case MMIO_WRITE:
+		memcpy(ghcb->shared_buffer, reg_data, bytes);
+		ret = vc_do_mmio(ghcb, ctxt, bytes, false);
+		break;
+	case MMIO_WRITE_IMM:
+		memcpy(ghcb->shared_buffer, insn->immediate1.bytes, bytes);
+		ret = vc_do_mmio(ghcb, ctxt, bytes, false);
+		break;
+	case MMIO_READ:
+		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		/* Zero-extend for 32-bit operation */
+		if (bytes == 4)
+			*reg_data = 0;
+
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+	case MMIO_READ_ZERO_EXTEND:
+		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		/* Zero extend based on operand size */
+		memset(reg_data, 0, insn->opnd_bytes);
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+	case MMIO_READ_SIGN_EXTEND:
+		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		if (bytes == 1) {
+			u8 *val = (u8 *)ghcb->shared_buffer;
+
+			sign_byte = (*val & 0x80) ? 0xff : 0x00;
+		} else {
+			u16 *val = (u16 *)ghcb->shared_buffer;
+
+			sign_byte = (*val & 0x8000) ? 0xff : 0x00;
+		}
+
+		/* Sign extend based on operand size */
+		memset(reg_data, sign_byte, insn->opnd_bytes);
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+	case MMIO_MOVS:
+		ret = vc_handle_mmio_movs(ctxt, bytes);
+		break;
+	default:
+		ret = ES_UNSUPPORTED;
+		break;
+	}
+
+	return ret;
+}
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 71301016c3ea..1bced5b49150 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -959,198 +959,6 @@ static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
 	do_early_exception(ctxt->regs, trapnr);
 }
 
-static long *vc_insn_get_rm(struct es_em_ctxt *ctxt)
-{
-	long *reg_array;
-	int offset;
-
-	reg_array = (long *)ctxt->regs;
-	offset    = insn_get_modrm_rm_off(&ctxt->insn, ctxt->regs);
-
-	if (offset < 0)
-		return NULL;
-
-	offset /= sizeof(long);
-
-	return reg_array + offset;
-}
-static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
-				 unsigned int bytes, bool read)
-{
-	u64 exit_code, exit_info_1, exit_info_2;
-	unsigned long ghcb_pa = __pa(ghcb);
-	enum es_result res;
-	phys_addr_t paddr;
-	void __user *ref;
-
-	ref = insn_get_addr_ref(&ctxt->insn, ctxt->regs);
-	if (ref == (void __user *)-1L)
-		return ES_UNSUPPORTED;
-
-	exit_code = read ? SVM_VMGEXIT_MMIO_READ : SVM_VMGEXIT_MMIO_WRITE;
-
-	res = vc_slow_virt_to_phys(ghcb, ctxt, (unsigned long)ref, &paddr);
-	if (res != ES_OK) {
-		if (res == ES_EXCEPTION && !read)
-			ctxt->fi.error_code |= X86_PF_WRITE;
-
-		return res;
-	}
-
-	exit_info_1 = paddr;
-	/* Can never be greater than 8 */
-	exit_info_2 = bytes;
-
-	ghcb_set_sw_scratch(ghcb, ghcb_pa + offsetof(struct ghcb, shared_buffer));
-
-	return sev_es_ghcb_hv_call(ghcb, true, ctxt, exit_code, exit_info_1, exit_info_2);
-}
-
-/*
- * The MOVS instruction has two memory operands, which raises the
- * problem that it is not known whether the access to the source or the
- * destination caused the #VC exception (and hence whether an MMIO read
- * or write operation needs to be emulated).
- *
- * Instead of playing games with walking page-tables and trying to guess
- * whether the source or destination is an MMIO range, split the move
- * into two operations, a read and a write with only one memory operand.
- * This will cause a nested #VC exception on the MMIO address which can
- * then be handled.
- *
- * This implementation has the benefit that it also supports MOVS where
- * source _and_ destination are MMIO regions.
- *
- * It will slow MOVS on MMIO down a lot, but in SEV-ES guests it is a
- * rare operation. If it turns out to be a performance problem the split
- * operations can be moved to memcpy_fromio() and memcpy_toio().
- */
-static enum es_result vc_handle_mmio_movs(struct es_em_ctxt *ctxt,
-					  unsigned int bytes)
-{
-	unsigned long ds_base, es_base;
-	unsigned char *src, *dst;
-	unsigned char buffer[8];
-	enum es_result ret;
-	bool rep;
-	int off;
-
-	ds_base = insn_get_seg_base(ctxt->regs, INAT_SEG_REG_DS);
-	es_base = insn_get_seg_base(ctxt->regs, INAT_SEG_REG_ES);
-
-	if (ds_base == -1L || es_base == -1L) {
-		ctxt->fi.vector = X86_TRAP_GP;
-		ctxt->fi.error_code = 0;
-		return ES_EXCEPTION;
-	}
-
-	src = ds_base + (unsigned char *)ctxt->regs->si;
-	dst = es_base + (unsigned char *)ctxt->regs->di;
-
-	ret = vc_read_mem(ctxt, src, buffer, bytes);
-	if (ret != ES_OK)
-		return ret;
-
-	ret = vc_write_mem(ctxt, dst, buffer, bytes);
-	if (ret != ES_OK)
-		return ret;
-
-	if (ctxt->regs->flags & X86_EFLAGS_DF)
-		off = -bytes;
-	else
-		off =  bytes;
-
-	ctxt->regs->si += off;
-	ctxt->regs->di += off;
-
-	rep = insn_has_rep_prefix(&ctxt->insn);
-	if (rep)
-		ctxt->regs->cx -= 1;
-
-	if (!rep || ctxt->regs->cx == 0)
-		return ES_OK;
-	else
-		return ES_RETRY;
-}
-
-static enum es_result vc_handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
-{
-	struct insn *insn = &ctxt->insn;
-	unsigned int bytes = 0;
-	enum mmio_type mmio;
-	enum es_result ret;
-	u8 sign_byte;
-	long *reg_data;
-
-	mmio = insn_decode_mmio(insn, &bytes);
-	if (mmio == MMIO_DECODE_FAILED)
-		return ES_DECODE_FAILED;
-
-	if (mmio != MMIO_WRITE_IMM && mmio != MMIO_MOVS) {
-		reg_data = insn_get_modrm_reg_ptr(insn, ctxt->regs);
-		if (!reg_data)
-			return ES_DECODE_FAILED;
-	}
-
-	switch (mmio) {
-	case MMIO_WRITE:
-		memcpy(ghcb->shared_buffer, reg_data, bytes);
-		ret = vc_do_mmio(ghcb, ctxt, bytes, false);
-		break;
-	case MMIO_WRITE_IMM:
-		memcpy(ghcb->shared_buffer, insn->immediate1.bytes, bytes);
-		ret = vc_do_mmio(ghcb, ctxt, bytes, false);
-		break;
-	case MMIO_READ:
-		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
-		if (ret)
-			break;
-
-		/* Zero-extend for 32-bit operation */
-		if (bytes == 4)
-			*reg_data = 0;
-
-		memcpy(reg_data, ghcb->shared_buffer, bytes);
-		break;
-	case MMIO_READ_ZERO_EXTEND:
-		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
-		if (ret)
-			break;
-
-		/* Zero extend based on operand size */
-		memset(reg_data, 0, insn->opnd_bytes);
-		memcpy(reg_data, ghcb->shared_buffer, bytes);
-		break;
-	case MMIO_READ_SIGN_EXTEND:
-		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
-		if (ret)
-			break;
-
-		if (bytes == 1) {
-			u8 *val = (u8 *)ghcb->shared_buffer;
-
-			sign_byte = (*val & 0x80) ? 0xff : 0x00;
-		} else {
-			u16 *val = (u16 *)ghcb->shared_buffer;
-
-			sign_byte = (*val & 0x8000) ? 0xff : 0x00;
-		}
-
-		/* Sign extend based on operand size */
-		memset(reg_data, sign_byte, insn->opnd_bytes);
-		memcpy(reg_data, ghcb->shared_buffer, bytes);
-		break;
-	case MMIO_MOVS:
-		ret = vc_handle_mmio_movs(ctxt, bytes);
-		break;
-	default:
-		ret = ES_UNSUPPORTED;
-		break;
-	}
-
-	return ret;
-}
-
 static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 					  struct es_em_ctxt *ctxt)
 {
diff --git a/arch/x86/lib/insn-eval-shared.c b/arch/x86/lib/insn-eval-shared.c
new file mode 100644
index 000000000000..ec310b5e6cd5
--- /dev/null
+++ b/arch/x86/lib/insn-eval-shared.c
@@ -0,0 +1,906 @@
+enum reg_type {
+	REG_TYPE_RM = 0,
+	REG_TYPE_REG,
+	REG_TYPE_INDEX,
+	REG_TYPE_BASE,
+};
+
+/**
+ * is_string_insn() - Determine if instruction is a string instruction
+ * @insn:	Instruction containing the opcode to inspect
+ *
+ * Returns:
+ *
+ * true if the instruction, determined by the opcode, is any of the
+ * string instructions as defined in the Intel Software Development manual.
+ * False otherwise.
+ */
+static bool is_string_insn(struct insn *insn)
+{
+	/* All string instructions have a 1-byte opcode. */
+	if (insn->opcode.nbytes != 1)
+		return false;
+
+	switch (insn->opcode.bytes[0]) {
+	case 0x6c ... 0x6f:	/* INS, OUTS */
+	case 0xa4 ... 0xa7:	/* MOVS, CMPS */
+	case 0xaa ... 0xaf:	/* STOS, LODS, SCAS */
+		return true;
+	default:
+		return false;
+	}
+}
+
+/**
+ * insn_has_rep_prefix() - Determine if instruction has a REP prefix
+ * @insn:	Instruction containing the prefix to inspect
+ *
+ * Returns:
+ *
+ * true if the instruction has a REP prefix, false if not.
+ */
+bool insn_has_rep_prefix(struct insn *insn)
+{
+	insn_byte_t p;
+	int i;
+
+	insn_get_prefixes(insn);
+
+	for_each_insn_prefix(insn, i, p) {
+		if (p == 0xf2 || p == 0xf3)
+			return true;
+	}
+
+	return false;
+}
+
+static const int pt_regoff[] = {
+	offsetof(struct pt_regs, ax),
+	offsetof(struct pt_regs, cx),
+	offsetof(struct pt_regs, dx),
+	offsetof(struct pt_regs, bx),
+	offsetof(struct pt_regs, sp),
+	offsetof(struct pt_regs, bp),
+	offsetof(struct pt_regs, si),
+	offsetof(struct pt_regs, di),
+#ifdef CONFIG_X86_64
+	offsetof(struct pt_regs, r8),
+	offsetof(struct pt_regs, r9),
+	offsetof(struct pt_regs, r10),
+	offsetof(struct pt_regs, r11),
+	offsetof(struct pt_regs, r12),
+	offsetof(struct pt_regs, r13),
+	offsetof(struct pt_regs, r14),
+	offsetof(struct pt_regs, r15),
+#else
+	offsetof(struct pt_regs, ds),
+	offsetof(struct pt_regs, es),
+	offsetof(struct pt_regs, fs),
+	offsetof(struct pt_regs, gs),
+#endif
+};
+
+int pt_regs_offset(struct pt_regs *regs, int regno)
+{
+	if ((unsigned)regno < ARRAY_SIZE(pt_regoff))
+		return pt_regoff[regno];
+	return -EDOM;
+}
+
+static int get_regno(struct insn *insn, enum reg_type type)
+{
+	int nr_registers = ARRAY_SIZE(pt_regoff);
+	int regno = 0;
+
+	/*
+	 * Don't possibly decode a 32-bit instructions as
+	 * reading a 64-bit-only register.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && !insn->x86_64)
+		nr_registers -= 8;
+
+	switch (type) {
+	case REG_TYPE_RM:
+		regno = X86_MODRM_RM(insn->modrm.value);
+
+		/*
+		 * ModRM.mod == 0 and ModRM.rm == 5 means a 32-bit displacement
+		 * follows the ModRM byte.
+		 */
+		if (!X86_MODRM_MOD(insn->modrm.value) && regno == 5)
+			return -EDOM;
+
+		if (X86_REX_B(insn->rex_prefix.value))
+			regno += 8;
+		break;
+
+	case REG_TYPE_REG:
+		regno = X86_MODRM_REG(insn->modrm.value);
+
+		if (X86_REX_R(insn->rex_prefix.value))
+			regno += 8;
+		break;
+
+	case REG_TYPE_INDEX:
+		regno = X86_SIB_INDEX(insn->sib.value);
+		if (X86_REX_X(insn->rex_prefix.value))
+			regno += 8;
+
+		/*
+		 * If ModRM.mod != 3 and SIB.index = 4 the scale*index
+		 * portion of the address computation is null. This is
+		 * true only if REX.X is 0. In such a case, the SIB index
+		 * is used in the address computation.
+		 */
+		if (X86_MODRM_MOD(insn->modrm.value) != 3 && regno == 4)
+			return -EDOM;
+		break;
+
+	case REG_TYPE_BASE:
+		regno = X86_SIB_BASE(insn->sib.value);
+		/*
+		 * If ModRM.mod is 0 and SIB.base == 5, the base of the
+		 * register-indirect addressing is 0. In this case, a
+		 * 32-bit displacement follows the SIB byte.
+		 */
+		if (!X86_MODRM_MOD(insn->modrm.value) && regno == 5)
+			return -EDOM;
+
+		if (X86_REX_B(insn->rex_prefix.value))
+			regno += 8;
+		break;
+
+	default:
+		pr_err_ratelimited("invalid register type: %d\n", type);
+		return -EINVAL;
+	}
+
+	if (regno >= nr_registers) {
+		WARN_ONCE(1, "decoded an instruction with an invalid register");
+		return -EINVAL;
+	}
+	return regno;
+}
+
+static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
+			  enum reg_type type)
+{
+	int regno = get_regno(insn, type);
+
+	if (regno < 0)
+		return regno;
+
+	return pt_regs_offset(regs, regno);
+}
+
+/**
+ * insn_get_modrm_rm_off() - Obtain register in r/m part of the ModRM byte
+ * @insn:	Instruction containing the ModRM byte
+ * @regs:	Register values as seen when entering kernel mode
+ *
+ * Returns:
+ *
+ * The register indicated by the r/m part of the ModRM byte. The
+ * register is obtained as an offset from the base of pt_regs. In specific
+ * cases, the returned value can be -EDOM to indicate that the particular value
+ * of ModRM does not refer to a register and shall be ignored.
+ */
+int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs)
+{
+	return get_reg_offset(insn, regs, REG_TYPE_RM);
+}
+
+/**
+ * insn_get_modrm_reg_off() - Obtain register in reg part of the ModRM byte
+ * @insn:	Instruction containing the ModRM byte
+ * @regs:	Register values as seen when entering kernel mode
+ *
+ * Returns:
+ *
+ * The register indicated by the reg part of the ModRM byte. The
+ * register is obtained as an offset from the base of pt_regs.
+ */
+int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs)
+{
+	return get_reg_offset(insn, regs, REG_TYPE_REG);
+}
+
+/**
+ * insn_get_modrm_reg_ptr() - Obtain register pointer based on ModRM byte
+ * @insn:	Instruction containing the ModRM byte
+ * @regs:	Register values as seen when entering kernel mode
+ *
+ * Returns:
+ *
+ * The register indicated by the reg part of the ModRM byte.
+ * The register is obtained as a pointer within pt_regs.
+ */
+unsigned long *insn_get_modrm_reg_ptr(struct insn *insn, struct pt_regs *regs)
+{
+	int offset;
+
+	offset = insn_get_modrm_reg_off(insn, regs);
+	if (offset < 0)
+		return NULL;
+	return (void *)regs + offset;
+}
+
+/**
+ * get_eff_addr_reg() - Obtain effective address from register operand
+ * @insn:	Instruction. Must be valid.
+ * @regs:	Register values as seen when entering kernel mode
+ * @regoff:	Obtained operand offset, in pt_regs, with the effective address
+ * @eff_addr:	Obtained effective address
+ *
+ * Obtain the effective address stored in the register operand as indicated by
+ * the ModRM byte. This function is to be used only with register addressing
+ * (i.e.,  ModRM.mod is 3). The effective address is saved in @eff_addr. The
+ * register operand, as an offset from the base of pt_regs, is saved in @regoff;
+ * such offset can then be used to resolve the segment associated with the
+ * operand. This function can be used with any of the supported address sizes
+ * in x86.
+ *
+ * Returns:
+ *
+ * 0 on success. @eff_addr will have the effective address stored in the
+ * operand indicated by ModRM. @regoff will have such operand as an offset from
+ * the base of pt_regs.
+ *
+ * -EINVAL on error.
+ */
+static int get_eff_addr_reg(struct insn *insn, struct pt_regs *regs,
+			    int *regoff, long *eff_addr)
+{
+	int ret;
+
+	ret = insn_get_modrm(insn);
+	if (ret)
+		return ret;
+
+	if (X86_MODRM_MOD(insn->modrm.value) != 3)
+		return -EINVAL;
+
+	*regoff = get_reg_offset(insn, regs, REG_TYPE_RM);
+	if (*regoff < 0)
+		return -EINVAL;
+
+	/* Ignore bytes that are outside the address size. */
+	if (insn->addr_bytes == 2)
+		*eff_addr = regs_get_register(regs, *regoff) & 0xffff;
+	else if (insn->addr_bytes == 4)
+		*eff_addr = regs_get_register(regs, *regoff) & 0xffffffff;
+	else /* 64-bit address */
+		*eff_addr = regs_get_register(regs, *regoff);
+
+	return 0;
+}
+
+/**
+ * get_eff_addr_modrm() - Obtain referenced effective address via ModRM
+ * @insn:	Instruction. Must be valid.
+ * @regs:	Register values as seen when entering kernel mode
+ * @regoff:	Obtained operand offset, in pt_regs, associated with segment
+ * @eff_addr:	Obtained effective address
+ *
+ * Obtain the effective address referenced by the ModRM byte of @insn. After
+ * identifying the registers involved in the register-indirect memory reference,
+ * its value is obtained from the operands in @regs. The computed address is
+ * stored @eff_addr. Also, the register operand that indicates the associated
+ * segment is stored in @regoff, this parameter can later be used to determine
+ * such segment.
+ *
+ * Returns:
+ *
+ * 0 on success. @eff_addr will have the referenced effective address. @regoff
+ * will have a register, as an offset from the base of pt_regs, that can be used
+ * to resolve the associated segment.
+ *
+ * -EINVAL on error.
+ */
+static int get_eff_addr_modrm(struct insn *insn, struct pt_regs *regs,
+			      int *regoff, long *eff_addr)
+{
+	long tmp;
+	int ret;
+
+	if (insn->addr_bytes != 8 && insn->addr_bytes != 4)
+		return -EINVAL;
+
+	ret = insn_get_modrm(insn);
+	if (ret)
+		return ret;
+
+	if (X86_MODRM_MOD(insn->modrm.value) > 2)
+		return -EINVAL;
+
+	*regoff = get_reg_offset(insn, regs, REG_TYPE_RM);
+
+	/*
+	 * -EDOM means that we must ignore the address_offset. In such a case,
+	 * in 64-bit mode the effective address relative to the rIP of the
+	 * following instruction.
+	 */
+	if (*regoff == -EDOM) {
+		if (any_64bit_mode(regs))
+			tmp = regs->ip + insn->length;
+		else
+			tmp = 0;
+	} else if (*regoff < 0) {
+		return -EINVAL;
+	} else {
+		tmp = regs_get_register(regs, *regoff);
+	}
+
+	if (insn->addr_bytes == 4) {
+		int addr32 = (int)(tmp & 0xffffffff) + insn->displacement.value;
+
+		*eff_addr = addr32 & 0xffffffff;
+	} else {
+		*eff_addr = tmp + insn->displacement.value;
+	}
+
+	return 0;
+}
+
+/**
+ * get_reg_offset_16() - Obtain offset of register indicated by instruction
+ * @insn:	Instruction containing ModRM byte
+ * @regs:	Register values as seen when entering kernel mode
+ * @offs1:	Offset of the first operand register
+ * @offs2:	Offset of the second operand register, if applicable
+ *
+ * Obtain the offset, in pt_regs, of the registers indicated by the ModRM byte
+ * in @insn. This function is to be used with 16-bit address encodings. The
+ * @offs1 and @offs2 will be written with the offset of the two registers
+ * indicated by the instruction. In cases where any of the registers is not
+ * referenced by the instruction, the value will be set to -EDOM.
+ *
+ * Returns:
+ *
+ * 0 on success, -EINVAL on error.
+ */
+static int get_reg_offset_16(struct insn *insn, struct pt_regs *regs,
+			     int *offs1, int *offs2)
+{
+	/*
+	 * 16-bit addressing can use one or two registers. Specifics of
+	 * encodings are given in Table 2-1. "16-Bit Addressing Forms with the
+	 * ModR/M Byte" of the Intel Software Development Manual.
+	 */
+	static const int regoff1[] = {
+		offsetof(struct pt_regs, bx),
+		offsetof(struct pt_regs, bx),
+		offsetof(struct pt_regs, bp),
+		offsetof(struct pt_regs, bp),
+		offsetof(struct pt_regs, si),
+		offsetof(struct pt_regs, di),
+		offsetof(struct pt_regs, bp),
+		offsetof(struct pt_regs, bx),
+	};
+
+	static const int regoff2[] = {
+		offsetof(struct pt_regs, si),
+		offsetof(struct pt_regs, di),
+		offsetof(struct pt_regs, si),
+		offsetof(struct pt_regs, di),
+		-EDOM,
+		-EDOM,
+		-EDOM,
+		-EDOM,
+	};
+
+	if (!offs1 || !offs2)
+		return -EINVAL;
+
+	/* Operand is a register, use the generic function. */
+	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
+		*offs1 = insn_get_modrm_rm_off(insn, regs);
+		*offs2 = -EDOM;
+		return 0;
+	}
+
+	*offs1 = regoff1[X86_MODRM_RM(insn->modrm.value)];
+	*offs2 = regoff2[X86_MODRM_RM(insn->modrm.value)];
+
+	/*
+	 * If ModRM.mod is 0 and ModRM.rm is 110b, then we use displacement-
+	 * only addressing. This means that no registers are involved in
+	 * computing the effective address. Thus, ensure that the first
+	 * register offset is invalid. The second register offset is already
+	 * invalid under the aforementioned conditions.
+	 */
+	if ((X86_MODRM_MOD(insn->modrm.value) == 0) &&
+	    (X86_MODRM_RM(insn->modrm.value) == 6))
+		*offs1 = -EDOM;
+
+	return 0;
+}
+
+/**
+ * get_eff_addr_modrm_16() - Obtain referenced effective address via ModRM
+ * @insn:	Instruction. Must be valid.
+ * @regs:	Register values as seen when entering kernel mode
+ * @regoff:	Obtained operand offset, in pt_regs, associated with segment
+ * @eff_addr:	Obtained effective address
+ *
+ * Obtain the 16-bit effective address referenced by the ModRM byte of @insn.
+ * After identifying the registers involved in the register-indirect memory
+ * reference, its value is obtained from the operands in @regs. The computed
+ * address is stored @eff_addr. Also, the register operand that indicates
+ * the associated segment is stored in @regoff, this parameter can later be used
+ * to determine such segment.
+ *
+ * Returns:
+ *
+ * 0 on success. @eff_addr will have the referenced effective address. @regoff
+ * will have a register, as an offset from the base of pt_regs, that can be used
+ * to resolve the associated segment.
+ *
+ * -EINVAL on error.
+ */
+static int get_eff_addr_modrm_16(struct insn *insn, struct pt_regs *regs,
+				 int *regoff, short *eff_addr)
+{
+	int addr_offset1, addr_offset2, ret;
+	short addr1 = 0, addr2 = 0, displacement;
+
+	if (insn->addr_bytes != 2)
+		return -EINVAL;
+
+	insn_get_modrm(insn);
+
+	if (!insn->modrm.nbytes)
+		return -EINVAL;
+
+	if (X86_MODRM_MOD(insn->modrm.value) > 2)
+		return -EINVAL;
+
+	ret = get_reg_offset_16(insn, regs, &addr_offset1, &addr_offset2);
+	if (ret < 0)
+		return -EINVAL;
+
+	/*
+	 * Don't fail on invalid offset values. They might be invalid because
+	 * they cannot be used for this particular value of ModRM. Instead, use
+	 * them in the computation only if they contain a valid value.
+	 */
+	if (addr_offset1 != -EDOM)
+		addr1 = regs_get_register(regs, addr_offset1) & 0xffff;
+
+	if (addr_offset2 != -EDOM)
+		addr2 = regs_get_register(regs, addr_offset2) & 0xffff;
+
+	displacement = insn->displacement.value & 0xffff;
+	*eff_addr = addr1 + addr2 + displacement;
+
+	/*
+	 * The first operand register could indicate to use of either SS or DS
+	 * registers to obtain the segment selector.  The second operand
+	 * register can only indicate the use of DS. Thus, the first operand
+	 * will be used to obtain the segment selector.
+	 */
+	*regoff = addr_offset1;
+
+	return 0;
+}
+
+/**
+ * get_eff_addr_sib() - Obtain referenced effective address via SIB
+ * @insn:	Instruction. Must be valid.
+ * @regs:	Register values as seen when entering kernel mode
+ * @regoff:	Obtained operand offset, in pt_regs, associated with segment
+ * @eff_addr:	Obtained effective address
+ *
+ * Obtain the effective address referenced by the SIB byte of @insn. After
+ * identifying the registers involved in the indexed, register-indirect memory
+ * reference, its value is obtained from the operands in @regs. The computed
+ * address is stored @eff_addr. Also, the register operand that indicates the
+ * associated segment is stored in @regoff, this parameter can later be used to
+ * determine such segment.
+ *
+ * Returns:
+ *
+ * 0 on success. @eff_addr will have the referenced effective address.
+ * @base_offset will have a register, as an offset from the base of pt_regs,
+ * that can be used to resolve the associated segment.
+ *
+ * Negative value on error.
+ */
+static int get_eff_addr_sib(struct insn *insn, struct pt_regs *regs,
+			    int *base_offset, long *eff_addr)
+{
+	long base, indx;
+	int indx_offset;
+	int ret;
+
+	if (insn->addr_bytes != 8 && insn->addr_bytes != 4)
+		return -EINVAL;
+
+	ret = insn_get_modrm(insn);
+	if (ret)
+		return ret;
+
+	if (!insn->modrm.nbytes)
+		return -EINVAL;
+
+	if (X86_MODRM_MOD(insn->modrm.value) > 2)
+		return -EINVAL;
+
+	ret = insn_get_sib(insn);
+	if (ret)
+		return ret;
+
+	if (!insn->sib.nbytes)
+		return -EINVAL;
+
+	*base_offset = get_reg_offset(insn, regs, REG_TYPE_BASE);
+	indx_offset = get_reg_offset(insn, regs, REG_TYPE_INDEX);
+
+	/*
+	 * Negative values in the base and index offset means an error when
+	 * decoding the SIB byte. Except -EDOM, which means that the registers
+	 * should not be used in the address computation.
+	 */
+	if (*base_offset == -EDOM)
+		base = 0;
+	else if (*base_offset < 0)
+		return -EINVAL;
+	else
+		base = regs_get_register(regs, *base_offset);
+
+	if (indx_offset == -EDOM)
+		indx = 0;
+	else if (indx_offset < 0)
+		return -EINVAL;
+	else
+		indx = regs_get_register(regs, indx_offset);
+
+	if (insn->addr_bytes == 4) {
+		int addr32, base32, idx32;
+
+		base32 = base & 0xffffffff;
+		idx32 = indx & 0xffffffff;
+
+		addr32 = base32 + idx32 * (1 << X86_SIB_SCALE(insn->sib.value));
+		addr32 += insn->displacement.value;
+
+		*eff_addr = addr32 & 0xffffffff;
+	} else {
+		*eff_addr = base + indx * (1 << X86_SIB_SCALE(insn->sib.value));
+		*eff_addr += insn->displacement.value;
+	}
+
+	return 0;
+}
+
+/**
+ * get_addr_ref_16() - Obtain the 16-bit address referred by instruction
+ * @insn:	Instruction containing ModRM byte and displacement
+ * @regs:	Register values as seen when entering kernel mode
+ *
+ * This function is to be used with 16-bit address encodings. Obtain the memory
+ * address referred by the instruction's ModRM and displacement bytes. Also, the
+ * segment used as base is determined by either any segment override prefixes in
+ * @insn or the default segment of the registers involved in the address
+ * computation. In protected mode, segment limits are enforced.
+ *
+ * Returns:
+ *
+ * Linear address referenced by the instruction operands on success.
+ *
+ * -1L on error.
+ */
+static void __user *get_addr_ref_16(struct insn *insn, struct pt_regs *regs)
+{
+	unsigned long linear_addr = -1L, seg_base, seg_limit;
+	int ret, regoff;
+	short eff_addr;
+	long tmp;
+
+	if (insn_get_displacement(insn))
+		goto out;
+
+	if (insn->addr_bytes != 2)
+		goto out;
+
+	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
+		ret = get_eff_addr_reg(insn, regs, &regoff, &tmp);
+		if (ret)
+			goto out;
+
+		eff_addr = tmp;
+	} else {
+		ret = get_eff_addr_modrm_16(insn, regs, &regoff, &eff_addr);
+		if (ret)
+			goto out;
+	}
+
+	ret = get_seg_base_limit(insn, regs, regoff, &seg_base, &seg_limit);
+	if (ret)
+		goto out;
+
+	/*
+	 * Before computing the linear address, make sure the effective address
+	 * is within the limits of the segment. In virtual-8086 mode, segment
+	 * limits are not enforced. In such a case, the segment limit is -1L to
+	 * reflect this fact.
+	 */
+	if ((unsigned long)(eff_addr & 0xffff) > seg_limit)
+		goto out;
+
+	linear_addr = (unsigned long)(eff_addr & 0xffff) + seg_base;
+
+	/* Limit linear address to 20 bits */
+	if (v8086_mode(regs))
+		linear_addr &= 0xfffff;
+
+out:
+	return (void __user *)linear_addr;
+}
+
+/**
+ * get_addr_ref_32() - Obtain a 32-bit linear address
+ * @insn:	Instruction with ModRM, SIB bytes and displacement
+ * @regs:	Register values as seen when entering kernel mode
+ *
+ * This function is to be used with 32-bit address encodings to obtain the
+ * linear memory address referred by the instruction's ModRM, SIB,
+ * displacement bytes and segment base address, as applicable. If in protected
+ * mode, segment limits are enforced.
+ *
+ * Returns:
+ *
+ * Linear address referenced by instruction and registers on success.
+ *
+ * -1L on error.
+ */
+static void __user *get_addr_ref_32(struct insn *insn, struct pt_regs *regs)
+{
+	unsigned long linear_addr = -1L, seg_base, seg_limit;
+	int eff_addr, regoff;
+	long tmp;
+	int ret;
+
+	if (insn->addr_bytes != 4)
+		goto out;
+
+	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
+		ret = get_eff_addr_reg(insn, regs, &regoff, &tmp);
+		if (ret)
+			goto out;
+
+		eff_addr = tmp;
+
+	} else {
+		if (insn->sib.nbytes) {
+			ret = get_eff_addr_sib(insn, regs, &regoff, &tmp);
+			if (ret)
+				goto out;
+
+			eff_addr = tmp;
+		} else {
+			ret = get_eff_addr_modrm(insn, regs, &regoff, &tmp);
+			if (ret)
+				goto out;
+
+			eff_addr = tmp;
+		}
+	}
+
+	ret = get_seg_base_limit(insn, regs, regoff, &seg_base, &seg_limit);
+	if (ret)
+		goto out;
+
+	/*
+	 * In protected mode, before computing the linear address, make sure
+	 * the effective address is within the limits of the segment.
+	 * 32-bit addresses can be used in long and virtual-8086 modes if an
+	 * address override prefix is used. In such cases, segment limits are
+	 * not enforced. When in virtual-8086 mode, the segment limit is -1L
+	 * to reflect this situation.
+	 *
+	 * After computed, the effective address is treated as an unsigned
+	 * quantity.
+	 */
+	if (!any_64bit_mode(regs) && ((unsigned int)eff_addr > seg_limit))
+		goto out;
+
+	/*
+	 * Even though 32-bit address encodings are allowed in virtual-8086
+	 * mode, the address range is still limited to [0x-0xffff].
+	 */
+	if (v8086_mode(regs) && (eff_addr & ~0xffff))
+		goto out;
+
+	/*
+	 * Data type long could be 64 bits in size. Ensure that our 32-bit
+	 * effective address is not sign-extended when computing the linear
+	 * address.
+	 */
+	linear_addr = (unsigned long)(eff_addr & 0xffffffff) + seg_base;
+
+	/* Limit linear address to 20 bits */
+	if (v8086_mode(regs))
+		linear_addr &= 0xfffff;
+
+out:
+	return (void __user *)linear_addr;
+}
+
+/**
+ * get_addr_ref_64() - Obtain a 64-bit linear address
+ * @insn:	Instruction struct with ModRM and SIB bytes and displacement
+ * @regs:	Structure with register values as seen when entering kernel mode
+ *
+ * This function is to be used with 64-bit address encodings to obtain the
+ * linear memory address referred by the instruction's ModRM, SIB,
+ * displacement bytes and segment base address, as applicable.
+ *
+ * Returns:
+ *
+ * Linear address referenced by instruction and registers on success.
+ *
+ * -1L on error.
+ */
+#ifndef CONFIG_X86_64
+static void __user *get_addr_ref_64(struct insn *insn, struct pt_regs *regs)
+{
+	return (void __user *)-1L;
+}
+#else
+static void __user *get_addr_ref_64(struct insn *insn, struct pt_regs *regs)
+{
+	unsigned long linear_addr = -1L, seg_base;
+	int regoff, ret;
+	long eff_addr;
+
+	if (insn->addr_bytes != 8)
+		goto out;
+
+	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
+		ret = get_eff_addr_reg(insn, regs, &regoff, &eff_addr);
+		if (ret)
+			goto out;
+
+	} else {
+		if (insn->sib.nbytes) {
+			ret = get_eff_addr_sib(insn, regs, &regoff, &eff_addr);
+			if (ret)
+				goto out;
+		} else {
+			ret = get_eff_addr_modrm(insn, regs, &regoff, &eff_addr);
+			if (ret)
+				goto out;
+		}
+
+	}
+
+	ret = get_seg_base_limit(insn, regs, regoff, &seg_base, NULL);
+	if (ret)
+		goto out;
+
+	linear_addr = (unsigned long)eff_addr + seg_base;
+
+out:
+	return (void __user *)linear_addr;
+}
+#endif /* CONFIG_X86_64 */
+
+/**
+ * insn_get_addr_ref() - Obtain the linear address referred by instruction
+ * @insn:	Instruction structure containing ModRM byte and displacement
+ * @regs:	Structure with register values as seen when entering kernel mode
+ *
+ * Obtain the linear address referred by the instruction's ModRM, SIB and
+ * displacement bytes, and segment base, as applicable. In protected mode,
+ * segment limits are enforced.
+ *
+ * Returns:
+ *
+ * Linear address referenced by instruction and registers on success.
+ *
+ * -1L on error.
+ */
+void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
+{
+	if (!insn || !regs)
+		return (void __user *)-1L;
+
+	if (insn_get_opcode(insn))
+		return (void __user *)-1L;
+
+	switch (insn->addr_bytes) {
+	case 2:
+		return get_addr_ref_16(insn, regs);
+	case 4:
+		return get_addr_ref_32(insn, regs);
+	case 8:
+		return get_addr_ref_64(insn, regs);
+	default:
+		return (void __user *)-1L;
+	}
+}
+
+/**
+ * insn_decode_mmio() - Decode a MMIO instruction
+ * @insn:	Structure to store decoded instruction
+ * @bytes:	Returns size of memory operand
+ *
+ * Decodes instruction that used for Memory-mapped I/O.
+ *
+ * Returns:
+ *
+ * Type of the instruction. Size of the memory operand is stored in
+ * @bytes. If decode failed, MMIO_DECODE_FAILED returned.
+ */
+enum mmio_type insn_decode_mmio(struct insn *insn, int *bytes)
+{
+	enum mmio_type type = MMIO_DECODE_FAILED;
+
+	*bytes = 0;
+
+	if (insn_get_opcode(insn))
+		return MMIO_DECODE_FAILED;
+
+	switch (insn->opcode.bytes[0]) {
+	case 0x88: /* MOV m8,r8 */
+		*bytes = 1;
+		fallthrough;
+	case 0x89: /* MOV m16/m32/m64, r16/m32/m64 */
+		if (!*bytes)
+			*bytes = insn->opnd_bytes;
+		type = MMIO_WRITE;
+		break;
+
+	case 0xc6: /* MOV m8, imm8 */
+		*bytes = 1;
+		fallthrough;
+	case 0xc7: /* MOV m16/m32/m64, imm16/imm32/imm64 */
+		if (!*bytes)
+			*bytes = insn->opnd_bytes;
+		type = MMIO_WRITE_IMM;
+		break;
+
+	case 0x8a: /* MOV r8, m8 */
+		*bytes = 1;
+		fallthrough;
+	case 0x8b: /* MOV r16/r32/r64, m16/m32/m64 */
+		if (!*bytes)
+			*bytes = insn->opnd_bytes;
+		type = MMIO_READ;
+		break;
+
+	case 0xa4: /* MOVS m8, m8 */
+		*bytes = 1;
+		fallthrough;
+	case 0xa5: /* MOVS m16/m32/m64, m16/m32/m64 */
+		if (!*bytes)
+			*bytes = insn->opnd_bytes;
+		type = MMIO_MOVS;
+		break;
+
+	case 0x0f: /* Two-byte instruction */
+		switch (insn->opcode.bytes[1]) {
+		case 0xb6: /* MOVZX r16/r32/r64, m8 */
+			*bytes = 1;
+			fallthrough;
+		case 0xb7: /* MOVZX r32/r64, m16 */
+			if (!*bytes)
+				*bytes = 2;
+			type = MMIO_READ_ZERO_EXTEND;
+			break;
+
+		case 0xbe: /* MOVSX r16/r32/r64, m8 */
+			*bytes = 1;
+			fallthrough;
+		case 0xbf: /* MOVSX r32/r64, m16 */
+			if (!*bytes)
+				*bytes = 2;
+			type = MMIO_READ_SIGN_EXTEND;
+			break;
+		}
+		break;
+	}
+
+	return type;
+}
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index b781d324211b..5540e3c6041e 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -18,61 +18,11 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "insn: " fmt
 
-enum reg_type {
-	REG_TYPE_RM = 0,
-	REG_TYPE_REG,
-	REG_TYPE_INDEX,
-	REG_TYPE_BASE,
-};
-
-/**
- * is_string_insn() - Determine if instruction is a string instruction
- * @insn:	Instruction containing the opcode to inspect
- *
- * Returns:
- *
- * true if the instruction, determined by the opcode, is any of the
- * string instructions as defined in the Intel Software Development manual.
- * False otherwise.
- */
-static bool is_string_insn(struct insn *insn)
-{
-	/* All string instructions have a 1-byte opcode. */
-	if (insn->opcode.nbytes != 1)
-		return false;
-
-	switch (insn->opcode.bytes[0]) {
-	case 0x6c ... 0x6f:	/* INS, OUTS */
-	case 0xa4 ... 0xa7:	/* MOVS, CMPS */
-	case 0xaa ... 0xaf:	/* STOS, LODS, SCAS */
-		return true;
-	default:
-		return false;
-	}
-}
-
-/**
- * insn_has_rep_prefix() - Determine if instruction has a REP prefix
- * @insn:	Instruction containing the prefix to inspect
- *
- * Returns:
- *
- * true if the instruction has a REP prefix, false if not.
- */
-bool insn_has_rep_prefix(struct insn *insn)
-{
-	insn_byte_t p;
-	int i;
-
-	insn_get_prefixes(insn);
+static int get_seg_base_limit(struct insn *insn, struct pt_regs *regs,
+			      int regoff, unsigned long *base,
+			      unsigned long *limit);
 
-	for_each_insn_prefix(insn, i, p) {
-		if (p == 0xf2 || p == 0xf3)
-			return true;
-	}
-
-	return false;
-}
+#include "insn-eval-shared.c"
 
 /**
  * get_seg_reg_override_idx() - obtain segment register override index
@@ -410,199 +360,6 @@ static short get_segment_selector(struct pt_regs *regs, int seg_reg_idx)
 #endif /* CONFIG_X86_64 */
 }
 
-static const int pt_regoff[] = {
-	offsetof(struct pt_regs, ax),
-	offsetof(struct pt_regs, cx),
-	offsetof(struct pt_regs, dx),
-	offsetof(struct pt_regs, bx),
-	offsetof(struct pt_regs, sp),
-	offsetof(struct pt_regs, bp),
-	offsetof(struct pt_regs, si),
-	offsetof(struct pt_regs, di),
-#ifdef CONFIG_X86_64
-	offsetof(struct pt_regs, r8),
-	offsetof(struct pt_regs, r9),
-	offsetof(struct pt_regs, r10),
-	offsetof(struct pt_regs, r11),
-	offsetof(struct pt_regs, r12),
-	offsetof(struct pt_regs, r13),
-	offsetof(struct pt_regs, r14),
-	offsetof(struct pt_regs, r15),
-#else
-	offsetof(struct pt_regs, ds),
-	offsetof(struct pt_regs, es),
-	offsetof(struct pt_regs, fs),
-	offsetof(struct pt_regs, gs),
-#endif
-};
-
-int pt_regs_offset(struct pt_regs *regs, int regno)
-{
-	if ((unsigned)regno < ARRAY_SIZE(pt_regoff))
-		return pt_regoff[regno];
-	return -EDOM;
-}
-
-static int get_regno(struct insn *insn, enum reg_type type)
-{
-	int nr_registers = ARRAY_SIZE(pt_regoff);
-	int regno = 0;
-
-	/*
-	 * Don't possibly decode a 32-bit instructions as
-	 * reading a 64-bit-only register.
-	 */
-	if (IS_ENABLED(CONFIG_X86_64) && !insn->x86_64)
-		nr_registers -= 8;
-
-	switch (type) {
-	case REG_TYPE_RM:
-		regno = X86_MODRM_RM(insn->modrm.value);
-
-		/*
-		 * ModRM.mod == 0 and ModRM.rm == 5 means a 32-bit displacement
-		 * follows the ModRM byte.
-		 */
-		if (!X86_MODRM_MOD(insn->modrm.value) && regno == 5)
-			return -EDOM;
-
-		if (X86_REX_B(insn->rex_prefix.value))
-			regno += 8;
-		break;
-
-	case REG_TYPE_REG:
-		regno = X86_MODRM_REG(insn->modrm.value);
-
-		if (X86_REX_R(insn->rex_prefix.value))
-			regno += 8;
-		break;
-
-	case REG_TYPE_INDEX:
-		regno = X86_SIB_INDEX(insn->sib.value);
-		if (X86_REX_X(insn->rex_prefix.value))
-			regno += 8;
-
-		/*
-		 * If ModRM.mod != 3 and SIB.index = 4 the scale*index
-		 * portion of the address computation is null. This is
-		 * true only if REX.X is 0. In such a case, the SIB index
-		 * is used in the address computation.
-		 */
-		if (X86_MODRM_MOD(insn->modrm.value) != 3 && regno == 4)
-			return -EDOM;
-		break;
-
-	case REG_TYPE_BASE:
-		regno = X86_SIB_BASE(insn->sib.value);
-		/*
-		 * If ModRM.mod is 0 and SIB.base == 5, the base of the
-		 * register-indirect addressing is 0. In this case, a
-		 * 32-bit displacement follows the SIB byte.
-		 */
-		if (!X86_MODRM_MOD(insn->modrm.value) && regno == 5)
-			return -EDOM;
-
-		if (X86_REX_B(insn->rex_prefix.value))
-			regno += 8;
-		break;
-
-	default:
-		pr_err_ratelimited("invalid register type: %d\n", type);
-		return -EINVAL;
-	}
-
-	if (regno >= nr_registers) {
-		WARN_ONCE(1, "decoded an instruction with an invalid register");
-		return -EINVAL;
-	}
-	return regno;
-}
-
-static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
-			  enum reg_type type)
-{
-	int regno = get_regno(insn, type);
-
-	if (regno < 0)
-		return regno;
-
-	return pt_regs_offset(regs, regno);
-}
-
-/**
- * get_reg_offset_16() - Obtain offset of register indicated by instruction
- * @insn:	Instruction containing ModRM byte
- * @regs:	Register values as seen when entering kernel mode
- * @offs1:	Offset of the first operand register
- * @offs2:	Offset of the second operand register, if applicable
- *
- * Obtain the offset, in pt_regs, of the registers indicated by the ModRM byte
- * in @insn. This function is to be used with 16-bit address encodings. The
- * @offs1 and @offs2 will be written with the offset of the two registers
- * indicated by the instruction. In cases where any of the registers is not
- * referenced by the instruction, the value will be set to -EDOM.
- *
- * Returns:
- *
- * 0 on success, -EINVAL on error.
- */
-static int get_reg_offset_16(struct insn *insn, struct pt_regs *regs,
-			     int *offs1, int *offs2)
-{
-	/*
-	 * 16-bit addressing can use one or two registers. Specifics of
-	 * encodings are given in Table 2-1. "16-Bit Addressing Forms with the
-	 * ModR/M Byte" of the Intel Software Development Manual.
-	 */
-	static const int regoff1[] = {
-		offsetof(struct pt_regs, bx),
-		offsetof(struct pt_regs, bx),
-		offsetof(struct pt_regs, bp),
-		offsetof(struct pt_regs, bp),
-		offsetof(struct pt_regs, si),
-		offsetof(struct pt_regs, di),
-		offsetof(struct pt_regs, bp),
-		offsetof(struct pt_regs, bx),
-	};
-
-	static const int regoff2[] = {
-		offsetof(struct pt_regs, si),
-		offsetof(struct pt_regs, di),
-		offsetof(struct pt_regs, si),
-		offsetof(struct pt_regs, di),
-		-EDOM,
-		-EDOM,
-		-EDOM,
-		-EDOM,
-	};
-
-	if (!offs1 || !offs2)
-		return -EINVAL;
-
-	/* Operand is a register, use the generic function. */
-	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
-		*offs1 = insn_get_modrm_rm_off(insn, regs);
-		*offs2 = -EDOM;
-		return 0;
-	}
-
-	*offs1 = regoff1[X86_MODRM_RM(insn->modrm.value)];
-	*offs2 = regoff2[X86_MODRM_RM(insn->modrm.value)];
-
-	/*
-	 * If ModRM.mod is 0 and ModRM.rm is 110b, then we use displacement-
-	 * only addressing. This means that no registers are involved in
-	 * computing the effective address. Thus, ensure that the first
-	 * register offset is invalid. The second register offset is already
-	 * invalid under the aforementioned conditions.
-	 */
-	if ((X86_MODRM_MOD(insn->modrm.value) == 0) &&
-	    (X86_MODRM_RM(insn->modrm.value) == 6))
-		*offs1 = -EDOM;
-
-	return 0;
-}
-
 /**
  * get_desc() - Obtain contents of a segment descriptor
  * @out:	Segment descriptor contents on success
@@ -839,58 +596,6 @@ int insn_get_code_seg_params(struct pt_regs *regs)
 	}
 }
 
-/**
- * insn_get_modrm_rm_off() - Obtain register in r/m part of the ModRM byte
- * @insn:	Instruction containing the ModRM byte
- * @regs:	Register values as seen when entering kernel mode
- *
- * Returns:
- *
- * The register indicated by the r/m part of the ModRM byte. The
- * register is obtained as an offset from the base of pt_regs. In specific
- * cases, the returned value can be -EDOM to indicate that the particular value
- * of ModRM does not refer to a register and shall be ignored.
- */
-int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs)
-{
-	return get_reg_offset(insn, regs, REG_TYPE_RM);
-}
-
-/**
- * insn_get_modrm_reg_off() - Obtain register in reg part of the ModRM byte
- * @insn:	Instruction containing the ModRM byte
- * @regs:	Register values as seen when entering kernel mode
- *
- * Returns:
- *
- * The register indicated by the reg part of the ModRM byte. The
- * register is obtained as an offset from the base of pt_regs.
- */
-int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs)
-{
-	return get_reg_offset(insn, regs, REG_TYPE_REG);
-}
-
-/**
- * insn_get_modrm_reg_ptr() - Obtain register pointer based on ModRM byte
- * @insn:	Instruction containing the ModRM byte
- * @regs:	Register values as seen when entering kernel mode
- *
- * Returns:
- *
- * The register indicated by the reg part of the ModRM byte.
- * The register is obtained as a pointer within pt_regs.
- */
-unsigned long *insn_get_modrm_reg_ptr(struct insn *insn, struct pt_regs *regs)
-{
-	int offset;
-
-	offset = insn_get_modrm_reg_off(insn, regs);
-	if (offset < 0)
-		return NULL;
-	return (void *)regs + offset;
-}
-
 /**
  * get_seg_base_limit() - obtain base address and limit of a segment
  * @insn:	Instruction. Must be valid.
@@ -939,528 +644,6 @@ static int get_seg_base_limit(struct insn *insn, struct pt_regs *regs,
 	return 0;
 }
 
-/**
- * get_eff_addr_reg() - Obtain effective address from register operand
- * @insn:	Instruction. Must be valid.
- * @regs:	Register values as seen when entering kernel mode
- * @regoff:	Obtained operand offset, in pt_regs, with the effective address
- * @eff_addr:	Obtained effective address
- *
- * Obtain the effective address stored in the register operand as indicated by
- * the ModRM byte. This function is to be used only with register addressing
- * (i.e.,  ModRM.mod is 3). The effective address is saved in @eff_addr. The
- * register operand, as an offset from the base of pt_regs, is saved in @regoff;
- * such offset can then be used to resolve the segment associated with the
- * operand. This function can be used with any of the supported address sizes
- * in x86.
- *
- * Returns:
- *
- * 0 on success. @eff_addr will have the effective address stored in the
- * operand indicated by ModRM. @regoff will have such operand as an offset from
- * the base of pt_regs.
- *
- * -EINVAL on error.
- */
-static int get_eff_addr_reg(struct insn *insn, struct pt_regs *regs,
-			    int *regoff, long *eff_addr)
-{
-	int ret;
-
-	ret = insn_get_modrm(insn);
-	if (ret)
-		return ret;
-
-	if (X86_MODRM_MOD(insn->modrm.value) != 3)
-		return -EINVAL;
-
-	*regoff = get_reg_offset(insn, regs, REG_TYPE_RM);
-	if (*regoff < 0)
-		return -EINVAL;
-
-	/* Ignore bytes that are outside the address size. */
-	if (insn->addr_bytes == 2)
-		*eff_addr = regs_get_register(regs, *regoff) & 0xffff;
-	else if (insn->addr_bytes == 4)
-		*eff_addr = regs_get_register(regs, *regoff) & 0xffffffff;
-	else /* 64-bit address */
-		*eff_addr = regs_get_register(regs, *regoff);
-
-	return 0;
-}
-
-/**
- * get_eff_addr_modrm() - Obtain referenced effective address via ModRM
- * @insn:	Instruction. Must be valid.
- * @regs:	Register values as seen when entering kernel mode
- * @regoff:	Obtained operand offset, in pt_regs, associated with segment
- * @eff_addr:	Obtained effective address
- *
- * Obtain the effective address referenced by the ModRM byte of @insn. After
- * identifying the registers involved in the register-indirect memory reference,
- * its value is obtained from the operands in @regs. The computed address is
- * stored @eff_addr. Also, the register operand that indicates the associated
- * segment is stored in @regoff, this parameter can later be used to determine
- * such segment.
- *
- * Returns:
- *
- * 0 on success. @eff_addr will have the referenced effective address. @regoff
- * will have a register, as an offset from the base of pt_regs, that can be used
- * to resolve the associated segment.
- *
- * -EINVAL on error.
- */
-static int get_eff_addr_modrm(struct insn *insn, struct pt_regs *regs,
-			      int *regoff, long *eff_addr)
-{
-	long tmp;
-	int ret;
-
-	if (insn->addr_bytes != 8 && insn->addr_bytes != 4)
-		return -EINVAL;
-
-	ret = insn_get_modrm(insn);
-	if (ret)
-		return ret;
-
-	if (X86_MODRM_MOD(insn->modrm.value) > 2)
-		return -EINVAL;
-
-	*regoff = get_reg_offset(insn, regs, REG_TYPE_RM);
-
-	/*
-	 * -EDOM means that we must ignore the address_offset. In such a case,
-	 * in 64-bit mode the effective address relative to the rIP of the
-	 * following instruction.
-	 */
-	if (*regoff == -EDOM) {
-		if (any_64bit_mode(regs))
-			tmp = regs->ip + insn->length;
-		else
-			tmp = 0;
-	} else if (*regoff < 0) {
-		return -EINVAL;
-	} else {
-		tmp = regs_get_register(regs, *regoff);
-	}
-
-	if (insn->addr_bytes == 4) {
-		int addr32 = (int)(tmp & 0xffffffff) + insn->displacement.value;
-
-		*eff_addr = addr32 & 0xffffffff;
-	} else {
-		*eff_addr = tmp + insn->displacement.value;
-	}
-
-	return 0;
-}
-
-/**
- * get_eff_addr_modrm_16() - Obtain referenced effective address via ModRM
- * @insn:	Instruction. Must be valid.
- * @regs:	Register values as seen when entering kernel mode
- * @regoff:	Obtained operand offset, in pt_regs, associated with segment
- * @eff_addr:	Obtained effective address
- *
- * Obtain the 16-bit effective address referenced by the ModRM byte of @insn.
- * After identifying the registers involved in the register-indirect memory
- * reference, its value is obtained from the operands in @regs. The computed
- * address is stored @eff_addr. Also, the register operand that indicates
- * the associated segment is stored in @regoff, this parameter can later be used
- * to determine such segment.
- *
- * Returns:
- *
- * 0 on success. @eff_addr will have the referenced effective address. @regoff
- * will have a register, as an offset from the base of pt_regs, that can be used
- * to resolve the associated segment.
- *
- * -EINVAL on error.
- */
-static int get_eff_addr_modrm_16(struct insn *insn, struct pt_regs *regs,
-				 int *regoff, short *eff_addr)
-{
-	int addr_offset1, addr_offset2, ret;
-	short addr1 = 0, addr2 = 0, displacement;
-
-	if (insn->addr_bytes != 2)
-		return -EINVAL;
-
-	insn_get_modrm(insn);
-
-	if (!insn->modrm.nbytes)
-		return -EINVAL;
-
-	if (X86_MODRM_MOD(insn->modrm.value) > 2)
-		return -EINVAL;
-
-	ret = get_reg_offset_16(insn, regs, &addr_offset1, &addr_offset2);
-	if (ret < 0)
-		return -EINVAL;
-
-	/*
-	 * Don't fail on invalid offset values. They might be invalid because
-	 * they cannot be used for this particular value of ModRM. Instead, use
-	 * them in the computation only if they contain a valid value.
-	 */
-	if (addr_offset1 != -EDOM)
-		addr1 = regs_get_register(regs, addr_offset1) & 0xffff;
-
-	if (addr_offset2 != -EDOM)
-		addr2 = regs_get_register(regs, addr_offset2) & 0xffff;
-
-	displacement = insn->displacement.value & 0xffff;
-	*eff_addr = addr1 + addr2 + displacement;
-
-	/*
-	 * The first operand register could indicate to use of either SS or DS
-	 * registers to obtain the segment selector.  The second operand
-	 * register can only indicate the use of DS. Thus, the first operand
-	 * will be used to obtain the segment selector.
-	 */
-	*regoff = addr_offset1;
-
-	return 0;
-}
-
-/**
- * get_eff_addr_sib() - Obtain referenced effective address via SIB
- * @insn:	Instruction. Must be valid.
- * @regs:	Register values as seen when entering kernel mode
- * @regoff:	Obtained operand offset, in pt_regs, associated with segment
- * @eff_addr:	Obtained effective address
- *
- * Obtain the effective address referenced by the SIB byte of @insn. After
- * identifying the registers involved in the indexed, register-indirect memory
- * reference, its value is obtained from the operands in @regs. The computed
- * address is stored @eff_addr. Also, the register operand that indicates the
- * associated segment is stored in @regoff, this parameter can later be used to
- * determine such segment.
- *
- * Returns:
- *
- * 0 on success. @eff_addr will have the referenced effective address.
- * @base_offset will have a register, as an offset from the base of pt_regs,
- * that can be used to resolve the associated segment.
- *
- * Negative value on error.
- */
-static int get_eff_addr_sib(struct insn *insn, struct pt_regs *regs,
-			    int *base_offset, long *eff_addr)
-{
-	long base, indx;
-	int indx_offset;
-	int ret;
-
-	if (insn->addr_bytes != 8 && insn->addr_bytes != 4)
-		return -EINVAL;
-
-	ret = insn_get_modrm(insn);
-	if (ret)
-		return ret;
-
-	if (!insn->modrm.nbytes)
-		return -EINVAL;
-
-	if (X86_MODRM_MOD(insn->modrm.value) > 2)
-		return -EINVAL;
-
-	ret = insn_get_sib(insn);
-	if (ret)
-		return ret;
-
-	if (!insn->sib.nbytes)
-		return -EINVAL;
-
-	*base_offset = get_reg_offset(insn, regs, REG_TYPE_BASE);
-	indx_offset = get_reg_offset(insn, regs, REG_TYPE_INDEX);
-
-	/*
-	 * Negative values in the base and index offset means an error when
-	 * decoding the SIB byte. Except -EDOM, which means that the registers
-	 * should not be used in the address computation.
-	 */
-	if (*base_offset == -EDOM)
-		base = 0;
-	else if (*base_offset < 0)
-		return -EINVAL;
-	else
-		base = regs_get_register(regs, *base_offset);
-
-	if (indx_offset == -EDOM)
-		indx = 0;
-	else if (indx_offset < 0)
-		return -EINVAL;
-	else
-		indx = regs_get_register(regs, indx_offset);
-
-	if (insn->addr_bytes == 4) {
-		int addr32, base32, idx32;
-
-		base32 = base & 0xffffffff;
-		idx32 = indx & 0xffffffff;
-
-		addr32 = base32 + idx32 * (1 << X86_SIB_SCALE(insn->sib.value));
-		addr32 += insn->displacement.value;
-
-		*eff_addr = addr32 & 0xffffffff;
-	} else {
-		*eff_addr = base + indx * (1 << X86_SIB_SCALE(insn->sib.value));
-		*eff_addr += insn->displacement.value;
-	}
-
-	return 0;
-}
-
-/**
- * get_addr_ref_16() - Obtain the 16-bit address referred by instruction
- * @insn:	Instruction containing ModRM byte and displacement
- * @regs:	Register values as seen when entering kernel mode
- *
- * This function is to be used with 16-bit address encodings. Obtain the memory
- * address referred by the instruction's ModRM and displacement bytes. Also, the
- * segment used as base is determined by either any segment override prefixes in
- * @insn or the default segment of the registers involved in the address
- * computation. In protected mode, segment limits are enforced.
- *
- * Returns:
- *
- * Linear address referenced by the instruction operands on success.
- *
- * -1L on error.
- */
-static void __user *get_addr_ref_16(struct insn *insn, struct pt_regs *regs)
-{
-	unsigned long linear_addr = -1L, seg_base, seg_limit;
-	int ret, regoff;
-	short eff_addr;
-	long tmp;
-
-	if (insn_get_displacement(insn))
-		goto out;
-
-	if (insn->addr_bytes != 2)
-		goto out;
-
-	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
-		ret = get_eff_addr_reg(insn, regs, &regoff, &tmp);
-		if (ret)
-			goto out;
-
-		eff_addr = tmp;
-	} else {
-		ret = get_eff_addr_modrm_16(insn, regs, &regoff, &eff_addr);
-		if (ret)
-			goto out;
-	}
-
-	ret = get_seg_base_limit(insn, regs, regoff, &seg_base, &seg_limit);
-	if (ret)
-		goto out;
-
-	/*
-	 * Before computing the linear address, make sure the effective address
-	 * is within the limits of the segment. In virtual-8086 mode, segment
-	 * limits are not enforced. In such a case, the segment limit is -1L to
-	 * reflect this fact.
-	 */
-	if ((unsigned long)(eff_addr & 0xffff) > seg_limit)
-		goto out;
-
-	linear_addr = (unsigned long)(eff_addr & 0xffff) + seg_base;
-
-	/* Limit linear address to 20 bits */
-	if (v8086_mode(regs))
-		linear_addr &= 0xfffff;
-
-out:
-	return (void __user *)linear_addr;
-}
-
-/**
- * get_addr_ref_32() - Obtain a 32-bit linear address
- * @insn:	Instruction with ModRM, SIB bytes and displacement
- * @regs:	Register values as seen when entering kernel mode
- *
- * This function is to be used with 32-bit address encodings to obtain the
- * linear memory address referred by the instruction's ModRM, SIB,
- * displacement bytes and segment base address, as applicable. If in protected
- * mode, segment limits are enforced.
- *
- * Returns:
- *
- * Linear address referenced by instruction and registers on success.
- *
- * -1L on error.
- */
-static void __user *get_addr_ref_32(struct insn *insn, struct pt_regs *regs)
-{
-	unsigned long linear_addr = -1L, seg_base, seg_limit;
-	int eff_addr, regoff;
-	long tmp;
-	int ret;
-
-	if (insn->addr_bytes != 4)
-		goto out;
-
-	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
-		ret = get_eff_addr_reg(insn, regs, &regoff, &tmp);
-		if (ret)
-			goto out;
-
-		eff_addr = tmp;
-
-	} else {
-		if (insn->sib.nbytes) {
-			ret = get_eff_addr_sib(insn, regs, &regoff, &tmp);
-			if (ret)
-				goto out;
-
-			eff_addr = tmp;
-		} else {
-			ret = get_eff_addr_modrm(insn, regs, &regoff, &tmp);
-			if (ret)
-				goto out;
-
-			eff_addr = tmp;
-		}
-	}
-
-	ret = get_seg_base_limit(insn, regs, regoff, &seg_base, &seg_limit);
-	if (ret)
-		goto out;
-
-	/*
-	 * In protected mode, before computing the linear address, make sure
-	 * the effective address is within the limits of the segment.
-	 * 32-bit addresses can be used in long and virtual-8086 modes if an
-	 * address override prefix is used. In such cases, segment limits are
-	 * not enforced. When in virtual-8086 mode, the segment limit is -1L
-	 * to reflect this situation.
-	 *
-	 * After computed, the effective address is treated as an unsigned
-	 * quantity.
-	 */
-	if (!any_64bit_mode(regs) && ((unsigned int)eff_addr > seg_limit))
-		goto out;
-
-	/*
-	 * Even though 32-bit address encodings are allowed in virtual-8086
-	 * mode, the address range is still limited to [0x-0xffff].
-	 */
-	if (v8086_mode(regs) && (eff_addr & ~0xffff))
-		goto out;
-
-	/*
-	 * Data type long could be 64 bits in size. Ensure that our 32-bit
-	 * effective address is not sign-extended when computing the linear
-	 * address.
-	 */
-	linear_addr = (unsigned long)(eff_addr & 0xffffffff) + seg_base;
-
-	/* Limit linear address to 20 bits */
-	if (v8086_mode(regs))
-		linear_addr &= 0xfffff;
-
-out:
-	return (void __user *)linear_addr;
-}
-
-/**
- * get_addr_ref_64() - Obtain a 64-bit linear address
- * @insn:	Instruction struct with ModRM and SIB bytes and displacement
- * @regs:	Structure with register values as seen when entering kernel mode
- *
- * This function is to be used with 64-bit address encodings to obtain the
- * linear memory address referred by the instruction's ModRM, SIB,
- * displacement bytes and segment base address, as applicable.
- *
- * Returns:
- *
- * Linear address referenced by instruction and registers on success.
- *
- * -1L on error.
- */
-#ifndef CONFIG_X86_64
-static void __user *get_addr_ref_64(struct insn *insn, struct pt_regs *regs)
-{
-	return (void __user *)-1L;
-}
-#else
-static void __user *get_addr_ref_64(struct insn *insn, struct pt_regs *regs)
-{
-	unsigned long linear_addr = -1L, seg_base;
-	int regoff, ret;
-	long eff_addr;
-
-	if (insn->addr_bytes != 8)
-		goto out;
-
-	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
-		ret = get_eff_addr_reg(insn, regs, &regoff, &eff_addr);
-		if (ret)
-			goto out;
-
-	} else {
-		if (insn->sib.nbytes) {
-			ret = get_eff_addr_sib(insn, regs, &regoff, &eff_addr);
-			if (ret)
-				goto out;
-		} else {
-			ret = get_eff_addr_modrm(insn, regs, &regoff, &eff_addr);
-			if (ret)
-				goto out;
-		}
-
-	}
-
-	ret = get_seg_base_limit(insn, regs, regoff, &seg_base, NULL);
-	if (ret)
-		goto out;
-
-	linear_addr = (unsigned long)eff_addr + seg_base;
-
-out:
-	return (void __user *)linear_addr;
-}
-#endif /* CONFIG_X86_64 */
-
-/**
- * insn_get_addr_ref() - Obtain the linear address referred by instruction
- * @insn:	Instruction structure containing ModRM byte and displacement
- * @regs:	Structure with register values as seen when entering kernel mode
- *
- * Obtain the linear address referred by the instruction's ModRM, SIB and
- * displacement bytes, and segment base, as applicable. In protected mode,
- * segment limits are enforced.
- *
- * Returns:
- *
- * Linear address referenced by instruction and registers on success.
- *
- * -1L on error.
- */
-void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
-{
-	if (!insn || !regs)
-		return (void __user *)-1L;
-
-	if (insn_get_opcode(insn))
-		return (void __user *)-1L;
-
-	switch (insn->addr_bytes) {
-	case 2:
-		return get_addr_ref_16(insn, regs);
-	case 4:
-		return get_addr_ref_32(insn, regs);
-	case 8:
-		return get_addr_ref_64(insn, regs);
-	default:
-		return (void __user *)-1L;
-	}
-}
-
 int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
 {
 	unsigned long seg_base = 0;
@@ -1583,87 +766,3 @@ bool insn_decode_from_regs(struct insn *insn, struct pt_regs *regs,
 
 	return true;
 }
-
-/**
- * insn_decode_mmio() - Decode a MMIO instruction
- * @insn:	Structure to store decoded instruction
- * @bytes:	Returns size of memory operand
- *
- * Decodes instruction that used for Memory-mapped I/O.
- *
- * Returns:
- *
- * Type of the instruction. Size of the memory operand is stored in
- * @bytes. If decode failed, MMIO_DECODE_FAILED returned.
- */
-enum mmio_type insn_decode_mmio(struct insn *insn, int *bytes)
-{
-	enum mmio_type type = MMIO_DECODE_FAILED;
-
-	*bytes = 0;
-
-	if (insn_get_opcode(insn))
-		return MMIO_DECODE_FAILED;
-
-	switch (insn->opcode.bytes[0]) {
-	case 0x88: /* MOV m8,r8 */
-		*bytes = 1;
-		fallthrough;
-	case 0x89: /* MOV m16/m32/m64, r16/m32/m64 */
-		if (!*bytes)
-			*bytes = insn->opnd_bytes;
-		type = MMIO_WRITE;
-		break;
-
-	case 0xc6: /* MOV m8, imm8 */
-		*bytes = 1;
-		fallthrough;
-	case 0xc7: /* MOV m16/m32/m64, imm16/imm32/imm64 */
-		if (!*bytes)
-			*bytes = insn->opnd_bytes;
-		type = MMIO_WRITE_IMM;
-		break;
-
-	case 0x8a: /* MOV r8, m8 */
-		*bytes = 1;
-		fallthrough;
-	case 0x8b: /* MOV r16/r32/r64, m16/m32/m64 */
-		if (!*bytes)
-			*bytes = insn->opnd_bytes;
-		type = MMIO_READ;
-		break;
-
-	case 0xa4: /* MOVS m8, m8 */
-		*bytes = 1;
-		fallthrough;
-	case 0xa5: /* MOVS m16/m32/m64, m16/m32/m64 */
-		if (!*bytes)
-			*bytes = insn->opnd_bytes;
-		type = MMIO_MOVS;
-		break;
-
-	case 0x0f: /* Two-byte instruction */
-		switch (insn->opcode.bytes[1]) {
-		case 0xb6: /* MOVZX r16/r32/r64, m8 */
-			*bytes = 1;
-			fallthrough;
-		case 0xb7: /* MOVZX r32/r64, m16 */
-			if (!*bytes)
-				*bytes = 2;
-			type = MMIO_READ_ZERO_EXTEND;
-			break;
-
-		case 0xbe: /* MOVSX r16/r32/r64, m8 */
-			*bytes = 1;
-			fallthrough;
-		case 0xbf: /* MOVSX r32/r64, m16 */
-			if (!*bytes)
-				*bytes = 2;
-			type = MMIO_READ_SIGN_EXTEND;
-			break;
-		}
-		break;
-	}
-
-	return type;
-}
-- 
2.34.1

