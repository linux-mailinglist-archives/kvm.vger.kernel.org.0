Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFEF6D3245
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDAPTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjDAPS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD61426240;
        Sat,  1 Apr 2023 08:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362330; x=1711898330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nxxu8mv/ExSN3oQSYj+ulTQ2pvW0BPiusuSRvWs4H04=;
  b=AUJq3CGxvfdcEsXsLx87WitX5kmOJKjlFNmLuuY+e5Ern6ZKP5yIUCSm
   JDapu7TjLpqUTxA1Iu4T3eYP14SLTYjOjqQdz75Z3ThhY9FKlFMdJgUcJ
   TxwwMUijwP1/k+bCwEXb3TPXSelAXt1eoSyiMNYW1YesKNhWbJHgeYQSa
   9yaOxOMvBBFOx0khfTzHoq3QukqwpiXvGnJ5XFt6eyDLlO1F0hD4PTJdO
   BOODUoJsCqGDtgcsut+r1sADY1K1V/vQ+Gk3QDg8pRkCsuQscdJ6irhyu
   xknepjd2/5VDh4wwl3OKeFfidJQ6pdw5dJHFpQQiAtYu3+WZwQ4913EOm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411389"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411389"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937232"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937232"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:47 -0700
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
        yanting.jiang@intel.com
Subject: [PATCH v9 22/25] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Date:   Sat,  1 Apr 2023 08:18:30 -0700
Message-Id: <20230401151833.124749-23-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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
			      VFIO_NOIOMMU_FD (-1) as iommufd value.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 152 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        |  13 ++++
 drivers/vfio/vfio_main.c   |   5 ++
 include/uapi/linux/vfio.h  |  31 ++++++++
 4 files changed, 201 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 1c640016a824..e3c51d2f5732 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2023 Intel Corporation.
  */
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio.h"
 
@@ -44,6 +45,157 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
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
+	 * In the time of close, there is no contention with another one
+	 * changing this flag.  So read df->access_granted without lock
+	 * and no smp_load_acquire() is ok.
+	 */
+	if (!df->access_granted)
+		return;
+
+	mutex_lock(&device->dev_set->lock);
+	vfio_device_close(df);
+	vfio_device_put_kvm(device);
+	if (df->iommufd)
+		iommufd_ctx_put(df->iommufd);
+	device->cdev_opened = false;
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_unblock_group(device);
+}
+
+static int vfio_device_cdev_probe_noiommu(struct vfio_device *device)
+{
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	if (!device->noiommu)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
+{
+	struct iommufd_ctx *iommufd;
+	struct fd f;
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
+	unsigned long minsz;
+	bool is_noiommu;
+	int ret;
+
+	static_assert(__same_type(arg->out_devid, df->devid));
+
+	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
+
+	if (copy_from_user(&bind, arg, minsz))
+		return -EFAULT;
+
+	if (bind.argsz < minsz || bind.flags)
+		return -EINVAL;
+
+	/* BIND_IOMMUFD only allowed for cdev fds */
+	if (df->group)
+		return -EINVAL;
+
+	ret = vfio_device_block_group(device);
+	if (ret)
+		return ret;
+
+	is_noiommu = bind.iommufd == VFIO_NOIOMMU_FD;
+
+	mutex_lock(&device->dev_set->lock);
+	/* one device cannot be bound twice */
+	if (df->access_granted) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (is_noiommu) {
+		ret = vfio_device_cdev_probe_noiommu(device);
+		if (ret)
+			goto out_unlock;
+	} else {
+		df->iommufd = vfio_get_iommufd_from_fd(bind.iommufd);
+		if (IS_ERR(df->iommufd)) {
+			ret = PTR_ERR(df->iommufd);
+			df->iommufd = NULL;
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
+	ret = vfio_device_open(df);
+	if (ret)
+		goto out_put_kvm;
+
+	if (is_noiommu) {
+		dev_warn(device->dev, "device is bound to vfio-noiommu by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+	} else {
+		ret = copy_to_user(&arg->out_devid, &df->devid,
+				   sizeof(df->devid)) ? -EFAULT : 0;
+		if (ret)
+			goto out_close_device;
+	}
+
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, true);
+	device->cdev_opened = true;
+	mutex_unlock(&device->dev_set->lock);
+
+	return 0;
+
+out_close_device:
+	vfio_device_close(df);
+out_put_kvm:
+	vfio_device_put_kvm(device);
+	if (!is_noiommu) {
+		iommufd_ctx_put(df->iommufd);
+		df->iommufd = NULL;
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
index 3a8fd0e32f59..ace3d52b0928 100644
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
index 61f56d9b5e5f..0611e29e41a9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -565,6 +565,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	if (df->group)
 		vfio_device_group_close(df);
+	else
+		vfio_device_cdev_close(df);
 
 	vfio_device_put_registration(device);
 
@@ -1138,6 +1140,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	struct vfio_device *device = df->device;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, (void __user *)arg);
+
 	/* Paired with smp_store_release() following vfio_device_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5a34364e3b94..84d76630dd60 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -194,6 +194,37 @@ struct vfio_group_status {
 
 /* --------------- IOCTLs for DEVICE file descriptors --------------- */
 
+/*
+ * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
+ *				   struct vfio_device_bind_iommufd)
+ *
+ * Bind a vfio_device to the specified iommufd.
+ *
+ * User is restricted from accessing the device before the binding operation
+ * is completed.
+ *
+ * Unbind is automatically conducted when device fd is closed.
+ *
+ * @argsz:	 user filled size of this data.
+ * @flags:	 reserved for future extension.
+ * @iommufd:	 iommufd to bind. VFIO_NOIOMMU_FD means noiommu.
+ * @out_devid:	 the device id generated by this bind. This field is valid
+ *		as long as the input @iommufd is valid. Otherwise, it is
+ *		meaningless. devid is a handle for this device and can be
+ *		used in IOMMUFD commands.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_bind_iommufd {
+	__u32		argsz;
+	__u32		flags;
+	__s32		iommufd;
+#define VFIO_NOIOMMU_FD	(-1)
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

