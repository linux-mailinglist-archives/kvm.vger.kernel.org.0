Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258B935E88A
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 23:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348505AbhDMVwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 17:52:07 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:51607 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhDMVwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 17:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618350707; x=1649886707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oRPtxgat/4J5V+eoHtGmgLp6qFUokLuBHjOnK7AYLZU=;
  b=I6TiGw7Fze+Kg06H993o/3xAUwkap7KYwBZMPbmuZHKIIY4cJXGfKiDE
   f1UwC0HaNHIXzKIRtONgP0/KyDdHIysi4nUe9hlLobn7k6IjLoCtyeQsN
   c1OHWyvWbHaGYmjtwqg9SlPhaDk2+b9byP39A0i7kH7ttvG5PxK2bi2QA
   4=;
X-IronPort-AV: E=Sophos;i="5.82,220,1613433600"; 
   d="scan'208";a="127407672"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 13 Apr 2021 21:51:40 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id D2C02220BCB;
        Tue, 13 Apr 2021 21:51:38 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.39) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 21:51:29 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v3 1/4] KVM: x86: Move FPU register accessors into fpu.h
Date:   Tue, 13 Apr 2021 23:50:54 +0200
Message-ID: <5905cb9f8585ac6d863bae4e3c22d5d1b682f10d.1618349671.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618349671.git.sidcha@amazon.de>
References: <cover.1618349671.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.39]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-v XMM fast hypercalls use XMM registers to pass input/output
parameters. To access these, hyperv.c can reuse some FPU register
accessors defined in emulator.c. Move them to a common location so both
can access them.

While at it, reorder the parameters of these accessor methods to make
them more readable.

Cc: Alexander Graf <graf@amazon.com>
Cc: Evgeny Iakovlev <eyakovl@amazon.de>
Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/kvm/emulate.c     | 137 +++++-------------------------------
 arch/x86/kvm/fpu.h         | 140 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/kvm_emulate.h |   3 +-
 3 files changed, 158 insertions(+), 122 deletions(-)
 create mode 100644 arch/x86/kvm/fpu.h

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f7970ba6219f..3634c4c77fd4 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -22,7 +22,6 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 #include <linux/stringify.h>
-#include <asm/fpu/api.h>
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 
@@ -1081,116 +1080,14 @@ static void fetch_register_operand(struct operand *op)
 	}
 }
 
