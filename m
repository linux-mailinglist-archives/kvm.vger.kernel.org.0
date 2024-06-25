Return-Path: <kvm+bounces-20482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA285916910
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D8931F29289
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F3916F916;
	Tue, 25 Jun 2024 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIfNGpWm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD89716B39A;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322525; cv=none; b=DSTBlrX6uzzgKdjYMqIncyp9AovCA2t1C35llJnvlRoclTcVNaTIpPM7Tps67ibv3p2qKPgqa04ITEgHk+6GUGByeG2gSpYS9VEVCW928EhD4e1XZKhQlDJjf9ZwcP+BImtkqZ5L67KKOA3l/tkwNjcZj+YIc/UyzUOBAVqGe9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322525; c=relaxed/simple;
	bh=c7fOw1CSlWTYN7dAgxetZtYg+b+8xyVjBZ2uZ5Ivxkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e+F0OMpdt4KfGOF0GM8MWNfd7jEZg13mQjrY8mQsZnILtGw+gaHnzmHT7Qgo15RiabYQiMIMee0Wx7n5N+w9BnSZekxU6/kdY9ogwrPVJrBS3FgbfQylTZijKVlwNQIpbDYzoGyiXDauH+7B9oRQ13aO8ZOfgQGcmaoeFRZYrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIfNGpWm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B45C4AF0C;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322524;
	bh=c7fOw1CSlWTYN7dAgxetZtYg+b+8xyVjBZ2uZ5Ivxkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIfNGpWmTbvYfgnzYCrxBdCDPLkuUp1zmD4u4JGHiwCLzKq0BWosXKyAU3aNG3mzM
	 WNQzJfGXK+YZPhMP3+4mJOQA0rZOyzWGv2QLWHmBPOG6AmExuRe7O09Zkrjd8PfKWf
	 8GtyVLMhJ50MREdO8HBOgF1wCJL4EGK3QCyJZj6ImloCuD2KavSp7+vNmFLKwTTaZH
	 yK2Y2ljTPR82NjQ7XPwSWFSf5/YVd0LS1GMMGqh8D8cMvvocLHka+1HHM1UdeYQqPU
	 nzUnn4LOYzaxCzqJei9PtcvDHry2JLxAjYEXPbvFyjSCloawFBZ+Bcrd8F7OWBxBeU
	 Vr4wc+9SinwaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KQ-007A6l-Ta;
	Tue, 25 Jun 2024 14:35:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 06/12] KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}[P]
Date: Tue, 25 Jun 2024 14:35:05 +0100
Message-Id: <20240625133508.259829-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Emulating AT instructions is one the tasks devolved to the host
hypervisor when NV is on.

Here, we take the basic approach of emulating AT S1E{0,1}{R,W}[P]
using the AT instructions themselves. While this mostly work,
it doesn't *always* work:

- S1 page tables can be swapped out

- shadow S2 can be incomplete and not contain mappings for
  the S1 page tables

We are not trying to handle these case here, and defer it to
a later patch. Suitable comments indicate where we are in dire
need of better handling.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |   1 +
 arch/arm64/kvm/Makefile          |   2 +-
 arch/arm64/kvm/at.c              | 197 +++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/at.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 25f49f5fc4a63..9b6c9f4f4d885 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -236,6 +236,7 @@ extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
+extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a6497228c5a8c..8a3ae76b4da22 100644
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
index 0000000000000..eb0aa49e61f68
--- /dev/null
+++ b/arch/arm64/kvm/at.c
@@ -0,0 +1,197 @@
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
+	u64	mair;
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
+	config->mair	= read_sysreg_el1(SYS_MAIR);
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
+	write_sysreg_el1(config->mair,	SYS_MAIR);
+	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
+	write_sysreg(config->vttbr,	vttbr_el2);
+	write_sysreg(config->vtcr,	vtcr_el2);
+	/*
+	 * ARM errata 1165522 and 1530923 require the actual execution of the
+	 * above before we can switch to the EL1/EL0 translation regime used by
+	 * the guest.
+	 */
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
+
+	write_sysreg(config->hcr,	hcr_el2);
+
+	isb();
+}
+
+static bool check_at_pan(struct kvm_vcpu *vcpu, u64 vaddr, u64 *res)
+{
+	u64 par_e0;
+	bool fail;
+
+	/*
+	 * For PAN-involved AT operations, perform the same translation,
+	 * using EL0 this time. Twice. Much fun.
+	 */
+	fail = __kvm_at(OP_AT_S1E0R, vaddr);
+	if (fail)
+		return true;
+
+	par_e0 = read_sysreg_par();
+	if (!(par_e0 & SYS_PAR_EL1_F))
+		goto out;
+
+	fail = __kvm_at(OP_AT_S1E0W, vaddr);
+	if (fail)
+		return true;
+
+	par_e0 = read_sysreg_par();
+out:
+	*res = par_e0;
+	return false;
+}
+
+void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct mmu_config config;
+	struct kvm_s2_mmu *mmu;
+	unsigned long flags;
+	bool fail;
+	u64 par;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * We've trapped, so everything is live on the CPU. As we will
+	 * be switching contexts behind everybody's back, disable
+	 * interrupts...
+	 */
+	local_irq_save(flags);
+	__mmu_config_save(&config);
+
+	/*
+	 * If HCR_EL2.{E2H,TGE} == {1,1}, the MMU context is already
+	 * the right one (as we trapped from vEL2). We have done too
+	 * much work by saving the full MMU context, but who cares?
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
+	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR0_EL1),	SYS_TTBR0);
+	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
+	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
+	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
+	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
+	__load_stage2(mmu, mmu->arch);
+
+skip_mmu_switch:
+	/* Clear TGE, enable S2 translation, we're rolling */
+	write_sysreg((config.hcr & ~HCR_TGE) | HCR_VM,	hcr_el2);
+	isb();
+
+	switch (op) {
+	case OP_AT_S1E1R:
+	case OP_AT_S1E1RP:
+		fail = __kvm_at(OP_AT_S1E1R, vaddr);
+		break;
+	case OP_AT_S1E1W:
+	case OP_AT_S1E1WP:
+		fail = __kvm_at(OP_AT_S1E1W, vaddr);
+		break;
+	case OP_AT_S1E0R:
+		fail = __kvm_at(OP_AT_S1E0R, vaddr);
+		break;
+	case OP_AT_S1E0W:
+		fail = __kvm_at(OP_AT_S1E0W, vaddr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		fail = true;
+		break;
+	}
+
+	if (!fail)
+		par = read_sysreg(par_el1);
+	else
+		par = SYS_PAR_EL1_F;
+
+	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+
+	/*
+	 * Failed? let's leave the building now.
+	 *
+	 * FIXME: how about a failed translation because the shadow S2
+	 * wasn't populated? We may need to perform a SW PTW,
+	 * populating our shadow S2 and retry the instruction.
+	 */
+	if (par & SYS_PAR_EL1_F)
+		goto nopan;
+
+	/* No PAN? No problem. */
+	if (!(*vcpu_cpsr(vcpu) & PSR_PAN_BIT))
+		goto nopan;
+
+	switch (op) {
+	case OP_AT_S1E1RP:
+	case OP_AT_S1E1WP:
+		fail = check_at_pan(vcpu, vaddr, &par);
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
+	if (fail || !(par & SYS_PAR_EL1_F))
+		vcpu_write_sys_reg(vcpu, (0xf << 1) | SYS_PAR_EL1_F, PAR_EL1);
+
+nopan:
+	__mmu_config_restore(&config);
+out:
+	local_irq_restore(flags);
+
+	write_unlock(&vcpu->kvm->mmu_lock);
+}
-- 
2.39.2


