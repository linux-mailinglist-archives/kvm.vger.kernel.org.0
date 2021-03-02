Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB14E32A709
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379927AbhCBP63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:58:29 -0500
Received: from foss.arm.com ([217.140.110.172]:48810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380072AbhCBK2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 05:28:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D5931042;
        Tue,  2 Mar 2021 02:27:50 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECB993F73C;
        Tue,  2 Mar 2021 02:27:49 -0800 (PST)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/1] irqchip/gic-v4.1: Disable vSGI upon (GIC CPUIF < v4.1) detection
Date:   Tue,  2 Mar 2021 10:27:44 +0000
Message-Id: <20210302102744.12692-2-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
References: <0201111162841.3151-1-lorenzo.pieralisi@arm.com>
 <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GIC CPU interfaces versions predating GIC v4.1 were not built to
accommodate vINTID within the vSGI range; as reported in the GIC
specifications (8.2 "Changes to the CPU interface"), it is
CONSTRAINED UNPREDICTABLE to deliver a vSGI to a PE with
ID_AA64PFR0_EL1.GIC < b0011.

Check the GIC CPUIF version by reading the SYS_ID_AA64_PFR0_EL1.

Disable vSGIs if a CPUIF version < 4.1 is detected to prevent using
vSGIs on systems where they may misbehave.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c     |  4 ++--
 arch/arm64/kvm/vgic/vgic-v3.c          |  3 ++-
 drivers/irqchip/irq-gic-v3-its.c       |  6 +++++-
 drivers/irqchip/irq-gic-v3.c           | 22 ++++++++++++++++++++++
 include/kvm/arm_vgic.h                 |  1 +
 include/linux/irqchip/arm-gic-common.h |  2 ++
 include/linux/irqchip/arm-gic-v3.h     |  1 +
 7 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 15a6c98ee92f..66548cd2a715 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -86,7 +86,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case GICD_TYPER2:
-		if (kvm_vgic_global_state.has_gicv4_1)
+		if (kvm_vgic_global_state.has_gicv4_1_vsgi)
 			value = GICD_TYPER2_nASSGIcap;
 		break;
 	case GICD_IIDR:
@@ -119,7 +119,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1)
+		if (!kvm_vgic_global_state.has_gicv4_1_vsgi)
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 52915b342351..57b73100e8cc 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -533,7 +533,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		return ret;
 	}
 
-	if (kvm_vgic_global_state.has_gicv4_1)
+	if (kvm_vgic_global_state.has_gicv4_1_vsgi)
 		vgic_v4_configure_vsgis(kvm);
 
 	return 0;
@@ -589,6 +589,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (info->has_v4) {
 		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
 		kvm_vgic_global_state.has_gicv4_1 = info->has_v4_1 && gicv4_enable;
+		kvm_vgic_global_state.has_gicv4_1_vsgi = info->has_v4_1_vsgi && gicv4_enable;
 		kvm_info("GICv4%s support %sabled\n",
 			 kvm_vgic_global_state.has_gicv4_1 ? ".1" : "",
 			 gicv4_enable ? "en" : "dis");
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ed46e6057e33..ee2a2ca27d5c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5412,7 +5412,11 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	if (has_v4 & rdists->has_vlpis) {
 		const struct irq_domain_ops *sgi_ops;
 
-		if (has_v4_1)
+		/*
+		 * Enable vSGIs only if the ITS and the
+		 * GIC CPUIF support them.
+		 */
+		if (has_v4_1 && rdists->has_vsgi_cpuif)
 			sgi_ops = &its_sgi_domain_ops;
 		else
 			sgi_ops = NULL;
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index eb0ee356a629..fd6cd9a5de34 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -31,6 +31,21 @@
 
 #include "irq-gic-common.h"
 
+#ifdef CONFIG_ARM64
+#include <asm/cpufeature.h>
+
+static inline bool gic_cpuif_has_vsgi(void)
+{
+	unsigned long fld, reg = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	fld = cpuid_feature_extract_unsigned_field(reg, ID_AA64PFR0_GIC_SHIFT);
+
+	return fld >= 0x3;
+}
+#else
+static inline bool gic_cpuif_has_vsgi(void) { return false; }
+#endif
+
 #define GICD_INT_NMI_PRI	(GICD_INT_DEF_PRI & ~0x80)
 
 #define FLAGS_WORKAROUND_GICR_WAKER_MSM8996	(1ULL << 0)
@@ -1679,6 +1694,8 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	gic_data.rdists.has_direct_lpi = true;
 	gic_data.rdists.has_vpend_valid_dirty = true;
 
+	gic_data.rdists.has_vsgi_cpuif = gic_cpuif_has_vsgi();
+
 	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdists.rdist)) {
 		err = -ENOMEM;
 		goto out_free;
@@ -1852,6 +1869,9 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 
 	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
+	gic_v3_kvm_info.has_v4_1_vsgi = gic_data.rdists.has_vsgi_cpuif &&
+					gic_data.rdists.has_rvpeid;
+
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
@@ -2168,6 +2188,8 @@ static void __init gic_acpi_setup_kvm_info(void)
 
 	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
+	gic_v3_kvm_info.has_v4_1_vsgi = gic_data.rdists.has_vsgi_cpuif &&
+					gic_data.rdists.has_rvpeid;
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3d74f1060bd1..614f11113298 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -71,6 +71,7 @@ struct vgic_global {
 	/* Hardware has GICv4? */
 	bool			has_gicv4;
 	bool			has_gicv4_1;
+	bool			has_gicv4_1_vsgi;
 
 	/* GIC system register CPU interface */
 	struct static_key_false gicv3_cpuif;
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index fa8c0455c352..c2efd1dd1790 100644
--- a/include/linux/irqchip/arm-gic-common.h
+++ b/include/linux/irqchip/arm-gic-common.h
@@ -34,6 +34,8 @@ struct gic_kvm_info {
 	bool		has_v4;
 	/* rvpeid support */
 	bool		has_v4_1;
+	/* vsgi support */
+	bool		has_v4_1_vsgi;
 };
 
 const struct gic_kvm_info *gic_get_kvm_info(void);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index f6d092fdb93d..5f00ce2535bf 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -683,6 +683,7 @@ struct rdists {
 	bool			has_vlpis;
 	bool			has_rvpeid;
 	bool			has_direct_lpi;
+	bool			has_vsgi_cpuif;
 	bool			has_vpend_valid_dirty;
 };
 
-- 
2.29.1

