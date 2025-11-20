Return-Path: <kvm+bounces-63954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A2BC75BCF
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EC5044E1BE8
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B4A3A9C0B;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipV8jXre"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0B73A8D5D;
	Thu, 20 Nov 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659565; cv=none; b=Kl63snoAwjOgwwVZKlNL3DxL8dDGYFuGiX+vRO6f0VX240G/W/KFaUODOup/DcRd429ngrduqv832X+9Zft53Po7YAl/cyQQ46vW03ZJfjOAAchOOSKm1S6PibARBjKesJa7e2juwHnaKl8/QQD9529hGjOTau/Gr7+qoClaJk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659565; c=relaxed/simple;
	bh=LxxRuWptOaynGSGXS0bG7RwUA5sN3+WRpy3Bgjezjn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsOcpPeBoPJpEAku6LRhufVUJVkH4z0ljEbL+g+ZkdXmVfMVQfJZ46hlrJMUjLkod+j+KYjFcfZ3hOaAB658vG4qAtTYSDz8z6nrc+rGdzNDl6kb4ryKuBD4EfDHnsfsJQsODD6LoHRQCSfrSR/lcjvGn3Y1mX2NTIa93WpgDLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipV8jXre; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47DAC19422;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659565;
	bh=LxxRuWptOaynGSGXS0bG7RwUA5sN3+WRpy3Bgjezjn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipV8jXrecAGcB1nI36Ut6qC2Q5mk7yGccBRGzaP1gYnbA/KSwjZ/L2yTkrcqvmOAj
	 ofrQLHquR0kkrYCixiyl4D9M1/s9OB2TLjOTeg07DDMRkvbRf72hedtXS6Lp4vHMq9
	 Lr/5a4Vhw2iCANRzdtkO+wK+m/olyn/FKYwvmF+zTn6BF6BpdPd1s5KiUtJjhMqk0/
	 LDCOkGExgukOqrLFfbfH7TTwEJuF5xfhk+Gjwgj/uym9Me+fpmdVZa53VxznyCE/hI
	 3In+a73USSsz+lj5wOFLcVgYem3RNEc+c4JG1zWmE2d7uN+yfGAEPGtk6lfouBRpC2
	 S8Dz5r35XtvvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pz-00000006y6g-0lel;
	Thu, 20 Nov 2025 17:26:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 38/49] KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
Date: Thu, 20 Nov 2025 17:25:28 +0000
Message-ID: <20251120172540.2267180-39-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the plumbing of GICv2 interrupt deactivation via GICV_DIR.
This requires adding a new device so that we can easily decode
the DIR address.

The deactivation itself is very similar to the GICv3 version.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 24 +++++++++
 arch/arm64/kvm/vgic/vgic-mmio.h    |  1 +
 arch/arm64/kvm/vgic/vgic-v2.c      | 85 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/kvm/arm_vgic.h             |  1 +
 5 files changed, 112 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index f25fccb1f8e63..406845b3117cf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -359,6 +359,16 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	vgic_set_vmcr(vcpu, &vmcr);
 }
 
+static void vgic_mmio_write_dir(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_deactivate(vcpu, val);
+	else
+		vgic_v3_deactivate(vcpu, val);
+}
+
 static unsigned long vgic_mmio_read_apr(struct kvm_vcpu *vcpu,
 					gpa_t addr, unsigned int len)
 {
@@ -482,6 +492,10 @@ static const struct vgic_register_region vgic_v2_cpu_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GIC_CPU_DEACTIVATE,
+		vgic_mmio_read_raz, vgic_mmio_write_dir,
+		vgic_mmio_read_raz, vgic_mmio_uaccess_write_wi,
+		4, VGIC_ACCESS_32bit),
 };
 
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
@@ -494,6 +508,16 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 	return SZ_4K;
 }
 
+unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_device *dev)
+{
+	dev->regions = vgic_v2_cpu_registers;
+	dev->nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	return KVM_VGIC_V2_CPU_SIZE;
+}
+
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 {
 	const struct vgic_register_region *region;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 5b490a4dfa5e9..50dc80220b0f3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -213,6 +213,7 @@ void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
 				    const u32 val);
 
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
+unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
 
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index bbd4d003fde86..bc52d44a573d5 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -9,6 +9,7 @@
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_mmu.h>
 
