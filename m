Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F26701701
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbjEMNV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238461AbjEMNVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:21:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F864204;
        Sat, 13 May 2023 06:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984111; x=1715520111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WT52gKHGSak5vPDkA73jE4i14CaOOE70paj3Kw9bXfg=;
  b=bxV7urcQz1sobjt9oS5MzkW/BbZ2HvVn9mqwQLQvu+ZrW5MROYKggs4o
   hgYf1K6oWvo1Nj9nH7Fg5++3UF/i6Azn5MZQExxg7IDnlgYzyQsSEKlgw
   OUq3gMRDYGwOKCvg5FPWtrDbHXakX040+EiIC3k7WLywi4Q9gXeOB2Ie5
   1SNjYA1EX584dzyZlhCBHGfyu3Y1YkNqEk3vzqzm0xfh9n2ns+d4JE4Hr
   Gc0gOKWhi/nfYft/vswKFkmG+csLlVkEBqLSQffZnr5R7deC2rE1gE6wL
   VZ1t/VA7t8G/iXC0Ns4rEQ0ftWsnBLJkaNrHrkHQcyC8hOlm/JZo45Hof
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="416599038"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="416599038"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:21:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="790126478"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="790126478"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2023 06:21:50 -0700
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
Subject: [PATCH v5 09/10] vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Date:   Sat, 13 May 2023 06:21:35 -0700
Message-Id: <20230513132136.15021-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230513132136.15021-1-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl to use the iommufd_ctx
of the cdev device to check the ownership of the other affected devices.

This returns devid for each of the affected devices. If it is bound to the
iommufd_ctx of the cdev device, _INFO reports a valid devid > 0; If it is
not opened by the calling user, but it belongs to the same iommu_group of
a device that is bound to the iommufd_ctx of the cdev device, reports devid
value of 0; If the device is un-owned device, configured within a different
iommufd, or opened outside of the vfio device cdev API, the _INFO ioctl shall
report devid value of -1.

devid >=0 doesn't block hot-reset as the affected devices are considered to
be owned, while devid == -1 will block the use of VFIO_DEVICE_PCI_HOT_RESET
outside of proof-of-ownership calling conventions (ie. via legacy group
accessed devices).

This adds flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID to tell the user devid is
returned in case of calling user get device fd from other software stack
and adds flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED to tell user if all
the affected devices are owned, so user can know it without looping all
the returned devids.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 52 ++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h        | 46 +++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 4df2def35bdd..57586be770af 100644
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
@@ -36,6 +37,10 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC "core driver for VFIO based PCI devices"
 
+#ifdef CONFIG_IOMMUFD
+MODULE_IMPORT_NS(IOMMUFD);
+#endif
+
 static bool nointxmask;
 static bool disable_vga;
 static bool disable_idle_d3;
@@ -776,6 +781,9 @@ struct vfio_pci_fill_info {
 	int max;
 	int cur;
 	struct vfio_pci_dependent_device *devices;
+	struct vfio_device *vdev;
+	bool devid:1;
+	bool dev_owned:1;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
@@ -790,7 +798,37 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 	if (!iommu_group)
 		return -EPERM; /* Cannot reset non-isolated devices */
 
-	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	if (fill->devid) {
+		struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(fill->vdev);
+		struct vfio_device_set *dev_set = fill->vdev->dev_set;
+		struct vfio_device *vdev;
+
+		/*
+		 * Report devid for the affected devices:
+		 * - valid devid > 0 for the devices that are bound with
+		 *   the iommufd of the calling device.
+		 * - devid == 0 for the devices that have not been opened
+		 *   but have same group with one of the devices bound to
+		 *   the iommufd of the calling device.
+		 * - devid == -1 for others, and clear dev_owned flag.
+		 */
+		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
+		if (vdev && iommufd == vfio_iommufd_physical_ictx(vdev)) {
+			int ret;
+
+			ret = vfio_iommufd_physical_devid(vdev);
+			if (WARN_ON(ret < 0))
+				return ret;
+			fill->devices[fill->cur].devid = ret;
+		} else if (vdev && iommufd_ctx_has_group(iommufd, iommu_group)) {
+			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_OWNED;
+		} else {
+			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
+			fill->dev_owned = false;
+		}
+	} else {
+		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	}
 	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
 	fill->devices[fill->cur].bus = pdev->bus->number;
 	fill->devices[fill->cur].devfn = pdev->devfn;
@@ -1229,17 +1267,27 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 		return -ENOMEM;
 
 	fill.devices = devices;
+	fill.vdev = &vdev->vdev;
 
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	fill.devid = fill.dev_owned = vfio_device_cdev_opened(&vdev->vdev);
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
+		if (fill.devid) {
+			hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID;
+			if (fill.dev_owned)
+				hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
+		}
+	}
 
 reset_info_exit:
 	if (copy_to_user(arg, &hdr, minsz))
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..01203215251a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -650,11 +650,53 @@ enum {
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
+ *	  data type.  For a given affected device, it is considered owned by
+ *	  this interface if it meets the following conditions:
+ *	  1) Has a valid devid within the iommufd_ctx of the calling device.
+ *	     Ownership cannot be determined across separate iommufd_ctx and the
+ *	     cdev calling conventions do not support a proof-of-ownership model
+ *	     as provided in the legacy group interface.  In this case a valid
+ *	     devid with value greater than zero is provided in the return
+ *	     structure.
+ *	  2) Does not have a valid devid within the iommufd_ctx of the calling
+ *	     device, but belongs to the same IOMMU group as the calling device
+ *	     or another opened device that has a valid devid within the
+ *	     iommufd_ctx of the calling device.  This provides implicit ownership
+ *	     for devices within the same DMA isolation context.  In this case
+ *	     the invalid devid value of zero is provided in the return structure.
+ *
+ *	  A devid value of -1 is provided in the return structure for devices
+ *	  where ownership is not available.  Such devices prevent the use of
+ *	  VFIO_DEVICE_PCI_HOT_RESET outside of proof-of-ownership calling
+ *	  conventions (ie. via legacy group accessed devices).
+ *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
+ *	  affected devices are owned by the user.  This flag is available only
+ *	  when VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
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
@@ -663,6 +705,8 @@ struct vfio_pci_dependent_device {
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

