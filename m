Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65056EF6E5
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbjDZOyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241289AbjDZOyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368DC7A91;
        Wed, 26 Apr 2023 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520880; x=1714056880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J7uU8ORTy0thRx4RxPcQ82ksVnUJ4EqDibdEuTyIzGs=;
  b=FoP0ZGjlQ+Y+j+dE3BsBoPEoj0SMwPL5v80XQBKhQUiAp3PwQ2yvMxHB
   f1010PAxduknNDHl35yf/2zxAKl3EWuEeB//xZKanoHPTJr8CrkiN74J5
   hEB+GALVSg4l1tUAeqmjK/iQS0AhlGMYqax0ICsMJU3AwVn0dBcz7Ii5b
   AhWMSEGBfqq6u6BncH0L1sn4/fzzKvidokTXKpNs7xoUQKQLLMo6t2O4U
   n9a3vDwtRLuZL+ETZ2inxnTSUpySkiU+9aIabXVsXIA6o7zUUCpYNzfzw
   uVxuqqaBzLlIvqJvC9VVnDjLIgks5Z9e9MsUuwZ0d2LtKPt0vkRQltC/Y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410360"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758644064"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758644064"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:39 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v4 8/9] vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Date:   Wed, 26 Apr 2023 07:54:18 -0700
Message-Id: <20230426145419.450922-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426145419.450922-1-yi.l.liu@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl to use the bound
iommufd of the cdev device to check the ownership of the other affected
devices and set a flag to tell user if the cdev device is resettable
with a zero-length fd array.

For each of the affected devices, if it is bound to the iommufd of the
cdev device, _INFO reports a valid dev_id > 0; if it is not opened by
the calling user, but it is in the iommu_group of a device that is bound
to the iommufd of the cdev device, reports dev_id == 0; If the device is
un-owned device, configured within a different iommufd, or opened outside
of the vfio device cdev API, the _INFO ioctl shall report dev_id==-1 for
such affected devices. dev_id >=0 doesn't block hot-reset, while
dev_id == -1 will block hot-reset.

This adds flag VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID to tell the user
dev_id is returned and adds flag VFIO_PCI_HOT_RESET_FLAG_RESETTABLE to
tell user if the cdev device is resettable or not.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 101 ++++++++++++++++++++++++++++---
 include/uapi/linux/vfio.h        |  39 +++++++++++-
 2 files changed, 132 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 39e7823088e7..43858d471447 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -766,6 +766,51 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
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
+/*
+ * Check if a given iommu_group has been bound to an iommufd within a
+ * devset.  Returns true if there is device in the devset which is in
+ * the input iommu_group and meanwhile bound to the input iommufd.
+ * Otherwise, returns false.
+ */
+static bool
+vfio_devset_iommufd_has_group(struct vfio_device_set *dev_set,
+			      struct iommufd_ctx *iommufd,
+			      struct iommu_group *iommu_group)
+{
+	struct vfio_device *cur;
+	struct iommu_group *grp;
+	bool found = false;
+
+	lockdep_assert_held(&dev_set->lock);
+
+	list_for_each_entry(cur, &dev_set->device_list, dev_set_list) {
+		grp = iommu_group_get(cur->dev);
+		if (!grp)
+			continue;
+		iommu_group_put(grp);
+		if (iommu_group == grp &&
+		    iommufd == vfio_iommufd_physical_ictx(cur)) {
+			found = true;
+			break;
+		}
+	}
+	return found;
+}
+
 static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 {
 	(*(int *)data)++;
@@ -776,13 +821,20 @@ struct vfio_pci_fill_info {
 	int max;
 	int cur;
 	struct vfio_pci_dependent_device *devices;
+	struct vfio_device *vdev;
+	bool devid;
+	bool resettable;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_pci_fill_info *fill = data;
+	struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(fill->vdev);
+	struct vfio_device_set *dev_set = fill->vdev->dev_set;
 	struct iommu_group *iommu_group;
 
+	lockdep_assert_held(&dev_set->lock);
+
 	if (fill->cur == fill->max)
 		return -EAGAIN; /* Something changed, try again */
 
@@ -790,7 +842,34 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 	if (!iommu_group)
 		return -EPERM; /* Cannot reset non-isolated devices */
 
-	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	if (fill->devid) {
+		struct vfio_device *vdev;
+
+		/*
+		 * Report devid for the affected devices:
+		 * - valid devid > 0 for the devices that are bound with
+		 *   the iommufd of the calling device.
+		 * - devid == 0 for the devices that have not been opened
+		 *   but have same group with one of the devices bound to
+		 *   the iommufd of the calling device.
+		 * - devid == -1 for others, and clear resettable flag.
+		 */
+		vdev = vfio_pci_find_device_in_devset(dev_set, pdev);
+		if (vdev && iommufd == vfio_iommufd_physical_ictx(vdev)) {
+			fill->devices[fill->cur].dev_id =
+						vfio_iommufd_physical_devid(vdev);
+			if (unlikely(!fill->devices[fill->cur].dev_id))
+				return -EINVAL;
+		} else if (vfio_devset_iommufd_has_group(dev_set, iommufd,
+							 iommu_group)) {
+			fill->devices[fill->cur].dev_id = VFIO_PCI_DEVID_NONBLOCKING;
+		} else {
+			fill->devices[fill->cur].dev_id = VFIO_PCI_DEVID_BLOCKING;
+			fill->resettable = false;
+		}
+	} else {
+		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	}
 	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
 	fill->devices[fill->cur].bus = pdev->bus->number;
 	fill->devices[fill->cur].devfn = pdev->devfn;
@@ -1229,17 +1308,27 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 		return -ENOMEM;
 
 	fill.devices = devices;
+	fill.vdev = &vdev->vdev;
 
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	fill.devid = fill.resettable = vfio_device_cdev_opened(&vdev->vdev);
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
+			hdr.flags = VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID;
+			if (fill.resettable)
+				hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_RESETTABLE;
+		}
+	}
 
 reset_info_exit:
 	if (copy_to_user(arg, &hdr, minsz))
