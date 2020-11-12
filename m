Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663D82AFECC
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 06:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgKLFi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 00:38:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:53611 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbgKLCbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 21:31:17 -0500
IronPort-SDR: 1Vbx+1fYqMdm+i0eNsQuRrVP+w7/4XAzEjqjLlS60VZmAVBrSZEBV2Z+wX+yZ3mcOiDJWafhkl
 RBWBR/AGQI0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="158027947"
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="158027947"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 18:31:14 -0800
IronPort-SDR: RqmfoNvjRlzJ+AZ0ZVwfPxQdbl9++xpGWOTNcFQUqDkXqk2nSnkuemt/WizPYJwrPXhU8GCLmI
 pSM7JC62A6xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="366450979"
Received: from allen-box.sh.intel.com ([10.239.159.28])
  by orsmga007.jf.intel.com with ESMTP; 11 Nov 2020 18:31:10 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] vfio/type1: Add subdev_ioasid callback to vfio_iommu_driver_ops
Date:   Thu, 12 Nov 2020 10:24:07 +0800
Message-Id: <20201112022407.2063896-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add API for getting the ioasid of a subdevice (vfio/mdev). This calls
into the backend IOMMU module to get the actual value or error number
if ioasid for subdevice is not supported. The physical device driver
implementations which rely on the vfio/mdev framework for mediated
device user level access could typically consume this interface like
below:

	struct device *dev = mdev_dev(mdev);
	unsigned int pasid;
	int ret;

	ret = vfio_subdev_ioasid(dev, &pasid);
	if (ret < 0)
		return ret;

         /* Program device context with pasid value. */
         ....

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio.c             | 34 ++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 57 +++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  4 +++
 3 files changed, 95 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2151bc7f87ab..4931e1492921 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2331,6 +2331,40 @@ int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
 }
 EXPORT_SYMBOL(vfio_unregister_notifier);
 
+int vfio_subdev_ioasid(struct device *dev, unsigned int *id)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+	struct vfio_group *group;
+	int ret;
+
+	if (!dev || !id)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto out;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->subdev_ioasid))
+		ret = driver->ops->subdev_ioasid(container->iommu_data,
+						 group->iommu_group, id);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+out:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL(vfio_subdev_ioasid);
+
 /**
  * Module/class support
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 67e827638995..f94cc7707d7e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2980,6 +2980,62 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	return ret;
 }
 
+static int vfio_iommu_type1_subdev_ioasid(void *iommu_data,
+					  struct iommu_group *iommu_group,
+					  unsigned int *id)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *domain = NULL, *d;
+	struct device *iommu_device = NULL;
+	struct bus_type *bus = NULL;
+	int ret;
+
+	if (!iommu || !iommu_group || !id)
+		return -EINVAL;
+
+	mutex_lock(&iommu->lock);
+	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
+	if (ret)
+		goto out;
+
+	if (!vfio_bus_is_mdev(bus)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = iommu_group_for_each_dev(iommu_group, &iommu_device,
+				       vfio_mdev_iommu_device);
+	if (ret || !iommu_device ||
+	    !iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		if (find_iommu_group(d, iommu_group)) {
+			domain = d;
+			break;
+		}
+	}
+
+	if (!domain) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = iommu_aux_get_pasid(domain->domain, iommu_device);
+	if (ret > 0) {
+		*id = ret;
+		ret = 0;
+	} else {
+		ret = -ENOSPC;
+	}
+
+out:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -2993,6 +3049,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
+	.subdev_ioasid		= vfio_iommu_type1_subdev_ioasid,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a8dc7e..6dcf09a2796d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -90,6 +90,9 @@ struct vfio_iommu_driver_ops {
 					       struct notifier_block *nb);
 	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
 				  void *data, size_t count, bool write);
+	int		(*subdev_ioasid)(void *iommu_data,
+					 struct iommu_group *group,
+					 unsigned int *id);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -125,6 +128,7 @@ extern int vfio_group_unpin_pages(struct vfio_group *group,
 
 extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
 		       void *data, size_t len, bool write);
+extern int vfio_subdev_ioasid(struct device *dev, unsigned int *id);
 
 /* each type has independent events */
 enum vfio_notify_type {
-- 
2.25.1

