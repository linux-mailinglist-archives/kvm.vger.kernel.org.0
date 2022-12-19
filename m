Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0152B6508C7
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiLSIsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiLSIrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89230BE2F
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439667; x=1702975667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CkVJOW6rGmVv11lIJVEphuL7LF+I9JfkeIFUwjs0JQw=;
  b=eeEX7sR+iyHyRiUA/0731chXlntGXTo4AQAj6GC5H/sV6rT77XaSMXBh
   KmDVQRV7jkpzTrkW+kJjpAr0dLO+mn7QGl3eyMZe/hZ255h5amnDQ4XYi
   qsqW6SCx8NVlGzv+qKNJls7hV9X1netpwVLD/4+N4V1Ui6A3wEnZltlkT
   jrUUOtlU6f64G38r7FY17c6sXGq4Cro6gHs60sj+11PhZYaSR1Ncychl2
   FvIgfj1bOsSY/jKYo4moFJVqtcjZBEUjH5eaFNo3oVbnAKWAJiQlEFQa0
   V18ETE4OHhtxZvBQ2/4yyg5nVe+MrqepTZyiR4y0YVjIkJfWcvrLT9Sx8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528491"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528491"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233800"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233800"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:46 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Date:   Mon, 19 Dec 2022 00:47:17 -0800
Message-Id: <20221219084718.9342-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
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

This adds two vfio device ioctls for userspace using iommufd on vfio
devices.

    VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
			      control provided by the iommufd. VFIO no
			      iommu is indicated by passing a minus
			      fd value.
    VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach device to ioas, page tables
				   managed by iommufd. Attach can be
				   undo by passing IOMMUFD_INVALID_ID
				   to kernel.

The ioctls introduced here are just on par with existing VFIO.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c     | 145 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/iommufd.h |   2 +
 include/uapi/linux/vfio.h    |  64 ++++++++++++++++
 3 files changed, 206 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4ba90b55ec44..d2a32b8a562b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -34,6 +34,7 @@
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
 #include <linux/iommufd.h>
+#include <uapi/linux/iommufd.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -415,7 +416,7 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
-	if (iommufd)
+	if (iommufd && !IS_ERR(iommufd))
 		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
 	else
 		ret = vfio_device_group_use_iommu(device);
@@ -432,7 +433,7 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 
 err_unuse_iommu:
 	device->kvm = NULL;
-	if (iommufd)
+	if (iommufd && !IS_ERR(iommufd))
 		vfio_iommufd_unbind(device);
 	else
 		vfio_device_group_unuse_iommu(device);
@@ -451,7 +452,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	if (iommufd)
+	if (iommufd && !IS_ERR(iommufd))
 		vfio_iommufd_unbind(device);
 	else
 		vfio_device_group_unuse_iommu(device);
@@ -495,11 +496,10 @@ int vfio_device_open(struct vfio_device_file *df,
 	return 0;
 }
 
-void vfio_device_close(struct vfio_device_file *df)
+static void __vfio_device_close(struct vfio_device_file *df)
 {
 	struct vfio_device *device = df->device;
 
-	mutex_lock(&device->dev_set->lock);
 	/*
 	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
 	 * read/write/mmap
@@ -511,6 +511,14 @@ void vfio_device_close(struct vfio_device_file *df)
 		device->single_open = false;
 	}
 	device->open_count--;
+}
+
+void vfio_device_close(struct vfio_device_file *df)
+{
+	struct vfio_device *device = df->device;
+
+	mutex_lock(&device->dev_set->lock);
+	__vfio_device_close(df);
 	mutex_unlock(&device->dev_set->lock);
 }
 
@@ -592,6 +600,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	 */
 	if (!df->single_open)
 		vfio_device_group_close(df);
+	else
+		vfio_device_close(df);
 	kfree(df);
 	vfio_device_put_registration(device);
 
@@ -1054,6 +1064,124 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 	}
 }
 
