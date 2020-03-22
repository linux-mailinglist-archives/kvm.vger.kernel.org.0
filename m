Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4492018E8AF
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCVM0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:26:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:51562 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgCVM0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:26:25 -0400
IronPort-SDR: p+DVMWb/fJpB2hqgDgilEltsQywUGVHFP43qZ4TJisZXBzhIuHKSC194RcnHUoPOJzOhwFUt7p
 /vtKh65c+JKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:26:23 -0700
IronPort-SDR: n+usVYSN9bVDhASoq4dNnClcMH2wws3t8OfgUpnS/JqtLHe1YyYt/DkSowJupqC+8CnPqami8x
 Qte9Jz14rSWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239663876"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:26:23 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to userspace
Date:   Sun, 22 Mar 2020 05:32:02 -0700
Message-Id: <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

VFIO exposes IOMMU nesting translation (a.k.a dual stage translation)
capability to userspace. Thus applications like QEMU could support
vIOMMU with hardware's nesting translation capability for pass-through
devices. Before setting up nesting translation for pass-through devices,
QEMU and other applications need to learn the supported 1st-lvl/stage-1
translation structure format like page table format.

Take vSVA (virtual Shared Virtual Addressing) as an example, to support
vSVA for pass-through devices, QEMU setup nesting translation for pass-
through devices. The guest page table are configured to host as 1st-lvl/
stage-1 page table. Therefore, guest format should be compatible with
host side.

This patch reports the supported 1st-lvl/stage-1 page table format on the
current platform to userspace. QEMU and other alike applications should
use this format info when trying to setup IOMMU nesting translation on
host IOMMU.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 56 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  1 +
 2 files changed, 57 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9aa2a67..82a9e0b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2234,11 +2234,66 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_get_stage1_format(struct vfio_iommu *iommu,
+					 u32 *stage1_format)
+{
+	struct vfio_domain *domain;
+	u32 format = 0, tmp_format = 0;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	if (list_empty(&iommu->domain_list)) {
+		mutex_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		if (iommu_domain_get_attr(domain->domain,
+			DOMAIN_ATTR_PASID_FORMAT, &format)) {
+			ret = -EINVAL;
+			format = 0;
+			goto out_unlock;
+		}
+		/*
+		 * format is always non-zero (the first format is
+		 * IOMMU_PASID_FORMAT_INTEL_VTD which is 1). For
+		 * the reason of potential different backed IOMMU
+		 * formats, here we expect to have identical formats
+		 * in the domain list, no mixed formats support.
+		 * return -EINVAL to fail the attempt of setup
+		 * VFIO_TYPE1_NESTING_IOMMU if non-identical formats
+		 * are detected.
+		 */
+		if (tmp_format && tmp_format != format) {
+			ret = -EINVAL;
+			format = 0;
+			goto out_unlock;
+		}
+
+		tmp_format = format;
+	}
+	ret = 0;
+
+out_unlock:
+	if (format)
+		*stage1_format = format;
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
 					 struct vfio_info_cap *caps)
 {
 	struct vfio_info_cap_header *header;
 	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
+	u32 formats = 0;
+	int ret;
+
+	ret = vfio_iommu_get_stage1_format(iommu, &formats);
+	if (ret) {
+		pr_warn("Failed to get stage-1 format\n");
+		return ret;
+	}
 
 	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
 				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
@@ -2254,6 +2309,7 @@ static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
 		/* nesting iommu type supports PASID requests (alloc/free) */
 		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
 	}
+	nesting_cap->stage1_formats = formats;
 
 	return 0;
 }
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ed9881d..ebeaf3e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -763,6 +763,7 @@ struct vfio_iommu_type1_info_cap_nesting {
 	struct	vfio_info_cap_header header;
 #define VFIO_IOMMU_PASID_REQS	(1 << 0)
 	__u32	nesting_capabilities;
+	__u32	stage1_formats;
 };
 
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
-- 
2.7.4

