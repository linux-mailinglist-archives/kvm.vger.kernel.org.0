Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0850914CA4E
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgA2MHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:07:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:59025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgA2MGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:06:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:06:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222433145"
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
Subject: [RFC v3 4/8] vfio/type1: Add VFIO_NESTING_GET_IOMMU_UAPI_VERSION
Date:   Wed, 29 Jan 2020 04:11:48 -0800
Message-Id: <1580299912-86084-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

In Linux Kernel, the IOMMU nesting translation (a.k.a. IOMMU dual stage
translation capability) is abstracted in uapi/iommu.h, in which the uAPIs
like bind_gpasid/iommu_cache_invalidate/fault_report/pgreq_resp are defined.

VFIO_TYPE1_NESTING_IOMMU stands for the vfio iommu type which is backed by
IOMMU nesting translation capability. VFIO exposes the nesting capability
to userspace and also exposes uAPIs (will be added in later patches) to user
space for setting up nesting translation from userspace. Thus applications
like QEMU could support vIOMMU for pass-through devices with IOMMU nesting
translation capability.

As VFIO expose the nesting IOMMU programming to userspace, it also needs to
provide an API for the uapi/iommu.h version check to ensure compatibility.
This patch reports the iommu uapi version to userspace. Applications could
use this API to do version check before further using the nesting uAPIs.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.c       |  3 +++
 include/uapi/linux/vfio.h | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 425d60a..9087ad4 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1170,6 +1170,9 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 	case VFIO_GET_API_VERSION:
 		ret = VFIO_API_VERSION;
 		break;
+	case VFIO_NESTING_GET_IOMMU_UAPI_VERSION:
+		ret = iommu_get_uapi_version();
+		break;
 	case VFIO_CHECK_EXTENSION:
 		ret = vfio_ioctl_check_extension(container, arg);
 		break;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d4bf415..62113be 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -857,6 +857,16 @@ struct vfio_iommu_type1_pasid_quota {
  */
 #define VFIO_IOMMU_SET_PASID_QUOTA	_IO(VFIO_TYPE, VFIO_BASE + 23)
 
+/**
+ * VFIO_NESTING_GET_IOMMU_UAPI_VERSION - _IO(VFIO_TYPE, VFIO_BASE + 24)
+ *
+ * Report the version of the IOMMU UAPI when dual stage IOMMU is supported.
+ * In VFIO, it is needed for VFIO_TYPE1_NESTING_IOMMU.
+ * Availability: Always.
+ * Return: IOMMU UAPI version
+ */
+#define VFIO_NESTING_GET_IOMMU_UAPI_VERSION	_IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

