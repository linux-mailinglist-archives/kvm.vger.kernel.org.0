Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5D1259E6
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 04:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLSDRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 22:17:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:29386 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfLSDRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 22:17:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 19:17:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222160411"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 19:17:38 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 3/7] iommu/vt-d: Add PASID_FLAG_FL5LP for first-level pasid setup
Date:   Thu, 19 Dec 2019 11:16:30 +0800
Message-Id: <20191219031634.15168-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219031634.15168-1-baolu.lu@linux.intel.com>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current intel_pasid_setup_first_level() use 5-level paging for
first level translation if CPUs use 5-level paging mode too.
This makes sense for SVA usages since the page table is shared
between CPUs and IOMMUs. But it makes no sense if we only want
to use first level for IOVA translation. Add PASID_FLAG_FL5LP
bit in the flags which indicates whether the 5-level paging
mode should be used.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-pasid.c | 7 ++-----
 drivers/iommu/intel-pasid.h | 6 ++++++
 drivers/iommu/intel-svm.c   | 8 ++++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel-pasid.c b/drivers/iommu/intel-pasid.c
index 3cb569e76642..22b30f10b396 100644
--- a/drivers/iommu/intel-pasid.c
+++ b/drivers/iommu/intel-pasid.c
@@ -477,18 +477,15 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		pasid_set_sre(pte);
 	}
 
-#ifdef CONFIG_X86
-	/* Both CPU and IOMMU paging mode need to match */
-	if (cpu_feature_enabled(X86_FEATURE_LA57)) {
+	if (flags & PASID_FLAG_FL5LP) {
 		if (cap_5lp_support(iommu->cap)) {
 			pasid_set_flpm(pte, 1);
 		} else {
-			pr_err("VT-d has no 5-level paging support for CPU\n");
+			pr_err("No 5-level paging support for first-level\n");
 			pasid_clear_entry(pte);
 			return -EINVAL;
 		}
 	}
-#endif /* CONFIG_X86 */
 
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
diff --git a/drivers/iommu/intel-pasid.h b/drivers/iommu/intel-pasid.h
index fc8cd8f17de1..92de6df24ccb 100644
--- a/drivers/iommu/intel-pasid.h
+++ b/drivers/iommu/intel-pasid.h
@@ -37,6 +37,12 @@
  */
 #define PASID_FLAG_SUPERVISOR_MODE	BIT(0)
 
+/*
+ * The PASID_FLAG_FL5LP flag Indicates using 5-level paging for first-
+ * level translation, otherwise, 4-level paging will be used.
+ */
+#define PASID_FLAG_FL5LP		BIT(1)
+
 struct pasid_dir_entry {
 	u64 val;
 };
diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index 04023033b79f..d7f2a5358900 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -364,7 +364,9 @@ int intel_svm_bind_mm(struct device *dev, int *pasid, int flags, struct svm_dev_
 		ret = intel_pasid_setup_first_level(iommu, dev,
 				mm ? mm->pgd : init_mm.pgd,
 				svm->pasid, FLPT_DEFAULT_DID,
-				mm ? 0 : PASID_FLAG_SUPERVISOR_MODE);
+				(mm ? 0 : PASID_FLAG_SUPERVISOR_MODE) |
+				(cpu_feature_enabled(X86_FEATURE_LA57) ?
+				 PASID_FLAG_FL5LP : 0));
 		spin_unlock(&iommu->lock);
 		if (ret) {
 			if (mm)
@@ -385,7 +387,9 @@ int intel_svm_bind_mm(struct device *dev, int *pasid, int flags, struct svm_dev_
 		ret = intel_pasid_setup_first_level(iommu, dev,
 						mm ? mm->pgd : init_mm.pgd,
 						svm->pasid, FLPT_DEFAULT_DID,
-						mm ? 0 : PASID_FLAG_SUPERVISOR_MODE);
+						(mm ? 0 : PASID_FLAG_SUPERVISOR_MODE) |
+						(cpu_feature_enabled(X86_FEATURE_LA57) ?
+						PASID_FLAG_FL5LP : 0));
 		spin_unlock(&iommu->lock);
 		if (ret) {
 			kfree(sdev);
-- 
2.17.1

