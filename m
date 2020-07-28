Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF2230298
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgG1GVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:21:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:26364 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgG1GVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:21:00 -0400
IronPort-SDR: zjoLI/cos27qH2EZL/4rk9dQFau7Vhr0VCImFvyzne7KWq201n0FJmyXqNJKAfdlO/Pya6N6Z1
 H4WNfkmof0hA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="212681242"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="212681242"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:20:55 -0700
IronPort-SDR: fZ4JEMY4zab+48XXStfmD2HLd1rYyWkFj66WJ5wx5qO0LZoF7XMSglcMuLgKrIB2i9PQQVbQi1
 dgVjc7Af4mjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="320274401"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2020 23:20:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/15] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST (alloc/free)
Date:   Mon, 27 Jul 2020 23:27:36 -0700
Message-Id: <1595917664-33276-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allows userspace to request PASID allocation/free, e.g. when
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
v5 -> v6:
*) address comments from Eric against v5. remove the alloc/free helper.

v4 -> v5:
*) address comments from Eric Auger.
*) the comments for the PASID_FREE request is addressed in patch 5/15 of
   this series.

v3 -> v4:
*) address comments from v3, except the below comment against the range
   of PASID_FREE request. needs more help on it.
    "> +if (req.range.min > req.range.max)

     Is it exploitable that a user can spin the kernel for a long time in
     the case of a free by calling this with [0, MAX_UINT] regardless of
     their actual allocations?"
    https://lore.kernel.org/linux-iommu/20200702151832.048b44d1@x1.home/

v1 -> v2:
*) move the vfio_mm related code to be a seprate module
*) use a single structure for alloc/free, could support a range of PASIDs
*) fetch vfio_mm at group_attach time instead of at iommu driver open time
---
 drivers/vfio/Kconfig            |  1 +
 drivers/vfio/vfio_iommu_type1.c | 69 +++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_pasid.c       | 10 ++++++
 include/linux/vfio.h            |  6 ++++
 include/uapi/linux/vfio.h       | 37 ++++++++++++++++++++++
 5 files changed, 123 insertions(+)

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
index 18ff0c3..ea89c7c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -76,6 +76,7 @@ struct vfio_iommu {
 	bool				dirty_page_tracking;
 	bool				pinned_page_dirty_scope;
 	struct iommu_nesting_info	*nesting_info;
+	struct vfio_mm			*vmm;
 };
 
 struct vfio_domain {
@@ -1937,6 +1938,11 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 
 static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
 {
+	if (iommu->vmm) {
+		vfio_mm_put(iommu->vmm);
+		iommu->vmm = NULL;
+	}
+
 	kfree(iommu->nesting_info);
 	iommu->nesting_info = NULL;
 }
@@ -2071,6 +2077,26 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 					    iommu->nesting_info);
 		if (ret)
 			goto out_detach;
+
+		if (iommu->nesting_info->features &
+					IOMMU_NESTING_FEAT_SYSWIDE_PASID) {
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
@@ -2859,6 +2885,47 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	return -EINVAL;
 }
 
+static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
+					  unsigned long arg)
+{
+	struct vfio_iommu_type1_pasid_request req;
+	unsigned long minsz;
+	int ret;
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
+	mutex_lock(&iommu->lock);
+	if (!iommu->vmm) {
+		mutex_unlock(&iommu->lock);
+		return -EOPNOTSUPP;
+	}
+
+	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
+	case VFIO_IOMMU_FLAG_ALLOC_PASID:
+		ret = vfio_pasid_alloc(iommu->vmm, req.range.min,
+				       req.range.max);
+		break;
+	case VFIO_IOMMU_FLAG_FREE_PASID:
+		vfio_pasid_free_range(iommu->vmm, req.range.min,
+				      req.range.max);
+		ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2875,6 +2942,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_unmap_dma(iommu, arg);
 	case VFIO_IOMMU_DIRTY_PAGES:
 		return vfio_iommu_type1_dirty_pages(iommu, arg);
+	case VFIO_IOMMU_PASID_REQUEST:
+		return vfio_iommu_type1_pasid_request(iommu, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
index befcf29..8d0317f 100644
--- a/drivers/vfio/vfio_pasid.c
+++ b/drivers/vfio/vfio_pasid.c
@@ -61,6 +61,7 @@ void vfio_mm_put(struct vfio_mm *vmm)
 {
 	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_mm_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_mm_put);
 
 static void vfio_mm_get(struct vfio_mm *vmm)
 {
@@ -114,6 +115,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
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
 
 /*
  * Find PASID within @min and @max
@@ -202,6 +210,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
 
 	return pasid;
 }
+EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
 
 void vfio_pasid_free_range(struct vfio_mm *vmm,
 			   ioasid_t min, ioasid_t max)
@@ -218,6 +227,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
 		vfio_remove_pasid(vmm, vid);
 	mutex_unlock(&vmm->pasid_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
 
 static int __init vfio_pasid_init(void)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 31472a9..a355d01 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -101,6 +101,7 @@ struct vfio_mm;
 #if IS_ENABLED(CONFIG_VFIO_PASID)
 extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
 extern void vfio_mm_put(struct vfio_mm *vmm);
+extern int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
 extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
 extern void vfio_pasid_free_range(struct vfio_mm *vmm,
 				  ioasid_t min, ioasid_t max);
@@ -114,6 +115,11 @@ static inline void vfio_mm_put(struct vfio_mm *vmm)
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
index 0cf3d6d..6d79557 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1172,6 +1172,43 @@ struct vfio_iommu_type1_dirty_bitmap_get {
 
 #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/**
+ * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
+ *				struct vfio_iommu_type1_pasid_request)
+ *
+ * PASID (Processor Address Space ID) is a PCIe concept for tagging
+ * address spaces in DMA requests. When system-wide PASID allocation
+ * is required by the underlying iommu driver (e.g. Intel VT-d), this
+ * provides an interface for userspace to request pasid alloc/free
+ * for its assigned devices. Userspace should check the availability
+ * of this API by checking VFIO_IOMMU_TYPE1_INFO_CAP_NESTING through
+ * VFIO_IOMMU_GET_INFO.
+ *
+ * @flags=VFIO_IOMMU_FLAG_ALLOC_PASID, allocate a single PASID within @range.
+ * @flags=VFIO_IOMMU_FLAG_FREE_PASID, free the PASIDs within @range.
+ * @range is [min, max], which means both @min and @max are inclusive.
+ * ALLOC_PASID and FREE_PASID are mutually exclusive.
+ *
+ * returns: allocated PASID value on success, -errno on failure for
+ *	     ALLOC_PASID;
+ *	     0 for FREE_PASID operation;
+ */
+struct vfio_iommu_type1_pasid_request {
+	__u32	argsz;
+#define VFIO_IOMMU_FLAG_ALLOC_PASID	(1 << 0)
+#define VFIO_IOMMU_FLAG_FREE_PASID	(1 << 1)
+	__u32	flags;
+	struct {
+		__u32	min;
+		__u32	max;
+	} range;
+};
+
+#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_FLAG_ALLOC_PASID | \
+					 VFIO_IOMMU_FLAG_FREE_PASID)
+
+#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

