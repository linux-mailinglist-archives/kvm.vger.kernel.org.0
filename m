Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2CE32A740
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839152AbhCBQFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:37930 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242529AbhCBMpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:45:01 -0500
IronPort-SDR: FoJJD5dG8xlv0DyyDMrSfaECLXHXF0nfLWCSVBmnckFtYgRpUHAGfT60bpjmJhq0njJEjU8OGE
 f/rhabvtVcEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="206431161"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="206431161"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:37:07 -0800
IronPort-SDR: jmziIK2qvXlVlgn5plbq/JgH03jp4wDn4j01/WlR99jI5ZPa6L2i0bdEJ1vXpXFf7o+c7nOPYp
 5uvY+Iknf0MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472054"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:37:02 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com
Subject: [Patch v8 04/10] vfio/type1: Support binding guest page tables to PASID
Date:   Wed,  3 Mar 2021 04:35:39 +0800
Message-Id: <20210302203545.436623-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nesting translation allows two-levels/stages page tables, with 1st level
for guest translations (e.g. GVA->GPA), 2nd level for host translations
(e.g. GPA->HPA). This patch adds interface for binding guest page tables
to a PASID. This PASID must have been allocated by the userspace before
the binding request. e.g. allocated from /dev/ioasid. As the bind data
is parsed by iommu abstract layer, so this patch doesn't have the ownership
check against the PASID from userspace. It would be done in the iommu sub-
system.

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
v7 -> v8:
*) adapt to /dev/ioasid
*) address comments from Alex on v7.
*) adapt to latest iommu_sva_unbind_gpasid() implementation.
*) remove the OP check against VFIO_IOMMU_NESTING_OP_NUM as it's redundant
   to the default switch case in vfio_iommu_handle_pgtbl_op().

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
 drivers/vfio/vfio_iommu_type1.c | 156 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  35 +++++++
 2 files changed, 191 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3a5c84d4f19b..0044931b80dc 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -164,6 +164,34 @@ struct vfio_regions {
 
 #define WAITED 1
 
+struct domain_capsule {
+	struct vfio_group	*group;
+	struct iommu_domain	*domain;
+	void			*data;
+	/* set if @data contains a user pointer*/
+	bool			user;
+};
+
+/* iommu->lock must be held */
+static int vfio_prepare_nesting_domain_capsule(struct vfio_iommu *iommu,
+					       struct domain_capsule *dc)
+{
+	struct vfio_domain *domain;
+	struct vfio_group *group;
+
+	if (!iommu->nesting_info)
+		return -EINVAL;
+
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
@@ -2607,6 +2635,51 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
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
+	/*
+	 * dc->user is a toggle for the unbind operation. When user
+	 * set, the dc->data passes in a __user pointer and requires
+	 * to use iommu_uapi_sva_unbind_gpasid(), in which it will
+	 * copy the unbind data from the user buffer. When user is
+	 * clear, the dc->data passes in a pasid which is going to
+	 * be unbind no need to copy data from userspace.
+	 */
+	if (dc->user) {
+		unsigned long arg = *(unsigned long *)dc->data;
+
+		iommu_uapi_sva_unbind_gpasid(dc->domain,
+					     dev, (void __user *)arg);
+	} else {
+		ioasid_t pasid = *(ioasid_t *)dc->data;
+
+		iommu_sva_unbind_gpasid(dc->domain, dev, pasid);
+	}
+	return 0;
+}
+
+static void vfio_group_unbind_gpasid_fn(ioasid_t pasid, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+
+	dc->user = false;
+	dc->data = &pasid;
+
+	iommu_group_for_each_dev(dc->group->iommu_group,
+				 dc, vfio_dev_unbind_gpasid_fn);
+}
+
 static void vfio_iommu_type1_detach_group(void *iommu_data,
 					  struct iommu_group *iommu_group)
 {
@@ -2650,6 +2723,27 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
+		if (iommu->nesting_info &&
+		    iommu->nesting_info->features &
+					IOMMU_NESTING_FEAT_BIND_PGTBL) {
+			struct domain_capsule dc = { .group = group,
+						     .domain = domain->domain,
+						     .data = NULL };
+			struct ioasid_user *iuser;
+
+			/*
+			 * For devices attached to nesting type iommu,
+			 * VFIO should unbind page tables bound with the
+			 * devices in the iommu group before detaching.
+			 */
+			iuser = ioasid_user_get_from_task(current);
+			if (!(IS_ERR(iuser) || !iuser)) {
+				ioasid_user_for_each_id(iuser, &dc,
+					       vfio_group_unbind_gpasid_fn);
+				ioasid_user_put(iuser);
+			}
+		}
+
 		vfio_iommu_detach_group(domain, group);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
@@ -3166,6 +3260,66 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	return -EINVAL;
 }
 
+static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
+				       bool is_bind, unsigned long arg)
+{
+	struct domain_capsule dc = { .data = &arg, .user = true };
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
+	ret = vfio_prepare_nesting_domain_capsule(iommu, &dc);
+	if (ret)
+		goto out_unlock;
+
+	if (is_bind)
+		ret = iommu_group_for_each_dev(dc.group->iommu_group, &dc,
+					       vfio_dev_bind_gpasid_fn);
+	if (ret || !is_bind)
+		iommu_group_for_each_dev(dc.group->iommu_group,
+					 &dc, vfio_dev_unbind_gpasid_fn);
+
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
+	if (hdr.argsz < minsz || hdr.flags & ~VFIO_NESTING_OP_MASK)
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
@@ -3182,6 +3336,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_unmap_dma(iommu, arg);
 	case VFIO_IOMMU_DIRTY_PAGES:
 		return vfio_iommu_type1_dirty_pages(iommu, arg);
+	case VFIO_IOMMU_NESTING_OP:
+		return vfio_iommu_type1_nesting_op(iommu, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5dab20aaf7e7..985e6cf4c52d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1227,6 +1227,41 @@ struct vfio_iommu_type1_dirty_bitmap_get {
 
 #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/**
+ * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 18,
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
+};
+
+#define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.25.1

