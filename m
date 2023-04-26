Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44B36EF769
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241473AbjDZPFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 11:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241533AbjDZPEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 11:04:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D4D7688;
        Wed, 26 Apr 2023 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682521474; x=1714057474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oAmMYYLXdvATNwuwzvX1zoTUqYL0u+TNIV6KJMkGxbU=;
  b=YuduEH6Uy1cEW5qLi705A6Co/JNZhiNFWQPm59Qa60AXfcStF9BGj6fH
   QsUHb0AkVtiD/1Ja9TrzyE8N7qDO/Ug5iv3xh0oiZHvCU5UQ6NeoJbGNo
   e5JBWgWlMeLqPTn3YMAk61iOxLE2rZLkT+KQYO+8SMW49pEtYvwKnJ7gn
   gDbie9d8lUICEszZcb5Dvxlj1yHPJkWBW0mMxZc7DqtMyKyW3C0005epX
   UuCk/nVIwMLqA9FIvH51MOu8z/xG7ZJKdfq1zPeVmTbIgXPeTrWohF8UN
   oqzr2zkvZd13Vf1GefAzhqEp9rm8jh5AzGIzGQDOF8rBcRwEze/vVLzKD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="349944684"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="349944684"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:04:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="805544314"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="805544314"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 26 Apr 2023 08:03:59 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v10 20/22] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Date:   Wed, 26 Apr 2023 08:03:19 -0700
Message-Id: <20230426150321.454465-21-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426150321.454465-1-yi.l.liu@intel.com>
References: <20230426150321.454465-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/vfio/device_cdev.c | 66 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/iommufd.c     | 20 ++++++++++++
 drivers/vfio/vfio.h        | 18 +++++++++++
 drivers/vfio/vfio_main.c   |  8 +++++
 include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++++++
 5 files changed, 164 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 004217e6f758..6d7f50ee535d 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -174,6 +174,72 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
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
+	ret = vfio_iommufd_attach(device, &attach.pt_id);
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
+	vfio_iommufd_detach(device);
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
+	vfio_iommufd_detach(device);
+	mutex_unlock(&device->dev_set->lock);
+
+	return 0;
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 49dc1182dea8..00c14821bfa5 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -76,6 +76,26 @@ void vfio_iommufd_unbind(struct vfio_device_file *df)
 		vdev->ops->unbind_iommufd(vdev);
 }
 
+int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->noiommu)
+		return vfio_iommufd_emulated_attach_ioas(vdev, pt_id);
+
+	return vdev->ops->attach_ioas(vdev, pt_id);
+}
+
+void vfio_iommufd_detach(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->noiommu)
+		vfio_iommufd_emulated_detach_ioas(vdev);
+	else
+		vdev->ops->detach_ioas(vdev);
+}
+
 struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
 {
 	if (vdev->iommufd_device)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index c38ee0e0cd54..c8579d63b2b9 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -242,6 +242,8 @@ int vfio_iommufd_bind(struct vfio_device_file *df);
 void vfio_iommufd_unbind(struct vfio_device_file *df);
 int vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
 				    struct iommufd_ctx *ictx);
+int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id);
+void vfio_iommufd_detach(struct vfio_device *vdev);
 #else
 static inline int
 vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
@@ -283,6 +285,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
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
@@ -316,6 +322,18 @@ static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
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
index e9ee5ab7257b..1004863efc14 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1154,6 +1154,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
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
index 43b1b9f8cd24..62bd41c214fd 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -222,6 +222,58 @@ struct vfio_device_bind_iommufd {
 
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
+ *		Output the input ioas id or the attached hwpt id which could
+ *		be the specified hwpt itself or a hwpt automatically created
+ *		for the specified ioas by kernel during the attachment.
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

