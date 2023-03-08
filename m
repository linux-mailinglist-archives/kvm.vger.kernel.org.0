Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446746B0921
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCHNcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCHNbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:31:43 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B638A2C665;
        Wed,  8 Mar 2023 05:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282199; x=1709818199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0L0vMMuWTJTwe95x2UEU2BefzXax/kTZVXcty/RFtNc=;
  b=Xhz6kU29vnOYRPyn+yzX9Dp3uRW0ftf+aX0Qob/6e6o4eJbrcM4eQ+NR
   MgZj01NIovNVjKDlyM3V1VTwFhCmrFUzwmTnmQZIaIIgvVYuvx8TbWSFN
   3hPyZLTQBfym444uRFRbo1DD35JVAt9lnS3I41FfVqRq73g8UUZHiPMyn
   r2ENa0g3cG3HJVqHfj6sDpCD1vk0OncAWioeC1qz89nUW/2Wfw80+Tiwy
   15a66vmWmUogRYI95cKpwLgh3/8eyc/wGwGazYtb1DDmsBWiDpgL/uEmF
   mRboFs8z5A8cSJdVowjsRkCMJG8xZu/ov2oAWCyLTGWe2M13NHqbho2xL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165213"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165213"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789376"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789376"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:24 -0800
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
Subject: [PATCH v6 11/24] vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
Date:   Wed,  8 Mar 2023 05:28:50 -0800
Message-Id: <20230308132903.465159-12-yi.l.liu@intel.com>
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

VFIO PCI device hot reset requires user to provide a set of FDs to prove
ownership on the affected devices in the hot reset. Either group fd or
device fd can be used. But when user uses vfio device cdev, there is only
device fd, hence VFIO_DEVICE_PCI_HOT_RESET needs to be extended to accept
device fds.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c             | 15 +-----------
 drivers/vfio/pci/vfio_pci_core.c | 22 +++++++++++------
 drivers/vfio/vfio.h              |  1 +
 drivers/vfio/vfio_main.c         | 42 ++++++++++++++++++++++++++++++++
 include/linux/vfio.h             |  1 +
 include/uapi/linux/vfio.h        |  6 +++--
 6 files changed, 63 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 4a220d5bf79b..6280368eb0bd 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -852,23 +852,10 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 	spin_unlock(&group->kvm_ref_lock);
 }
 
-/**
- * vfio_file_has_dev - True if the VFIO file is a handle for device
- * @file: VFIO file to check
- * @device: Device that must be part of the file
- *
- * Returns true if given file has permission to manipulate the given device.
- */
-bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device)
 {
-	struct vfio_group *group = vfio_group_from_file(file);
-
-	if (!group)
-		return false;
-
 	return group == device->group;
 }
-EXPORT_SYMBOL_GPL(vfio_file_has_dev);
 
 static char *vfio_devnode(const struct device *dev, umode_t *mode)
 {
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 265a0058436c..123b468ead73 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1300,7 +1300,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(user_fds, arg->group_fds,
+	if (copy_from_user(user_fds, arg->fds,
 			   hdr.count * sizeof(*user_fds))) {
 		kfree(user_fds);
 		kfree(files);
@@ -1308,8 +1308,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * Get the group file for each fd to ensure the group held across
-	 * the reset
+	 * Get the file for each fd to ensure the group/device file
+	 * is held across the reset
 	 */
 	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
 		struct file *file = fget(user_fds[file_idx]);
@@ -1319,8 +1319,14 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 			break;
 		}
 
-		/* Ensure the FD is a vfio group FD.*/
-		if (!vfio_file_is_group(file)) {
+		/*
+		 * For vfio group FD, sanitize the file is enough.
+		 * For vfio device FD, needs to ensure it has got the
+		 * access to device, otherwise it cannot be used as
+		 * proof of device ownership.
+		 */
+		if (!vfio_file_is_valid(file) ||
+		    (!vfio_file_is_group(file) && !vfio_file_has_device_access(file))) {
 			fput(file);
 			ret = -EINVAL;
 			break;
@@ -2440,9 +2446,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * by other users.
 		 *
 		 * For the devices that have been opened, needs to check the
-		 * ownership.  If the user provides a set of group fds, test
-		 * whether all the opened affected devices are contained by the
-		 * set of groups provided by the user.
+		 * ownership.  If the user provides a set of group/device
+		 * fds, test whether all the opened devices are contained
+		 * by the set of groups/devices provided by the user.
 		 */
 		if (cur_vma->vdev.open_count &&
 		    !vfio_dev_in_user_fds(cur_vma, user_info)) {
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index e60c409868f8..464263288d16 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -96,6 +96,7 @@ void vfio_device_group_close(struct vfio_device_file *df);
 struct vfio_group *vfio_group_from_file(struct file *file);
 bool vfio_group_enforced_coherent(struct vfio_group *group);
 void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
+bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 027410e8d4a8..cf9994a65df3 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1277,6 +1277,48 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
+/**
+ * vfio_file_has_device_access - True if the file has opened device
+ * @file: VFIO device file
+ */
+bool vfio_file_has_device_access(struct file *file)
+{
+	struct vfio_device_file *df;
+
+	if (vfio_group_from_file(file) ||
+	    !vfio_device_from_file(file))
+		return false;
+
+	df = file->private_data;
+
+	return READ_ONCE(df->access_granted);
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_device_access);
+
+/**
+ * vfio_file_has_dev - True if the VFIO file is a handle for device
+ * @file: VFIO file to check
+ * @device: Device that must be part of the file
+ *
+ * Returns true if given file has permission to manipulate the given device.
+ */
+bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+{
+	struct vfio_group *group;
+	struct vfio_device *vdev;
+
+	group = vfio_group_from_file(file);
+	if (group)
+		return vfio_group_has_dev(group, device);
+
+	vdev = vfio_device_from_file(file);
+	if (device)
+		return vdev == device;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b14dcdd0b71f..1c69be2d687e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -248,6 +248,7 @@ bool vfio_file_is_group(struct file *file);
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+bool vfio_file_has_device_access(struct file *file);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index f96e5689cffc..d80141969cd1 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -679,7 +679,9 @@ struct vfio_pci_hot_reset_info {
  * the calling user must ensure all affected devices, if opened, are
  * owned by itself.
  *
- * The ownership is proved by an array of group fds.
+ * The ownership can be proved by:
+ *   - An array of group fds
+ *   - An array of device fds
  *
  * Return: 0 on success, -errno on failure.
  */
@@ -687,7 +689,7 @@ struct vfio_pci_hot_reset {
 	__u32	argsz;
 	__u32	flags;
 	__u32	count;
-	__s32	group_fds[];
+	__s32	fds[];
 };
 
 #define VFIO_DEVICE_PCI_HOT_RESET	_IO(VFIO_TYPE, VFIO_BASE + 13)
-- 
2.34.1

