Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA18733DB4F
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbhCPRrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239218AbhCPRql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:46:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 269FD6511D;
        Tue, 16 Mar 2021 17:46:41 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmB-0021ao-C8; Tue, 16 Mar 2021 17:46:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 01/11] irqchip/gic: Split vGIC probing information from the GIC code
Date:   Tue, 16 Mar 2021 17:46:06 +0000
Message-Id: <20210316174617.173033-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316174617.173033-1-maz@kernel.org>
References: <20210316174617.173033-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vGIC advertising code is unsurprisingly very much tied to
the GIC implementations. However, we are about to extend the
support to lesser implementations.

Let's dissociate the vgic registration from the GIC code and
move it into KVM, where it makes a bit more sense. This also
allows us to mark the gic_kvm_info structures as __initdata.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c        | 17 +++++++++--
 drivers/irqchip/irq-gic-common.c       | 13 --------
 drivers/irqchip/irq-gic-common.h       |  2 --
 drivers/irqchip/irq-gic-v3.c           |  6 ++--
 drivers/irqchip/irq-gic.c              |  6 ++--
 include/linux/irqchip/arm-gic-common.h | 25 +---------------
 include/linux/irqchip/arm-vgic-info.h  | 41 ++++++++++++++++++++++++++
 7 files changed, 62 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/irqchip/arm-vgic-info.h

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 052917deb149..9b491263f5f7 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -480,6 +480,15 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static struct gic_kvm_info *gic_kvm_info;
+
+void __init vgic_set_kvm_info(const struct gic_kvm_info *info)
+{
+	BUG_ON(gic_kvm_info != NULL);
+	gic_kvm_info = kmalloc(sizeof(*info), GFP_KERNEL);
+	*gic_kvm_info = *info;
+}
+
 /**
  * kvm_vgic_init_cpu_hardware - initialize the GIC VE hardware
  *
@@ -507,10 +516,8 @@ void kvm_vgic_init_cpu_hardware(void)
  */
 int kvm_vgic_hyp_init(void)
 {
-	const struct gic_kvm_info *gic_kvm_info;
 	int ret;
 
-	gic_kvm_info = gic_get_kvm_info();
 	if (!gic_kvm_info)
 		return -ENODEV;
 
@@ -534,10 +541,14 @@ int kvm_vgic_hyp_init(void)
 		ret = -ENODEV;
 	}
 
+	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
+
+	kfree(gic_kvm_info);
+	gic_kvm_info = NULL;
+
 	if (ret)
 		return ret;
 
-	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
 				 vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
index f47b41dfd023..a610821c8ff2 100644
--- a/drivers/irqchip/irq-gic-common.c
+++ b/drivers/irqchip/irq-gic-common.c
@@ -12,19 +12,6 @@
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
-static const struct gic_kvm_info *gic_kvm_info;
-
-const struct gic_kvm_info *gic_get_kvm_info(void)
-{
-	return gic_kvm_info;
-}
-
-void gic_set_kvm_info(const struct gic_kvm_info *info)
-{
-	BUG_ON(gic_kvm_info != NULL);
-	gic_kvm_info = info;
-}
-
 void gic_enable_of_quirks(const struct device_node *np,
 			  const struct gic_quirk *quirks, void *data)
 {
diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
index ccba8b0fe0f5..27e3d4ed4f32 100644
--- a/drivers/irqchip/irq-gic-common.h
+++ b/drivers/irqchip/irq-gic-common.h
@@ -28,6 +28,4 @@ void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
 void gic_enable_of_quirks(const struct device_node *np,
 			  const struct gic_quirk *quirks, void *data);
 
-void gic_set_kvm_info(const struct gic_kvm_info *info);
-
 #endif /* _IRQ_GIC_COMMON_H */
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index eb0ee356a629..3bd0f25a342f 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -103,7 +103,7 @@ EXPORT_SYMBOL(gic_nonsecure_priorities);
 /* ppi_nmi_refs[n] == number of cpus having ppi[n + 16] set as NMI */
 static refcount_t *ppi_nmi_refs;
 
-static struct gic_kvm_info gic_v3_kvm_info;
+static struct gic_kvm_info gic_v3_kvm_info __initdata;
 static DEFINE_PER_CPU(bool, has_rss);
 
 #define MPIDR_RS(mpidr)			(((mpidr) & 0xF0UL) >> 4)
@@ -1852,7 +1852,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 
 	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
-	gic_set_kvm_info(&gic_v3_kvm_info);
+	vgic_set_kvm_info(&gic_v3_kvm_info);
 }
 
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
@@ -2168,7 +2168,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 
 	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
