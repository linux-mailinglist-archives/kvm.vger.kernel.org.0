Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27BC32685F
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBZUPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:15:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:35678 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231158AbhBZUNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:13:02 -0500
IronPort-SDR: qUHTRTDnPq++1jaCZsORqC7MMs4x1M1cXiliohkJRJPYrhU5JR5UJ3fL4AODbXzRWb21cKibW7
 X/QxAUxXDXxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846892"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846892"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:12 -0800
IronPort-SDR: nqd1c2DrHAyAoYNdWmeu+9h9FxL/yedqJ6yNvbNjqce+r0FJsduGHC+XPoXtVhYueoBpzZeSR5
 nU0B0RDaqelw==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109434"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:12 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 05/13] genirq/msi: Provide and use msi_domain_set_default_info_flags()
Date:   Fri, 26 Feb 2021 12:11:09 -0800
Message-Id: <1614370277-23235-6-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

MSI interrupts have some common flags which should be set not only for
PCI/MSI interrupts.

Move the PCI/MSI flag setting into a common function so it can be reused.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 drivers/pci/msi.c   |  7 +------
 include/linux/msi.h |  1 +
 kernel/irq/msi.c    | 24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 3162f88..20d2512 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1492,12 +1492,7 @@ struct irq_domain *pci_msi_create_irq_domain(struct fwnode_handle *fwnode,
 	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
 		pci_msi_domain_update_chip_ops(info);
 
-	info->flags |= MSI_FLAG_ACTIVATE_EARLY;
-	if (IS_ENABLED(CONFIG_GENERIC_IRQ_RESERVATION_MODE))
-		info->flags |= MSI_FLAG_MUST_REACTIVATE;
-
-	/* PCI-MSI is oneshot-safe */
-	info->chip->flags |= IRQCHIP_ONESHOT_SAFE;
+	msi_domain_set_default_info_flags(info);
 
 	domain = msi_create_irq_domain(fwnode, info, parent);
 	if (!domain)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index f3e54d2..f6e52de 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -454,6 +454,7 @@ int platform_msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 void platform_msi_domain_free(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nvec);
 void *platform_msi_get_host_data(struct irq_domain *domain);
+void msi_domain_set_default_info_flags(struct msi_domain_info *info);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index b338d62..c54316d 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -70,6 +70,30 @@ void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
 EXPORT_SYMBOL_GPL(get_cached_msi_msg);
 
 #ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+void msi_domain_set_default_info_flags(struct msi_domain_info *info)
+{
+	/* Required so that a device latches a valid MSI message on startup */
+	info->flags |= MSI_FLAG_ACTIVATE_EARLY;
+
+	/*
+	 * Interrupt reservation mode allows to stear the MSI message of an
+	 * inactive device to a special (usually spurious interrupt) target.
+	 * This allows to prevent interrupt vector exhaustion e.g. on x86.
+	 * But (PCI)MSI interrupts are activated early - see above - so the
+	 * interrupt request/startup sequence would not try to allocate a
+	 * usable vector which means that the device interrupts would end
+	 * up on the special vector and issue spurious interrupt messages.
+	 * Setting the reactivation flag ensures that when the interrupt
+	 * is requested the activation is invoked again so that a real
+	 * vector can be allocated.
+	 */
+	if (IS_ENABLED(CONFIG_GENERIC_IRQ_RESERVATION_MODE))
+		info->flags |= MSI_FLAG_MUST_REACTIVATE;
+
+	/* MSI is oneshot-safe at least in theory */
+	info->chip->flags |= IRQCHIP_ONESHOT_SAFE;
+}
+
 static inline void irq_chip_write_msi_msg(struct irq_data *data,
 					  struct msi_msg *msg)
 {
-- 
2.7.4

