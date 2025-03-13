Return-Path: <kvm+bounces-40925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D324A5F4E2
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 13:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 503721884E89
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 12:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8FC267B01;
	Thu, 13 Mar 2025 12:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OPe5EbAX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C867C2673A1
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741870081; cv=none; b=WztgEJp8gmiJTCsaUZ0c8PIxfb3vtiVDGGga2jrDjz/8qujKkeF4VN+mZm4JMsp9JSO2yeue1+2gCrYcAGbm8MoEzfrbPvU4et2jtk2eSny2FIucHD8Npxcx3UQy+qi3OqmuRobIFlxIXoc5OsedVhNZ0uDcrVQgnk8zaTOKPF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741870081; c=relaxed/simple;
	bh=9j1wFnERO/FmX/HyIif1kOvae7k7J77O297T3e3kkto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MbbiGEBby6mkfmilIJS7Fk4Sbf98tRKBRIlZlTdbVDDhs1tRHQOtoL8dFpTqt6Q6UAT4ExjWBSP+nUWF4X0iRmD+GOK5pUszpp/dqtZAB4PxANRs4/WGmSxrBF6rmtu+vU8+yGycM0zwvXh+5+b3Rj1KO7p6wco+i36KcM4CbpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OPe5EbAX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741870080; x=1773406080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9j1wFnERO/FmX/HyIif1kOvae7k7J77O297T3e3kkto=;
  b=OPe5EbAX/eBF63JRS1SthUldTfPxlKyINS7/j0cm+6h8v5kQd2ShMroy
   0EkcCJYRq+7vcT0zrn//FaRf/8KrLKse8iTfI3G33cgTy40ZYfpvNhCod
   ryFt8IJMXoReUiqmgkgoq5Gy7qBg80zlw0T9HkyZnfrYcdnd20IOhOEce
   QbXNaiABJbM/XJ3imOlZe0V6mHS+pZmXJ56OqsOFTyoM65VFuoo3R3TMI
   BzbX3ay68dxI/w+xitX/qhirrPZqfm51vXvt0atUYDhTj7cx6Myw8OHin
   FkthHfmLR3w8e8pkMAPC7yC9nsT6wyjwjkk2o17BLzEOfZPxb6yYKwz+V
   w==;
X-CSE-ConnectionGUID: GpFSfhbgRt+3oldVySJzVw==
X-CSE-MsgGUID: SqFlmkICSV2OUhHN39nmvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="60383570"
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="60383570"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 05:47:56 -0700
X-CSE-ConnectionGUID: Lr1pv0tGQwOWCZU/PNtenA==
X-CSE-MsgGUID: 06TZXpDgQiqaV/sTcg+LSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="158095329"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa001.jf.intel.com with ESMTP; 13 Mar 2025 05:47:55 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	kevin.tian@intel.com
Cc: jgg@nvidia.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com
Subject: [PATCH v8 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
Date: Thu, 13 Mar 2025 05:47:51 -0700
Message-Id: <20250313124753.185090-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250313124753.185090-1-yi.l.liu@intel.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
a given pasid of a vfio device to/from an IOAS/HWPT.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 60 +++++++++++++++++++++++++++++++++-----
 include/uapi/linux/vfio.h  | 29 +++++++++++-------
 2 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..6d436bee8207 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -162,9 +162,9 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
 int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 			    struct vfio_device_attach_iommufd_pt __user *arg)
 {
-	struct vfio_device *device = df->device;
 	struct vfio_device_attach_iommufd_pt attach;
-	unsigned long minsz;
+	struct vfio_device *device = df->device;
+	unsigned long minsz, xend = 0;
 	int ret;
 
 	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
@@ -172,11 +172,34 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 	if (copy_from_user(&attach, arg, minsz))
 		return -EFAULT;
 
-	if (attach.argsz < minsz || attach.flags)
+	if (attach.argsz < minsz)
 		return -EINVAL;
 
+	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
+		return -EINVAL;
+
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID) {
+		if (!device->ops->pasid_attach_ioas)
+			return -EOPNOTSUPP;
+		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
+	}
+
+	if (xend) {
+		if (attach.argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&attach + minsz,
+				   (void __user *)arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
 	mutex_lock(&device->dev_set->lock);
-	ret = device->ops->attach_ioas(device, &attach.pt_id);
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
+		ret = device->ops->pasid_attach_ioas(device,
+						     attach.pasid,
+						     &attach.pt_id);
+	else
+		ret = device->ops->attach_ioas(device, &attach.pt_id);
 	if (ret)
 		goto out_unlock;
 
@@ -198,20 +221,41 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 			    struct vfio_device_detach_iommufd_pt __user *arg)
 {
-	struct vfio_device *device = df->device;
 	struct vfio_device_detach_iommufd_pt detach;
-	unsigned long minsz;
+	struct vfio_device *device = df->device;
+	unsigned long minsz, xend = 0;
 
 	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
 
 	if (copy_from_user(&detach, arg, minsz))
 		return -EFAULT;
 
-	if (detach.argsz < minsz || detach.flags)
+	if (detach.argsz < minsz)
 		return -EINVAL;
 
+	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
+		return -EINVAL;
+
+	if (detach.flags & VFIO_DEVICE_DETACH_PASID) {
+		if (!device->ops->pasid_detach_ioas)
+			return -EOPNOTSUPP;
+		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
+	}
+
+	if (xend) {
+		if (detach.argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&detach + minsz,
+				   (void __user *)arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
 	mutex_lock(&device->dev_set->lock);
-	device->ops->detach_ioas(device);
+	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
+		device->ops->pasid_detach_ioas(device, detach.pasid);
+	else
+		device->ops->detach_ioas(device);
 	mutex_unlock(&device->dev_set->lock);
 
 	return 0;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index c8dbf8219c4f..6899da70b929 100644
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


