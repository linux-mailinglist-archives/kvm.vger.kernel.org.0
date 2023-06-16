Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510A2732BD3
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344536AbjFPJbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343992AbjFPJbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:31:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C930DD;
        Fri, 16 Jun 2023 02:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686907850; x=1718443850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnP4t9PbX+rwljBW/SAHyInvgy635ijpPseLsCUYOmU=;
  b=EYSvImMyWsD6fSNN8lkEgyzBf4CHzn8jJcBfgvvizn4apn2clFb5JWna
   Elswa1ysPFO2OefIPEOrGJQoLgaebsAySTzOGEgEdN9aeUnx14Isdooly
   kVgwEA4AfNN0HhN+p6wR1wd+z7BbXTXCSJ63LDpbTfQQCNObPvFvGVQZL
   XCM6hScCSgBeoPJbfZeiQo1CE7CLeUtf8Le0iscAJS/PWBiq0DZSybLoV
   sB0bRgFvUmkmqLisibkIY7m1F5tEA5xL6sVwh2+7eM2uekIygcbwey0FJ
   YedoHEc23lS76x/prXi4uQ2FLvurm8BjXhHUr8hwU3K3JD2CHW/r5fABO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387863527"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="387863527"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 02:30:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742601954"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="742601954"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2023 02:30:49 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v8 08/10] vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Date:   Fri, 16 Jun 2023 02:30:40 -0700
Message-Id: <20230616093042.65094-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616093042.65094-1-yi.l.liu@intel.com>
References: <20230616093042.65094-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl use the iommufd_ctx
of the cdev device to check the ownership of the other affected devices.

When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD managed
device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is reported to indicate
the values returned are IOMMUFD devids rather than group IDs as used when
accessing vfio devices through the conventional vfio group interface.
Additionally the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be reported
in this mode if all of the devices affected by the hot-reset are owned by
either virtue of being directly bound to the same iommufd context as the
calling device, or implicitly owned via a shared IOMMU group.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c           | 44 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 54 +++++++++++++++++++++++++++-----
 include/linux/vfio.h             | 14 +++++++++
 include/uapi/linux/vfio.h        | 50 ++++++++++++++++++++++++++++-
 4 files changed, 154 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 88b00c501015..afda47ee9663 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -66,6 +66,50 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 		vdev->ops->unbind_iommufd(vdev);
 }
 
+struct iommufd_ctx *vfio_iommufd_device_ictx(struct vfio_device *vdev)
+{
+	if (vdev->iommufd_device)
+		return iommufd_device_to_ictx(vdev->iommufd_device);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_device_ictx);
+
+static int vfio_iommufd_device_id(struct vfio_device *vdev)
+{
+	if (vdev->iommufd_device)
+		return iommufd_device_to_id(vdev->iommufd_device);
+	return -EINVAL;
+}
+
+/*
+ * Return devid for a device.
+ *  valid ID for the device that is owned by the ictx
+ *  -ENOENT = device is owned but there is no ID
+ *  -ENODEV or other error = device is not owned
+ */
+int vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+{
+	struct iommu_group *group;
+	int devid;
+
+	if (vfio_iommufd_device_ictx(vdev) == ictx)
+		return vfio_iommufd_device_id(vdev);
+
+	group = iommu_group_get(vdev->dev);
+	if (!group)
+		return -ENODEV;
+
+	if (iommufd_ctx_has_group(ictx, group))
+		devid = -ENOENT;
+	else
+		devid = -ENODEV;
+
+	iommu_group_put(group);
+
+	return devid;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_get_dev_id);
+
 /*
  * The physical standard ops mean that the iommufd_device is bound to the
  * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6f13161dca6b..65e3ee5255a6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,6 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#include <linux/iommufd.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -779,26 +780,56 @@ struct vfio_pci_fill_info {
 	int max;
 	int cur;
 	struct vfio_pci_dependent_device *devices;
+	struct vfio_device *vdev;
+	u32 flags;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_pci_fill_info *fill = data;
-	struct iommu_group *iommu_group;
 
 	if (fill->cur == fill->max)
 		return -EAGAIN; /* Something changed, try again */
 
-	iommu_group = iommu_group_get(&pdev->dev);
-	if (!iommu_group)
-		return -EPERM; /* Cannot reset non-isolated devices */
+	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
+		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
+		struct vfio_device_set *dev_set = fill->vdev->dev_set;
+		struct vfio_device *vdev;
 
-	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+		/*
+		 * hot-reset requires all affected devices be represented in
+		 * the dev_set.
+		 */
+		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
+		if (!vdev) {
+			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
+		} else {
+			int id = vfio_iommufd_get_dev_id(vdev, iommufd);
+
+			if (id > 0)
+				fill->devices[fill->cur].devid = id;
+			else if (id == -ENOENT)
+				fill->devices[fill->cur].devid = VFIO_PCI_DEVID_OWNED;
+			else
+				fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
+		}
+		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
+		if (fill->devices[fill->cur].devid == VFIO_PCI_DEVID_NOT_OWNED)
+			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
+	} else {
+		struct iommu_group *iommu_group;
+
+		iommu_group = iommu_group_get(&pdev->dev);
+		if (!iommu_group)
+			return -EPERM; /* Cannot reset non-isolated devices */
+
+		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+		iommu_group_put(iommu_group);
+	}
 	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
 	fill->devices[fill->cur].bus = pdev->bus->number;
 	fill->devices[fill->cur].devfn = pdev->devfn;
 	fill->cur++;