+static long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+					   unsigned long arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_bind_iommufd bind;
+	struct iommufd_ctx *iommufd;
+	unsigned long minsz;
+	struct fd f;
+	int ret;
+	bool access;
+
+	minsz = offsetofend(struct vfio_device_bind_iommufd, iommufd);
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
+	/* iommufd < 0 means noiommu mode */
+	if (bind.iommufd < 0) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		iommufd = ERR_PTR(-EINVAL);
+	} else {
+		f = fdget(bind.iommufd);
+		if (!f.file)
+			return -EBADF;
+
+		iommufd = iommufd_ctx_from_file(f.file);
+		if (IS_ERR(iommufd)) {
+			fdput(f);
+			return PTR_ERR(iommufd);
+		}
+	}
+
+	mutex_lock(&device->dev_set->lock);
+	/* Paired with smp_store_release() in vfio_device_open/close() */
+	access = smp_load_acquire(&df->access_granted);
+	if (access) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* df->kvm is supposed to be set in vfio_device_file_set_kvm() */
+	df->iommufd = iommufd;
+	ret = vfio_device_open(df, &bind.out_devid, NULL);
+	if (ret)
+		goto out_unlock;
+
+	ret = copy_to_user((void __user *)arg + minsz,
+			   &bind.out_devid,
+			   sizeof(bind.out_devid)) ? -EFAULT : 0;
+	if (ret)
+		goto out_close_device;
+
+	mutex_unlock(&device->dev_set->lock);
+	if (!IS_ERR(iommufd))
+		fdput(f);
+	else
+		dev_warn(device->dev, "vfio-noiommu device used by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+	return 0;
+
+out_close_device:
+	__vfio_device_close(df);
+out_unlock:
+	df->iommufd = NULL;
+	mutex_unlock(&device->dev_set->lock);
+	if (!IS_ERR(iommufd))
+		fdput(f);
+	return ret;
+}
+
+static int vfio_ioctl_device_attach(struct vfio_device *device,
+				    struct vfio_device_feature __user *arg)
+{
+	struct vfio_device_attach_iommufd_pt attach;
+	u32 pt_id;
+	int ret;
+
+	if (copy_from_user(&attach, (void __user *)arg, sizeof(attach)))
+		return -EFAULT;
+
+	if (attach.flags)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	mutex_lock(&device->dev_set->lock);
+	pt_id = attach.pt_id;
+	ret = vfio_iommufd_attach(device,
+				  pt_id != IOMMUFD_INVALID_ID ? &pt_id : NULL);
+	if (ret)
+		goto out_unlock;
+
+	if (pt_id != IOMMUFD_INVALID_ID) {
+		ret = copy_to_user((void __user *)arg + offsetofend(
+				   struct vfio_device_attach_iommufd_pt, flags),
+				   &pt_id,
+				   sizeof(pt_id)) ? -EFAULT : 0;
+		if (ret)
+			goto out_detach;
+	}
+	mutex_unlock(&device->dev_set->lock);
+	return 0;
+
+out_detach:
+	vfio_iommufd_attach(device, NULL);
+out_unlock:
+	mutex_unlock(&device->dev_set->lock);
+	return ret;
+}
+
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
@@ -1062,6 +1190,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	bool access;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, arg);
+
 	/* Paired with smp_store_release() in vfio_device_open/close() */
 	access = smp_load_acquire(&df->access_granted);
 	if (!access)
@@ -1076,6 +1207,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
 		break;
 
+	case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
+		ret = vfio_ioctl_device_attach(device, (void __user *)arg);
+		break;
+
 	default:
 		if (unlikely(!device->ops->ioctl))
 			ret = -EINVAL;
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 98ebba80cfa1..87680274c01b 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -9,6 +9,8 @@
 
 #define IOMMUFD_TYPE (';')
 
+#define IOMMUFD_INVALID_ID 0  /* valid ID starts from 1 */
+
 /**
  * DOC: General ioctl format
  *
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d7d8e0922376..d5cb347c0763 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -190,6 +190,70 @@ struct vfio_group_status {
 
 /* --------------- IOCTLs for DEVICE file descriptors --------------- */
 
+/*
+ * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
+ *				   struct vfio_device_bind_iommufd)
+ *
+ * Bind a vfio_device to the specified iommufd and an ioas or a hardware
+ * page table.
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
+ * @iommufd:	 iommufd to bind. iommufd < 0 means noiommu.
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
+ * id or hardware page table id.
+ *
+ * Available only after a device has been bound to iommufd via
+ * VFIO_DEVICE_BIND_IOMMUFD
+ *
+ * Undo by passing pt_id == IOMMUFD_INVALID_ID
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	must be 0.
+ * @pt_id:	Input the target id, can be an ioas or a hwpt allocated
+ *		via iommufd subsystem, and output the attached pt_id. It
+ *		be the ioas, hwpt itself or an hwpt created by kernel
+ *		during the attachment.
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
 /**
  * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
  *						struct vfio_device_info)
-- 
2.34.1

