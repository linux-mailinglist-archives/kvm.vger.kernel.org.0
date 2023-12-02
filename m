Return-Path: <kvm+bounces-3229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3944801BD8
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78CBD281C78
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD83913FE4;
	Sat,  2 Dec 2023 09:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IEVmV/1g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236C81A4;
	Sat,  2 Dec 2023 01:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510647; x=1733046647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=rqH35GdOrKoZEkvGITnBvH+ikDglRlVlt01Gqn8iCuQ=;
  b=IEVmV/1gdxf356DBwO04fRRnMuNVHGI2FFm259u7fyHoV3w9F0Xt5KLg
   IlVhnvkJsXcDPS60fWmJLQ/OU2eTm3JusESpxxuII8RJ/LePJCqXHqVGH
   /p9eFpDJdnDciK/N8xGG+GEANlJL6bYQ+D/6GVUtn2pHWe/iODzI8Pg98
   lBtNTlGNr2FedY/wpwWIqKx35TRi1AOJC6K896JJlc1Q2huCE7NT950Sc
   r5hahkRLUP+OzWlBaWDEaGikURFzq/2uhtx1NzhHbdBQ34+tUHiapl7+9
   5gDvK8sJKvIZUpVJiLLH3QEUmCVVDGcej+r9yjK+YQ27wu3mSHDpsyk1X
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="479794143"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="479794143"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:50:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="11414277"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:50:43 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 13/42] iommufd: Add a KVM HW pagetable object
Date: Sat,  2 Dec 2023 17:21:47 +0800
Message-Id: <20231202092147.14208-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add new obj type IOMMUFD_OBJ_HWPT_KVM for KVM HW page tables, which
correspond to iommu stage 2 domains whose paging strcutures and mappings
are managed by KVM.

Extend the IOMMU_HWPT_ALLOC ioctl to accept KVM HW page table specific
data of "struct iommu_hwpt_kvm_info".

