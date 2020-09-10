Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A884264495
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgIJKtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:49:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:21915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729663AbgIJKrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:47:41 -0400
IronPort-SDR: KehVBXhkYrGJd4FwDPek4qg/9PpEE9uL+ZF2m5UUyyggKrcSvo+R4vB+oHMI2/IFw5q+kBXBwa
 Sk3Kk4Dweccg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066294"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:35 -0700
IronPort-SDR: AJSAoAe8J/v4IYsTisio5eeg99esw7VnpbfAIX6Ns8DQro0L+nV+BqlMIhxKWm2LXBdcg4ZTqy
 dFUUNZVJQ2Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137222"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:35 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 15/16] iommu/vt-d: Only support nesting when nesting caps are consistent across iommu units
Date:   Thu, 10 Sep 2020 03:45:32 -0700
Message-Id: <1599734733-6431-16-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch makes change to only supports the case where all the physical iommu
units have the same CAP/ECAP MASKS for nested translation.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v6 - > v7:
*) added per comment from Eric.
   https://lore.kernel.org/kvm/7fe337fa-abbc-82be-c8e8-b9e2a6179b90@redhat.com/
---
 drivers/iommu/intel/iommu.c |  8 ++++++--
 include/linux/intel-iommu.h | 16 ++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 95740b9..38c6c9b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5675,12 +5675,16 @@ static inline bool iommu_pasid_support(void)
 static inline bool nested_mode_support(void)
 {
 	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
+	struct intel_iommu *iommu, *prev = NULL;
 	bool ret = true;
 
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
-		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap)) {
+		if (!prev)
+			prev = iommu;
+		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap) ||
+		    (VTD_CAP_MASK & (iommu->cap ^ prev->cap)) ||
+		    (VTD_ECAP_MASK & (iommu->ecap ^ prev->ecap))) {
 			ret = false;
 			break;
 		}
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index db7fc59..e7b7512 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -197,6 +197,22 @@
 #define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
 #define ecap_sc_support(e)	((e >> 7) & 0x1) /* Snooping Control */
 
+/* Nesting Support Capability Alignment */
+#define VTD_CAP_FL1GP		BIT_ULL(56)
+#define VTD_CAP_FL5LP		BIT_ULL(60)
+#define VTD_ECAP_PRS		BIT_ULL(29)
+#define VTD_ECAP_ERS		BIT_ULL(30)
+#define VTD_ECAP_SRS		BIT_ULL(31)
+#define VTD_ECAP_EAFS		BIT_ULL(34)
+#define VTD_ECAP_PASID		BIT_ULL(40)
+
+/* Only capabilities marked in below MASKs are reported */
+#define VTD_CAP_MASK		(VTD_CAP_FL1GP | VTD_CAP_FL5LP)
+
+#define VTD_ECAP_MASK		(VTD_ECAP_PRS | VTD_ECAP_ERS | \
+				 VTD_ECAP_SRS | VTD_ECAP_EAFS | \
+				 VTD_ECAP_PASID)
+
 /* Virtual command interface capability */
 #define vccap_pasid(v)		(((v) & DMA_VCS_PAS)) /* PASID allocation */
 
-- 
2.7.4

