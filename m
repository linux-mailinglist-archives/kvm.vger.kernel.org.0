Return-Path: <kvm+bounces-23965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7082B95020A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F20331F23063
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D67019B5A5;
	Tue, 13 Aug 2024 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7pcRdrK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B856619B3D6;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543583; cv=none; b=KeLG2OsLEOM/ssD6NdEYZc2dZ6gByp+eiIjieuTWUe0cseEMNw4tpobB5kVFU+HMbECklCyEh+3qFX6aXmowRSMtESVvB3B/7kzDyaCc3lUEfvhJxuZ5pUe+RgwcOKXJoU1uGn/d9cVLtbJlCS8g9oojq7SsUrI+JnuS8wBYL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543583; c=relaxed/simple;
	bh=aU4Ozt59GbaUbO3+PotNeMwxVTRMgu3/5LP0uRVy3Do=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M1vq69oeYHBRfc7AlB8NaDxPruvzE5pRe1TnkugjxzCTv9dmfamPckwFzHtOetoYTIjrnjoOHmSLEgVQT1whp1VEaQnAWoUVrcOy39w9ILNDXRfqNBtVSlfYStklxJEpu/1UPPKPjOYxlGHH8CtO4FM8TS2LcfvWAce71xdmZJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7pcRdrK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA8BC4AF10;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543583;
	bh=aU4Ozt59GbaUbO3+PotNeMwxVTRMgu3/5LP0uRVy3Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7pcRdrK5hiFr5bN1UNYZjFsk1HT3zU3JyXwWV6oQGPPq3M3jYxxCmz3RFHIXKQpw
	 upHdn8nPYk3Kx8ehWyc1ATNiAFyU8sBqHKxip7P8J/3XC/ndy3nafu6G+HcdPnVQiU
	 SaIDQL8lPkwwGjVhp+ITtX+jx4iOrNEozsUPWgcptamtYQ0XuipRX3cXwY1a8CuA9m
	 1CmwsQv6tDXLccLmUl1jDoSEEJpjK+8eUHOB3+QnrkPwL+sR80wJnd5kCczzesNj/H
	 YtW5U0rO8mtx8YNUhWxWfIE5d6BkB2dL3LE7u9lESsxzXji9IjcVF3lvQv0uzRORmT
	 +MVnD6a4gLenw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ1-003INM-BK;
	Tue, 13 Aug 2024 11:06:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v3 09/18] KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}
Date: Tue, 13 Aug 2024 11:05:31 +0100
Message-Id: <20240813100540.1955263-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Emulating AT instructions is one the tasks devolved to the host
hypervisor when NV is on.

Here, we take the basic approach of emulating AT S1E{0,1}{R,W}
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
 arch/arm64/kvm/at.c              | 140 +++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/at.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 25f49f5fc4a6..9b6c9f4f4d88 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -236,6 +236,7 @@ extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
+extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a6497228c5a8..8a3ae76b4da2 100644
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
index 000000000000..da378ad834cd
--- /dev/null
+++ b/arch/arm64/kvm/at.c
@@ -0,0 +1,140 @@
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
+	write_sysreg(config->hcr,	hcr_el2);
+
+	/*
+	 * ARM errata 1165522 and 1530923 require TGE to be 1 before
+	 * we update the guest state.
+	 */
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
+
+	write_sysreg_el1(config->ttbr0,	SYS_TTBR0);
+	write_sysreg_el1(config->ttbr1,	SYS_TTBR1);
+	write_sysreg_el1(config->tcr,	SYS_TCR);
+	write_sysreg_el1(config->mair,	SYS_MAIR);
+	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
+	write_sysreg(config->vttbr,	vttbr_el2);
+	write_sysreg(config->vtcr,	vtcr_el2);
+}
+
+/*
+ * Return the PAR_EL1 value as the result of a valid translation.
+ *
+ * If the translation is unsuccessful, the value may only contain
+ * PAR_EL1.F, and cannot be taken at face value. It isn't an
+ * indication of the translation having failed, only that the fast
+ * path did not succeed, *unless* it indicates a S1 permission fault.
+ */
+static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct mmu_config config;
+	struct kvm_s2_mmu *mmu;
+	bool fail;
+	u64 par;
+
+	par = SYS_PAR_EL1_F;
+
+	/*
+	 * We've trapped, so everything is live on the CPU. As we will
+	 * be switching contexts behind everybody's back, disable
+	 * interrupts while holding the mmu lock.
+	 */
+	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * If HCR_EL2.{E2H,TGE} == {1,1}, the MMU context is already
+	 * the right one (as we trapped from vEL2). If not, save the
+	 * full MMU context.
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+		goto skip_mmu_switch;
+
+	/*
+	 * Obtaining the S2 MMU for a L2 is horribly racy, and we may not
+	 * find it (recycled by another vcpu, for example). When this
+	 * happens, admit defeat immediately and use the SW (slow) path.
+	 */
+	mmu = lookup_s2_mmu(vcpu);
+	if (!mmu)
+		return par;
+
+	__mmu_config_save(&config);
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
+		fail = __kvm_at(OP_AT_S1E1R, vaddr);
+		break;
+	case OP_AT_S1E1W:
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
+		par = read_sysreg_par();
+
+	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+		__mmu_config_restore(&config);
+
+	return par;
+}
+
+void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
+
+	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+}
-- 
2.39.2


