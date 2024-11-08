Return-Path: <kvm+bounces-31267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C059C1CC6
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C53D31C20BD3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7361EABB0;
	Fri,  8 Nov 2024 12:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RqnN23+o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82431E883D
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731068275; cv=none; b=I3o1Um5FdQNdq7zE08PGxmvdvyIBvyXqJ7pBBEufEMdrmDqfE0ScDglTzdRIxK40lukYKiTaQqNAb8Y4VHc9SMv2loUD30aCrcVCFnAnfv3Wj5iEt9I4kS/3WXj0e6tOx5Gwb6pY3yksvCSqTeSNOoOff47LsWHqFnzfruYA7ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731068275; c=relaxed/simple;
	bh=rbnYdbmwhGJ1udSVXhSJ1PK4TnSQVX5UBIcjXa2TZ7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ba/AgPSiVCRMms7y8AZeWBrbRbKOTkcn+E0nTyJVI6xYDfl5EF3PubLvAg+EZU99YS+RIDmqyVZB4NGJjkO+jI56MJbET6bifglwS0EwOkDOECztTebxxCca3s8JaShaH4fPm5h6rBaYtLwv1Hv9LOhu9gRCilXYAKdhPtjX4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RqnN23+o; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731068272; x=1762604272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rbnYdbmwhGJ1udSVXhSJ1PK4TnSQVX5UBIcjXa2TZ7s=;
  b=RqnN23+orYMKxraG8xHS0D+UlkSvRe1YRBcw+A+iJxWvDMw4loWDtZyZ
   fTK42zZnbdjuOzyDxKmsXGzgNAEfp+IUcK5nxWRPigJegSuOHNEUSVB/L
   4nXAwE7n8Dls/b6iBwPMipu5asTf0+CdWy9BwIhxHHb1FLHqWvz9sQ3Zq
   1qOJzhKDz9uzHPMPyLCCUotbgLqsggRPimcfw2UygXoucVZ7av1TrUR1r
   0OLOLWsG6OJfPgyLcE1aZfan/c85QNUDCNgKmj4bUYSgW8ujI/kys9vvo
   P0yV7hyYxpA2BZbedgJT8u3VncbBKGGOvPYNOe2xo0DhFbfNJaC3+EP7z
   A==;
X-CSE-ConnectionGUID: 2J1ANiQXQam0nzh9KaHB3g==
X-CSE-MsgGUID: BdCghSfFT12iGFR+gUDG+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41560834"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="41560834"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:17:49 -0800
X-CSE-ConnectionGUID: ZEV8d+mVT1KsDtegPGUvyg==
X-CSE-MsgGUID: IzpUrl8xQtyg7Qg/maQb4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85865456"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 08 Nov 2024 04:17:49 -0800
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
Subject: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
Date: Fri,  8 Nov 2024 04:17:41 -0800
Message-Id: <20241108121742.18889-5-yi.l.liu@intel.com>
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

This generalizes the logic of copying user data when the user struct
Have new fields introduced. The helpers can be used by the vfio uapis
that have the argsz and flags fields in the beginning 8 bytes.

As an example, the vfio_device_{at|de}tach_iommufd_pt paths are updated
to use the helpers.

The flags may be defined to mark a new field in the structure, reuse
reserved fields, or special handling of an existing field. The extended
size would differ for different flags. Each user API that wants to use
the generalized helpers should define an array to store the corresponding
extended sizes for each defined flag.

For example, we start out with the below, minsz is 12.

  struct vfio_foo_struct {
  	__u32   argsz;
  	__u32   flags;
  	__u32   pt_id;
  };

And then here it becomes:

  struct vfio_foo_struct {
  	__u32   argsz;
  	__u32   flags;
  #define VFIO_FOO_STRUCT_PASID   (1 << 0)
  	__u32   pt_id;
  	__u32   pasid;
  };

The array is { 16 }.

If the next flag is simply related to the processing of @pt_id and
doesn't require @pasid, then the extended size of the new flag is
12. The array become { 16, 12 }

  struct vfio_foo_struct {
  	__u32   argsz;
  	__u32   flags;
  #define VFIO_FOO_STRUCT_PASID   (1 << 0)
  #define VFIO_FOO_STRUCT_SPECICAL_PTID   (1 << 1)
  	__u32   pt_id;
  	__u32   pasid;
  };

