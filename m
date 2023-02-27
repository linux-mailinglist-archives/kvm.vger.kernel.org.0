Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A406A4052
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjB0LMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjB0LMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:12:24 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D247A1E2BC;
        Mon, 27 Feb 2023 03:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496319; x=1709032319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1wJQt8xmLC72/COLDcNleApLDA/VeZORqeX+Ak1v4Mw=;
  b=hHm/lLpJ5vlbUgI/Vh9an0IbN2vvfaKS45Ka6Y/PZxxGAj5kf4rkfcf/
   AWGtho18WfBaNbP/erzvXFuIIP64NVR8NChzuk3PHsC5B98JzINoQbi/f
   GENr04Hv+syDx5sXq7dNG1gyd+vo6DWpT3mnALTIrTl5MJuHuz7Pj3Mig
   d5L6h2EvzldMwFIugR+oBKzXgFIga/1X2Qazv82/WLIuKLaFMA14JorJ4
   lu6XrxWjNxORDgRIkiOtpeneHljSPB3FHi0Ua3lG5R6jJj2ObrUwwp2xi
   pPzFQ+tKd9Xlo9MoXLPEUr5h0gdqofzt3YjaWsnNhBhNRjH4igLqznnHw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097759"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097759"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189595"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189595"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:48 -0800
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
Subject: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Date:   Mon, 27 Feb 2023 03:11:32 -0800
Message-Id: <20230227111135.61728-17-yi.l.liu@intel.com>
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

This adds ioctl for userspace to bind device cdev fd to iommufd.

    VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
			      control provided by the iommufd. open_device
			      op is called after bind_iommufd op.
			      VFIO no iommu mode is indicated by passing
			      a negative iommufd value.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 146 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        |  17 ++++-
 drivers/vfio/vfio_main.c   |  54 ++++++++++++--
 include/linux/iommufd.h    |   6 ++
 include/uapi/linux/vfio.h  |  34 +++++++++
 5 files changed, 248 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 9e2c1ecaaf4f..37f80e368551 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2023 Intel Corporation.
  */
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio.h"
 
@@ -45,6 +46,151 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
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
+	/*
+	 * As df->access_granted writer is under dev_set->lock as well,
+	 * so this read no need to use smp_load_acquire() to pair with
+	 * smp_store_release() in the caller of vfio_device_open().
+	 */
+	if (!df->access_granted) {
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
+static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
+{
+	struct fd f;
+	struct iommufd_ctx *iommufd;
+
+	f = fdget(fd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	iommufd = iommufd_ctx_from_file(f.file);
+
+	fdput(f);
+	return iommufd;
+}
+
+long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+				    unsigned long arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_bind_iommufd bind;
+	struct iommufd_ctx *iommufd = NULL;
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
+		iommufd = vfio_get_iommufd_from_fd(bind.iommufd);
+		if (IS_ERR(iommufd)) {
+			ret = PTR_ERR(iommufd);
+			goto out_unlock;
+		}
+	}
+
+	/*
+	 * Before the device open, get the KVM pointer currently
+	 * associated with the device file (if there is) and obtain
+	 * a reference.  This reference is held until device closed.
+	 * Save the pointer in the device for use by drivers.
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
+	if (df->noiommu)
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
+	if (iommufd)
+		iommufd_ctx_put(iommufd);
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
index 8661de75f94b..4716a904e63b 100644
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
@@ -269,6 +271,9 @@ static inline void vfio_device_del(struct vfio_device *device)
 
 void vfio_init_device_cdev(struct vfio_device *device);
 int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
+void vfio_device_cdev_close(struct vfio_device_file *df);
+long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+				    unsigned long arg);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -292,6 +297,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
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
index 3f83447d022e..69d0add930bb 100644
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
 
@@ -1122,7 +1141,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	struct vfio_device *device = df->device;
 	int ret;
 
-	/* Paired with smp_store_release() in vfio_device_group_open() */
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, arg);
+
+	/*
+	 * Paired with smp_store_release() in the caller of
+	 * vfio_device_open(). e.g. vfio_device_group_open()
+	 * and vfio_device_ioctl_bind_iommufd()
+	 */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
 
@@ -1153,7 +1179,11 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	/* Paired with smp_store_release() in vfio_device_group_open() */
+	/*
+	 * Paired with smp_store_release() in the caller of
+	 * vfio_device_open(). e.g. vfio_device_group_open()
+	 * and vfio_device_ioctl_bind_iommufd()
+	 */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
 
@@ -1170,7 +1200,11 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	/* Paired with smp_store_release() in vfio_device_group_open() */
+	/*
+	 * Paired with smp_store_release() in the caller of
+	 * vfio_device_open(). e.g. vfio_device_group_open()
+	 * and vfio_device_ioctl_bind_iommufd()
+	 */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
 
@@ -1185,7 +1219,11 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	/* Paired with smp_store_release() in vfio_device_group_open() */
+	/*
+	 * Paired with smp_store_release() in the caller of
+	 * vfio_device_open(). e.g. vfio_device_group_open()
+	 * and vfio_device_ioctl_bind_iommufd()
+	 */
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
index 4bf11ee8de53..92aa8dbc970a 100644
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

