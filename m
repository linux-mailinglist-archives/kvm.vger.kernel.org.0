Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413FB69D9D3
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjBUDuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjBUDuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:50:23 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF9244A2;
        Mon, 20 Feb 2023 19:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676951406; x=1708487406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kX/jMEN++KWYCep5D98/ZKX7M0giqep2VB+jNHwBWPc=;
  b=a3lR4JC28OFIh1GZ0kG6LzDdopU3WtwmIepzviEASQJF/Wu2rhsBUYso
   ZTL/SE73zdHhJ8wcoRhzfvvrxbxDpXns4KnMx3I5bdLZcmcrQmZTBaAth
   eQBZgQpPEjyArEXhzxsE2cY2hMC/EsHKxSIAGeNPSvIpHEeiB+T4djm6e
   clzNQ6ILLGqVlwqlhlVPHxMbyTiPbfSRMJH3cbu34ecZXO4I9IW8P/RbB
   iWfJHqriETrVUh5S/Bkyrvl+oLEL+L0BW9ZhpVH0fV5A9KGTJhSqTGGoh
   X9g0fBXrE1P68gUVx9PKX3xxMVVQxP/N6BOtKg0OUNZyhDesb5VSo40Cl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397218521"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="397218521"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:48:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664822214"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="664822214"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 19:48:26 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        yan.y.zhao@intel.com, xudong.hao@intel.com, terrence.xu@intel.com
Subject: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Date:   Mon, 20 Feb 2023 19:48:09 -0800
Message-Id: <20230221034812.138051-17-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221034812.138051-1-yi.l.liu@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
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

This adds ioctl for userspace to bind device cdev fd to iommufd.

    VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
			      control provided by the iommufd. open_device
			      op is called after bind_iommufd op.
			      VFIO no iommu mode is indicated by passing
			      a negative iommufd value.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 137 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        |  17 ++++-
 drivers/vfio/vfio_main.c   |  30 ++++++--
 include/linux/iommufd.h    |   6 ++
 include/uapi/linux/vfio.h  |  34 +++++++++
 5 files changed, 219 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 9e2c1ecaaf4f..be62f0a5687e 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2023 Intel Corporation.
  */
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio.h"
 
@@ -45,6 +46,142 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	return ret;
 }
 
