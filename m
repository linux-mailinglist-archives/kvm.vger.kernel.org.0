Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4E18E8AA
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCVM0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:26:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:51561 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgCVM0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:26:24 -0400
IronPort-SDR: AJqd8HXzqQYzDmS9d0gekE7+goANJwg7Q9x5c2SnxcwiF1lKEUn1SFgX/mR0OzCtGx+nh4ZeUM
 ZTg4Ut9SAO6A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:26:23 -0700
IronPort-SDR: ODU0KUNuNzn/OqGhgj2jPcOOpyU0+gOjRODvSadyb95UTsobMtrBs5/P+2WtfjMzTUOx/yvOxI
 jHywM3xIEA2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239663867"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:26:23 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter for quota tuning
Date:   Sun, 22 Mar 2020 05:31:59 -0700
Message-Id: <1584880325-10561-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

This patch adds a module option to make the PASID quota tunable by
administrator.

TODO: needs to think more on how to  make the tuning to be per-process.

Previous discussions:
https://patchwork.kernel.org/patch/11209429/

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.c             | 8 +++++++-
 drivers/vfio/vfio_iommu_type1.c | 7 ++++++-
 include/linux/vfio.h            | 3 ++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index d13b483..020a792 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2217,13 +2217,19 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
 
-int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
+int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int quota, int min, int max)
 {
 	ioasid_t pasid;
 	int ret = -ENOSPC;
 
 	mutex_lock(&vmm->pasid_lock);
 
+	/* update quota as it is tunable by admin */
+	if (vmm->pasid_quota != quota) {
+		vmm->pasid_quota = quota;
+		ioasid_adjust_set(vmm->ioasid_sid, quota);
+	}
+
 	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
 	if (pasid == INVALID_IOASID) {
 		ret = -ENOSPC;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 331ceee..e40afc0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -60,6 +60,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
 MODULE_PARM_DESC(dma_entry_limit,
 		 "Maximum number of user DMA mappings per container (65535).");
 
+static int pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
+module_param_named(pasid_quota, pasid_quota, uint, 0644);
+MODULE_PARM_DESC(pasid_quota,
+		 "Quota of user owned PASIDs per vfio-based application (1000).");
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct list_head	iova_list;
@@ -2200,7 +2205,7 @@ static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 	if (vmm)
-		ret = vfio_mm_pasid_alloc(vmm, min, max);
+		ret = vfio_mm_pasid_alloc(vmm, pasid_quota, min, max);
 	else
 		ret = -EINVAL;
 out_unlock:
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 75f9f7f1..af2ef78 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -106,7 +106,8 @@ struct vfio_mm {
 
 extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
 extern void vfio_mm_put(struct vfio_mm *vmm);
-extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max);
+extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm,
+				int quota, int min, int max);
 extern int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid);
 
 /*
-- 
2.7.4

