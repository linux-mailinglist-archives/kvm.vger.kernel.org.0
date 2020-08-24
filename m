Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBEF24F796
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgHXJR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgHXIz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:58 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1454C061574;
        Mon, 24 Aug 2020 01:55:57 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id DB0F660E;
        Mon, 24 Aug 2020 10:55:50 +0200 (CEST)
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
Subject: [PATCH v6 09/76] x86/umip: Factor out instruction decoding
Date:   Mon, 24 Aug 2020 10:54:04 +0200
Message-Id: <20200824085511.7553-10-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Factor out the code used to decode an instruction with the correct
address and operand sizes to a helper function.

No functional changes.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200724160336.5435-9-joro@8bytes.org
---
 arch/x86/include/asm/insn-eval.h |  2 ++
 arch/x86/kernel/umip.c           | 23 +---------------
 arch/x86/lib/insn-eval.c         | 45 ++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index b8b9ef1bbd06..392b4fe377f9 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -21,5 +21,7 @@ unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
 int insn_fetch_from_user(struct pt_regs *regs,
 			 unsigned char buf[MAX_INSN_SIZE]);
+bool insn_decode(struct insn *insn, struct pt_regs *regs,
+		 unsigned char buf[MAX_INSN_SIZE], int buf_size);
 
 #endif /* _ASM_X86_INSN_EVAL_H */
diff --git a/arch/x86/kernel/umip.c b/arch/x86/kernel/umip.c
index ad135be4f1f0..f6225bf22c02 100644
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -342,7 +342,6 @@ bool fixup_umip_exception(struct pt_regs *regs)
 	unsigned long *reg_addr;
 	void __user *uaddr;
 	struct insn insn;
-	int seg_defs;
 
 	if (!regs)
 		return false;
@@ -357,27 +356,7 @@ bool fixup_umip_exception(struct pt_regs *regs)
 	if (!nr_copied)
 		return false;
 
-	insn_init(&insn, buf, nr_copied, user_64bit_mode(regs));
-
-	/*
-	 * Override the default operand and address sizes with what is specified
-	 * in the code segment descriptor. The instruction decoder only sets
-	 * the address size it to either 4 or 8 address bytes and does nothing
-	 * for the operand bytes. This OK for most of the cases, but we could
-	 * have special cases where, for instance, a 16-bit code segment
-	 * descriptor is used.
-	 * If there is an address override prefix, the instruction decoder
-	 * correctly updates these values, even for 16-bit defaults.
-	 */
-	seg_defs = insn_get_code_seg_params(regs);
-	if (seg_defs == -EINVAL)
-		return false;
-
-	insn.addr_bytes = INSN_CODE_SEG_ADDR_SZ(seg_defs);
-	insn.opnd_bytes = INSN_CODE_SEG_OPND_SZ(seg_defs);
-
-	insn_get_length(&insn);
-	if (nr_copied < insn.length)
+	if (!insn_decode(&insn, regs, buf, nr_copied))
 		return false;
 
 	umip_inst = identify_insn(&insn);
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 0c4f7ebc261b..f52046f90dd3 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1407,3 +1407,48 @@ int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
 
 	return MAX_INSN_SIZE - not_copied;
 }
+
+/**
+ * insn_decode() - Decode an instruction
+ * @insn:	Structure to store decoded instruction
+ * @regs:	Structure with register values as seen when entering kernel mode
+ * @buf:	Buffer containing the instruction bytes
+ * @buf_size:   Number of instruction bytes available in buf
+ *
+ * Decodes the instruction provided in buf and stores the decoding results in
+ * insn. Also determines the correct address and operand sizes.
+ *
+ * Returns:
+ *
+ * True if instruction was decoded, False otherwise.
+ */
+bool insn_decode(struct insn *insn, struct pt_regs *regs,
+		 unsigned char buf[MAX_INSN_SIZE], int buf_size)
+{
+	int seg_defs;
+
+	insn_init(insn, buf, buf_size, user_64bit_mode(regs));
+
+	/*
+	 * Override the default operand and address sizes with what is specified
+	 * in the code segment descriptor. The instruction decoder only sets
+	 * the address size it to either 4 or 8 address bytes and does nothing
+	 * for the operand bytes. This OK for most of the cases, but we could
+	 * have special cases where, for instance, a 16-bit code segment
+	 * descriptor is used.
+	 * If there is an address override prefix, the instruction decoder
+	 * correctly updates these values, even for 16-bit defaults.
+	 */
+	seg_defs = insn_get_code_seg_params(regs);
+	if (seg_defs == -EINVAL)
+		return false;
+
+	insn->addr_bytes = INSN_CODE_SEG_ADDR_SZ(seg_defs);
+	insn->opnd_bytes = INSN_CODE_SEG_OPND_SZ(seg_defs);
+
+	insn_get_length(insn);
+	if (buf_size < insn->length)
+		return false;
+
+	return true;
+}
-- 
2.28.0

