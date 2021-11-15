Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DB544FD03
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhKOCQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:16:34 -0500
Received: from mga12.intel.com ([192.55.52.136]:64444 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236431AbhKOCOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:14:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="213398885"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="213398885"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:11:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="505714747"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:11:19 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/11] iommu: Remove iommu group changes notifier
Date:   Mon, 15 Nov 2021 10:05:52 +0800
Message-Id: <20211115020552.2378167-12-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu group changes notifer is not referenced in the tree. Remove it
to avoid dead code.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 23 -------------
 drivers/iommu/iommu.c | 75 -------------------------------------------
 2 files changed, 98 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3d2dfd220d3c..d8946f22edd5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -414,13 +414,6 @@ static inline void iommu_iotlb_gather_init(struct iommu_iotlb_gather *gather)
 	};
 }
 
-#define IOMMU_GROUP_NOTIFY_ADD_DEVICE		1 /* Device added */
-#define IOMMU_GROUP_NOTIFY_DEL_DEVICE		2 /* Pre Device removed */
-#define IOMMU_GROUP_NOTIFY_BIND_DRIVER		3 /* Pre Driver bind */
-#define IOMMU_GROUP_NOTIFY_BOUND_DRIVER		4 /* Post Driver bind */
-#define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
-#define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
-
 extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern int bus_iommu_probe(struct bus_type *bus);
 extern bool iommu_present(struct bus_type *bus);
@@ -493,10 +486,6 @@ extern int iommu_group_for_each_dev(struct iommu_group *group, void *data,
 extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
-extern int iommu_group_register_notifier(struct iommu_group *group,
-					 struct notifier_block *nb);
-extern int iommu_group_unregister_notifier(struct iommu_group *group,
-					   struct notifier_block *nb);
 extern int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
 					void *data);
@@ -897,18 +886,6 @@ static inline void iommu_group_put(struct iommu_group *group)
 {
 }
 
-static inline int iommu_group_register_notifier(struct iommu_group *group,
-						struct notifier_block *nb)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_group_unregister_notifier(struct iommu_group *group,
-						  struct notifier_block *nb)
-{
-	return 0;
-}
-
 static inline
 int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3dcd3fc4290a..064d0679906a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/iommu.h>
 #include <linux/idr.h>
-#include <linux/notifier.h>
 #include <linux/err.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
@@ -41,7 +40,6 @@ struct iommu_group {
 	struct kobject *devices_kobj;
 	struct list_head devices;
 	struct mutex mutex;
-	struct blocking_notifier_head notifier;
 	void *iommu_data;
 	void (*iommu_data_release)(void *iommu_data);
 	char *name;
@@ -628,7 +626,6 @@ struct iommu_group *iommu_group_alloc(void)
 	mutex_init(&group->mutex);
 	INIT_LIST_HEAD(&group->devices);
 	INIT_LIST_HEAD(&group->entry);
-	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 	group->dma_owner = DMA_OWNER_NONE;
 
 	ret = ida_simple_get(&iommu_group_ida, 0, 0, GFP_KERNEL);
@@ -904,10 +901,6 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 	if (ret)
 		goto err_put_group;
 
-	/* Notify any listeners about change to group. */
-	blocking_notifier_call_chain(&group->notifier,
-				     IOMMU_GROUP_NOTIFY_ADD_DEVICE, dev);
-
 	trace_add_device_to_group(group->id, dev);
 
 	dev_info(dev, "Adding to iommu group %d\n", group->id);
@@ -949,10 +942,6 @@ void iommu_group_remove_device(struct device *dev)
 
 	dev_info(dev, "Removing from iommu group %d\n", group->id);
 
-	/* Pre-notify listeners that a device is being removed. */
-	blocking_notifier_call_chain(&group->notifier,
-				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
-
 	mutex_lock(&group->mutex);
 	list_for_each_entry(tmp_device, &group->devices, list) {
 		if (tmp_device->dev == dev) {
@@ -1075,36 +1064,6 @@ void iommu_group_put(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_put);
 
-/**
- * iommu_group_register_notifier - Register a notifier for group changes
- * @group: the group to watch
- * @nb: notifier block to signal
- *
- * This function allows iommu group users to track changes in a group.
- * See include/linux/iommu.h for actions sent via this notifier.  Caller
- * should hold a reference to the group throughout notifier registration.
- */
-int iommu_group_register_notifier(struct iommu_group *group,
-				  struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&group->notifier, nb);
-}
-EXPORT_SYMBOL_GPL(iommu_group_register_notifier);
-
-/**
- * iommu_group_unregister_notifier - Unregister a notifier
- * @group: the group to watch
- * @nb: notifier block to signal
- *
- * Unregister a previously registered group notifier block.
- */
-int iommu_group_unregister_notifier(struct iommu_group *group,
-				    struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&group->notifier, nb);
-}
-EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
-
 /**
  * iommu_register_device_fault_handler() - Register a device fault handler
  * @dev: the device
@@ -1653,14 +1612,8 @@ static int remove_iommu_group(struct device *dev, void *data)
 static int iommu_bus_notifier(struct notifier_block *nb,
 			      unsigned long action, void *data)
 {
-	unsigned long group_action = 0;
 	struct device *dev = data;
-	struct iommu_group *group;
 
-	/*
-	 * ADD/DEL call into iommu driver ops if provided, which may
-	 * result in ADD/DEL notifiers to group->notifier
-	 */
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		int ret;
 
@@ -1671,34 +1624,6 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	/*
-	 * Remaining BUS_NOTIFYs get filtered and republished to the
-	 * group, if anyone is listening
-	 */
-	group = iommu_group_get(dev);
-	if (!group)
-		return 0;
-
-	switch (action) {
-	case BUS_NOTIFY_BIND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_BIND_DRIVER;
-		break;
-	case BUS_NOTIFY_BOUND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_BOUND_DRIVER;
-		break;
-	case BUS_NOTIFY_UNBIND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_UNBIND_DRIVER;
-		break;
-	case BUS_NOTIFY_UNBOUND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER;
-		break;
-	}
-
-	if (group_action)
-		blocking_notifier_call_chain(&group->notifier,
-					     group_action, dev);
-
-	iommu_group_put(group);
 	return 0;
 }
 
-- 
2.25.1

