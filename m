Return-Path: <kvm+bounces-39150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC908A4488A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D81B16BAEA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335FB215770;
	Tue, 25 Feb 2025 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArRHrcIu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEE820D513;
	Tue, 25 Feb 2025 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504587; cv=none; b=I/3A7iB4yIxdrXxyLFHf0NVUbxKwPqMUUEYKiAht+1FWueHKcOmnVQ14sJp+w4hSAcUBiuWpuF/4te45mdFJZ6hIHrs4OrFdzviNlc50UR7pTcygcQ9IN71Ir/OytJ44+5v9Vrb8rlDpYD18g5RAVbCTmjKvUnKHq943OzSnd18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504587; c=relaxed/simple;
	bh=9CjdniUMCErzrsUtghZUxDDK7vywe6Gk03WGF/J/BjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dTWOqfSKJhiI0rnOBCwt+gL4gcp8j1IiiX6YOXB3Kbej0z+ywqW4pXeUQu8FxR71TVVYyyCf5P04DHxU4izJv/Rj43dRIIp/oRKcnaGDjxijYOIxu7BCLwP68QLxcwwJnCF83KX3S0PVd6qUHYj5snp3FFOxcSKurgc8VMeeXco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArRHrcIu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA574C4CEEA;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504586;
	bh=9CjdniUMCErzrsUtghZUxDDK7vywe6Gk03WGF/J/BjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArRHrcIuh6Y8kX37HXIE2dxHq94cbU9hSJLhLHUtR9zJpXhbhyzjy//w2xR0BsH2s
	 iyM5w7kyvA9SCCu8ABETGjdRkFF9sjMOjxwsRul5K9aI3KlrxGV/mON0j7TOrpra7u
	 GjnU8B27yyGAOlmiZrtzjvbD0EyXrbGyWHgthY7uqNdh/2PDE05xXXRx+T/jW/aHwp
	 Sw6AKU68Jzb3t/dgnCLhK3p29p8dIpfj9ZRrClTEqC+aukJK+uY8AWWLqQncg1zU3g
	 QpXzpocyCVcD5jP1PQdpAeVusZDfviooo8Z01faOyqVasO8y49o4/t4kqVvj5PV49O
	 N/+EeRaPz0PFQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tmyka-007rKs-T3;
	Tue, 25 Feb 2025 17:29:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 06/16] KVM: arm64: nv: Plumb handling of GICv3 EL2 accesses
Date: Tue, 25 Feb 2025 17:29:20 +0000
Message-Id: <20250225172930.1850838-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Wire the handling of all GICv3 EL2 registers, and provide emulation
for all the non memory-backed registers (ICC_SRE_EL2, ICH_VTR_EL2,
ICH_MISR_EL2, ICH_ELRSR_EL2, and ICH_EISR_EL2).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/sys_regs.c            |  95 +++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 125 +++++++++++++++++++++++++++
 include/kvm/arm_vgic.h               |   4 +
 4 files changed, 224 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b5038..209bc76263f10 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd02..84248fabd418c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/uaccess.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cacheflush.h>
@@ -531,7 +532,13 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	if (p->Op1 == 4) {	/* ICC_SRE_EL2 */
+		p->regval = (ICC_SRE_EL2_ENABLE | ICC_SRE_EL2_SRE |
+			     ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB);
+	} else {		/* ICC_SRE_EL1 */
+		p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	}
+
 	return true;
 }
 
@@ -2426,6 +2433,59 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
 	vq = min(vq, vcpu_sve_max_vq(vcpu));
 	vcpu_write_sys_reg(vcpu, vq - 1, ZCR_EL2);
+
+	return true;
+}
+
+static bool access_gic_vtr(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = kvm_vgic_global_state.ich_vtr_el2;
+	p->regval &= ~(ICH_VTR_EL2_DVIM 	|
+		       ICH_VTR_EL2_A3V		|
+		       ICH_VTR_EL2_IDbits);
+	p->regval |= ICH_VTR_EL2_nV4;
+
+	return true;
+}
+
+static bool access_gic_misr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_misr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_eisr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_eisr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_elrsr(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_elrsr(vcpu);
+
 	return true;
 }
 
@@ -3102,7 +3162,40 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), undef_access },
 
+	EL2_REG_VNCR(ICH_AP0R0_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP0R1_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP0R2_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP0R3_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R0_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R1_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R2_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R3_EL2, reset_val, 0),
+
+	{ SYS_DESC(SYS_ICC_SRE_EL2), access_gic_sre },
+
 	EL2_REG_VNCR(ICH_HCR_EL2, reset_val, 0),
