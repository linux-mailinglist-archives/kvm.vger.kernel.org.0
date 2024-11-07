Return-Path: <kvm+bounces-31104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B71D39C059F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 772B2283EB9
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56748210193;
	Thu,  7 Nov 2024 12:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tvd4ujwK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB1720FA81
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982162; cv=none; b=sot7YJ3pCIwzoJFXMmb34w4M+h7pvDmJgTVPRqvX3/+zhS2yx2/Eo2u2VQR6HauRNVJdLLOiaUhd795eWmkLMd5mpzkne0mWucZgQcwD++LErNJzv2VUPDZvFNgAK6DszIILWnGuUQ36YfUKLLoDs31vCd+C20EiMrRgPQv6nKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982162; c=relaxed/simple;
	bh=xFPrtyXkYT63Q3iV+uXRCl2QqkXdlVNS1B7jsbIWhVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KIPfW+mPYJjvVZa83ZxF2Im0Rh5c5vxW+wiSKh/Sk47sRfZpZUpUv0TSoIXrKi8V++k9sYvWErqMC6kgUni9v49+olELMpDZHamQqdtpBkBzV2xbJY+DBUfIQCwbeuVvR7W9yUxybzUkL3KcSOib3jsQ7+zCVSgtloN4qOzbEkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tvd4ujwK; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982160; x=1762518160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xFPrtyXkYT63Q3iV+uXRCl2QqkXdlVNS1B7jsbIWhVU=;
  b=Tvd4ujwKno8jFQpuHd7llieDLtcM0ZLMUfQZO531lZtwjJ6ktAH/V0ao
   /j7M5/MdYvbcH3POpRft2JghKlV7bFrsyAzw2g1opqVqBnhjZ7BzgjAcu
   w2XnwIh1Chlz3popu3jyKXHStn98VAAZNzETIKw28f2zUE21X9/V7Q6wK
   PIuD20LlNbKZJLOBRKU2l90tNC4Eh8c5RdvFoB/49HAT6g33/mr/sV6ry
   nrkck3Ebhfj+Cf9JGKAxHYjcVqLVvXttd9DnnYh15yhAG8BzipEr+3y0q
   X4+vJm1R3RELlKLWkzLx36NatQTcqkern6RMveTTw0y6dcwarm5cSeiij
   w==;
X-CSE-ConnectionGUID: Ph1Ij3H9Qc+7h3fQe3/6HQ==
X-CSE-MsgGUID: JOX/0iF7QV+w/wqwTMYYPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744606"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744606"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:38 -0800
X-CSE-ConnectionGUID: q7D+8WvzTbOUVSiV2Rt44w==
X-CSE-MsgGUID: h3uJrOP9T8S9lEWGQwAriA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180568"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:39 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	willy@infradead.org
Subject: [PATCH v6 05/13] iommu/vt-d: Consolidate the struct dev_pasid_info add/remove
Date: Thu,  7 Nov 2024 04:22:26 -0800
Message-Id: <20241107122234.7424-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241107122234.7424-1-yi.l.liu@intel.com>
References: <20241107122234.7424-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

domain_add_dev_pasid() and domain_remove_dev_pasid() are added to consolidate
the adding/removing of the struct dev_pasid_info. Besides, it includes the cache
tag assign/unassign as well.

This also prepares for adding domain replacement for pasid. The set_dev_pasid
callbacks need to deal with the dev_pasid_info for both old and new domain.
These two helpers make the life easier.

intel_iommu_set_dev_pasid() and intel_svm_set_dev_pasid() are updated to use
the helpers.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 91 +++++++++++++++++++++++++------------
 drivers/iommu/intel/iommu.h |  6 +++
 drivers/iommu/intel/svm.c   | 28 +++---------
 3 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 402ba1058794..a1e9dbca6561 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4038,8 +4038,8 @@ static int intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 	return 0;
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-					 struct iommu_domain *domain)
+void domain_remove_dev_pasid(struct iommu_domain *domain,
+			     struct device *dev, ioasid_t pasid)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dev_pasid_info *curr, *dev_pasid = NULL;
@@ -4047,10 +4047,12 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	struct dmar_domain *dmar_domain;
 	unsigned long flags;
 
-	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+	if (!domain)
+		return;
+
+	/* Identity domain has no meta data for pasid. */
+	if (domain->type == IOMMU_DOMAIN_IDENTITY)
 		return;
-	}
 
 	dmar_domain = to_dmar_domain(domain);
 	spin_lock_irqsave(&dmar_domain->lock, flags);
@@ -4068,7 +4070,52 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	domain_detach_iommu(dmar_domain, iommu);
 	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
 	kfree(dev_pasid);
