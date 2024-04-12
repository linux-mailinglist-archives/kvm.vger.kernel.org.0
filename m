Return-Path: <kvm+bounces-14411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E288A292C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E85F1F2236C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CED502B7;
	Fri, 12 Apr 2024 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WRADAllr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EAE4E1B3
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910087; cv=none; b=MFUMDduiZHRfQFH5uS6A+Sk7hH2TmnCIWZXQHi/3go3d4eVP1Cm/3+SbNQhTDy9wi4EnpiqV8xRtZih0nPYdBEMXuxZ4xdjFF7wh10+Xo54/JOFPMxVreuRtiI4lXGIT0UiU6fnHghRT/1jqy3AfVENTp3g9bW45TXENoL3Og+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910087; c=relaxed/simple;
	bh=UjPvmgpzmm11TnJlYYfXn0iNU172tlWImjrbz2kHSQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fuplmi9dYD9cqckBDzOAnEy9b/GgJr/CUdSmIO+AYhbJVZfqyHtkxuwExrduFbgZe/1W+pjZvu5aoHt67Fi4VRusoVbUJFWRARDKxBHClLxapOkzGdjWKGtsUxDuhXfVmaNhAigs7ChxYZvXT5uUizFPimGkAqrNJeszHvHdc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WRADAllr; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712910086; x=1744446086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UjPvmgpzmm11TnJlYYfXn0iNU172tlWImjrbz2kHSQI=;
  b=WRADAllrNZP5iG0Uhtap9Q+Cu6xJcXEL/hqVxiOg6GYptLAuItHeSH65
   9b250Wh7s8f8PM7YhUkMRjBXBrz+6fKEP4AJj7AWrJLcJICCwIe2Q6iJ3
   cXmJahC7Z3btrLi7X3wx09fOVHn4wF1o6iohQ8QiJ2JVrC4RmzmW2qnLL
   Y5mFxQIHuAiZdGvOPbovFjMK3/TFWJdJAoSOAKB71c2+eFOIm2wgw6SrP
   KGAljUqxL1IdDsHyqYmYjCxuMz2C8yGkiS8LZ875iCPMyyiUcek8rzsap
   0dmufA/MB9ShsoMPmakqzkopSc9ZoPyl0vZREu+P+w9Dez74cw31TUiQi
   A==;
X-CSE-ConnectionGUID: /NK05YcdTIq17IIkIISAfQ==
X-CSE-MsgGUID: 8Jgap+LjTGea7rNa9xBcRA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19069410"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="19069410"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:21:24 -0700
X-CSE-ConnectionGUID: dpYYN6x0Rh2Kk1AGPvc8Dw==
X-CSE-MsgGUID: LRfYMf+UTqmVk3E86mRZjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25836267"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 01:21:24 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: joro@8bytes.org,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
Date: Fri, 12 Apr 2024 01:21:19 -0700
Message-Id: <20240412082121.33382-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412082121.33382-1-yi.l.liu@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds pasid_at|de]tach_ioas ops for attaching hwpt to pasid of a
device and the helpers for it. For now, only vfio-pci supports pasid
attach/detach.

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c      | 60 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c |  2 ++
 include/linux/vfio.h        | 11 +++++++
 3 files changed, 73 insertions(+)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 82eba6966fa5..fc533416c75d 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -119,14 +119,26 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
 	vdev->iommufd_device = idev;
+	ida_init(&vdev->pasids);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_bind);
 
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
 {
+	int pasid = 0;
+
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	while (!ida_is_empty(&vdev->pasids)) {
+		pasid = ida_get_lowest(&vdev->pasids, pasid, INT_MAX);
+		if (pasid < 0)
+			break;
+
+		iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
+		ida_free(&vdev->pasids, pasid);
+	}
+
 	if (vdev->iommufd_attached) {
 		iommufd_device_detach(vdev->iommufd_device);
 		vdev->iommufd_attached = false;
@@ -168,6 +180,54 @@ void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_detach_ioas);
 
+int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
+					    u32 pasid, u32 *pt_id)
+{
+	int rc;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (WARN_ON(!vdev->iommufd_device))
+		return -EINVAL;
+
+	rc = ida_get_lowest(&vdev->pasids, pasid, pasid);
+	if (rc == pasid)
+		return iommufd_device_pasid_replace(vdev->iommufd_device,
+						    pasid, pt_id);
+
+	rc = iommufd_device_pasid_attach(vdev->iommufd_device, pasid, pt_id);
+	if (rc)
+		return rc;
+
+	rc = ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
+	if (rc < 0) {
+		iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
+		return rc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_pasid_attach_ioas);
+
+void vfio_iommufd_physical_pasid_detach_ioas(struct vfio_device *vdev,
+					     u32 pasid)
+{
+	int rc;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (WARN_ON(!vdev->iommufd_device))
+		return;
+
+	rc = ida_get_lowest(&vdev->pasids, pasid, pasid);
+	if (rc < 0)
+		return;
+
+	iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
+	ida_free(&vdev->pasids, pasid);
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_pasid_detach_ioas);
+
 /*
  * The emulated standard ops mean that vfio_device is going to use the
  * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index cb5b7f865d58..e0198851ffd2 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -142,6 +142,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
+	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 8b1a29820409..8fd1db173e84 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -66,6 +66,7 @@ struct vfio_device {
 	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
+	struct ida pasids;
 	u8 iommufd_attached:1;
 #endif
 	u8 cdev_opened:1;
@@ -90,6 +91,8 @@ struct vfio_device {
  *		 bound iommufd. Undo in unbind_iommufd if @detach_ioas is not
  *		 called.
  * @detach_ioas: Opposite of attach_ioas
+ * @pasid_attach_ioas: The pasid variation of attach_ioas
+ * @pasid_detach_ioas: Opposite of pasid_attach_ioas
  * @open_device: Called when the first file descriptor is opened for this device
  * @close_device: Opposite of open_device
  * @read: Perform read(2) on device file descriptor
@@ -114,6 +117,8 @@ struct vfio_device_ops {
 	void	(*unbind_iommufd)(struct vfio_device *vdev);
 	int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
 	void	(*detach_ioas)(struct vfio_device *vdev);
+	int	(*pasid_attach_ioas)(struct vfio_device *vdev, u32 pasid, u32 *pt_id);
+	void	(*pasid_detach_ioas)(struct vfio_device *vdev, u32 pasid);
 	int	(*open_device)(struct vfio_device *vdev);
 	void	(*close_device)(struct vfio_device *vdev);
 	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
@@ -138,6 +143,8 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev);
+int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev, u32 pasid, u32 *pt_id);
+void vfio_iommufd_physical_pasid_detach_ioas(struct vfio_device *vdev, u32 pasid);
 int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
@@ -165,6 +172,10 @@ vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #define vfio_iommufd_physical_detach_ioas \
 	((void (*)(struct vfio_device *vdev)) NULL)
+#define vfio_iommufd_physical_pasid_attach_ioas \
+	((int (*)(struct vfio_device *vdev, u32 pasid, u32 *pt_id)) NULL)
+#define vfio_iommufd_physical_pasid_detach_ioas \
+	((void (*)(struct vfio_device *vdev, u32 pasid)) NULL)
 #define vfio_iommufd_emulated_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
 		  u32 *out_device_id)) NULL)
-- 
2.34.1


