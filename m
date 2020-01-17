Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364F61411D9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 20:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgAQTek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 14:34:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:18185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbgAQTej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 14:34:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 11:30:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="274474207"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jan 2020 11:30:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 4/4] KVM: x86: Remove unused ctxt param from emulator's FPU accessors
Date:   Fri, 17 Jan 2020 11:30:52 -0800
Message-Id: <20200117193052.1339-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117193052.1339-1-sean.j.christopherson@intel.com>
References: <20200117193052.1339-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove an unused struct x86_emulate_ctxt * param from low level helpers
used to access guest FPU state.  The unused param was left behind by
commit 6ab0b9feb82a ("x86,kvm: remove KVM emulator get_fpu / put_fpu").

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/emulate.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2a5bed60ce50..3e3b3cd60cce 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1090,7 +1090,7 @@ static void emulator_put_fpu(void)
 	fpregs_unlock();
 }
 
-static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
+static void read_sse_reg(sse128_t *data, int reg)
 {
 	emulator_get_fpu();
 	switch (reg) {
@@ -1117,8 +1117,7 @@ static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
 	emulator_put_fpu();
 }
 
-static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
-			  int reg)
+static void write_sse_reg(sse128_t *data, int reg)
 {
 	emulator_get_fpu();
 	switch (reg) {
@@ -1145,7 +1144,7 @@ static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
 	emulator_put_fpu();
 }
 
-static void read_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
+static void read_mmx_reg(u64 *data, int reg)
 {
 	emulator_get_fpu();
 	switch (reg) {
@@ -1162,7 +1161,7 @@ static void read_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 	emulator_put_fpu();
 }
 
-static void write_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
+static void write_mmx_reg(u64 *data, int reg)
 {
 	emulator_get_fpu();
 	switch (reg) {
@@ -1234,7 +1233,7 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 		op->type = OP_XMM;
 		op->bytes = 16;
 		op->addr.xmm = reg;
-		read_sse_reg(ctxt, &op->vec_val, reg);
+		read_sse_reg(&op->vec_val, reg);
 		return;
 	}
 	if (ctxt->d & Mmx) {
@@ -1285,7 +1284,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			op->type = OP_XMM;
 			op->bytes = 16;
 			op->addr.xmm = ctxt->modrm_rm;
-			read_sse_reg(ctxt, &op->vec_val, ctxt->modrm_rm);
+			read_sse_reg(&op->vec_val, ctxt->modrm_rm);
 			return rc;
 		}
 		if (ctxt->d & Mmx) {
@@ -1862,10 +1861,10 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 				       op->bytes * op->count);
 		break;
 	case OP_XMM:
-		write_sse_reg(ctxt, &op->vec_val, op->addr.xmm);
+		write_sse_reg(&op->vec_val, op->addr.xmm);
 		break;
 	case OP_MM:
-		write_mmx_reg(ctxt, &op->mm_val, op->addr.mm);
+		write_mmx_reg(&op->mm_val, op->addr.mm);
 		break;
 	case OP_NONE:
 		/* no writeback */
@@ -5495,11 +5494,10 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-static void fetch_possible_mmx_operand(struct x86_emulate_ctxt *ctxt,
-				       struct operand *op)
+static void fetch_possible_mmx_operand(struct operand *op)
 {
 	if (op->type == OP_MM)
-		read_mmx_reg(ctxt, &op->mm_val, op->addr.mm);
+		read_mmx_reg(&op->mm_val, op->addr.mm);
 }
 
 static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
@@ -5578,10 +5576,10 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 			 * Now that we know the fpu is exception safe, we can fetch
 			 * operands from it.
 			 */
-			fetch_possible_mmx_operand(ctxt, &ctxt->src);
-			fetch_possible_mmx_operand(ctxt, &ctxt->src2);
+			fetch_possible_mmx_operand(&ctxt->src);
+			fetch_possible_mmx_operand(&ctxt->src2);
 			if (!(ctxt->d & Mov))
-				fetch_possible_mmx_operand(ctxt, &ctxt->dst);
+				fetch_possible_mmx_operand(&ctxt->dst);
 		}
 
 		if (unlikely(emul_flags & X86EMUL_GUEST_MASK) && ctxt->intercept) {
-- 
2.24.1

