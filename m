Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED92F14CA44
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA2MGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:06:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:59025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgA2MGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:06:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:06:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222433148"
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
Subject: [RFC v3 5/8] vfio/type1: Report 1st-level/stage-1 page table format to userspace
Date:   Wed, 29 Jan 2020 04:11:49 -0800
Message-Id: <1580299912-86084-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
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
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 79 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  7 ++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1cf75f5..e0bbcfb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2243,6 +2243,81 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_get_pasid_format(struct vfio_iommu *iommu,
+					u32 *pasid_format)
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
+		 * in the domain list, no miexed formats support.
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
+		*pasid_format = format;
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
+					 struct vfio_info_cap *caps)
+{
+	struct vfio_info_cap_header *header;
+	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
+	u32 format = 0;
+	int ret;
+
+	ret = vfio_iommu_get_pasid_format(iommu, &format);
+	if (ret) {
+		pr_warn("Failed to get domain format\n");
+		return ret;
+	}
+
+	header = vfio_info_cap_add(caps, sizeof(*nesting_cap) + sizeof(format),
+				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
+	if (IS_ERR(header))
+		return PTR_ERR(header);
+
+	nesting_cap = container_of(header,
+				struct vfio_iommu_type1_info_cap_nesting,
+				header);
+
+	nesting_cap->pasid_format = format;
+
+	return 0;
+}
+
 static int vfio_iommu_type1_set_pasid_quota(struct vfio_iommu *iommu,
 					    u32 quota)
 {
@@ -2313,6 +2388,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (ret)
 			return ret;
 
+		ret = vfio_iommu_info_add_nesting_cap(iommu, &caps);
+		if (ret)
+			return ret;
+
 		if (caps.size) {
 			info.flags |= VFIO_IOMMU_INFO_CAPS;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 62113be..633c07f 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -748,6 +748,13 @@ struct vfio_iommu_type1_info_cap_iova_range {
 	struct	vfio_iova_range iova_ranges[];
 };
 
+#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  2
+
+struct vfio_iommu_type1_info_cap_nesting {
+	struct	vfio_info_cap_header header;
+	__u32	pasid_format;
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
2.7.4

