Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1614532685C
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhBZUOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:14:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:35659 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhBZUNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:13:02 -0500
IronPort-SDR: WoXaGExp3AugKtPPIZSszoWlVajphvks6EWzIR8NYyHwF0bHmmtxKDHuGTLXMi7/gIYYxKk6tv
 uGevjAsIcClw==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846899"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846899"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:13 -0800
IronPort-SDR: +EpK/x9VncNDE5qsC6U/B0HcBszgCBpXa4e1qFTeKEWYJgpXogusVejBQoXRMwu4tztbv7ye9z
 g5dY5zB++ODA==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109442"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:13 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 07/13] irqdomain/msi: Provide msi_alloc/free_store() callbacks
Date:   Fri, 26 Feb 2021 12:11:11 -0800
Message-Id: <1614370277-23235-8-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

For devices which don't have a standard storage for MSI messages like the
upcoming IMS (Interrupt Message Store) it's required to allocate storage
space before allocating interrupts and after freeing them.

This could be achieved with the existing callbacks, but that would be
awkward because they operate on msi_alloc_info_t which is not uniform
across architectures. Also these callbacks are invoked per interrupt but
the allocation might have bulk requirements depending on the device.

As such devices can operate on different architectures it is simpler to
have separate callbacks which operate on struct device. The resulting
storage information has to be stored in struct msi_desc so the underlying
irq chip implementation can retrieve it for the relevant operations.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 include/linux/msi.h |  8 ++++++++
 kernel/irq/msi.c    | 11 +++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 46e879c..e915932 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -323,6 +323,10 @@ struct msi_domain_info;
  *			function.
  * @domain_free_irqs:	Optional function to override the default free
  *			function.
+ * @msi_alloc_store:	Optional callback to allocate storage in a device
+ *			specific non-standard MSI store
+ * @msi_alloc_free:	Optional callback to free storage in a device
+ *			specific non-standard MSI store
  *
  * @get_hwirq, @msi_init and @msi_free are callbacks used by
  * msi_create_irq_domain() and related interfaces
@@ -372,6 +376,10 @@ struct msi_domain_ops {
 					     struct device *dev, int nvec);
 	void		(*domain_free_irqs)(struct irq_domain *domain,
 					    struct device *dev);
+	int		(*msi_alloc_store)(struct irq_domain *domain,
+					   struct device *dev, int nvec);
+	void		(*msi_free_store)(struct irq_domain *domain,
+					  struct device *dev);
 };
 
 /**
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index c54316d..047b59d 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -434,6 +434,12 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	if (ret)
 		return ret;
 
+	if (ops->msi_alloc_store) {
+		ret = ops->msi_alloc_store(domain, dev, nvec);
+		if (ret)
+			return ret;
+	}
+
 	for_each_msi_entry(desc, dev) {
 		ops->set_desc(&arg, desc);
 
@@ -529,6 +535,8 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 void __msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
+	struct msi_domain_info *info = domain->host_data;
+	struct msi_domain_ops *ops = info->ops;
 	struct msi_desc *desc;
 
 	for_each_msi_entry(desc, dev) {
@@ -542,6 +550,9 @@ void __msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 			desc->irq = 0;
 		}
 	}
+
+	if (ops->msi_free_store)
+		ops->msi_free_store(domain, dev);
 }
 
 /**
-- 
2.7.4

