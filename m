Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462856B0923
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCHNcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjCHNcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:32:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACF659801;
        Wed,  8 Mar 2023 05:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282210; x=1709818210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Espd273RqmEh9OcwiFTjRTtZDCKwnO6GhCUnMZWHQA=;
  b=Ao/uZeS0kqwpPaKVXKHFGx++vjjpTevhfqKVY4xDgVkCmVgErnxTTh7i
   LZ+lE10Nb1wbyAdQIMleNuXUc/EC4EtiJ1cCUojkZFq0LLylAG8e5xBp5
   Bg+/ENIX6z/AF1JEID6NFl3nAbuHAfkKZTX+AAo9/qusrqjSCi3InUAIT
   LAsaT104BQF0kwuqj9RtEUVXmiTggIsSEscLHMwY32F3kX4tbcYSo/GO/
   unMszTJmLvb8/F8J1mhiBhQxRBTK6zWvZA3qzddvPFT3k8GxCNLd/wAcl
   b3rJfs7feoewRhCA/apjyv+NJC2GeQRPrqDtjEbDGuHCzHxJ3/oBaKry/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165223"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165223"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789384"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789384"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:26 -0800
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
Subject: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Date:   Wed,  8 Mar 2023 05:28:51 -0800
Message-Id: <20230308132903.465159-13-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308132903.465159-1-yi.l.liu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is another method to issue PCI hot reset for the users that bounds
device to a positive iommufd value. In such case, iommufd is a proof of
device ownership. By passing a zero-length fd array, user indicates kernel
to do ownership check with the bound iommufd. All the opened devices within
the affected dev_set should have been bound to the same iommufd. This is
simpler and faster as user does not need to pass a set of fds and kernel
no need to search the device within the given fds.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c   |  6 +++
 drivers/vfio/iommufd.c           |  9 ++++
 drivers/vfio/pci/vfio_pci_core.c | 92 ++++++++++++++++++++++----------
 include/linux/iommufd.h          |  1 +
 include/linux/vfio.h             |  3 ++
 include/uapi/linux/vfio.h        |  5 ++
 6 files changed, 89 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 9087cd8ed3ea..dbcee0d38a48 100644
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
index 768d353cb6fa..30c0da2e11f9 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -69,6 +69,15 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 		vdev->ops->unbind_iommufd(vdev);
 }
 
+struct iommufd_ctx *vfio_iommufd_physical_ctx(struct vfio_device *vdev)
+{
+	/* Only serve for physical device */
+	if (!vdev->iommufd_device)
+		return NULL;
+	return iommufd_device_to_ictx(vdev->iommufd_device);
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ctx);
+
 /*
  * The physical standard ops mean that the iommufd_device is bound to the
  * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 123b468ead73..b039fbd5c656 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -180,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 struct vfio_pci_user_file_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_user_file_info *user_info);
+				      struct vfio_pci_user_file_info *user_info,
+				      struct iommufd_ctx *iommufd_ctx);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1255,29 +1256,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	return ret;
 }
 
-static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
+static int
+vfio_pci_ioctl_pci_hot_reset_user_files(struct vfio_pci_core_device *vdev,
+					struct vfio_pci_hot_reset *hdr,
+					bool slot,
 					struct vfio_pci_hot_reset __user *arg)
 {
-	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
-	struct vfio_pci_hot_reset hdr;
 	int32_t *user_fds;
 	struct file **files;
 	struct vfio_pci_user_file_info info;
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
 
-	user_fds = kcalloc(hdr.count, sizeof(*user_fds), GFP_KERNEL);
-	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+	user_fds = kcalloc(hdr->count, sizeof(*user_fds), GFP_KERNEL);
+	files = kcalloc(hdr->count, sizeof(*files), GFP_KERNEL);
 	if (!user_fds || !files) {
 		kfree(user_fds);
 		kfree(files);
@@ -1301,7 +1290,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	if (copy_from_user(user_fds, arg->fds,
-			   hdr.count * sizeof(*user_fds))) {
+			   hdr->count * sizeof(*user_fds))) {
 		kfree(user_fds);
 		kfree(files);
 		return -EFAULT;
@@ -1311,7 +1300,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	 * Get the file for each fd to ensure the group/device file
 	 * is held across the reset
 	 */
-	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
 		struct file *file = fget(user_fds[file_idx]);
 
 		if (!file) {
@@ -1341,10 +1330,10 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto hot_reset_release;
 
-	info.count = hdr.count;
+	info.count = hdr->count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1354,6 +1343,36 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
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
+		return vfio_pci_ioctl_pci_hot_reset_user_files(vdev, &hdr, slot, arg);
+
+	iommufd = vfio_iommufd_physical_ctx(&vdev->vdev);
+	if (!iommufd)
+		return -EINVAL;
+
+	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
+}
+
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				    struct vfio_device_ioeventfd __user *arg)
 {
@@ -2323,6 +2342,9 @@ static bool vfio_dev_in_user_fds(struct vfio_pci_core_device *vdev,
 {
 	unsigned int i;
 
+	if (!user_info)
+		return false;
+
 	for (i = 0; i < user_info->count; i++)
 		if (vfio_file_has_dev(user_info->files[i], &vdev->vdev))
 			return true;
@@ -2398,13 +2420,25 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
 	return ret;
 }
 
+static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
+				    struct iommufd_ctx *iommufd_ctx)
+{
+	struct iommufd_ctx *iommufd = vfio_iommufd_physical_ctx(&vdev->vdev);
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
-				      struct vfio_pci_user_file_info *user_info)
+				      struct vfio_pci_user_file_info *user_info,
+				      struct iommufd_ctx *iommufd_ctx)
 {
 	struct vfio_pci_core_device *cur_mem;
 	struct vfio_pci_core_device *cur_vma;
@@ -2448,10 +2482,14 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * For the devices that have been opened, needs to check the
 		 * ownership.  If the user provides a set of group/device
 		 * fds, test whether all the opened devices are contained
-		 * by the set of groups/devices provided by the user.
+		 * by the set of groups/devices provided by the user.  If
+		 * user provides a zero-length array, the ownerhsip check
+		 * is done by checking if all the opened devices are bound
+		 * to the same iommufd_ctx.
 		 */
 		if (cur_vma->vdev.open_count &&
-		    !vfio_dev_in_user_fds(cur_vma, user_info)) {
+		    !vfio_dev_in_user_fds(cur_vma, user_info) &&
+		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 365f11e8e615..7a0d7f2c4237 100644
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
index 1c69be2d687e..fc14f8430a10 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -116,6 +116,7 @@ struct vfio_device_ops {
 int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
+struct iommufd_ctx *vfio_iommufd_physical_ctx(struct vfio_device *vdev);
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
@@ -127,6 +128,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 		  u32 *out_device_id)) NULL)
 #define vfio_iommufd_physical_unbind \
 	((void (*)(struct vfio_device *vdev)) NULL)
+#define vfio_iommufd_physical_ctx \
+	((struct iommufd_ctx * (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_physical_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #define vfio_iommufd_emulated_bind                                      \
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d80141969cd1..382d95455f89 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -682,6 +682,11 @@ struct vfio_pci_hot_reset_info {
  * The ownership can be proved by:
  *   - An array of group fds
  *   - An array of device fds
+ *   - A zero-length array
+ *
+ * In the last case all affected devices which are opened by this user
+ * must have been bound to a same iommufd_ctx.  This approach is only
+ * available for devices bound to positive iommufd.
  *
  * Return: 0 on success, -errno on failure.
  */
-- 
2.34.1

