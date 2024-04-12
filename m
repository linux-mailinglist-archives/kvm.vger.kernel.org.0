Return-Path: <kvm+bounces-14398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B73D28A28FC
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BF2FB25122
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5FD502B1;
	Fri, 12 Apr 2024 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khTRl2gf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA0D4F20A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909734; cv=none; b=QlMJfl1yxxH2aurVjiJn8AWks2vbxIszysLVqetFEzZT0pT+VIkxfkeiOgch2VBTiXzFX4g7StlhJllPAdjQX/WmHytdtVqN5NYicLQoYqtXK2CYHTdWy/yd2E/VJUl1gioxP+BMlSObpMqGPrTaNe6h1ZE8wPjLJKQtaRs0tk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909734; c=relaxed/simple;
	bh=ACEk34/RP5dvOflDxOyZ6INdZQHZeKilkYWroT75ukw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vFoiCOcSxmiSkKYJ7lXyx7o9Dfm4Zg97KhZODVcperQIC7mL/Hj6qYUS6BRLfghlQx1K8HZCcmQ7OKQ2+3akO2AjMGp1IktfS9BvVZTVgwbV/o2dKXQF+6QSeIVx76gnK7cYJuAyn29rlCIHaDLGl+obf/Ospv+Ab8qrwxCg5b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khTRl2gf; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909733; x=1744445733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ACEk34/RP5dvOflDxOyZ6INdZQHZeKilkYWroT75ukw=;
  b=khTRl2gf5GP65rR/5AMCIKnXAsp9mQaUVlzNxjInLoHSr7lohZ0Xg8RR
   YH/f7ssk1QCNguLy27El2KdnCce2/iDRserljTBV4ok1ALMlO/ScrKfJW
   YTT6UTl/OlGT96IW3ZNRJaq7c0+SEeKd9HFpe6Hfl+aAtWZCNWSoVDvPS
   +k0IfoVCb2HKiHkH1HNZqZz20gy07f/2SKsl1NMNPVfOfc/djcnXtkXSS
   lj/4AuL+H6R3fND58YDcDe06FfW3kk/kxTlVxKNw5/nATUBdDKTeb8HQI
   Ruc3a/Xffk6EBxfcbkwv+I8Lbk+QOo92LgRsdy5yFmPvl/MNJVMgD+QDM
   g==;
X-CSE-ConnectionGUID: Ah6HUl7LR5OwgoUuceHyng==
X-CSE-MsgGUID: 2LIdvGAtT62StThtBZDIxQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465064"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465064"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:33 -0700
X-CSE-ConnectionGUID: F1nz8HZCQ+Oyehwr9tC+5g==
X-CSE-MsgGUID: q0lc6C13RYefPyGchsuvSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137836"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:32 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 04/12] iommufd: Support attach/replace hwpt per pasid
Date: Fri, 12 Apr 2024 01:15:08 -0700
Message-Id: <20240412081516.31168-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412081516.31168-1-yi.l.liu@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces three APIs for device drivers to manage pasid attach/
replace/detach.

    int iommufd_device_pasid_attach(struct iommufd_device *idev,
				    u32 pasid, u32 *pt_id);
    int iommufd_device_pasid_replace(struct iommufd_device *idev,
				     u32 pasid, u32 *pt_id);
    void iommufd_device_pasid_detach(struct iommufd_device *idev,
				     u32 pasid);

