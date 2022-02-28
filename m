Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDE64C606B
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 01:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiB1Ayw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 19:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiB1Ayu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 19:54:50 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB447063;
        Sun, 27 Feb 2022 16:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646009640; x=1677545640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VohBJ0mLVRX99N211IVtR1yA93DL6NDJ2YrVaFpMmak=;
  b=RkvBQFPgrNeTNBip1pDWoHrxj8o7rLL80oQbUa4E9mlvqJzl1U8d0CJF
   9uetPiNVQWLWsCU+D9M/yII/Q6Yb/h0CPHAiloe/fCn/I5s5ZLXDJugim
   zL5JspfZGXLP7NNphNobcPYfUCSvG62ZgUjhHuIbummgb+ELbJaA0MaIa
   qCOpPmFqLGK2r9bjBA72a2qGk1s0ugGMMAMZ5COk2kPBodoGzgy6DPZcB
   XuyCVz0M82aErUzCq30VgBH9XiKLV+bpy3yMe8196PgWuthz4b4F+2nUq
   Ied4P8A8vJdzYqdKlGbEubjjfhoUZxXE3+YWniZnvkLNCRtIK9BCJvSQc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="236280304"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="236280304"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 16:53:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="550020343"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2022 16:53:47 -0800
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
Subject: [PATCH v7 10/11] vfio: Remove iommu group notifier
Date:   Mon, 28 Feb 2022 08:50:55 +0800
Message-Id: <20220228005056.599595-11-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228005056.599595-1-baolu.lu@linux.intel.com>
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu core and driver core have been enhanced to avoid unsafe driver
binding to a live group after iommu_group_set_dma_owner(PRIVATE_USER)
has been called. There's no need to register iommu group notifier. This
removes the iommu group notifer which contains BUG_ON() and WARN().

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 147 --------------------------------------------
 1 file changed, 147 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e0df2bc692b2..dd3fac0d6bc9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -71,7 +71,6 @@ struct vfio_group {
 	struct vfio_container		*container;
 	struct list_head		device_list;
 	struct mutex			device_lock;
-	struct notifier_block		nb;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
 	atomic_t			opened;
@@ -274,8 +273,6 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
 
-static int vfio_iommu_group_notifier(struct notifier_block *nb,
-				     unsigned long action, void *data);
 static void vfio_group_get(struct vfio_group *group);
 
 /*
@@ -395,13 +392,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 		goto err_put;
 	}
 
-	group->nb.notifier_call = vfio_iommu_group_notifier;
-	err = iommu_group_register_notifier(iommu_group, &group->nb);
-	if (err) {
-		ret = ERR_PTR(err);
-		goto err_put;
-	}
-
 	mutex_lock(&vfio.group_lock);
 
 	/* Did we race creating this group? */
@@ -422,7 +412,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 
 err_unlock:
 	mutex_unlock(&vfio.group_lock);
-	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
 err_put:
 	put_device(&group->dev);
 	return ret;
@@ -447,7 +436,6 @@ static void vfio_group_put(struct vfio_group *group)
 	cdev_device_del(&group->cdev, &group->dev);
 	mutex_unlock(&vfio.group_lock);
 
-	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
 	put_device(&group->dev);
 }
 
@@ -503,141 +491,6 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
 	return NULL;
 }
 