Similarly, rather than adding new field, we might have reused a previously
reserved field, for instance what if we already expanded the structure
as the below, array is already { 24 }.

  struct vfio_foo_struct {
  	__u32   argsz;
  	__u32   flags;
  #define VFIO_FOO_STRUCT_XXX     (1 << 0)
  	__u32   pt_id;
  	__u32   reserved;
  	__u64   xxx;
  };

If we then want to add @pasid, we might really prefer to take advantage
of that reserved field and the array becomes { 24, 16 }.

  struct vfio_foo_struct {
  	__u32   argsz;
  	__u32   flags;
  #define VFIO_FOO_STRUCT_XXX     (1 << 0)
  #define VFIO_FOO_STRUCT_PASID   (1 << 1)
  	__u32   pt_id;
  	__u32   reserved;
  	__u64   xxx;
  };

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 81 +++++++++++++-------------------------
 drivers/vfio/vfio.h        | 18 +++++++++
 drivers/vfio/vfio_main.c   | 55 ++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 54 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 4519f482e212..35c7664b9a97 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -159,40 +159,33 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
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
 	struct vfio_device_attach_iommufd_pt attach;
 	struct vfio_device *device = df->device;
-	unsigned long minsz, xend = 0;
 	int ret;
 
-	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
-
-	if (copy_from_user(&attach, arg, minsz))
-		return -EFAULT;
-
-	if (attach.argsz < minsz)
-		return -EINVAL;
-
-	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
-		return -EINVAL;
-
-	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
-		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
-
-	/*
-	 * xend may be equal to minsz if a flag is defined for reusing a
-	 * reserved field or a special usage of an existing field.
-	 */
-	if (xend > minsz) {
-		if (attach.argsz < xend)
-			return -EINVAL;
-
-		if (copy_from_user((void *)&attach + minsz,
-				   (void __user *)arg + minsz, xend - minsz))
-			return -EFAULT;
-	}
+	ret = vfio_copy_user_data((void __user *)arg, &attach,
+				  struct vfio_device_attach_iommufd_pt,
+				  pt_id, VFIO_ATTACH_FLAGS_MASK,
+				  vfio_attach_xends);
+	if (ret)
+		return ret;
 
 	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
 	    !device->ops->pasid_attach_ioas)
@@ -227,34 +220,14 @@ int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 {
 	struct vfio_device_detach_iommufd_pt detach;
 	struct vfio_device *device = df->device;
-	unsigned long minsz, xend = 0;
-
-	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
-
-	if (copy_from_user(&detach, arg, minsz))
-		return -EFAULT;
-
-	if (detach.argsz < minsz)
-		return -EINVAL;
-
-	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
-		return -EINVAL;
-
-	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
-		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
-
-	/*
-	 * xend may be equal to minsz if a flag is defined for reusing a
-	 * reserved field or a special usage of an existing field.
-	 */
-	if (xend > minsz) {
-		if (detach.argsz < xend)
-			return -EINVAL;
+	int ret;
 
-		if (copy_from_user((void *)&detach + minsz,
-				   (void __user *)arg + minsz, xend - minsz))
-			return -EFAULT;
-	}
+	ret = vfio_copy_user_data((void __user *)arg, &detach,
+				  struct vfio_device_detach_iommufd_pt,
+				  flags, VFIO_DETACH_FLAGS_MASK,
+				  vfio_detach_xends);
+	if (ret)
+		return ret;
 
 	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
 	    !device->ops->pasid_detach_ioas)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..87bed550c46e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -34,6 +34,24 @@ void vfio_df_close(struct vfio_device_file *df);
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
 
+int vfio_copy_from_user(void *buffer, void __user *arg,
+			unsigned long minsz, u32 flags_mask,
+			unsigned long *xend_array);
+
+#define vfio_copy_user_data(_arg, _local_buffer, _struct, _min_last,          \
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
index a5a62d9d963f..c61336ea5123 100644
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
+ * @minsz: The minimum size of the user struct
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
+	unsigned long xend = minsz;
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
+	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
+		if (xend_array[flag] > xend)
+			xend = xend_array[flag];
+	}
+
+	if (xend > minsz) {
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
-- 
2.34.1


