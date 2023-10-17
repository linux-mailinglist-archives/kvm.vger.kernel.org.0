Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111927CB933
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbjJQDW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbjJQDWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:22:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CEAD5E;
        Mon, 16 Oct 2023 20:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512899; x=1729048899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rIP4lGeh4l++76KLDIftiMSwqqH2jZrP09tAxFYTrFc=;
  b=crPElB6nP4LYtoSQdKRUeQg6WyDq65K+8nc2sfN7skGa6au6SQmibSmh
   OA7Bfp1JacUr6Nn1o7RfMt3qmlsOD6ulflrioRUTCu2wocU/gz5Vntc8v
   2C3ISssR15vGDzSUVYaz2p1NVUSjaOrBSkXRwR65QfFH3nrr5gGiUFz49
   MHvX+NX0cIVmvkCUNruuxCvm+nncF9xZpXK3e1NcNnsuUttA4QIgXSkvs
   2nkBmjaRW3lkqoHVqpwhE5Uyjt1uVUDcmKgWf0BHzUnv3BrOdegvhk38u
   8O4XpRjN8P+PoYmmB98KKMNWg/840HCFn86e8oVQ0qLcZ5cgkIgX8BqHD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560895"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560895"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270102"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270102"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:35 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 11/12] iommu/vt-d: Use intel_iommu_set_dev_pasid() for sva domain
Date:   Tue, 17 Oct 2023 11:20:44 +0800
Message-Id: <20231017032045.114868-13-tina.zhang@intel.com>
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

Let intel_svm_set_dev_pasid() use intel_iommu_set_dev_pasid() for
set_dev_pasid operation.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/svm.c | 44 +++++++--------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 7f98c8acd04f..c9a703935908 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -231,13 +231,9 @@ static const struct mmu_notifier_ops intel_mmuops = {
 static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t pasid)
 {
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	struct intel_iommu *iommu = info->iommu;
 	struct mm_struct *mm = domain->mm;
-	struct dev_pasid_info *dev_pasid;
-	unsigned long sflags;
-	int ret = 0;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	int ret;
 
 	/*
 	 * The sva domain can be shared among multiple devices. Make sure
@@ -250,37 +246,11 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 			return ret;
 	}
 
-	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
-	if (!dev_pasid) {
-		ret = -ENOMEM;
-		goto out_unregister;
-	}
-
-	dev_pasid->dev = dev;
-	dev_pasid->sid = PCI_DEVID(info->bus, info->devfn);
-	if (info->ats_enabled) {
-		dev_pasid->qdep = info->ats_qdep;
-		if (dev_pasid->qdep >= QI_DEV_EIOTLB_MAX_INVS)
-			dev_pasid->qdep = 0;
+	ret = intel_iommu_set_dev_pasid(domain, dev, pasid);
+	if (ret) {
+		if (list_empty(&dmar_domain->dev_pasids))
+			mmu_notifier_unregister(&domain->notifier, mm);
 	}
-
-	/* Setup the pasid table: */
-	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
-	ret = intel_pasid_setup_first_level(iommu, dev, mm->pgd, pasid,
-					    FLPT_DEFAULT_DID, sflags);
-	if (ret)
-		goto out_free_dev_pasid;
-
-	list_add_rcu(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
-
-	return 0;
-
-out_free_dev_pasid:
-	kfree(dev_pasid);
-out_unregister:
-	if (list_empty(&dmar_domain->dev_pasids))
-		mmu_notifier_unregister(&domain->notifier, mm);
-
 	return ret;
 }
 
@@ -696,6 +666,8 @@ struct iommu_domain *intel_svm_domain_alloc(void)
 		return NULL;
 	domain->domain.ops = &intel_svm_domain_ops;
 	INIT_LIST_HEAD(&domain->dev_pasids);
+	spin_lock_init(&domain->lock);
+	xa_init(&domain->iommu_array);
 
 	return &domain->domain;
 }
-- 
2.39.3

