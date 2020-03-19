Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8CE18AFA3
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgCSJSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:18:35 -0400
Received: from 8bytes.org ([81.169.241.247]:52340 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbgCSJOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:33 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 383F948C; Thu, 19 Mar 2020 10:14:20 +0100 (CET)
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
Subject: [PATCH 22/70] x86/boot/compressed/64: Setup GHCB Based VC Exception handler
Date:   Thu, 19 Mar 2020 10:13:19 +0100
Message-Id: <20200319091407.1481-23-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Install an exception handler for #VC exception that uses a GHCB. Also
add the infrastructure for handling different exit-codes by decoding
the instruction that caused the exception and error handling.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/Kconfig                           |   1 +
 arch/x86/boot/compressed/idt_64.c          |   4 +
 arch/x86/boot/compressed/idt_handlers_64.S |   1 +
 arch/x86/boot/compressed/misc.h            |   1 +
 arch/x86/boot/compressed/sev-es.c          |  94 ++++++++++++++
 arch/x86/include/asm/sev-es.h              |  33 +++++
 arch/x86/include/uapi/asm/svm.h            |   1 +
 arch/x86/kernel/sev-es-shared.c            | 142 +++++++++++++++++++++
 8 files changed, 277 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beea77046f9b..c12347492589 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1526,6 +1526,7 @@ config AMD_MEM_ENCRYPT
 	select DYNAMIC_PHYSICAL_MASK
 	select ARCH_USE_MEMREMAP_PROT
 	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
+	select INSTRUCTION_DECODER
 	---help---
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
index bdd20dfd1fd0..eebb2f857dac 100644
--- a/arch/x86/boot/compressed/idt_64.c
+++ b/arch/x86/boot/compressed/idt_64.c
@@ -45,5 +45,9 @@ void load_stage2_idt(void)
 
 	set_idt_entry(X86_TRAP_PF, boot_pf_handler);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	set_idt_entry(X86_TRAP_VC, boot_stage2_vc_handler);
+#endif
+
 	load_boot_idt(&boot_idt_desc);
 }
diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
index 67ddafab2943..04edeb73d2cf 100644
--- a/arch/x86/boot/compressed/idt_handlers_64.S
+++ b/arch/x86/boot/compressed/idt_handlers_64.S
@@ -78,4 +78,5 @@ EXCEPTION_HANDLER	boot_pf_handler do_boot_page_fault error_code=1
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 EXCEPTION_HANDLER	boot_stage1_vc_handler vc_no_ghcb_handler error_code=1
+EXCEPTION_HANDLER	boot_stage2_vc_handler boot_vc_handler error_code=1
 #endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 42f68a858a35..567d71ab5ed9 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -143,5 +143,6 @@ extern struct desc_ptr boot_idt_desc;
 /* IDT Entry Points */
 void boot_pf_handler(void);
 void boot_stage1_vc_handler(void);
+void boot_stage2_vc_handler(void);
 
 #endif /* BOOT_COMPRESSED_MISC_H */
diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index eeeb3553547c..193c970a3379 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -8,12 +8,16 @@
 #include <linux/kernel.h>
 
 #include <asm/sev-es.h>
+#include <asm/trap_defs.h>
 #include <asm/msr-index.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
 
 #include "misc.h"
 
+struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
+struct ghcb *boot_ghcb;
+
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
 	unsigned long low, high;
@@ -35,8 +39,98 @@ static inline void sev_es_wr_ghcb_msr(u64 val)
 			"a"(low), "d" (high) : "memory");
 }
 
+static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
+{
+	char buffer[MAX_INSN_SIZE];
+	enum es_result ret;
+
+	memcpy(buffer, (unsigned char *)ctxt->regs->ip, MAX_INSN_SIZE);
+
+	insn_init(&ctxt->insn, buffer, MAX_INSN_SIZE, 1);
+	insn_get_length(&ctxt->insn);
+
+	ret = ctxt->insn.immediate.got ? ES_OK : ES_DECODE_FAILED;
+
+	return ret;
+}
+
+static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
+				   void *dst, char *buf, size_t size)
+{
+	memcpy(dst, buf, size);
+
+	return ES_OK;
+}
+
+static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
+				  void *src, char *buf, size_t size)
+{
+	memcpy(buf, src, size);
+
+	return ES_OK;
+}
+
 #undef __init