-/*
- * Some drivers, like pci-stub, are only used to prevent other drivers from
- * claiming a device and are therefore perfectly legitimate for a user owned
- * group.  The pci-stub driver has no dependencies on DMA or the IOVA mapping
- * of the device, but it does prevent the user from having direct access to
- * the device, which is useful in some circumstances.
- *
- * We also assume that we can include PCI interconnect devices, ie. bridges.
- * IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
- * then all of the downstream devices will be part of the same IOMMU group as
- * the bridge.  Thus, if placing the bridge into the user owned IOVA space
- * breaks anything, it only does so for user owned devices downstream.  Note
- * that error notification via MSI can be affected for platforms that handle
- * MSI within the same IOVA space as DMA.
- */
-static const char * const vfio_driver_allowed[] = { "pci-stub" };
-
-static bool vfio_dev_driver_allowed(struct device *dev,
-				    struct device_driver *drv)
-{
-	if (dev_is_pci(dev)) {
-		struct pci_dev *pdev = to_pci_dev(dev);
-
-		if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
-			return true;
-	}
-
-	return match_string(vfio_driver_allowed,
-			    ARRAY_SIZE(vfio_driver_allowed),
-			    drv->name) >= 0;
-}
-
-/*
- * A vfio group is viable for use by userspace if all devices are in
- * one of the following states:
- *  - driver-less
- *  - bound to a vfio driver
- *  - bound to an otherwise allowed driver
- *  - a PCI interconnect device
- *
- * We use two methods to determine whether a device is bound to a vfio
- * driver.  The first is to test whether the device exists in the vfio
- * group.  The second is to test if the device exists on the group
- * unbound_list, indicating it's in the middle of transitioning from
- * a vfio driver to driver-less.
- */
-static int vfio_dev_viable(struct device *dev, void *data)
-{
-	struct vfio_group *group = data;
-	struct vfio_device *device;
-	struct device_driver *drv = READ_ONCE(dev->driver);
-
-	if (!drv || vfio_dev_driver_allowed(dev, drv))
-		return 0;
-
-	device = vfio_group_get_device(group, dev);
-	if (device) {
-		vfio_device_put(device);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-/*
- * Async device support
- */
-static int vfio_group_nb_add_dev(struct vfio_group *group, struct device *dev)
-{
-	struct vfio_device *device;
-
-	/* Do we already know about it?  We shouldn't */
-	device = vfio_group_get_device(group, dev);
-	if (WARN_ON_ONCE(device)) {
-		vfio_device_put(device);
-		return 0;
-	}
-
-	/* Nothing to do for idle groups */
-	if (!atomic_read(&group->container_users))
-		return 0;
-
-	/* TODO Prevent device auto probing */
-	dev_WARN(dev, "Device added to live group %d!\n",
-		 iommu_group_id(group->iommu_group));
-
-	return 0;
-}
-
-static int vfio_group_nb_verify(struct vfio_group *group, struct device *dev)
-{
-	/* We don't care what happens when the group isn't in use */
-	if (!atomic_read(&group->container_users))
-		return 0;
-
-	return vfio_dev_viable(dev, group);
-}
-
-static int vfio_iommu_group_notifier(struct notifier_block *nb,
-				     unsigned long action, void *data)
-{
-	struct vfio_group *group = container_of(nb, struct vfio_group, nb);
-	struct device *dev = data;
-
-	switch (action) {
-	case IOMMU_GROUP_NOTIFY_ADD_DEVICE:
-		vfio_group_nb_add_dev(group, dev);
-		break;
-	case IOMMU_GROUP_NOTIFY_DEL_DEVICE:
-		/*
-		 * Nothing to do here.  If the device is in use, then the
-		 * vfio sub-driver should block the remove callback until
-		 * it is unused.  If the device is unused or attached to a
-		 * stub driver, then it should be released and we don't
-		 * care that it will be going away.
-		 */
-		break;
-	case IOMMU_GROUP_NOTIFY_BIND_DRIVER:
-		dev_dbg(dev, "%s: group %d binding to driver\n", __func__,
-			iommu_group_id(group->iommu_group));
-		break;
-	case IOMMU_GROUP_NOTIFY_BOUND_DRIVER:
-		dev_dbg(dev, "%s: group %d bound to driver %s\n", __func__,
-			iommu_group_id(group->iommu_group), dev->driver->name);
-		BUG_ON(vfio_group_nb_verify(group, dev));
-		break;
-	case IOMMU_GROUP_NOTIFY_UNBIND_DRIVER:
-		dev_dbg(dev, "%s: group %d unbinding from driver %s\n",
-			__func__, iommu_group_id(group->iommu_group),
-			dev->driver->name);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
 /*
  * VFIO driver API
  */
-- 
2.25.1

