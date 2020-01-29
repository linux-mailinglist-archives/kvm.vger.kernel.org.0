Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE514CA4B
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgA2MHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:07:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:59025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbgA2MGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:06:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:06:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222433139"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2020 04:06:38 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v3 2/8] vfio/type1: Make per-application (VM) PASID quota tunable
Date:   Wed, 29 Jan 2020 04:11:46 -0800
Message-Id: <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

The PASID quota is per-application (VM) according to vfio's PASID
management rule. For better flexibility, quota shall be user tunable
. This patch provides a VFIO based user interface for which quota can
be adjusted. However, quota cannot be adjusted downward below the
number of outstanding PASIDs.

This patch only makes the per-VM PASID quota tunable. While for the
way to tune the default PASID quota, it may require a new vfio module
option or other way. This may be another patchset in future.

Previous discussions:
https://patchwork.kernel.org/patch/11209429/

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 33 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 22 ++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e836d04..1cf75f5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2243,6 +2243,27 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_type1_set_pasid_quota(struct vfio_iommu *iommu,
+					    u32 quota)
+{
+	struct vfio_mm *vmm = iommu->vmm;
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+	mutex_lock(&vmm->pasid_lock);
+	if (vmm->pasid_count > quota) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	vmm->pasid_quota = quota;
+	ret = quota;
+
+out_unlock:
+	mutex_unlock(&vmm->pasid_lock);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2389,6 +2410,18 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		default:
 			return -EINVAL;
 		}
+	} else if (cmd == VFIO_IOMMU_SET_PASID_QUOTA) {
+		struct vfio_iommu_type1_pasid_quota quota;
+
+		minsz = offsetofend(struct vfio_iommu_type1_pasid_quota,
+				    quota);
+
+		if (copy_from_user(&quota, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (quota.argsz < minsz)
+			return -EINVAL;
+		return vfio_iommu_type1_set_pasid_quota(iommu, quota.quota);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 298ac80..d4bf415 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -835,6 +835,28 @@ struct vfio_iommu_type1_pasid_request {
  */
 #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 22)
 
+/**
+ * @quota: the new pasid quota which a userspace application (e.g. VM)
+ * is configured.
+ */
+struct vfio_iommu_type1_pasid_quota {
+	__u32	argsz;
+	__u32	flags;
+	__u32	quota;
+};
+
+/**
+ * VFIO_IOMMU_SET_PASID_QUOTA - _IOW(VFIO_TYPE, VFIO_BASE + 23,
+ *				struct vfio_iommu_type1_pasid_quota)
+ *
+ * Availability of this feature depends on PASID support in the device,
+ * its bus, the underlying IOMMU and the CPU architecture. In VFIO, it
+ * is available after VFIO_SET_IOMMU.
+ *
+ * returns: latest quota on success, -errno on failure.
+ */
+#define VFIO_IOMMU_SET_PASID_QUOTA	_IO(VFIO_TYPE, VFIO_BASE + 23)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

