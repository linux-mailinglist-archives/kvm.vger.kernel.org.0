Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05F51590D7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgBKNz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:55:26 -0500
Received: from 8bytes.org ([81.169.241.247]:52218 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgBKNx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:27 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B804CE88; Tue, 11 Feb 2020 14:53:14 +0100 (CET)
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
Subject: [PATCH 42/62] x86/sev-es: Handle DR7 read/write events
Date:   Tue, 11 Feb 2020 14:52:36 +0100
Message-Id: <20200211135256.24617-43-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
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
 arch/x86/kernel/sev-es.c | 69 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index b27d5b0a8ae1..fcd67ab04d2d 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -22,6 +22,8 @@
 #include <asm/traps.h>
 #include <asm/svm.h>
 
+#define DR7_RESET_VALUE        0x400
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -30,6 +32,9 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  * cleared
  */
 struct ghcb __initdata *boot_ghcb;
+static DEFINE_PER_CPU(unsigned long, cached_dr7) = DR7_RESET_VALUE;
+/* Needed before per-cpu access is set up */
+static unsigned long early_dr7 = DR7_RESET_VALUE;
 
 /* Runtime GHCBs */
 static DEFINE_PER_CPU_DECRYPTED(struct ghcb, ghcb_page) __aligned(PAGE_SIZE);
@@ -212,13 +217,69 @@ static void __init early_forward_exception(struct es_em_ctxt *ctxt)
 	early_exception(ctxt->regs, trapnr);
 }
 
+static enum es_result handle_dr7_write(struct ghcb *ghcb,
+				       struct es_em_ctxt *ctxt,
+				       bool early)
+{
+	u8 rm = X86_MODRM_RM(ctxt->insn.modrm.value);
+	unsigned long *reg;
+	enum es_result ret;
+
+	if (ctxt->insn.rex_prefix.nbytes &&
+	    X86_REX_B(ctxt->insn.rex_prefix.value))
+		rm |= 0x8;
+
+	reg = register_from_idx(ctxt->regs, rm);
+
+	/* Using a value of 0 for ExitInfo1 means RAX holds the value */
+	ghcb_set_rax(ghcb, *reg);
+	ret = ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (early)
+		early_dr7 = *reg;
+	else
+		this_cpu_write(cached_dr7, *reg);
+
+	return ES_OK;
+}
+
+static enum es_result handle_dr7_read(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt,
+				      bool early)
+{
+	u8 rm = X86_MODRM_RM(ctxt->insn.modrm.value);
+	unsigned long *reg;
+
+	if (ctxt->insn.rex_prefix.nbytes &&
+	    X86_REX_B(ctxt->insn.rex_prefix.value))
+		rm |= 0x8;
+
+	reg = register_from_idx(ctxt->regs, rm);
+
+	if (early)
+		*reg = early_dr7;
+	else
+		*reg = this_cpu_read(cached_dr7);
+
+	return ES_OK;
+}
+
 static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
-		struct ghcb *ghcb,
-		unsigned long exit_code)
+					  struct ghcb *ghcb,
+					  unsigned long exit_code,
+					  bool early)
 {
 	enum es_result result;
 
 	switch (exit_code) {
+	case SVM_EXIT_READ_DR7:
+		result = handle_dr7_read(ghcb, ctxt, early);
+		break;
+	case SVM_EXIT_WRITE_DR7:
+		result = handle_dr7_write(ghcb, ctxt, early);
+		break;
 	case SVM_EXIT_CPUID:
 		result = handle_cpuid(ghcb, ctxt);
 		break;
@@ -302,7 +363,7 @@ dotraplinkage void do_vmm_communication(struct pt_regs *regs, unsigned long exit
 		result = context_filter(regs, exit_code);
 
 	if (result == ES_OK)
-		result = handle_vc_exception(&ctxt, ghcb, exit_code);
+		result = handle_vc_exception(&ctxt, ghcb, exit_code, false);
 
 	/* Done - now check the result */
 	switch (result) {
@@ -368,7 +429,7 @@ int __init boot_vc_exception(struct pt_regs *regs)
 	result = init_em_ctxt(&ctxt, regs, exit_code);
 
 	if (result == ES_OK)
-		result = handle_vc_exception(&ctxt, boot_ghcb, exit_code);
+		result = handle_vc_exception(&ctxt, boot_ghcb, exit_code, true);
 
 	/* Done - now check the result */
 	switch (result) {
-- 
2.17.1

