Return-Path: <kvm+bounces-2094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E08957F140B
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8E71C215BF
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F231E536;
	Mon, 20 Nov 2023 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uT0uKI94"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4227C1DA50;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEBEC433C9;
	Mon, 20 Nov 2023 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485857;
	bh=e8RDz47CI1UIy/kMDMFeBJwhcKDdDZlK+Yx7vIDXl+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uT0uKI94kckv0BgQyIXYsqrAdvMtZ6oY9Kc9Z4yOZC5/vosx8UrV4ZrHmwDqo58oG
	 H4XFF7TV7KME6zeOPiOB5GMqNuIP/2FUwZiC2kMAwQqaRF/NHPoAp3zF5OqK//Kg2Q
	 2n0WTwUnaS6RNlKOdNPlYxm5r9vAKZAOhzC07zjZlZUrpeUtf77HLWMAW34liZesQi
	 93MKuFLMetLR7Ru1I9wWF4dPyuxG6bBp5HE8p+/D3CDPTlpRCPErvXLZ8/W+vRF8l0
	 TIYU0k+toQaqYOAsx3u4CKKPVw/6FyTTiaegmHBx8gncBHQdmhDl5qcOm1HY6ybdtW
	 NfahiV6g9QGBg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543C-00EjnU-UG;
	Mon, 20 Nov 2023 13:10:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 23/43] KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
Date: Mon, 20 Nov 2023 13:10:07 +0000
Message-Id: <20231120131027.854038-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When supporting nested virtualization a guest hypervisor executing AT
instructions must be trapped and emulated by the host hypervisor,
because untrapped AT instructions operating on S1E1 will use the wrong
translation regieme (the one used to emulate virtual EL2 in EL1 instead
of virtual EL1) and AT instructions operating on S12 will not work from
EL1.

This patch does several things.

1. List and define all AT system instructions to emulate and document
the emulation design.

2. Implement AT instruction handling logic in EL2. This will be used to
emulate AT instructions executed in the virtual EL2.

AT instruction emulation works by loading the proper processor
context, which depends on the trapped instruction and the virtual
HCR_EL2, to the EL1 virtual memory control registers and executing AT
instructions. Note that ctxt->hw_sys_regs is expected to have the
proper processor context before calling the handling
function(__kvm_at_insn) implemented in this patch.

4. Emulate AT S1E[01] instructions by issuing the same instructions in
EL2. We set the physical EL1 registers, NV and NV1 bits as described in
the AT instruction emulation overview.

5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
translation by reusing the existing AT emulation functions.  Second, do
the stage-2 translation by walking the guest hypervisor's stage-2 page
table in software. Record the translation result to PAR_EL1.

6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
instructions in EL2. We set the physical EL1 registers and the HCR_EL2
register as described in the AT instruction emulation overview.

7. Forward system instruction traps to the virtual EL2 if the corresponding
virtual AT bit is set in the virtual HCR_EL2.

  [ Much logic above has been reworked by Marc Zyngier ]

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |   1 +
 arch/arm64/include/asm/kvm_asm.h |   2 +
 arch/arm64/kvm/Makefile          |   2 +-
 arch/arm64/kvm/at.c              | 219 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        | 217 ++++++++++++++++++++++++++++++
 5 files changed, 440 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/at.c

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 9c10c88d2fc2..d0b5ba7ecccf 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -132,6 +132,7 @@
 #define VTCR_EL2_TG0_16K	TCR_TG0_16K
 #define VTCR_EL2_TG0_64K	TCR_TG0_64K
 #define VTCR_EL2_SH0_MASK	TCR_SH0_MASK
