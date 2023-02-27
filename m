Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22BB6A402B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjB0LLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjB0LLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:11:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685811DB97;
        Mon, 27 Feb 2023 03:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496306; x=1709032306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djFdIv/X2hVfUL9/5yFFxBfudPCkKXSOQ6UCqFo1JE=;
  b=kLDJ2TfhM/dQfeSzP4/tfA5EUpdSEBJGALQTm33XYi2FMacQCYTV/vwQ
   scywJUiO1NDuZ7YqXARrOnAFlTEcnU6DecS1x/1c2QYVLS7Zulq5syu+a
   rbx4DG5uhIpbZynVZaKjKFTDNsE7FxHBuqMV+Kcym+RP30vNgvUfk3JlP
   psb5uh+YPBL2D719UblPsCGxnEn2lgQt4f1hNVvKZw5McLRFH6L+wVC6o
   oqDSKiptT/TlYBY1QoGhx1XdBBYzp1LQJNpOLM50URme2LJPdlIJ+WVPe
   s1eCsHQEbg1JLaLIHQQpWX3u4MmlO/I2JCBvftpKHvot7DXEsrDZGm35l
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097663"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097663"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189505"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189505"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:44 -0800
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
Subject: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Date:   Mon, 27 Feb 2023 03:11:25 -0800
Message-Id: <20230227111135.61728-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227111135.61728-1-yi.l.liu@intel.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

to indicate kernel to use the device's bound iommufd_ctx for the device
ownership check. Kernel should loop all the opened devices in the dev_set,
and check if they are bound to the same iommufd_ctx. For the devices that
has not been opened yet but affected, they can be reset by the current
users as they cannot be opened by any other user. This applies to the
existing group/container path as well.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 111 +++++++++++++++++++++++--------
 drivers/vfio/vfio.h              |  11 +++
 include/uapi/linux/vfio.h        |  16 +++++
 3 files changed, 109 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1bf54beeaef2..e0ebe55b4df0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,11 +27,13 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#include <linux/iommufd.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
 
 #include "vfio_pci_priv.h"
+#include "../vfio.h"
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC "core driver for VFIO based PCI devices"
@@ -180,7 +182,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 struct vfio_pci_group_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups);
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1255,29 +1258,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
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
@@ -1289,11 +1280,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
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
@@ -1301,7 +1292,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	if (copy_from_user(group_fds, arg->group_fds,
-			   hdr.count * sizeof(*group_fds))) {
+			   hdr->count * sizeof(*group_fds))) {
 		kfree(group_fds);
 		kfree(files);
 		return -EFAULT;
@@ -1311,7 +1302,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	 * Get the group file for each fd to ensure the group held across
 	 * the reset
 	 */
-	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
 		struct file *file = fget(group_fds[file_idx]);
 
 		if (!file) {
@@ -1335,10 +1326,10 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto hot_reset_release;
 
-	info.count = hdr.count;
+	info.count = hdr->count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1348,6 +1339,36 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
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
+	if (!hdr.count)
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
+
+	iommufd = vfio_device_iommufd(&vdev->vdev);
+	if (!iommufd)
+		return -EINVAL;
+
+	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
+}
+
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				    struct vfio_device_ioeventfd __user *arg)
 {
@@ -2317,6 +2338,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 {
 	unsigned int i;
 
+	if (!groups)
+		return false;
+
 	for (i = 0; i < groups->count; i++)
 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
@@ -2392,13 +2416,25 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
 	return ret;
 }
 
+static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
+				    struct iommufd_ctx *iommufd_ctx)
+{
+	struct iommufd_ctx *iommufd = vfio_device_iommufd(&vdev->vdev);
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
@@ -2429,10 +2465,27 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
-		 * Test whether all the affected devices are contained by the
-		 * set of groups provided by the user.
+		 * Test whether all the affected devices can be reset by the
+		 * user.  The affected devices may already been opened or not
+		 * yet.
+		 *
+		 * For the devices not opened yet, user can reset them. The
+		 * reason is that the hot reset is done under the protection
+		 * of the dev_set->lock, and device open is also under this
+		 * lock.  During the hot reset, such devices can not be opened
+		 * by other users.
+		 *
+		 * For the devices that have been opened, needs to check the
+		 * ownership.  If the user provides a set of group fds, the
+		 * ownership check is done by checking if all the opened
+		 * devices are contained by the groups.  If the user provides
+		 * a zero-length fd array, the ownerhsip check is done by
+		 * checking if all the opened devices are bound to the same
+		 * iommufd_ctx.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (cur_vma->vdev.open_count &&
+		    !vfio_dev_in_groups(cur_vma, groups) &&
+		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 2e3cb284711d..64e862a02dad 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -225,6 +225,11 @@ static inline void vfio_container_cleanup(void)
 #if IS_ENABLED(CONFIG_IOMMUFD)
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
+static inline struct iommufd_ctx *
+vfio_device_iommufd(struct vfio_device *device)
+{
+	return device->iommufd_ictx;
+}
 #else
 static inline int vfio_iommufd_bind(struct vfio_device *device,
 				    struct iommufd_ctx *ictx)
@@ -235,6 +240,12 @@ static inline int vfio_iommufd_bind(struct vfio_device *device,
 static inline void vfio_iommufd_unbind(struct vfio_device *device)
 {
 }
+
+static inline struct iommufd_ctx *
+vfio_device_iommufd(struct vfio_device *device)
+{
+	return NULL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..4bf11ee8de53 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -673,6 +673,22 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * Userspace requests hot reset for the devices it uses.  Due to the
+ * underlying topology, multiple devices may be affected in the reset.
+ * The affected devices may have been opened by the user or by other
+ * users or not opened yet.  Only when all the affected devices are
+ * either opened by the current user or not opened by any user, should
+ * the reset request be allowed.  Otherwise, this request is expected
+ * to return error.
+ *
+ * If the user uses group and container interface, it should pass down
+ * a set of group fds for ownership check.  If the user uses iommufd, it
+ * should pass down a zero-length group_fds array to indicate the kernel
+ * to use the bound iommufd for the ownership check.  User that uses the
+ * vfio iommufd compatible mode can also pass down a zero-length group_fds
+ * array as this mode uses iommufd in kernel, and there is no reason to
+ * forbide it.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
-- 
2.34.1

