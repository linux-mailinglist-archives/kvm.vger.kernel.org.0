Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4099025C551
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgICP0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbgICP00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C381208CA;
        Thu,  3 Sep 2020 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146784;
        bh=UgL5h2/N4AaKwcBf0Fqm/Wf8W19Iwr6g3G+3eOn1h1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0WuPxRxlpht9j/tIBc1SKbf8RKtMZHQw3Az5TvPyVABskke0c/zO1wH1YgL1iJMx
         zMZKSzDYidYwGi8a1waBkriX5j2NFn2CwqGMlDu/4HAoFoKkTtJ8umKbOTUob3QT1D
         edzUoeTYFy9aR9nicWWU/dYsCeLy8wGL22vB+Fv8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr82-008vT9-No; Thu, 03 Sep 2020 16:26:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 03/23] irqchip: Add Reduced Virtual Interrupt Distributor support
Date:   Thu,  3 Sep 2020 16:25:50 +0100
Message-Id: <20200903152610.1078827-4-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/Kconfig          |   6 +
 drivers/irqchip/Makefile         |   1 +
 drivers/irqchip/irq-rvid.c       | 259 +++++++++++++++++++++++++++++++
 include/linux/irqchip/irq-rvic.h |  19 +++
 4 files changed, 285 insertions(+)
 create mode 100644 drivers/irqchip/irq-rvid.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 348ff1d06651..731e8da9ae0c 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -67,6 +67,12 @@ config ARM_RVIC
 	select IRQ_DOMAIN_HIERARCHY
 	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
 
+config ARM_RVID
+	bool
+	default ARM64
+	select IRQ_DOMAIN_HIERARCHY
+	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
+
 config ARM_VIC
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index d2b280efd2e0..cbcc23f92d31 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_PARTITION_PERCPU)		+= irq-partition-percpu.o
 obj-$(CONFIG_HISILICON_IRQ_MBIGEN)	+= irq-mbigen.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_RVIC)			+= irq-rvic.o
+obj-$(CONFIG_ARM_RVID)			+= irq-rvid.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_ARMADA_370_XP_IRQ)		+= irq-armada-370-xp.o
 obj-$(CONFIG_ATMEL_AIC_IRQ)		+= irq-atmel-aic-common.o irq-atmel-aic.o
