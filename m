Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A51E6BD049
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjCPM4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCPM4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:56:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A81C7C965;
        Thu, 16 Mar 2023 05:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678971366; x=1710507366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=22fk7h9kyqgQxLZKd3Z85noEys/Ejz9EipQjLeneFNY=;
  b=hgC81xRmo8ppAHsC+/ys91njA66XYriUNQh+m02zH3lbaUD4lf68SGm+
   rYYqektj5OZkHxSMg4iMNJQXvxZpKjiY7jlBehJ9l16inxnh/vf6WnQyn
   fG6edddFc9Uoi84qeuSEaCjKobsp89cPVSpBpe6psvKbZFFpDek056BET
   wxqsQyk+vHnqUhns/9fB0kuUPLcKlVYb2GpHAuEnP0OzgQmJXmPyBGxoC
   zzvp0mx1f5RovIqvWhex7tRB6w7PJG9JAIvqTcGJYmxW0kivwvpEc1fhv
   X1UUbslMBZxqG+hEB/REjQfLUmd+4Z/cnMvTL42rlFlt/c/LTtzNEJW1k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336668227"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336668227"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:56:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="790277887"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790277887"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 05:56:04 -0700
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
Subject: [PATCH v7 19/22] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Date:   Thu, 16 Mar 2023 05:55:31 -0700
Message-Id: <20230316125534.17216-20-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316125534.17216-1-yi.l.liu@intel.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
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
 drivers/vfio/device_cdev.c | 153 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        |  13 ++++
 drivers/vfio/vfio_main.c   |   5 ++
 include/uapi/linux/vfio.h  |  37 +++++++++
 4 files changed, 208 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 1c640016a824..73430290e7d1 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2023 Intel Corporation.
  */
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio.h"
 
@@ -44,6 +45,158 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	return ret;
 }
 
+static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
+{
+	spin_lock(&df->kvm_ref_lock);
+	if (df->kvm)
+		_vfio_device_get_kvm_safe(df->device, df->kvm);
+	spin_unlock(&df->kvm_ref_lock);
+}
+
+void vfio_device_cdev_close(struct vfio_device_file *df)
+{
+	struct vfio_device *device = df->device;
+
+	/*
+	 * As df->access_granted writer is under dev_set->lock as well,
+	 * so this read no need to use smp_load_acquire() to pair with
+	 * smp_store_release() in the caller of vfio_device_open().
+	 */
+	if (!df->access_granted)
+		return;
+
+	mutex_lock(&device->dev_set->lock);
+	vfio_device_close(df);
+	vfio_device_put_kvm(device);
+	if (df->iommufd)
+		iommufd_ctx_put(df->iommufd);
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_unblock_group(device);
+}
+
+static int vfio_device_cdev_enable_noiommu(struct vfio_device *device)
+{
+	if (!vfio_device_is_noiommu(device))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	return 0;
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
+				    struct vfio_device_bind_iommufd __user *arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_bind_iommufd bind;
+	struct iommufd_ctx *iommufd = NULL;
+	unsigned long minsz;
+	int ret;
+
+	static_assert(__same_type(arg->out_devid, bind.out_devid));
+
+	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
+
+	if (copy_from_user(&bind, arg, minsz))
+		return -EFAULT;
+
+	if (bind.argsz < minsz || bind.flags)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	/* BIND_IOMMUFD only allowed for cdev fds */
+	if (df->group)
+		return -EINVAL;
+
+	ret = vfio_device_block_group(device);
+	if (ret)
+		return ret;
+
+	mutex_lock(&device->dev_set->lock);
+	/* one device cannot be bound twice */
+	if (df->access_granted) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* iommufd < 0 means noiommu mode */
+	if (bind.iommufd < 0) {
+		ret = vfio_device_cdev_enable_noiommu(device);
+		if (ret)
+			goto out_unlock;
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
+	ret = vfio_device_open(df);
+	if (ret)
+		goto out_put_kvm;
+
+	if (df->iommufd)
+		bind.out_devid = df->devid;
+
+	ret = copy_to_user(&arg->out_devid, &bind.out_devid,
+			   sizeof(bind.out_devid)) ? -EFAULT : 0;
+	if (ret)
+		goto out_close_device;
+
+	if (bind.iommufd < 0)
+		dev_warn(device->dev, "device is bound to vfio-noiommu by user "
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
index 5a53d0862d08..87b536a06f91 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -281,6 +281,9 @@ static inline void vfio_device_del(struct vfio_device *device)
 
 void vfio_init_device_cdev(struct vfio_device *device);
 int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
+void vfio_device_cdev_close(struct vfio_device_file *df);
+long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+				    struct vfio_device_bind_iommufd __user *arg);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -304,6 +307,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
 	return 0;
 }
 
+static inline void vfio_device_cdev_close(struct vfio_device_file *df)
+{
+}
+
+static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+						  struct vfio_device_bind_iommufd __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_cdev_init(struct class *device_class)
 {
 	return 0;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a979df2794d2..867c1353ede2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -556,6 +556,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	if (df->group)
 		vfio_device_group_close(df);
+	else
+		vfio_device_cdev_close(df);
 
 	vfio_device_put_registration(device);
 
@@ -1129,6 +1131,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	struct vfio_device *device = df->device;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, (void __user *)arg);
+
 	/* Paired with smp_store_release() following vfio_device_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 25432ef213ee..e902670dcbaa 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -194,6 +194,43 @@ struct vfio_group_status {
 
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
+ * the target device in other ioctls (e.g. iommu hardware infomration query
+ * via iommufd, and etc.).
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
+ * @out_devid:	 the device id generated by this bind. This field is valid
+ *		as long as the input @iommufd is valid. Otherwise, it is
+ *		meaningless.
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

