Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAFD21C8D4
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgGLLP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:15:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:45842 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbgGLLOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:14:40 -0400
IronPort-SDR: Jm//NFbWoCmLf3+QCjY1x/60ZDLRJm97mAskZWcVMw+M2Ezt3W9YfQxxkBoHJo1zKsZ0+FBo1/
 GuGuJpxY14rQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="149952699"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="149952699"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:14:30 -0700
IronPort-SDR: TpUadfNXGOKyQtPHLf+zBgdTT1OrKl8lrURofdW1RGomC9+9H9adkelkGxGszaxNVmVe2N0PzG
 a15AnqQ6UvIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="315788582"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2020 04:14:30 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/15] vfio/type1: Allow invalidating first-level/stage IOMMU cache
Date:   Sun, 12 Jul 2020 04:21:06 -0700
Message-Id: <1594552870-55687-12-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch provides an interface allowing the userspace to invalidate
IOMMU cache for first-level page table. It is required when the first
level IOMMU page table is not managed by the host kernel in the nested
translation setup.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v1 -> v2:
*) rename from "vfio/type1: Flush stage-1 IOMMU cache for nesting type"
*) rename vfio_cache_inv_fn() to vfio_dev_cache_invalidate_fn()
*) vfio_dev_cache_inv_fn() always successful
*) remove VFIO_IOMMU_CACHE_INVALIDATE, and reuse VFIO_IOMMU_NESTING_OP
---
 drivers/vfio/vfio_iommu_type1.c | 50 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  3 +++
 2 files changed, 53 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f0f21ff..960cc59 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -3073,6 +3073,53 @@ static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_dev_cache_invalidate_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	unsigned long arg = *(unsigned long *)dc->data;
+
+	iommu_cache_invalidate(dc->domain, dev, (void __user *)arg);
+	return 0;
+}
+
+static long vfio_iommu_invalidate_cache(struct vfio_iommu *iommu,
+					unsigned long arg)
+{
+	struct domain_capsule dc = { .data = &arg };
+	struct vfio_group *group;
+	struct vfio_domain *domain;
+	int ret = 0;
+	struct iommu_nesting_info *info;
+
+	mutex_lock(&iommu->lock);
+	/*
+	 * Cache invalidation is required for any nesting IOMMU,
+	 * so no need to check system-wide PASID support.
+	 */
+	info = iommu->nesting_info;
+	if (!info || !(info->features & IOMMU_NESTING_FEAT_CACHE_INVLD)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	group = vfio_find_nesting_group(iommu);
+	if (!group) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	domain = list_first_entry(&iommu->domain_list,
+				  struct vfio_domain, next);
+	dc.group = group;
+	dc.domain = domain->domain;
+	iommu_group_for_each_dev(group->iommu_group, &dc,
+				 vfio_dev_cache_invalidate_fn);
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
 					unsigned long arg)
 {
@@ -3095,6 +3142,9 @@ static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
 	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
 		ret = vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
 		break;
+	case VFIO_IOMMU_NESTING_OP_CACHE_INVLD:
+		ret = vfio_iommu_invalidate_cache(iommu, arg + minsz);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index a8ad786..845a5800 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1225,6 +1225,8 @@ struct vfio_iommu_type1_pasid_request {
  * +-----------------+-----------------------------------------------+
  * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
  * +-----------------+-----------------------------------------------+
+ * | CACHE_INVLD     |      struct iommu_cache_invalidate_info       |
+ * +-----------------+-----------------------------------------------+
  *
  * returns: 0 on success, -errno on failure.
  */
@@ -1237,6 +1239,7 @@ struct vfio_iommu_type1_nesting_op {
 
 #define VFIO_IOMMU_NESTING_OP_BIND_PGTBL	(0)
 #define VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL	(1)
+#define VFIO_IOMMU_NESTING_OP_CACHE_INVLD	(2)
 
 #define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 19)
 
-- 
2.7.4

