Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7A694AD1
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 16:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjBMPQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 10:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjBMPPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 10:15:45 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23B41EBC6;
        Mon, 13 Feb 2023 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676301319; x=1707837319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vYK+VzdGsyMdBFhy4eGViVnwSU0vUHFt71pZ3T0a0KY=;
  b=oAl9iiwZCsMHFMUpWHy2m0kOBem/+82MhJ+POWf2wyWDMcAdrZFaxJTO
   b2UGTj6pO5NoVphXHf1qvIPU2vhZG4I96RNXKnu9jH9TYyAf7sReWLd7x
   u5epR/lMByhKHnKtQBQB0l0iO7WVjY3ndgrdDvonusP9wjFxXlhqbItur
   YeiZRtotDC3m7heiTqPMfGaFNuZrW0QcAZy8zfK2Tu1pkLPKfc7oQxVGi
   JoveVLY0syTA0hoz5n62KQn2K1eLalcSJX7cSZ60I7uW8fG0R4fMemB72
   zbi/fKhbqz75rAr4z8HpiZVgVyOAcxZ2PBXHXNOysUQq6q7U6BKIUCVGY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="318931667"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="318931667"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:14:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701289695"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701289695"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 07:14:02 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     joro@8bytes.org, alex.williamson@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, robin.murphy@arm.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Date:   Mon, 13 Feb 2023 07:13:47 -0800
Message-Id: <20230213151348.56451-15-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213151348.56451-1-yi.l.liu@intel.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds three vfio device ioctls for userspace using iommufd to set up
secure DMA context for device access.

    VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
			      control provided by the iommufd. open_device
			      op is called after bind_iommufd op.
			      VFIO no iommu mode is indicated by passing
			      a negative iommufd value.
    VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach device to IOAS, hw_pagetable
				   managed by iommufd. Attach can be
				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
				   or device fd close.
    VFIO_DEVICE_DETACH_IOMMUFD_PT: detach device from the current attached
				   IOAS or hw_pagetable managed by iommufd.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 200 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/group.c       |  27 +++++
 drivers/vfio/vfio.h        |  35 ++++++-
 drivers/vfio/vfio_main.c   |  38 ++++++-
 include/linux/iommufd.h    |   6 ++
 include/uapi/linux/vfio.h  |  86 ++++++++++++++++
 6 files changed, 387 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 07869fde1c0c..e5297bf99cc4 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2023 Intel Corporation.
  */
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio.h"
 
