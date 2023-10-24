Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3C7D4A9A
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjJXImC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjJXImA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:42:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82131DB;
        Tue, 24 Oct 2023 01:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698136917; x=1729672917;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b7LXl0qgpLpoKB3PWzwmiJ1ozaFOWYLgH1jot2rzMeo=;
  b=d07ZCaUlde/SAiAKuqt5kO5bknl9nklo5JNvqUXXEkZFU1i6L+acpVul
   I7qCHhi2Oip8xWY0+vAXgYNdH/fx60M8lVkzpBBMr2ARymELJb9uUiH9E
   C31mCPhkERdghocWgoHc1CufBTuytN9CTQc73rEMIMNNVsC+IS77DGOW2
   sfy71XUl72R45YAdUFtvy0F9XQD9hLCnvkIB0mwJQ4R2kCsRyeiWUkPZr
   1/IUvct9BkZuBw4SH894h+k5563xYhs7ogpMAFTyOWhfUr7cq+imu75I6
   TYvx3FZVTcp+wgVNbd0Ihv72bZ6fIpdtcs+V5jNeU9UA1SHwMNAN0cFON
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="389860359"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="389860359"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:41:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="849062185"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="849062185"
Received: from b49691a74c3c.jf.intel.com ([10.165.59.100])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Oct 2023 01:41:56 -0700
From:   Huang Jiaqing <jiaqing.huang@intel.com>
To:     joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
Cc:     jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, jiaqing.huang@intel.com
Subject: [PATCH 1/2] iommu: Introduce a rb_tree for looking up device
Date:   Tue, 24 Oct 2023 01:41:23 -0700
Message-Id: <20231024084124.11155-1-jiaqing.huang@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing IO page fault handler locates the PCI device by calling
pci_get_domain_bus_and_slot(), which searches the list of all PCI
devices until the desired PCI device is found. This is inefficient
because the algorithm efficiency of searching a list is O(n). In the
critical path of handling an IO page fault, this is not performance
friendly given that I/O page fault handling patch is performance
critical, and parallel heavy dsa_test may cause cpu stuck due to
the low efficiency and lock competition in current path.

To improve the performance of the IO page fault handler, replace
pci_get_domain_bus_and_slot() with a local red-black tree. A red-black
tree is a self-balancing binary search tree, which means that the
average time complexity of searching a red-black tree is O(log(n)). This
is significantly faster than O(n), so it can significantly improve the
performance of the IO page fault handler.

In addition, we can only insert the affected devices (those that have IO
page fault enabled) into the red-black tree. This can further improve
the performance of the IO page fault handler.

This series depends on "deliver page faults to user space" patch-set:
https://lore.kernel.org/linux-iommu/20230928042734.16134-1-baolu.lu@linux.intel.com/

Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
---
 drivers/iommu/io-pgfault.c | 104 ++++++++++++++++++++++++++++++++++++-
 include/linux/iommu.h      |  16 ++++++
 2 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 1dbacc4fdf72..68e85dc6b1b6 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -7,6 +7,7 @@
 
 #include <linux/iommu.h>
 #include <linux/list.h>
+#include <linux/pci.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -392,6 +393,55 @@ int iopf_queue_discard_partial(struct iopf_queue *queue)
 }
 EXPORT_SYMBOL_GPL(iopf_queue_discard_partial);
 
