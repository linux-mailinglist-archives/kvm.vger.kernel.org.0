Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F46418AF75
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgCSJQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:16:47 -0400
Received: from 8bytes.org ([81.169.241.247]:51930 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgCSJOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:43 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id BE09EE7D; Thu, 19 Mar 2020 10:14:25 +0100 (CET)
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
Subject: [PATCH 50/70] x86/sev-es: Handle DR7 read/write events
Date:   Thu, 19 Mar 2020 10:13:47 +0100
Message-Id: <20200319091407.1481-51-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add code to handle #VC exceptions on DR7 register reads and writes.
This is needed early because show_regs() reads DR7 to print it out.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: - Adapt to #VC handling framework
                   - Support early usage ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 87 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 163b8a7f98a4..7a9cdc660637 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -23,6 +23,8 @@
 #include <asm/traps.h>
 #include <asm/svm.h>
 
+#define DR7_RESET_VALUE        0x400
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -31,6 +33,7 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  * cleared
  */
 struct ghcb __initdata *boot_ghcb;
+static DEFINE_PER_CPU(unsigned long, cached_dr7) = DR7_RESET_VALUE;
 
 struct ghcb_state {
 	struct ghcb *ghcb;
@@ -359,6 +362,21 @@ static long *vc_insn_get_reg(struct es_em_ctxt *ctxt)
 	return reg_array + offset;
 }
 
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
 static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
 				 unsigned int bytes, bool read)
 {
@@ -587,13 +605,74 @@ static enum es_result vc_handle_mmio(struct ghcb *ghcb,
 	return ret;
 }
 
+static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  bool early)
+{
+	long val, *reg = vc_insn_get_rm(ctxt);
+	enum es_result ret;
+
+	if (!reg)
+		return ES_DECODE_FAILED;
+
+	val = *reg;
+
+	/* Upper 32 bits must be written as zeroes */
+	if (val >> 32) {
+		ctxt->fi.vector = X86_TRAP_GP;
+		ctxt->fi.error_code = 0;
+		return ES_EXCEPTION;
+	}
+
+	/* Clear out other reservered bits and set bit 10 */
+	val = (val & 0xffff23ffL) | BIT(10);
+
+	/* Early non-zero writes to DR7 are not supported */
+	if (early && (val & ~DR7_RESET_VALUE))
+		return ES_UNSUPPORTED;
+
+	/* Using a value of 0 for ExitInfo1 means RAX holds the value */
+	ghcb_set_rax(ghcb, val);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	this_cpu_write(cached_dr7, *reg);
+
+	return ES_OK;
+}
+
+static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
+					 struct es_em_ctxt *ctxt,
+					 bool early)
+{
+	long *reg = vc_insn_get_rm(ctxt);
+
+	if (!reg)
+		return ES_DECODE_FAILED;
+
+	if (early)
+		*reg = DR7_RESET_VALUE;
+	else
+		*reg = this_cpu_read(cached_dr7);
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
-		struct ghcb *ghcb,
-		unsigned long exit_code)
+					 struct ghcb *ghcb,
+					 unsigned long exit_code,
+					 bool early)
 {
 	enum es_result result;
 
 	switch (exit_code) {
+	case SVM_EXIT_READ_DR7:
+		result = vc_handle_dr7_read(ghcb, ctxt, early);
+		break;
+	case SVM_EXIT_WRITE_DR7:
+		result = vc_handle_dr7_write(ghcb, ctxt, early);
+		break;
 	case SVM_EXIT_CPUID:
 		result = vc_handle_cpuid(ghcb, ctxt);
 		break;
@@ -682,7 +761,7 @@ dotraplinkage void do_vmm_communication(struct pt_regs *regs, unsigned long exit
 		result = vc_context_filter(regs, exit_code);
 
 	if (result == ES_OK)
-		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
+		result = vc_handle_exitcode(&ctxt, ghcb, exit_code, false);
 
 	sev_es_put_ghcb(&state);
 
@@ -750,7 +829,7 @@ bool __init boot_vc_exception(struct pt_regs *regs)
 	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
 
 	if (result == ES_OK)
-		result = vc_handle_exitcode(&ctxt, boot_ghcb, exit_code);
+		result = vc_handle_exitcode(&ctxt, boot_ghcb, exit_code, true);
 
 	/* Done - now check the result */
 	switch (result) {
-- 
2.17.1

