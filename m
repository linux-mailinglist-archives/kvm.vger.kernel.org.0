Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715F01B333A
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDUXeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:10107 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgDUXeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:08 -0400
IronPort-SDR: gj/HV3+RyhDo1NzmEmmHSGrWoIlFF2YW4aQcwiGJS0XDXn4dLsfKnSXz170QIS6z87Vhfts4xH
 be6zQnHEziZg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:00 -0700
IronPort-SDR: iJ1MRYp5BPfCtqBEdZDaPFs2OEEnUSCFISx+8YUDKbWRQr5FhFLQ6m1Q5rW+zca6goptwqkxK4
 lUsXm58ZWXEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="258876422"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2020 16:33:59 -0700
Subject: [PATCH RFC 02/15] drivers/base: Introduce a new platform-msi list
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
Date:   Tue, 21 Apr 2020 16:33:59 -0700
Message-ID: <158751203902.36773.2662739280103265908.stgit@djiang5-desk3.ch.intel.com>
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

The struct device has a linked list ('msi_list') of the MSI (msi/msi-x,
platform-msi) descriptors of that device. This list holds only 1 type
of descriptor since it is not possible for a device to support more
than one of these descriptors concurrently.

However, with the introduction of IMS, a device can support IMS as well
as MSI-X at the same time. Instead of sharing this list between IMS (a
type of platform-msi) and MSI-X descriptors, introduce a new linked list,
platform_msi_list, which will hold all the platform-msi descriptors.

Thus, msi_list will point to the MSI/MSIX descriptors of a device, while
platform_msi_list will point to the platform-msi descriptors of a device.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 drivers/base/core.c         |    1 +
 drivers/base/platform-msi.c |   19 +++++++++++--------
 include/linux/device.h      |    2 ++
 include/linux/list.h        |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/msi.h         |   21 +++++++++++++++++++++
 kernel/irq/msi.c            |   16 ++++++++--------
 6 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 139cdf7e7327..5a0116d1a8d0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1984,6 +1984,7 @@ void device_initialize(struct device *dev)
 	set_dev_node(dev, -1);
 #ifdef CONFIG_GENERIC_MSI_IRQ
 	INIT_LIST_HEAD(&dev->msi_list);
+	INIT_LIST_HEAD(&dev->platform_msi_list);
 #endif
 	INIT_LIST_HEAD(&dev->links.consumers);
 	INIT_LIST_HEAD(&dev->links.suppliers);
diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 1a3af5f33802..b25c52f734dc 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -110,7 +110,8 @@ static void platform_msi_free_descs(struct device *dev, int base, int nvec)
 {
 	struct msi_desc *desc, *tmp;
 
-	list_for_each_entry_safe(desc, tmp, dev_to_msi_list(dev), list) {
+	list_for_each_entry_safe(desc, tmp, dev_to_platform_msi_list(dev),
+				 list) {
 		if (desc->platform.msi_index >= base &&
 		    desc->platform.msi_index < (base + nvec)) {
 			list_del(&desc->list);
@@ -127,8 +128,8 @@ static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
 	struct msi_desc *desc;
 	int i, base = 0;
 
-	if (!list_empty(dev_to_msi_list(dev))) {
-		desc = list_last_entry(dev_to_msi_list(dev),
+	if (!list_empty(dev_to_platform_msi_list(dev))) {
+		desc = list_last_entry(dev_to_platform_msi_list(dev),
 				       struct msi_desc, list);
 		base = desc->platform.msi_index + 1;
 	}
@@ -142,7 +143,7 @@ static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
 		desc->platform.msi_index = base + i;
 		desc->irq = virq ? virq + i : 0;
 
-		list_add_tail(&desc->list, dev_to_msi_list(dev));
+		list_add_tail(&desc->list, dev_to_platform_msi_list(dev));
 	}
 
 	if (i != nvec) {
@@ -213,7 +214,7 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
 	}
 
 	/* Already had a helping of MSI? Greed... */
-	if (!list_empty(dev_to_msi_list(dev)))
+	if (!list_empty(dev_to_platform_msi_list(dev)))
 		return ERR_PTR(-EBUSY);
 
 	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
@@ -255,6 +256,8 @@ int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 	struct platform_msi_priv_data *priv_data;
 	int err;
 
+	dev->platform_msi_type = GEN_PLAT_MSI;
+
 	priv_data = platform_msi_alloc_priv_data(dev, nvec, platform_ops);
 	if (IS_ERR(priv_data))
 		return PTR_ERR(priv_data);
@@ -284,10 +287,10 @@ EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs);
  */
 void platform_msi_domain_free_irqs(struct device *dev)
 {
-	if (!list_empty(dev_to_msi_list(dev))) {
+	if (!list_empty(dev_to_platform_msi_list(dev))) {
 		struct msi_desc *desc;
 
-		desc = first_msi_entry(dev);
+		desc = first_platform_msi_entry(dev);
 		platform_msi_free_priv_data(desc->platform.msi_priv_data);
 	}
 
@@ -370,7 +373,7 @@ void platform_msi_domain_free(struct irq_domain *domain, unsigned int virq,
 {
 	struct platform_msi_priv_data *data = domain->host_data;
 	struct msi_desc *desc, *tmp;
-	for_each_msi_entry_safe(desc, tmp, data->dev) {
+	for_each_platform_msi_entry_safe(desc, tmp, data->dev) {
 		if (WARN_ON(!desc->irq || desc->nvec_used != 1))
 			return;
 		if (!(desc->irq >= virq && desc->irq < (virq + nvec)))
diff --git a/include/linux/device.h b/include/linux/device.h
index ac8e37cd716a..cbcecb14584e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -567,6 +567,8 @@ struct device {
 #endif
 #ifdef CONFIG_GENERIC_MSI_IRQ
 	struct list_head	msi_list;
+	struct list_head	platform_msi_list;
+	unsigned int		platform_msi_type;
 #endif
 
 	const struct dma_map_ops *dma_ops;
diff --git a/include/linux/list.h b/include/linux/list.h
index aff44d34f4e4..7a5ea40cb945 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -492,6 +492,18 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
 
+/**
+ * list_entry_select - get the correct struct for this entry based on condition
+ * @condition:	the condition to choose a particular &struct list head pointer
+ * @ptr_a:      the &struct list_head pointer if @condition is not met.
+ * @ptr_b:      the &struct list_head pointer if @condition is met.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_head within the struct.
+ */
+#define list_entry_select(condition, ptr_a, ptr_b, type, member)\
+	(condition) ? list_entry(ptr_a, type, member) :		\
+		      list_entry(ptr_b, type, member)
+
 /**
  * list_first_entry - get the first element from a list
  * @ptr:	the list head to take the element from.
@@ -503,6 +515,17 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_first_entry_select - get the first element from list based on condition
+ * @condition:  the condition to choose a particular &struct list head pointer
+ * @ptr_a:      the &struct list_head pointer if @condition is not met.
+ * @ptr_b:      the &struct list_head pointer if @condition is met.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_head within the struct.
+ */
+#define list_first_entry_select(condition, ptr_a, ptr_b, type, member)  \
+	list_entry_select((condition), (ptr_a)->next, (ptr_b)->next, type, member)
+
 /**
  * list_last_entry - get the last element from a list
  * @ptr:	the list head to take the element from.
@@ -602,6 +625,19 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     &pos->member != (head);					\
 	     pos = list_next_entry(pos, member))
 
+/**
+ * list_for_each_entry_select - iterate over list of given type based on condition
+ * @condition:  the condition to choose a particular &struct list head pointer
+ * @pos:        the type * to use as a loop cursor.
+ * @head_a:     the head for your list if condition is met.
+ * @head_b:     the head for your list if condition is not met.
+ * @member:     the name of the list_head within the struct.
+ */
+#define list_for_each_entry_select(condition, pos, head_a, head_b, member)\
+	for (pos = list_first_entry_select((condition), head_a, head_b, typeof(*pos), member);\
+	     (condition) ? &pos->member != (head_a) : &pos->member != (head_b);\
+	     pos = list_next_entry(pos, member))
+
 /**
  * list_for_each_entry_reverse - iterate backwards over list of given type.
  * @pos:	the type * to use as a loop cursor.
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8e08907d70cb..9c15b7403694 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -130,6 +130,11 @@ struct msi_desc {
 	};
 };
 
+enum platform_msi_type {
+	NOT_PLAT_MSI = 0,
+	GEN_PLAT_MSI = 1,
+};
+
 /* Helpers to hide struct msi_desc implementation details */
 #define msi_desc_to_dev(desc)		((desc)->dev)
 #define dev_to_msi_list(dev)		(&(dev)->msi_list)
@@ -140,6 +145,22 @@ struct msi_desc {
 #define for_each_msi_entry_safe(desc, tmp, dev)	\
 	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
 
+#define dev_to_platform_msi_list(dev)	(&(dev)->platform_msi_list)
+#define first_platform_msi_entry(dev)		\
+	list_first_entry(dev_to_platform_msi_list((dev)), struct msi_desc, list)
+#define for_each_platform_msi_entry(desc, dev)	\
+	list_for_each_entry((desc), dev_to_platform_msi_list((dev)), list)
+#define for_each_platform_msi_entry_safe(desc, tmp, dev)	\
+	list_for_each_entry_safe((desc), (tmp), dev_to_platform_msi_list((dev)), list)
+
+#define first_msi_entry_common(dev)	\
+	list_first_entry_select((dev)->platform_msi_type, dev_to_platform_msi_list((dev)),	\
+				dev_to_msi_list((dev)), struct msi_desc, list)
+
+#define for_each_msi_entry_common(desc, dev)	\
+	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
+				   dev_to_msi_list((dev)), list)	\
+
 #ifdef CONFIG_IRQ_MSI_IOMMU
 static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
 {
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index eb95f6106a1e..bc5f9e32387f 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -320,7 +320,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 	struct msi_desc *desc;
 	int ret = 0;
 
-	for_each_msi_entry(desc, dev) {
+	for_each_msi_entry_common(desc, dev) {
 		/* Don't even try the multi-MSI brain damage. */
 		if (WARN_ON(!desc->irq || desc->nvec_used != 1)) {
 			ret = -EINVAL;
@@ -342,7 +342,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 
 	if (ret) {
 		/* Mop up the damage */
-		for_each_msi_entry(desc, dev) {
+		for_each_msi_entry_common(desc, dev) {
 			if (!(desc->irq >= virq && desc->irq < (virq + nvec)))
 				continue;
 
@@ -383,7 +383,7 @@ static bool msi_check_reservation_mode(struct irq_domain *domain,
 	 * Checking the first MSI descriptor is sufficient. MSIX supports
 	 * masking and MSI does so when the maskbit is set.
 	 */
-	desc = first_msi_entry(dev);
+	desc = first_msi_entry_common(dev);
 	return desc->msi_attrib.is_msix || desc->msi_attrib.maskbit;
 }
 
@@ -411,7 +411,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	if (ret)
 		return ret;
 
-	for_each_msi_entry(desc, dev) {
+	for_each_msi_entry_common(desc, dev) {
 		ops->set_desc(&arg, desc);
 
 		virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used,
@@ -437,7 +437,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 	can_reserve = msi_check_reservation_mode(domain, info, dev);
 
-	for_each_msi_entry(desc, dev) {
+	for_each_msi_entry_common(desc, dev) {
 		virq = desc->irq;
 		if (desc->nvec_used == 1)
 			dev_dbg(dev, "irq %d for MSI\n", virq);
@@ -468,7 +468,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	 * so request_irq() will assign the final vector.
 	 */
 	if (can_reserve) {
-		for_each_msi_entry(desc, dev) {
+		for_each_msi_entry_common(desc, dev) {
 			irq_data = irq_domain_get_irq_data(domain, desc->irq);
 			irqd_clr_activated(irq_data);
 		}
@@ -476,7 +476,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	return 0;
 
 cleanup:
-	for_each_msi_entry(desc, dev) {
+	for_each_msi_entry_common(desc, dev) {
 		struct irq_data *irqd;
 
 		if (desc->irq == virq)
@@ -500,7 +500,7 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
 	struct msi_desc *desc;
 
-	for_each_msi_entry(desc, dev) {
+	for_each_msi_entry_common(desc, dev) {
 		/*
 		 * We might have failed to allocate an MSI early
 		 * enough that there is no IRQ associated to this