pasid operations have different implications when comparing to device
operations:

 - No connection to iommufd_group since pasid is a device capability
   and can be enabled only in singleton group;

 - no reserved region per pasid otherwise SVA architecture is already
   broken (CPU address space doesn't count device reserved regions);

 - accordingly no sw_msi trick;

 - immediated_attach is not supported, expecting that arm-smmu driver
   will already remove that requirement before supporting this pasid
   operation. This avoids unnecessary change in iommufd_hw_pagetable_alloc()
   to carry the pasid from device.c.

With above differences, this puts all pasid related logics into a new
pasid.c file.

Cache coherency enforcement is still applied to pasid operations since
it is about memory accesses post page table walking (no matter the walk
is per RID or per PASID).

Since the attach is per PASID, this introduces a pasid_hwpts xarray to
track the per-pasid attach data.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/device.c          |  14 ++-
 drivers/iommu/iommufd/iommufd_private.h |  15 +++
 drivers/iommu/iommufd/pasid.c           | 161 ++++++++++++++++++++++++
 include/linux/iommufd.h                 |   6 +
 5 files changed, 194 insertions(+), 3 deletions(-)
 create mode 100644 drivers/iommu/iommufd/pasid.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 34b446146961..4b4d516b025c 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -6,6 +6,7 @@ iommufd-y := \
 	ioas.o \
 	main.o \
 	pages.o \
+	pasid.o \
 	vfio_compat.o
 
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 56e4b8e776c9..442169f8b460 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -136,6 +136,7 @@ void iommufd_device_destroy(struct iommufd_object *obj)
 	struct iommufd_device *idev =
 		container_of(obj, struct iommufd_device, obj);
 
+	WARN_ON(!xa_empty(&idev->pasid_hwpts));
 	iommu_device_release_dma_owner(idev->dev);
 	iommufd_put_group(idev->igroup);
 	if (!iommufd_selftest_is_mock_dev(idev->dev))
@@ -216,6 +217,8 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 	/* igroup refcount moves into iommufd_device */
 	idev->igroup = igroup;
 
+	xa_init(&idev->pasid_hwpts);
+
 	/*
 	 * If the caller fails after this success it must call
 	 * iommufd_unbind_device() which is safe since we hold this refcount.
@@ -534,7 +537,10 @@ iommufd_device_do_replace(struct iommufd_device *idev,
 static struct iommufd_hw_pagetable *do_attach(struct iommufd_device *idev,
 		struct iommufd_hw_pagetable *hwpt, struct attach_data *data)
 {
-	return data->attach_fn(idev, hwpt);
+	if (data->pasid == IOMMU_PASID_INVALID)
+		return data->attach_fn(idev, hwpt);
+	else
+		return data->pasid_attach_fn(idev, data->pasid, hwpt);
 }
 
 /*
@@ -620,8 +626,8 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	return destroy_hwpt;
 }
 
-static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
-				    struct attach_data *data)
+int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
+			     struct attach_data *data)
 {
 	struct iommufd_hw_pagetable *destroy_hwpt;
 	struct iommufd_object *pt_obj;
@@ -684,6 +690,7 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id)
 	int rc;
 	struct attach_data data = {
 		.attach_fn = &iommufd_device_do_attach,
+		.pasid = IOMMU_PASID_INVALID,
 	};
 
 	rc = iommufd_device_change_pt(idev, pt_id, &data);
@@ -718,6 +725,7 @@ int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id)
 {
 	struct attach_data data = {
 		.attach_fn = &iommufd_device_do_replace,
+		.pasid = IOMMU_PASID_INVALID,
 	};
 
 	return iommufd_device_change_pt(idev, pt_id, &data);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 22f0b9a3df36..bf42775fa1c1 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -394,6 +394,7 @@ struct iommufd_device {
 	struct list_head group_item;
 	/* always the physical device */
 	struct device *dev;
+	struct xarray pasid_hwpts;
 	bool enforce_cache_coherency;
 };
 
@@ -413,9 +414,23 @@ struct attach_data {
 		struct iommufd_hw_pagetable *(*attach_fn)(
 				struct iommufd_device *idev,
 				struct iommufd_hw_pagetable *hwpt);
+		struct iommufd_hw_pagetable *(*pasid_attach_fn)(
+				struct iommufd_device *idev, u32 pasid,
+				struct iommufd_hw_pagetable *hwpt);
 	};
+	u32 pasid;
 };
 
