Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBCB478520
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 07:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhLQGid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 01:38:33 -0500
Received: from mga07.intel.com ([134.134.136.100]:40614 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233382AbhLQGic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 01:38:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="303069179"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="303069179"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:38:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="519623298"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 16 Dec 2021 22:38:23 -0800
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
Subject: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for multi-device groups
Date:   Fri, 17 Dec 2021 14:37:02 +0800
Message-Id: <20211217063708.1740334-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_attach/detach_device() interfaces were exposed for the device
drivers to attach/detach their own domains. The commit <426a273834eae>
("iommu: Limit iommu_attach/detach_device to device with their own group")
restricted them to singleton groups to avoid different device in a group
attaching different domain.

As we've introduced device DMA ownership into the iommu core. We can now
introduce interfaces for muliple-device groups, and "all devices are in the
same address space" is still guaranteed.

The iommu_attach/detach_device_shared() could be used when multiple drivers
sharing the group claim the DMA_OWNER_PRIVATE_DOMAIN ownership. The first
call of iommu_attach_device_shared() attaches the domain to the group.
Other drivers could join it later. The domain will be detached from the
group after all drivers unjoin it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
---
 include/linux/iommu.h | 13 +++++++
 drivers/iommu/iommu.c | 79 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5ad4cf13370d..1bc03118dfb3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -703,6 +703,8 @@ int iommu_group_set_dma_owner(struct iommu_group *group, enum iommu_dma_owner ow
 			      void *owner_cookie);
 void iommu_group_release_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner);
 bool iommu_group_dma_owner_unclaimed(struct iommu_group *group);
+int iommu_attach_device_shared(struct iommu_domain *domain, struct device *dev);
+void iommu_detach_device_shared(struct iommu_domain *domain, struct device *dev);
 
 #else /* CONFIG_IOMMU_API */
 
@@ -743,11 +745,22 @@ static inline int iommu_attach_device(struct iommu_domain *domain,
 	return -ENODEV;
 }
 
+static inline int iommu_attach_device_shared(struct iommu_domain *domain,
+					     struct device *dev)
+{
+	return -ENODEV;
+}
+
 static inline void iommu_detach_device(struct iommu_domain *domain,
 				       struct device *dev)
 {
 }
 
+static inline void iommu_detach_device_shared(struct iommu_domain *domain,
+					      struct device *dev)
+{
+}
+
 static inline struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
 {
 	return NULL;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8bec71b1cc18..3ad66cb9bedc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -50,6 +50,7 @@ struct iommu_group {
 	struct list_head entry;
 	enum iommu_dma_owner dma_owner;
 	unsigned int owner_cnt;
+	unsigned int attach_cnt;
 	void *owner_cookie;
 };
 
@@ -3512,3 +3513,81 @@ void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner own
 	iommu_group_put(group);
 }
 EXPORT_SYMBOL_GPL(iommu_device_release_dma_owner);
+
+/**
+ * iommu_attach_device_shared() - Attach shared domain to a device
+ * @domain: The shared domain.
+ * @dev: The device.
+ *
+ * Similar to iommu_attach_device(), but allowed for shared-group devices
+ * and guarantees that all devices in an iommu group could only be attached
+ * by a same iommu domain. The caller should explicitly set the dma ownership
+ * of DMA_OWNER_PRIVATE_DOMAIN or DMA_OWNER_PRIVATE_DOMAIN_USER type before
+ * calling it and use the paired helper iommu_detach_device_shared() for
+ * cleanup.
+ */
+int iommu_attach_device_shared(struct iommu_domain *domain, struct device *dev)
+{
+	struct iommu_group *group;
+	int ret = 0;
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return -ENODEV;
+
+	mutex_lock(&group->mutex);
+	if (group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN &&
+	    group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER) {
+		ret = -EPERM;
+		goto unlock_out;
+	}
+
+	if (group->attach_cnt) {
+		if (group->domain != domain) {
+			ret = -EBUSY;
+			goto unlock_out;
+		}
+	} else {
+		ret = __iommu_attach_group(domain, group);
+		if (ret)
+			goto unlock_out;
+	}
+
+	group->attach_cnt++;
+unlock_out:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_attach_device_shared);
+
+/**
+ * iommu_detach_device_shared() - Detach a domain from device
+ * @domain: The domain.
+ * @dev: The device.
+ *
+ * The detach helper paired with iommu_attach_device_shared().
+ */
+void iommu_detach_device_shared(struct iommu_domain *domain, struct device *dev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return;
+
+	mutex_lock(&group->mutex);
+	if (WARN_ON(!group->attach_cnt || group->domain != domain ||
+		    (group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN &&
+		     group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER)))
+		goto unlock_out;
+
+	if (--group->attach_cnt == 0)
+		__iommu_detach_group(domain, group);
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_device_shared);
-- 
2.25.1

