Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CD5264499
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgIJKuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:50:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:21877 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgIJKom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:44:42 -0400
IronPort-SDR: S5MGevmNSs5m6Uw6reZLVLGPB5/EEaZSZt4enctleyx4Pjth/8sSynPlIGnPJ0f/fhIjwR0nnB
 fpe2FBXdBeGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066289"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066289"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:35 -0700
IronPort-SDR: wp/YY19N3Tx4zieq8L5L0QP5jGYXf/2kGKP3VrdXqfBYpUt+vA4MuTjTQ6hZ2YLJY+x3keUr1t
 guzYkPoxFGlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137209"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:34 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 10/16] vfio/type1: Support binding guest page tables to PASID
Date:   Thu, 10 Sep 2020 03:45:27 -0700
Message-Id: <1599734733-6431-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nesting translation allows two-levels/stages page tables, with 1st level
for guest translations (e.g. GVA->GPA), 2nd level for host translations
(e.g. GPA->HPA). This patch adds interface for binding guest page tables
to a PASID. This PASID must have been allocated by the userspace before
the binding request.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v6 -> v7:
*) introduced @user in struct domain_capsule to simplify the code per Eric's
   suggestion.
*) introduced VFIO_IOMMU_NESTING_OP_NUM for sanitizing op from userspace.
*) corrected the @argsz value of unbind_data in vfio_group_unbind_gpasid_fn().

v5 -> v6:
*) dropped vfio_find_nesting_group() and add vfio_get_nesting_domain_capsule().
   per comment from Eric.
*) use iommu_uapi_sva_bind/unbind_gpasid() and iommu_sva_unbind_gpasid() in
   linux/iommu.h for userspace operation and in-kernel operation.

v3 -> v4:
*) address comments from Alex on v3

v2 -> v3:
*) use __iommu_sva_unbind_gpasid() for unbind call issued by VFIO
   https://lore.kernel.org/linux-iommu/1592931837-58223-6-git-send-email-jacob.jun.pan@linux.intel.com/

v1 -> v2:
*) rename subject from "vfio/type1: Bind guest page tables to host"
*) remove VFIO_IOMMU_BIND, introduce VFIO_IOMMU_NESTING_OP to support bind/
   unbind guet page table
*) replaced vfio_iommu_for_each_dev() with a group level loop since this
   series enforces one group per container w/ nesting type as start.
*) rename vfio_bind/unbind_gpasid_fn() to vfio_dev_bind/unbind_gpasid_fn()
*) vfio_dev_unbind_gpasid() always successful
*) use vfio_mm->pasid_lock to avoid race between PASID free and page table
   bind/unbind
---
 drivers/vfio/vfio_iommu_type1.c | 163 ++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_pasid.c       |  26 +++++++
 include/linux/vfio.h            |  20 +++++
 include/uapi/linux/vfio.h       |  36 +++++++++
 4 files changed, 245 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bd4b668..11f1156 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -149,6 +149,39 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
+struct domain_capsule {
+	struct vfio_group	*group;
+	struct iommu_domain	*domain;
+	/* set if @data contains a user pointer*/
+	bool			user;
+	void			*data;
+};
+
+/* iommu->lock must be held */
+static int vfio_prepare_nesting_domain_capsule(struct vfio_iommu *iommu,
+					       struct domain_capsule *dc)
+{
+	struct vfio_domain *domain = NULL;
+	struct vfio_group *group = NULL;
+
+	if (!iommu->nesting_info)
+		return -EINVAL;
+
+	/*
+	 * Only support singleton container with nesting type. If
+	 * nesting_info is non-NULL, the container is non-empty.
+	 * Also domain is non-empty.
+	 */
+	domain = list_first_entry(&iommu->domain_list,
+				  struct vfio_domain, next);
+	group = list_first_entry(&domain->group_list,
+				 struct vfio_group, next);
+	dc->group = group;
+	dc->domain = domain->domain;
+	dc->user = true;
+	return 0;
+}
+
 static int put_pfn(unsigned long pfn, int prot);
 
 static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
