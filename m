Return-Path: <kvm+bounces-57166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7972B50BF3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC3A61887CD5
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B49248F6F;
	Wed, 10 Sep 2025 02:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="Esjrdf3z"
X-Original-To: kvm@vger.kernel.org
Received: from out28-52.mail.aliyun.com (out28-52.mail.aliyun.com [115.124.28.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C9318E1F;
	Wed, 10 Sep 2025 02:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472890; cv=none; b=Zfy8n0zOqsVfgymeWF1Q1ULr7M+lpRHgGaWPVtf+TxS0Tf51DLTsYthpM5I8g2F95oOPiV51GviJWDt/Zq4KlZmP5EAidB5Wi0oipja4IZK3ffGJyYlJbimgJs3B68cMSSZ04xN4vT7UJE5FSYB/VMxkKb2e8jJRIEE+9bbAsmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472890; c=relaxed/simple;
	bh=B4xvjjI1rrLCW6sI7GSnMtzM776TeMbBZrnd2OKF/A0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hxkdPuCV+6NwwI7jw+siLaQVZ4OhW7AJ0RT3OggfaBbcL7BaSF6FQO9c6AY3tS4H2bUtjtud99HiaNYzMINosZo0+PWkOFHuQpzmsra3YcwmcmykXfKGIN3vYN4VcynmoeoJJZloL+mCIZrigFdIUMuqs7r57122+3XMp7zAJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=Esjrdf3z; arc=none smtp.client-ip=115.124.28.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757472884; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=28FlJ5PhUPR1yuFNdYQOxlXS7iJPbikWqlooFHuZXaI=;
	b=Esjrdf3zVoypVoE31+lesII6s3/JrUDsvtZdMnaYoS2soUTgBUqitThEp7yd16ErVrMfLVezTv4LPBh/hLTVfr6AuK5IacFgNRJNUGbeW3Mnp6DMUX3rzwEQp2ycY5plqIFWkg3xz/3vDyOwbBMR5pPsHPrOFkgVu8KeZ+LmrGg=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ebgggze_1757472565 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 10 Sep 2025 10:49:25 +0800
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
Subject: [PATCH 2/7] KVM: x86: Check guest debug in DR access instruction emulation
Date: Wed, 10 Sep 2025 10:49:14 +0800
Message-Id: <6d375ab3edb54645ac16e0446dc7516105ed4b04.1757416809.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
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
 arch/x86/kvm/x86.c         | 51 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.h         |  7 ++++++
 4 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 18e3a732d106..87d98ffd7d2d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3858,7 +3858,7 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 	if ((cr4 & X86_CR4_DE) && (dr == 4 || dr == 5))
 		return emulate_ud(ctxt);
 
-	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD)
+	if (ctxt->ops->get_eff_dr(ctxt, 7) & DR7_GD)
 		return emulate_db(ctxt, DR6_BD);
 
 	return X86EMUL_CONTINUE;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index a6fad7b938e3..b971b2947094 100644
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
index b2e8322aeca7..cf289d04b104 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1571,6 +1571,22 @@ unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr)
 }
 EXPORT_SYMBOL_GPL(kvm_get_dr);
 
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
@@ -8207,6 +8223,11 @@ static unsigned long emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr)
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
@@ -8563,6 +8584,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_cr              = emulator_set_cr,
 	.cpl                 = emulator_get_cpl,
 	.get_dr              = emulator_get_dr,
+	.get_eff_dr          = emulator_get_eff_dr,
 	.set_dr              = emulator_set_dr,
 	.set_msr_with_filter = emulator_set_msr_with_filter,
 	.get_msr_with_filter = emulator_get_msr_with_filter,
@@ -8606,19 +8628,38 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
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
+	int r = 1;
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 
 	if (ctxt->exception.vector == PF_VECTOR)
 		kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
 	else if (ctxt->exception.vector == DB_VECTOR)
-		kvm_queue_exception_p(vcpu, DB_VECTOR, ctxt->exception.dr6);
+		r = kvm_inject_emulated_db(vcpu, ctxt->exception.dr6);
 	else if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
 				      ctxt->exception.error_code);
 	else
 		kvm_queue_exception(vcpu, ctxt->exception.vector);
+
+	return r;
 }
 
 static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)
@@ -9098,8 +9139,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				 */
 				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
 					     exception_type(ctxt->exception.vector) == EXCPT_TRAP);
-				inject_emulated_exception(vcpu);
-				return 1;
+				return inject_emulated_exception(vcpu);
 			}
 			return handle_emulation_failure(vcpu, emulation_type);
 		}
@@ -9190,8 +9230,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
index eb3088684e8a..7ad3b9645ea3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -593,6 +593,13 @@ static inline bool kvm_dr6_valid(u64 data)
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


