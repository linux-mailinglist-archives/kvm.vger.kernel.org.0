Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D993218E8A8
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCVM0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:26:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:51561 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgCVM0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:26:25 -0400
IronPort-SDR: QMsZBmxgk+66lUUKEVZIhxC6W1UIAG0foY5xkUlxHVGh1DSyoPo0kiiEO7DIIDxGBTMRZAfTEI
 zHQvpJ1/bX7Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:26:23 -0700
IronPort-SDR: oDhKabdEgKGFhpjlxoqmAbyif2PuoUrVoTpudwxrGw3kcsSiW5nnR6w8cuyypgFXvymAR4fuLf
 dUBxviObXjeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239663874"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:26:23 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: [PATCH v1 4/8] vfio: Check nesting iommu uAPI version
Date:   Sun, 22 Mar 2020 05:32:01 -0700
Message-Id: <1584880325-10561-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

In Linux Kernel, the IOMMU nesting translation (a.k.a dual stage address
translation) capability is abstracted in uapi/iommu.h, in which the uAPIs
like bind_gpasid/iommu_cache_invalidate/fault_report/pgreq_resp are defined.

VFIO_TYPE1_NESTING_IOMMU stands for the vfio iommu type which is backed by
hardware IOMMU w/ dual stage translation capability. For such vfio iommu
type, userspace is able to setup dual stage DMA translation in host side
via VFIO's ABI. However, such VFIO ABIs rely on the uAPIs defined in uapi/
iommu.h. So VFIO needs to provide an API to userspace for the uapi/iommu.h
version check to ensure the iommu uAPI compatibility.

This patch reports the iommu uAPI version to userspace in VFIO_CHECK_EXTENSION
IOCTL. Applications could do version check before further setup dual stage
translation in host IOMMU.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 include/uapi/linux/vfio.h       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ddd1ffe..9aa2a67 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2274,6 +2274,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			if (!iommu)
 				return 0;
 			return vfio_domains_have_iommu_cache(iommu);
+		case VFIO_NESTING_IOMMU_UAPI:
+			return iommu_get_uapi_version();
 		default:
 			return 0;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8837219..ed9881d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -47,6 +47,15 @@
 #define VFIO_NOIOMMU_IOMMU		8
 
 /*
+ * Hardware IOMMUs with two-stage translation capability give userspace
+ * the ownership of stage-1 translation structures (e.g. page tables).
+ * VFIO exposes the two-stage IOMMU programming capability to userspace
+ * based on the IOMMU UAPIs. Therefore user of VFIO_TYPE1_NESTING should
+ * check the IOMMU UAPI version compatibility.
+ */
+#define VFIO_NESTING_IOMMU_UAPI		9
+
+/*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
  * kernel and userspace.  We therefore use the _IO() macro for these
-- 
2.7.4

