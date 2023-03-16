Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D0B6BCFBB
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjCPMm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCPMmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:42:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4543B0BB5;
        Thu, 16 Mar 2023 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678970543; x=1710506543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/P7IVz4x0RFbFGWsYEmkd4pnPBYbK35RmNGyDNdhegc=;
  b=Lpec+h4OYRTjkDhTlHZdA4ULFBh7f7VFPahuGkyBOFW1k0VmknfZudss
   R4XgHKg+G8jikdOTYhSAkA9Z/YUEv7Ip1s/rm823HcAYIEqrAyR1FpK6P
   3TPOp7GWn0ymjHsoYZVw7aqdkoZNatg660VRVDBFJNBfnyPupUOzmLU3H
   nYw1oJ8YH6mK8xLgfJQGA151yUlMpcOYTpCUS7YMA63YTh86SuBszETGu
   ec0Mg/TzRfbuL4KKeconHZh8LrYjnJTxsaRahWGLoR36VtspmCyLYAdUG
   M08EGxUCGtsqX9h1bh1hqdbFgXs5ZqQAyYaBCzZOWoaSo7wjv3pfuPfKs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="321812069"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="321812069"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:42:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="1009207924"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009207924"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 05:42:09 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Date:   Thu, 16 Mar 2023 05:41:52 -0700
Message-Id: <20230316124156.12064-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316124156.12064-1-yi.l.liu@intel.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

as an alternative method for ownership check when iommufd is used. In
this case all opened devices in the affected dev_set are verified to
be bound to a same valid iommufd value to allow reset. It's simpler
and faster as user does not need to pass a set of fds and kernel no
need to search the device within the given fds.

a device in noiommu mode doesn't have a valid iommufd, so this method
should not be used in a dev_set which contains multiple devices and one
of them is in noiommu. The only allowed noiommu scenario is that the
calling device is noiommu and it's in a singleton dev_set.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c   |  6 ++
 drivers/vfio/iommufd.c           |  8 +++
 drivers/vfio/pci/vfio_pci_core.c | 94 +++++++++++++++++++++++---------
 include/linux/iommufd.h          |  1 +
 include/linux/vfio.h             |  3 +
 include/uapi/linux/vfio.h        |  9 ++-
 6 files changed, 93 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 0295140dd384..2ca12716db98 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -131,6 +131,12 @@ void iommufd_device_unbind(struct iommufd_device *idev)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
 
+struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
+{
+	return idev->ictx;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
+
 static int iommufd_device_setup_msi(struct iommufd_device *idev,
 				    struct iommufd_hw_pagetable *hwpt,
 				    phys_addr_t sw_msi_start)
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 9aabd8b31c15..ca0c16bb747e 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -66,6 +66,14 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 		vdev->ops->unbind_iommufd(vdev);
 }
 
+struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
+{
+	if (!vdev->iommufd_device)
+		return NULL;
+	return iommufd_device_to_ictx(vdev->iommufd_device);
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
+
 /*
  * The physical standard ops mean that the iommufd_device is bound to the
  * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 5d745c9abf05..b68fcba67a4b 100644
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
@@ -1255,29 +1256,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	return ret;
 }
 
-static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
-					struct vfio_pci_hot_reset __user *arg)
+static int
+vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_hot_reset *hdr,
+				    bool slot,
+				    struct vfio_pci_hot_reset __user *arg)
 {
-	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
-	struct vfio_pci_hot_reset hdr;
 	int32_t *group_fds;
 	struct file **files;
 	struct vfio_pci_group_info info;
-	bool slot = false;
 	int file_idx, count = 0, ret = 0;
 
-	if (copy_from_user(&hdr, arg, minsz))
-		return -EFAULT;
-
-	if (hdr.argsz < minsz || hdr.flags)
-		return -EINVAL;
-
-	/* Can we do a slot or bus reset or neither? */
-	if (!pci_probe_reset_slot(vdev->pdev->slot))
-		slot = true;
-	else if (pci_probe_reset_bus(vdev->pdev->bus))
-		return -ENODEV;
-
 	/*
 	 * We can't let userspace give us an arbitrarily large buffer to copy,
 	 * so verify how many we think there could be.  Note groups can have
@@ -1289,11 +1278,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return ret;
 
 	/* Somewhere between 1 and count is OK */
-	if (!hdr.count || hdr.count > count)
+	if (hdr->count > count)
 		return -EINVAL;
 
-	group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
+	files = kcalloc(hdr->count, sizeof(*files), GFP_KERNEL);
 	if (!group_fds || !files) {
 		kfree(group_fds);
 		kfree(files);
@@ -1301,7 +1290,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	if (copy_from_user(group_fds, arg->group_fds,
-			   hdr.count * sizeof(*group_fds))) {
+			   hdr->count * sizeof(*group_fds))) {
 		kfree(group_fds);
 		kfree(files);
 		return -EFAULT;
@@ -1311,7 +1300,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	 * Get the group file for each fd to ensure the group held across
 	 * the reset
 	 */
-	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
 		struct file *file = fget(group_fds[file_idx]);
 
 		if (!file) {
@@ -1335,10 +1324,10 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto hot_reset_release;
 
-	info.count = hdr.count;
+	info.count = hdr->count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1348,6 +1337,34 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
+					struct vfio_pci_hot_reset __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
+	struct vfio_pci_hot_reset hdr;
+	struct iommufd_ctx *iommufd;
+	bool slot = false;
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz || hdr.flags)
+		return -EINVAL;
+
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
+
+	if (hdr.count)
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
+
+	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
+
+	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
+}
+
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				    struct vfio_device_ioeventfd __user *arg)
 {
@@ -2317,6 +2334,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 {
 	unsigned int i;
 
+	if (!groups)
+		return false;
+
 	for (i = 0; i < groups->count; i++)
 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
@@ -2392,13 +2412,25 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
 	return ret;
 }
 
+static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
+				    struct iommufd_ctx *iommufd_ctx)
+{
+	struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
+
+	if (!iommufd)
+		return false;
+
+	return iommufd == iommufd_ctx;
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
@@ -2438,9 +2470,17 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 *
 		 * Otherwise all opened devices in the dev_set must be
 		 * contained by the set of groups provided by the user.
+		 *
+		 * If user provides a zero-length array, then all the
+		 * opened devices must be bound to a same iommufd_ctx.
+		 *
+		 * If all above checks are failed, reset is allowed only if
+		 * the calling device is in a singleton dev_set.
 		 */
 		if (cur_vma->vdev.open_count &&
-		    !vfio_dev_in_groups(cur_vma, groups)) {
+		    !vfio_dev_in_groups(cur_vma, groups) &&
+		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx) &&
+		    (dev_set->device_count > 1)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 1129a36a74c4..035d5d28e612 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -20,6 +20,7 @@ struct file;
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
 void iommufd_device_unbind(struct iommufd_device *idev);
+struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 
 int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 3188d8a374bd..f0a5ff317b20 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -116,6 +116,7 @@ struct vfio_device_ops {
 int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
+struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
@@ -127,6 +128,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 		  u32 *out_device_id)) NULL)
 #define vfio_iommufd_physical_unbind \
 	((void (*)(struct vfio_device *vdev)) NULL)
+#define vfio_iommufd_physical_ictx \
+	((struct iommufd_ctx * (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_physical_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #define vfio_iommufd_emulated_bind                                      \
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index f96e5689cffc..17aa5d09db41 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -679,7 +679,14 @@ struct vfio_pci_hot_reset_info {
  * the calling user must ensure all affected devices, if opened, are
  * owned by itself.
  *
- * The ownership is proved by an array of group fds.
+ * The ownership can be proved by:
+ *   - An array of group fds
+ *   - A zero-length array
+ *
+ * In the last case all affected devices which are opened by this user
+ * must have been bound to a same iommufd. If the calling device is in
+ * noiommu mode (no valid iommufd) then it can be reset only if the reset
+ * doesn't affect other devices.
  *
  * Return: 0 on success, -errno on failure.
  */
-- 
2.34.1

