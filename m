Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254B846031D
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242582AbhK1C42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:56:28 -0500
Received: from mga18.intel.com ([134.134.136.126]:39764 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhK1Cy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:54:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="222672285"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208,223";a="222672285"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:51:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208,223";a="652488925"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:51:04 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 01/17] iommu: Add device dma ownership set/release interfaces
Date:   Sun, 28 Nov 2021 10:50:35 +0800
Message-Id: <20211128025051.355578-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From the perspective of who is initiating the device to do DMA, device
DMA could be divided into the following types:

        DMA_OWNER_DMA_API: Device DMAs are initiated by a kernel driver
			through the kernel DMA API.
        DMA_OWNER_PRIVATE_DOMAIN: Device DMAs are initiated by a kernel
			driver with its own PRIVATE domain.
	DMA_OWNER_PRIVATE_DOMAIN_USER: Device DMAs are initiated by
			userspace.

Different DMA ownerships are exclusive for all devices in the same iommu
group as an iommu group is the smallest granularity of device isolation
and protection that the IOMMU subsystem can guarantee. This extends the
iommu core to enforce this exclusion.

Basically two new interfaces are provided:

        int iommu_device_set_dma_owner(struct device *dev,
                enum iommu_dma_owner type, void *owner_cookie);
        void iommu_device_release_dma_owner(struct device *dev,
                enum iommu_dma_owner type);

Although above interfaces are per-device, DMA owner is tracked per group
under the hood. An iommu group cannot have different dma ownership set
at the same time. Violation of this assumption fails
iommu_device_set_dma_owner().

Kernel driver which does DMA have DMA_OWNER_DMA_API automatically set/
released in the driver binding/unbinding process (see next patch).

Kernel driver which doesn't do DMA could avoid setting the owner type.
Device bound to such driver is considered same as a driver-less device
which is compatible to all owner types.

Userspace driver framework (e.g. vfio) should set
DMA_OWNER_PRIVATE_DOMAIN_USER for a device before the userspace is allowed
to access it, plus a owner cookie pointer to mark the user identity so a
single group cannot be operated by multiple users simultaneously. Vice
versa, the owner type should be released after the user access permission
is withdrawn.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 36 +++++++++++++++++
 drivers/iommu/iommu.c | 93 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2f3435e7d17..24676b498f38 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -162,6 +162,23 @@ enum iommu_dev_features {
 	IOMMU_DEV_FEAT_IOPF,
 };
 
+/**
+ * enum iommu_dma_owner - IOMMU DMA ownership
+ * @DMA_OWNER_NONE: No DMA ownership.
+ * @DMA_OWNER_DMA_API: Device DMAs are initiated by a kernel driver through
+ *			the kernel DMA API.
+ * @DMA_OWNER_PRIVATE_DOMAIN: Device DMAs are initiated by a kernel driver
+ *			which provides an UNMANAGED domain.
+ * @DMA_OWNER_PRIVATE_DOMAIN_USER: Device DMAs are initiated by userspace,
+ *			kernel ensures that DMAs never go to kernel memory.
+ */
+enum iommu_dma_owner {
+	DMA_OWNER_NONE,
+	DMA_OWNER_DMA_API,
+	DMA_OWNER_PRIVATE_DOMAIN,
+	DMA_OWNER_PRIVATE_DOMAIN_USER,
+};
+
 #define IOMMU_PASID_INVALID	(-1U)
 
 #ifdef CONFIG_IOMMU_API
@@ -681,6 +698,10 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
+int iommu_device_set_dma_owner(struct device *dev, enum iommu_dma_owner owner,
+			       void *owner_cookie);
+void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner);
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1081,6 +1102,21 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
 }
+
+static inline int iommu_device_set_dma_owner(struct device *dev,
+					     enum iommu_dma_owner owner,
+					     void *owner_cookie)
+{
+	if (owner != DMA_OWNER_DMA_API)
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
index 8b86406b7162..1de520a07518 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -48,6 +48,9 @@ struct iommu_group {
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
+	enum iommu_dma_owner dma_owner;
+	refcount_t owner_cnt;
+	void *owner_cookie;
 };
 
 struct group_device {
@@ -621,6 +624,7 @@ struct iommu_group *iommu_group_alloc(void)
 	INIT_LIST_HEAD(&group->devices);
 	INIT_LIST_HEAD(&group->entry);
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
+	group->dma_owner = DMA_OWNER_NONE;
 
 	ret = ida_simple_get(&iommu_group_ida, 0, 0, GFP_KERNEL);
 	if (ret < 0) {
@@ -3351,3 +3355,92 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 	return ret;
 }
+
+static int __iommu_group_set_dma_owner(struct iommu_group *group,
+				       enum iommu_dma_owner owner,
+				       void *owner_cookie)
+{
+	if (refcount_inc_not_zero(&group->owner_cnt)) {
+		if (group->dma_owner != owner ||
+		    group->owner_cookie != owner_cookie) {
+			refcount_dec(&group->owner_cnt);
+			return -EBUSY;
+		}
+
+		return 0;
+	}
+
+	group->dma_owner = owner;
+	group->owner_cookie = owner_cookie;
+	refcount_set(&group->owner_cnt, 1);
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
+	if (!refcount_dec_and_test(&group->owner_cnt))
+		return;
+
+	group->dma_owner = DMA_OWNER_NONE;
+}
+
+/**
+ * iommu_device_set_dma_owner() - Set DMA ownership of a device
+ * @dev: The device.
+ * @owner: DMA ownership type.
+ * @owner_cookie: Caller specified pointer. Could be used for exclusive
+ *                declaration. Could be NULL.
+ *
+ * Set the DMA ownership of a device. The different ownerships are
+ * exclusive. The caller could specify a owner_cookie pointer so that
+ * the same DMA ownership could be exclusive among different owners.
+ */
+int iommu_device_set_dma_owner(struct device *dev, enum iommu_dma_owner owner,
+			       void *owner_cookie)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+	int ret;
+
+	if (!group) {
+		if (owner == DMA_OWNER_DMA_API)
+			return 0;
+		else
+			return -ENODEV;
+	}
+
+	mutex_lock(&group->mutex);
+	ret = __iommu_group_set_dma_owner(group, owner, owner_cookie);
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
+ * @owner: The DMA ownership type.
+ *
+ * Release the DMA ownership claimed by iommu_device_set_dma_owner().
+ */
+void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+
+	if (!group) {
+		WARN_ON(owner != DMA_OWNER_DMA_API);
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

