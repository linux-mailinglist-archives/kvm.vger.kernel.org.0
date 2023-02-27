Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A2D6A4054
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjB0LM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjB0LM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:12:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D6C1E5C1;
        Mon, 27 Feb 2023 03:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496320; x=1709032320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+2nGFqMlUexalcfwI76Tj5hlMkcgxqcd4DR0EsI5nmE=;
  b=R3xkkc3VlULjS/gAiqnvM/WED+aaT1yy+aMNry7WzQZByOUQguetnutu
   zIbb2/ltMWvOsgc2OHrz22r618rohvlyNtju8Utvk7JFEN0/Y5qGzTAvl
   gtk8t82ifPRa3p7+CZX2dXNRadaHPCtRh4j8IbAjVeQpbs0UkC+NxoqU6
   WLGKPLZTAv0NF6aBeFHGF81CapFW60fb7f3b1IQaLcFHjTo6YrjrJ9frp
   xp5/5+8rWX4mm+dFz8puXBPni0AV77ThwN2YhYlB/vdj0IVqRbSnjOIbd
   S6O25zbitFe5tXRNBIcgN5HVJBnV+BoeEO0jhjCKDPrt9jn2lbTkWM/k1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097773"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097773"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189613"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189613"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:49 -0800
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
Subject: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Date:   Mon, 27 Feb 2023 03:11:33 -0800
Message-Id: <20230227111135.61728-18-yi.l.liu@intel.com>
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
---
 drivers/vfio/device_cdev.c | 76 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        | 16 ++++++++
 drivers/vfio/vfio_main.c   |  8 ++++
 include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++
 4 files changed, 152 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 37f80e368551..5b5a249a6612 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -191,6 +191,82 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	return ret;
 }
 
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
+
+	return 0;
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 4716a904e63b..5a1ceb014779 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -274,6 +274,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
 void vfio_device_cdev_close(struct vfio_device_file *df);
 long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 				    unsigned long arg);
+int vfio_ioctl_device_attach(struct vfio_device_file *df,
+			     void __user *arg);
+int vfio_ioctl_device_detach(struct vfio_device_file *df,
+			     void __user *arg);
 int vfio_cdev_init(struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
@@ -307,6 +311,18 @@ static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	return -EOPNOTSUPP;
 }
 
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
index 69d0add930bb..f68550fe206f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1161,6 +1161,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
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
index 92aa8dbc970a..ff8753d0abb0 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -228,6 +228,58 @@ struct vfio_device_bind_iommufd {
 
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