@@ -2405,6 +2438,49 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	unsigned long arg = *(unsigned long *)dc->data;
+
+	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
+					  (void __user *)arg);
+}
+
+static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+
+	if (dc->user) {
+		unsigned long arg = *(unsigned long *)dc->data;
+
+		iommu_uapi_sva_unbind_gpasid(dc->domain,
+					     dev, (void __user *)arg);
+	} else {
+		struct iommu_gpasid_bind_data *unbind_data =
+				(struct iommu_gpasid_bind_data *)dc->data;
+
+		iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
+	}
+	return 0;
+}
+
+static void vfio_group_unbind_gpasid_fn(ioasid_t pasid, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct iommu_gpasid_bind_data unbind_data;
+
+	unbind_data.argsz = sizeof(struct iommu_gpasid_bind_data);
+	unbind_data.flags = 0;
+	unbind_data.hpasid = pasid;
+
+	dc->user = false;
+	dc->data = &unbind_data;
+
+	iommu_group_for_each_dev(dc->group->iommu_group,
+				 dc, vfio_dev_unbind_gpasid_fn);
+}
+
 static void vfio_iommu_type1_detach_group(void *iommu_data,
 					  struct iommu_group *iommu_group)
 {
@@ -2448,6 +2524,20 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
+		if (iommu->vmm && (iommu->nesting_info->features &
+					IOMMU_NESTING_FEAT_BIND_PGTBL)) {
+			struct domain_capsule dc = { .group = group,
+						     .domain = domain->domain,
+						     .data = NULL };
+
+			/*
+			 * Unbind page tables bound with system wide PASIDs
+			 * which are allocated to userspace.
+			 */
+			vfio_mm_for_each_pasid(iommu->vmm, &dc,
+					       vfio_group_unbind_gpasid_fn);
+		}
+
 		vfio_iommu_detach_group(domain, group);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
@@ -2982,6 +3072,77 @@ static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
+				       bool is_bind, unsigned long arg)
+{
+	struct domain_capsule dc = { .data = &arg };
+	struct iommu_nesting_info *info;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+
+	info = iommu->nesting_info;
+	if (!info || !(info->features & IOMMU_NESTING_FEAT_BIND_PGTBL)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	if (!iommu->vmm) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = vfio_prepare_nesting_domain_capsule(iommu, &dc);
+	if (ret)
+		goto out_unlock;
+
+	/* Avoid race with other containers within the same process */
+	vfio_mm_pasid_lock(iommu->vmm);
+
+	if (is_bind)
+		ret = iommu_group_for_each_dev(dc.group->iommu_group, &dc,
+					       vfio_dev_bind_gpasid_fn);
+	if (ret || !is_bind)
+		iommu_group_for_each_dev(dc.group->iommu_group,
+					 &dc, vfio_dev_unbind_gpasid_fn);
+
+	vfio_mm_pasid_unlock(iommu->vmm);
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
+					unsigned long arg)
+{
+	struct vfio_iommu_type1_nesting_op hdr;
+	unsigned int minsz;
+	int ret;
+
+	minsz = offsetofend(struct vfio_iommu_type1_nesting_op, flags);
+
+	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz ||
+	    hdr.flags & ~VFIO_NESTING_OP_MASK ||
+	    (hdr.flags & VFIO_NESTING_OP_MASK) >= VFIO_IOMMU_NESTING_OP_NUM)
+		return -EINVAL;
+
+	switch (hdr.flags & VFIO_NESTING_OP_MASK) {
+	case VFIO_IOMMU_NESTING_OP_BIND_PGTBL:
+		ret = vfio_iommu_handle_pgtbl_op(iommu, true, arg + minsz);
+		break;
+	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
+		ret = vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -3000,6 +3161,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_dirty_pages(iommu, arg);
 	case VFIO_IOMMU_PASID_REQUEST:
 		return vfio_iommu_type1_pasid_request(iommu, arg);
+	case VFIO_IOMMU_NESTING_OP:
+		return vfio_iommu_type1_nesting_op(iommu, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
index 0ec4660..9e2e4b0 100644
--- a/drivers/vfio/vfio_pasid.c
+++ b/drivers/vfio/vfio_pasid.c
@@ -220,6 +220,8 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
 	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
 	 * teardown necessary structures depending on the to-be-freed
 	 * PASID.
+	 * Hold pasid_lock also avoids race with PASID usages like bind/
+	 * unbind page tables to requested PASID.
 	 */
 	mutex_lock(&vmm->pasid_lock);
 	while ((vid = vfio_find_pasid(vmm, min, max)) != NULL)
@@ -228,6 +230,30 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
 }
 EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
 
+int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
+			   void (*fn)(ioasid_t id, void *data))
+{
+	int ret;
+
+	mutex_lock(&vmm->pasid_lock);
+	ret = ioasid_set_for_each_ioasid(vmm->ioasid_set, fn, data);
+	mutex_unlock(&vmm->pasid_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_mm_for_each_pasid);
+
+void vfio_mm_pasid_lock(struct vfio_mm *vmm)
+{
+	mutex_lock(&vmm->pasid_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_mm_pasid_lock);
+
+void vfio_mm_pasid_unlock(struct vfio_mm *vmm)
+{
+	mutex_unlock(&vmm->pasid_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_mm_pasid_unlock);
+
 static int __init vfio_pasid_init(void)
 {
 	mutex_init(&vfio_mm_lock);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 5c3d7a8..6a999c3 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -105,6 +105,11 @@ extern struct ioasid_set *vfio_mm_ioasid_set(struct vfio_mm *vmm);
 extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
 extern void vfio_pasid_free_range(struct vfio_mm *vmm,
 				  ioasid_t min, ioasid_t max);
+extern int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
+				  void (*fn)(ioasid_t id, void *data));
+extern void vfio_mm_pasid_lock(struct vfio_mm *vmm);
+extern void vfio_mm_pasid_unlock(struct vfio_mm *vmm);
+
 #else
 static inline struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
 {
@@ -129,6 +134,21 @@ static inline void vfio_pasid_free_range(struct vfio_mm *vmm,
 					  ioasid_t min, ioasid_t max)
 {
 }
+
+static inline int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
+					 void (*fn)(ioasid_t id, void *data))
+{
+	return -ENOTTY;
+}
+
+static inline void vfio_mm_pasid_lock(struct vfio_mm *vmm)
+{
+}
+
+static inline void vfio_mm_pasid_unlock(struct vfio_mm *vmm)
+{
+}
+
 #endif /* CONFIG_VFIO_PASID */
 
 /*
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index a4bc42e..a99bd71 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1215,6 +1215,42 @@ struct vfio_iommu_type1_pasid_request {
 
 #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
 
+/**
+ * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 19,
+ *				struct vfio_iommu_type1_nesting_op)
+ *
+ * This interface allows userspace to utilize the nesting IOMMU
+ * capabilities as reported in VFIO_IOMMU_TYPE1_INFO_CAP_NESTING
+ * cap through VFIO_IOMMU_GET_INFO. For platforms which require
+ * system wide PASID, PASID will be allocated by VFIO_IOMMU_PASID
+ * _REQUEST.
+ *
+ * @data[] types defined for each op:
+ * +=================+===============================================+
+ * | NESTING OP      |      @data[]                                  |
+ * +=================+===============================================+
+ * | BIND_PGTBL      |      struct iommu_gpasid_bind_data            |
+ * +-----------------+-----------------------------------------------+
+ * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
+ * +-----------------+-----------------------------------------------+
+ *
+ * returns: 0 on success, -errno on failure.
+ */
+struct vfio_iommu_type1_nesting_op {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_NESTING_OP_MASK	(0xffff) /* lower 16-bits for op */
+	__u8	data[];
+};
+
+enum {
+	VFIO_IOMMU_NESTING_OP_BIND_PGTBL,
+	VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL,
+	VFIO_IOMMU_NESTING_OP_NUM,
+};
+
+#define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 19)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