diff --git a/drivers/irqchip/irq-rvid.c b/drivers/irqchip/irq-rvid.c
new file mode 100644
index 000000000000..953f654e58d4
--- /dev/null
+++ b/drivers/irqchip/irq-rvid.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2020 Google LLC.
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#define pr_fmt(fmt)	"rVID: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/cpuhotplug.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqchip.h>
+#include <linux/irqdomain.h>
+
+#include <linux/irqchip/irq-rvic.h>
+
+struct rvid_data {
+	struct fwnode_handle	*fwnode;
+	struct irq_domain	*domain;
+};
+
+static struct rvid_data rvid;
+
+static inline int rvid_version(unsigned long *version)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC64_RVID_VERSION, &res);
+	if (res.a0 == RVID_STATUS_SUCCESS)
+		*version = res.a1;
+	return res.a0;
+}
+
+static inline int rvid_map(unsigned long input,
+			   unsigned long target, unsigned long intid)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC64_RVID_MAP, input, target, intid, &res);
+	return res.a0;
+}
+
+static inline int rvid_unmap(unsigned long input)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC64_RVID_UNMAP, input, &res);
+	return res.a0;
+}
+
+static int rvid_irq_set_affinity(struct irq_data *data,
+				 const struct cpumask *mask_val,
+				 bool force)
+{
+	unsigned int old_cpu, cpu;
+	bool masked, pending;
+	int err = 0, ret;
+	u64 mpidr;
+
+	if (force)
+		cpu = cpumask_first(mask_val);
+	else
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	mpidr = cpu_logical_map(cpu) & MPIDR_HWID_BITMASK;
+	old_cpu = cpumask_first(data->common->effective_affinity);
+	if (cpu == old_cpu)
+		return 0;
+
+	/* Mask on source */
+	masked = irqd_irq_masked(data);
+	if (!masked)
+		irq_chip_mask_parent(data);
+
+	/* Switch to target */
+	irq_data_update_effective_affinity(data, cpumask_of(cpu));
+
+	/* Mask on target */
+	irq_chip_mask_parent(data);
+
+	/* Map the input signal to the new target */
+	ret = rvid_map(data->hwirq, mpidr, data->parent_data->hwirq);
+	if (ret != RVID_STATUS_SUCCESS) {
+		err = -ENXIO;
+		goto unmask;
+	}
+
+	/* Back to the source */
+	irq_data_update_effective_affinity(data, cpumask_of(old_cpu));
+
+	/* Sample pending state and clear it if necessary */
+	err = irq_chip_get_parent_state(data, IRQCHIP_STATE_PENDING, &pending);
+	if (err)
+		goto unmask;
+	if (pending)
+		irq_chip_set_parent_state(data, IRQCHIP_STATE_PENDING, false);
+
+	/*
+	 * To the target again (for good this time), propagating the
+	 * pending bit if required.
+	 */
+	irq_data_update_effective_affinity(data, cpumask_of(cpu));
+	if (pending)
+		irq_chip_set_parent_state(data, IRQCHIP_STATE_PENDING, true);
+unmask:
+	/* Propagate the masking state */
+	if (!masked)
+		irq_chip_unmask_parent(data);
+
+	return err;
+}
+
+static struct irq_chip rvid_chip = {
+	.name			= "rvid",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_get_irqchip_state	= irq_chip_get_parent_state,
+	.irq_set_irqchip_state	= irq_chip_set_parent_state,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_type		= irq_chip_set_type_parent,
+	.irq_set_affinity	= rvid_irq_set_affinity,
+};
+
+static int rvid_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs, void *arg)
+{
+	struct irq_fwspec *fwspec = arg;
+	unsigned int type = IRQ_TYPE_NONE;
+	irq_hw_number_t hwirq;
+	int i, ret;
+
+	ret = irq_domain_translate_onecell(domain, fwspec, &hwirq, &type);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		unsigned int intid = hwirq + i;
+		unsigned int irq = virq + i;
+
+		/* Get the rVIC to allocate any untrusted intid */
+		ret = irq_domain_alloc_irqs_parent(domain, irq, 1, NULL);
+		if (WARN_ON(ret))
+			return ret;
+
+		irq_domain_set_hwirq_and_chip(domain, irq, intid,
+					      &rvid_chip, &rvid);
+		irqd_set_affinity_on_activate(irq_get_irq_data(irq));
+	}
+
+	return 0;
+}
+
+static void rvid_irq_domain_free(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs)
+{
+	int i;
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_data *d;
+
+		d = irq_domain_get_irq_data(domain, virq + i);
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+}
+
+static int rvid_irq_domain_activate(struct irq_domain *domain,
+				    struct irq_data *data, bool reserve)
+{
+	unsigned long ret;
+	int cpu, err = 0;
+	u64 mpidr;
+
+	cpu = get_cpu();
+	mpidr = cpu_logical_map(cpu) & MPIDR_HWID_BITMASK;
+
+	/* Map the input signal */
+	ret = rvid_map(data->hwirq, mpidr, data->parent_data->hwirq);
+	if (ret != RVID_STATUS_SUCCESS) {
+		err = -ENXIO;
+		goto out;
+	}
+
+	irq_data_update_effective_affinity(data, cpumask_of(cpu));
+
+out:
+	put_cpu();
+	return err;
+}
+
+static void rvid_irq_domain_deactivate(struct irq_domain *domain,
+				       struct irq_data *data)
+{
+	rvid_unmap(data->hwirq);
+}
+
+static const struct irq_domain_ops rvid_irq_domain_ops = {
+	.translate	= irq_domain_translate_onecell,
+	.alloc		= rvid_irq_domain_alloc,
+	.free		= rvid_irq_domain_free,
+	.activate	= rvid_irq_domain_activate,
+	.deactivate	= rvid_irq_domain_deactivate,
+};
+
+static int __init rvid_init(struct device_node *node,
+			    struct device_node *parent)
+{
+	struct irq_domain *parent_domain;
+	unsigned long ret, version;
+
+	if (arm_smccc_get_version() < ARM_SMCCC_VERSION_1_1) {
+		pr_err("SMCCC 1.1 required, aborting\n");
+		return -EINVAL;
+	}
+
+	if (!parent)
+		return -ENXIO;
+
+	parent_domain = irq_find_host(parent);
+	if (!parent_domain)
+		return -ENXIO;
+
+	rvid.fwnode = of_node_to_fwnode(node);
+
+	ret = rvid_version(&version);
+	if (ret != RVID_STATUS_SUCCESS) {
+		pr_err("error retrieving version (%ld, %ld)\n",
+		       RVID_STATUS_REASON(ret), RVID_STATUS_INDEX(ret));
+		return -ENXIO;
+	}
+
+	if (version < RVID_VERSION(0, 3)) {
+		pr_err("version (%ld, %ld) too old, expected min. (%d, %d)\n",
+		       RVID_VERSION_MAJOR(version), RVID_VERSION_MINOR(version),
+		       0, 3);
+		return -ENXIO;
+	}
+
+	pr_info("distributing interrupts to %pOF\n", parent);
+
+	rvid.domain = irq_domain_create_hierarchy(parent_domain, 0, 0,
+						  rvid.fwnode,
+						  &rvid_irq_domain_ops, &rvid);
+	if (!rvid.domain) {
+		pr_warn("Failed to allocate irq domain\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+IRQCHIP_DECLARE(rvic, "arm,rvid", rvid_init);
diff --git a/include/linux/irqchip/irq-rvic.h b/include/linux/irqchip/irq-rvic.h
index 0176ca7d3c30..4545c1e89741 100644
--- a/include/linux/irqchip/irq-rvic.h
+++ b/include/linux/irqchip/irq-rvic.h
@@ -74,4 +74,23 @@
 #define RVIC_STATUS_DISABLED		RVIx_STATUS_DISABLED
 #define RVIC_STATUS_NO_INTERRUPTS	RVIx_STATUS_NO_INTERRUPTS
 
+/* rVID functions */
+#define SMC64_RVID_BASE			0xc5000100
+#define SMC64_RVID_FN(n)		(SMC64_RVID_BASE + (n))
+
+#define SMC64_RVID_VERSION		SMC64_RVID_FN(0)
+#define SMC64_RVID_MAP			SMC64_RVID_FN(1)
+#define SMC64_RVID_UNMAP		SMC64_RVID_FN(2)
+
+#define RVID_VERSION(M, m)		RVIx_VERSION((M), (m))
+
+#define RVID_VERSION_MAJOR(v)		RVIx_VERSION_MAJOR((v))
+#define RVID_VERSION_MINOR(v)		RVIx_VERSION_MINOR((v))
+
+#define RVID_STATUS_REASON(c)		RVIx_STATUS_REASON((c))
+#define RVID_STATUS_INDEX(c)		RVIx_STATUS_INDEX((c))
+
+#define RVID_STATUS_SUCCESS		RVIx_STATUS_SUCCESS
+#define RVID_STATUS_ERROR_PARAMETER	RVIx_STATUS_ERROR_PARAMETER
+
 #endif /* __IRQCHIP_IRQ_RVIC_H__ */
-- 
2.27.0