-	gic_set_kvm_info(&gic_v3_kvm_info);
+	vgic_set_kvm_info(&gic_v3_kvm_info);
 }
 
 static int __init
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index b1d9c22caf2e..2de9ec8ece0c 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -119,7 +119,7 @@ static DEFINE_STATIC_KEY_TRUE(supports_deactivate_key);
 
 static struct gic_chip_data gic_data[CONFIG_ARM_GIC_MAX_NR] __read_mostly;
 
-static struct gic_kvm_info gic_v2_kvm_info;
+static struct gic_kvm_info gic_v2_kvm_info __initdata;
 
 static DEFINE_PER_CPU(u32, sgi_intid);
 
@@ -1451,7 +1451,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 		return;
 
 	if (static_branch_likely(&supports_deactivate_key))
-		gic_set_kvm_info(&gic_v2_kvm_info);
+		vgic_set_kvm_info(&gic_v2_kvm_info);
 }
 
 int __init
@@ -1618,7 +1618,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 
 	gic_v2_kvm_info.maint_irq = irq;
 
-	gic_set_kvm_info(&gic_v2_kvm_info);
+	vgic_set_kvm_info(&gic_v2_kvm_info);
 }
 
 static int __init gic_v2_acpi_init(union acpi_subtable_headers *header,
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index fa8c0455c352..1177f3a1aed5 100644
--- a/include/linux/irqchip/arm-gic-common.h
+++ b/include/linux/irqchip/arm-gic-common.h
@@ -7,8 +7,7 @@
 #ifndef __LINUX_IRQCHIP_ARM_GIC_COMMON_H
 #define __LINUX_IRQCHIP_ARM_GIC_COMMON_H
 
-#include <linux/types.h>
-#include <linux/ioport.h>
+#include <linux/irqchip/arm-vgic-info.h>
 
 #define GICD_INT_DEF_PRI		0xa0
 #define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
@@ -16,28 +15,6 @@
 					(GICD_INT_DEF_PRI << 8) |\
 					GICD_INT_DEF_PRI)
 
-enum gic_type {
-	GIC_V2,
-	GIC_V3,
-};
-
-struct gic_kvm_info {
-	/* GIC type */
-	enum gic_type	type;
-	/* Virtual CPU interface */
-	struct resource vcpu;
-	/* Interrupt number */
-	unsigned int	maint_irq;
-	/* Virtual control interface */
-	struct resource vctrl;
-	/* vlpi support */
-	bool		has_v4;
-	/* rvpeid support */
-	bool		has_v4_1;
-};
-
-const struct gic_kvm_info *gic_get_kvm_info(void);
-
 struct irq_domain;
 struct fwnode_handle;
 int gicv2m_init(struct fwnode_handle *parent_handle,
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
new file mode 100644
index 000000000000..0319636be928
--- /dev/null
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * include/linux/irqchip/arm-vgic-info.h
+ *
+ * Copyright (C) 2016 ARM Limited, All Rights Reserved.
+ */
+#ifndef __ARM_VGIC_INFO_H
+#define __ARM_VGIC_INFO_H
+
+#include <linux/types.h>
+#include <linux/ioport.h>
+
+enum gic_type {
+	/* Full GICv2 */
+	GIC_V2,
+	/* Full GICv3, optionally with v2 compat */
+	GIC_V3,
+};
+
+struct gic_kvm_info {
+	/* GIC type */
+	enum gic_type	type;
+	/* Virtual CPU interface */
+	struct resource vcpu;
+	/* Interrupt number */
+	unsigned int	maint_irq;
+	/* Virtual control interface */
+	struct resource vctrl;
+	/* vlpi support */
+	bool		has_v4;
+	/* rvpeid support */
+	bool		has_v4_1;
+};
+
+#ifdef CONFIG_KVM
+void vgic_set_kvm_info(const struct gic_kvm_info *info);
+#else
+static inline void vgic_set_kvm_info(const struct gic_kvm_info *info) {}
+#endif
+
+#endif
-- 
2.29.2

