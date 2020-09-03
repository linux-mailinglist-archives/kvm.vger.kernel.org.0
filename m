Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832C825C556
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgICP07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgICP00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08531208FE;
        Thu,  3 Sep 2020 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146785;
        bh=ceS8NE2MW+txLmS/EWVjLDcRc/17UR1qG/NRs/CDH60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uciye53Rz0ao2HSHPhxALTU36xXXtoFDxua7X+zyhfs/RLATZ3OTrvBbYzluD8Xju
         5AgwZnGRMb/e6YEhsXXUEJz0p9qszaM0xCSa1pJ4vd7CpFj8YOX4RdpeKMDQEW1ABr
         4m4oHkunthOYOMD+zIBB+hit4TKacp6SLIUOGPus=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr83-008vT9-BF; Thu, 03 Sep 2020 16:26:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 04/23] irqchip/rvid: Add PCI MSI support
Date:   Thu,  3 Sep 2020 16:25:51 +0100
Message-Id: <20200903152610.1078827-5-maz@kernel.org>
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
 drivers/irqchip/irq-rvid.c | 182 +++++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)

diff --git a/drivers/irqchip/irq-rvid.c b/drivers/irqchip/irq-rvid.c
index 953f654e58d4..250f95ad1a09 100644
--- a/drivers/irqchip/irq-rvid.c
+++ b/drivers/irqchip/irq-rvid.c
@@ -12,12 +12,19 @@
 #include <linux/irq.h>
 #include <linux/irqchip.h>
 #include <linux/irqdomain.h>
+#include <linux/msi.h>
 
 #include <linux/irqchip/irq-rvic.h>
 
 struct rvid_data {
 	struct fwnode_handle	*fwnode;
 	struct irq_domain	*domain;
+	struct irq_domain	*msi_domain;
+	struct irq_domain	*pci_domain;
+	unsigned long		*msi_map;
+	struct mutex		msi_lock;
+	u32			msi_base;
+	u32			msi_nr;
 };
 
 static struct rvid_data rvid;
@@ -209,6 +216,177 @@ static const struct irq_domain_ops rvid_irq_domain_ops = {
 	.deactivate	= rvid_irq_domain_deactivate,
 };
 
