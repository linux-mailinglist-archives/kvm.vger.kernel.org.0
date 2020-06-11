Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4631F6796
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgFKMJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:09:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:41828 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbgFKMJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:09:16 -0400
IronPort-SDR: Oeka+v6EZQ8A7+qKGG/L3wTUw61dE077K/rEqIan8OaW0PT5VqzWc8C+xA1WCYmxDKS7qW8LxY
 kNfntsX758kQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:09:10 -0700
IronPort-SDR: vWZgDANsXcC7EravlJOASXOBWf9AaJzlGMD0g2oRs8HAC+xfreVP9zj4LYumlqfs5swsLXEtNo
 rcKa1c5asScg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="419082482"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 05:09:09 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/15] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST (alloc/free)
Date:   Thu, 11 Jun 2020 05:15:25 -0700
Message-Id: <1591877734-66527-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allows user space to request PASID allocation/free, e.g. when
serving the request from the guest.

PASIDs that are not freed by userspace are automatically freed when the
IOASID set is destroyed when process exits.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v1 -> v2:
*) move the vfio_mm related code to be a seprate module
*) use a single structure for alloc/free, could support a range of PASIDs
*) fetch vfio_mm at group_attach time instead of at iommu driver open time

 drivers/vfio/Kconfig            |  1 +
 drivers/vfio/vfio_iommu_type1.c | 96 ++++++++++++++++++++++++++++++++++++++++-
 drivers/vfio/vfio_pasid.c       | 10 +++++
 include/linux/vfio.h            |  6 +++
 include/uapi/linux/vfio.h       | 36 ++++++++++++++++
 5 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 3d8a108..95d90c6 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -2,6 +2,7 @@
 config VFIO_IOMMU_TYPE1
 	tristate
 	depends on VFIO
+	select VFIO_PASID if (X86)
 	default n
 
 config VFIO_IOMMU_SPAPR_TCE
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 22432cf..a7b3a83 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,6 +72,7 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	struct iommu_nesting_info *nesting_info;
+	struct vfio_mm		*vmm;
 };
 
 struct vfio_domain {
@@ -1615,6 +1616,17 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 
 	list_splice_tail(iova_copy, iova);
 }
+
+static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
+{
+	if (iommu->vmm) {
+		vfio_mm_put(iommu->vmm);
+		iommu->vmm = NULL;
+	}
+
+	kfree(iommu->nesting_info);
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -1738,6 +1750,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			goto out_detach;
 		}
 		iommu->nesting_info = info;
+
+		if (info->features & IOMMU_NESTING_FEAT_SYSWIDE_PASID) {
+			struct vfio_mm *vmm;
+			int sid;
+
+			vmm = vfio_mm_get_from_task(current);
+			if (IS_ERR(vmm)) {
+				ret = PTR_ERR(vmm);
+				goto out_detach;
+			}
+			iommu->vmm = vmm;
+
+			sid = vfio_mm_ioasid_sid(vmm);
+			ret = iommu_domain_set_attr(domain->domain,
+						    DOMAIN_ATTR_IOASID_SID,
+						    &sid);
+			if (ret)
+				goto out_detach;
+		}
 	}
 
 	/* Get aperture info */
@@ -1841,7 +1872,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	return 0;
 
 out_detach:
-	kfree(iommu->nesting_info);
+	if (iommu->nesting_info)
+		vfio_iommu_release_nesting_info(iommu);
 	vfio_iommu_detach_group(domain, group);
 out_domain:
 	iommu_domain_free(domain->domain);
@@ -2040,7 +2072,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 				else
 					vfio_iommu_unmap_unpin_reaccount(iommu);
 
-				kfree(iommu->nesting_info);
+				if (iommu->nesting_info)
+					vfio_iommu_release_nesting_info(iommu);
 			}
 			iommu_domain_free(domain->domain);
 			list_del(&domain->next);
@@ -2363,6 +2396,63 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 
 }
 
