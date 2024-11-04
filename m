Return-Path: <kvm+bounces-30549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D86089BB61D
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 072151C21D67
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1889813D53D;
	Mon,  4 Nov 2024 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCeLcUaw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D34A13A257
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726859; cv=none; b=ldmsBGf1AjZKxAonERmsauYYbNf6ZC50n7Kh2vzOM9UQoHP5IcRcBhp1jY5PfzOQdWGUC/F3e+eEYHWt0VuuVdnnx4q89XxsLPb0if/lY/0xN87R0UCuK1cDwS3VBsVxW0QHPetDvAxNUznIToE7y0u4D3wI5uGFPrqsbYuJpuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726859; c=relaxed/simple;
	bh=5AEHrFelzzYCbUMFTwKTciwsccytUM8vk4BGolHmtHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q3MQF7OPOMf6Jal8QzedmFDsuaDTU5HVq27SOc64/BLTfwBcLB0Fni0Me+U9rJBA1vpcplihPt0Y1vIn1SHZrXP04vtL9orNyEozMRh3HnHmUcVF6+hDUXd35VtWoMDflEuCxdxJWkiH4fgkUALsSt5kWniDklK4ULnBQCRyS/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCeLcUaw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726858; x=1762262858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5AEHrFelzzYCbUMFTwKTciwsccytUM8vk4BGolHmtHE=;
  b=oCeLcUawRMWioGy1VF7uo8OAlJefNxDjDP+9qThws0MbDCcBGmvWBgUH
   c6SyeddDK/i/qPLKMKzVkF8Vu1MkVLxHGHmsHSlQ8ECZk936Ztw+zzHrE
   fu405b+swlG2L6BfKsFQBCO0KyhkGWTt13i0KMP1d80BDkVAOaVYgf8lH
   SF56XRZV4QwYeKnZV+1bQmho8bmvSKI2aipQJJQXI7dD9Ss0+YDAYs89+
   V6TYB4xdzFI4Tw6ra9+UuX5nnGtZTVXCdi+/OzaPoax9Q1d0FhzAmypuo
   urmjj4cUPuQzqWM+6kTjBw6UMkkfKOYJdXmOaDbG6hTevKyX5vhK4NkkN
   Q==;
X-CSE-ConnectionGUID: dIF6byq2Rp2fYq1PDogXLA==
X-CSE-MsgGUID: HtKtPR8xQjiP+1yaynJhcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884582"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884582"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:27:36 -0800
X-CSE-ConnectionGUID: 8cUuzv/fSV26JYbo1UztVg==
X-CSE-MsgGUID: 6RiW8GfCR7qz1XoV3uikFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100911"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:27:36 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: joro@8bytes.org,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	willy@infradead.org
Subject: [PATCH v4 3/4] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
Date: Mon,  4 Nov 2024 05:27:31 -0800
Message-Id: <20241104132732.16759-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132732.16759-1-yi.l.liu@intel.com>
References: <20241104132732.16759-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
a given pasid of a vfio device to/from an IOAS/HWPT.

vfio_copy_from_user() is added to copy the user data for the case in which
the existing user struct has introduced new fields. The rule is not breaking
the existing usersapce. The kernel only copies the new fields when the
corresponding flag is set by the userspace. For the case that has multiple
new fields marked by different flags, kernel checks the flags one by one to
get the correct size to copy besides the minsz. Such logics can be shared by
the other uapi extensions, hence add a helper for it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 62 +++++++++++++++++++++++++++-----------
 drivers/vfio/vfio.h        | 18 +++++++++++
 drivers/vfio/vfio_main.c   | 55 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h  | 29 ++++++++++++------
 4 files changed, 136 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..bd13ddbfb9e3 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -159,24 +159,44 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
 	vfio_device_unblock_group(device);
 }
 
