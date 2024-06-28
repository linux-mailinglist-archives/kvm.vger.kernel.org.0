Return-Path: <kvm+bounces-20645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E18391BA7C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7B3728280D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F0215099C;
	Fri, 28 Jun 2024 08:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MgurLral"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C3214F133
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 08:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719564945; cv=none; b=J4YlYRN/QTG34Dk4pWb3+VkkdWu7DBJLKzUcUl0IeDufB4ACwfPpebqz9DcYuTr893HoErP12ORatE7yxOhZD4gREe31WygQxTNZMRfDK2Buzdyt9C8z1CAejof6IJSuHlDv5c9dKbult3l97misN+AETsVyizoroLyBHJq11Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719564945; c=relaxed/simple;
	bh=rBKvVG4Uk1psIKKs9WUwQ1qr6CMaOdyXHGtCugycUyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IORGta3ibAactzgzvPCYEH3YuVjHEACR/YGc/UkWFaMGWQxShW/FjDeY9BBYkZH7ISSWekioagCOXWuXKtROCgXKwqUh1Zuzl+xSXlpdu3qIBFHVG6AcE4H1LpttooYLMn3X/2wwV46hBansPGx8JKtxhIEMLhyTJyuD6+oOBOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgurLral; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719564944; x=1751100944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rBKvVG4Uk1psIKKs9WUwQ1qr6CMaOdyXHGtCugycUyE=;
  b=MgurLralmUenkiMOXl44ipvflmGCT/bzfBiEq0N9LxFgCYiId8pWmNd3
   XhTqGoX9zVFm5XwuClYTl9Ng4EspEeearOcgX+dRo3KZvPJlUndrXzDtJ
   b7V/6Ft4FtY4fLs50q/nE515P+cLhQ26WtKuRm3EUtwo2gVbCSV8yqzlp
   pUyzrVzOUKAg5Jn9YX8lirDG6Dd2wJgdC8Wp0Wha3TmaHdY/nbJRX3jfN
   DLSRLHYdLK5HGTtWorp3nQymClFw/djNNusFmOwu2F7XNZom3n83zvm8H
   GySucdL/mvC7RvJsmnQihC0FPWcVj3VGPpukhi9IbYYdb+TuketlvR9Ma
   A==;
X-CSE-ConnectionGUID: QyFT2bIlRPS+79qcoHxTsA==
X-CSE-MsgGUID: pSNEfkvMT4SAhY20SWzeJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="34277502"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="34277502"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 01:55:43 -0700
X-CSE-ConnectionGUID: 6JCx95Q2SH+ScP09XFc60w==
X-CSE-MsgGUID: DTZjjOoUThmkynfC67ibFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44584538"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 28 Jun 2024 01:55:44 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev
Subject: [PATCH 4/6] iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain replacement
Date: Fri, 28 Jun 2024 01:55:36 -0700
Message-Id: <20240628085538.47049-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_dev_pasid op is going to support domain replacement and keep the old
hardware config if it fails. Make the Intel iommu driver be prepared for
it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/debugfs.c |  2 +
 drivers/iommu/intel/iommu.c   | 94 +++++++++++++++++++++++------------
 2 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/intel/debugfs.c b/drivers/iommu/intel/debugfs.c
index affbf4a1558d..8deb6bc262c5 100644
--- a/drivers/iommu/intel/debugfs.c
+++ b/drivers/iommu/intel/debugfs.c
@@ -806,5 +806,7 @@ void intel_iommu_debugfs_create_dev_pasid(struct dev_pasid_info *dev_pasid)
 /* Remove the device pasid debugfs directory. */
 void intel_iommu_debugfs_remove_dev_pasid(struct dev_pasid_info *dev_pasid)
 {
+	if (!dev_pasid->debugfs_dentry)
+		return;
 	debugfs_remove_recursive(dev_pasid->debugfs_dentry);
 }
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index dd3de95c7122..8ef6c06f7e73 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4031,8 +4031,8 @@ static int intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 	return 0;
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-					 struct iommu_domain *domain)
+static void domain_undo_dev_pasid(struct iommu_domain *domain,
+				  struct device *dev, ioasid_t pasid)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dev_pasid_info *curr, *dev_pasid = NULL;
@@ -4040,9 +4040,6 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	struct dmar_domain *dmar_domain;
 	unsigned long flags;
 
-	if (domain->type == IOMMU_DOMAIN_IDENTITY)
-		goto out_tear_down;
-
 	dmar_domain = to_dmar_domain(domain);
 	spin_lock_irqsave(&dmar_domain->lock, flags);
 	list_for_each_entry(curr, &dmar_domain->dev_pasids, link_domain) {
@@ -4059,13 +4056,23 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	domain_detach_iommu(dmar_domain, iommu);
 	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
 	kfree(dev_pasid);
-out_tear_down:
+}
+
+static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *domain)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct intel_iommu *iommu = info->iommu;
+
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
+	if (domain->type == IOMMU_DOMAIN_IDENTITY)
+		return;
+	domain_undo_dev_pasid(domain, dev, pasid);
 }
 
-static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
-				     struct device *dev, ioasid_t pasid,
-				     struct iommu_domain *old)
+static struct dev_pasid_info *
+domain_prepare_dev_pasid(struct iommu_domain *domain,
+			 struct device *dev, ioasid_t pasid)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
@@ -4074,22 +4081,13 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	unsigned long flags;
 	int ret;
 
-	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
-		return -EOPNOTSUPP;
-
-	if (domain->dirty_ops)
-		return -EINVAL;
-
-	if (context_copied(iommu, info->bus, info->devfn))
-		return -EBUSY;
-
 	ret = prepare_domain_attach_device(domain, dev);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 
 	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
 	if (!dev_pasid)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	ret = domain_attach_iommu(dmar_domain, iommu);
 	if (ret)
@@ -4099,6 +4097,43 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (ret)
 		goto out_detach_iommu;
 
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
+}
+
+static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+				     struct device *dev, ioasid_t pasid,
+				     struct iommu_domain *old)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct intel_iommu *iommu = info->iommu;
+	struct dev_pasid_info *dev_pasid;
+	int ret;
+
+	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
+		return -EOPNOTSUPP;
+
+	if (domain->dirty_ops)
+		return -EINVAL;
+
+	if (context_copied(iommu, info->bus, info->devfn))
+		return -EBUSY;
+
+	dev_pasid = domain_prepare_dev_pasid(domain, dev, pasid);
+	if (IS_ERR(dev_pasid))
+		return PTR_ERR(dev_pasid);
+
 	if (dmar_domain->use_first_level)
 		ret = domain_setup_first_level(iommu, dmar_domain,
 					       dev, pasid);
@@ -4106,24 +4141,19 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 		ret = intel_pasid_setup_second_level(iommu, dmar_domain,
 						     dev, pasid);
 	if (ret)
-		goto out_unassign_tag;
+		goto out_undo_dev_pasid;
 
-	dev_pasid->dev = dev;
-	dev_pasid->pasid = pasid;
-	spin_lock_irqsave(&dmar_domain->lock, flags);
-	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
-	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	/* Undo the association between the old domain and pasid of a device */
+	if (old)
+		domain_undo_dev_pasid(old, dev, pasid);
 
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
+out_undo_dev_pasid:
+	domain_undo_dev_pasid(domain, dev, pasid);
 	return ret;
 }
 
-- 
2.34.1


