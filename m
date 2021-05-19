Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7199F388F97
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353852AbhESNyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 09:54:43 -0400
Received: from 8bytes.org ([81.169.241.247]:40238 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353785AbhESNye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 09:54:34 -0400
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 016484E1;
        Wed, 19 May 2021 15:53:11 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
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
Subject: [PATCH v2 7/8] x86/insn: Extend error reporting from insn_fetch_from_user[_inatomic]()
Date:   Wed, 19 May 2021 15:52:50 +0200
Message-Id: <20210519135251.30093-8-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519135251.30093-1-joro@8bytes.org>
References: <20210519135251.30093-1-joro@8bytes.org>
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
 arch/x86/include/asm/insn-eval.h |  6 +++--
 arch/x86/kernel/sev.c            |  8 +++----
 arch/x86/kernel/umip.c           | 10 ++++-----
 arch/x86/lib/insn-eval.c         | 38 +++++++++++++++++++++++---------
 4 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 91d7182ad2d6..8362f1ce4b00 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -22,9 +22,11 @@ int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
 unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
 int insn_fetch_from_user(struct pt_regs *regs,
-			 unsigned char buf[MAX_INSN_SIZE]);
+			 unsigned char buf[MAX_INSN_SIZE],
+			 int *copied);
 int insn_fetch_from_user_inatomic(struct pt_regs *regs,
-				  unsigned char buf[MAX_INSN_SIZE]);
+				  unsigned char buf[MAX_INSN_SIZE],
+				  int *copied);
 bool insn_decode_from_regs(struct insn *insn, struct pt_regs *regs,
 			   unsigned char buf[MAX_INSN_SIZE], int buf_size);
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9a64030e74c0..1edb6cd5e308 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -258,17 +258,17 @@ static int vc_fetch_insn_kernel(struct es_em_ctxt *ctxt,
 static enum es_result __vc_decode_user_insn(struct es_em_ctxt *ctxt)
 {
 	char buffer[MAX_INSN_SIZE];
-	int res;
+	int insn_bytes = 0, res;
 
-	res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
-	if (!res) {
+	res = insn_fetch_from_user_inatomic(ctxt->regs, buffer, &insn_bytes);
+	if (res) {
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
index 8daa70b0d2da..b005ef42682e 100644
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -346,13 +346,13 @@ bool fixup_umip_exception(struct pt_regs *regs)
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
+	if (!insn_fetch_from_user(regs, buf, NULL))
+		return false;
+
 	if (!nr_copied)
 		return false;
 
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 4eecb9c7c6a0..d8a057ba0895 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1442,27 +1442,36 @@ static int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
  * insn_fetch_from_user() - Copy instruction bytes from user-space memory
  * @regs:	Structure with register values as seen when entering kernel mode
  * @buf:	Array to store the fetched instruction
+ * @copied:	Pointer to an int where the number of copied instruction bytes
+ *		is stored. Can be NULL.
  *
  * Gets the linear address of the instruction and copies the instruction bytes
  * to the buf.
  *
  * Returns:
  *
- * Number of instruction bytes copied.
+ * -EINVAL if the linear address of the instruction could not be calculated
+ * -EFAULT if nothing was copied
+ *       0 on success
  *
- * 0 if nothing was copied.
  */
-int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
+int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE],
+			 int *copied)
 {
 	unsigned long ip;
 	int not_copied;
+	int bytes;
 
 	if (insn_get_effective_ip(regs, &ip))
-		return 0;
+		return -EINVAL;
 
 	not_copied = copy_from_user(buf, (void __user *)ip, MAX_INSN_SIZE);
 
-	return MAX_INSN_SIZE - not_copied;
+	bytes = MAX_INSN_SIZE - not_copied;
+	if (copied)
+		*copied = bytes;
+
+	return bytes ? 0 : -EFAULT;
 }
 
 /**
@@ -1470,27 +1479,36 @@ int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
  *                                   while in atomic code
  * @regs:	Structure with register values as seen when entering kernel mode
  * @buf:	Array to store the fetched instruction
+ * @copied:	Pointer to an int where the number of copied instruction bytes
+ *		is stored. Can be NULL.
  *
  * Gets the linear address of the instruction and copies the instruction bytes
  * to the buf. This function must be used in atomic context.
  *
  * Returns:
  *
- * Number of instruction bytes copied.
+ * -EINVAL if the linear address of the instruction could not be calculated
+ * -EFAULT if nothing was copied
+ *       0 on success
  *
- * 0 if nothing was copied.
  */
-int insn_fetch_from_user_inatomic(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
+int insn_fetch_from_user_inatomic(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE],
+				  int *copied)
 {
 	unsigned long ip;
 	int not_copied;
+	int bytes;
 
 	if (insn_get_effective_ip(regs, &ip))
-		return 0;
+		return -EINVAL;
 
 	not_copied = __copy_from_user_inatomic(buf, (void __user *)ip, MAX_INSN_SIZE);
 
-	return MAX_INSN_SIZE - not_copied;
+	bytes = MAX_INSN_SIZE - not_copied;
+	if (copied)
+		*copied = bytes;
+
+	return bytes ? 0 : -EFAULT;
 }
 
 /**
-- 
2.31.1

