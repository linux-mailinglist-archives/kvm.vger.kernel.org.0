Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F2D701704
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbjEMNWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238565AbjEMNVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:21:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954AD46A9;
        Sat, 13 May 2023 06:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984112; x=1715520112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lEhjBYfia0mz7JSmjh7SFm1OSylP/YfJVuAcamAGQhs=;
  b=OOz3BUzhiTLwyzBan0/XkUtOL4bcLOie7BVoOL1FsbOtzHmUFXwFEGsU
   SV1O1tQY72JNDP0IeNfDDStF2NGLnSn4MyWn9jVE0r3aP6xR1FNUBIJer
   Q5WRIMiqLz+AlTDBO8ga1sRLGKOjMqJLQsfxXGfRet7qnC5RKhllv9jZm
   3HioHFWKYujVXOrPpuc/v3OCqNAxm/Y0jleUHspee3lPXA1qKQbIJXhtu
   m7UpWy+wjoPpQSQRJ2uCIZex2sciQS+cnns7NHuYXLIpxj9RcqE8vwiPK
   MBR5s5AUtbIQYx3nC4vJ0ckmwxZrxOLMwRrFB9Ufj/EKEaqMvz15j/KH4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="416599051"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="416599051"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:21:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="790126486"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="790126486"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2023 06:21:51 -0700
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
Subject: [PATCH v5 10/10] vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Date:   Sat, 13 May 2023 06:21:36 -0700
Message-Id: <20230513132136.15021-11-yi.l.liu@intel.com>
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

This is the way user to invoke hot-reset for the devices opened by cdev
interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED
in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
hot-reset for cdev devices.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 68 ++++++++++++++++++++++++++------
 include/uapi/linux/vfio.h        | 14 +++++++
 2 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 57586be770af..7fa3f54eb855 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -185,7 +185,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 struct vfio_pci_group_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups);
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1323,8 +1324,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	if (ret)
 		return ret;
 
-	/* Somewhere between 1 and count is OK */
-	if (!array_count || array_count > count)
+	if (array_count > count || vfio_device_cdev_opened(&vdev->vdev))
 		return -EINVAL;
 
 	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
@@ -1373,7 +1373,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	info.count = array_count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1402,7 +1402,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+	if (hdr.count)
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+
+	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
+					  vfio_iommufd_physical_ictx(&vdev->vdev));
 }
 
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
@@ -2369,13 +2373,16 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
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
@@ -2447,13 +2454,37 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
 	return ret;
 }
 
+static bool vfio_device_owned(struct vfio_device *vdev,
+			      struct vfio_pci_group_info *groups,
+			      struct iommufd_ctx *iommufd_ctx)
+{
+	struct iommu_group *group;
+
+	WARN_ON(!!groups == !!iommufd_ctx);
+
+	if (groups)
+		return vfio_dev_in_groups(vdev, groups);
+
+	if (vfio_iommufd_physical_ictx(vdev) == iommufd_ctx)
+		return true;
+
+	group = iommu_group_get(vdev->dev);
+	if (!group)
+		return false;
+
+	iommu_group_put(group);
+
+	return iommufd_ctx_has_group(iommufd_ctx, group);
+}
+
 /*
  * We need to get memory_lock for each device, but devices can share mmap_lock,
  * therefore we need to zap and hold the vma_lock for each device, and only then
  * get each memory_lock.
  */
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups)
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx)
 {
 	struct vfio_pci_core_device *cur_mem;
 	struct vfio_pci_core_device *cur_vma;
@@ -2484,10 +2515,25 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
-		 * Test whether all the affected devices are contained by the
-		 * set of groups provided by the user.
+		 * Test whether all the affected devices can be reset by the
+		 * user.
+		 *
+		 * If the user provides a set of groups, all the devices
+		 * in the dev_set should be contained by the set of groups
+		 * provided by the user.
+		 *
+		 * If the user provides a zero-length group fd array, then
+		 * all the devices in the dev_set must be bound to the same
+		 * iommufd_ctx as the input iommufd_ctx.  If there is any
+		 * device that has not been bound to iommufd_ctx yet, check
+		 * if its iommu_group has any device bound to the input
+		 * iommufd_ctx Such devices can be considered owned by
+		 * the input iommufd_ctx as the device cannot be owned
+		 * by another iommufd_ctx when its iommu_group is owned.
+		 *
+		 * Otherwise, reset is not allowed.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (!vfio_device_owned(&cur_vma->vdev, groups, iommufd_ctx)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 01203215251a..24858b650562 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -686,6 +686,9 @@ enum {
  *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
  *	  affected devices are owned by the user.  This flag is available only
  *	  when VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
+ *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
+ *	  length fd array on the calling device as the ownership is validated
+ *	  by iommufd_ctx.
  *
  * Return: 0 on success, -errno on failure:
  *	-enospc = insufficient buffer, -enodev = unsupported for device.
@@ -717,6 +720,17 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * Userspace requests hot reset for the devices it operates.  Due to the
+ * underlying topology, multiple devices can be affected in the reset
+ * while some might be opened by another user.  To avoid interference
+ * the calling user must ensure all affected devices are owned by itself.
+ *
+ * As the ownership described by VFIO_DEVICE_GET_PCI_HOT_RESET_INFO, the
+ * cdev opened devices must exclusively provide a zero-length fd array and
+ * the group opened devices must exclusively use an array of group fds for
+ * proof of ownership.  Mixed access to devices between cdev and legacy
+ * groups are not supported by this interface.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
-- 
2.34.1

