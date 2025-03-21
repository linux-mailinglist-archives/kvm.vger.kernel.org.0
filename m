Return-Path: <kvm+bounces-41704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE83A6C200
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E27B3B7CDA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B9022FE18;
	Fri, 21 Mar 2025 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJ0+YDqA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D779722E414
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580110; cv=none; b=ML0L14YCk4ukI56gL3OMl0NlDGm26Fy58vXiN1TY+dbHqhwHw4olH4SbMsvNGXBu1QUQdmvp/i/VGpvRv1cAt4eu6aOiPc3iFo7ZmmdXXedO7BwqENGo4BWH7v57N+3DZC6bIVqiUDK5+IZGr6F4ZVgBqqG6Hes3knBEnYA3w0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580110; c=relaxed/simple;
	bh=ks/T/DR7qhJ5KPMfVuqd5gRzm0/sOka9acQq3FTIPes=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GS/4k00jBVQqDz/Joo0iIlrxuzfMsbxYVjwCgYVane8mYQitugHZYqWls5iwoH0eRFKBhhOqx+0jt4VI2+0P2MWbfBjYHqnDuoBgMPnidxm8K8m2oW3AKXDaLjHALD04+YVXAoc7ewcqkMs23/xWjyusmJgxfdoOiZE8D3LpfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJ0+YDqA; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742580109; x=1774116109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ks/T/DR7qhJ5KPMfVuqd5gRzm0/sOka9acQq3FTIPes=;
  b=iJ0+YDqAsiAIc6QrUBwwJPjk5mN8z4p4HSfmX3JqF1za7wqslFCdhmV5
   bIQcers2cyqngAysUXXafD+IsZunuIdULbDCVa9TtbeBCxvkvN4Y83DV/
   WcLVha6y8lxDmnrXLQI1la5gZGiSEsUVympp7Sjyx9cWrXexqzCK5h/Lo
   QW5ZU0x6uh0wYQCrlqL2U1H4G6d4eDoVhV7nHsKA0jNi5+lTf7E46nfnW
   WnQoWDTf2CR7TGy+DIdHYHZae8XKaNcPp+MGsy0U+2LiLfudosOLtVAD1
   ALxgBqGNi63XsIl+0HD57q4m/cnavn9mPjv8kSZxD76hO781pHCuHNplo
   w==;
X-CSE-ConnectionGUID: AhEBv4o/QMOBvE2RtQhv0g==
X-CSE-MsgGUID: 4JCmynz2SrqFNkTMEIyQrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="55234674"
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="55234674"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 11:01:46 -0700
X-CSE-ConnectionGUID: XYBpguPyQhWeCTyvIPsALg==
X-CSE-MsgGUID: pqr4INwoQ9OgH62rs7FjwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="160694116"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa001.jf.intel.com with ESMTP; 21 Mar 2025 11:01:46 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com
Cc: jgg@nvidia.com,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v9 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
Date: Fri, 21 Mar 2025 11:01:41 -0700
Message-Id: <20250321180143.8468-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250321180143.8468-1-yi.l.liu@intel.com>
References: <20250321180143.8468-1-yi.l.liu@intel.com>
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
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 60 +++++++++++++++++++++++++++++++++-----
 include/uapi/linux/vfio.h  | 29 +++++++++++-------
 2 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..281a8dc3ed49 100644
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
 
+	if (attach.flags & ~VFIO_DEVICE_ATTACH_PASID)
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
 
+	if (detach.flags & ~VFIO_DEVICE_DETACH_PASID)
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


