Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224CB7CB939
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbjJQDWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbjJQDWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:22:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B191BD;
        Mon, 16 Oct 2023 20:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512894; x=1729048894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qobGlaK8TEPOAY4t3FEri4+IRYlzhuaNkBI59Owxzdg=;
  b=B8ChmSumxPErEUjB+AhVH19+i6YCCebuzQwQny4Bge4O4/AwbQ3O6xqz
   jGdNiO69km74zymsEB32vHKRIEIAWLZiVg+Q0Z0bgdfE9f1MDaOGIW7KM
   BaLgmQEIfN98w1vhmRD7DRQTyX8lCZof7N+EcvhIYfNCwEP+nteH+6eR/
   J05vrZjKWXZi4ahSbd5T8tbUetYkFWe+gyyQyx6sATwAvjurYKebiqYXM
   f0jTs2tY7Z+x9BqApaMj9e8tH+ujTml+146DYvQtXEes8u9SeUL5Otf1a
   lUJZyT6lec+/gEY2iqzB+A67fzzroaF0dgquXBmrirv2saU8Zstn4/0IV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560879"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560879"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270083"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270083"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:31 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 09/12] iommu/vt-d: Refactor intel_iommu_set_dev_pasid()
Date:   Tue, 17 Oct 2023 11:20:42 +0800
Message-Id: <20231017032045.114868-11-tina.zhang@intel.com>
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

Refactor the code in several aspects:
1) Add domain_type_is_sva() helper.
2) Extend domain_attach_iommu() to support sva domain.
3) Extend intel_iommu_set_dev_pasid() to support sva domain.
4) Make intel_iommu_set_dev_pasid() global so that it can be used by
   others.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/iommu.c | 58 +++++++++++++++++++++++++++++++------
 drivers/iommu/intel/iommu.h |  2 ++
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index fe063e1250fa..57f6bbf33205 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -388,6 +388,11 @@ static inline int domain_type_is_si(struct dmar_domain *domain)
 	return domain->domain.type == IOMMU_DOMAIN_IDENTITY;
 }
 
+static inline int domain_type_is_sva(struct dmar_domain *domain)
+{
+	return domain->domain.type == IOMMU_DOMAIN_SVA;
+}
+
 static inline int domain_pfn_supported(struct dmar_domain *domain,
 				       unsigned long pfn)
 {
@@ -562,6 +567,14 @@ static unsigned long domain_super_pgsize_bitmap(struct dmar_domain *domain)
 /* Some capabilities may be different across iommus */
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
+	/*
+	 * Caps for maintaining I/O page table are unnecessary for SVA domain,
+	 * since device is using the same virtual page table with processor and
+	 * processor is the owner of the page table.
+	 */
+	if (domain_type_is_sva(domain))
+		return;
+
 	domain_update_iommu_coherency(domain);
 	domain->iommu_superpage = domain_update_iommu_superpage(domain, NULL);
 
@@ -1798,14 +1811,18 @@ static int domain_attach_iommu(struct dmar_domain *domain,
 		return 0;
 	}
 
-	ndomains = cap_ndoms(iommu->cap);
-	num = find_first_zero_bit(iommu->domain_ids, ndomains);
-	if (num >= ndomains) {
-		pr_err("%s: No free domain ids\n", iommu->name);
-		goto err_unlock;
+	if (!domain_type_is_sva(domain)) {
+		ndomains = cap_ndoms(iommu->cap);
+		num = find_first_zero_bit(iommu->domain_ids, ndomains);
+		if (num >= ndomains) {
+			pr_err("%s: No free domain ids\n", iommu->name);
+			goto err_unlock;
+		}
+		set_bit(num, iommu->domain_ids);
+	} else {
+		num = FLPT_DEFAULT_DID;
 	}
 
-	set_bit(num, iommu->domain_ids);
 	info->refcnt	= 1;
 	info->did	= num;
 	info->iommu	= iommu;
@@ -1821,7 +1838,8 @@ static int domain_attach_iommu(struct dmar_domain *domain,
 	return 0;
 
 err_clear:
-	clear_bit(info->did, iommu->domain_ids);
+	if (!domain_type_is_sva(domain))
+		clear_bit(info->did, iommu->domain_ids);
 err_unlock:
 	spin_unlock(&iommu->lock);
 	kfree(info);
@@ -4064,6 +4082,14 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 	struct intel_iommu *iommu;
 	int addr_width;
 
+	/*
+	 * In SVA case, don't need to check the fields for maintaining I/O page table, as
+	 * device is using the same virtual page table with processor and processor is
+	 * the owner of the page table.
+	 */
+	if (domain_type_is_sva(dmar_domain))
+		return 0;
+
 	iommu = device_to_iommu(dev, NULL, NULL);
 	if (!iommu)
 		return -ENODEV;
@@ -4685,7 +4711,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	 * notification. Before consolidating that code into iommu core, let
 	 * the intel sva code handle it.
 	 */
-	if (domain->type == IOMMU_DOMAIN_SVA) {
+	if (domain_type_is_sva(dmar_domain)) {
 		intel_svm_remove_dev_pasid(dev, pasid);
 		goto out_tear_down;
 	}
@@ -4709,7 +4735,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	intel_drain_pasid_prq(dev, pasid);
 }
 
-static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 				     struct device *dev, ioasid_t pasid)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
@@ -4733,6 +4759,16 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (!dev_pasid)
 		return -ENOMEM;
 
+	if (domain_type_is_sva(dmar_domain)) {
+		dev_pasid->sid = PCI_DEVID(info->bus, info->devfn);
+		init_rcu_head(&dev_pasid->rcu);
+		if (info->ats_enabled) {
+			dev_pasid->qdep = info->ats_qdep;
+			if (dev_pasid->qdep >= QI_DEV_EIOTLB_MAX_INVS)
+				dev_pasid->qdep = 0;
+		}
+	}
+
 	ret = domain_attach_iommu(dmar_domain, iommu);
 	if (ret)
 		goto out_free;
@@ -4743,6 +4779,10 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	else if (dmar_domain->use_first_level)
 		ret = domain_setup_first_level(iommu, dmar_domain,
 					       dev, pasid);
+	else if (domain_type_is_sva(dmar_domain))
+		ret = intel_pasid_setup_first_level(iommu, dev,
+			domain->mm->pgd, pasid, FLPT_DEFAULT_DID,
+			cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0);
 	else
 		ret = intel_pasid_setup_second_level(iommu, dmar_domain,
 						     dev, pasid);
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index a9e9301b2713..b6dff0da9e8e 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -850,6 +850,8 @@ static inline struct intel_iommu *dev_to_intel_iommu(struct device *dev)
 
 	return container_of(iommu_dev, struct intel_iommu, iommu);
 }
+int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+				     struct device *dev, ioasid_t pasid);
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
 void intel_svm_check(struct intel_iommu *iommu);
-- 
2.39.3

