Return-Path: <kvm+bounces-31265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0ED9C1CC4
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEE3C1F23F02
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AB41E908A;
	Fri,  8 Nov 2024 12:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I/uygt5f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7201E7648
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731068273; cv=none; b=KdCenaXY8Lbqena6c4gb5stYAg57vZAUb56hCNQ/n2L7bAchP5jfcRVtKwTQE13d7COTIdcBIeziuJMCH5pCv86pwpKcmHccELKtp3gguGEdODoI99IloAI9QqczUFI1upTbwwIrCZaUU4oyuNnU2FiVVtlI6M88cqRkmPKXb54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731068273; c=relaxed/simple;
	bh=cTLLqq2ykU/HGdHB6WcOnjF2xGCXptzhaEq48UUFTBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GFr8Hp4Z3hMwEtL6XUdMh0EWpT/4DUFw+I6hYN8CGmacpAt2JOD4cNta5w1Zzn9nK4kvW5PiJ+9uitzr7DrVf5KFAYqWHkCcaB5m79YiDta3TLqeCzgPO/O5bXanQW0TyrnvgdnnOcoWxiAjkhTGoLcEurLvALilCAOy9SOyu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I/uygt5f; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731068271; x=1762604271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cTLLqq2ykU/HGdHB6WcOnjF2xGCXptzhaEq48UUFTBA=;
  b=I/uygt5fn+ftOAYsLK/fiTy20ivOrKz/TqQF3e0iahAORD5TK57mF6ky
   31wTHxQWnFOuqk5q3rTH3UlOVBZprBk+SVB3+ELEuK/DfMPg31VNvtpk0
   4AA6e8vQKIPtcxHZKnVLVU6h28Bq9eIal1wMkb3KsXZVdar7Y4zreU/c6
   /7oviALEQD7EjI/hNuwdxBFOuEjX67gSE0u+O0BSVZeAkugXd4DxCDUB/
   Qx/UgucPm0s1o69GqdDCe0Ley6MQzkrrUFo5m6sv/uigbtq1SMc0D9oEa
   KJd6xIwJehMZp4He+EmHll2wxcjwP41H8Qu9uTEkoZzPKuu8DO5pv4Olw
   A==;
X-CSE-ConnectionGUID: hZYr8JxnSi+2WiciGiLY3Q==
X-CSE-MsgGUID: wWjxgMI/QZ+AqQ/xjl0fyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41560827"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="41560827"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:17:49 -0800
X-CSE-ConnectionGUID: Wu0vrP9zQjWuu1Z71XJK0A==
X-CSE-MsgGUID: +jKBSp0GQByhH/dFnqd8eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85865452"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 08 Nov 2024 04:17:48 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: joro@8bytes.org,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v5 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
Date: Fri,  8 Nov 2024 04:17:40 -0800
Message-Id: <20241108121742.18889-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241108121742.18889-1-yi.l.liu@intel.com>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
a given pasid of a vfio device to/from an IOAS/HWPT.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 69 +++++++++++++++++++++++++++++++++-----
 include/uapi/linux/vfio.h  | 29 ++++++++++------
 2 files changed, 80 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..4519f482e212 100644
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
@@ -172,11 +172,38 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 	if (copy_from_user(&attach, arg, minsz))
 		return -EFAULT;
 
-	if (attach.argsz < minsz || attach.flags)
+	if (attach.argsz < minsz)
 		return -EINVAL;
 
+	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
+		return -EINVAL;
+
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
+		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
+
+	/*
+	 * xend may be equal to minsz if a flag is defined for reusing a
+	 * reserved field or a special usage of an existing field.
+	 */
+	if (xend > minsz) {
+		if (attach.argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&attach + minsz,
+				   (void __user *)arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
+	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
+	    !device->ops->pasid_attach_ioas)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&device->dev_set->lock);
-	ret = device->ops->attach_ioas(device, &attach.pt_id);
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
+		ret = device->ops->pasid_attach_ioas(device, attach.pasid,
+						     &attach.pt_id);
+	else
+		ret = device->ops->attach_ioas(device, &attach.pt_id);
 	if (ret)
 		goto out_unlock;
 
@@ -198,20 +225,46 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
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
+		return -EINVAL;
+
+	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
 		return -EINVAL;
 
+	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
+		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
+
+	/*
+	 * xend may be equal to minsz if a flag is defined for reusing a
+	 * reserved field or a special usage of an existing field.
+	 */
+	if (xend > minsz) {
+		if (detach.argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&detach + minsz,
+				   (void __user *)arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
+	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
+	    !device->ops->pasid_detach_ioas)
+		return -EOPNOTSUPP;
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