The real allocator iommufd_hwpt_kvm_alloc() is now an empty function and
will be implemented in next patch when config IOMMUFD_KVM_HWPT is on.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/iommufd/device.c          | 13 +++++----
 drivers/iommu/iommufd/hw_pagetable.c    | 29 +++++++++++++++++++-
 drivers/iommu/iommufd/iommufd_private.h | 35 +++++++++++++++++++++++++
 drivers/iommu/iommufd/main.c            |  4 +++
 4 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 59d3a07300d93..83af6b7e2784b 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -629,7 +629,8 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 
 	switch (pt_obj->type) {
 	case IOMMUFD_OBJ_HWPT_NESTED:
-	case IOMMUFD_OBJ_HWPT_PAGING: {
+	case IOMMUFD_OBJ_HWPT_PAGING:
+	case IOMMUFD_OBJ_HWPT_KVM: {
 		struct iommufd_hw_pagetable *hwpt =
 			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
 
@@ -667,8 +668,9 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 /**
  * iommufd_device_attach - Connect a device to an iommu_domain
  * @idev: device to attach
- * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HWPT_PAGING
- *         Output the IOMMUFD_OBJ_HWPT_PAGING ID
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HWPT_PAGING, or
+ *         IOMMUFD_OBJ_HWPT_KVM
+ *         Output the IOMMUFD_OBJ_HWPT_PAGING ID or IOMMUFD_OBJ_HWPT_KVM ID
  *
  * This connects the device to an iommu_domain, either automatically or manually
  * selected. Once this completes the device could do DMA.
@@ -696,8 +698,9 @@ EXPORT_SYMBOL_NS_GPL(iommufd_device_attach, IOMMUFD);
 /**
  * iommufd_device_replace - Change the device's iommu_domain
  * @idev: device to change
- * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HWPT_PAGING
- *         Output the IOMMUFD_OBJ_HWPT_PAGING ID
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HWPT_PAGING, or
+ *         IOMMUFD_OBJ_HWPT_KVM
+ *         Output the IOMMUFD_OBJ_HWPT_PAGING ID or IOMMUFD_OBJ_HWPT_KVM ID
  *
  * This is the same as::
  *
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 367459d92f696..c8430ec42cdf8 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -273,6 +273,31 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
 
+	if (cmd->data_type == IOMMU_HWPT_DATA_KVM) {
+		struct iommu_hwpt_kvm_info kvm_data;
+		struct iommufd_hwpt_kvm *hwpt_kvm;
+
+		if (!cmd->data_len || cmd->data_len != sizeof(kvm_data) ||
+		    !cmd->data_uptr) {
+			rc = -EINVAL;
+			goto out_put_idev;
+		}
+		rc = copy_struct_from_user(&kvm_data, sizeof(kvm_data),
+					   u64_to_user_ptr(cmd->data_uptr),
+					   cmd->data_len);
+		if (rc)
+			goto out_put_idev;
+
+		hwpt_kvm = iommufd_hwpt_kvm_alloc(ucmd->ictx, idev, cmd->flags,
+						  &kvm_data);
+		if (IS_ERR(hwpt_kvm)) {
+			rc = PTR_ERR(hwpt_kvm);
+			goto out_put_idev;
+		}
+		hwpt = &hwpt_kvm->common;
+		goto out_respond;
+	}
+
 	pt_obj = iommufd_get_object(ucmd->ictx, cmd->pt_id, IOMMUFD_OBJ_ANY);
 	if (IS_ERR(pt_obj)) {
 		rc = -EINVAL;
@@ -310,6 +335,7 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 		goto out_put_pt;
 	}
 
+out_respond:
 	cmd->out_hwpt_id = hwpt->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
@@ -323,7 +349,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	if (ioas)
 		mutex_unlock(&ioas->mutex);
 out_put_pt:
-	iommufd_put_object(pt_obj);
+	if (cmd->data_type != IOMMU_HWPT_DATA_KVM)
+		iommufd_put_object(pt_obj);
 out_put_idev:
 	iommufd_put_object(&idev->obj);
 	return rc;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 160521800d9b4..a46a6e3e537f9 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -125,6 +125,7 @@ enum iommufd_object_type {
 	IOMMUFD_OBJ_DEVICE,
 	IOMMUFD_OBJ_HWPT_PAGING,
 	IOMMUFD_OBJ_HWPT_NESTED,
+	IOMMUFD_OBJ_HWPT_KVM,
 	IOMMUFD_OBJ_IOAS,
 	IOMMUFD_OBJ_ACCESS,
 #ifdef CONFIG_IOMMUFD_TEST
@@ -266,17 +267,33 @@ struct iommufd_hwpt_nested {
 	struct iommufd_hwpt_paging *parent;
 };
 
+struct iommufd_hwpt_kvm {
+	struct iommufd_hw_pagetable common;
+	void *context;
+};
+
 static inline bool hwpt_is_paging(struct iommufd_hw_pagetable *hwpt)
 {
 	return hwpt->obj.type == IOMMUFD_OBJ_HWPT_PAGING;
 }
 
+static inline bool hwpt_is_kvm(struct iommufd_hw_pagetable *hwpt)
+{
+	return hwpt->obj.type == IOMMUFD_OBJ_HWPT_KVM;
+}
+
 static inline struct iommufd_hwpt_paging *
 to_hwpt_paging(struct iommufd_hw_pagetable *hwpt)
 {
 	return container_of(hwpt, struct iommufd_hwpt_paging, common);
 }
 
+static inline struct iommufd_hwpt_kvm *
+to_hwpt_kvm(struct iommufd_hw_pagetable *hwpt)
+{
+	return container_of(hwpt, struct iommufd_hwpt_kvm, common);
+}
+
 static inline struct iommufd_hwpt_paging *
 iommufd_get_hwpt_paging(struct iommufd_ucmd *ucmd, u32 id)
 {
@@ -413,4 +430,22 @@ static inline bool iommufd_selftest_is_mock_dev(struct device *dev)
 	return false;
 }
 #endif
+
+struct iommu_hwpt_kvm_info;
+static inline struct iommufd_hwpt_kvm *
+iommufd_hwpt_kvm_alloc(struct iommufd_ctx *ictx,
+		       struct iommufd_device *idev, u32 flags,
+		       const struct iommu_hwpt_kvm_info *kvm_data)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void iommufd_hwpt_kvm_abort(struct iommufd_object *obj)
+{
+}
+
+static inline void iommufd_hwpt_kvm_destroy(struct iommufd_object *obj)
+{
+}
+
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 6edef860f91cc..0798c1279133f 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -499,6 +499,10 @@ static const struct iommufd_object_ops iommufd_object_ops[] = {
 		.destroy = iommufd_hwpt_nested_destroy,
 		.abort = iommufd_hwpt_nested_abort,
 	},
+	[IOMMUFD_OBJ_HWPT_KVM] = {
+		.destroy = iommufd_hwpt_kvm_destroy,
+		.abort = iommufd_hwpt_kvm_abort,
+	},
 #ifdef CONFIG_IOMMUFD_TEST
 	[IOMMUFD_OBJ_SELFTEST] = {
 		.destroy = iommufd_selftest_destroy,
-- 
2.17.1