+int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
+			     struct attach_data *data);
+
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_attach(struct iommufd_device *idev, u32 pasid,
+			       struct iommufd_hw_pagetable *hwpt);
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_replace(struct iommufd_device *idev, u32 pasid,
+				struct iommufd_hw_pagetable *hwpt);
+
 struct iommufd_access {
 	struct iommufd_object obj;
 	struct iommufd_ctx *ictx;
diff --git a/drivers/iommu/iommufd/pasid.c b/drivers/iommu/iommufd/pasid.c
new file mode 100644
index 000000000000..ee063fdb75c3
--- /dev/null
+++ b/drivers/iommu/iommufd/pasid.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2024, Intel Corporation
+ */
+#include <linux/iommufd.h>
+#include <linux/iommu.h>
+#include "../iommu-priv.h"
+
+#include "iommufd_private.h"
+
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_attach(struct iommufd_device *idev, u32 pasid,
+			       struct iommufd_hw_pagetable *hwpt)
+{
+	void *curr;
+	int rc;
+
+	refcount_inc(&hwpt->obj.users);
+	curr = xa_cmpxchg(&idev->pasid_hwpts, pasid, NULL, hwpt, GFP_KERNEL);
+	if (curr) {
+		if (curr == hwpt)
+			rc = 0;
+		else
+			rc = xa_err(curr) ? : -EBUSY;
+		goto err_put_hwpt;
+	}
+
+	rc = iommu_attach_device_pasid(hwpt->domain, idev->dev, pasid);
+	if (rc) {
+		xa_erase(&idev->pasid_hwpts, pasid);
+		goto err_put_hwpt;
+	}
+
+	return NULL;
+
+err_put_hwpt:
+	refcount_dec(&hwpt->obj.users);
+	return ERR_PTR(rc);
+}
+
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_replace(struct iommufd_device *idev, u32 pasid,
+				struct iommufd_hw_pagetable *hwpt)
+{
+	void *curr;
+	int rc;
+
+	refcount_inc(&hwpt->obj.users);
+	curr = xa_store(&idev->pasid_hwpts, pasid, hwpt, GFP_KERNEL);
+	rc = xa_err(curr);
+	if (rc)
+		goto out_put_hwpt;
+
+	if (!curr) {
+		xa_erase(&idev->pasid_hwpts, pasid);
+		rc = -EINVAL;
+		goto out_put_hwpt;
+	}
+
+	if (curr == hwpt)
+		goto out_put_hwpt;
+
+	rc = iommu_replace_device_pasid(hwpt->domain, idev->dev, pasid);
+	if (rc) {
+		WARN_ON(xa_err(xa_store(&idev->pasid_hwpts, pasid,
+					curr, GFP_KERNEL)));
+		goto out_put_hwpt;
+	}
+
+	/* Caller must destroy old_hwpt */
+	return curr;
+
+out_put_hwpt:
+	refcount_dec(&hwpt->obj.users);
+	return ERR_PTR(rc);
+}
+
+/**
+ * iommufd_device_pasid_attach - Connect a {device, pasid} to an iommu_domain
+ * @idev: device to attach
+ * @pasid: pasid to attach
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ *
+ * This connects a pasid of the device to an iommu_domain. Once this
+ * completes the device could do DMA with the pasid.
+ *
+ * This function is undone by calling iommufd_device_detach_pasid().
+ *
+ * iommufd does not handle race between iommufd_device_pasid_attach(),
+ * iommufd_device_pasid_replace() and iommufd_device_pasid_detach().
+ * So caller of them should guarantee no concurrent call on the same
+ * device and pasid.
+ */
+int iommufd_device_pasid_attach(struct iommufd_device *idev,
+				u32 pasid, u32 *pt_id)
+{
+	struct attach_data data = {
+		.pasid_attach_fn = &iommufd_device_pasid_do_attach,
+		.pasid = pasid,
+	};
+
+	return iommufd_device_change_pt(idev, pt_id, &data);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_pasid_attach, IOMMUFD);
+
+/**
+ * iommufd_device_pasid_replace - Change the {device, pasid}'s iommu_domain
+ * @idev: device to change
+ * @pasid: pasid to change
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ *
+ * This is the same as
+ *   iommufd_device_pasid_detach();
+ *   iommufd_device_pasid_attach();
+ *
+ * If it fails then no change is made to the attachment. The iommu driver may
+ * implement this so there is no disruption in translation. This can only be
+ * called if iommufd_device_pasid_attach() has already succeeded.
+ *
+ * iommufd does not handle race between iommufd_device_pasid_replace(),
+ * iommufd_device_pasid_attach() and iommufd_device_pasid_detach().
+ * So caller of them should guarantee no concurrent call on the same
+ * device and pasid.
+ */
+int iommufd_device_pasid_replace(struct iommufd_device *idev,
+				 u32 pasid, u32 *pt_id)
+{
+	struct attach_data data = {
+		.pasid_attach_fn = &iommufd_device_pasid_do_replace,
+		.pasid = pasid,
+	};
+
+	return iommufd_device_change_pt(idev, pt_id, &data);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_pasid_replace, IOMMUFD);
+
+/**
+ * iommufd_device_pasid_detach - Disconnect a {device, pasid} to an iommu_domain
+ * @idev: device to detach
+ * @pasid: pasid to detach
+ *
+ * Undo iommufd_device_pasid_attach(). This disconnects the idev/pasid from
+ * the previously attached pt_id.
+ *
+ * iommufd does not handle race between iommufd_device_pasid_detach(),
+ * iommufd_device_pasid_attach() and iommufd_device_pasid_replace().
+ * So caller of them should guarantee no concurrent call on the same
+ * device and pasid.
+ */
+void iommufd_device_pasid_detach(struct iommufd_device *idev, u32 pasid)
+{
+	struct iommufd_hw_pagetable *hwpt;
+
+	hwpt = xa_erase(&idev->pasid_hwpts, pasid);
+	if (WARN_ON(!hwpt))
+		return;
+	iommu_detach_device_pasid(hwpt->domain, idev->dev, pasid);
+	iommufd_hw_pagetable_put(idev->ictx, hwpt);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_pasid_detach, IOMMUFD);
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index ffc3a949f837..0b007c376306 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -26,6 +26,12 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+int iommufd_device_pasid_attach(struct iommufd_device *idev,
+				u32 pasid, u32 *pt_id);
+int iommufd_device_pasid_replace(struct iommufd_device *idev,
+				 u32 pasid, u32 *pt_id);
+void iommufd_device_pasid_detach(struct iommufd_device *idev, u32 pasid);
+
 struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 u32 iommufd_device_to_id(struct iommufd_device *idev);
 
-- 
2.34.1