+#define VFIO_ATTACH_FLAGS_MASK VFIO_DEVICE_ATTACH_PASID
+static unsigned long
+vfio_attach_xends[ilog2(VFIO_ATTACH_FLAGS_MASK) + 1] = {
+	XEND_SIZE(VFIO_DEVICE_ATTACH_PASID,
+		  struct vfio_device_attach_iommufd_pt, pasid),
+};
+
+#define VFIO_DETACH_FLAGS_MASK VFIO_DEVICE_DETACH_PASID
+static unsigned long
+vfio_detach_xends[ilog2(VFIO_DETACH_FLAGS_MASK) + 1] = {
+	XEND_SIZE(VFIO_DEVICE_DETACH_PASID,
+		  struct vfio_device_detach_iommufd_pt, pasid),
+};
+
 int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 			    struct vfio_device_attach_iommufd_pt __user *arg)
 {
-	struct vfio_device *device = df->device;
 	struct vfio_device_attach_iommufd_pt attach;
-	unsigned long minsz;
+	struct vfio_device *device = df->device;
 	int ret;
 
-	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
-
-	if (copy_from_user(&attach, arg, minsz))
-		return -EFAULT;
+	ret = VFIO_COPY_USER_DATA((void __user *)arg, &attach,
+				  struct vfio_device_attach_iommufd_pt,
+				  pt_id, VFIO_ATTACH_FLAGS_MASK,
+				  vfio_attach_xends);
+	if (ret)
+		return ret;
 
-	if (attach.argsz < minsz || attach.flags)
-		return -EINVAL;
+	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
+	    !device->ops->pasid_attach_ioas)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&device->dev_set->lock);
-	ret = device->ops->attach_ioas(device, &attach.pt_id);
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
+		ret = device->ops->pasid_attach_ioas(device, attach.pasid,
+						     &attach.pt_id);
+	else
+		ret = device->ops->attach_ioas(device, &attach.pt_id);
 	if (ret)
 		goto out_unlock;
 
@@ -198,20 +218,26 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 			    struct vfio_device_detach_iommufd_pt __user *arg)
 {
-	struct vfio_device *device = df->device;
 	struct vfio_device_detach_iommufd_pt detach;
-	unsigned long minsz;
-
-	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
+	struct vfio_device *device = df->device;
+	int ret;
 
-	if (copy_from_user(&detach, arg, minsz))
-		return -EFAULT;
+	ret = VFIO_COPY_USER_DATA((void __user *)arg, &detach,
+				  struct vfio_device_detach_iommufd_pt,
+				  flags, VFIO_DETACH_FLAGS_MASK,
+				  vfio_detach_xends);
+	if (ret)
+		return ret;
 
-	if (detach.argsz < minsz || detach.flags)
-		return -EINVAL;
+	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
+	    !device->ops->pasid_detach_ioas)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&device->dev_set->lock);
-	device->ops->detach_ioas(device);
+	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
+		device->ops->pasid_detach_ioas(device, detach.pasid);
+	else
+		device->ops->detach_ioas(device);
 	mutex_unlock(&device->dev_set->lock);
 
 	return 0;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..9f081cf01c5a 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -34,6 +34,24 @@ void vfio_df_close(struct vfio_device_file *df);
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
 
+int vfio_copy_from_user(void *buffer, void __user *arg,
+			unsigned long minsz, u32 flags_mask,
+			unsigned long *xend_array);
+
+#define VFIO_COPY_USER_DATA(_arg, _local_buffer, _struct, _min_last,          \
+			    _flags_mask, _xend_array)                         \
+	vfio_copy_from_user(_local_buffer, _arg,                              \
+			    offsetofend(_struct, _min_last) +                \
+			    BUILD_BUG_ON_ZERO(offsetof(_struct, argsz) !=     \
+					      0) +                            \
+			    BUILD_BUG_ON_ZERO(offsetof(_struct, flags) !=     \
+					      sizeof(u32)),                   \
+			    _flags_mask, _xend_array)
+
+#define XEND_SIZE(_flag, _struct, _xlast)                                    \
+	[ilog2(_flag)] = offsetofend(_struct, _xlast) +                      \
+			 BUILD_BUG_ON_ZERO(_flag == 0)                       \
+
 extern const struct file_operations vfio_device_fops;
 
 #ifdef CONFIG_VFIO_NOIOMMU
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..7df94bf121fd 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1694,6 +1694,61 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 }
 EXPORT_SYMBOL(vfio_dma_rw);
 