+static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
+					unsigned int min,
+					unsigned int max)
+{
+	int ret = -ENOTSUPP;
+
+	mutex_lock(&iommu->lock);
+	if (iommu->vmm)
+		ret = vfio_pasid_alloc(iommu->vmm, min, max);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
+					unsigned int min,
+					unsigned int max)
+{
+	int ret = -ENOTSUPP;
+
+	mutex_lock(&iommu->lock);
+	if (iommu->vmm) {
+		vfio_pasid_free_range(iommu->vmm, min, max);
+		ret = 0;
+	}
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
+					  unsigned long arg)
+{
+	struct vfio_iommu_type1_pasid_request req;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_iommu_type1_pasid_request, range);
+
+	if (copy_from_user(&req, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (req.argsz < minsz || (req.flags & ~VFIO_PASID_REQUEST_MASK))
+		return -EINVAL;
+
+	if (req.range.min > req.range.max)
+		return -EINVAL;
+
+	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
+	case VFIO_IOMMU_ALLOC_PASID:
+		return vfio_iommu_type1_pasid_alloc(iommu,
+					req.range.min, req.range.max);
+	case VFIO_IOMMU_FREE_PASID:
+		return vfio_iommu_type1_pasid_free(iommu,
+					req.range.min, req.range.max);
+	default:
+		return -EINVAL;
+	}
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2377,6 +2467,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_map_dma(iommu, arg);
 	case VFIO_IOMMU_UNMAP_DMA:
 		return vfio_iommu_type1_unmap_dma(iommu, arg);
+	case VFIO_IOMMU_PASID_REQUEST:
+		return vfio_iommu_type1_pasid_request(iommu, arg);
 	}
 
 	return -ENOTTY;
diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
index dd5b6d1..2ea9f1a 100644
--- a/drivers/vfio/vfio_pasid.c
+++ b/drivers/vfio/vfio_pasid.c
@@ -54,6 +54,7 @@ void vfio_mm_put(struct vfio_mm *vmm)
 {
 	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_pasid.vfio_mm_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_mm_put);
 
 static void vfio_mm_get(struct vfio_mm *vmm)
 {
@@ -103,6 +104,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
 	mmput(mm);
 	return vmm;
 }
+EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
+
+int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
+{
+	return vmm->ioasid_sid;
+}
+EXPORT_SYMBOL_GPL(vfio_mm_ioasid_sid);
 
 int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
 {
@@ -112,6 +120,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
 
 	return (pasid == INVALID_IOASID) ? -ENOSPC : pasid;
 }
+EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
 
 void vfio_pasid_free_range(struct vfio_mm *vmm,
 			    ioasid_t min, ioasid_t max)
@@ -129,6 +138,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
 	for (; pasid <= max; pasid++)
 		ioasid_free(pasid);
 }
+EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
 
 static int __init vfio_pasid_init(void)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 104418a..76da56e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -99,6 +99,7 @@ struct vfio_mm;
 #if IS_ENABLED(CONFIG_VFIO_PASID)
 extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
 extern void vfio_mm_put(struct vfio_mm *vmm);
+int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
 extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
 extern void vfio_pasid_free_range(struct vfio_mm *vmm,
 					ioasid_t min, ioasid_t max);
@@ -112,6 +113,11 @@ static inline void vfio_mm_put(struct vfio_mm *vmm)
 {
 }
 
+static inline int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
+{
+	return -ENOTTY;
+}
+
 static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
 {
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 26e3dce..24d1992 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -840,6 +840,42 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
+ *				struct vfio_iommu_type1_pasid_request)
+ *
+ * PASID (Processor Address Space ID) is a PCIe concept for tagging
+ * address spaces in DMA requests. When system-wide PASID allocation
+ * is required by underlying iommu driver (e.g. Intel VT-d), this
+ * provides an interface for userspace to request pasid alloc/free
+ * for its assigned devices. Userspace should check the availability
+ * of this API through VFIO_IOMMU_GET_INFO.
+ *
+ * @flags=VFIO_IOMMU_ALLOC_PASID, allocate a single PASID within @range.
+ * @flags=VFIO_IOMMU_FREE_PASID, free the PASIDs within @range.
+ * @range is [min, max], which means both @min and @max are inclusive.
+ * ALLOC_PASID and FREE_PASID are mutually exclusive.
+ *
+ * returns: allocated PASID value on success, -errno on failure for
+ *	     ALLOC_PASID;
+ *	     0 for FREE_PASID operation;
+ */
+struct vfio_iommu_type1_pasid_request {
+	__u32	argsz;
+#define VFIO_IOMMU_ALLOC_PASID	(1 << 0)
+#define VFIO_IOMMU_FREE_PASID	(1 << 1)
+	__u32	flags;
+	struct {
+		__u32	min;
+		__u32	max;
+	} range;
+};
+
+#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_ALLOC_PASID | \
+					 VFIO_IOMMU_FREE_PASID)
+
+#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