-static void emulator_get_fpu(void)
-{
-	fpregs_lock();
-
-	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_return();
-}
-
-static void emulator_put_fpu(void)
-{
-	fpregs_unlock();
-}
-
-static void read_sse_reg(sse128_t *data, int reg)
-{
-	emulator_get_fpu();
-	switch (reg) {
-	case 0: asm("movdqa %%xmm0, %0" : "=m"(*data)); break;
-	case 1: asm("movdqa %%xmm1, %0" : "=m"(*data)); break;
-	case 2: asm("movdqa %%xmm2, %0" : "=m"(*data)); break;
-	case 3: asm("movdqa %%xmm3, %0" : "=m"(*data)); break;
-	case 4: asm("movdqa %%xmm4, %0" : "=m"(*data)); break;
-	case 5: asm("movdqa %%xmm5, %0" : "=m"(*data)); break;
-	case 6: asm("movdqa %%xmm6, %0" : "=m"(*data)); break;
-	case 7: asm("movdqa %%xmm7, %0" : "=m"(*data)); break;
-#ifdef CONFIG_X86_64
-	case 8: asm("movdqa %%xmm8, %0" : "=m"(*data)); break;
-	case 9: asm("movdqa %%xmm9, %0" : "=m"(*data)); break;
-	case 10: asm("movdqa %%xmm10, %0" : "=m"(*data)); break;
-	case 11: asm("movdqa %%xmm11, %0" : "=m"(*data)); break;
-	case 12: asm("movdqa %%xmm12, %0" : "=m"(*data)); break;
-	case 13: asm("movdqa %%xmm13, %0" : "=m"(*data)); break;
-	case 14: asm("movdqa %%xmm14, %0" : "=m"(*data)); break;
-	case 15: asm("movdqa %%xmm15, %0" : "=m"(*data)); break;
-#endif
-	default: BUG();
-	}
-	emulator_put_fpu();
-}
-
-static void write_sse_reg(sse128_t *data, int reg)
-{
-	emulator_get_fpu();
-	switch (reg) {
-	case 0: asm("movdqa %0, %%xmm0" : : "m"(*data)); break;
-	case 1: asm("movdqa %0, %%xmm1" : : "m"(*data)); break;
-	case 2: asm("movdqa %0, %%xmm2" : : "m"(*data)); break;
-	case 3: asm("movdqa %0, %%xmm3" : : "m"(*data)); break;
-	case 4: asm("movdqa %0, %%xmm4" : : "m"(*data)); break;
-	case 5: asm("movdqa %0, %%xmm5" : : "m"(*data)); break;
-	case 6: asm("movdqa %0, %%xmm6" : : "m"(*data)); break;
-	case 7: asm("movdqa %0, %%xmm7" : : "m"(*data)); break;
-#ifdef CONFIG_X86_64
-	case 8: asm("movdqa %0, %%xmm8" : : "m"(*data)); break;
-	case 9: asm("movdqa %0, %%xmm9" : : "m"(*data)); break;
-	case 10: asm("movdqa %0, %%xmm10" : : "m"(*data)); break;
-	case 11: asm("movdqa %0, %%xmm11" : : "m"(*data)); break;
-	case 12: asm("movdqa %0, %%xmm12" : : "m"(*data)); break;
-	case 13: asm("movdqa %0, %%xmm13" : : "m"(*data)); break;
-	case 14: asm("movdqa %0, %%xmm14" : : "m"(*data)); break;
-	case 15: asm("movdqa %0, %%xmm15" : : "m"(*data)); break;
-#endif
-	default: BUG();
-	}
-	emulator_put_fpu();
-}
-
-static void read_mmx_reg(u64 *data, int reg)
-{
-	emulator_get_fpu();
-	switch (reg) {
-	case 0: asm("movq %%mm0, %0" : "=m"(*data)); break;
-	case 1: asm("movq %%mm1, %0" : "=m"(*data)); break;
-	case 2: asm("movq %%mm2, %0" : "=m"(*data)); break;
-	case 3: asm("movq %%mm3, %0" : "=m"(*data)); break;
-	case 4: asm("movq %%mm4, %0" : "=m"(*data)); break;
-	case 5: asm("movq %%mm5, %0" : "=m"(*data)); break;
-	case 6: asm("movq %%mm6, %0" : "=m"(*data)); break;
-	case 7: asm("movq %%mm7, %0" : "=m"(*data)); break;
-	default: BUG();
-	}
-	emulator_put_fpu();
-}
-
-static void write_mmx_reg(u64 *data, int reg)
-{
-	emulator_get_fpu();
-	switch (reg) {
-	case 0: asm("movq %0, %%mm0" : : "m"(*data)); break;
-	case 1: asm("movq %0, %%mm1" : : "m"(*data)); break;
-	case 2: asm("movq %0, %%mm2" : : "m"(*data)); break;
-	case 3: asm("movq %0, %%mm3" : : "m"(*data)); break;
-	case 4: asm("movq %0, %%mm4" : : "m"(*data)); break;
-	case 5: asm("movq %0, %%mm5" : : "m"(*data)); break;
-	case 6: asm("movq %0, %%mm6" : : "m"(*data)); break;
-	case 7: asm("movq %0, %%mm7" : : "m"(*data)); break;
-	default: BUG();
-	}
-	emulator_put_fpu();
-}
-
 static int em_fninit(struct x86_emulate_ctxt *ctxt)
 {
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
-	emulator_get_fpu();
+	kvm_fpu_get();
 	asm volatile("fninit");
-	emulator_put_fpu();
+	kvm_fpu_put();
 	return X86EMUL_CONTINUE;
 }
 
@@ -1201,9 +1098,9 @@ static int em_fnstcw(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
-	emulator_get_fpu();
+	kvm_fpu_get();
 	asm volatile("fnstcw %0": "+m"(fcw));
-	emulator_put_fpu();
+	kvm_fpu_put();
 
 	ctxt->dst.val = fcw;
 
@@ -1217,9 +1114,9 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
 		return emulate_nm(ctxt);
 
-	emulator_get_fpu();
+	kvm_fpu_get();
 	asm volatile("fnstsw %0": "+m"(fsw));
-	emulator_put_fpu();
+	kvm_fpu_put();
 
 	ctxt->dst.val = fsw;
 
@@ -1238,7 +1135,7 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 		op->type = OP_XMM;
 		op->bytes = 16;
 		op->addr.xmm = reg;
-		read_sse_reg(&op->vec_val, reg);
+		kvm_read_sse_reg(reg, &op->vec_val);
 		return;
 	}
 	if (ctxt->d & Mmx) {
@@ -1289,7 +1186,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			op->type = OP_XMM;
 			op->bytes = 16;
 			op->addr.xmm = ctxt->modrm_rm;
-			read_sse_reg(&op->vec_val, ctxt->modrm_rm);
+			kvm_read_sse_reg(ctxt->modrm_rm, &op->vec_val);
 			return rc;
 		}
 		if (ctxt->d & Mmx) {
@@ -1866,10 +1763,10 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 				       op->bytes * op->count);
 		break;
 	case OP_XMM:
-		write_sse_reg(&op->vec_val, op->addr.xmm);
+		kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
 		break;
 	case OP_MM:
-		write_mmx_reg(&op->mm_val, op->addr.mm);
+		kvm_write_mmx_reg(op->addr.mm, &op->mm_val);
 		break;
 	case OP_NONE:
 		/* no writeback */
@@ -4124,11 +4021,11 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	emulator_get_fpu();
+	kvm_fpu_get();
 
 	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_state));
 
-	emulator_put_fpu();
+	kvm_fpu_put();
 
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
@@ -4172,7 +4069,7 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	emulator_get_fpu();
+	kvm_fpu_get();
 
 	if (size < __fxstate_size(16)) {
 		rc = fxregs_fixup(&fx_state, size);
@@ -4189,7 +4086,7 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
 		rc = asm_safe("fxrstor %[fx]", : [fx] "m"(fx_state));
 
 out:
-	emulator_put_fpu();
+	kvm_fpu_put();
 
 	return rc;
 }
@@ -5510,9 +5407,9 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 
-	emulator_get_fpu();
+	kvm_fpu_get();
 	rc = asm_safe("fwait");
-	emulator_put_fpu();
+	kvm_fpu_put();
 
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return emulate_exception(ctxt, MF_VECTOR, 0, false);
@@ -5523,7 +5420,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 static void fetch_possible_mmx_operand(struct operand *op)
 {
 	if (op->type == OP_MM)
-		read_mmx_reg(&op->mm_val, op->addr.mm);
+		kvm_read_mmx_reg(op->addr.mm, &op->mm_val);
 }
 
 static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