+#include "vgic-mmio.h"
 #include "vgic.h"
 
 static inline void vgic_v2_write_lr(int lr, u32 val)
@@ -147,6 +148,79 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	cpuif->used_lrs = 0;
 }
 
+void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
+	struct kvm_vcpu *target_vcpu = NULL;
+	bool mmio = false;
+	struct vgic_irq *irq;
+	unsigned long flags;
+	u64 lr = 0;
+	u8 cpuid;
+
+	/* Snapshot CPUID, and remove it from the INTID */
+	cpuid = FIELD_GET(GENMASK_ULL(12, 10), val);
+	val &= ~GENMASK_ULL(12, 10);
+
+	/* We only deal with DIR when EOIMode==1 */
+	if (!(cpuif->vgic_vmcr & GICH_VMCR_EOI_MODE_MASK))
+		return;
+
+	/* Make sure we're in the same context as LR handling */
+	local_irq_save(flags);
+
+	irq = vgic_get_vcpu_irq(vcpu, val);
+	if (WARN_ON_ONCE(!irq))
+		goto out;
+
+	/* See the corresponding v3 code for the rationale */
+	scoped_guard(raw_spinlock, &irq->irq_lock) {
+		target_vcpu = irq->vcpu;
+
+		/* Not on any ap_list? */
+		if (!target_vcpu)
+			goto put;
+
+		/*
+		 * Urgh. We're deactivating something that we cannot
+		 * observe yet... Big hammer time.
+		 */
+		if (irq->on_lr) {
+			mmio = true;
+			goto put;
+		}
+
+		/* SGI: check that the cpuid matches */
+		if (val < VGIC_NR_SGIS && irq->active_source != cpuid) {
+			target_vcpu = NULL;
+			goto put;
+		}
+
+		/* (with a Dalek voice) DEACTIVATE!!!! */
+		lr = vgic_v2_compute_lr(vcpu, irq) & ~GICH_LR_ACTIVE_BIT;
+	}
+
+	if (lr & GICH_LR_HW)
+		writel_relaxed(FIELD_GET(GICH_LR_PHYSID_CPUID, lr),
+			       kvm_vgic_global_state.gicc_base + GIC_CPU_DEACTIVATE);
+
+	vgic_v2_fold_lr(vcpu, lr);
+
+put:
+	vgic_put_irq(vcpu->kvm, irq);
+
+out:
+	local_irq_restore(flags);
+
+	if (mmio)
+		vgic_mmio_write_cactive(vcpu, (val / 32) * 4, 4, BIT(val % 32));
+
+	/* Force the ap_list to be pruned */
+	if (target_vcpu)
+		kvm_make_request(KVM_REQ_VGIC_PROCESS_UPDATE, target_vcpu);
+}
+
 static u32 vgic_v2_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	u32 val = irq->intid;
@@ -346,6 +420,7 @@ static bool vgic_v2_check_base(gpa_t dist_base, gpa_t cpu_base)
 int vgic_v2_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned int len;
 	int ret = 0;
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
@@ -369,6 +444,16 @@ int vgic_v2_map_resources(struct kvm *kvm)
 		return ret;
 	}
 
+	len = vgic_v2_init_cpuif_iodev(&dist->cpuif_iodev);
+	dist->cpuif_iodev.base_addr = dist->vgic_cpu_base;
+	dist->cpuif_iodev.iodev_type = IODEV_CPUIF;
+	dist->cpuif_iodev.redist_vcpu = NULL;
+
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, dist->vgic_cpu_base,
+				      len, &dist->cpuif_iodev.dev);
+	if (ret)
+		return ret;
+
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e93bdb485f070..5f0fc96b4dc29 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -277,6 +277,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
+void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu, struct ap_list_summary *als);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6a4d3d2055966..b261fb3968d03 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -287,6 +287,7 @@ struct vgic_dist {
 	struct vgic_irq		*spis;
 
 	struct vgic_io_device	dist_iodev;
+	struct vgic_io_device	cpuif_iodev;
 
 	bool			has_its;
 	bool			table_write_in_progress;
-- 
2.47.3


