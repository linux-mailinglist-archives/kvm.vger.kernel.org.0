Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD13410A3E
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhISGn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:43:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:37215 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236912AbhISGnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="223042919"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="223042919"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701919"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:41:50 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 04/20] iommu: Add iommu_device_get_info interface
Date:   Sun, 19 Sep 2021 14:38:32 +0800
Message-Id: <20210919063848.1476776-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

This provides an interface for upper layers to get the per-device iommu
attributes.

    int iommu_device_get_info(struct device *dev,
                              enum iommu_devattr attr, void *data);

The first attribute (IOMMU_DEV_INFO_FORCE_SNOOP) is added. It tells if
the iommu can force DMA to snoop cache. At this stage, only PCI devices
which have this attribute set could use the iommufd, this is due to
supporting no-snoop DMA requires additional refactoring work on the
current kvm-vfio contract. The following patch will have vfio check this
attribute to decide whether a pci device can be exposed through
/dev/vfio/devices.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 16 ++++++++++++++++
 include/linux/iommu.h | 19 +++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 63f0af10c403..5ea3a007fd7c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3260,3 +3260,19 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 	return ret;
 }
+
+/* Expose per-device iommu attributes. */
+int iommu_device_get_info(struct device *dev, enum iommu_devattr attr, void *data)
+{
+	const struct iommu_ops *ops;
+
+	if (!dev->bus || !dev->bus->iommu_ops)
+		return -EINVAL;
+
+	ops = dev->bus->iommu_ops;
+	if (unlikely(!ops->device_info))
+		return -ENODEV;
+
+	return ops->device_info(dev, attr, data);
+}
+EXPORT_SYMBOL_GPL(iommu_device_get_info);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 32d448050bf7..52a6d33c82dc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -150,6 +150,14 @@ enum iommu_dev_features {
 	IOMMU_DEV_FEAT_IOPF,
 };
 
+/**
+ * enum iommu_devattr - Per device IOMMU attributes
+ * @IOMMU_DEV_INFO_FORCE_SNOOP [bool]: IOMMU can force DMA to be snooped.
+ */
+enum iommu_devattr {
+	IOMMU_DEV_INFO_FORCE_SNOOP,
+};
+
 #define IOMMU_PASID_INVALID	(-1U)
 
 #ifdef CONFIG_IOMMU_API
@@ -215,6 +223,7 @@ struct iommu_iotlb_gather {
  *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
  *		- 0: use the default setting
+ * @device_info: query per-device iommu attributes
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  * @owner: Driver module providing these ops
  */
@@ -283,6 +292,8 @@ struct iommu_ops {
 
 	int (*def_domain_type)(struct device *dev);
 
+	int (*device_info)(struct device *dev, enum iommu_devattr attr, void *data);
+
 	unsigned long pgsize_bitmap;
 	struct module *owner;
 };
@@ -604,6 +615,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
+int iommu_device_get_info(struct device *dev, enum iommu_devattr attr, void *data);
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -999,6 +1012,12 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
 }
+
+static inline int iommu_device_get_info(struct device *dev,
+					enum iommu_devattr type, void *data)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_IOMMU_API */
 
 /**
-- 
2.25.1

