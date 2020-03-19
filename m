Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A60318AF0B
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCSJOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:14:23 -0400
Received: from 8bytes.org ([81.169.241.247]:51922 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgCSJOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:22 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E409320A; Thu, 19 Mar 2020 10:14:16 +0100 (CET)
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
Subject: [PATCH 06/70] x86/umip: Factor out instruction fetch
Date:   Thu, 19 Mar 2020 10:13:03 +0100
Message-Id: <20200319091407.1481-7-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Factor out the code to fetch the instruction from user-space to a helper
function.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/insn-eval.h |  2 ++
 arch/x86/kernel/umip.c           | 26 +++++-----------------
 arch/x86/lib/insn-eval.c         | 38 ++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 2b6ccf2c49f1..b8b9ef1bbd06 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -19,5 +19,7 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs);
 int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
 unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
+int insn_fetch_from_user(struct pt_regs *regs,
+			 unsigned char buf[MAX_INSN_SIZE]);
 
 #endif /* _ASM_X86_INSN_EVAL_H */
diff --git a/arch/x86/kernel/umip.c b/arch/x86/kernel/umip.c
index 4d732a444711..00cb157673b1 100644
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -317,11 +317,11 @@ static void force_sig_info_umip_fault(void __user *addr, struct pt_regs *regs)
  */
 bool fixup_umip_exception(struct pt_regs *regs)
 {
-	int not_copied, nr_copied, reg_offset, dummy_data_size, umip_inst;
-	unsigned long seg_base = 0, *reg_addr;
+	int nr_copied, reg_offset, dummy_data_size, umip_inst;
 	/* 10 bytes is the maximum size of the result of UMIP instructions */
 	unsigned char dummy_data[10] = { 0 };
 	unsigned char buf[MAX_INSN_SIZE];
+	unsigned long *reg_addr;
 	void __user *uaddr;
 	struct insn insn;
 	int seg_defs;
@@ -329,26 +329,12 @@ bool fixup_umip_exception(struct pt_regs *regs)
 	if (!regs)
 		return false;
 
-	/*
-	 * If not in user-space long mode, a custom code segment could be in
-	 * use. This is true in protected mode (if the process defined a local
-	 * descriptor table), or virtual-8086 mode. In most of the cases
-	 * seg_base will be zero as in USER_CS.
-	 */
-	if (!user_64bit_mode(regs))
-		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
-
-	if (seg_base == -1L)
-		return false;
-
-	not_copied = copy_from_user(buf, (void __user *)(seg_base + regs->ip),
-				    sizeof(buf));
-	nr_copied = sizeof(buf) - not_copied;
+	nr_copied = insn_fetch_from_user(regs, buf);
 
 	/*
-	 * The copy_from_user above could have failed if user code is protected
-	 * by a memory protection key. Give up on emulation in such a case.
-	 * Should we issue a page fault?
+	 * The insn_fetch_from_user above could have failed if user code
+	 * is protected by a memory protection key. Give up on emulation
+	 * in such a case.  Should we issue a page fault?
 	 */
 	if (!nr_copied)
 		return false;
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 31600d851fd8..95ae3953e2a2 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1369,3 +1369,41 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
 		return (void __user *)-1L;
 	}
 }
+
+/**
+ * insn_fetch_from_user() - Copy instruction bytes from user-space memory
+ * @regs:	Structure with register values as seen when entering kernel mode
+ * @buf:	Array to store the fetched instruction
+ *
+ * Gets the linear address of the instruction and copies the instruction bytes
+ * to the buf.
+ *
+ * Returns:
+ *
+ * Number of instruction bytes copied.
+ *
+ * 0 if nothing was copied.
+ */
+int insn_fetch_from_user(struct pt_regs *regs,
+			 unsigned char buf[MAX_INSN_SIZE])
+{
+	unsigned long seg_base = 0;
+	int not_copied;
+
+	/*
+	 * If not in user-space long mode, a custom code segment could be in
+	 * use. This is true in protected mode (if the process defined a local
+	 * descriptor table), or virtual-8086 mode. In most of the cases
+	 * seg_base will be zero as in USER_CS.
+	 */
+	if (!user_64bit_mode(regs))
+		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
+
+	if (seg_base == -1L)
+		return 0;
+
+	not_copied = copy_from_user(buf, (void __user *)(seg_base + regs->ip),
+				    MAX_INSN_SIZE);
+
+	return MAX_INSN_SIZE - not_copied;
+}
-- 
2.17.1

