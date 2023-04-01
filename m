Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE476D319A
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjDAOoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjDAOon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E701DFB1;
        Sat,  1 Apr 2023 07:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360281; x=1711896281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p64YHQtdhIkzhEK1tO8XIf7bxcuE3M+6sbnj/z7LnJY=;
  b=bShBW/y5fjhOikPm2pGnCHIfTOJipesdhm2DJUbPrzn792IpkJTiAm5n
   4gCQGZEEixsfoxWwDxS8N5LWIgYHpx2Y959Cr5UbEWqLkpjW7uLNY32C4
   1IlVvt2yQ3RsF26LG6CGQ/914vPGklT4xPVCdgtOBAhknSGKIq7bYPB51
   5bugxqtzpgGlEukyzAVlW6FuAfqp6CJ6Fcv8iCQDCtKSAoFVlLiHc+KAF
   1ac8bi+2WisY3RKgBvyj8U+po5DbXxLkplF6NIkDPV/5O5ywVRP4ZGhCb
   MYhpem7duvzQasXeh2WZZKUvu0aqnfrDDaKWOkfATXmpOEd3JsvZlHvbd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385183"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385183"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705864"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705864"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:41 -0700
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
        yanting.jiang@intel.com
Subject: [PATCH v3 12/12] vfio/pci: Report dev_id in VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Date:   Sat,  1 Apr 2023 07:44:29 -0700
Message-Id: <20230401144429.88673-13-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401144429.88673-1-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

for the users that accept device fds passed from management stacks to be
able to figure out the host reset affected devices among the devices
opened by the user. This is needed as such users do not have BDF (bus,
devfn) knowledge about the devices it has opened, hence unable to use
the information reported by existing VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
to figure out the affected devices.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 58 ++++++++++++++++++++++++++++----
 include/uapi/linux/vfio.h        | 24 ++++++++++++-
 2 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 19f5b075d70a..a5a7e148dce1 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -30,6 +30,7 @@
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
+#include <uapi/linux/iommufd.h>
 
 #include "vfio_pci_priv.h"
 
@@ -767,6 +768,20 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 	return 0;
 }
 
+static struct vfio_device *
+vfio_pci_find_device_in_devset(struct vfio_device_set *dev_set,
+			       struct pci_dev *pdev)
+{
+	struct vfio_device *cur;
+
+	lockdep_assert_held(&dev_set->lock);
+
+	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
+		if (cur->dev == &pdev->dev)
+			return cur;
+	return NULL;
+}
+
 static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 {
 	(*(int *)data)++;
@@ -776,13 +791,20 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 struct vfio_pci_fill_info {
 	int max;
 	int cur;
+	bool require_devid;
+	struct iommufd_ctx *iommufd;
+	struct vfio_device_set *dev_set;
 	struct vfio_pci_dependent_device *devices;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_pci_fill_info *fill = data;
+	struct vfio_device_set *dev_set = fill->dev_set;
 	struct iommu_group *iommu_group;
+	struct vfio_device *vdev;
+
+	lockdep_assert_held(&dev_set->lock);
 
 	if (fill->cur == fill->max)
 		return -EAGAIN; /* Something changed, try again */
@@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 	if (!iommu_group)
 		return -EPERM; /* Cannot reset non-isolated devices */
 
-	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	if (fill->require_devid) {
+		/*
+		 * Report dev_id of the devices that are opened as cdev
+		 * and have the same iommufd with the fill->iommufd.
+		 * Otherwise, just fill IOMMUFD_INVALID_ID.
+		 */
+		vdev = vfio_pci_find_device_in_devset(dev_set, pdev);
+		if (vdev && vfio_device_cdev_opened(vdev) &&
+		    fill->iommufd == vfio_iommufd_physical_ictx(vdev))
+			vfio_iommufd_physical_devid(vdev, &fill->devices[fill->cur].dev_id);
+		else
+			fill->devices[fill->cur].dev_id = IOMMUFD_INVALID_ID;
+	} else {
+		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	}
 	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
 	fill->devices[fill->cur].bus = pdev->bus->number;
 	fill->devices[fill->cur].devfn = pdev->devfn;
@@ -1230,17 +1266,27 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 		return -ENOMEM;
 
 	fill.devices = devices;
+	fill.dev_set = vdev->vdev.dev_set;
 
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	if (vfio_device_cdev_opened(&vdev->vdev)) {
+		fill.require_devid = true;
+		fill.iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
+	}
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
+		if (fill.require_devid)
+			hdr.flags = VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID;
+	}
 
 reset_info_exit:
 	if (copy_to_user(arg, &hdr, minsz))
@@ -2346,12 +2392,10 @@ static bool vfio_dev_in_files(struct vfio_pci_core_device *vdev,
 static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
 {
 	struct vfio_device_set *dev_set = data;
-	struct vfio_device *cur;
 
-	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
-		if (cur->dev == &pdev->dev)
-			return 0;
-	return -EBUSY;
+	lockdep_assert_held(&dev_set->lock);
+
+	return vfio_pci_find_device_in_devset(dev_set, pdev) ? 0 : -EBUSY;
 }
 
 /*
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 25432ef213ee..5a34364e3b94 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -650,11 +650,32 @@ enum {
  * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
  *
+ * This command is used to query the affected devices in the hot reset for
+ * a given device.  User could use the information reported by this command
+ * to figure out the affected devices among the devices it has opened.
+ * This command always reports the segment, bus and devfn information for
+ * each affected device, and selectively report the group_id or the dev_id
+ * per the way how the device being queried is opened.
+ *	- If the device is opened via the traditional group/container manner,
+ *	  this command reports the group_id for each affected device.
+ *
+ *	- If the device is opened as a cdev, this command needs to report
+ *	  dev_id for each affected device and set the
+ *	  VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID flag.  For the affected
+ *	  devices that are not opened as cdev or bound to different iommufds
+ *	  with the device that is queried, report an invalid dev_id to avoid
+ *	  potential dev_id conflict as dev_id is local to iommufd.  For such
+ *	  affected devices, user shall fall back to use the segment, bus and
+ *	  devfn info to map it to opened device.
+ *
  * Return: 0 on success, -errno on failure:
  *	-enospc = insufficient buffer, -enodev = unsupported for device.
  */
 struct vfio_pci_dependent_device {
-	__u32	group_id;
+	union {
+		__u32   group_id;
+		__u32	dev_id;
+	};
 	__u16	segment;
 	__u8	bus;
 	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
@@ -663,6 +684,7 @@ struct vfio_pci_dependent_device {
 struct vfio_pci_hot_reset_info {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID	(1 << 0)
 	__u32	count;
 	struct vfio_pci_dependent_device	devices[];
 };
-- 
2.34.1