@@ -2335,12 +2424,10 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
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
index 0552e8dcf0cb..4b4e2c28984b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -650,11 +650,46 @@ enum {
  * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
  *
+ * This command is used to query the affected devices in the hot reset for
+ * a given device.
+ *
+ * This command always reports the segment, bus, and devfn information for
+ * each affected device, and selectively reports the group_id or dev_id per
+ * the way how the calling device is opened.
+ *
+ *	- If the calling device is opened via the traditional group/container
+ *	  API, group_id is reported.  User should check if it has owned all
+ *	  the affected devices and provides a set of group fds to prove the
+ *	  ownership in VFIO_DEVICE_PCI_HOT_RESET ioctl.
+ *
+ *	- If the calling device is opened as a cdev, dev_id is reported.
+ *	  Flag VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID would be set.  Flag
+ *	  VFIO_PCI_HOT_RESET_FLAG_RESETTABLE would be set per the ownership
+ *	  of the other affected devices.  If it is set, the user could invoke
+ *	  VFIO_DEVICE_PCI_HOT_RESET with a zero-length fd array.  Kernel
+ *	  set this flag when all the affected devices are owned by the user.
+ *	  This flag is available only VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID
+ *	  is set, otherwise ignored.  For a given affected device, it is owned
+ *	  if it suits one of the below cases:
+ *		1) bound to the same iommufd_ctx with the calling device
+ *		2) has not been bound to iommufd_ctx, but it is within the
+ *		   iommu_group of an owned device.
+ *	  For 1), the dev_id > 0, for 2) dev_id == 0. Otherwise, dev_id == -1.
+ *
+ * If the affected devices of a calling device span into multiple iommufds
+ * or opened by different APIs (group/container or cdev), hot-reset on
+ * this device would be rejected.
+ *
  * Return: 0 on success, -errno on failure:
  *	-enospc = insufficient buffer, -enodev = unsupported for device.
  */
 struct vfio_pci_dependent_device {
-	__u32	group_id;
+	union {
+		__u32   group_id;
+		__u32	dev_id;
+#define VFIO_PCI_DEVID_NONBLOCKING	0
+#define VFIO_PCI_DEVID_BLOCKING	-1
+	};
 	__u16	segment;
 	__u8	bus;
 	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
@@ -663,6 +698,8 @@ struct vfio_pci_dependent_device {
 struct vfio_pci_hot_reset_info {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID	(1 << 0)
+#define VFIO_PCI_HOT_RESET_FLAG_RESETTABLE	(1 << 1)
 	__u32	count;
 	struct vfio_pci_dependent_device	devices[];
 };
-- 
2.34.1