+	{ SYS_DESC(SYS_ICH_VTR_EL2), access_gic_vtr },
+	{ SYS_DESC(SYS_ICH_MISR_EL2), access_gic_misr },
+	{ SYS_DESC(SYS_ICH_EISR_EL2), access_gic_eisr },
+	{ SYS_DESC(SYS_ICH_ELRSR_EL2), access_gic_elrsr },
+	EL2_REG_VNCR(ICH_VMCR_EL2, reset_val, 0),
+
+	EL2_REG_VNCR(ICH_LR0_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR1_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR2_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR3_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR4_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR5_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR6_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR7_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR8_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR9_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR10_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR11_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR12_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR13_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR14_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR15_EL2, reset_val, 0),
 
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
new file mode 100644
index 0000000000000..48bfd2f556a36
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <kvm/arm_vgic.h>
+
+#include <asm/kvm_arm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
+
+#include "vgic.h"
+
+#define ICH_LRN(n)	(ICH_LR0_EL2 + (n))
+
+struct mi_state {
+	u16	eisr;
+	u16	elrsr;
+	bool	pend;
+};
+
+/*
+ * Nesting GICv3 support
+ *
+ * System register emulation:
+ *
+ * We get two classes of registers:
+ *
+ * - those backed by memory (LRs, APRs, HCR, VMCR): L1 can freely access
+ *   them, and L0 doesn't see a thing.
+ *
+ * - those that always trap (ELRSR, EISR, MISR): these are status registers
+ *   that are built on the fly based on the in-memory state.
+ *
+ * Only L1 can access the ICH_*_EL2 registers. A non-NV L2 obviously cannot,
+ * and a NV L2 would either access the VNCR page provided by L1 (memory
+ * based registers), or see the access redirected to L1 (registers that
+ * trap) thanks to NV being set by L1.
+ */
+
+static bool lr_triggers_eoi(u64 lr)
+{
+	return !(lr & (ICH_LR_STATE | ICH_LR_HW)) && (lr & ICH_LR_EOI);
+}
+
+static void vgic_compute_mi_state(struct kvm_vcpu *vcpu, struct mi_state *mi_state)
+{
+	u16 eisr = 0, elrsr = 0;
+	bool pend = false;
+
+	for (int i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+
+		if (lr_triggers_eoi(lr))
+			eisr |= BIT(i);
+		if (!(lr & ICH_LR_STATE))
+			elrsr |= BIT(i);
+		pend |= (lr & ICH_LR_PENDING_BIT);
+	}
+
+	mi_state->eisr	= eisr;
+	mi_state->elrsr	= elrsr;
+	mi_state->pend	= pend;
+}
+
+u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
+{
+	struct mi_state mi_state;
+
+	vgic_compute_mi_state(vcpu, &mi_state);
+	return mi_state.eisr;
+}
+
+u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
+{
+	struct mi_state mi_state;
+
+	vgic_compute_mi_state(vcpu, &mi_state);
+	return mi_state.elrsr;
+}
+
+u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
+{
+	struct mi_state mi_state;
+	u64 reg = 0, hcr, vmcr;
+
+	hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
+
+	vgic_compute_mi_state(vcpu, &mi_state);
+
+	if (mi_state.eisr)
+		reg |= ICH_MISR_EL2_EOI;
+
+	if (__vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EL2_UIE) {
+		int used_lrs = kvm_vgic_global_state.nr_lr;
+
+		used_lrs -= hweight16(mi_state.elrsr);
+		reg |= (used_lrs <= 1) ? ICH_MISR_EL2_U : 0;
+	}
+
+	if ((hcr & ICH_HCR_EL2_LRENPIE) && FIELD_GET(ICH_HCR_EL2_EOIcount_MASK, hcr))
+		reg |= ICH_MISR_EL2_LRENP;
+
+	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
+		reg |= ICH_MISR_EL2_NP;
+
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+		reg |= ICH_MISR_EL2_VGrp0E;
+
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		reg |= ICH_MISR_EL2_VGrp0D;
+
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+		reg |= ICH_MISR_EL2_VGrp1E;
+
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		reg |= ICH_MISR_EL2_VGrp1D;
+
+	return reg;
+}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3a8ccfda34d29..5017fcc71e604 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -389,6 +389,10 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 
+u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu);
+u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu);
+u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
-- 
2.39.2


