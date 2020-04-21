Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19AB1B333D
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgDUXeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:32238 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgDUXeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:11 -0400
IronPort-SDR: HdzxX1T31gR/D7a1x9O9GOH5VEyvlXJtC2l/S/ccA1Mxxd4ggq3YJ2gPOqMbr0pqifyOSstv9D
 vdF3ALZFct1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:07 -0700
IronPort-SDR: xxjg9s1XUxfrlmxvbvMt8lEmGxmPguT8DMvlQE+tiLyPmeB+3RNRmwR9VkCnEy3csLXauG4JmA
 q/YoOCgjOl8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="245816392"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2020 16:34:05 -0700
Subject: [PATCH RFC 03/15] drivers/base: Allocate/free platform-msi
 interrupts by group
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:34:05 -0700
Message-ID: <158751204550.36773.459505651659406529.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

This is a preparatory patch to introduce Interrupt Message Store (IMS).

Dynamic allocation is IMS vectors is a requirement for devices which
support Scalable I/o virtualization. A driver can allocate and free
vectors not just once during probe (as was the case with the MSI/MSI-X)
but also in the post probe phase where actual demand is available.

Thus, introduce an API, platform_msi_domain_alloc_irqs_group() which
drivers using IMS would be able to call multiple times. The vectors
allocated each time this API is called are associated with a group ID,
starting from 1. To free the vectors associated with a particular group,
platform_msi_domain_free_irqs_group() API can be called.

The existing drivers using platform-msi infrastructure will continue to
use the existing alloc (platform_msi_domain_alloc_irqs) and free
(platform_msi_domain_free_irqs) APIs and are assigned a default group 0.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 drivers/base/platform-msi.c |  131 ++++++++++++++++++++++++++++++++-----------
 include/linux/device.h      |    1 
 include/linux/msi.h         |   47 +++++++++++----
 kernel/irq/msi.c            |   43 +++++++++++---
 4 files changed, 169 insertions(+), 53 deletions(-)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index b25c52f734dc..2696aa75983b 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -106,16 +106,28 @@ static void platform_msi_update_chip_ops(struct msi_domain_info *info)
 		info->flags &= ~MSI_FLAG_LEVEL_CAPABLE;
 }
 