-	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+}
+
+static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *domain)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+
+	intel_pasid_tear_down_entry(info->iommu, dev, pasid, false);
+	domain_remove_dev_pasid(domain, dev, pasid);
+}
+
+struct dev_pasid_info *
+domain_add_dev_pasid(struct iommu_domain *domain,
+		     struct device *dev, ioasid_t pasid)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct intel_iommu *iommu = info->iommu;
+	struct dev_pasid_info *dev_pasid;
+	unsigned long flags;
+	int ret;
+
+	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
+	if (!dev_pasid)
+		return ERR_PTR(-ENOMEM);
+
+	ret = domain_attach_iommu(dmar_domain, iommu);
+	if (ret)
+		goto out_free;
+
+	ret = cache_tag_assign_domain(dmar_domain, dev, pasid);
+	if (ret)
+		goto out_detach_iommu;
+
+	dev_pasid->dev = dev;
+	dev_pasid->pasid = pasid;
+	spin_lock_irqsave(&dmar_domain->lock, flags);
+	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
+	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+
+	return dev_pasid;
+out_detach_iommu:
+	domain_detach_iommu(dmar_domain, iommu);
+out_free:
+	kfree(dev_pasid);
+	return ERR_PTR(ret);
 }
 
 static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
@@ -4079,7 +4126,6 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
 	struct dev_pasid_info *dev_pasid;
-	unsigned long flags;
 	int ret;
 
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
@@ -4095,17 +4141,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (ret)
 		return ret;
 
-	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
-	if (!dev_pasid)
-		return -ENOMEM;
-
-	ret = domain_attach_iommu(dmar_domain, iommu);
-	if (ret)
-		goto out_free;
-
-	ret = cache_tag_assign_domain(dmar_domain, dev, pasid);
-	if (ret)
-		goto out_detach_iommu;
+	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
+	if (IS_ERR(dev_pasid))
+		return PTR_ERR(dev_pasid);
 
 	if (dmar_domain->use_first_level)
 		ret = domain_setup_first_level(iommu, dmar_domain,
@@ -4114,24 +4152,17 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 		ret = intel_pasid_setup_second_level(iommu, dmar_domain,
 						     dev, pasid);
 	if (ret)
-		goto out_unassign_tag;
+		goto out_remove_dev_pasid;
 
-	dev_pasid->dev = dev;
-	dev_pasid->pasid = pasid;
-	spin_lock_irqsave(&dmar_domain->lock, flags);
-	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
-	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	domain_remove_dev_pasid(old, dev, pasid);
 
 	if (domain->type & __IOMMU_DOMAIN_PAGING)
 		intel_iommu_debugfs_create_dev_pasid(dev_pasid);
 
 	return 0;
-out_unassign_tag:
-	cache_tag_unassign_domain(dmar_domain, dev, pasid);
-out_detach_iommu:
-	domain_detach_iommu(dmar_domain, iommu);
-out_free:
-	kfree(dev_pasid);
+
+out_remove_dev_pasid:
+	domain_remove_dev_pasid(domain, dev, pasid);
 	return ret;
 }
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index b3912633ce25..df0261e03fad 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1228,6 +1228,12 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void device_block_translation(struct device *dev);
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev);
 
+struct dev_pasid_info *
+domain_add_dev_pasid(struct iommu_domain *domain,
+		     struct device *dev, ioasid_t pasid);
+void domain_remove_dev_pasid(struct iommu_domain *domain,
+			     struct device *dev, ioasid_t pasid);
+
 int dmar_ir_support(void);
 
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 4a2bd65614ad..6c0685ea8466 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -115,43 +115,29 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 				   struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
 	struct mm_struct *mm = domain->mm;
 	struct dev_pasid_info *dev_pasid;
 	unsigned long sflags;
-	unsigned long flags;
 	int ret = 0;
 
-	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
-	if (!dev_pasid)
-		return -ENOMEM;
-
-	dev_pasid->dev = dev;
-	dev_pasid->pasid = pasid;
-
-	ret = cache_tag_assign_domain(to_dmar_domain(domain), dev, pasid);
-	if (ret)
-		goto free_dev_pasid;
+	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
+	if (IS_ERR(dev_pasid))
+		return PTR_ERR(dev_pasid);
 
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
 	ret = intel_pasid_setup_first_level(iommu, dev, mm->pgd, pasid,
 					    FLPT_DEFAULT_DID, sflags);
 	if (ret)
-		goto unassign_tag;
+		goto out_remove_dev_pasid;
 
-	spin_lock_irqsave(&dmar_domain->lock, flags);
-	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
-	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	domain_remove_dev_pasid(old, dev, pasid);
 
 	return 0;
 
-unassign_tag:
-	cache_tag_unassign_domain(to_dmar_domain(domain), dev, pasid);
-free_dev_pasid:
-	kfree(dev_pasid);
-
+out_remove_dev_pasid:
+	domain_remove_dev_pasid(domain, dev, pasid);
 	return ret;
 }
 
-- 
2.34.1


