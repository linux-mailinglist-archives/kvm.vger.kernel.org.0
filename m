Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3721403F6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 07:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgAQG0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 01:26:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:14600 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgAQG0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 01:26:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 22:26:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,329,1574150400"; 
   d="scan'208";a="424342475"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2020 22:26:30 -0800
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
Subject: [PATCH 2/4] KVM: x86: Ensure guest's FPU state is loaded when accessing for emulation
Date:   Thu, 16 Jan 2020 22:26:26 -0800
Message-Id: <20200117062628.6233-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117062628.6233-1-sean.j.christopherson@intel.com>
References: <20200117062628.6233-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lock the FPU regs and reload the current thread's FPU state, which holds
the guest's FPU state, to the CPU registers if necessary prior to
accessing guest FPU state as part of emulation.  kernel_fpu_begin() can
be called from softirq context, therefore KVM must ensure softirqs are
disabled (locking the FPU regs disables softirqs) when touching CPU FPU
state.

Note, for all intents and purposes this reverts commit 6ab0b9feb82a7
("x86,kvm: remove KVM emulator get_fpu / put_fpu"), but at the time it
was applied, removing get/put_fpu() was correct.  The re-introduction
of {get,put}_fpu() is necessitated by the deferring of FPU state load.

Fixes: 5f409e20b7945 ("x86/fpu: Defer FPU state load until return to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/emulate.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 952d1a4f4d7e..2a5bed60ce50 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -22,6 +22,7 @@
 #include "kvm_cache_regs.h"
 #include <asm/kvm_emulate.h>
 #include <linux/stringify.h>
+#include <asm/fpu/api.h>
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 
@@ -1075,8 +1076,23 @@ static void fetch_register_operand(struct operand *op)
 	}
 }
 
+static void emulator_get_fpu(void)
+{
+	fpregs_lock();
+
+	fpregs_assert_state_consistent();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+}
+
+static void emulator_put_fpu(void)
+{
+	fpregs_unlock();
+}
+
 static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movdqa %%xmm0, %0" : "=m"(*data)); break;
 	case 1: asm("movdqa %%xmm1, %0" : "=m"(*data)); break;
@@ -1098,11 +1114,13 @@ static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
 #endif
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
 			  int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movdqa %0, %%xmm0" : : "m"(*data)); break;
 	case 1: asm("movdqa %0, %%xmm1" : : "m"(*data)); break;
@@ -1124,10 +1142,12 @@ static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
 #endif
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static void read_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movq %%mm0, %0" : "=m"(*data)); break;
 	case 1: asm("movq %%mm1, %0" : "=m"(*data)); break;
@@ -1139,10 +1159,12 @@ static void read_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 	case 7: asm("movq %%mm7, %0" : "=m"(*data)); break;
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static void write_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 {
+	emulator_get_fpu();
 	switch (reg) {
 	case 0: asm("movq %0, %%mm0" : : "m"(*data)); break;
 	case 1: asm("movq %0, %%mm1" : : "m"(*data)); break;
@@ -1154,6 +1176,7 @@ static void write_mmx_reg(struct x86_emulate_ctxt *ctxt, u64 *data, int reg)
 	case 7: asm("movq %0, %%mm7" : : "m"(*data)); break;
 	default: BUG();
 	}
+	emulator_put_fpu();
 }
 
 static int em_fninit(struct x86_emulate_ctxt *ctxt)
@@ -1161,7 +1184,9 @@ static int em_fninit(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
+	emulator_get_fpu();
 	asm volatile("fninit");
+	emulator_put_fpu();
 	return X86EMUL_CONTINUE;
 }
 
@@ -1172,7 +1197,9 @@ static int em_fnstcw(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
+	emulator_get_fpu();
 	asm volatile("fnstcw %0": "+m"(fcw));
+	emulator_put_fpu();
 
 	ctxt->dst.val = fcw;
 
@@ -1186,7 +1213,9 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
+	emulator_get_fpu();
 	asm volatile("fnstsw %0": "+m"(fsw));
+	emulator_put_fpu();
 
 	ctxt->dst.val = fsw;
 
@@ -4092,8 +4121,12 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
+	emulator_get_fpu();
+
 	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_state));
 
+	emulator_put_fpu();
+
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
@@ -4136,6 +4169,8 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
+	emulator_get_fpu();
+
 	if (size < __fxstate_size(16)) {
 		rc = fxregs_fixup(&fx_state, size);
 		if (rc != X86EMUL_CONTINUE)
@@ -4151,6 +4186,8 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
 		rc = asm_safe("fxrstor %[fx]", : [fx] "m"(fx_state));
 
 out:
+	emulator_put_fpu();
+
 	return rc;
 }
 
@@ -5448,7 +5485,9 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 
+	emulator_get_fpu();
 	rc = asm_safe("fwait");
+	emulator_put_fpu();
 
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return emulate_exception(ctxt, MF_VECTOR, 0, false);
-- 
2.24.1

