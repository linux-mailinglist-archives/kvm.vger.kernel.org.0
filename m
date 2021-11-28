Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312D946033C
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353541AbhK1C5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:57:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:64288 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240025AbhK1Czf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:55:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="235619895"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="235619895"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:52:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="652489097"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:52:13 -0800
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
Subject: [PATCH v2 11/17] iommu: Add iommu_at[de]tach_device_shared() for multi-device groups
Date:   Sun, 28 Nov 2021 10:50:45 +0800
Message-Id: <20211128025051.355578-12-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
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
---
 include/linux/iommu.h | 13 +++++++++
 drivers/iommu/iommu.c | 61 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index afcc07bc8d41..8c81ba11ae8c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -705,6 +705,8 @@ int iommu_group_set_dma_owner(struct iommu_group *group, enum iommu_dma_owner ow
 			      void *owner_cookie);
 void iommu_group_release_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner);
 bool iommu_group_dma_owner_unclaimed(struct iommu_group *group);
+int iommu_attach_device_shared(struct iommu_domain *domain, struct device *dev);
+void iommu_detach_device_shared(struct iommu_domain *domain, struct device *dev);
 
 #else /* CONFIG_IOMMU_API */
 
@@ -745,11 +747,22 @@ static inline int iommu_attach_device(struct iommu_domain *domain,
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
index 423197db99a9..f9cb96acbac8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -50,6 +50,7 @@ struct iommu_group {
 	struct list_head entry;
 	enum iommu_dma_owner dma_owner;
 	refcount_t owner_cnt;
+	refcount_t attach_cnt;
 	void *owner_cookie;
 };
 
@@ -2026,6 +2027,41 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
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
+	if (refcount_inc_not_zero(&group->attach_cnt)) {
+		if (group->domain != domain ||
+		    (group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN &&
+		     group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER)) {
+			refcount_dec(&group->attach_cnt);
+			ret = -EBUSY;
+		}
+
+		goto unlock_out;
+	}
+
+	ret = __iommu_attach_group(domain, group);
+	if (ret)
+		goto unlock_out;
+
+	refcount_set(&group->owner_cnt, 1);
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_attach_device_shared);
+
 int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 {
 	const struct iommu_ops *ops = domain->ops;
@@ -2281,6 +2317,31 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
+void iommu_detach_device_shared(struct iommu_domain *domain, struct device *dev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return;
+
+	mutex_lock(&group->mutex);
+	if (WARN_ON(group->domain != domain ||
+		    (group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN &&
+		     group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER)))
+		goto unlock_out;
+
+	if (refcount_dec_and_test(&group->owner_cnt)) {
+		__iommu_detach_group(domain, group);
+		group->dma_owner = DMA_OWNER_NONE;
+	}
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_device_shared);
+
 struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
 {
 	struct iommu_domain *domain;
-- 
2.25.1

