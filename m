Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE717CB92F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbjJQDWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbjJQDVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749F318C;
        Mon, 16 Oct 2023 20:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512889; x=1729048889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2TfOucGeiLB5cqiCoJ8ekSLHAIzfu3AryvC3L1C9fRo=;
  b=HukQHx5RlWUq80QQC+z8RrHAa7LS+xFiL0uaxkV6ag4aW6eJyUJaPToX
   TgzWbjCJ/V3Iq1/Og78FuxGirK5w+29DRoqI6dD8M98BJSXyk2rPeojNR
   X8ThFKkX5SHW6V0Y97pOVEl/xMJzFl4UMchwoSDuxeDSX62TnEmSMebDI
   jyWDOypSCqGBLwxinVzwKWCvcEK54PwhoqcyaNVg6V3R6UwTme00gWs9K
   Dpw2DGXCCDXmRi5m1i9vdvzqVi+1+3pmqtqLFsTlLiXbPVHjxXWRz4z0i
   NN9dCJaV0CLBgQRPcq+Yic1L1i4Pj7z8Rs7qJQ0VbFB8MjGq5aA7y+NqW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560864"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560864"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270065"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270065"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:25 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 07/12] iommu/vt-d: Retire struct intel_svm
Date:   Tue, 17 Oct 2023 11:20:40 +0800
Message-Id: <20231017032045.114868-9-tina.zhang@intel.com>
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

The sva domain can be shared among devices behind different IOMMUs and
therefore sva domain should centrally keep the info needed for shared
virtual memory to avoid duplicating code.

