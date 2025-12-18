Return-Path: <kvm+bounces-66263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C5AC8CCC2D6
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0D23302F1A2
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70F8341ADF;
	Thu, 18 Dec 2025 14:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="YEh/pSrQ"
X-Original-To: kvm@vger.kernel.org
Received: from out28-101.mail.aliyun.com (out28-101.mail.aliyun.com [115.124.28.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66CB33FE0D;
	Thu, 18 Dec 2025 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066472; cv=none; b=l+NxvlW03AP3s+SMzXcBmQmFD6bTGEYan9lqmTEYHpoo4BAw1zyA80orsuz8814JW7DGVIDFksgoETmJjRxK0zLyR/xXncoP+NKCLdxKMy26uMd+62YndZxqhSZqJet6x0FLhk8oFC1bwy0b6NMCPfK38CZnkpQeUvYS8XuSWqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066472; c=relaxed/simple;
	bh=5H466jYKBehQSHk8UFMMLu3sGrBGVN8/1Tdo52+uXcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tTu9NGwc2s+Q1T5zJPyequYemCtgiDV1rnkL4HN5jpBTGYEwe6h0wmwYEJAhIEROip2tMyZf7ziYCgtRkMaqpuEFdOaOUFGqyyTCNuj2Ys7fr+Wt1AsDY7CHeJtqLgtnOa+U63O48MINduX+3lKNtK4/EBf7CMR3If9c/hMwnhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=YEh/pSrQ; arc=none smtp.client-ip=115.124.28.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066460; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=8ULNaMl/OndzL8Zsh+tHLHn+czcHBn/v2lq32gCqBVE=;
	b=YEh/pSrQ51FhcDhFpyLqHiXQzqrY2i+CbMACmhUvGIq8TS746kM9nOBuTPjtBp2t8irDEvr3zO7UrLgfGVzaTmTsf0SFwjburLZe50XRRD3y1knJM/iKKRh1EVBBWLGgzCw88P3K0yCduORG8Z3DMf7AlCjHPy+0+4TZupPOg2w=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fnkSTCH_1766066459 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:01:00 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] KVM: x86: Check guest debug in DR access instruction emulation
Date: Thu, 18 Dec 2025 22:00:38 +0800
Message-Id: <0faa9263a82b12fe1024cbaa1452d01b4d703f11.1766066076.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
References: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a DR access instruction is emulated by the x86 instruction
emulator, only the guest DR7.GD is checked. Since the instruction
emulation path has already performed some guest debug checks, add a
guest debug check in the DR access instruction emulation to improve the
guest debug logic in the instruction emulator.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c     |  2 +-
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/x86.c         | 52 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.h         |  7 +++++
 4 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 997cd6e46d90..f2e2ee412b78 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3835,7 +3835,7 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 	if ((cr4 & X86_CR4_DE) && (dr == 4 || dr == 5))
 		return emulate_ud(ctxt);
 
-	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD)
+	if (ctxt->ops->get_eff_dr(ctxt, 7) & DR7_GD)
 		return emulate_db(ctxt, DR6_BD);
 
 	return X86EMUL_CONTINUE;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 7fe38b174e18..006a439a60b3 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -216,6 +216,7 @@ struct x86_emulate_ops {
 	int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
 	int (*cpl)(struct x86_emulate_ctxt *ctxt);
 	ulong (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr);
+	ulong (*get_eff_dr)(struct x86_emulate_ctxt *ctxt, int dr);
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
 	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f33ce947633e..824eb489de43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1592,6 +1592,22 @@ unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_dr);
 
+static unsigned long kvm_get_eff_dr(struct kvm_vcpu *vcpu, int dr)
+{
+	size_t size = ARRAY_SIZE(vcpu->arch.eff_db);
+
+	switch (dr) {
+	case 0 ... 3:
+		return vcpu->arch.eff_db[array_index_nospec(dr, size)];
+	case 4:
+	case 6:
+		return vcpu->arch.dr6;
+	case 5:
+	default: /* 7 */
+		return kvm_get_eff_dr7(vcpu);
+	}
+}
+
 int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 {
 	u32 pmc = kvm_rcx_read(vcpu);
@@ -8504,6 +8520,11 @@ static unsigned long emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr)
 	return kvm_get_dr(emul_to_vcpu(ctxt), dr);
 }
 
+static unsigned long emulator_get_eff_dr(struct x86_emulate_ctxt *ctxt, int dr)
+{
+	return kvm_get_eff_dr(emul_to_vcpu(ctxt), dr);
+}
+
 static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 			   unsigned long value)
 {
@@ -8877,6 +8898,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_cr              = emulator_set_cr,
 	.cpl                 = emulator_get_cpl,
 	.get_dr              = emulator_get_dr,
+	.get_eff_dr          = emulator_get_eff_dr,
 	.set_dr              = emulator_set_dr,
 	.set_msr_with_filter = emulator_set_msr_with_filter,
 	.get_msr_with_filter = emulator_get_msr_with_filter,
@@ -8921,18 +8943,36 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	}
 }
 
-static void inject_emulated_exception(struct kvm_vcpu *vcpu)
+static int kvm_inject_emulated_db(struct kvm_vcpu *vcpu, unsigned long dr6)
+{
+	struct kvm_run *kvm_run = vcpu->run;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+		kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
+		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
+		kvm_run->debug.arch.exception = DB_VECTOR;
+		kvm_run->exit_reason = KVM_EXIT_DEBUG;
+		return 0;
+	}
+
+	kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
+	return 1;
+}
+
+static int inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_exception *ex = &vcpu->arch.emulate_ctxt->exception;
 
 	if (ex->vector == DB_VECTOR)
-		kvm_queue_exception_e(vcpu, DB_VECTOR, ex->dr6);
-	else if (ex->vector == PF_VECTOR)
+		return kvm_inject_emulated_db(vcpu, ex->dr6);
+
+	if (ex->vector == PF_VECTOR)
 		kvm_inject_emulated_page_fault(vcpu, ex);
 	else if (ex->error_code_valid)
 		kvm_queue_exception_e(vcpu, ex->vector, ex->error_code);
 	else
 		kvm_queue_exception(vcpu, ex->vector);
+	return 1;
 }
 
 static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)
@@ -9441,8 +9481,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				 */
 				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
 					     exception_type(ctxt->exception.vector) == EXCPT_TRAP);
-				inject_emulated_exception(vcpu);
-				return 1;
+				return inject_emulated_exception(vcpu);
 			}
 			return handle_emulation_failure(vcpu, emulation_type);
 		}
@@ -9537,8 +9576,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (ctxt->have_exception) {
 		WARN_ON_ONCE(vcpu->mmio_needed && !vcpu->mmio_is_write);
 		vcpu->mmio_needed = false;
-		r = 1;
-		inject_emulated_exception(vcpu);
+		r = inject_emulated_exception(vcpu);
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
 			/* FIXME: return into emulator if single-stepping.  */
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..7543ab2ec1f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -617,6 +617,13 @@ static inline bool kvm_dr6_valid(u64 data)
 	return !(data >> 32);
 }
 
+static inline unsigned long kvm_get_eff_dr7(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		return vcpu->arch.guest_debug_dr7;
+	return vcpu->arch.dr7;
+}
+
 /*
  * Trigger machine check on the host. We assume all the MSRs are already set up
  * by the CPU and that we still run on the same CPU as the MCE occurred on.
-- 
2.31.1