@@ -46,6 +47,205 @@ int vfio_device_fops_open(struct inode *inode, struct file *filep)
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
+	if (!device->open_count) {
+		mutex_unlock(&device->dev_set->lock);
+		return;
+	}
+	vfio_device_close(df);
+	vfio_device_put_kvm(device);
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_release_group(device);
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
+	ret = vfio_device_claim_group(device);
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
+	mutex_unlock(&device->dev_set->lock);
+	return 0;
+
+out_close_device:
+	vfio_device_close(df);
+out_put_kvm:
+	df->iommufd = NULL;
+	df->noiommu = false;
+	vfio_device_put_kvm(device);
+out_put_file:
+	if (iommufd)
+		fdput(f);
+out_unlock:
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_release_group(device);
+	return ret;
+}
+
+int vfio_ioctl_device_attach(struct vfio_device_file *df,
+			     void __user *arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_attach_iommufd_pt attach;
+	unsigned long minsz;
+	int ret;
+
+	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
+
+	if (copy_from_user(&attach, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (attach.argsz < minsz || attach.flags ||
+	    attach.pt_id == IOMMUFD_INVALID_ID)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	mutex_lock(&device->dev_set->lock);
+	if (df->noiommu) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = device->ops->attach_ioas(device, &attach.pt_id);
+	if (ret)
+		goto out_unlock;
+
+	ret = copy_to_user((void __user *)arg +
+			   offsetofend(struct vfio_device_attach_iommufd_pt, flags),
+			   &attach.pt_id,
+			   sizeof(attach.pt_id)) ? -EFAULT : 0;
+	if (ret)
+		goto out_detach;
+	mutex_unlock(&device->dev_set->lock);
+	return 0;
+
+out_detach:
+	device->ops->detach_ioas(device);
+out_unlock:
+	mutex_unlock(&device->dev_set->lock);
+	return ret;
+}
+
+int vfio_ioctl_device_detach(struct vfio_device_file *df,
+			     void __user *arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_detach_iommufd_pt detach;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
+
+	if (copy_from_user(&detach, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (detach.argsz < minsz || detach.flags)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	mutex_lock(&device->dev_set->lock);
+	if (df->noiommu) {
+		mutex_unlock(&device->dev_set->lock);
+		return -EINVAL;
+	}
+	device->ops->detach_ioas(device);
+	mutex_unlock(&device->dev_set->lock);
+	return 0;
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index f3f5f4589cdd..8ee06d8b17fa 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -381,6 +381,33 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 	}
 }
 
+int vfio_device_claim_group(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+	int ret = 0;
+
+	mutex_lock(&group->group_lock);
+	if (group->opened_file) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	group->cdev_device_open_cnt++;
+
+out_unlock:
+	mutex_unlock(&group->group_lock);
+	return ret;
+}
+
+void vfio_device_release_group(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	mutex_lock(&group->group_lock);
+	group->cdev_device_open_cnt--;
+	mutex_unlock(&group->group_lock);
+}
+
 static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_group *group =
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index be93a1c953f8..421492518ab5 100644
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
@@ -89,6 +91,8 @@ struct vfio_group {
 	unsigned int			cdev_device_open_cnt;
 };
 
+int vfio_device_claim_group(struct vfio_device *device);
+void vfio_device_release_group(struct vfio_device *device);
 int vfio_device_set_group(struct vfio_device *device,
 			  enum vfio_group_type type);
 void vfio_device_remove_group(struct vfio_device *device);
@@ -247,6 +251,13 @@ static inline void vfio_iommufd_unbind(struct vfio_device *device)
 #if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
 void vfio_init_device_cdev(struct vfio_device *device);
 int vfio_device_fops_open(struct inode *inode, struct file *filep);
+void vfio_device_cdev_close(struct vfio_device_file *df);
+long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+				    unsigned long arg);
+int vfio_ioctl_device_attach(struct vfio_device_file *df,
+			     void __user *arg);
+int vfio_ioctl_device_detach(struct vfio_device_file *df,
+			     void __user *arg);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -260,6 +271,28 @@ static inline int vfio_device_fops_open(struct inode *inode,
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
+static inline int vfio_ioctl_device_attach(struct vfio_device_file *df,
+					   void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int vfio_ioctl_device_detach(struct vfio_device_file *df,
+					   void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_cdev_init(struct class *device_class)
 {
 	return 0;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a7eb2727c613..933319083282 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -37,6 +37,7 @@
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
 #include <linux/iommufd.h>
+#include <uapi/linux/iommufd.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -441,16 +442,32 @@ static int vfio_device_first_open(struct vfio_device_file *df,
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
+	 * into this helper. Its noiommu support is in container.c.
+	 *
+	 * For iommufd compat mode, iommufd pointer here is a valid value.
+	 * Its noiommu support is in vfio_iommufd_bind().
+	 *
+	 * For device cdev path, iommufd pointer here is a valid value for
+	 * normal cases, but it is NULL if it's noiommu. To differentiate
+	 * the noiommu from the group/container path which also passes NULL
+	 * iommufd pointer in, check df->noiommu which is set only in the
+	 * cdev path.
+	 */
 	if (iommufd)
 		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
-	else
+	else if (!df->noiommu)
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
@@ -465,7 +482,7 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 err_unuse_iommu:
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (!df->noiommu)
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
@@ -483,7 +500,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 		device->ops->close_device(device);
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (!df->noiommu)
 		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
@@ -582,6 +599,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	 */
 	if (!df->is_cdev_device)
 		vfio_device_group_close(df);
+	else
+		vfio_device_cdev_close(df);
 
 	vfio_device_put_registration(device);
 
@@ -1156,6 +1175,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	bool access;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, arg);
+
 	/* Paired with smp_store_release() in vfio_device_open() */
 	access = smp_load_acquire(&df->access_granted);
 	if (!access)
@@ -1170,6 +1192,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
 		break;
 
+	case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
+		ret = vfio_ioctl_device_attach(df, (void __user *)arg);
+		break;
+
+	case VFIO_DEVICE_DETACH_IOMMUFD_PT:
+		ret = vfio_ioctl_device_detach(df, (void __user *)arg);
+		break;
+
 	default:
 		if (unlikely(!device->ops->ioctl))
 			ret = -EINVAL;
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
index 0552e8dcf0cb..026af52cf22e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -194,6 +194,92 @@ struct vfio_group_status {
 
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
+/*
+ * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
+ *					struct vfio_device_attach_iommufd_pt)
+ *
+ * Attach a vfio device to an iommufd address space specified by IOAS
+ * id or hw_pagetable (hwpt) id.
+ *
+ * Available only after a device has been bound to iommufd via
+ * VFIO_DEVICE_BIND_IOMMUFD
+ *
+ * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	must be 0.
+ * @pt_id:	Input the target id which can represent an ioas or a hwpt
+ *		allocated via iommufd subsystem.
+ *		Output the attached hwpt id which could be the specified
+ *		hwpt itself or a hwpt automatically created for the
+ *		specified ioas by kernel during the attachment.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_attach_iommufd_pt {
+	__u32	argsz;
+	__u32	flags;
+	__u32	pt_id;
+};
+
+#define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
+
+/*
+ * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 21,
+ *					struct vfio_device_detach_iommufd_pt)
+ *
+ * Detach a vfio device from the iommufd address space it has been
+ * attached to. After it, device should be in a blocking DMA state.
+ *
+ * Available only after a device has been bound to iommufd via
+ * VFIO_DEVICE_BIND_IOMMUFD
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	must be 0.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_detach_iommufd_pt {
+	__u32	argsz;
+	__u32	flags;
+};
+
+#define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /**
  * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
  *						struct vfio_device_info)
-- 
2.34.1

