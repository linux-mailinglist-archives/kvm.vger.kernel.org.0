Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25B06EF6EB
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241411AbjDZOy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241513AbjDZOyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAE37D83;
        Wed, 26 Apr 2023 07:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520882; x=1714056882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2K7nvdIG5YIxPwK2ZtjJpN2nWmwhSE9eiTVKfvbiR/Y=;
  b=bIf/zHTuzMc/mSknU/ijMG/HNNbyCHDs0XY7tLUYobwipBHHiUzkH47T
   YffiuddVCbabu5gAiWS7ZHTLkMTRxAyrz8DBKYYjlpl6Hf295g7tnNxN2
   AF184O9PlqF3whk4U8+gOWWMfoLekcvPpL9CpkrdhFaA/ZguHJ/mygahk
   gU+7fMwWwYUK3h44Sx7IwJeAlfmr6gl7t5o5M35pm1Jl47T7UZtNBR04r
   VyG7PHFlSkS9krWBgyvNbboddda2jszW8LyBY+0osUc4LstNzI7/+nAib
   ckF4iyiNlalXXEkTYhisD3BjNtYspYSxVRkMOeIJJ5TzXkWBIy18kbl6D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410373"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410373"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758644069"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758644069"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:40 -0700
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
Subject: [PATCH v4 9/9] vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Date:   Wed, 26 Apr 2023 07:54:19 -0700
Message-Id: <20230426145419.450922-10-yi.l.liu@intel.com>
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

This is the way user to invoke hot-reset for the devices opened by cdev
interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_RESETTABLE
in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
hot-reset for cdev devices.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 66 +++++++++++++++++++++++++++-----
 include/uapi/linux/vfio.h        | 22 +++++++++++
 2 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 43858d471447..f70e3b948b16 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -180,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 struct vfio_pci_group_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups);
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1364,8 +1365,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	if (ret)
 		return ret;
 
-	/* Somewhere between 1 and count is OK */
-	if (!array_count || array_count > count)
+	if (array_count > count)
 		return -EINVAL;
 
 	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
@@ -1414,7 +1414,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	info.count = array_count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1429,6 +1429,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 {
 	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
 	struct vfio_pci_hot_reset hdr;
+	struct iommufd_ctx *iommufd;
 	bool slot = false;
 
 	if (copy_from_user(&hdr, arg, minsz))
@@ -1443,7 +1444,12 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+	if (hdr.count)
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+
+	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
+
+	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
 }
 
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
@@ -2415,6 +2421,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 {
 	unsigned int i;
 
+	if (!groups)
+		return false;
+
 	for (i = 0; i < groups->count; i++)
 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
@@ -2488,13 +2497,38 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
 	return ret;
 }
 
+static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
+				    struct iommufd_ctx *iommufd_ctx)
+{
+	struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
+	struct iommu_group *iommu_group;
+
+	if (!iommufd_ctx)
+		return false;
+
+	if (iommufd == iommufd_ctx)
+		return true;
+
+	iommu_group = iommu_group_get(vdev->vdev.dev);
+	if (!iommu_group)
+		return false;
+
+	/*
+	 * Try to check if any device within iommu_group is bound with
+	 * the input iommufd_ctx.
+	 */
+	return vfio_devset_iommufd_has_group(vdev->vdev.dev_set,
+					     iommufd_ctx, iommu_group);
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
@@ -2525,10 +2559,24 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
-		 * Test whether all the affected devices are contained by the
-		 * set of groups provided by the user.
+		 * Test whether all the affected devices can be reset by the
+		 * user.
+		 *
+		 * If user provides a set of groups, all the opened devices
+		 * in the dev_set should be contained by the set of groups
+		 * provided by the user.
+		 *
+		 * If user provides a zero-length group fd array, then all
+		 * the affected devices must be bound to same iommufd_ctx as
+		 * the input iommufd_ctx.  If there is device that has not
+		 * been bound to iommufd_ctx yet, shall check if there is any
+		 * device within its iommu_group that has been bound to the
+		 * input iommufd_ctx.
+		 *
+		 * Otherwise, reset is not allowed.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (!vfio_dev_in_groups(cur_vma, groups) &&
+		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4b4e2c28984b..1241d02d8701 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -710,6 +710,28 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * Userspace requests hot reset for the devices it operates.  Due to the
+ * underlying topology, multiple devices can be affected in the reset
+ * while some might be opened by another user.  To avoid interference
+ * the calling user must ensure all affected devices are owned by itself.
+ * The ownership proof needs to refer the output of
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO.  Ownership can be proved as:
+ *
+ *   1) An array of group fds - This is used for the devices opened via
+ *				the group/container interface.
+ *   2) A zero-length array - This is used for the devices opened via
+ *			      the cdev interface.  User should check the
+ *			      flag VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID
+ *			      and flag VFIO_PCI_HOT_RESET_FLAG_RESETTABLE
+ *			      before using this method.
+ *
+ * In case a non void group fd array is passed, the devices affected by
+ * the reset must belong to those opened VFIO groups.  In case a zero
+ * length array is passed, the other devices affected by the reset, if
+ * any, must be either bound to the same iommufd as this VFIO device or
+ * in the same iommu_group with a device that does.  Either of the two
+ * methods is applied to check the feasibility of the hot reset.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
-- 
2.34.1

