Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E127CB937
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbjJQDWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbjJQDWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:22:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48806D43;
        Mon, 16 Oct 2023 20:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512896; x=1729048896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8lrMBovYHF13zqlv8fq2NGGZgFHbL3cK2VIac2TIbMY=;
  b=VTIfFmeMJTTOnw77lzFEU3b1fXofAy1tGCOb77oKTJim1KdF3Mdl7vFb
   M/dgTAxGa6z8f3vN+MfDrplG+PfXRU7qlvjK24EQM/adVbiNNEuO7OT2e
   VyRT69geh3E9WdtLNGKMXFqLIFBh/mId5zFy0fMP1+hVbfarkBp/X2nWx
   diTjdGyBin7fYq9wa4B6a12LvhLyahr1V0cDE1g/NEw8jg4O96c2uBWbo
   fAexO3Ps78UASBNDUG0MCKmKAKn8jGT/n2tXvT7ehI9O0sAsjHhLVXuVU
   NMoAmE6DXOfRwV9h47soJrvqrOOa9GZJFFWxyIhKkni3q0pwToBCmkr8L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560888"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560888"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270092"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270092"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:33 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 10/12] iommu/vt-d: Refactor intel_iommu_remove_dev_pasid()
Date:   Tue, 17 Oct 2023 11:20:43 +0800
Message-Id: <20231017032045.114868-12-tina.zhang@intel.com>
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

Since domain centralizes info required for sva domain in itself, the
intel_iommu_remove_dev_pasid() can handle device detaching work of sva
domain w/o asking help of intel_svm_remove_dev_pasid() any more.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/iommu.c | 16 +++++----------
 drivers/iommu/intel/iommu.h |  4 ----
 drivers/iommu/intel/svm.c   | 39 -------------------------------------
 3 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 57f6bbf33205..2aea5201de3d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4703,19 +4703,9 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	unsigned long flags;
 
 	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
-	if (WARN_ON_ONCE(!domain))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(domain)))
 		goto out_tear_down;
 
-	/*
-	 * The SVA implementation needs to handle its own stuffs like the mm
-	 * notification. Before consolidating that code into iommu core, let
-	 * the intel sva code handle it.
-	 */
-	if (domain_type_is_sva(dmar_domain)) {
-		intel_svm_remove_dev_pasid(dev, pasid);
-		goto out_tear_down;
-	}
-
 	dmar_domain = to_dmar_domain(domain);
 	spin_lock_irqsave(&dmar_domain->lock, flags);
 	list_for_each_entry(curr, &dmar_domain->dev_pasids, link_domain) {
@@ -4730,6 +4720,10 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 	domain_detach_iommu(dmar_domain, iommu);
 	kfree_rcu(dev_pasid, rcu);
+	if (list_empty(&to_dmar_domain(domain)->dev_pasids)) {
+		if (domain->notifier.ops)
+			mmu_notifier_unregister(&domain->notifier, domain->mm);
+	}
 out_tear_down:
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
 	intel_drain_pasid_prq(dev, pasid);
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index b6dff0da9e8e..84e942a16666 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -860,7 +860,6 @@ int intel_svm_finish_prq(struct intel_iommu *iommu);
 int intel_svm_page_response(struct device *dev, struct iommu_fault_event *evt,
 			    struct iommu_page_response *msg);
 struct iommu_domain *intel_svm_domain_alloc(void);
-void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
 void intel_drain_pasid_prq(struct device *dev, u32 pasid);
 #else
 static inline void intel_svm_check(struct intel_iommu *iommu) {}
@@ -870,9 +869,6 @@ static inline struct iommu_domain *intel_svm_domain_alloc(void)
 	return NULL;
 }
 
-static inline void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid)
-{
-}
 #endif
 
 #ifdef CONFIG_INTEL_IOMMU_DEBUGFS
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index fd61fbf7593a..7f98c8acd04f 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -27,23 +27,6 @@
 
 static irqreturn_t prq_event_thread(int irq, void *d);
 
-static struct dev_pasid_info *
-domain_lookup_dev_pasid_info_by_dev(struct dmar_domain *domain, struct device *dev)
-{
-	struct dev_pasid_info *dev_pasid = NULL, *t;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(t, &domain->dev_pasids, link_domain) {
-		if (t->dev == dev) {
-			dev_pasid = t;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	return dev_pasid;
-}
-
 int intel_svm_enable_prq(struct intel_iommu *iommu)
 {
 	struct iopf_queue *iopfq;
@@ -301,28 +284,6 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 	return ret;
 }
 
-void intel_svm_remove_dev_pasid(struct device *dev, u32 pasid)
-{
-	struct iommu_domain *domain;
-	struct dev_pasid_info *dev_pasid;
-
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid,
-						IOMMU_DOMAIN_SVA);
-	if (WARN_ON_ONCE(IS_ERR_OR_NULL(domain)))
-		return;
-
-	dev_pasid = domain_lookup_dev_pasid_info_by_dev(to_dmar_domain(domain), dev);
-	if (dev_pasid) {
-		list_del_rcu(&dev_pasid->link_domain);
-		kfree_rcu(dev_pasid, rcu);
-
-		if (list_empty(&to_dmar_domain(domain)->dev_pasids)) {
-			if (domain->notifier.ops)
-				mmu_notifier_unregister(&domain->notifier, domain->mm);
-		}
-	}
-}
-
 /* Page request queue descriptor */
 struct page_req_dsc {
 	union {
-- 
2.39.3