-static void platform_msi_free_descs(struct device *dev, int base, int nvec)
+static void platform_msi_free_descs(struct device *dev, int base, int nvec,
+				    unsigned int group)
 {
 	struct msi_desc *desc, *tmp;
-
-	list_for_each_entry_safe(desc, tmp, dev_to_platform_msi_list(dev),
-				 list) {
-		if (desc->platform.msi_index >= base &&
-		    desc->platform.msi_index < (base + nvec)) {
-			list_del(&desc->list);
-			free_msi_entry(desc);
+	struct platform_msi_group_entry *platform_msi_group,
+					*tmp_platform_msi_group;
+
+	list_for_each_entry_safe(platform_msi_group, tmp_platform_msi_group,
+				 dev_to_platform_msi_group_list(dev),
+				 group_list) {
+		if (platform_msi_group->group_id == group) {
+			list_for_each_entry_safe(desc, tmp,
+						&platform_msi_group->entry_list,
+						list) {
+				if (desc->platform.msi_index >= base &&
+				    desc->platform.msi_index < (base + nvec)) {
+					list_del(&desc->list);
+					free_msi_entry(desc);
+				}
+			}
+			list_del(&platform_msi_group->group_list);
+			kfree(platform_msi_group);
 		}
 	}
 }
@@ -128,8 +140,8 @@ static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
 	struct msi_desc *desc;
 	int i, base = 0;
 
-	if (!list_empty(dev_to_platform_msi_list(dev))) {
-		desc = list_last_entry(dev_to_platform_msi_list(dev),
+	if (!list_empty(platform_msi_current_group_entry_list(dev))) {
+		desc = list_last_entry(platform_msi_current_group_entry_list(dev),
 				       struct msi_desc, list);
 		base = desc->platform.msi_index + 1;
 	}
@@ -143,12 +155,13 @@ static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
 		desc->platform.msi_index = base + i;
 		desc->irq = virq ? virq + i : 0;
 
-		list_add_tail(&desc->list, dev_to_platform_msi_list(dev));
+		list_add_tail(&desc->list,
+			      platform_msi_current_group_entry_list(dev));
 	}
 
 	if (i != nvec) {
 		/* Clean up the mess */
-		platform_msi_free_descs(dev, base, nvec);
+		platform_msi_free_descs(dev, base, nvec, dev->group_id);
 
 		return -ENOMEM;
 	}
@@ -214,7 +227,7 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
 	}
 
 	/* Already had a helping of MSI? Greed... */
-	if (!list_empty(dev_to_platform_msi_list(dev)))
+	if (!list_empty(platform_msi_current_group_entry_list(dev)))
 		return ERR_PTR(-EBUSY);
 
 	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
@@ -253,11 +266,36 @@ static void platform_msi_free_priv_data(struct platform_msi_priv_data *data)
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 				   const struct platform_msi_ops *platform_ops)
 {
+	return platform_msi_domain_alloc_irqs_group(dev, nvec, platform_ops,
+									NULL);
+}
+EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs);
+
+int platform_msi_domain_alloc_irqs_group(struct device *dev, unsigned int nvec,
+					 const struct platform_msi_ops *platform_ops,
+					 unsigned int *group_id)
+{
+	struct platform_msi_group_entry *platform_msi_group;
 	struct platform_msi_priv_data *priv_data;
 	int err;
 
 	dev->platform_msi_type = GEN_PLAT_MSI;
 
+	if (group_id)
+		*group_id = ++dev->group_id;
+
+	platform_msi_group = kzalloc(sizeof(*platform_msi_group), GFP_KERNEL);
+	if (!platform_msi_group) {
+		err = -ENOMEM;
+		goto out_platform_msi_group;
+	}
+
+	INIT_LIST_HEAD(&platform_msi_group->group_list);
+	INIT_LIST_HEAD(&platform_msi_group->entry_list);
+	platform_msi_group->group_id = dev->group_id;
+	list_add_tail(&platform_msi_group->group_list,
+		      dev_to_platform_msi_group_list(dev));
+
 	priv_data = platform_msi_alloc_priv_data(dev, nvec, platform_ops);
 	if (IS_ERR(priv_data))
 		return PTR_ERR(priv_data);
@@ -273,13 +311,14 @@ int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 	return 0;
 
 out_free_desc:
-	platform_msi_free_descs(dev, 0, nvec);
+	platform_msi_free_descs(dev, 0, nvec, dev->group_id);
 out_free_priv_data:
 	platform_msi_free_priv_data(priv_data);
-
+out_platform_msi_group:
+	kfree(platform_msi_group);
 	return err;
 }
-EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs);
+EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs_group);
 
 /**
  * platform_msi_domain_free_irqs - Free MSI interrupts for @dev
@@ -287,17 +326,30 @@ EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs);
  */
 void platform_msi_domain_free_irqs(struct device *dev)
 {
-	if (!list_empty(dev_to_platform_msi_list(dev))) {
-		struct msi_desc *desc;
+	platform_msi_domain_free_irqs_group(dev, 0);
+}
+EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs);
 
-		desc = first_platform_msi_entry(dev);
-		platform_msi_free_priv_data(desc->platform.msi_priv_data);
+void platform_msi_domain_free_irqs_group(struct device *dev, unsigned int group)
+{
+	struct platform_msi_group_entry *platform_msi_group;
+
+	list_for_each_entry(platform_msi_group,
+			    dev_to_platform_msi_group_list((dev)), group_list) {
+		if (platform_msi_group->group_id == group) {
+			if (!list_empty(&platform_msi_group->entry_list)) {
+				struct msi_desc *desc;
+
+				desc = list_first_entry(&(platform_msi_group)->entry_list,
+							struct msi_desc, list);
+				platform_msi_free_priv_data(desc->platform.msi_priv_data);
+			}
+		}
 	}
-
-	msi_domain_free_irqs(dev->msi_domain, dev);
-	platform_msi_free_descs(dev, 0, MAX_DEV_MSIS);
+	msi_domain_free_irqs_group(dev->msi_domain, dev, group);
+	platform_msi_free_descs(dev, 0, MAX_DEV_MSIS, group);
 }
-EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs);
+EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs_group);
 
 /**
  * platform_msi_get_host_data - Query the private data associated with
@@ -373,15 +425,28 @@ void platform_msi_domain_free(struct irq_domain *domain, unsigned int virq,
 {
 	struct platform_msi_priv_data *data = domain->host_data;
 	struct msi_desc *desc, *tmp;
-	for_each_platform_msi_entry_safe(desc, tmp, data->dev) {
-		if (WARN_ON(!desc->irq || desc->nvec_used != 1))
-			return;
-		if (!(desc->irq >= virq && desc->irq < (virq + nvec)))
-			continue;
-
-		irq_domain_free_irqs_common(domain, desc->irq, 1);
-		list_del(&desc->list);
-		free_msi_entry(desc);
+	struct platform_msi_group_entry *platform_msi_group,
+					*tmp_platform_msi_group;
+
+	list_for_each_entry_safe(platform_msi_group, tmp_platform_msi_group,
+				 dev_to_platform_msi_group_list(data->dev),
+				 group_list) {
+		if (platform_msi_group->group_id == data->dev->group_id) {
+			list_for_each_entry_safe(desc, tmp,
+						&platform_msi_group->entry_list,
+						list) {
+				if (WARN_ON(!desc->irq || desc->nvec_used != 1))
+					return;
+				if (!(desc->irq >= virq && desc->irq < (virq + nvec)))
+					continue;
+
+				irq_domain_free_irqs_common(domain, desc->irq, 1);
+				list_del(&desc->list);
+				free_msi_entry(desc);
+			}
+			list_del(&platform_msi_group->group_list);
+			kfree(platform_msi_group);
+		}
 	}
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index cbcecb14584e..f6700b85eb95 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -624,6 +624,7 @@ struct device {
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
 	bool			dma_coherent:1;
 #endif
+	unsigned int		group_id;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 9c15b7403694..3890b143b04d 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -135,6 +135,12 @@ enum platform_msi_type {
 	GEN_PLAT_MSI = 1,
 };
 
+struct platform_msi_group_entry {
+	unsigned int group_id;
+	struct list_head group_list;
+	struct list_head entry_list;
+};
+
 /* Helpers to hide struct msi_desc implementation details */
 #define msi_desc_to_dev(desc)		((desc)->dev)
 #define dev_to_msi_list(dev)		(&(dev)->msi_list)
@@ -145,21 +151,31 @@ enum platform_msi_type {
 #define for_each_msi_entry_safe(desc, tmp, dev)	\
 	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
 
-#define dev_to_platform_msi_list(dev)	(&(dev)->platform_msi_list)
-#define first_platform_msi_entry(dev)		\
-	list_first_entry(dev_to_platform_msi_list((dev)), struct msi_desc, list)
-#define for_each_platform_msi_entry(desc, dev)	\
-	list_for_each_entry((desc), dev_to_platform_msi_list((dev)), list)
-#define for_each_platform_msi_entry_safe(desc, tmp, dev)	\
-	list_for_each_entry_safe((desc), (tmp), dev_to_platform_msi_list((dev)), list)
+#define dev_to_platform_msi_group_list(dev)    (&(dev)->platform_msi_list)
+
+#define first_platform_msi_group_entry(dev)				\
+	list_first_entry(dev_to_platform_msi_group_list((dev)),		\
+			 struct platform_msi_group_entry, group_list)
 
-#define first_msi_entry_common(dev)	\
-	list_first_entry_select((dev)->platform_msi_type, dev_to_platform_msi_list((dev)),	\
+#define platform_msi_current_group_entry_list(dev)			\
+	(&((list_last_entry(dev_to_platform_msi_group_list((dev)),	\
+			    struct platform_msi_group_entry,		\
+			    group_list))->entry_list))
+
+#define first_msi_entry_current_group(dev)				\
+	list_first_entry_select((dev)->platform_msi_type,		\
+				platform_msi_current_group_entry_list((dev)),	\
 				dev_to_msi_list((dev)), struct msi_desc, list)
 
-#define for_each_msi_entry_common(desc, dev)	\
-	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
-				   dev_to_msi_list((dev)), list)	\
+#define for_each_msi_entry_current_group(desc, dev)			\
+	list_for_each_entry_select((dev)->platform_msi_type, desc,	\
+				   platform_msi_current_group_entry_list((dev)),\
+				   dev_to_msi_list((dev)), list)
+
+#define for_each_platform_msi_entry_in_group(desc, platform_msi_group, group, dev)	\
+	list_for_each_entry((platform_msi_group), dev_to_platform_msi_group_list((dev)), group_list)	\
+		if (((platform_msi_group)->group_id) == (group))			\
+			list_for_each_entry((desc), (&(platform_msi_group)->entry_list), list)
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
 static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
@@ -363,6 +379,8 @@ struct irq_domain *msi_create_irq_domain(struct fwnode_handle *fwnode,
 int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			  int nvec);
 void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
+void msi_domain_free_irqs_group(struct irq_domain *domain,
+				struct device *dev, unsigned int group);
 struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
 
 struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
@@ -371,6 +389,11 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 				   const struct platform_msi_ops *platform_ops);
 void platform_msi_domain_free_irqs(struct device *dev);
