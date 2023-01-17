Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C582666DF5D
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjAQNus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjAQNuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6573E367E0
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963399; x=1705499399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eor2XodTuo+1n2yc1CRomFNfDbYdFRiv33jME0SEMMU=;
  b=Ji5pHE0t1kc1aYv/h8Ub3kPjSL7prw4qvxWGjeOTNVv+F5t3hcRipabd
   AcRL9EoepkP9T+O9djske60NfwkKrAsq+warVjrN+7cypj0cKkEyMhBPe
   YICf/jyNJ9C9RQFg3bRird/+PI1ImCAqIQkB7MiFhKQyTfDU0pNWJHL1W
   Hm2K0fdBRDNvnMKoQURTIwu2EPoSVSZjyVkcdnmneK0+fUdQjucju2SuP
   LdlHkjNePcQ6RP4HHUKfVOB8tOt+DaoH9PkhY4sH768MLPadQ0M46fpJa
   X1CYlg2CCQ5ksHb7fRGuy6gLeykqAyTVY888ijmkzmPHramPsiI2K2D+R
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766473"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766473"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551092"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551092"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:59 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 12/13] vfio: Add ioctls for device cdev iommufd
Date:   Tue, 17 Jan 2023 05:49:41 -0800
Message-Id: <20230117134942.101112-13-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
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
 drivers/vfio/vfio.h          |   1 +
 drivers/vfio/vfio_main.c     | 175 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/iommufd.h |   2 +
 include/uapi/linux/vfio.h    |  64 +++++++++++++
 4 files changed, 237 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index bdcf9762521d..444be924c915 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -25,6 +25,7 @@ struct vfio_device_file {
 	struct kvm *kvm;
 	struct iommufd_ctx *iommufd;
 	bool access_granted;
+	bool noiommu;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6068ffb7c6b7..99ebb5bd1eda 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -34,6 +34,7 @@
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
 #include <linux/iommufd.h>
+#include <uapi/linux/iommufd.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -402,12 +403,37 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/* df->iommufd and df->noiommu should be exclusive */
+	if (WARN_ON(iommufd && df->noiommu))
+		return -EINVAL;
+
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
+	/*
+	 * For group path, iommufd pointer is NULL when comes into this
+	 * helper. Its noiommu support is in container.c.
+	 *
+	 * For iommufd compat mode, iommufd pointer here is a valid value.
+	 * Its noiommu support is supposed to be in vfio_iommufd_bind().
+	 *
+	 * For device cdev path, iommufd pointer here is a valid value for
+	 * normal cases, but it is NULL if it's noiommu. The reason is
+	 * that userspace uses iommufd==-1 to indicate noiommu mode in this
+	 * path. So caller of this helper will pass in a NULL iommufd
+	 * pointer. To differentiate it from the group path which also
+	 * passes NULL iommufd pointer in, df->noiommu is used. For cdev
+	 * noiommu, df->noiommu would be set to mark noiommu case for cdev
+	 * path.
+	 *
+	 * So if df->noiommu is set then this helper just goes ahead to
+	 * open device. If not, it depends on if iommufd pointer is NULL
+	 * to handle the group path, iommufd compat mode, normal cases in
+	 * the cdev path.
+	 */
 	if (iommufd)
 		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
-	else
+	else if (!df->noiommu)
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
@@ -424,7 +450,7 @@ static int vfio_device_first_open(struct vfio_device_file *df,
 	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (!df->noiommu)
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
@@ -443,7 +469,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (!df->noiommu)
 		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
@@ -485,17 +511,24 @@ int vfio_device_open(struct vfio_device_file *df,
 	return 0;
 }
 
-void vfio_device_close(struct vfio_device_file *df)
+static void __vfio_device_close(struct vfio_device_file *df)
 {
 	struct vfio_device *device = df->device;
 
-	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
 	if (device->open_count == 1) {
 		vfio_device_last_close(df);
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
 
@@ -577,6 +610,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	 */
 	if (!df->single_open)
 		vfio_device_group_close(df);
+	else
+		vfio_device_close(df);
 
 	vfio_device_put_registration(device);
 
@@ -1143,6 +1178,129 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 	}
 }
 
+static long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
+					   unsigned long arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_bind_iommufd bind;
+	struct iommufd_ctx *iommufd = NULL;
+	unsigned long minsz;
+	struct fd f;
+	int ret;
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
+	/* df->kvm is supposed to be set in vfio_device_file_set_kvm() */
+	df->iommufd = iommufd;
+	ret = vfio_device_open(df, &bind.out_devid, NULL);
+	if (ret)
+		goto out_put_file;
+
+	ret = copy_to_user((void __user *)arg + minsz,
+			   &bind.out_devid,
+			   sizeof(bind.out_devid)) ? -EFAULT : 0;
+	if (ret)
+		goto out_close_device;
+
+	mutex_unlock(&device->dev_set->lock);
+	if (iommufd)
+		fdput(f);
+	else if (df->noiommu)
+		dev_warn(device->dev, "vfio-noiommu device used by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+	return 0;
+
+out_close_device:
+	__vfio_device_close(df);
+out_put_file:
+	if (iommufd)
+		fdput(f);
+out_unlock:
+	df->iommufd = NULL;
+	df->noiommu = false;
+	mutex_unlock(&device->dev_set->lock);
+	return ret;
+}
+
+static int vfio_ioctl_device_attach(struct vfio_device *device,
+				    struct vfio_device_feature __user *arg)
+{
+	struct vfio_device_attach_iommufd_pt attach;
+	int ret;
+	bool is_attach;
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
+	is_attach = attach.pt_id != IOMMUFD_INVALID_ID;
+	ret = vfio_iommufd_attach(device, is_attach ? &attach.pt_id : NULL);
+	if (ret)
+		goto out_unlock;
+
+	if (is_attach) {
+		ret = copy_to_user((void __user *)arg + offsetofend(
+				   struct vfio_device_attach_iommufd_pt, flags),
+				   &attach.pt_id,
+				   sizeof(attach.pt_id)) ? -EFAULT : 0;
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
@@ -1151,6 +1309,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	bool access;
 	int ret;
 
+	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
+		return vfio_device_ioctl_bind_iommufd(df, arg);
+
 	/* Paired with smp_store_release() in vfio_device_open() */
 	access = smp_load_acquire(&df->access_granted);
 	if (!access)
@@ -1165,6 +1326,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
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
index 23105eb036fa..235d3485a883 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -190,6 +190,70 @@ struct vfio_group_status {
 
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
+ * id or hw_pagetable (hwpt) id.
+ *
+ * Available only after a device has been bound to iommufd via
+ * VFIO_DEVICE_BIND_IOMMUFD
+ *
+ * Undo by passing pt_id == IOMMUFD_INVALID_ID
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
 /**
  * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
  *						struct vfio_device_info)
-- 
2.34.1