+#define VTCR_EL2_SH0_SHIFT	TCR_SH0_SHIFT
 #define VTCR_EL2_SH0_INNER	TCR_SH0_INNER
 #define VTCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
 #define VTCR_EL2_ORGN0_WBWA	TCR_ORGN0_WBWA
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 24b5e6b23417..ee50ed8a2a47 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -235,6 +235,8 @@ extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
+extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c0c050e53157..c2717a8f12f5 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
-	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o \
+	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
new file mode 100644
index 000000000000..6d47dd409384
--- /dev/null
+++ b/arch/arm64/kvm/at.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017 - Linaro Ltd
+ * Author: Jintack Lim <jintack.lim@linaro.org>
+ */
+
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+struct mmu_config {
+	u64	ttbr0;
+	u64	ttbr1;
+	u64	tcr;
+	u64	sctlr;
+	u64	vttbr;
+	u64	vtcr;
+	u64	hcr;
+};
+
+static void __mmu_config_save(struct mmu_config *config)
+{
+	config->ttbr0	= read_sysreg_el1(SYS_TTBR0);
+	config->ttbr1	= read_sysreg_el1(SYS_TTBR1);
+	config->tcr	= read_sysreg_el1(SYS_TCR);
+	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
+	config->vttbr	= read_sysreg(vttbr_el2);
+	config->vtcr	= read_sysreg(vtcr_el2);
+	config->hcr	= read_sysreg(hcr_el2);
+}
+
+static void __mmu_config_restore(struct mmu_config *config)
+{
+	write_sysreg_el1(config->ttbr0,	SYS_TTBR0);
+	write_sysreg_el1(config->ttbr1,	SYS_TTBR1);
+	write_sysreg_el1(config->tcr,	SYS_TCR);
+	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
+	write_sysreg(config->vttbr,	vttbr_el2);
+	write_sysreg(config->vtcr,	vtcr_el2);
+	write_sysreg(config->hcr,	hcr_el2);
+
+	isb();
+}
+
+void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	struct mmu_config config;
+	struct kvm_s2_mmu *mmu;
+	bool fail;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * If HCR_EL2.{E2H,TGE} == {1,1}, the MMU context is already
+	 * the right one (as we trapped from vEL2).
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+		goto skip_mmu_switch;
+
+	/*
+	 * FIXME: Obtaining the S2 MMU for a L2 is horribly racy, and
+	 * we may not find it (recycled by another vcpu, for example).
+	 * See the other FIXME comment below about the need for a SW
+	 * PTW in this case.
+	 */
+	mmu = lookup_s2_mmu(vcpu);
+	if (WARN_ON(!mmu))
+		goto out;
+
+	/* We've trapped, so everything is live on the CPU. */
+	__mmu_config_save(&config);
+
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
+	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
+	/*
+	 * REVISIT: do we need anything from the guest's VTCR_EL2? If
+	 * looks like keeping the hosts configuration is the right
+	 * thing to do at this stage (and we could avoid save/restore
+	 * it. Keep the host's version for now.
+	 */
+	write_sysreg((config.hcr & ~HCR_TGE) | HCR_VM,	hcr_el2);
+
+	isb();
+
+skip_mmu_switch:
+
+	switch (op) {
+	case OP_AT_S1E1R:
+	case OP_AT_S1E1RP:
+		fail = __kvm_at("s1e1r", vaddr);
+		break;
+	case OP_AT_S1E1W:
+	case OP_AT_S1E1WP:
+		fail = __kvm_at("s1e1w", vaddr);
+		break;
+	case OP_AT_S1E0R:
+		fail = __kvm_at("s1e0r", vaddr);
+		break;
+	case OP_AT_S1E0W:
+		fail = __kvm_at("s1e0w", vaddr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	if (!fail)
+		ctxt_sys_reg(ctxt, PAR_EL1) = read_sysreg(par_el1);
+	else
+		ctxt_sys_reg(ctxt, PAR_EL1) = SYS_PAR_EL1_F;
+
+	/*
+	 * Failed? let's leave the building now.
+	 *
+	 * FIXME: how about a failed translation because the shadow S2
+	 * wasn't populated? We may need to perform a SW PTW,
+	 * populating our shadow S2 and retry the instruction.
+	 */
+	if (ctxt_sys_reg(ctxt, PAR_EL1) & SYS_PAR_EL1_F)
+		goto nopan;
+
+	/* No PAN? No problem. */
+	if (!vcpu_el2_e2h_is_set(vcpu) || !(*vcpu_cpsr(vcpu) & PSR_PAN_BIT))
+		goto nopan;
+
+	/*
+	 * For PAN-involved AT operations, perform the same
+	 * translation, using EL0 this time.
+	 */
+	switch (op) {
+	case OP_AT_S1E1RP:
+		fail = __kvm_at("s1e0r", vaddr);
+		break;
+	case OP_AT_S1E1WP:
+		fail = __kvm_at("s1e0w", vaddr);
+		break;
+	default:
+		goto nopan;
+	}
+
+	/*
+	 * If the EL0 translation has succeeded, we need to pretend
+	 * the AT operation has failed, as the PAN setting forbids
+	 * such a translation.
+	 *
+	 * FIXME: we hardcode a Level-3 permission fault. We really
+	 * should return the real fault level.
+	 */
+	if (fail || !(read_sysreg(par_el1) & SYS_PAR_EL1_F))
+		ctxt_sys_reg(ctxt, PAR_EL1) = (0xf << 1) | SYS_PAR_EL1_F;
+
+nopan:
+	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+		__mmu_config_restore(&config);
+
+out:
+	write_unlock(&vcpu->kvm->mmu_lock);
+}
+
+void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	struct mmu_config config;
+	struct kvm_s2_mmu *mmu;
+	u64 val;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	mmu = &vcpu->kvm->arch.mmu;
+
+	/* We've trapped, so everything is live on the CPU. */
+	__mmu_config_save(&config);
+
+	if (vcpu_el2_e2h_is_set(vcpu)) {
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL2),	SYS_TTBR1);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL2),	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL2),	SYS_SCTLR);
+
+		val = config.hcr;
+	} else {
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
+		val = translate_tcr_el2_to_tcr_el1(ctxt_sys_reg(ctxt, TCR_EL2));
+		write_sysreg_el1(val, SYS_TCR);
+		val = translate_sctlr_el2_to_sctlr_el1(ctxt_sys_reg(ctxt, SCTLR_EL2));
+		write_sysreg_el1(val, SYS_SCTLR);
+
+		val = config.hcr | HCR_NV | HCR_NV1;
+	}
+
+	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
+	/* FIXME: write S2 MMU VTCR_EL2? */
+	write_sysreg((val & ~HCR_TGE) | HCR_VM,		hcr_el2);
+
+	isb();
+
+	switch (op) {
+	case OP_AT_S1E2R:
+		asm volatile("at s1e1r, %0" : : "r" (vaddr));
+		break;
+	case OP_AT_S1E2W:
+		asm volatile("at s1e1w, %0" : : "r" (vaddr));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	isb();
+
+	/* FIXME: handle failed translation due to shadow S2 */
+	ctxt_sys_reg(ctxt, PAR_EL1) = read_sysreg(par_el1);
+
+	__mmu_config_restore(&config);
+	write_unlock(&vcpu->kvm->mmu_lock);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 49d00f0cdda0..475e245cd653 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2776,16 +2776,233 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static bool handle_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	__kvm_at_s1e01(vcpu, sys_encoding, p->regval);
+
+	return true;
+}
+
+static bool handle_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	__kvm_at_s1e2(vcpu, sys_encoding, p->regval);
+
+	return true;
+}
+
+static u64 setup_par_aborted(u32 esr)
+{
+	u64 par = 0;
+
+	/* S [9]: fault in the stage 2 translation */
+	par |= (1 << 9);
+	/* FST [6:1]: Fault status code  */
+	par |= (esr << 1);
+	/* F [0]: translation is aborted */
+	par |= 1;
+
+	return par;
+}
+
+static u64 setup_par_completed(struct kvm_vcpu *vcpu, struct kvm_s2_trans *out)
+{
+	u64 par, vtcr_sh0;
+
+	/* F [0]: Translation is completed successfully */
+	par = 0;
+	/* ATTR [63:56] */
+	par |= out->upper_attr;
+	/* PA [47:12] */
+	par |= out->output & GENMASK_ULL(11, 0);
+	/* RES1 [11] */
+	par |= (1UL << 11);
+	/* SH [8:7]: Shareability attribute */
+	vtcr_sh0 = vcpu_read_sys_reg(vcpu, VTCR_EL2) & VTCR_EL2_SH0_MASK;
+	par |= (vtcr_sh0 >> VTCR_EL2_SH0_SHIFT) << 7;
+
+	return par;
+}
+
+static bool handle_s12(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+		       const struct sys_reg_desc *r, bool write)
+{
+	u64 par, va;
+	u32 esr, op;
+	phys_addr_t ipa;
+	struct kvm_s2_trans out;
+	int ret;
+
+	/* Do the stage-1 translation */
+	va = p->regval;
+	op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	switch (op) {
+	case OP_AT_S12E1R:
+		op = OP_AT_S1E1R;
+		break;
+	case OP_AT_S12E1W:
+		op = OP_AT_S1E1W;
+		break;
+	case OP_AT_S12E0R:
+		op = OP_AT_S1E0R;
+		break;
+	case OP_AT_S12E0W:
+		op = OP_AT_S1E0W;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return true;
+	}
+
+	__kvm_at_s1e01(vcpu, op, va);
+	par = vcpu_read_sys_reg(vcpu, PAR_EL1);
+	if (par & 1) {
+		/* The stage-1 translation aborted */
+		return true;
+	}
+
+	/* Do the stage-2 translation */
+	ipa = (par & GENMASK_ULL(47, 12)) | (va & GENMASK_ULL(11, 0));
+	out.esr = 0;
+	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	if (ret < 0)
+		return false;
+
+	/* Check if the stage-2 PTW is aborted */
+	if (out.esr) {
+		esr = out.esr;
+		goto s2_trans_abort;
+	}
+
+	/* Check the access permission */
+	if ((!write && !out.readable) || (write && !out.writable)) {
+		esr = ESR_ELx_FSC_PERM;
+		esr |= out.level & 0x3;
+		goto s2_trans_abort;
+	}
+
+	vcpu_write_sys_reg(vcpu, setup_par_completed(vcpu, &out), PAR_EL1);
+	return true;
+
+s2_trans_abort:
+	vcpu_write_sys_reg(vcpu, setup_par_aborted(esr), PAR_EL1);
+	return true;
+}
+
+static bool handle_s12r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	return handle_s12(vcpu, p, r, false);
+}
+
+static bool handle_s12w(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	return handle_s12(vcpu, p, r, true);
+}
+
+/*
+ * AT instruction emulation
+ *
+ * We emulate AT instructions executed in the virtual EL2.
+ * Basic strategy for the stage-1 translation emulation is to load proper
+ * context, which depends on the trapped instruction and the virtual HCR_EL2,
+ * to the EL1 virtual memory control registers and execute S1E[01] instructions
+ * in EL2. See below for more detail.
+ *
+ * For the stage-2 translation, which is necessary for S12E[01] emulation,
+ * we walk the guest hypervisor's stage-2 page table in software.
+ *
+ * The stage-1 translation emulations can be divided into two groups depending
+ * on the translation regime.
+ *
+ * 1. EL2 AT instructions: S1E2x
+ * +-----------------------------------------------------------------------+
+ * |                             |         Setting for the emulation       |
+ * | Virtual HCR_EL2.E2H on trap |-----------------------------------------+
+ * |                             | Phys EL1 regs | Phys NV, NV1 | Phys TGE |
+ * |-----------------------------------------------------------------------|
+ * |             0               |     vEL2      |    (1, 1)    |    0     |
+ * |             1               |     vEL2      |    (0, 0)    |    0     |
+ * +-----------------------------------------------------------------------+
+ *
+ * We emulate the EL2 AT instructions by loading virtual EL2 context
+ * to the EL1 virtual memory control registers and executing corresponding
+ * EL1 AT instructions.
+ *
+ * We set physical NV and NV1 bits to use EL2 page table format for non-VHE
+ * guest hypervisor (i.e. HCR_EL2.E2H == 0). As a VHE guest hypervisor uses the
+ * EL1 page table format, we don't set those bits.
+ *
+ * We should clear physical TGE bit not to use the EL2 translation regime when
+ * the host uses the VHE feature.
+ *
+ *
+ * 2. EL0/EL1 AT instructions: S1E[01]x, S12E1x
+ * +----------------------------------------------------------------------+
+ * |   Virtual HCR_EL2 on trap  |        Setting for the emulation        |
+ * |----------------------------------------------------------------------+
+ * | (vE2H, vTGE) | (vNV, vNV1) | Phys EL1 regs | Phys NV, NV1 | Phys TGE |
+ * |----------------------------------------------------------------------|
+ * |    (0, 0)*   |   (0, 0)    |      vEL1     |    (0, 0)    |    0     |
+ * |    (0, 0)    |   (1, 1)    |      vEL1     |    (1, 1)    |    0     |
+ * |    (1, 1)    |   (0, 0)    |      vEL2     |    (0, 0)    |    0     |
+ * |    (1, 1)    |   (1, 1)    |      vEL2     |    (1, 1)    |    0     |
+ * +----------------------------------------------------------------------+
+ *
+ * *For (0, 0) in the 'Virtual HCR_EL2 on trap' column, it actually means
+ *  (1, 1). Keep them (0, 0) just for the readability.
+ *
+ * We set physical EL1 virtual memory control registers depending on
+ * (vE2H, vTGE) pair. When the pair is (0, 0) where AT instructions are
+ * supposed to use EL0/EL1 translation regime, we load the EL1 registers with
+ * the virtual EL1 registers (i.e. EL1 registers from the guest hypervisor's
+ * point of view). When the pair is (1, 1), however, AT instructions are defined
+ * to apply EL2 translation regime. To emulate this behavior, we load the EL1
+ * registers with the virtual EL2 context. (i.e the shadow registers)
+ *
+ * We respect the virtual NV and NV1 bit for the emulation. When those bits are
+ * set, it means that a guest hypervisor would like to use EL2 page table format
+ * for the EL1 translation regime. We emulate this by setting the physical
+ * NV and NV1 bits.
+ */
+
+#define SYS_INSN(insn, access_fn)					\
+	{								\
+		SYS_DESC(OP_##insn),					\
+		.access = (access_fn),					\
+	}
+
 static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
+
+	SYS_INSN(AT_S1E1R, handle_s1e01),
+	SYS_INSN(AT_S1E1W, handle_s1e01),
+	SYS_INSN(AT_S1E0R, handle_s1e01),
+	SYS_INSN(AT_S1E0W, handle_s1e01),
+	SYS_INSN(AT_S1E1RP, handle_s1e01),
+	SYS_INSN(AT_S1E1WP, handle_s1e01),
+
 	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+
+	SYS_INSN(AT_S1E2R, handle_s1e2),
+	SYS_INSN(AT_S1E2W, handle_s1e2),
+	SYS_INSN(AT_S12E1R, handle_s12r),
+	SYS_INSN(AT_S12E1W, handle_s12w),
+	SYS_INSN(AT_S12E0R, handle_s12r),
+	SYS_INSN(AT_S12E0W, handle_s12w),
 };
 
 static const struct sys_reg_desc *first_idreg;
-- 
2.39.2


