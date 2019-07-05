Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7026106E
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfGFLXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:23:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:6331 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfGFLXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:23:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:23:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="158693780"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga008.jf.intel.com with ESMTP; 06 Jul 2019 04:23:12 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, eric.auger@redhat.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [RFC v1 1/4] vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE
Date:   Fri,  5 Jul 2019 19:06:09 +0800
Message-Id: <1562324772-3084-2-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324772-3084-1-git-send-email-yi.l.liu@intel.com>
References: <1562324772-3084-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@linux.intel.com>

This patch adds VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE ioctl
which aims to pass/withdraw the virtual iommu guest configuration
to/from the VFIO driver downto to the iommu subsystem.

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 22 +++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3ddc375..b2d609d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1758,6 +1758,43 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static void
+vfio_detach_pasid_table(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		iommu_detach_pasid_table(d->domain);
+	}
+	mutex_unlock(&iommu->lock);
+}
+
+static int
+vfio_attach_pasid_table(struct vfio_iommu *iommu,
+			struct vfio_iommu_type1_attach_pasid_table *ustruct)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_attach_pasid_table(d->domain, &ustruct->config);
+		if (ret)
+			goto unwind;
+	}
+	goto unlock;
+unwind:
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
+		iommu_detach_pasid_table(d->domain);
+	}
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1828,6 +1865,22 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd == VFIO_IOMMU_ATTACH_PASID_TABLE) {
+		struct vfio_iommu_type1_attach_pasid_table ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_attach_pasid_table,
+				    config);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		return vfio_attach_pasid_table(iommu, &ustruct);
+	} else if (cmd == VFIO_IOMMU_DETACH_PASID_TABLE) {
+		vfio_detach_pasid_table(iommu);
+		return 0;
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748..4316dd8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -763,6 +764,27 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_ATTACH_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
+ *			struct vfio_iommu_type1_attach_pasid_table)
+ *
+ * Passes the PASID table to the host. Calling ATTACH_PASID_TABLE
+ * while a table is already installed is allowed: it replaces the old
+ * table. DETACH does a comprehensive tear down of the nested mode.
+ */
+struct vfio_iommu_type1_attach_pasid_table {
+	__u32	argsz;
+	__u32	flags;
+	struct iommu_pasid_table_config config;
+};
+#define VFIO_IOMMU_ATTACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
+/**
+ * VFIO_IOMMU_DETACH_PASID_TABLE - - _IOWR(VFIO_TYPE, VFIO_BASE + 23)
+ * Detaches the PASID table
+ */
+#define VFIO_IOMMU_DETACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 23)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