+int platform_msi_domain_alloc_irqs_group(struct device *dev, unsigned int nvec,
+					 const struct platform_msi_ops *platform_ops,
+					 unsigned int *group_id);
+void platform_msi_domain_free_irqs_group(struct device *dev,
+					 unsigned int group_id);
 
 /* When an MSI domain is used as an intermediate domain */
 int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index bc5f9e32387f..899ade394ec8 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -320,7 +320,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 	struct msi_desc *desc;
 	int ret = 0;
 
-	for_each_msi_entry_common(desc, dev) {
+	for_each_msi_entry_current_group(desc, dev) {
 		/* Don't even try the multi-MSI brain damage. */
 		if (WARN_ON(!desc->irq || desc->nvec_used != 1)) {
 			ret = -EINVAL;
@@ -342,7 +342,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 
 	if (ret) {
 		/* Mop up the damage */
-		for_each_msi_entry_common(desc, dev) {
+		for_each_msi_entry_current_group(desc, dev) {
 			if (!(desc->irq >= virq && desc->irq < (virq + nvec)))
 				continue;
 
@@ -383,7 +383,7 @@ static bool msi_check_reservation_mode(struct irq_domain *domain,
 	 * Checking the first MSI descriptor is sufficient. MSIX supports
 	 * masking and MSI does so when the maskbit is set.
 	 */
-	desc = first_msi_entry_common(dev);
+	desc = first_msi_entry_current_group(dev);
 	return desc->msi_attrib.is_msix || desc->msi_attrib.maskbit;
 }
 
@@ -411,7 +411,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	if (ret)
 		return ret;
 
-	for_each_msi_entry_common(desc, dev) {
+	for_each_msi_entry_current_group(desc, dev) {
 		ops->set_desc(&arg, desc);
 
 		virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used,
@@ -437,7 +437,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 	can_reserve = msi_check_reservation_mode(domain, info, dev);
 
-	for_each_msi_entry_common(desc, dev) {
+	for_each_msi_entry_current_group(desc, dev) {
 		virq = desc->irq;
 		if (desc->nvec_used == 1)
 			dev_dbg(dev, "irq %d for MSI\n", virq);
@@ -468,7 +468,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	 * so request_irq() will assign the final vector.
 	 */
 	if (can_reserve) {
-		for_each_msi_entry_common(desc, dev) {
+		for_each_msi_entry_current_group(desc, dev) {
 			irq_data = irq_domain_get_irq_data(domain, desc->irq);
 			irqd_clr_activated(irq_data);
 		}
@@ -476,7 +476,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	return 0;
 
 cleanup:
-	for_each_msi_entry_common(desc, dev) {
+	for_each_msi_entry_current_group(desc, dev) {
 		struct irq_data *irqd;
 
 		if (desc->irq == virq)
@@ -500,7 +500,34 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
 	struct msi_desc *desc;
 
-	for_each_msi_entry_common(desc, dev) {
+	for_each_msi_entry_current_group(desc, dev) {
+		/*
+		 * We might have failed to allocate an MSI early
+		 * enough that there is no IRQ associated to this
+		 * entry. If that's the case, don't do anything.
+		 */
+		if (desc->irq) {
+			irq_domain_free_irqs(desc->irq, desc->nvec_used);
+			desc->irq = 0;
+		}
+	}
+}
+
+/**
+ * msi_domain_free_irqs_group - Free interrupts from a MSI interrupt @domain
+ * associated to @dev from a particular group
+ * @domain:	The domain to managing the interrupts
+ * @dev:	Pointer to device struct of the device for which the interrupts
+ *		are free
+ * @group:	group from which interrupts are to be freed
+ */
+void msi_domain_free_irqs_group(struct irq_domain *domain,
+				struct device *dev, unsigned int group)
+{
+	struct msi_desc *desc;
+	struct platform_msi_group_entry *platform_msi_group;
+
+	for_each_platform_msi_entry_in_group(desc, platform_msi_group, group, dev) {
 		/*
 		 * We might have failed to allocate an MSI early
 		 * enough that there is no IRQ associated to this