+/**
+ * vfio_copy_from_user - Copy the user struct that may have extended fields
+ *
+ * @buffer: The local buffer to store the data copied from user
+ * @arg: The user buffer pointer
+ * @minsz: The minimum size of the user struct, it should never bump up.
+ * @flags_mask: The combination of all the falgs defined
+ * @xend_array: The array that stores the xend size for set flags.
+ *
+ * This helper requires the user struct put the argsz and flags fields in
+ * the first 8 bytes.
+ *
+ * Return 0 for success, otherwise -errno
+ */
+int vfio_copy_from_user(void *buffer, void __user *arg,
+			unsigned long minsz, u32 flags_mask,
+			unsigned long *xend_array)
+{
+	unsigned long xend = 0;
+	struct user_header {
+		u32 argsz;
+		u32 flags;
+	} *header;
+	unsigned long flags;
+	u32 flag;
+
+	if (copy_from_user(buffer, arg, minsz))
+		return -EFAULT;
+
+	header = (struct user_header *)buffer;
+	if (header->argsz < minsz)
+		return -EINVAL;
+
+	if (header->flags & ~flags_mask)
+		return -EINVAL;
+
+	/* Loop each set flag to decide the xend */
+	flags = header->flags;
+	for_each_set_bit(flag, &flags, BITS_PER_LONG) {
+		if (xend_array[flag])
+			xend = xend_array[flag];
+	}
+
+	if (xend) {
+		if (header->argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user(buffer + minsz,
+				   arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 /*
  * Module/class support
  */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..40b414e642f5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -931,29 +931,34 @@ struct vfio_device_bind_iommufd {
  * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 19,
  *					struct vfio_device_attach_iommufd_pt)
  * @argsz:	User filled size of this data.
- * @flags:	Must be 0.
+ * @flags:	Flags for attach.
  * @pt_id:	Input the target id which can represent an ioas or a hwpt
  *		allocated via iommufd subsystem.
  *		Output the input ioas id or the attached hwpt id which could
  *		be the specified hwpt itself or a hwpt automatically created
  *		for the specified ioas by kernel during the attachment.
+ * @pasid:	The pasid to be attached, only meaningful when
+ *		VFIO_DEVICE_ATTACH_PASID is set in @flags
  *
  * Associate the device with an address space within the bound iommufd.
  * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.  This is only
  * allowed on cdev fds.
  *
- * If a vfio device is currently attached to a valid hw_pagetable, without doing
- * a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl
- * passing in another hw_pagetable (hwpt) id is allowed. This action, also known
- * as a hw_pagetable replacement, will replace the device's currently attached
- * hw_pagetable with a new hw_pagetable corresponding to the given pt_id.
+ * If a vfio device or a pasid of this device is currently attached to a valid
+ * hw_pagetable (hwpt), without doing a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second
+ * VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl passing in another hwpt id is allowed.
+ * This action, also known as a hw_pagetable replacement, will replace the
+ * currently attached hwpt of the device or the pasid of this device with a new
+ * hwpt corresponding to the given pt_id.
  *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_attach_iommufd_pt {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_DEVICE_ATTACH_PASID	(1 << 0)
 	__u32	pt_id;
+	__u32	pasid;
 };
 
 #define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 19)
@@ -962,17 +967,21 @@ struct vfio_device_attach_iommufd_pt {
  * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
  *					struct vfio_device_detach_iommufd_pt)
  * @argsz:	User filled size of this data.
- * @flags:	Must be 0.
+ * @flags:	Flags for detach.
+ * @pasid:	The pasid to be detached, only meaningful when
+ *		VFIO_DEVICE_DETACH_PASID is set in @flags
  *
- * Remove the association of the device and its current associated address
- * space.  After it, the device should be in a blocking DMA state.  This is only
- * allowed on cdev fds.
+ * Remove the association of the device or a pasid of the device and its current
+ * associated address space.  After it, the device or the pasid should be in a
+ * blocking DMA state.  This is only allowed on cdev fds.
  *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_detach_iommufd_pt {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_DEVICE_DETACH_PASID	(1 << 0)
+	__u32	pasid;
 };
 
 #define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
-- 
2.34.1


