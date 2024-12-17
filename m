Return-Path: <kvm+bounces-33959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 626139F4F13
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32F027A35E7
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7661F76C9;
	Tue, 17 Dec 2024 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tH2eF4k1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7251F7567;
	Tue, 17 Dec 2024 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448445; cv=none; b=PPay6+kR2KpBgS6FdFdpZIcgN9RLF/U6e944H+X7NTt19igsg6/yQvQi6GTPlnOfAxvSAI2ojeUjnCwTypWfKT8umNe6ifudKiKUKZ2TX5UoOxKeMOf3WlqH2HK3m+dVxWQp2b7mokf7JKAQM9BlnJuFcUJFL9Wj6lOotoP/oKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448445; c=relaxed/simple;
	bh=ZazDMacD+OsJwszhNsJs0jzCPTWHDxmUqkqRwrsHAVw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p0qHbBzWksyJoFworApU0XeNVdJzSqE60QR0e1K3PodgVRx0IiSXuWImrbKQQyHBb8Q74/9aWjq1wKA7T9gT85401C2klOb+iWUHO8jtg9g1oVZXKCmollwCG7+BSPN7LYyKPL4IalvT0gippMtyA4+Fi7jS/BeeIrIQ3vLXdSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tH2eF4k1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A69C4CED4;
	Tue, 17 Dec 2024 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448444;
	bh=ZazDMacD+OsJwszhNsJs0jzCPTWHDxmUqkqRwrsHAVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH2eF4k1Z7NwpA2xwnn0QIHdQ+KTWMzDO+88I+NaPFIxNY9Ko6HqP8LPIP/h6v1ya
	 1az/S12OdVoI3YLzbjJF4MVw5VYCnEdeoBRh9V0sOixVKa3gMjXv/xsCyFoFd4N++5
	 UbtdXD0UsmYt7s31baU/avDzD4jzZ8A8nLhzktE5hYa9ycRG42wMZchsqcvevsE43x
	 cifd01TdyqV6Id3TI+b5KUv0h+fmS4f7ZAKfiMjYbAPHwWhQWqTUpbyYKZju2jy7yc
	 EClATAqwEkFglIYjWv7JI8tEOnsNRAHJYHcPzlFxNhl8DG+SkWR7mhHi7WPTAxDk1V
	 4D0hfGP4UE5Fg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGs-004bWV-LJ;
	Tue, 17 Dec 2024 15:14:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 01/16] arm64: sysreg: Add layout for ICH_HCR_EL2
Date: Tue, 17 Dec 2024 15:13:16 +0000
Message-Id: <20241217151331.934077-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217151331.934077-1-maz@kernel.org>
References: <20241217151331.934077-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eauger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ICH_HCR_EL2-related macros are missing a number of control
bits that we are about to handle. Take this opportunity to fully
describe the layout of that register as part of the automatic
generation infrastructure.

This results in a bit of churn, unfortunately.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h       | 12 ------------
 arch/arm64/kvm/emulate-nested.c       | 16 ++++++++--------
 arch/arm64/kvm/hyp/vgic-v3-sr.c       | 14 +++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c         | 17 +++++++++--------
 arch/arm64/tools/sysreg               | 22 ++++++++++++++++++++++
 drivers/irqchip/irq-apple-aic.c       |  8 ++++----
 tools/arch/arm64/include/asm/sysreg.h | 12 ------------
 7 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b8303a83c0bff..3e84ef8f5b311 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -561,7 +561,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
 #define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
 #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
@@ -1011,17 +1010,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
 
