Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC532686A
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhBZUQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:16:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:35678 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhBZUOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:14:02 -0500
IronPort-SDR: VxfR5jkt3HFxkn681jJcDta0X1KeYqEP8rBlGLR3rNCUxrT7N/VncmFDF1QYT1WzgTA0JcUM2m
 Ykl42Q2WsRvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846919"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846919"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:15 -0800
IronPort-SDR: nb0fcvfHHm0m8Hdy1+xls3a8hEnYNqDlXOEEWSI1luFshB5X1P5oXgEgsXgT8eoI0Qn46ShK9E
 yLC1P6ZemW2g==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109464"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:15 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 13/13] genirq/msi: Provide helpers to return Linux IRQ/dev_msi hw IRQ number
Date:   Fri, 26 Feb 2021 12:11:17 -0800
Message-Id: <1614370277-23235-14-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

Add new helpers to get the Linux IRQ number and device specific index
for given device-relative vector so that the drivers don't need to
allocate their own arrays to keep track of the vectors and hwirq for
the multi vector device MSI case.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 include/linux/msi.h |  2 ++
 kernel/irq/msi.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 24abec0..d60a6ba 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -451,6 +451,8 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 				   irq_write_msi_msg_t write_msi_msg);
 void platform_msi_domain_free_irqs(struct device *dev);
+int msi_irq_vector(struct device *dev, unsigned int nr);
+int dev_msi_hwirq(struct device *dev, unsigned int nr);
 
 /* When an MSI domain is used as an intermediate domain */
 int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 047b59d..f2a8f55 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -581,4 +581,48 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
 	return (struct msi_domain_info *)domain->host_data;
 }
 
+/**
+ * msi_irq_vector - Get the Linux IRQ number of a device vector
+ * @dev: device to operate on
+ * @nr: device-relative interrupt vector index (0-based).
+ *
+ * Returns the Linux IRQ number of a device vector.
+ */
+int msi_irq_vector(struct device *dev, unsigned int nr)
+{
+	struct msi_desc *entry;
+	int i = 0;
+
+	for_each_msi_entry(entry, dev) {
+		if (i == nr)
+			return entry->irq;
+		i++;
+	}
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(msi_irq_vector);
+
+/**
+ * dev_msi_hwirq - Get the device MSI hw IRQ number of a device vector
+ * @dev: device to operate on
+ * @nr: device-relative interrupt vector index (0-based).
+ *
+ * Return the dev_msi hw IRQ number of a device vector.
+ */
+int dev_msi_hwirq(struct device *dev, unsigned int nr)
+{
+	struct msi_desc *entry;
+	int i = 0;
+
+	for_each_msi_entry(entry, dev) {
+		if (i == nr)
+			return entry->device_msi.hwirq;
+		i++;
+	}
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(dev_msi_hwirq);
+
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
-- 
2.7.4