new file mode 100644
index 000000000000..3ba12888bf66
--- /dev/null
+++ b/arch/x86/kvm/fpu.h
@@ -0,0 +1,140 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __KVM_FPU_H_
+#define __KVM_FPU_H_
+
+#include <asm/fpu/api.h>
+
+typedef u32		__attribute__((vector_size(16))) sse128_t;
+#define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
+#define sse128_lo(x)	({ __sse128_u t; t.vec = x; t.as_u64[0]; })
+#define sse128_hi(x)	({ __sse128_u t; t.vec = x; t.as_u64[1]; })
+#define sse128_l0(x)	({ __sse128_u t; t.vec = x; t.as_u32[0]; })
+#define sse128_l1(x)	({ __sse128_u t; t.vec = x; t.as_u32[1]; })
+#define sse128_l2(x)	({ __sse128_u t; t.vec = x; t.as_u32[2]; })
+#define sse128_l3(x)	({ __sse128_u t; t.vec = x; t.as_u32[3]; })
+#define sse128(lo, hi)	({ __sse128_u t; t.as_u64[0] = lo; t.as_u64[1] = hi; t.vec; })
+
+static inline void _kvm_read_sse_reg(int reg, sse128_t *data)
+{
+	switch (reg) {
+	case 0: asm("movdqa %%xmm0, %0" : "=m"(*data)); break;
+	case 1: asm("movdqa %%xmm1, %0" : "=m"(*data)); break;
+	case 2: asm("movdqa %%xmm2, %0" : "=m"(*data)); break;
+	case 3: asm("movdqa %%xmm3, %0" : "=m"(*data)); break;
+	case 4: asm("movdqa %%xmm4, %0" : "=m"(*data)); break;
+	case 5: asm("movdqa %%xmm5, %0" : "=m"(*data)); break;
+	case 6: asm("movdqa %%xmm6, %0" : "=m"(*data)); break;
+	case 7: asm("movdqa %%xmm7, %0" : "=m"(*data)); break;
+#ifdef CONFIG_X86_64
+	case 8: asm("movdqa %%xmm8, %0" : "=m"(*data)); break;
+	case 9: asm("movdqa %%xmm9, %0" : "=m"(*data)); break;
+	case 10: asm("movdqa %%xmm10, %0" : "=m"(*data)); break;
+	case 11: asm("movdqa %%xmm11, %0" : "=m"(*data)); break;
+	case 12: asm("movdqa %%xmm12, %0" : "=m"(*data)); break;
+	case 13: asm("movdqa %%xmm13, %0" : "=m"(*data)); break;
+	case 14: asm("movdqa %%xmm14, %0" : "=m"(*data)); break;
+	case 15: asm("movdqa %%xmm15, %0" : "=m"(*data)); break;
+#endif
+	default: BUG();
+	}
+}
+
+static inline void _kvm_write_sse_reg(int reg, const sse128_t *data)
+{
+	switch (reg) {
+	case 0: asm("movdqa %0, %%xmm0" : : "m"(*data)); break;
+	case 1: asm("movdqa %0, %%xmm1" : : "m"(*data)); break;
+	case 2: asm("movdqa %0, %%xmm2" : : "m"(*data)); break;
+	case 3: asm("movdqa %0, %%xmm3" : : "m"(*data)); break;
+	case 4: asm("movdqa %0, %%xmm4" : : "m"(*data)); break;
+	case 5: asm("movdqa %0, %%xmm5" : : "m"(*data)); break;
+	case 6: asm("movdqa %0, %%xmm6" : : "m"(*data)); break;
+	case 7: asm("movdqa %0, %%xmm7" : : "m"(*data)); break;
+#ifdef CONFIG_X86_64
+	case 8: asm("movdqa %0, %%xmm8" : : "m"(*data)); break;
+	case 9: asm("movdqa %0, %%xmm9" : : "m"(*data)); break;
+	case 10: asm("movdqa %0, %%xmm10" : : "m"(*data)); break;
+	case 11: asm("movdqa %0, %%xmm11" : : "m"(*data)); break;
+	case 12: asm("movdqa %0, %%xmm12" : : "m"(*data)); break;
+	case 13: asm("movdqa %0, %%xmm13" : : "m"(*data)); break;
+	case 14: asm("movdqa %0, %%xmm14" : : "m"(*data)); break;
+	case 15: asm("movdqa %0, %%xmm15" : : "m"(*data)); break;
+#endif
+	default: BUG();
+	}
+}
+
+static inline void _kvm_read_mmx_reg(int reg, u64 *data)
+{
+	switch (reg) {
+	case 0: asm("movq %%mm0, %0" : "=m"(*data)); break;
+	case 1: asm("movq %%mm1, %0" : "=m"(*data)); break;
+	case 2: asm("movq %%mm2, %0" : "=m"(*data)); break;
+	case 3: asm("movq %%mm3, %0" : "=m"(*data)); break;
+	case 4: asm("movq %%mm4, %0" : "=m"(*data)); break;
+	case 5: asm("movq %%mm5, %0" : "=m"(*data)); break;
+	case 6: asm("movq %%mm6, %0" : "=m"(*data)); break;
+	case 7: asm("movq %%mm7, %0" : "=m"(*data)); break;
+	default: BUG();
+	}
+}
+
+static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
+{
+	switch (reg) {
+	case 0: asm("movq %0, %%mm0" : : "m"(*data)); break;
+	case 1: asm("movq %0, %%mm1" : : "m"(*data)); break;
+	case 2: asm("movq %0, %%mm2" : : "m"(*data)); break;
+	case 3: asm("movq %0, %%mm3" : : "m"(*data)); break;
+	case 4: asm("movq %0, %%mm4" : : "m"(*data)); break;
+	case 5: asm("movq %0, %%mm5" : : "m"(*data)); break;
+	case 6: asm("movq %0, %%mm6" : : "m"(*data)); break;
+	case 7: asm("movq %0, %%mm7" : : "m"(*data)); break;
+	default: BUG();
+	}
+}
+
+static inline void kvm_fpu_get(void)
+{
+	fpregs_lock();
+
+	fpregs_assert_state_consistent();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+}
+
+static inline void kvm_fpu_put(void)
+{
+	fpregs_unlock();
+}
+
+static inline void kvm_read_sse_reg(int reg, sse128_t *data)
+{
+	kvm_fpu_get();
+	_kvm_read_sse_reg(reg, data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_write_sse_reg(int reg, const sse128_t *data)
+{
+	kvm_fpu_get();
+	_kvm_write_sse_reg(reg, data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_read_mmx_reg(int reg, u64 *data)
+{
+	kvm_fpu_get();
+	_kvm_read_mmx_reg(reg, data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_write_mmx_reg(int reg, const u64 *data)
+{
+	kvm_fpu_get();
+	_kvm_write_mmx_reg(reg, data);
+	kvm_fpu_put();
+}
+
+#endif
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 0d359115429a..f098b6e8e49c 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -13,6 +13,7 @@
 #define _ASM_X86_KVM_X86_EMULATE_H
 
 #include <asm/desc_defs.h>
+#include "fpu.h"
 
 struct x86_emulate_ctxt;
 enum x86_intercept;
@@ -236,8 +237,6 @@ struct x86_emulate_ops {
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
 
-typedef u32 __attribute__((vector_size(16))) sse128_t;
-
 /* Type, address-of, and value of an instruction's operand. */
 struct operand {
 	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_MM, OP_NONE } type;
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



