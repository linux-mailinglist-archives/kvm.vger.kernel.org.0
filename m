Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94B739F2FE
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFHJ4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 05:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhFHJ4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 05:56:42 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CFCC061574;
        Tue,  8 Jun 2021 02:54:49 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 75B594B4;
        Tue,  8 Jun 2021 11:54:47 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
Subject: [PATCH v3 6/7] x86/insn: Extend error reporting from insn_fetch_from_user[_inatomic]()
Date:   Tue,  8 Jun 2021 11:54:38 +0200
Message-Id: <20210608095439.12668-7-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608095439.12668-1-joro@8bytes.org>
References: <20210608095439.12668-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The error reporting from the insn_fetch_from_user*() functions is not
very verbose. Extend it to include information on whether the linear
RIP could not be calculated or whether the memory access faulted.

This will be used in the SEV-ES code to propagate the correct
exception depending on what went wrong during instruction fetch.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c    |  8 ++++----
 arch/x86/kernel/umip.c   | 10 ++++------
 arch/x86/lib/insn-eval.c |  8 ++++++--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b563fb747aed..2b499affb2fb 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -267,17 +267,17 @@ static int vc_fetch_insn_kernel(struct es_em_ctxt *ctxt,
 static enum es_result __vc_decode_user_insn(struct es_em_ctxt *ctxt)
 {
 	char buffer[MAX_INSN_SIZE];
-	int res;
+	int insn_bytes;
 
-	res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
-	if (!res) {
+	insn_bytes = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
+	if (insn_bytes <= 0) {
 		ctxt->fi.vector     = X86_TRAP_PF;
 		ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
 		ctxt->fi.cr2        = ctxt->regs->ip;
 		return ES_EXCEPTION;
 	}
 
-	if (!insn_decode_from_regs(&ctxt->insn, ctxt->regs, buffer, res))
+	if (!insn_decode_from_regs(&ctxt->insn, ctxt->regs, buffer, insn_bytes))
 		return ES_DECODE_FAILED;
 
 	if (ctxt->insn.immediate.got)
diff --git a/arch/x86/kernel/umip.c b/arch/x86/kernel/umip.c
index 8daa70b0d2da..337178809c89 100644
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -346,14 +346,12 @@ bool fixup_umip_exception(struct pt_regs *regs)
 	if (!regs)
 		return false;
 
-	nr_copied = insn_fetch_from_user(regs, buf);
-
 	/*
-	 * The insn_fetch_from_user above could have failed if user code
-	 * is protected by a memory protection key. Give up on emulation
-	 * in such a case.  Should we issue a page fault?
+	 * Give up on emulation if fetching the instruction failed. Should we
+	 * issue a page fault or a #GP?
 	 */
-	if (!nr_copied)
+	nr_copied = insn_fetch_from_user(regs, buf);
+	if (nr_copied <= 0)
 		return false;
 
 	if (!insn_decode_from_regs(&insn, regs, buf, nr_copied))
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 4eecb9c7c6a0..1b5cdf8b7a4e 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1451,6 +1451,8 @@ static int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
  * Number of instruction bytes copied.
  *
  * 0 if nothing was copied.
+ *
+ * -EINVAL if the linear address of the instruction could not be calculated
  */
 int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
 {
@@ -1458,7 +1460,7 @@ int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
 	int not_copied;
 
 	if (insn_get_effective_ip(regs, &ip))
-		return 0;
+		return -EINVAL;
 
 	not_copied = copy_from_user(buf, (void __user *)ip, MAX_INSN_SIZE);
 
@@ -1479,6 +1481,8 @@ int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
  * Number of instruction bytes copied.
  *
  * 0 if nothing was copied.
+ *
+ * -EINVAL if the linear address of the instruction could not be calculated
  */
 int insn_fetch_from_user_inatomic(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
 {
@@ -1486,7 +1490,7 @@ int insn_fetch_from_user_inatomic(struct pt_regs *regs, unsigned char buf[MAX_IN
 	int not_copied;
 
 	if (insn_get_effective_ip(regs, &ip))
-		return 0;
+		return -EINVAL;
 
 	not_copied = __copy_from_user_inatomic(buf, (void __user *)ip, MAX_INSN_SIZE);
 
-- 
2.31.1

