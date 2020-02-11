Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B39015910E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgBKN5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:57:43 -0500
Received: from 8bytes.org ([81.169.241.247]:52218 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729508AbgBKNxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:22 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 018F6E06; Tue, 11 Feb 2020 14:53:10 +0100 (CET)
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
Subject: [PATCH 22/62] x86/sev-es: Add handler for MMIO events
Date:   Tue, 11 Feb 2020 14:52:16 +0100
Message-Id: <20200211135256.24617-23-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add handler for VC exceptions caused by MMIO intercepts. These
intercepts come along as nested page faults on pages with reserved
bits set.

TODO:
	- Add return values of helper functions
	- Check permissions on page-table walks
	- Check data segments
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to VC handling framework ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/sev-es.c |   8 +
 arch/x86/include/uapi/asm/svm.h   |   5 +
 arch/x86/kernel/sev-es-shared.c   | 236 ++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 270a23c05f53..55a78b42a2f2 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -67,6 +67,11 @@ static enum es_result es_read_mem(struct es_em_ctxt *ctxt,
 	return ES_OK;
 }
 
+static phys_addr_t es_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
+{
+	return (phys_addr_t)vaddr;
+}
+
 #undef __init
 #undef __pa
 #define __init
@@ -121,6 +126,9 @@ void boot_vc_handler(struct pt_regs *regs)
 	case SVM_EXIT_CPUID:
 		result = handle_cpuid(boot_ghcb, &ctxt);
 		break;
+	case SVM_EXIT_NPF:
+		result = handle_mmio(boot_ghcb, &ctxt);
+		break;
 	default:
 		result = ES_UNSUPPORTED;
 		break;
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
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index 0f422e3b2077..14693eff9614 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -483,3 +483,239 @@ static enum es_result handle_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 
 	return ES_OK;
 }
