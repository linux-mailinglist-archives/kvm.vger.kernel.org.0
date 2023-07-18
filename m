Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184DA757EBE
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbjGRN6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjGRN61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:58:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A7B1990;
        Tue, 18 Jul 2023 06:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688683; x=1721224683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZBh7bMFBrgvlWP2zmLNuugMeEYlXwlvKD68Pxx2Yb3o=;
  b=nNLYi/NbOxhuYIymxNSMK5ZkKYmRIMN08nZdI67c2Ga2jS1mbIxR14L+
   DNS8u7PFSKydFvT/v8SvLQvzXHEjgbqL16G+Qt2MDqiXG+ghez/ODw//P
   daq5kHuqxdfmPglmuPSayFDbHFr2lTBAfa8nKcujRA2ILXWPau8lbiqQc
   1OcX8AJWyzLy01qQAVFiCOb/mla5Xdt1VoP6FpM7vnIj3JWL2L2bR72UO
   nx2V0phZ161Cx1emJyudCSDC43Rf8+t7iXzV4cBVVAR7N7B7ROrM0kgP6
   GHmpdSGjb9diOQz++OGMXuUSgRQfdKSKi0fYn7qjQOXWkKArOOpQ1A8Qs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452590819"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452590819"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:56:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="970251130"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="970251130"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2023 06:56:11 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v15 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Date:   Tue, 18 Jul 2023 06:55:47 -0700
Message-Id: <20230718135551.6592-23-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718135551.6592-1-yi.l.liu@intel.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds ioctl for userspace to bind device cdev fd to iommufd.

    VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
			      control provided by the iommufd. open_device
			      op is called after bind_iommufd op.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 107 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        |  13 +++++
 drivers/vfio/vfio_main.c   |   5 ++
 include/linux/vfio.h       |   5 +-
 include/uapi/linux/vfio.h  |  27 ++++++++++
 5 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bf1032d00107..f40784dd5561 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2023 Intel Corporation.
  */
 #include <linux/vfio.h>
+#include <linux/iommufd.h>
 
 #include "vfio.h"
 
@@ -45,6 +46,112 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	return ret;
 }
 
+static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
+{
+	spin_lock(&df->kvm_ref_lock);
+	vfio_device_get_kvm_safe(df->device, df->kvm);
+	spin_unlock(&df->kvm_ref_lock);
+}
+
+long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
+				struct vfio_device_bind_iommufd __user *arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_bind_iommufd bind;
+	unsigned long minsz;
+	int ret;
+
+	static_assert(__same_type(arg->out_devid, df->devid));
+
+	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
+
+	if (copy_from_user(&bind, arg, minsz))
+		return -EFAULT;
+
+	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
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
+	mutex_lock(&device->dev_set->lock);
+	/* one device cannot be bound twice */
+	if (df->access_granted) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
+	if (IS_ERR(df->iommufd)) {
+		ret = PTR_ERR(df->iommufd);
+		df->iommufd = NULL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Before the device open, get the KVM pointer currently
+	 * associated with the device file (if there is) and obtain
+	 * a reference.  This reference is held until device closed.
+	 * Save the pointer in the device for use by drivers.
+	 */
+	vfio_df_get_kvm_safe(df);
+
+	ret = vfio_df_open(df);
+	if (ret)
+		goto out_put_kvm;
+
+	ret = copy_to_user(&arg->out_devid, &df->devid,
+			   sizeof(df->devid)) ? -EFAULT : 0;
+	if (ret)
+		goto out_close_device;
+
+	device->cdev_opened = true;
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, true);
+	mutex_unlock(&device->dev_set->lock);
+	return 0;
+
+out_close_device:
+	vfio_df_close(df);
+out_put_kvm:
+	vfio_device_put_kvm(device);
+	iommufd_ctx_put(df->iommufd);
+	df->iommufd = NULL;
+out_unlock:
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_unblock_group(device);
+	return ret;
+}
+
+void vfio_df_unbind_iommufd(struct vfio_device_file *df)
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
+	vfio_df_close(df);
+	vfio_device_put_kvm(device);
+	iommufd_ctx_put(df->iommufd);
+	device->cdev_opened = false;
+	mutex_unlock(&device->dev_set->lock);
+	vfio_device_unblock_group(device);
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index c2aa65382592..b6d4ba1ef2b8 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -287,6 +287,9 @@ static inline void vfio_device_del(struct vfio_device *device)
 }
 
 int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
+long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
+				struct vfio_device_bind_iommufd __user *arg);
+void vfio_df_unbind_iommufd(struct vfio_device_file *df);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -310,6 +313,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
 	return 0;
 }
 
+static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
+					      struct vfio_device_bind_iommufd __user *arg)
+{
+	return -ENOTTY;
+}
+
+static inline void vfio_df_unbind_iommufd(struct vfio_device_file *df)
+{
+}
+
 static inline int vfio_cdev_init(struct class *device_class)
 {
 	return 0;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a2744cb64c6d..9fdf93ff17cf 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -575,6 +575,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	if (df->group)
 		vfio_df_group_close(df);
+	else
+		vfio_df_unbind_iommufd(df);
 
 	vfio_device_put_registration(device);
 
@@ -1149,6 +1151,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	void __user *uptr = (void __user *)arg;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_df_ioctl_bind_iommufd(df, uptr);
+
 	/* Paired with smp_store_release() following vfio_df_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e0069f26488d..d6228c839c44 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -64,8 +64,9 @@ struct vfio_device {
 	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
-	bool iommufd_attached;
+	u8 iommufd_attached:1;
 #endif
+	u8 cdev_opened:1;
 };
 
 /**
@@ -168,7 +169,7 @@ vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
 static inline bool vfio_device_cdev_opened(struct vfio_device *device)
 {
-	return false;
+	return device->cdev_opened;
 }
 
 /**
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4c3d548e9c96..098946b23e86 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -897,6 +897,33 @@ struct vfio_device_feature {
 
 #define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/*
+ * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
+ *				   struct vfio_device_bind_iommufd)
+ * @argsz:	 User filled size of this data.
+ * @flags:	 Must be 0.
+ * @iommufd:	 iommufd to bind.
+ * @out_devid:	 The device id generated by this bind. devid is a handle for
+ *		 this device/iommufd bond and can be used in IOMMUFD commands.
+ *
+ * Bind a vfio_device to the specified iommufd.
+ *
+ * User is restricted from accessing the device before the binding operation
+ * is completed.  Only allowed on cdev fds.
+ *
+ * Unbind is automatically conducted when device fd is closed.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_bind_iommufd {
+	__u32		argsz;
+	__u32		flags;
+	__s32		iommufd;
+	__u32		out_devid;
+};
+
+#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /*
  * Provide support for setting a PCI VF Token, which is used as a shared
  * secret between PF and VF drivers.  This feature may only be set on a
-- 
2.34.1

