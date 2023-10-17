Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39727CB929
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbjJQDVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbjJQDVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1042112;
        Mon, 16 Oct 2023 20:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512883; x=1729048883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pytNRtnuhCH6Oa/tr99cc7MVoCYtmt+k5VsRuaFB52A=;
  b=Q0J8fCncM/OPQGpEWwKZzuTE4i/F7UbIdGrEBM2WDZBy6gZEhTe7nNaJ
   Wc2DqcfUnrAia/o0Ja8cF6ahwz0moibd6pALAFKxaVhEkx0imLWyHrV1/
   +vQ0MwW1rc2heiNQK8SaR+ShSrxVqY4REBaBNn5oK5Wd1PdWfJhSYbf32
   xFC5XmnQ9IMvuQ+42Z9j/oK+WoG7KQihjeiLwV3icLVyC8k48HG+RHRea
   w831gtzjwefVslVK91WCEz2UTSYJiLFbZ/kmIJf0CqTZz9tg57pFM2mi4
   +x0zmSGKhkwnuE8Ob045iOCn1iQUD7/aPV3JUVtxcMUD9Rr9zSUyxuual
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560840"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560840"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270051"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270051"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:20 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 05/12] iommu/vt-d: Retire struct intel_svm_dev
Date:   Tue, 17 Oct 2023 11:20:38 +0800
Message-Id: <20231017032045.114868-7-tina.zhang@intel.com>
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

