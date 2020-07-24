Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5BB22CA91
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgGXQLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:11:10 -0400
Received: from 8bytes.org ([81.169.241.247]:59368 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgGXQED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:03 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id D83909CE;
        Fri, 24 Jul 2020 18:03:59 +0200 (CEST)
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v5 07/75] x86/umip: Factor out instruction fetch
Date:   Fri, 24 Jul 2020 18:02:28 +0200
Message-Id: <20200724160336.5435-8-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
References: <20200724160336.5435-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Factor out the code to fetch the instruction from user-space to a helper
function.

No functional changes.

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
index 8d5cbe1bbb3b..c9e5345da793 100644
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
index 31600d851fd8..0c4f7ebc261b 100644
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
+int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
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
+	if (!user_64bit_mode(regs)) {
+		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
+		if (seg_base == -1L)
+			return 0;
+	}
+
+
+	not_copied = copy_from_user(buf, (void __user *)(seg_base + regs->ip),
+				    MAX_INSN_SIZE);
+
+	return MAX_INSN_SIZE - not_copied;
+}
-- 
2.27.0

