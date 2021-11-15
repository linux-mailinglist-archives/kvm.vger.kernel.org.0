Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1537844FCFA
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhKOCOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:14:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:44502 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236292AbhKOCNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:13:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233204636"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208,223";a="233204636"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:10:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208,223";a="505714533"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:10:26 -0800
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
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 01/11] iommu: Add device dma ownership set/release interfaces
Date:   Mon, 15 Nov 2021 10:05:42 +0800
Message-Id: <20211115020552.2378167-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From the perspective of who is initiating the device to do DMA, device
DMA could be divided into the following types:

        DMA_OWNER_KERNEL: kernel device driver intiates the DMA
        DMA_OWNER_USER: userspace device driver intiates the DMA

DMA_OWNER_KERNEL and DMA_OWNER_USER are exclusive for all devices in
same iommu group as an iommu group is the smallest granularity of device
isolation and protection that the IOMMU subsystem can guarantee. This
extends the iommu core to enforce this exclusion when devices are
assigned to userspace.

Basically two new interfaces are provided:

        int iommu_device_set_dma_owner(struct device *dev,
                enum iommu_dma_owner mode, struct file *user_file);
        void iommu_device_release_dma_owner(struct device *dev,
                enum iommu_dma_owner mode);

Although above interfaces are per-device, DMA owner is tracked per group
under the hood. An iommu group cannot have both DMA_OWNER_KERNEL
and DMA_OWNER_USER set at the same time. Violation of this assumption
fails iommu_device_set_dma_owner().

Kernel driver which does DMA have DMA_OWNER_KENREL automatically
set/released in the driver binding process (see next patch).

Kernel driver which doesn't do DMA should not set the owner type (via a
new suppress flag in next patch). Device bound to such driver is considered
same as a driver-less device which is compatible to all owner types.

Userspace driver framework (e.g. vfio) should set DMA_OWNER_USER for
a device before the userspace is allowed to access it, plus a fd pointer to
mark the user identity so a single group cannot be operated by multiple
users simultaneously. Vice versa, the owner type should be released after
the user access permission is withdrawn.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h |  31 ++++++++++++
 drivers/iommu/iommu.c | 106 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2f3435e7d17..f77eb9e7788a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -162,6 +162,18 @@ enum iommu_dev_features {
 	IOMMU_DEV_FEAT_IOPF,
 };
 
+/**
+ * enum iommu_dma_owner - IOMMU DMA ownership
+ * @DMA_OWNER_NONE: No DMA ownership
+ * @DMA_OWNER_KERNEL: Device DMAs are initiated by a kernel driver
+ * @DMA_OWNER_USER: Device DMAs are initiated by a userspace driver
+ */
+enum iommu_dma_owner {
+	DMA_OWNER_NONE,
+	DMA_OWNER_KERNEL,
+	DMA_OWNER_USER,
+};
+
 #define IOMMU_PASID_INVALID	(-1U)
 
 #ifdef CONFIG_IOMMU_API
@@ -681,6 +693,10 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
+int iommu_device_set_dma_owner(struct device *dev, enum iommu_dma_owner owner,
+			       struct file *user_file);
+void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner);
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1081,6 +1097,21 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
 }
+
+static inline int iommu_device_set_dma_owner(struct device *dev,
+					     enum iommu_dma_owner owner,
+					     struct file *user_file)
+{
+	if (owner != DMA_OWNER_KERNEL)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline void iommu_device_release_dma_owner(struct device *dev,
+						  enum iommu_dma_owner owner)
+{
+}
 #endif /* CONFIG_IOMMU_API */
 
 /**
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8b86406b7162..39493b1b3edf 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -26,6 +26,7 @@
 #include <linux/fsl/mc.h>
 #include <linux/module.h>
 #include <linux/cc_platform.h>
+#include <linux/file.h>
 #include <trace/events/iommu.h>
 
 static struct kset *iommu_group_kset;
@@ -48,6 +49,9 @@ struct iommu_group {
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
+	enum iommu_dma_owner dma_owner;
+	refcount_t owner_cnt;
+	struct file *owner_user_file;
 };
 
 struct group_device {
@@ -621,6 +625,7 @@ struct iommu_group *iommu_group_alloc(void)
 	INIT_LIST_HEAD(&group->devices);
 	INIT_LIST_HEAD(&group->entry);
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
+	group->dma_owner = DMA_OWNER_NONE;
 
 	ret = ida_simple_get(&iommu_group_ida, 0, 0, GFP_KERNEL);
 	if (ret < 0) {
@@ -3351,3 +3356,104 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 	return ret;
 }
+
+static int __iommu_group_set_dma_owner(struct iommu_group *group,
+				       enum iommu_dma_owner owner,
+				       struct file *user_file)
+{
+	if (group->dma_owner != DMA_OWNER_NONE && group->dma_owner != owner)
+		return -EBUSY;
+
+	if (owner == DMA_OWNER_USER) {
+		if (!user_file)
+			return -EINVAL;
+
+		if (group->owner_user_file && group->owner_user_file != user_file)
+			return -EPERM;
+	}
+
+	if (!refcount_inc_not_zero(&group->owner_cnt)) {
+		group->dma_owner = owner;
+		refcount_set(&group->owner_cnt, 1);
+
+		if (owner == DMA_OWNER_USER) {
+			get_file(user_file);
+			group->owner_user_file = user_file;
+		}
+	}
+
+	return 0;
+}
+
+static void __iommu_group_release_dma_owner(struct iommu_group *group,
+					    enum iommu_dma_owner owner)
+{
+	if (WARN_ON(group->dma_owner != owner))
+		return;
+
+	if (refcount_dec_and_test(&group->owner_cnt)) {
+		group->dma_owner = DMA_OWNER_NONE;
+
+		if (owner == DMA_OWNER_USER) {
+			fput(group->owner_user_file);
+			group->owner_user_file = NULL;
+		}
+	}
+}
+
+/**
+ * iommu_device_set_dma_owner() - Set DMA ownership of a device
+ * @dev: The device.
+ * @owner: DMA_OWNER_KERNEL or DMA_OWNER_USER.
+ * @user_file: The device fd when DMA_OWNER_USER is about to set.
+ *
+ * Set the DMA ownership of a device. The KERNEL and USER ownership are
+ * exclusive. For DMA_OWNER_USER, the caller should also specify the fd
+ * through which the I/O address spaces are managed for the target device.
+ * This interface guarantees that the USER DMA ownership is only assigned
+ * to the same fd.
+ */
+int iommu_device_set_dma_owner(struct device *dev, enum iommu_dma_owner owner,
+			       struct file *user_file)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+	int ret;
+
+	if (!group) {
+		if (owner == DMA_OWNER_KERNEL)
+			return 0;
+		else
+			return -ENODEV;
+	}
+
+	mutex_lock(&group->mutex);
+	ret = __iommu_group_set_dma_owner(group, owner, user_file);
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_device_set_dma_owner);
+
+/**
+ * iommu_device_release_dma_owner() - Release DMA ownership of a device
+ * @dev: The device.
+ * @owner: DMA_OWNER_KERNEL or DMA_OWNER_USER.
+ *
+ * Release the DMA ownership claimed by iommu_device_set_dma_owner().
+ */
+void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+
+	if (!group) {
+		WARN_ON(owner != DMA_OWNER_KERNEL);
+		return;
+	}
+
+	mutex_lock(&group->mutex);
+	__iommu_group_release_dma_owner(group, owner);
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+}
+EXPORT_SYMBOL_GPL(iommu_device_release_dma_owner);
-- 
2.25.1

