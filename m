Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028F86B093D
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjCHNdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjCHNdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:33:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D7580E2;
        Wed,  8 Mar 2023 05:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282301; x=1709818301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jQI11V9I2VfPt6XpbiUYEXw6DQ12QXvh5vFb+3F7BPM=;
  b=nfyfOWEVzHY4FlF8uK9u24XgT+qnRrL01olgF/+jLtcWiLLn+Wp0H1FS
   uv33zk5Xz7XxY3RUQfsPZo6V/GJUPjCmYFuPhomgqU7ePZ7eAE9cYJ0Ox
   VfqnlyuKT+pMcu6DSfZ0/WEp5O1VVNRVBe3ki2qQEUHPUQjoOQ/9OpjA8
   EtQahKvMsSFDnGwVPFVmAJpL9vuu7rTYUPNZL9vf0uQOjy5g6UNoLo8UK
   L7kproKQaVrMlVS/NVgJ25UDr4yBwjcZVXJIR71w3tbMx3Iq3IdvqiH/k
   p7rrtEvbkU5GQMuwjyk66o3IHECM2n2+qu/UcsiZGqV0LRY+qQ7dtc/fl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165345"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165345"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789460"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789460"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:42 -0800
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
Subject: [PATCH v6 22/24] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Date:   Wed,  8 Mar 2023 05:29:01 -0800
Message-Id: <20230308132903.465159-23-yi.l.liu@intel.com>
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

This adds ioctl for userspace to attach device cdev fd to and detach
from IOAS/hw_pagetable managed by iommufd.

    VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS, hw_pagetable
				   managed by iommufd. Attach can be
				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
				   or device fd close.
    VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current attached
				   IOAS or hw_pagetable managed by iommufd.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/device_cdev.c | 85 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        | 16 +++++++
 drivers/vfio/vfio_main.c   |  8 ++++
 include/uapi/linux/vfio.h  | 52 +++++++++++++++++++++++
 4 files changed, 161 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 568cc9da16c7..77e0f34f6bc7 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -210,6 +210,91 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	return ret;
 }
 
+int vfio_ioctl_device_attach(struct vfio_device_file *df,
+			     struct vfio_device_attach_iommufd_pt __user *arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_attach_iommufd_pt attach;
+	unsigned long minsz;
+	int ret;
+
+	static_assert(__same_type(arg->pt_id, attach.pt_id));
+
+	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
+
+	if (copy_from_user(&attach, arg, minsz))
+		return -EFAULT;
+
+	if (attach.argsz < minsz || attach.flags)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	/* ATTACH only allowed for cdev fds */
+	if (df->group)
+		return -EINVAL;
+
+	mutex_lock(&device->dev_set->lock);
+	/* noiommufd mode doesn't allow attach */
+	if (!df->iommufd) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	ret = device->ops->attach_ioas(device, &attach.pt_id);
+	if (ret)
+		goto out_unlock;
+
+	ret = copy_to_user(&arg->pt_id, &attach.pt_id,
+			   sizeof(attach.pt_id)) ? -EFAULT : 0;
+	if (ret)
+		goto out_detach;
+	mutex_unlock(&device->dev_set->lock);
+
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
+			     struct vfio_device_detach_iommufd_pt __user *arg)
+{
+	struct vfio_device *device = df->device;
+	struct vfio_device_detach_iommufd_pt detach;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
+
+	if (copy_from_user(&detach, arg, minsz))
+		return -EFAULT;
+
+	if (detach.argsz < minsz || detach.flags)
+		return -EINVAL;
+
+	if (!device->ops->bind_iommufd)
+		return -ENODEV;
+
+	/* DETACH only allowed for cdev fds */
+	if (df->group)
+		return -EINVAL;
+
+	mutex_lock(&device->dev_set->lock);
+	/* noiommufd mode doesn't support detach */
+	if (!df->iommufd) {
+		mutex_unlock(&device->dev_set->lock);
+		return -EOPNOTSUPP;
+	}
+	device->ops->detach_ioas(device);
+	mutex_unlock(&device->dev_set->lock);
+
+	return 0;
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 5df737b24102..8b70e2af4ece 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -278,6 +278,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
 void vfio_device_cdev_close(struct vfio_device_file *df);
 long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 				    struct vfio_device_bind_iommufd __user *arg);
+int vfio_ioctl_device_attach(struct vfio_device_file *df,
+			     struct vfio_device_attach_iommufd_pt __user *arg);
+int vfio_ioctl_device_detach(struct vfio_device_file *df,
+			     struct vfio_device_detach_iommufd_pt __user *arg);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -311,6 +315,18 @@ static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	return -EOPNOTSUPP;
 }
 
+static inline int vfio_ioctl_device_attach(struct vfio_device_file *df,
+					   struct vfio_device_attach_iommufd_pt __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int vfio_ioctl_device_detach(struct vfio_device_file *df,
+					   struct vfio_device_detach_iommufd_pt __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_cdev_init(struct class *device_class)
 {
 	return 0;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 08bb1705d02d..e5f4738692ac 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1170,6 +1170,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
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
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index a53afe349a34..692156a708bb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -231,6 +231,58 @@ struct vfio_device_bind_iommufd {
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
 
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
+ * VFIO_DEVICE_BIND_IOMMUFD.
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

