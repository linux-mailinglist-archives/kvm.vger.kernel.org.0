Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502ED18E8AB
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgCVM0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:26:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:51564 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgCVM00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:26:26 -0400
IronPort-SDR: 1lK/tANWQp5LWleezTVc4pHv35hhcimuGmgdQ/6uxgoUlpxiuX0d9Q38mU3wMGIl/69rBBn/VR
 1YZXU0kTbKpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:26:23 -0700
IronPort-SDR: XVRlIpu/d2DWOsgb+ymfD6NKYbgW+7z52sm8Ou8/b2gOE9wIx/c9xqqTI9gVEdEus1Cwit0U86
 iCybnCM0x0sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239663882"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:26:23 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Date:   Sun, 22 Mar 2020 05:32:04 -0700
Message-Id: <1584880325-10561-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@linux.intel.com>

For VFIO IOMMUs with the type VFIO_TYPE1_NESTING_IOMMU, guest "owns" the
first-level/stage-1 translation structures, the host IOMMU driver has no
knowledge of first-level/stage-1 structure cache updates unless the guest
invalidation requests are trapped and propagated to the host.

This patch adds a new IOCTL VFIO_IOMMU_CACHE_INVALIDATE to propagate guest
first-level/stage-1 IOMMU cache invalidations to host to ensure IOMMU cache
correctness.

With this patch, vSVA (Virtual Shared Virtual Addressing) can be used safely
as the host IOMMU iotlb correctness are ensured.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 22 ++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a877747..937ec3f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2423,6 +2423,15 @@ static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_cache_inv_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct iommu_cache_invalidate_info *cache_inv_info =
+		(struct iommu_cache_invalidate_info *) dc->data;
+
+	return iommu_cache_invalidate(dc->domain, dev, cache_inv_info);
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2629,6 +2638,46 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		}
 		kfree(gbind_data);
 		return ret;
+	} else if (cmd == VFIO_IOMMU_CACHE_INVALIDATE) {
+		struct vfio_iommu_type1_cache_invalidate cache_inv;
+		u32 version;
+		int info_size;
+		void *cache_info;
+		int ret;
+
+		minsz = offsetofend(struct vfio_iommu_type1_cache_invalidate,
+				    flags);
+
+		if (copy_from_user(&cache_inv, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (cache_inv.argsz < minsz || cache_inv.flags)
+			return -EINVAL;
+
+		/* Get the version of struct iommu_cache_invalidate_info */
+		if (copy_from_user(&version,
+			(void __user *) (arg + minsz), sizeof(version)))
+			return -EFAULT;
+
+		info_size = iommu_uapi_get_data_size(
+					IOMMU_UAPI_CACHE_INVAL, version);
+
+		cache_info = kzalloc(info_size, GFP_KERNEL);
+		if (!cache_info)
+			return -ENOMEM;
+
+		if (copy_from_user(cache_info,
+			(void __user *) (arg + minsz), info_size)) {
+			kfree(cache_info);
+			return -EFAULT;
+		}
+
+		mutex_lock(&iommu->lock);
+		ret = vfio_iommu_for_each_dev(iommu, vfio_cache_inv_fn,
+					    cache_info);
+		mutex_unlock(&iommu->lock);
+		kfree(cache_info);
+		return ret;
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2235bc6..62ca791 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -899,6 +899,28 @@ struct vfio_iommu_type1_bind {
  */
 #define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 23)
 
+/**
+ * VFIO_IOMMU_CACHE_INVALIDATE - _IOW(VFIO_TYPE, VFIO_BASE + 24,
+ *			struct vfio_iommu_type1_cache_invalidate)
+ *
+ * Propagate guest IOMMU cache invalidation to the host. The cache
+ * invalidation information is conveyed by @cache_info, the content
+ * format would be structures defined in uapi/linux/iommu.h. User
+ * should be aware of that the struct  iommu_cache_invalidate_info
+ * has a @version field, vfio needs to parse this field before getting
+ * data from userspace.
+ *
+ * Availability of this IOCTL is after VFIO_SET_IOMMU.
+ *
+ * returns: 0 on success, -errno on failure.
+ */
+struct vfio_iommu_type1_cache_invalidate {
+	__u32   argsz;
+	__u32   flags;
+	struct	iommu_cache_invalidate_info cache_info;
+};
+#define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