+static int iopf_queue_pci_rbtree_insert(struct iopf_queue *queue, struct pci_dev *pdev)
+{
+	int ret;
+	struct rb_node **new, *parent = NULL;
+	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(&pdev->dev);
+
+	if (!iopf_param)
+		return -ENODEV;
+
+	down_write(&queue->pci_dev_sem);
+	new = &(queue->pci_dev_rbtree.rb_node);
+	while (*new) {
+		struct iommu_fault_param *this = container_of(*new, struct iommu_fault_param, node);
+		struct pci_dev *this_pdev = to_pci_dev(this->dev);
+		s16 result = RB_NODE_CMP(pdev->bus->number, pdev->devfn, this_pdev->bus->number, this_pdev->devfn);
+
+		parent = *new;
+		if (result < 0)
+			new = &((*new)->rb_left);
+		else if (result > 0)
+			new = &((*new)->rb_right);
+		else {
+			ret = -EEXIST;
+			goto err_unlock;
+		}
+	}
+
+	rb_link_node(&iopf_param->node, parent, new);
+	rb_insert_color(&iopf_param->node, &queue->pci_dev_rbtree);
+
+	up_write(&queue->pci_dev_sem);
+	return 0;
+err_unlock:
+	up_write(&queue->pci_dev_sem);
+	iopf_put_dev_fault_param(iopf_param);
+	return ret;
+}
+
+/* Caller must have inserted iopf_param by calling iopf_queue_pci_rbtree_insert() */
+static void iopf_queue_pci_rbtree_remove(struct iopf_queue *queue, struct iommu_fault_param *iopf_param)
+{
+	down_write(&queue->pci_dev_sem);
+	rb_erase(&iopf_param->node, &queue->pci_dev_rbtree);
+	up_write(&queue->pci_dev_sem);
+
+	/* paired with iopf_queue_pci_rbtree_insert() */
+	iopf_put_dev_fault_param(iopf_param);
+}
+
 /**
  * iopf_queue_add_device - Add producer to the fault queue
  * @queue: IOPF queue
@@ -434,7 +484,13 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
 
-	return ret;
+	if (ret)
+		return ret;
+
+	if (dev_is_pci(dev))
+		return iopf_queue_pci_rbtree_insert(queue, to_pci_dev(dev));
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_add_device);
 
@@ -486,7 +542,13 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
 
-	return ret;
+	if (ret)
+		return ret;
+
+	if (dev_is_pci(dev))
+		iopf_queue_pci_rbtree_remove(queue, fault_param);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
 
@@ -519,6 +581,9 @@ struct iopf_queue *iopf_queue_alloc(const char *name)
 	INIT_LIST_HEAD(&queue->devices);
 	mutex_init(&queue->lock);
 
+	queue->pci_dev_rbtree = RB_ROOT;
+	init_rwsem(&queue->pci_dev_sem);
+
 	return queue;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_alloc);
@@ -544,3 +609,38 @@ void iopf_queue_free(struct iopf_queue *queue)
 	kfree(queue);
 }
 EXPORT_SYMBOL_GPL(iopf_queue_free);
+
+/**
+ * iopf_queue_find_pdev - Lookup pci device in iopf_queue rbtree
+ * @queue: IOPF queue
+ * @bus: bus number of pci device to lookup
+ * @devfn: devfn of pci device to lookup
+ *
+ * Return: the pci device on success and NULL on not found.
+ */
+struct pci_dev *iopf_queue_find_pdev(struct iopf_queue *queue, u8 bus, u8 devfn)
+{
+	struct iommu_fault_param *data = NULL;
+	struct pci_dev *pdev = NULL;
+	struct rb_node *node;
+
+	down_read(&queue->pci_dev_sem);
+
+	node = queue->pci_dev_rbtree.rb_node;
+	while (node) {
+		data = container_of(node, struct iommu_fault_param, node);
+		pdev = to_pci_dev(data->dev);
+		s16 result = RB_NODE_CMP(bus, devfn, pdev->bus->number, pdev->devfn);
+
+		if (result < 0)
+			node = node->rb_left;
+		else if (result > 0)
+			node = node->rb_right;
+		else
+			break;
+	}
+	up_read(&queue->pci_dev_sem);
+
+	return node ? pdev : NULL;
+}
+EXPORT_SYMBOL_GPL(iopf_queue_find_pdev);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index bcec7e91dfc4..b29bbb0d1843 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -136,11 +136,15 @@ struct iopf_group {
  * @wq: the fault workqueue
  * @devices: devices attached to this queue
  * @lock: protects the device list
+ * @pci_dev_rbtree: pci devices for looking up
+ * @pci_dev_sem: protects the rb_tree
  */
 struct iopf_queue {
 	struct workqueue_struct *wq;
 	struct list_head devices;
 	struct mutex lock;
+	struct rb_root pci_dev_rbtree;
+	struct rw_semaphore pci_dev_sem;
 };
 
 /* iommu fault flags */
@@ -483,6 +487,8 @@ struct iommu_device {
 	u32 max_pasids;
 };
 
+#define RB_NODE_CMP(bus1, devfn1, bus2, devfn2) ((s16)(PCI_DEVID(bus1, devfn1) - PCI_DEVID(bus2, devfn2)))
+
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @lock: protect pending faults list
@@ -494,6 +500,7 @@ struct iommu_device {
  * @partial: faults that are part of a Page Request Group for which the last
  *           request hasn't been submitted yet.
  * @faults: holds the pending faults which needs response
+ * @node: pci device tracking node(lookup by (bus, devfn))
  */
 struct iommu_fault_param {
 	struct mutex lock;
@@ -505,6 +512,7 @@ struct iommu_fault_param {
 
 	struct list_head partial;
 	struct list_head faults;
+	struct rb_node node;
 };
 
 /**
@@ -1286,6 +1294,8 @@ int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
+struct pci_dev *iopf_queue_find_pdev(struct iopf_queue *queue,
+				u8 bus, u8 devfn);
 void iopf_free_group(struct iopf_group *group);
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 int iommu_page_response(struct device *dev, struct iommu_page_response *msg);
@@ -1321,6 +1331,12 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
 	return -ENODEV;
 }
 
+static inline struct pci_dev *iopf_queue_find_pdev(struct iopf_queue *queue,
+						u8 bus, u8 devfn)
+{
+	return NULL;
+}
+
 static inline void iopf_free_group(struct iopf_group *group)
 {
 }
-- 
2.31.1

