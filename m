Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B416D3244
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDAPTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjDAPS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD45A25570;
        Sat,  1 Apr 2023 08:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362330; x=1711898330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=08bjCZhxXGSjuh8rdxCrsBgcg7gZq7iG60aLor7QczQ=;
  b=WQTHNrQ6hgG0CUjzl/aTj2IV/mozgj6HbqqFE5VCbN03AFlhll8wMyBt
   L+AtB8rjxQnGvePcICUiV5TTWdwctraSU3LyEa1T+UUN2ebAbTrnohSfB
   AZPH1AgRGX5peE19X3WapS2YvlaPIkKOyx78q8kbGTfSGasYMVN5d0RJP
   x1A/9PsASu9SmGvdpLXgfyB+RudCoGo5Dd7PjmmnRpfLRtTmsdg3XtS+b
   6VKFeE5+R8xFJWIAa1pHRi0Pf5iYsmwyQV00P6MYHDbctiRb7QCIhHoDT
   c0J+RGQl6FxCmHpofEN8ThcRokqz0LmEjaAv2/ehdXDhCfK0YxaTZLom1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411400"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411400"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937236"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937236"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:48 -0700
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
Subject: [PATCH v9 23/25] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Date:   Sat,  1 Apr 2023 08:18:31 -0700
Message-Id: <20230401151833.124749-24-yi.l.liu@intel.com>
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

This adds ioctl for userspace to attach device cdev fd to and detach
from IOAS/hw_pagetable managed by iommufd.

    VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS, hw_pagetable
				   managed by iommufd. Attach can be
				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
				   or device fd close.
    VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current attached
				   IOAS or hw_pagetable managed by iommufd.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 77 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        | 16 ++++++++
 drivers/vfio/vfio_main.c   |  8 ++++
 include/uapi/linux/vfio.h  | 52 +++++++++++++++++++++++++
 4 files changed, 153 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index e3c51d2f5732..12a8435649e9 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -196,6 +196,83 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
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
+	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
+
+	if (copy_from_user(&attach, arg, minsz))
+		return -EFAULT;
+
+	if (attach.argsz < minsz || attach.flags)
+		return -EINVAL;
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
index ace3d52b0928..c199e410db18 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -284,6 +284,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
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
@@ -317,6 +321,18 @@ static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
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
index 0611e29e41a9..9e2f2daf056a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1156,6 +1156,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
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
index 84d76630dd60..a356596f882d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -225,6 +225,58 @@ struct vfio_device_bind_iommufd {
 
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

