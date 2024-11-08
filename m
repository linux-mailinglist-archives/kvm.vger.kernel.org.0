Return-Path: <kvm+bounces-31264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C50B9C1CC3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC7C4B23DC0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCC61E885D;
	Fri,  8 Nov 2024 12:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W3rVPHA6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4031E7C13
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731068271; cv=none; b=rb23nsHT3LootBSUmsIc3zyTN+hW09X0NgCZ3vbvEidAU3m+N9SsUiX2L9VYibXTE26kw9adN1dvwcbJ2epFfa1AX/WuAjdR4KqNc5qZf231BNLGjtpl+V/VpPl3TrUoimSrH36/DrvCf/15iKZPQg1CmjHGHGU9tjnzgk8L2X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731068271; c=relaxed/simple;
	bh=0AE17RqoKgAiRcTE9GKa3HBCcyLWgeaREVzR/lJSCLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=guP4cAC8SAnAYot7LGTK3+NmctOJdsmNn+vO1hIGEVs7M8VZLEXue0h39jih9mIMngkGo1Zae5Rah/vBvZ/FfOzORqCf5MZAp61rrnPiaONWzOjNFDjCGWGCiW49a5biQi/WVqXJytOjvqEBjtQhdRPXqXmOZAlo6iIOoIP4m70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W3rVPHA6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731068270; x=1762604270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AE17RqoKgAiRcTE9GKa3HBCcyLWgeaREVzR/lJSCLg=;
  b=W3rVPHA6MXoSrIVnBiNh1k4BIcCnLW0zV0q+rmeZg5QPrbPJH273gTrg
   k3lhocPYkEJR4+9f+jZlxmH6oewToAWrShYpxXtR4z0rmQKfs5Esg9IzX
   4+8zEIb69tiUaBC4ZJkgS0REKs5PZsZWqbWs0QbFoZDKnewVkWAWO/OmR
   oUbA/69hHbDHg9y5YJmmNEtCJaryFAleSpIkVTQO7f9b9YUz5BMJxVIvP
   IuJ1tf0sb6PB5KPFZsWjw3VFcbECW9GYFpolrMLPmjHi47FzRGMOSX5GP
   E20V9CRO7Le/9nXD00geaY6L+XZ0mea7eM/CT8JrHBzRwclIgLUZ2nm4O
   g==;
X-CSE-ConnectionGUID: at3o/fOnTfu3sS4rmvcPcw==
X-CSE-MsgGUID: lyMz4IsSR5itk/fNDkf3nA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41560820"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="41560820"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:17:48 -0800
X-CSE-ConnectionGUID: Su5J+SG3TrWJ5kTCl0Ve/w==
X-CSE-MsgGUID: 5hjKFy75RrygqtuO2Ya7kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85865447"
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
Subject: [PATCH v5 2/5] vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
Date: Fri,  8 Nov 2024 04:17:39 -0800
Message-Id: <20241108121742.18889-3-yi.l.liu@intel.com>
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

This adds pasid_at|de]tach_ioas ops for attaching hwpt to pasid of a
device and the helpers for it. For now, only vfio-pci supports pasid
attach/detach.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c      | 50 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c |  2 ++
 include/linux/vfio.h        | 11 ++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 82eba6966fa5..039c0157ac1c 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -119,14 +119,22 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
 	vdev->iommufd_device = idev;
+	ida_init(&vdev->pasids);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_bind);
 
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
 {
+	int pasid;
+
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	while ((pasid = ida_find_first(&vdev->pasids)) >= 0) {
+		iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
+		ida_free(&vdev->pasids, pasid);
+	}
+
 	if (vdev->iommufd_attached) {
 		iommufd_device_detach(vdev->iommufd_device);
 		vdev->iommufd_attached = false;
@@ -168,6 +176,48 @@ void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
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
+	if (ida_exists(&vdev->pasids, pasid))
+		return iommufd_device_pasid_replace(vdev->iommufd_device,
+						    pasid, pt_id);
+
+	rc = ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
+	if (rc < 0)
+		return rc;
+
+	rc = iommufd_device_pasid_attach(vdev->iommufd_device, pasid, pt_id);
+	if (rc)
+		ida_free(&vdev->pasids, pasid);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_pasid_attach_ioas);
+
+void vfio_iommufd_physical_pasid_detach_ioas(struct vfio_device *vdev,
+					     u32 pasid)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (WARN_ON(!vdev->iommufd_device))
+		return;
+
+	if (!ida_exists(&vdev->pasids, pasid))
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
index e727941f589d..6f7ae7e5b7b0 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -144,6 +144,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
+	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 000a6cab2d31..11b3b453752e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -67,6 +67,7 @@ struct vfio_device {
 	struct inode *inode;
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
+	struct ida pasids;
 	u8 iommufd_attached:1;
 #endif
 	u8 cdev_opened:1;
@@ -91,6 +92,8 @@ struct vfio_device {
  *		 bound iommufd. Undo in unbind_iommufd if @detach_ioas is not
  *		 called.
  * @detach_ioas: Opposite of attach_ioas
+ * @pasid_attach_ioas: The pasid variation of attach_ioas
+ * @pasid_detach_ioas: Opposite of pasid_attach_ioas
  * @open_device: Called when the first file descriptor is opened for this device
  * @close_device: Opposite of open_device
  * @read: Perform read(2) on device file descriptor
@@ -115,6 +118,8 @@ struct vfio_device_ops {
 	void	(*unbind_iommufd)(struct vfio_device *vdev);
 	int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
 	void	(*detach_ioas)(struct vfio_device *vdev);
+	int	(*pasid_attach_ioas)(struct vfio_device *vdev, u32 pasid, u32 *pt_id);
+	void	(*pasid_detach_ioas)(struct vfio_device *vdev, u32 pasid);
 	int	(*open_device)(struct vfio_device *vdev);
 	void	(*close_device)(struct vfio_device *vdev);
 	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
@@ -139,6 +144,8 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev);
+int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev, u32 pasid, u32 *pt_id);
+void vfio_iommufd_physical_pasid_detach_ioas(struct vfio_device *vdev, u32 pasid);
 int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
@@ -166,6 +173,10 @@ vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
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