-/* ICH_HCR_EL2 bit definitions */
-#define ICH_HCR_EN		(1 << 0)
-#define ICH_HCR_UIE		(1 << 1)
-#define ICH_HCR_NPIE		(1 << 3)
-#define ICH_HCR_TC		(1 << 10)
-#define ICH_HCR_TALL0		(1 << 11)
-#define ICH_HCR_TALL1		(1 << 12)
-#define ICH_HCR_TDIR		(1 << 14)
-#define ICH_HCR_EOIcount_SHIFT	27
-#define ICH_HCR_EOIcount_MASK	(0x1f << ICH_HCR_EOIcount_SHIFT)
-
 /* ICH_VMCR_EL2 bit definitions */
 #define ICH_VMCR_ACK_CTL_SHIFT	2
 #define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1ffbfd1c3cf2e..c460b8403aec5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -395,26 +395,26 @@ static const struct trap_bits coarse_trap_bits[] = {
 	},
 	[CGT_ICH_HCR_TC] = {
 		.index		= ICH_HCR_EL2,
-		.value		= ICH_HCR_TC,
-		.mask		= ICH_HCR_TC,
+		.value		= ICH_HCR_EL2_TC,
+		.mask		= ICH_HCR_EL2_TC,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TALL0] = {
 		.index		= ICH_HCR_EL2,
-		.value		= ICH_HCR_TALL0,
-		.mask		= ICH_HCR_TALL0,
+		.value		= ICH_HCR_EL2_TALL0,
+		.mask		= ICH_HCR_EL2_TALL0,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TALL1] = {
 		.index		= ICH_HCR_EL2,
-		.value		= ICH_HCR_TALL1,
-		.mask		= ICH_HCR_TALL1,
+		.value		= ICH_HCR_EL2_TALL1,
+		.mask		= ICH_HCR_EL2_TALL1,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TDIR] = {
 		.index		= ICH_HCR_EL2,
-		.value		= ICH_HCR_TDIR,
-		.mask		= ICH_HCR_TDIR,
+		.value		= ICH_HCR_EL2_TDIR,
+		.mask		= ICH_HCR_EL2_TDIR,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 };
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3f9741e51d41b..b47dede973b3c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -218,7 +218,7 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 
 		elrsr = read_gicreg(ICH_ELRSR_EL2);
 