+static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
+{
+	spin_lock(&df->kvm_ref_lock);
+	if (!df->kvm)
+		goto unlock;
+
+	_vfio_device_get_kvm_safe(df->device, df->kvm);
+
+unlock:
+	spin_unlock(&df->kvm_ref_lock);
+}
+
+void vfio_device_cdev_close(struct vfio_device_file *df)
+{
+	struct vfio_device *device = df->device;
+
+	mutex_lock(&device->dev_set->lock);
+	if (!smp_load_acquire(&df->access_granted)) {
+		mutex_unlock(&device->dev_set->lock);
+		return;
+	}
+	vfio_device_close(df);
+	vfio_device_put_kvm(device);
+	if (df->iommufd)
+		iommufd_ctx_put(df->iommufd);
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_unblock_group(device);
+}
+
+long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+				    unsigned long arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_bind_iommufd bind;
+	struct iommufd_ctx *iommufd = NULL;
+	struct fd f;
+	unsigned long minsz;
+	int ret;
+
+	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
+
+	if (copy_from_user(&bind, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (bind.argsz < minsz || bind.flags)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	ret = vfio_device_block_group(device);
+	if (ret)
+		return ret;
+
+	mutex_lock(&device->dev_set->lock);
+	/*
+	 * If already been bound to an iommufd, or already set noiommu
+	 * then fail it.
+	 */
+	if (df->iommufd || df->noiommu) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* iommufd < 0 means noiommu mode */
+	if (bind.iommufd < 0) {
+		if (!capable(CAP_SYS_RAWIO)) {
+			ret = -EPERM;
+			goto out_unlock;
+		}
+		df->noiommu = true;
+	} else {
+		f = fdget(bind.iommufd);
+		if (!f.file) {
+			ret = -EBADF;
+			goto out_unlock;
+		}
+		iommufd = iommufd_ctx_from_file(f.file);
+		if (IS_ERR(iommufd)) {
+			ret = PTR_ERR(iommufd);
+			goto out_put_file;
+		}
+	}
+
+	/*
+	 * Before the device open, get the KVM pointer currently
+	 * associated with the device file (if there is) and obtain a
+	 * reference. This reference is held until device closed. Save
+	 * the pointer in the device for use by drivers.
+	 */
+	vfio_device_get_kvm_safe(df);
+
+	df->iommufd = iommufd;
+	ret = vfio_device_open(df, &bind.out_devid, NULL);
+	if (ret)
+		goto out_put_kvm;
+
+	ret = copy_to_user((void __user *)arg +
+			   offsetofend(struct vfio_device_bind_iommufd, iommufd),
+			   &bind.out_devid,
+			   sizeof(bind.out_devid)) ? -EFAULT : 0;
+	if (ret)
+		goto out_close_device;
+
+	if (iommufd)
+		fdput(f);
+	else if (df->noiommu)
+		dev_warn(device->dev, "vfio-noiommu device used by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, true);
+	mutex_unlock(&device->dev_set->lock);
+
+	return 0;
+
+out_close_device:
+	vfio_device_close(df);
+out_put_kvm:
+	df->iommufd = NULL;
+	df->noiommu = false;
+	vfio_device_put_kvm(device);
+out_put_file:
+	if (iommufd) {
+		iommufd_ctx_put(iommufd);
+		fdput(f);
+	}
+out_unlock:
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_unblock_group(device);
+	return ret;
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 15734dbba9fb..40b54b0ce993 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -23,7 +23,9 @@ struct vfio_device_file {
 	bool access_granted;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
-	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
+	/* protected by struct vfio_device_set::lock */
+	struct iommufd_ctx *iommufd;
+	bool noiommu;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
@@ -259,6 +261,9 @@ static inline void vfio_device_del(struct vfio_device *device)
 
 void vfio_init_device_cdev(struct vfio_device *device);
 int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
+void vfio_device_cdev_close(struct vfio_device_file *df);
+long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+				    unsigned long arg);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -282,6 +287,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
 	return 0;
 }
 
+static inline void vfio_device_cdev_close(struct vfio_device_file *df)
+{
+}
+
+static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+						  unsigned long arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_cdev_init(struct class *device_class)
 {
 	return 0;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 48616ef97dfd..5e9a4fd800be 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -37,6 +37,7 @@
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
 #include <linux/iommufd.h>
+#include <uapi/linux/iommufd.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -422,16 +423,32 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 {
 	struct vfio_device *device = df->device;
 	struct iommufd_ctx *iommufd = df->iommufd;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	if (WARN_ON(iommufd && df->noiommu))
+		return -EINVAL;
+
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
+	/*
+	 * For group/container path, iommufd pointer is NULL when comes
+	 * into this helper. Its noiommu support is handled by
+	 * vfio_device_group_use_iommu()
+	 *
+	 * For iommufd compat mode, iommufd pointer here is a valid value.
+	 * Its noiommu support is in vfio_iommufd_bind().
+	 *
+	 * For device cdev path, iommufd pointer here is a valid value for
+	 * normal cases, but it is NULL if it's noiommu. Check df->noiommu
+	 * to differentiate cdev noiommu from the group/container path which
+	 * also passes NULL iommufd pointer in. If set then do nothing.
+	 */
 	if (iommufd)
 		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
-	else
+	else if (!df->noiommu)
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
@@ -446,7 +463,7 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 err_unuse_iommu:
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (!df->noiommu)
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
@@ -464,7 +481,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 		device->ops->close_device(device);
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (!df->noiommu)
 		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
@@ -549,6 +566,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	if (!df->is_cdev_device)
 		vfio_device_group_close(df);
+	else
+		vfio_device_cdev_close(df);
 
 	vfio_device_put_registration(device);
 
@@ -1122,6 +1141,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	struct vfio_device *device = df->device;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, arg);
+
 	/* Paired with smp_store_release() in vfio_device_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 650d45629647..9672cf839687 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -17,6 +17,12 @@ struct iommufd_ctx;
 struct iommufd_access;
 struct file;
 
+/*
+ * iommufd core init xarray with flags==XA_FLAGS_ALLOC1, so valid
+ * ID starts from 1.
+ */
+#define IOMMUFD_INVALID_ID 0
+
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
 void iommufd_device_unbind(struct iommufd_device *idev);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..1fe69173e739 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -194,6 +194,40 @@ struct vfio_group_status {
 
 /* --------------- IOCTLs for DEVICE file descriptors --------------- */
 
+/*
+ * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
+ *				   struct vfio_device_bind_iommufd)
+ *
+ * Bind a vfio_device to the specified iommufd.
+ *
+ * The user should provide a device cookie when calling this ioctl. The
+ * cookie is carried only in event e.g. I/O fault reported to userspace
+ * via iommufd. The user should use devid returned by this ioctl to mark
+ * the target device in other ioctls (e.g. capability query via iommufd).
+ *
+ * User is not allowed to access the device before the binding operation
+ * is completed.
+ *
+ * Unbind is automatically conducted when device fd is closed.
+ *
+ * @argsz:	 user filled size of this data.
+ * @flags:	 reserved for future extension.
+ * @dev_cookie:	 a per device cookie provided by userspace.
+ * @iommufd:	 iommufd to bind. a negative value means noiommu.
+ * @out_devid:	 the device id generated by this bind.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_bind_iommufd {
+	__u32		argsz;
+	__u32		flags;
+	__aligned_u64	dev_cookie;
+	__s32		iommufd;
+	__u32		out_devid;
+};
+
+#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
+
 /**
  * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
  *						struct vfio_device_info)
-- 
2.34.1