+
+/* Map from x86 register index to pt_regs offset */
+static unsigned long *register_from_idx(struct pt_regs *regs, u8 reg)
+{
+	static int reg2pt_regs[] = {
+		10, 11, 12, 5, 19, 4, 13, 14, 9, 8, 7, 6, 3, 2, 1, 0
+	};
+	unsigned long *regs_array = (unsigned long *)regs;
+
+	if (WARN_ONCE(reg > 15, "register index is not valid: %#hhx\n", reg))
+		return NULL;
+
+	return &regs_array[reg2pt_regs[reg]];
+}
+
+static u64 insn_get_eff_addr(struct es_em_ctxt *ctxt)
+{
+	u64 effective_addr;
+	u8 mod, rm;
+
+	if (!ctxt->insn.modrm.nbytes)
+		return 0;
+
+	if (insn_rip_relative(&ctxt->insn))
+		return ctxt->regs->ip + ctxt->insn.displacement.value;
+
+	mod = X86_MODRM_MOD(ctxt->insn.modrm.value);
+	rm = X86_MODRM_RM(ctxt->insn.modrm.value);
+
+	if (ctxt->insn.rex_prefix.nbytes &&
+	    X86_REX_B(ctxt->insn.rex_prefix.value))
+		rm |= 0x8;
+
+	if (mod == 3)
+		return *register_from_idx(ctxt->regs, rm);
+
+	switch (mod) {
+	case 1:
+	case 2:
+		effective_addr = ctxt->insn.displacement.value;
+		break;
+	default:
+		effective_addr = 0;
+	}
+
+	if (ctxt->insn.sib.nbytes) {
+		u8 scale, index, base;
+
+		scale = X86_SIB_SCALE(ctxt->insn.sib.value);
+		index = X86_SIB_INDEX(ctxt->insn.sib.value);
+		base = X86_SIB_BASE(ctxt->insn.sib.value);
+		if (ctxt->insn.rex_prefix.nbytes &&
+		    X86_REX_X(ctxt->insn.rex_prefix.value))
+			index |= 0x8;
+		if (ctxt->insn.rex_prefix.nbytes &&
+		    X86_REX_B(ctxt->insn.rex_prefix.value))
+			base |= 0x8;
+
+		if (index != 4)
+			effective_addr += (*register_from_idx(ctxt->regs, index)
+					   << scale);
+
+		if ((base != 5) || mod)
+			effective_addr += *register_from_idx(ctxt->regs, base);
+		else
+			effective_addr += ctxt->insn.displacement.value;
+	} else {
+		effective_addr += *register_from_idx(ctxt->regs, rm);
+	}
+
+	return effective_addr;
+}
+
+static unsigned long *insn_get_reg(struct es_em_ctxt *ctxt)
+{
+	u8 reg;
+
+	if (!ctxt->insn.modrm.nbytes)
+		return NULL;
+
+	reg = X86_MODRM_REG(ctxt->insn.modrm.value);
+	if (ctxt->insn.rex_prefix.nbytes &&
+	    X86_REX_R(ctxt->insn.rex_prefix.value))
+		reg |= 0x8;
+
+	return register_from_idx(ctxt->regs, reg);
+}
+
+static enum es_result do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
+			      unsigned int bytes, bool read)
+{
+	u64 exit_code, exit_info_1, exit_info_2;
+	unsigned long ghcb_pa = __pa(ghcb);
+
+	/* Register-direct addressing mode not supported with MMIO */
+	if (X86_MODRM_MOD(ctxt->insn.modrm.value) == 3)
+		return ES_UNSUPPORTED;
+
+	exit_code = read ? SVM_VMGEXIT_MMIO_READ : SVM_VMGEXIT_MMIO_WRITE;
+
+	exit_info_1 = insn_get_eff_addr(ctxt);
+	exit_info_1 = es_slow_virt_to_phys(ghcb, exit_info_1);
+	exit_info_2 = bytes;    /* Can never be greater than 8 */
+
+	ghcb->save.sw_scratch = ghcb_pa + offsetof(struct ghcb, shared_buffer);
+
+	return ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1, exit_info_2);
+}
+
+static enum es_result handle_mmio_twobyte_ops(struct ghcb *ghcb,
+					      struct es_em_ctxt *ctxt)
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
+		/* Fallthrough */
+	case 0xb7:
+		if (!bytes)
+			bytes = 2;
+
+		ret = do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		/* Zero extend based on operand size */
+		reg_data = insn_get_reg(ctxt);
+		memset(reg_data, 0, insn->opnd_bytes);
+
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+
+		/* MMIO Read w/ sign-extension */
+	case 0xbe:
+		bytes = 1;
+		/* Fallthrough */
+	case 0xbf:
+		if (!bytes)
+			bytes = 2;
+
+		ret = do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		/* Sign extend based on operand size */
+		reg_data = insn_get_reg(ctxt);
+		if (bytes == 1) {
+			u8 *val = (u8 *)ghcb->shared_buffer;
+
+			sign_byte = (*val & 0x80) ? 0x00 : 0xff;
+		} else {
+			u16 *val = (u16 *)ghcb->shared_buffer;
+
+			sign_byte = (*val & 0x8000) ? 0x00 : 0xff;
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
+static enum es_result handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
+		/* Fallthrough */
+	case 0x89:
+		if (!bytes)
+			bytes = insn->opnd_bytes;
+
+		reg_data = insn_get_reg(ctxt);
+		memcpy(ghcb->shared_buffer, reg_data, bytes);
+
+		ret = do_mmio(ghcb, ctxt, bytes, false);
+		break;
+
+	case 0xc6:
+		bytes = 1;
+		/* Fallthrough */
+	case 0xc7:
+		if (!bytes)
+			bytes = insn->opnd_bytes;
+
+		memcpy(ghcb->shared_buffer, insn->immediate1.bytes, bytes);
+
+		ret = do_mmio(ghcb, ctxt, bytes, false);
+		break;
+
+		/* MMIO Read */
+	case 0x8a:
+		bytes = 1;
+		/* Fallthrough */
+	case 0x8b:
+		if (!bytes)
+			bytes = insn->opnd_bytes;
+
+		ret = do_mmio(ghcb, ctxt, bytes, true);
+		if (ret)
+			break;
+
+		reg_data = insn_get_reg(ctxt);
+		if (bytes == 4)
+			*reg_data = 0;  /* Zero-extend for 32-bit operation */
+
+		memcpy(reg_data, ghcb->shared_buffer, bytes);
+		break;
+
+		/* Two-Byte Opcodes */
+	case 0x0f:
+		ret = handle_mmio_twobyte_ops(ghcb, ctxt);
+		break;
+	default:
+		ret = ES_UNSUPPORTED;
+	}
+
+	return ret;
+}
-- 
2.17.1