Chain the attached devices to sva domains's dev_pasids list, and retire
struct intel_svm.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/iommu.h |   7 --
 drivers/iommu/intel/svm.c   | 152 ++++++++++--------------------------
 2 files changed, 42 insertions(+), 117 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index bd7210980fb2..a9e9301b2713 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -860,13 +860,6 @@ int intel_svm_page_response(struct device *dev, struct iommu_fault_event *evt,
 struct iommu_domain *intel_svm_domain_alloc(void);
 void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
 void intel_drain_pasid_prq(struct device *dev, u32 pasid);
-
-struct intel_svm {
-	struct mmu_notifier notifier;
-	struct mm_struct *mm;
-	u32 pasid;
-	struct list_head devs;
-};
 #else
 static inline void intel_svm_check(struct intel_iommu *iommu) {}
 static inline void intel_drain_pasid_prq(struct device *dev, u32 pasid) {}
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index e0373586811e..fd61fbf7593a 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -27,30 +27,13 @@
 
 static irqreturn_t prq_event_thread(int irq, void *d);
 
-static DEFINE_XARRAY_ALLOC(pasid_private_array);
-static int pasid_private_add(ioasid_t pasid, void *priv)
-{
-	return xa_alloc(&pasid_private_array, &pasid, priv,
-			XA_LIMIT(pasid, pasid), GFP_ATOMIC);
-}
-
-static void pasid_private_remove(ioasid_t pasid)
-{
-	xa_erase(&pasid_private_array, pasid);
-}
-
-static void *pasid_private_find(ioasid_t pasid)
-{
-	return xa_load(&pasid_private_array, pasid);
-}
-
 static struct dev_pasid_info *
-svm_lookup_dev_pasid_info_by_dev(struct intel_svm *svm, struct device *dev)
+domain_lookup_dev_pasid_info_by_dev(struct dmar_domain *domain, struct device *dev)
 {
 	struct dev_pasid_info *dev_pasid = NULL, *t;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(t, &svm->devs, link_domain) {
+	list_for_each_entry_rcu(t, &domain->dev_pasids, link_domain) {
 		if (t->dev == dev) {
 			dev_pasid = t;
 			break;
@@ -169,28 +152,29 @@ void intel_svm_check(struct intel_iommu *iommu)
 	iommu->flags |= VTD_FLAG_SVM_CAPABLE;
 }
 
-static void __flush_svm_range_dev(struct intel_svm *svm,
+static void __flush_svm_range_dev(struct dmar_domain *domain,
 				  struct dev_pasid_info *dev_pasid,
 				  unsigned long address,
 				  unsigned long pages, int ih)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev_pasid->dev);
 	struct intel_iommu *iommu = dev_to_intel_iommu(dev_pasid->dev);
+	u32 pasid = mm_get_enqcmd_pasid(domain->domain.mm);
 
 	if (WARN_ON(!pages))
 		return;
 
-	qi_flush_piotlb(iommu, FLPT_DEFAULT_DID, svm->pasid, address, pages, ih);
+	qi_flush_piotlb(iommu, FLPT_DEFAULT_DID, pasid, address, pages, ih);
 	if (info->ats_enabled) {
 		qi_flush_dev_iotlb_pasid(iommu, dev_pasid->sid, info->pfsid,
-					 svm->pasid, dev_pasid->qdep, address,
+					 pasid, dev_pasid->qdep, address,
 					 order_base_2(pages));
 		quirk_extra_dev_tlb_flush(info, address, order_base_2(pages),
-					  svm->pasid, dev_pasid->qdep);
+					  pasid, dev_pasid->qdep);
 	}
 }
 
-static void intel_flush_svm_range_dev(struct intel_svm *svm,
+static void intel_flush_svm_range_dev(struct dmar_domain *domain,
 				      struct dev_pasid_info *dev_pasid,
 				      unsigned long address,
 				      unsigned long pages, int ih)
@@ -201,19 +185,19 @@ static void intel_flush_svm_range_dev(struct intel_svm *svm,
 	unsigned long end = ALIGN(address + (pages << VTD_PAGE_SHIFT), align);
 
 	while (start < end) {
-		__flush_svm_range_dev(svm, dev_pasid, start, align >> VTD_PAGE_SHIFT, ih);
+		__flush_svm_range_dev(domain, dev_pasid, start, align >> VTD_PAGE_SHIFT, ih);
 		start += align;
 	}
 }
 
-static void intel_flush_svm_range(struct intel_svm *svm, unsigned long address,
+static void intel_flush_svm_range(struct dmar_domain *domain, unsigned long address,
 				unsigned long pages, int ih)
 {
 	struct dev_pasid_info *dev_pasid;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(dev_pasid, &svm->devs, link_domain)
-		intel_flush_svm_range_dev(svm, dev_pasid, address, pages, ih);
+	list_for_each_entry_rcu(dev_pasid, &domain->dev_pasids, link_domain)
+		intel_flush_svm_range_dev(domain, dev_pasid, address, pages, ih);
 	rcu_read_unlock();
 }
 
@@ -222,15 +206,15 @@ static void intel_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long start, unsigned long end)
 {
-	struct intel_svm *svm = container_of(mn, struct intel_svm, notifier);
+	struct iommu_domain *domain = container_of(mn, struct iommu_domain, notifier);
 
-	intel_flush_svm_range(svm, start,
+	intel_flush_svm_range(to_dmar_domain(domain), start,
 			      (end - start + PAGE_SIZE - 1) >> VTD_PAGE_SHIFT, 0);
 }
 
 static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
-	struct intel_svm *svm = container_of(mn, struct intel_svm, notifier);
+	struct iommu_domain *domain = container_of(mn, struct iommu_domain, notifier);
 	struct dev_pasid_info *dev_pasid;
 	struct intel_iommu *iommu;
 
@@ -247,10 +231,10 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * *has* to handle gracefully without affecting other processes.
 	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(dev_pasid, &svm->devs, link_domain) {
+	list_for_each_entry_rcu(dev_pasid, &to_dmar_domain(domain)->dev_pasids, link_domain) {
 		iommu = dev_to_intel_iommu(dev_pasid->dev);
 		intel_pasid_tear_down_entry(iommu, dev_pasid->dev,
-					    svm->pasid, true);
+					    mm_get_enqcmd_pasid(domain->mm), true);
 	}
 	rcu_read_unlock();
 
@@ -261,78 +245,32 @@ static const struct mmu_notifier_ops intel_mmuops = {
 	.arch_invalidate_secondary_tlbs = intel_arch_invalidate_secondary_tlbs,
 };
 
-static int pasid_to_dev_pasid_info(struct device *dev, unsigned int pasid,
-			     struct intel_svm **rsvm,
-			     struct dev_pasid_info **rsdev_pasid_info)
-{
-	struct dev_pasid_info *dev_pasid = NULL;
-	struct intel_svm *svm;
-
-	if (pasid == IOMMU_PASID_INVALID || pasid >= PASID_MAX)
-		return -EINVAL;
-
-	svm = pasid_private_find(pasid);
-	if (IS_ERR(svm))
-		return PTR_ERR(svm);
-
-	if (!svm)
-		goto out;
-
-	/*
-	 * If we found svm for the PASID, there must be at least one device
-	 * bond.
-	 */
-	if (WARN_ON(list_empty(&svm->devs)))
-		return -EINVAL;
-	dev_pasid = svm_lookup_dev_pasid_info_by_dev(svm, dev);
-
-out:
-	*rsvm = svm;
-	*rsdev_pasid_info = dev_pasid;
-
-	return 0;
-}
-
 static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t pasid)
 {
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
 	struct mm_struct *mm = domain->mm;
 	struct dev_pasid_info *dev_pasid;
-	struct intel_svm *svm;
 	unsigned long sflags;
 	int ret = 0;
 
-	svm = pasid_private_find(pasid);
-	if (!svm) {
-		svm = kzalloc(sizeof(*svm), GFP_KERNEL);
-		if (!svm)
-			return -ENOMEM;
-
-		svm->pasid = pasid;
-		svm->mm = mm;
-		INIT_LIST_HEAD_RCU(&svm->devs);
-
-		svm->notifier.ops = &intel_mmuops;
-		ret = mmu_notifier_register(&svm->notifier, mm);
-		if (ret) {
-			kfree(svm);
-			return ret;
-		}
-
-		ret = pasid_private_add(svm->pasid, svm);
-		if (ret) {
-			mmu_notifier_unregister(&svm->notifier, mm);
-			kfree(svm);
+	/*
+	 * The sva domain can be shared among multiple devices. Make sure
+	 * to add the notifier only once to a sva domain.
+	 */
+	if (domain->notifier.ops != &intel_mmuops) {
+		domain->notifier.ops = &intel_mmuops;
+		ret = mmu_notifier_register(&domain->notifier, mm);
+		if (ret)
 			return ret;
-		}
 	}
 
 	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
 	if (!dev_pasid) {
 		ret = -ENOMEM;
-		goto free_svm;
+		goto out_unregister;
 	}
 
 	dev_pasid->dev = dev;
@@ -348,46 +286,39 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 	ret = intel_pasid_setup_first_level(iommu, dev, mm->pgd, pasid,
 					    FLPT_DEFAULT_DID, sflags);
 	if (ret)
-		goto free_dev_pasid;
+		goto out_free_dev_pasid;
 
-	list_add_rcu(&dev_pasid->link_domain, &svm->devs);
+	list_add_rcu(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
 
 	return 0;
 
-free_dev_pasid:
+out_free_dev_pasid:
 	kfree(dev_pasid);
-free_svm:
-	if (list_empty(&svm->devs)) {
-		mmu_notifier_unregister(&svm->notifier, mm);
-		pasid_private_remove(pasid);
-		kfree(svm);
-	}
+out_unregister:
+	if (list_empty(&dmar_domain->dev_pasids))
+		mmu_notifier_unregister(&domain->notifier, mm);
 
 	return ret;
 }
 
 void intel_svm_remove_dev_pasid(struct device *dev, u32 pasid)
 {
+	struct iommu_domain *domain;
 	struct dev_pasid_info *dev_pasid;
-	struct intel_iommu *iommu;
-	struct intel_svm *svm;
-
-	iommu = device_to_iommu(dev, NULL, NULL);
-	if (!iommu)
-		return;
 
-	if (pasid_to_dev_pasid_info(dev, pasid, &svm, &dev_pasid))
+	domain = iommu_get_domain_for_dev_pasid(dev, pasid,
+						IOMMU_DOMAIN_SVA);
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(domain)))
 		return;
 
+	dev_pasid = domain_lookup_dev_pasid_info_by_dev(to_dmar_domain(domain), dev);
 	if (dev_pasid) {
 		list_del_rcu(&dev_pasid->link_domain);
 		kfree_rcu(dev_pasid, rcu);
 
-		if (list_empty(&svm->devs)) {
-			if (svm->notifier.ops)
-				mmu_notifier_unregister(&svm->notifier, svm->mm);
-			pasid_private_remove(svm->pasid);
-			kfree(svm);
+		if (list_empty(&to_dmar_domain(domain)->dev_pasids)) {
+			if (domain->notifier.ops)
+				mmu_notifier_unregister(&domain->notifier, domain->mm);
 		}
 	}
 }
@@ -803,6 +734,7 @@ struct iommu_domain *intel_svm_domain_alloc(void)
 	if (!domain)
 		return NULL;
 	domain->domain.ops = &intel_svm_domain_ops;
+	INIT_LIST_HEAD(&domain->dev_pasids);
 
 	return &domain->domain;
 }
-- 
2.39.3

