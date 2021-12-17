Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FD34784FF
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 07:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhLQGho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 01:37:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:46331 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233288AbhLQGhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 01:37:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="238435806"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208,223";a="238435806"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:37:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208,223";a="519623112"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 16 Dec 2021 22:37:35 -0800
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
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 01/13] iommu: Add device dma ownership set/release interfaces
Date:   Fri, 17 Dec 2021 14:36:56 +0800
Message-Id: <20211217063708.1740334-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
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
 include/linux/iommu.h | 34 ++++++++++++++++
 drivers/iommu/iommu.c | 95 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2f3435e7d17..53a023ee1ac0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -162,6 +162,21 @@ enum iommu_dev_features {
 	IOMMU_DEV_FEAT_IOPF,
 };
 
+/**
+ * enum iommu_dma_owner - IOMMU DMA ownership
+ * @DMA_OWNER_DMA_API: Device DMAs are initiated by a kernel driver through
+ *			the kernel DMA API.
+ * @DMA_OWNER_PRIVATE_DOMAIN: Device DMAs are initiated by a kernel driver
+ *			which provides an UNMANAGED domain.
+ * @DMA_OWNER_PRIVATE_DOMAIN_USER: Device DMAs are initiated by userspace,
+ *			kernel ensures that DMAs never go to kernel memory.
+ */
+enum iommu_dma_owner {
+	DMA_OWNER_DMA_API,
+	DMA_OWNER_PRIVATE_DOMAIN,
+	DMA_OWNER_PRIVATE_DOMAIN_USER,
+};
+
 #define IOMMU_PASID_INVALID	(-1U)
 
 #ifdef CONFIG_IOMMU_API
@@ -681,6 +696,10 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
+int iommu_device_set_dma_owner(struct device *dev, enum iommu_dma_owner owner,
+			       void *owner_cookie);
+void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner);
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1081,6 +1100,21 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
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
index 8b86406b7162..5439bf45afb2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -48,6 +48,9 @@ struct iommu_group {
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
+	enum iommu_dma_owner dma_owner;
+	unsigned int owner_cnt;
+	void *owner_cookie;
 };
 
 struct group_device {
@@ -3351,3 +3354,95 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 	return ret;
 }
+
+static int iommu_group_set_dma_owner(struct iommu_group *group,
+				     enum iommu_dma_owner owner,
+				     void *owner_cookie)
+{
+	int ret = 0;
+
+	mutex_lock(&group->mutex);
+	if (group->owner_cnt &&
+	    (group->dma_owner != owner ||
+	     group->owner_cookie != owner_cookie)) {
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+
+	group->dma_owner = owner;
+	group->owner_cookie = owner_cookie;
+	group->owner_cnt++;
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+static void iommu_group_release_dma_owner(struct iommu_group *group,
+					  enum iommu_dma_owner owner)
+{
+	mutex_lock(&group->mutex);
+	if (WARN_ON(!group->owner_cnt || group->dma_owner != owner))
+		goto unlock_out;
+
+	if (--group->owner_cnt > 0)
+		goto unlock_out;
+
+	group->dma_owner = DMA_OWNER_DMA_API;
+
+unlock_out:
+	mutex_unlock(&group->mutex);
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
+	ret = iommu_group_set_dma_owner(group, owner, owner_cookie);
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
+	iommu_group_release_dma_owner(group, owner);
+	iommu_group_put(group);
+}
+EXPORT_SYMBOL_GPL(iommu_device_release_dma_owner);
-- 
2.25.1

