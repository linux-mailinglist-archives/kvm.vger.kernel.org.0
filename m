Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4621A74E43A
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 04:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjGKCcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 22:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjGKCby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 22:31:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B68ABE;
        Mon, 10 Jul 2023 19:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689042713; x=1720578713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=94KwID7bgWMS/YDaUgs443iYg4PZa5+44u6HqEJvYPg=;
  b=mi+cNPEt+2vcPc9eLFWUyKGxb/+HF4QP7nkwBFHou8bmo6ib4USz3WoE
   rEPkkL9b5v3DRZju09/BZ0oILT37MUj8835kBCnlXNq5NeOLi7XwCeTIN
   4uTgKv7l1poXmvXI46X/VEk96hrGmKhL4gDDXvWQ2aWJvyuE9z7mzxa6+
   tc13u63cj+EcgZou2NBa/khGd7atAyo35j2HB2lrbztRBPLjkAeAkJ3TK
   LpGHVPRJvhdm/Vta74uPW31qayDfH9adEXSXmfmLIBweDSanqCSnDMk2/
   3V2vapOzvciwPmcGV0+CUqhLRQxkOJ0XERlQpkNMJlwyQixF7Xogp9TIW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="368004739"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="368004739"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:31:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="720907613"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="720907613"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 10 Jul 2023 19:31:33 -0700
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
Subject: [PATCH v9 09/10] vfio/pci: Copy hot-reset device info to userspace in the devices loop
Date:   Mon, 10 Jul 2023 19:31:25 -0700
Message-Id: <20230711023126.5531-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711023126.5531-1-yi.l.liu@intel.com>
References: <20230711023126.5531-1-yi.l.liu@intel.com>
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

This copies the vfio_pci_dependent_device to userspace during looping each
affected device for reporting vfio_pci_hot_reset_info. This avoids counting
the affected devices and allocating a potential large buffer to store the
vfio_pci_dependent_device of all the affected devices before copying them
to userspace.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 93 ++++++++++++--------------------
 1 file changed, 33 insertions(+), 60 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 32506c5539b9..4737eeacd538 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -777,19 +777,25 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 }
 
 struct vfio_pci_fill_info {
-	int max;
-	int cur;
-	struct vfio_pci_dependent_device *devices;
+	struct vfio_pci_dependent_device __user *devices;
+	struct vfio_pci_dependent_device __user *devices_end;
 	struct vfio_device *vdev;
+	u32 count;
 	u32 flags;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
+	struct vfio_pci_dependent_device info = {
+		.segment = pci_domain_nr(pdev->bus),
+		.bus = pdev->bus->number,
+		.devfn = pdev->devfn,
+	};
 	struct vfio_pci_fill_info *fill = data;
 
-	if (fill->cur == fill->max)
-		return -EAGAIN; /* Something changed, try again */
+	fill->count++;
+	if (fill->devices >= fill->devices_end)
+		return 0;
 
 	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
 		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
@@ -802,19 +808,19 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		 */
 		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
 		if (!vdev) {
-			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
+			info.devid = VFIO_PCI_DEVID_NOT_OWNED;
 		} else {
 			int id = vfio_iommufd_get_dev_id(vdev, iommufd);
 
 			if (id > 0)
-				fill->devices[fill->cur].devid = id;
+				info.devid = id;
 			else if (id == -ENOENT)
-				fill->devices[fill->cur].devid = VFIO_PCI_DEVID_OWNED;
+				info.devid = VFIO_PCI_DEVID_OWNED;
 			else
-				fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
+				info.devid = VFIO_PCI_DEVID_NOT_OWNED;
 		}
 		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
-		if (fill->devices[fill->cur].devid == VFIO_PCI_DEVID_NOT_OWNED)
+		if (info.devid == VFIO_PCI_DEVID_NOT_OWNED)
 			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
 	} else {
 		struct iommu_group *iommu_group;
@@ -823,13 +829,13 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		if (!iommu_group)
 			return -EPERM; /* Cannot reset non-isolated devices */
 
-		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+		info.group_id = iommu_group_id(iommu_group);
 		iommu_group_put(iommu_group);
 	}
-	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
-	fill->devices[fill->cur].bus = pdev->bus->number;
-	fill->devices[fill->cur].devfn = pdev->devfn;
-	fill->cur++;
+
+	if (copy_to_user(fill->devices, &info, sizeof(info)))
+		return -EFAULT;
+	fill->devices++;
 	return 0;
 }
 
@@ -1259,8 +1265,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
 	struct vfio_pci_hot_reset_info hdr;
-	struct vfio_pci_fill_info fill = { 0 };
-	struct vfio_pci_dependent_device *devices = NULL;
+	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
 	int ret = 0;
 
@@ -1278,29 +1283,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	/* How many devices are affected? */
-	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
-					    &fill.max, slot);
-	if (ret)
-		return ret;
-
-	WARN_ON(!fill.max); /* Should always be at least one */
-
-	/*
-	 * If there's enough space, fill it now, otherwise return -ENOSPC and
-	 * the number of devices affected.
-	 */
-	if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
-		ret = -ENOSPC;
-		hdr.count = fill.max;
-		goto reset_info_exit;
-	}
-
-	devices = kcalloc(fill.max, sizeof(*devices), GFP_KERNEL);
-	if (!devices)
-		return -ENOMEM;
-
-	fill.devices = devices;
+	fill.devices = arg->devices;
+	fill.devices_end = arg->devices +
+			   (hdr.argsz - sizeof(hdr)) / sizeof(arg->devices[0]);
 	fill.vdev = &vdev->vdev;
 
 	if (vfio_device_cdev_opened(&vdev->vdev))
@@ -1311,29 +1296,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
 					    &fill, slot);
 	mutex_unlock(&vdev->vdev.dev_set->lock);
+	if (ret)
+		return ret;
 
-	/*
-	 * If a device was removed between counting and filling, we may come up
-	 * short of fill.max.  If a device was added, we'll have a return of
-	 * -EAGAIN above.
-	 */
-	if (!ret) {
-		hdr.count = fill.cur;
-		hdr.flags = fill.flags;
-	}
-
-reset_info_exit:
+	hdr.count = fill.count;
+	hdr.flags = fill.flags;
 	if (copy_to_user(arg, &hdr, minsz))
-		ret = -EFAULT;
-
-	if (!ret) {
-		if (copy_to_user(&arg->devices, devices,
-				 hdr.count * sizeof(*devices)))
-			ret = -EFAULT;
-	}
+		return -EFAULT;
 
-	kfree(devices);
-	return ret;
+	if (fill.count != fill.devices - arg->devices)
+		return -ENOSPC;
+	return 0;
 }
 
 static int
-- 
2.34.1