-		write_gicreg(cpu_if->vgic_hcr & ~ICH_HCR_EN, ICH_HCR_EL2);
+		write_gicreg(cpu_if->vgic_hcr & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
 
 		for (i = 0; i < used_lrs; i++) {
 			if (elrsr & (1 << i))
@@ -274,7 +274,7 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 	 * system registers to trap to EL1 (duh), force ICC_SRE_EL1.SRE to 1
 	 * so that the trap bits can take effect. Yes, we *loves* the GIC.
 	 */
-	if (!(cpu_if->vgic_hcr & ICH_HCR_EN)) {
+	if (!(cpu_if->vgic_hcr & ICH_HCR_EL2_En)) {
 		write_gicreg(ICC_SRE_EL1_SRE, ICC_SRE_EL1);
 		isb();
 	} else if (!cpu_if->vgic_sre) {
@@ -752,7 +752,7 @@ static void __vgic_v3_bump_eoicount(void)
 	u32 hcr;
 
 	hcr = read_gicreg(ICH_HCR_EL2);
-	hcr += 1 << ICH_HCR_EOIcount_SHIFT;
+	hcr += 1 << ICH_HCR_EL2_EOIcount_SHIFT;
 	write_gicreg(hcr, ICH_HCR_EL2);
 }
 
@@ -1069,7 +1069,7 @@ static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
 	case SYS_ICC_EOIR0_EL1:
 	case SYS_ICC_HPPIR0_EL1:
 	case SYS_ICC_IAR0_EL1:
-		return ich_hcr & ICH_HCR_TALL0;
+		return ich_hcr & ICH_HCR_EL2_TALL0;
 
 	case SYS_ICC_IGRPEN1_EL1:
 		if (is_read &&
@@ -1090,10 +1090,10 @@ static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
 	case SYS_ICC_EOIR1_EL1:
 	case SYS_ICC_HPPIR1_EL1:
 	case SYS_ICC_IAR1_EL1:
-		return ich_hcr & ICH_HCR_TALL1;
+		return ich_hcr & ICH_HCR_EL2_TALL1;
 
 	case SYS_ICC_DIR_EL1:
-		if (ich_hcr & ICH_HCR_TDIR)
+		if (ich_hcr & ICH_HCR_EL2_TDIR)
 			return true;
 
 		fallthrough;
@@ -1101,7 +1101,7 @@ static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
 	case SYS_ICC_RPR_EL1:
 	case SYS_ICC_CTLR_EL1:
 	case SYS_ICC_PMR_EL1:
-		return ich_hcr & ICH_HCR_TC;
+		return ich_hcr & ICH_HCR_EL2_TC;
 
 	default:
 		return false;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index f267bc2486a18..6c21be12959d6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -23,7 +23,7 @@ void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	cpuif->vgic_hcr |= ICH_HCR_UIE;
+	cpuif->vgic_hcr |= ICH_HCR_EL2_UIE;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
@@ -41,7 +41,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
-	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
+	cpuif->vgic_hcr &= ~ICH_HCR_EL2_UIE;
 
 	for (lr = 0; lr < cpuif->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
@@ -291,7 +291,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 					    ICH_VTR_PRI_BITS_SHIFT) + 1;
 
 	/* Get the show on the road... */
-	vgic_v3->vgic_hcr = ICH_HCR_EN;
+	vgic_v3->vgic_hcr = ICH_HCR_EL2_En;
 }
 
 void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
@@ -300,18 +300,19 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 
 	/* Hide GICv3 sysreg if necessary */
 	if (!kvm_has_gicv3(vcpu->kvm)) {
-		vgic_v3->vgic_hcr |= ICH_HCR_TALL0 | ICH_HCR_TALL1 | ICH_HCR_TC;
+		vgic_v3->vgic_hcr |= (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
+				      ICH_HCR_EL2_TC);
 		return;
 	}
 
 	if (group0_trap)
-		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
+		vgic_v3->vgic_hcr |= ICH_HCR_EL2_TALL0;
 	if (group1_trap)
-		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
+		vgic_v3->vgic_hcr |= ICH_HCR_EL2_TALL1;
 	if (common_trap)
-		vgic_v3->vgic_hcr |= ICH_HCR_TC;
+		vgic_v3->vgic_hcr |= ICH_HCR_EL2_TC;
 	if (dir_trap)
-		vgic_v3->vgic_hcr |= ICH_HCR_TDIR;
+		vgic_v3->vgic_hcr |= ICH_HCR_EL2_TDIR;
 }
 
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b081b54d6d227..9938926421b5c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2938,6 +2938,28 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
 
+Sysreg	ICH_HCR_EL2	3	4	12	11	0
+Res0	63:32
+Field	31:27	EOIcount
+Res0	26:16
+Field	15	DVIM
+Field	14	TDIR
+Field	13	TSEI
+Field	12	TALL1
+Field	11	TALL0
+Field	10	TC
+Res0	9
+Field	8	vSGIEOICount
+Field	7	VGrp1DIE
+Field	6	VGrp1EIE
+Field	5	VGrp0DIE
+Field	4	VGrp0EIE
+Field	3	NPIE
+Field	2	LRENPIE
+Field	1	UIE
+Field	0	En
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index da5250f0155cf..7a5cc26529f82 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -409,15 +409,15 @@ static void __exception_irq_entry aic_handle_irq(struct pt_regs *regs)
 	 * in use, and be cleared when coming back from the handler.
 	 */
 	if (is_kernel_in_hyp_mode() &&
-	    (read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EN) &&
+	    (read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EL2_En) &&
 	    read_sysreg_s(SYS_ICH_MISR_EL2) != 0) {
 		generic_handle_domain_irq(aic_irqc->hw_domain,
 					  AIC_FIQ_HWIRQ(AIC_VGIC_MI));
 
-		if (unlikely((read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EN) &&
+		if (unlikely((read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EL2_En) &&
 			     read_sysreg_s(SYS_ICH_MISR_EL2))) {
 			pr_err_ratelimited("vGIC IRQ fired and not handled by KVM, disabling.\n");
-			sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EN, 0);
+			sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EL2_En, 0);
 		}
 	}
 }
@@ -840,7 +840,7 @@ static int aic_init_cpu(unsigned int cpu)
 				   VM_TMR_FIQ_ENABLE_V | VM_TMR_FIQ_ENABLE_P, 0);
 
 		/* vGIC maintenance IRQ */
-		sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EN, 0);
+		sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EL2_En, 0);
 	}
 
 	/* PMC FIQ */
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index cd8420e8c3ad8..d314ccab7560a 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -420,7 +420,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
 #define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
 #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
@@ -654,17 +653,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
 
-/* ICH_HCR_EL2 bit definitions */
-#define ICH_HCR_EN		(1 << 0)
-#define ICH_HCR_UIE		(1 << 1)
-#define ICH_HCR_NPIE		(1 << 3)
-#define ICH_HCR_TC		(1 << 10)
-#define ICH_HCR_TALL0		(1 << 11)
-#define ICH_HCR_TALL1		(1 << 12)
-#define ICH_HCR_TDIR		(1 << 14)
-#define ICH_HCR_EOIcount_SHIFT	27
-#define ICH_HCR_EOIcount_MASK	(0x1f << ICH_HCR_EOIcount_SHIFT)
-
 /* ICH_VMCR_EL2 bit definitions */
 #define ICH_VMCR_ACK_CTL_SHIFT	2
 #define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-- 
2.39.2