+#undef __pa
 #define __init
+#define __pa(x)	((unsigned long)(x))
+
+#define __BOOT_COMPRESSED
+
+/* Basic instruction decoding support needed */
+#include "../../lib/inat.c"
+#include "../../lib/insn.c"
 
 /* Include code for early handlers */
 #include "../../kernel/sev-es-shared.c"
+
+static bool sev_es_setup_ghcb(void)
+{
+	if (!sev_es_negotiate_protocol())
+		sev_es_terminate(GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
+
+	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
+		return false;
+
+	/* Page is now mapped decrypted, clear it */
+	memset(&boot_ghcb_page, 0, sizeof(boot_ghcb_page));
+
+	boot_ghcb = &boot_ghcb_page;
+
+	/* Initialize lookup tables for the instruction decoder */
+	inat_init_tables();
+
+	return true;
+}
+
+void boot_vc_handler(struct pt_regs *regs, unsigned long exit_code)
+{
+	struct es_em_ctxt ctxt;
+	enum es_result result;
+
+	if (!boot_ghcb && !sev_es_setup_ghcb())
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+	vc_ghcb_invalidate(boot_ghcb);
+	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	if (result != ES_OK)
+		goto finish;
+
+	switch (exit_code) {
+	default:
+		result = ES_UNSUPPORTED;
+		break;
+	}
+
+finish:
+	if (result == ES_OK) {
+		vc_finish_insn(&ctxt);
+	} else if (result != ES_RETRY) {
+		/*
+		 * For now, just halt the machine. That makes debugging easier,
+		 * later we just call sev_es_terminate() here.
+		 */
+		while (true)
+			asm volatile("hlt\n");
+	}
+}
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index f524b40aef07..512d3ccb9832 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -9,7 +9,14 @@
 #define __ASM_ENCRYPTED_STATE_H
 
 #include <linux/types.h>
+#include <asm/insn.h>
 
+#define GHCB_SEV_INFO		0x001UL
+#define GHCB_SEV_INFO_REQ	0x002UL
+#define		GHCB_INFO(v)		((v) & 0xfffUL)
+#define		GHCB_PROTO_MAX(v)	(((v) >> 48) & 0xffffUL)
+#define		GHCB_PROTO_MIN(v)	(((v) >> 32) & 0xffffUL)
+#define		GHCB_PROTO_OUR		0x0001UL
 #define GHCB_SEV_CPUID_REQ	0x004UL
 #define		GHCB_CPUID_REQ_EAX	0
 #define		GHCB_CPUID_REQ_EBX	1
@@ -21,10 +28,36 @@
 
 #define GHCB_SEV_CPUID_RESP	0x005UL
 #define GHCB_SEV_TERMINATE	0x100UL
+#define		GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
+#define		GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
 
 #define	GHCB_SEV_GHCB_RESP_CODE(v)	((v) & 0xfff)
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
+enum es_result {
+	ES_OK,			/* All good */
+	ES_UNSUPPORTED,		/* Requested operation not supported */
+	ES_VMM_ERROR,		/* Unexpected state from the VMM */
+	ES_DECODE_FAILED,	/* Instruction decoding failed */
+	ES_EXCEPTION,		/* Instruction caused exception */
+	ES_RETRY,		/* Retry instruction emulation */
+};
+
+struct es_fault_info {
+	unsigned long vector;
+	unsigned long error_code;
+	unsigned long cr2;
+};
+
+struct pt_regs;
+
+/* ES instruction emulation context */
+struct es_em_ctxt {
+	struct pt_regs *regs;
+	struct insn insn;
+	struct es_fault_info fi;
+};
+
 static inline u64 lower_bits(u64 val, unsigned int bits)
 {
 	u64 mask = (1ULL << bits) - 1;
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 2e8a30f06c74..c68d1618c9b0 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -29,6 +29,7 @@
 #define SVM_EXIT_WRITE_DR6     0x036
 #define SVM_EXIT_WRITE_DR7     0x037
 #define SVM_EXIT_EXCP_BASE     0x040
+#define SVM_EXIT_LAST_EXCP     0x05f
 #define SVM_EXIT_INTR          0x060
 #define SVM_EXIT_NMI           0x061
 #define SVM_EXIT_SMI           0x062
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index e963b48d3e86..f0947ea3c601 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -9,6 +9,106 @@
  * and is included directly into both code-bases.
  */
 
+static void sev_es_terminate(unsigned int reason)
+{
+	/* Request Guest Termination from Hypvervisor */
+	sev_es_wr_ghcb_msr(GHCB_SEV_TERMINATE);
+	VMGEXIT();
+
+	while (true)
+		asm volatile("hlt\n" : : : "memory");
+}
+
+static bool sev_es_negotiate_protocol(void)
+{
+	u64 val;
+
+	/* Do the GHCB protocol version negotiation */
+	sev_es_wr_ghcb_msr(GHCB_SEV_INFO_REQ);
+	VMGEXIT();
+	val = sev_es_rd_ghcb_msr();
+
+	if (GHCB_INFO(val) != GHCB_SEV_INFO)
+		return false;
+
+	if (GHCB_PROTO_MAX(val) < GHCB_PROTO_OUR ||
+	    GHCB_PROTO_MIN(val) > GHCB_PROTO_OUR)
+		return false;
+
+	return true;
+}
+
+static void vc_ghcb_invalidate(struct ghcb *ghcb)
+{
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
+}
+
+static bool vc_decoding_needed(unsigned long exit_code)
+{
+	/* Exceptions don't require to decode the instruction */
+	return !(exit_code >= SVM_EXIT_EXCP_BASE &&
+		 exit_code <= SVM_EXIT_LAST_EXCP);
+}
+
+static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
+				      struct pt_regs *regs,
+				      unsigned long exit_code)
+{
+	enum es_result ret = ES_OK;
+
+	memset(ctxt, 0, sizeof(*ctxt));
+	ctxt->regs = regs;
+
+	if (vc_decoding_needed(exit_code))
+		ret = vc_decode_insn(ctxt);
+
+	return ret;
+}
+
+static void vc_finish_insn(struct es_em_ctxt *ctxt)
+{
+	ctxt->regs->ip += ctxt->insn.length;
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	enum es_result ret;
+
+	ghcb_set_sw_exit_code(ghcb, exit_code);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
+		u64 info = ghcb->save.sw_exit_info_2;
+		unsigned long v;
+
+		info = ghcb->save.sw_exit_info_2;
+		v = info & SVM_EVTINJ_VEC_MASK;
+
+		/* Check if exception information from hypervisor is sane. */
+		if ((info & SVM_EVTINJ_VALID) &&
+		    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
+		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
+			ctxt->fi.vector = v;
+			if (info & SVM_EVTINJ_VALID_ERR)
+				ctxt->fi.error_code = info >> 32;
+			ret = ES_EXCEPTION;
+		} else {
+			ret = ES_VMM_ERROR;
+		}
+	} else {
+		ret = ES_OK;
+	}
+
+	return ret;
+}
+
 /*
  * Boot VC Handler - This is the first VC handler during boot, there is no GHCB
  * page yet, so it only supports the MSR based communication with the
@@ -63,3 +163,45 @@ void __init vc_no_ghcb_handler(struct pt_regs *regs, unsigned long exit_code)
 	while (true)
 		asm volatile("hlt\n");
 }
+
+static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
+					  void *src, char *buf,
+					  unsigned int data_size,
+					  unsigned int count,
+					  bool backwards)
+{
+	int i, b = backwards ? -1 : 1;
+	enum es_result ret = ES_OK;
+
+	for (i = 0; i < count; i++) {
+		void *s = src + (i * data_size * b);
+		char *d = buf + (i * data_size);
+
+		ret = vc_read_mem(ctxt, s, d, data_size);
+		if (ret != ES_OK)
+			break;
+	}
+
+	return ret;
+}
+
+static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
+					   void *dst, char *buf,
+					   unsigned int data_size,
+					   unsigned int count,
+					   bool backwards)
+{
+	int i, s = backwards ? -1 : 1;
+	enum es_result ret = ES_OK;
+
+	for (i = 0; i < count; i++) {
+		void *d = dst + (i * data_size * s);
+		char *b = buf + (i * data_size);
+
+		ret = vc_write_mem(ctxt, d, b, data_size);
+		if (ret != ES_OK)
+			break;
+	}
+
+	return ret;
+}
-- 
2.17.1