+#ifdef CONFIG_PCI_MSI
+/*
+ * The MSI irqchip is completely transparent. The only purpose of the
+ * corresponding irq domain is to provide the MSI allocator, and feed
+ * the allocated inputs to the main rVID irq domain for mapping at the
+ * rVIC level.
+ */
+static struct irq_chip rvid_msi_chip = {
+	.name			= "rvid-MSI",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_get_irqchip_state	= irq_chip_get_parent_state,
+	.irq_set_irqchip_state	= irq_chip_set_parent_state,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_type		= irq_chip_set_type_parent,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+};
+
+static int rvid_msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs, void *arg)
+{
+	int ret, hwirq, i;
+
+	mutex_lock(&rvid.msi_lock);
+	hwirq = bitmap_find_free_region(rvid.msi_map, rvid.msi_nr,
+					get_count_order(nr_irqs));
+	mutex_unlock(&rvid.msi_lock);
+
+	if (hwirq < 0)
+		return -ENOSPC;
+
+	for (i = 0; i < nr_irqs; i++) {
+		/* Use the rVID domain to map the input to something */
+		struct irq_fwspec fwspec = (struct irq_fwspec) {
+			.fwnode		= domain->parent->fwnode,
+			.param_count	= 1,
+			.param[0]	= rvid.msi_base + hwirq + i,
+		};
+
+		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, &fwspec);
+		if (WARN_ON(ret))
+			goto out;
+
+		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
+					      &rvid_msi_chip, &rvid);
+	}
+
+	return 0;
+
+out:
+	mutex_lock(&rvid.msi_lock);
+	bitmap_release_region(rvid.msi_map, hwirq, get_count_order(nr_irqs));
+	mutex_unlock(&rvid.msi_lock);
+
+	return ret;
+}
+
+static void rvid_msi_domain_free(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs)
+{
+	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
+	irq_hw_number_t hwirq = d->hwirq;
+
+	/* This is a bit cheeky, but hey, recursion never hurt anyone... */
+	rvid_irq_domain_free(domain, virq, nr_irqs);
+
+	mutex_lock(&rvid.msi_lock);
+	bitmap_release_region(rvid.msi_map, hwirq, get_count_order(nr_irqs));
+	mutex_unlock(&rvid.msi_lock);
+}
+
+static struct irq_domain_ops rvid_msi_domain_ops = {
+	.alloc		= rvid_msi_domain_alloc,
+	.free		= rvid_msi_domain_free,
+};
+
+/*
+ * The PCI irq chip only provides the minimal stuff, as most of the
+ * other methods will be provided as defaults.
+ */
+static void rvid_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	/* Random address, the rVID doesn't really have a doorbell */
+	msg->address_hi = 0;
+	msg->address_lo = 0xba5e0000;
+
+	/*
+	 * We are called from the PCI domain, and what we program in
+	 * the device is the rVID input pin, which is located two
+	 * levels down in the interrupt chain (PCI -> MSI -> rVID).
+	 */
+	msg->data = data->parent_data->parent_data->hwirq;
+}
+
+static void rvid_pci_mask(struct irq_data *d)
+{
+	pci_msi_mask_irq(d);
+	irq_chip_mask_parent(d);
+}
+
+static void rvid_pci_unmask(struct irq_data *d)
+{
+	pci_msi_unmask_irq(d);
+	irq_chip_unmask_parent(d);
+}
+
+static struct irq_chip rvid_pci_chip = {
+	.name			= "PCI-MSI",
+	.irq_mask		= rvid_pci_mask,
+	.irq_unmask		= rvid_pci_unmask,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_compose_msi_msg	= rvid_compose_msi_msg,
+	.irq_write_msi_msg	= pci_msi_domain_write_msg,
+};
+
+static struct msi_domain_info rvid_pci_domain_info = {
+	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+		   MSI_FLAG_PCI_MSIX | MSI_FLAG_MULTI_PCI_MSI),
+	.chip	= &rvid_pci_chip,
+};
+
+static void __init rvid_msi_setup(struct device_node *np)
+{
+	if (!of_property_read_bool(np, "msi-controller"))
+		return;
+
+	if (of_property_read_u32_index(np, "msi-range", 0, &rvid.msi_base) ||
+	    of_property_read_u32_index(np, "msi-range", 1, &rvid.msi_nr)) {
+		pr_err("Invalid or missing msi-range\n");
+		return;
+	}
+
+	mutex_init(&rvid.msi_lock);
+
+	rvid.msi_map = bitmap_alloc(rvid.msi_nr, GFP_KERNEL | __GFP_ZERO);
+	if (!rvid.msi_map)
+		return;
+
+	rvid.msi_domain = irq_domain_create_hierarchy(rvid.domain, 0, 0,
+						      rvid.fwnode,
+						      &rvid_msi_domain_ops,
+						      &rvid);
+	if (!rvid.msi_domain) {
+		pr_err("Failed to allocate MSI domain\n");
+		goto out;
+	}
+
+	irq_domain_update_bus_token(rvid.msi_domain, DOMAIN_BUS_NEXUS);
+
+	rvid.pci_domain = pci_msi_create_irq_domain(rvid.domain->fwnode,
+						    &rvid_pci_domain_info,
+						    rvid.msi_domain);
+	if (!rvid.pci_domain) {
+		pr_err("Failed to allocate PCI domain\n");
+		goto out;
+	}
+
+	pr_info("MSIs available as inputs [%d:%d]\n",
+		rvid.msi_base, rvid.msi_base + rvid.msi_nr - 1);
+	return;
+
+out:
+	if (rvid.msi_domain)
+		irq_domain_remove(rvid.msi_domain);
+	kfree(rvid.msi_map);
+}
+#else
+static inline void rvid_msi_setup(struct device_node *np) {}
+#endif
+
 static int __init rvid_init(struct device_node *node,
 			    struct device_node *parent)
 {
@@ -253,6 +431,10 @@ static int __init rvid_init(struct device_node *node,
 		return -ENOMEM;
 	}
 
+	irq_domain_update_bus_token(rvid.domain, DOMAIN_BUS_WIRED);
+
+	rvid_msi_setup(node);
+
 	return 0;
 }
 
-- 
2.27.0

