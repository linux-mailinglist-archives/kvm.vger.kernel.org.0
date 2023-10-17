Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989F37CB924
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbjJQDVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjJQDVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDD7AB;
        Mon, 16 Oct 2023 20:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512876; x=1729048876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Z6jX+P7MCIOfyMGIgtsB1mRLw9bjRzEbzGK7rvIIsU=;
  b=QwV9BNYusIctareYmJltCA4SYVQu8MYlyVAEI521PSQ7G1WFKqWIz6uB
   XxkHdY+MpiGUz2Od/v9J9ApyuQXcbvl1zN3Sp+NbrR2opy84MwSwTkwgw
   Pcexz+Z7EY8+eweucGe6cSEst5tHcwcV8wY+pLerWaLNOih5zlKvIhPPy
   QleqkFJ8jHJY/Pqb/gGSXJWQoWCMpHSHBrxcV8jJCOC5qlSRBOX0Wq0z1
   whR5mh+H+y0/SUrBXO2UBO7CAb0JTF7OrvlvQNOzfGl6fT2nzip+H+Uvr
   h25aFc1KSkxKA9Iga8afuc/UfIgks+ExGyhLllAIRtU934ve3WhH+sulj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560795"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560795"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826269962"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826269962"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:13 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 03/12] iommu/vt-d: Retire intel_svm_bind_mm()
Date:   Tue, 17 Oct 2023 11:20:35 +0800
Message-Id: <20231017032045.114868-4-tina.zhang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231017032045.114868-1-tina.zhang@intel.com>
References: <20231017032045.114868-1-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor intel_svm_set_dev_pasid() by moving the logic from
intel_svm_bind_mm() into intel_svm_set_dev_pasid() and retire
intel_svm_bind_mm().

No functional change intended.

The motivation is to let intel_iommu_set_dev_pasid() serve for both sva
domain and default domain set_dev_pasid operation, instead of duplicating
code for them. In latter patches, we will first do some refactoring to
intel_svm_set_dev_pasid(), and then extend intel_iommu_set_dev_pasid()
to support sva domain. After that, intel_svm_set_dev_pasid() will call
intel_iommu_set_dev_pasid() for set_dev_pasid purpose.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/svm.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index f9b1f13bd068..03406395ac5b 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -289,10 +289,11 @@ static int pasid_to_svm_sdev(struct device *dev, unsigned int pasid,
 	return 0;
 }
 
-static int intel_svm_bind_mm(struct intel_iommu *iommu, struct device *dev,
-			     struct iommu_domain *domain, ioasid_t pasid)
+static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
+				   struct device *dev, ioasid_t pasid)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct intel_iommu *iommu = info->iommu;
 	struct mm_struct *mm = domain->mm;
 	struct intel_svm_dev *sdev;
 	struct intel_svm *svm;
@@ -784,15 +785,6 @@ int intel_svm_page_response(struct device *dev,
 	return ret;
 }
 
-static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t pasid)
-{
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	struct intel_iommu *iommu = info->iommu;
-
-	return intel_svm_bind_mm(iommu, dev, domain, pasid);
-}
-
 static void intel_svm_domain_free(struct iommu_domain *domain)
 {
 	kfree(to_dmar_domain(domain));
-- 
2.39.3

