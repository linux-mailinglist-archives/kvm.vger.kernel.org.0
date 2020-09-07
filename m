Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404A32602F8
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731105AbgIGRkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgIGNSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:18:01 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC312C061755;
        Mon,  7 Sep 2020 06:17:58 -0700 (PDT)
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 5AF5412C6;
        Mon,  7 Sep 2020 15:17:07 +0200 (CEST)
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
Subject: [PATCH v7 49/72] x86/sev-es: Handle MMIO events
Date:   Mon,  7 Sep 2020 15:15:50 +0200
Message-Id: <20200907131613.12703-50-joro@8bytes.org>
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

Add handler for VC exceptions caused by MMIO intercepts. These
intercepts come along as nested page faults on pages with reserved
bits set.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to VC handling framework ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/uapi/asm/svm.h |   5 +
 arch/x86/kernel/sev-es.c        | 222 ++++++++++++++++++++++++++++++++
 2 files changed, 227 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index c68d1618c9b0..8f36ae021a7f 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -81,6 +81,11 @@
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 
+/* SEV-ES software-defined VMGEXIT events */
+#define SVM_VMGEXIT_MMIO_READ			0x80000001
+#define SVM_VMGEXIT_MMIO_WRITE			0x80000002
+#define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
+
 #define SVM_EXIT_ERR           -1
 
 #define SVM_EXIT_REASONS \
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index bc2854b81a51..62fd0ebf2a67 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -359,6 +359,37 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 	return ES_EXCEPTION;
 }
 
+static bool vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
+				 unsigned long vaddr, phys_addr_t *paddr)
+{
+	unsigned long va = (unsigned long)vaddr;
+	unsigned int level;
+	phys_addr_t pa;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	pgd = __va(read_cr3_pa());
+	pgd = &pgd[pgd_index(va)];
+	pte = lookup_address_in_pgd(pgd, va, &level);
+	if (!pte) {
+		ctxt->fi.vector     = X86_TRAP_PF;
+		ctxt->fi.cr2        = vaddr;
+		ctxt->fi.error_code = 0;
+
+		if (user_mode(ctxt->regs))
+			ctxt->fi.error_code |= X86_PF_USER;
+
+		return false;
+	}
+
+	pa = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
+	pa |= va & ~page_level_mask(level);
+
+	*paddr = pa;
+
+	return true;
+}
+
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
@@ -447,6 +478,194 @@ static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
 	do_early_exception(ctxt->regs, trapnr);
 }
 
+static long *vc_insn_get_reg(struct es_em_ctxt *ctxt)
+{
+	long *reg_array;
+	int offset;
+
+	reg_array = (long *)ctxt->regs;
+	offset    = insn_get_modrm_reg_off(&ctxt->insn, ctxt->regs);
+
+	if (offset < 0)
+		return NULL;
+
+	offset /= sizeof(long);
+
+	return reg_array + offset;
+}
+
+static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
+				 unsigned int bytes, bool read)
+{
+	u64 exit_code, exit_info_1, exit_info_2;
+	unsigned long ghcb_pa = __pa(ghcb);
+	phys_addr_t paddr;
+	void __user *ref;
+
+	ref = insn_get_addr_ref(&ctxt->insn, ctxt->regs);
+	if (ref == (void __user *)-1L)
+		return ES_UNSUPPORTED;
+
+	exit_code = read ? SVM_VMGEXIT_MMIO_READ : SVM_VMGEXIT_MMIO_WRITE;
+
+	if (!vc_slow_virt_to_phys(ghcb, ctxt, (unsigned long)ref, &paddr)) {
+		if (!read)
+			ctxt->fi.error_code |= X86_PF_WRITE;
+
+		return ES_EXCEPTION;
+	}
+
+	exit_info_1 = paddr;
+	/* Can never be greater than 8 */
+	exit_info_2 = bytes;
+
+	ghcb->save.sw_scratch = ghcb_pa + offsetof(struct ghcb, shared_buffer);
+
+	return sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1, exit_info_2);
+}
+
+static enum es_result vc_handle_mmio_twobyte_ops(struct ghcb *ghcb,
+						 struct es_em_ctxt *ctxt)
+{
+	struct insn *insn = &ctxt->insn;
+	unsigned int bytes = 0;
+	enum es_result ret;
+	int sign_byte;
+	long *reg_data;
+
+	switch (insn->opcode.bytes[1]) {
+		/* MMIO Read w/ zero-extension */
+	case 0xb6:
+		bytes = 1;
+		fallthrough;
+	case 0xb7:
+		if (!bytes)
+			bytes = 2;
+
+		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		/* Zero extend based on operand size */
+		reg_data = vc_insn_get_reg(ctxt);
+		if (!reg_data)
+			return ES_DECODE_FAILED;
+
+		memset(reg_data, 0, insn->opnd_bytes);
+
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+
+		/* MMIO Read w/ sign-extension */
+	case 0xbe:
+		bytes = 1;
+		fallthrough;
+	case 0xbf:
+		if (!bytes)
+			bytes = 2;
+
+		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		/* Sign extend based on operand size */
+		reg_data = vc_insn_get_reg(ctxt);
+		if (!reg_data)
+			return ES_DECODE_FAILED;
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
+		memset(reg_data, sign_byte, insn->opnd_bytes);
+
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+
+	default:
+		ret = ES_UNSUPPORTED;
+	}
+
+	return ret;
+}
+
+static enum es_result vc_handle_mmio(struct ghcb *ghcb,
+				     struct es_em_ctxt *ctxt)
+{
+	struct insn *insn = &ctxt->insn;
+	unsigned int bytes = 0;
+	enum es_result ret;
+	long *reg_data;
+
+	switch (insn->opcode.bytes[0]) {
+	/* MMIO Write */
+	case 0x88:
+		bytes = 1;
+		fallthrough;
+	case 0x89:
+		if (!bytes)
+			bytes = insn->opnd_bytes;
+
+		reg_data = vc_insn_get_reg(ctxt);
+		if (!reg_data)
+			return ES_DECODE_FAILED;
+
+		memcpy(ghcb->shared_buffer, reg_data, bytes);
+
+		ret = vc_do_mmio(ghcb, ctxt, bytes, false);
+		break;
+
+	case 0xc6:
+		bytes = 1;
+		fallthrough;
+	case 0xc7:
+		if (!bytes)
+			bytes = insn->opnd_bytes;
+
+		memcpy(ghcb->shared_buffer, insn->immediate1.bytes, bytes);
+
+		ret = vc_do_mmio(ghcb, ctxt, bytes, false);
+		break;
+
+		/* MMIO Read */
+	case 0x8a:
+		bytes = 1;
+		fallthrough;
+	case 0x8b:
+		if (!bytes)
+			bytes = insn->opnd_bytes;
+
+		ret = vc_do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		reg_data = vc_insn_get_reg(ctxt);
+		if (!reg_data)
+			return ES_DECODE_FAILED;
+
+		/* Zero-extend for 32-bit operation */
+		if (bytes == 4)
+			*reg_data = 0;
+
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+
+		/* Two-Byte Opcodes */
+	case 0x0f:
+		ret = vc_handle_mmio_twobyte_ops(ghcb, ctxt);
+		break;
+	default:
+		ret = ES_UNSUPPORTED;
+	}
+
+	return ret;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -460,6 +679,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_IOIO:
 		result = vc_handle_ioio(ghcb, ctxt);
 		break;
+	case SVM_EXIT_NPF:
+		result = vc_handle_mmio(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.28.0