The struct dev_pasid_info is used by IOMMU domain to keep pasid info of
attached device. For sva domain, there is another structure which keeps
info of attached device, named intel_svm_dev. Instead of using two structs
to keep attached device info separately, sva domain should use struct
dev_pasid to centralize info of attach device. To achieve this, rcu/sid/
qdep fields are moved from struct intel_svm_dev into struct
dev_pasid_info and then sva domain switches to use dev_pasid_info to
keep attached device info. In this way, struct intel_svm_dev gets retired.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/iommu.h | 11 +----
 drivers/iommu/intel/svm.c   | 94 ++++++++++++++++++-------------------
 2 files changed, 49 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 1e972e7edeca..bd7210980fb2 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -722,6 +722,8 @@ struct dev_pasid_info {
 	struct list_head link_domain;	/* link to domain siblings */
 	struct device *dev;
 	ioasid_t pasid;
+	struct rcu_head rcu;
+	u16 sid, qdep;
 };
 
 static inline void __iommu_flush_cache(
@@ -859,15 +861,6 @@ struct iommu_domain *intel_svm_domain_alloc(void);
 void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
 void intel_drain_pasid_prq(struct device *dev, u32 pasid);
 
-struct intel_svm_dev {
-	struct list_head list;
-	struct rcu_head rcu;
-	struct device *dev;
-	struct intel_iommu *iommu;
-	u16 did;
-	u16 sid, qdep;
-};
-
 struct intel_svm {
 	struct mmu_notifier notifier;
 	struct mm_struct *mm;
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 03406395ac5b..e0373586811e 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -44,21 +44,21 @@ static void *pasid_private_find(ioasid_t pasid)
 	return xa_load(&pasid_private_array, pasid);
 }
 
-static struct intel_svm_dev *
-svm_lookup_device_by_dev(struct intel_svm *svm, struct device *dev)
+static struct dev_pasid_info *
+svm_lookup_dev_pasid_info_by_dev(struct intel_svm *svm, struct device *dev)
 {
-	struct intel_svm_dev *sdev = NULL, *t;
+	struct dev_pasid_info *dev_pasid = NULL, *t;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(t, &svm->devs, list) {
+	list_for_each_entry_rcu(t, &svm->devs, link_domain) {
 		if (t->dev == dev) {
-			sdev = t;
+			dev_pasid = t;
 			break;
 		}
 	}
 	rcu_read_unlock();
 
-	return sdev;
+	return dev_pasid;
 }
 
 int intel_svm_enable_prq(struct intel_iommu *iommu)
@@ -170,27 +170,28 @@ void intel_svm_check(struct intel_iommu *iommu)
 }
 
 static void __flush_svm_range_dev(struct intel_svm *svm,
-				  struct intel_svm_dev *sdev,
+				  struct dev_pasid_info *dev_pasid,
 				  unsigned long address,
 				  unsigned long pages, int ih)
 {
-	struct device_domain_info *info = dev_iommu_priv_get(sdev->dev);
+	struct device_domain_info *info = dev_iommu_priv_get(dev_pasid->dev);
+	struct intel_iommu *iommu = dev_to_intel_iommu(dev_pasid->dev);
 
 	if (WARN_ON(!pages))
 		return;
 
-	qi_flush_piotlb(sdev->iommu, sdev->did, svm->pasid, address, pages, ih);
+	qi_flush_piotlb(iommu, FLPT_DEFAULT_DID, svm->pasid, address, pages, ih);
 	if (info->ats_enabled) {
-		qi_flush_dev_iotlb_pasid(sdev->iommu, sdev->sid, info->pfsid,
-					 svm->pasid, sdev->qdep, address,
+		qi_flush_dev_iotlb_pasid(iommu, dev_pasid->sid, info->pfsid,
+					 svm->pasid, dev_pasid->qdep, address,
 					 order_base_2(pages));
 		quirk_extra_dev_tlb_flush(info, address, order_base_2(pages),
-					  svm->pasid, sdev->qdep);
+					  svm->pasid, dev_pasid->qdep);
 	}
 }
 
 static void intel_flush_svm_range_dev(struct intel_svm *svm,
-				      struct intel_svm_dev *sdev,
+				      struct dev_pasid_info *dev_pasid,
 				      unsigned long address,
 				      unsigned long pages, int ih)
 {
@@ -200,7 +201,7 @@ static void intel_flush_svm_range_dev(struct intel_svm *svm,
 	unsigned long end = ALIGN(address + (pages << VTD_PAGE_SHIFT), align);
 
 	while (start < end) {
-		__flush_svm_range_dev(svm, sdev, start, align >> VTD_PAGE_SHIFT, ih);
+		__flush_svm_range_dev(svm, dev_pasid, start, align >> VTD_PAGE_SHIFT, ih);
 		start += align;
 	}
 }
@@ -208,11 +209,11 @@ static void intel_flush_svm_range_dev(struct intel_svm *svm,
 static void intel_flush_svm_range(struct intel_svm *svm, unsigned long address,
 				unsigned long pages, int ih)
 {
-	struct intel_svm_dev *sdev;
+	struct dev_pasid_info *dev_pasid;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(sdev, &svm->devs, list)
-		intel_flush_svm_range_dev(svm, sdev, address, pages, ih);
+	list_for_each_entry_rcu(dev_pasid, &svm->devs, link_domain)
+		intel_flush_svm_range_dev(svm, dev_pasid, address, pages, ih);
 	rcu_read_unlock();
 }
 
@@ -230,7 +231,8 @@ static void intel_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct intel_svm *svm = container_of(mn, struct intel_svm, notifier);
-	struct intel_svm_dev *sdev;
+	struct dev_pasid_info *dev_pasid;
+	struct intel_iommu *iommu;
 
 	/* This might end up being called from exit_mmap(), *before* the page
 	 * tables are cleared. And __mmu_notifier_release() will delete us from
@@ -245,9 +247,11 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * *has* to handle gracefully without affecting other processes.
 	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(sdev, &svm->devs, list)
-		intel_pasid_tear_down_entry(sdev->iommu, sdev->dev,
+	list_for_each_entry_rcu(dev_pasid, &svm->devs, link_domain) {
+		iommu = dev_to_intel_iommu(dev_pasid->dev);
+		intel_pasid_tear_down_entry(iommu, dev_pasid->dev,
 					    svm->pasid, true);
+	}
 	rcu_read_unlock();
 
 }
@@ -257,11 +261,11 @@ static const struct mmu_notifier_ops intel_mmuops = {
 	.arch_invalidate_secondary_tlbs = intel_arch_invalidate_secondary_tlbs,
 };
 
-static int pasid_to_svm_sdev(struct device *dev, unsigned int pasid,
+static int pasid_to_dev_pasid_info(struct device *dev, unsigned int pasid,
 			     struct intel_svm **rsvm,
-			     struct intel_svm_dev **rsdev)
+			     struct dev_pasid_info **rsdev_pasid_info)
 {
-	struct intel_svm_dev *sdev = NULL;
+	struct dev_pasid_info *dev_pasid = NULL;
 	struct intel_svm *svm;
 
 	if (pasid == IOMMU_PASID_INVALID || pasid >= PASID_MAX)
@@ -280,11 +284,11 @@ static int pasid_to_svm_sdev(struct device *dev, unsigned int pasid,
 	 */
 	if (WARN_ON(list_empty(&svm->devs)))
 		return -EINVAL;
-	sdev = svm_lookup_device_by_dev(svm, dev);
+	dev_pasid = svm_lookup_dev_pasid_info_by_dev(svm, dev);
 
 out:
 	*rsvm = svm;
-	*rsdev = sdev;
+	*rsdev_pasid_info = dev_pasid;
 
 	return 0;
 }
@@ -295,7 +299,7 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
 	struct mm_struct *mm = domain->mm;
-	struct intel_svm_dev *sdev;
+	struct dev_pasid_info *dev_pasid;
 	struct intel_svm *svm;
 	unsigned long sflags;
 	int ret = 0;
@@ -325,20 +329,18 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 		}
 	}
 
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
-	if (!sdev) {
+	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
+	if (!dev_pasid) {
 		ret = -ENOMEM;
 		goto free_svm;
 	}
 
-	sdev->dev = dev;
-	sdev->iommu = iommu;
-	sdev->did = FLPT_DEFAULT_DID;
-	sdev->sid = PCI_DEVID(info->bus, info->devfn);
+	dev_pasid->dev = dev;
+	dev_pasid->sid = PCI_DEVID(info->bus, info->devfn);
 	if (info->ats_enabled) {
-		sdev->qdep = info->ats_qdep;
-		if (sdev->qdep >= QI_DEV_EIOTLB_MAX_INVS)
-			sdev->qdep = 0;
+		dev_pasid->qdep = info->ats_qdep;
+		if (dev_pasid->qdep >= QI_DEV_EIOTLB_MAX_INVS)
+			dev_pasid->qdep = 0;
 	}
 
 	/* Setup the pasid table: */
@@ -346,14 +348,14 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 	ret = intel_pasid_setup_first_level(iommu, dev, mm->pgd, pasid,
 					    FLPT_DEFAULT_DID, sflags);
 	if (ret)
-		goto free_sdev;
+		goto free_dev_pasid;
 
-	list_add_rcu(&sdev->list, &svm->devs);
+	list_add_rcu(&dev_pasid->link_domain, &svm->devs);
 
 	return 0;
 
-free_sdev:
-	kfree(sdev);
+free_dev_pasid:
+	kfree(dev_pasid);
 free_svm:
 	if (list_empty(&svm->devs)) {
 		mmu_notifier_unregister(&svm->notifier, mm);
@@ -366,26 +368,24 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 
 void intel_svm_remove_dev_pasid(struct device *dev, u32 pasid)
 {
-	struct intel_svm_dev *sdev;
+	struct dev_pasid_info *dev_pasid;
 	struct intel_iommu *iommu;
 	struct intel_svm *svm;
-	struct mm_struct *mm;
 
 	iommu = device_to_iommu(dev, NULL, NULL);
 	if (!iommu)
 		return;
 
-	if (pasid_to_svm_sdev(dev, pasid, &svm, &sdev))
+	if (pasid_to_dev_pasid_info(dev, pasid, &svm, &dev_pasid))
 		return;
-	mm = svm->mm;
 
-	if (sdev) {
-		list_del_rcu(&sdev->list);
-		kfree_rcu(sdev, rcu);
+	if (dev_pasid) {
+		list_del_rcu(&dev_pasid->link_domain);
+		kfree_rcu(dev_pasid, rcu);
 
 		if (list_empty(&svm->devs)) {
 			if (svm->notifier.ops)
-				mmu_notifier_unregister(&svm->notifier, mm);
+				mmu_notifier_unregister(&svm->notifier, svm->mm);
 			pasid_private_remove(svm->pasid);
 			kfree(svm);
 		}
-- 
2.39.3