-	iommu_group_put(iommu_group);
 	return 0;
 }
 
@@ -1232,17 +1263,26 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 		return -ENOMEM;
 
 	fill.devices = devices;
+	fill.vdev = &vdev->vdev;
 
+	if (vfio_device_cdev_opened(&vdev->vdev))
+		fill.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID |
+			     VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
+
+	mutex_lock(&vdev->vdev.dev_set->lock);
 	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
 					    &fill, slot);
+	mutex_unlock(&vdev->vdev.dev_set->lock);
 
 	/*
 	 * If a device was removed between counting and filling, we may come up
 	 * short of fill.max.  If a device was added, we'll have a return of
 	 * -EAGAIN above.
 	 */
-	if (!ret)
+	if (!ret) {
 		hdr.count = fill.cur;
+		hdr.flags = fill.flags;
+	}
 
 reset_info_exit:
 	if (copy_to_user(arg, &hdr, minsz))
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ee120d2d530b..7079911edfb1 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -114,6 +114,8 @@ struct vfio_device_ops {
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
+struct iommufd_ctx *vfio_iommufd_device_ictx(struct vfio_device *vdev);
+int vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx);
 int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
@@ -123,6 +125,18 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 #else
+static inline struct iommufd_ctx *
+vfio_iommufd_device_ictx(struct vfio_device *vdev)
+{
+	return NULL;
+}
+
+static inline int
+vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+{
+	return VFIO_PCI_DEVID_NOT_OWNED;
+}
+
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
 		  u32 *out_device_id)) NULL)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 1a36134cae5c..d7deb5acad62 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -653,11 +653,57 @@ enum {
  * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
  *
+ * This command is used to query the affected devices in the hot reset for
+ * a given device.
+ *
+ * This command always reports the segment, bus, and devfn information for
+ * each affected device, and selectively reports the group_id or devid per
+ * the way how the calling device is opened.
+ *
+ *	- If the calling device is opened via the traditional group/container
+ *	  API, group_id is reported.  User should check if it has owned all
+ *	  the affected devices and provides a set of group fds to prove the
+ *	  ownership in VFIO_DEVICE_PCI_HOT_RESET ioctl.
+ *
+ *	- If the calling device is opened as a cdev, devid is reported.
+ *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set to indicate this
+ *	  data type.  All the affected devices should be represented in
+ *	  the dev_set, ex. bound to a vfio driver, and also be owned by
+ *	  this interface which is determined by the following conditions:
+ *	  1) Has a valid devid within the iommufd_ctx of the calling device.
+ *	     Ownership cannot be determined across separate iommufd_ctx and
+ *	     the cdev calling conventions do not support a proof-of-ownership
+ *	     model as provided in the legacy group interface.  In this case
+ *	     valid devid with value greater than zero is provided in the return
+ *	     structure.
+ *	  2) Does not have a valid devid within the iommufd_ctx of the calling
+ *	     device, but belongs to the same IOMMU group as the calling device
+ *	     or another opened device that has a valid devid within the
+ *	     iommufd_ctx of the calling device.  This provides implicit ownership
+ *	     for devices within the same DMA isolation context.  In this case
+ *	     the devid value of VFIO_PCI_DEVID_OWNED is provided in the return
+ *	     structure.
+ *
+ *	  A devid value of VFIO_PCI_DEVID_NOT_OWNED is provided in the return
+ *	  structure for affected devices where device is NOT represented in the
+ *	  dev_set or ownership is not available.  Such devices prevent the use
+ *	  of VFIO_DEVICE_PCI_HOT_RESET ioctl outside of the proof-of-ownership
+ *	  calling conventions (ie. via legacy group accessed devices).  Flag
+ *	  VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
+ *	  affected devices are represented in the dev_set and also owned by
+ *	  the user.  This flag is available only when
+ *	  flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
+ *
  * Return: 0 on success, -errno on failure:
  *	-enospc = insufficient buffer, -enodev = unsupported for device.
  */
 struct vfio_pci_dependent_device {
-	__u32	group_id;
+	union {
+		__u32   group_id;
+		__u32	devid;
+#define VFIO_PCI_DEVID_OWNED		0
+#define VFIO_PCI_DEVID_NOT_OWNED	-1
+	};
 	__u16	segment;
 	__u8	bus;
 	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
@@ -666,6 +712,8 @@ struct vfio_pci_dependent_device {
 struct vfio_pci_hot_reset_info {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID		(1 << 0)
+#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED	(1 << 1)
 	__u32	count;
 	struct vfio_pci_dependent_device	devices[];
 };
-- 
2.34.1

