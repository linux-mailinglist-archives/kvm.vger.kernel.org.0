Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287B57579E1
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjGRK4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjGRKzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:55:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B3EE43;
        Tue, 18 Jul 2023 03:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689677751; x=1721213751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5+KBDV3Eu19BAttwqbTJHc73PULREjsPNYQpZnyg2KU=;
  b=HxsESbu1TRIIHILSNv62Z356meSKxi3azIORWzgZOV8Z95Z9oOvMOdcl
   ooDA4vwxCtHYBIHjc6FCceiZb5LOvasxXauQYw4oFLgOxynZ+8V9J9x9r
   iy/q/cKzxGqaRBCWQSSyoqXbgq+wSjiX5FhXcswwWKrZ9V3tC+NsNc0hf
   p+AdOLTWIEsqM5WUCQpVJ6Mwp145mJJi0hs44EUrXDYFMuuOv7hdcs7rU
   bhNOsYYIyYLTBb1m2hLyrx2KF5Z7pUlbEJpXJZN+DDMb7sHB76mxi36a8
   jVH84k0hFfu2Ds2+4InFBgsHiDdz84hVSz9rqV9BLdnjViYAXoKBuUULT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="452553623"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452553623"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 03:55:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673863842"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="673863842"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2023 03:55:50 -0700
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
Subject: [PATCH v10 10/10] vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Date:   Tue, 18 Jul 2023 03:55:42 -0700
Message-Id: <20230718105542.4138-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718105542.4138-1-yi.l.liu@intel.com>
References: <20230718105542.4138-1-yi.l.liu@intel.com>
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

This is the way user to invoke hot-reset for the devices opened by cdev
interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED
in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
hot-reset for cdev devices.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 61 ++++++++++++++++++++++++++------
 include/uapi/linux/vfio.h        | 21 +++++++++++
 2 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f4a0ea01559e..65cbada3ec13 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -181,7 +181,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 struct vfio_pci_group_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups);
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1329,8 +1330,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	if (ret)
 		return ret;
 
-	/* Somewhere between 1 and count is OK */
-	if (!array_count || array_count > count)
+	if (array_count > count)
 		return -EINVAL;
 
 	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
@@ -1379,7 +1379,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	info.count = array_count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1402,13 +1402,21 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (hdr.argsz < minsz || hdr.flags)
 		return -EINVAL;
 
+	/* zero-length array is only for cdev opened devices */
+	if (!!hdr.count == vfio_device_cdev_opened(&vdev->vdev))
+		return -EINVAL;
+
 	/* Can we do a slot or bus reset or neither? */
 	if (!pci_probe_reset_slot(vdev->pdev->slot))
 		slot = true;
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+	if (hdr.count)
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+
+	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
+					  vfio_iommufd_device_ictx(&vdev->vdev));
 }
 
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
@@ -2376,13 +2384,16 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
-static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
+static bool vfio_dev_in_groups(struct vfio_device *vdev,
 			       struct vfio_pci_group_info *groups)
 {
 	unsigned int i;
 
+	if (!groups)
+		return false;
+
 	for (i = 0; i < groups->count; i++)
-		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
+		if (vfio_file_has_dev(groups->files[i], vdev))
 			return true;
 	return false;
 }
@@ -2458,7 +2469,8 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
  * get each memory_lock.
  */
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups)
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx)
 {
 	struct vfio_pci_core_device *cur_mem;
 	struct vfio_pci_core_device *cur_vma;
@@ -2488,11 +2500,38 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		goto err_unlock;
 
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
+		bool owned;
+
 		/*
-		 * Test whether all the affected devices are contained by the
-		 * set of groups provided by the user.
+		 * Test whether all the affected devices can be reset by the
+		 * user.
+		 *
+		 * If called from a group opened device and the user provides
+		 * a set of groups, all the devices in the dev_set should be
+		 * contained by the set of groups provided by the user.
+		 *
+		 * If called from a cdev opened device and the user provides
+		 * a zero-length array, all the devices in the dev_set must
+		 * be bound to the same iommufd_ctx as the input iommufd_ctx.
+		 * If there is any device that has not been bound to any
+		 * iommufd_ctx yet, check if its iommu_group has any device
+		 * bound to the input iommufd_ctx.  Such devices can be
+		 * considered owned by the input iommufd_ctx as the device
+		 * cannot be owned by another iommufd_ctx when its iommu_group
+		 * is owned.
+		 *
+		 * Otherwise, reset is not allowed.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (iommufd_ctx) {
+			int devid = vfio_iommufd_get_dev_id(&cur_vma->vdev,
+							    iommufd_ctx);
+
+			owned = (devid > 0 || devid == -ENOENT);
+		} else {
+			owned = vfio_dev_in_groups(&cur_vma->vdev, groups);
+		}
+
+		if (!owned) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index e680720ddddc..4c3d548e9c96 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -717,6 +717,9 @@ enum {
  *	  affected devices are represented in the dev_set and also owned by
  *	  the user.  This flag is available only when
  *	  flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
+ *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
+ *	  length fd array on the calling device as the ownership is validated
+ *	  by iommufd_ctx.
  *
  * Return: 0 on success, -errno on failure:
  *	-enospc = insufficient buffer, -enodev = unsupported for device.
@@ -748,6 +751,24 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * A PCI hot reset results in either a bus or slot reset which may affect
+ * other devices sharing the bus/slot.  The calling user must have
+ * ownership of the full set of affected devices as determined by the
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl.
+ *
+ * When called on a device file descriptor acquired through the vfio
+ * group interface, the user is required to provide proof of ownership
+ * of those affected devices via the group_fds array in struct
+ * vfio_pci_hot_reset.
+ *
+ * When called on a direct cdev opened vfio device, the flags field of
+ * struct vfio_pci_hot_reset_info reports the ownership status of the
+ * affected devices and this ioctl must be called with an empty group_fds
+ * array.  See above INFO ioctl definition for ownership requirements.
+ *
+ * Mixed usage of legacy groups and cdevs across the set of affected
+ * devices is not supported.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
-- 
2.34.1

