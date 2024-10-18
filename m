Return-Path: <kvm+bounces-29132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B3E39A34D4
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 199ED1F24844
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79648185B6E;
	Fri, 18 Oct 2024 05:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V6DW61Fs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD01F183098
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230848; cv=none; b=gW+uS2WiUEFIyTKB4bTfrq6TncOJbDVyyvVCvAVtFazn4xGOOMsWxINGz0cZOrIz1BwiMFAkuZ5am8HBu1vDpRTvh3TAj9D/4+jTB1GmBgt8aoVX0oq1MCOuRgKrk9xEgk12t4VO9RKtD5T9LIVeyO/VKnHYnjoXPC6PCtZy6aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230848; c=relaxed/simple;
	bh=uSRFVZ4BOHbA24h5SRenTsoKuVFBMXPVHVf6pu1kEnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZjHyiyJAMQ/B5SnJSZUVoaQFNVCp8Aob5yzHOD4LHJOX90PqRPsg1m4UwN8kldcWdYh2gbsuGJxRLi/mZUD/zBh4bvrKYFK785TJJlDNCVVQgihFJn5tYSD7qGUJhC0M5mJ8e8WlgJxzOv0oaMRjC3ZHvEraZM0TiX98A4eMhTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V6DW61Fs; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230847; x=1760766847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uSRFVZ4BOHbA24h5SRenTsoKuVFBMXPVHVf6pu1kEnE=;
  b=V6DW61FskYL0+O2yc6CU8YO9upSiqJb+tQktALCJIAptzGtPkiNr12TM
   I8sMzxjDXO1+fD43/wWACtvuJtS7XZwVa6a2DiZdgl8FSCVwUh6gGu0bl
   /8eCnfyM1ndqKeM7smPv64CmMhSDEXxzb3u+w5TXszMnWw9tYF/3uyWlI
   3IfbLU9ofSqgF81jYNkysDQA7kZwYWSypvMzwFEAY/FCQujKE1sCM5OID
   7xaOwg4W9v77usY6wADOYSiwpYKPgz1xNxVx0GLyisJrdjGfPipwxd2J6
   ps5uEqyfQv8ihva6KWifMnpakp+EJxTXW2S/nRUe76fpZmc1y7aarcRP4
   Q==;
X-CSE-ConnectionGUID: GmL8pUoxTfGIEwU6A5NQRQ==
X-CSE-MsgGUID: HM3ASHuoTzeuHfjVgbdyRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708785"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708785"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:06 -0700
X-CSE-ConnectionGUID: eIo5H9FrR0K4WhffUhkfLg==
X-CSE-MsgGUID: AsWaVv+FThy/tasmq9rVnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188562"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:05 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	will@kernel.org
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v3 2/9] iommu/vt-d: Move intel_drain_pasid_prq() into intel_pasid_tear_down_entry()
Date: Thu, 17 Oct 2024 22:53:55 -0700
Message-Id: <20241018055402.23277-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241018055402.23277-1-yi.l.liu@intel.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Draining PRQ is mostly conjuncted with pasid teardown, and with more
callers coming, it makes sense to move it into the
intel_pasid_tear_down_entry(). But there is scenario that only teardown
pasid entry but no PRQ drain, so passing a flag to mark it.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c |  8 ++++----
 drivers/iommu/intel/pasid.c | 12 ++++++++++--
 drivers/iommu/intel/pasid.h |  8 +++++---
 drivers/iommu/intel/svm.c   |  3 ++-
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d5e3e0e79599..ae3522a1e025 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3362,7 +3362,7 @@ void device_block_translation(struct device *dev)
 	if (!dev_is_real_dma_subdevice(dev)) {
 		if (sm_supported(iommu))
 			intel_pasid_tear_down_entry(iommu, dev,
-						    IOMMU_NO_PASID, false);
+						    IOMMU_NO_PASID, 0);
 		else
 			domain_context_clear(info);
 	}
@@ -4260,7 +4260,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	unsigned long flags;
 
 	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+		intel_pasid_tear_down_entry(iommu, dev, pasid, 0);
 		return;
 	}
 
@@ -4280,8 +4280,8 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	domain_detach_iommu(dmar_domain, iommu);
 	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
 	kfree(dev_pasid);
-	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
-	intel_drain_pasid_prq(dev, pasid);
+	intel_pasid_tear_down_entry(iommu, dev, pasid,
+				    INTEL_PASID_TEARDOWN_DRAIN_PRQ);
 }
 
 static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 2e5fa0a23299..2898e7af2cf4 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -236,8 +236,12 @@ devtlb_invalidation_with_pasid(struct intel_iommu *iommu,
 		qi_flush_dev_iotlb_pasid(iommu, sid, pfsid, pasid, qdep, 0, 64 - VTD_PAGE_SHIFT);
 }
 
+/*
+ * Caller can request to drain PRQ in this helper if it hasn't done so,
+ * e.g. in a path which doesn't follow remove_dev_pasid().
+ */
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
-				 u32 pasid, bool fault_ignore)
+				 u32 pasid, u32 flags)
 {
 	struct pasid_entry *pte;
 	u16 did, pgtt;
@@ -251,7 +255,8 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 
 	did = pasid_get_domain_id(pte);
 	pgtt = pasid_pte_get_pgtt(pte);
-	intel_pasid_clear_entry(dev, pasid, fault_ignore);
+	intel_pasid_clear_entry(dev, pasid,
+				flags & INTEL_PASID_TEARDOWN_IGNORE_FAULT);
 	spin_unlock(&iommu->lock);
 
 	if (!ecap_coherent(iommu->ecap))
@@ -265,6 +270,9 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
 	devtlb_invalidation_with_pasid(iommu, dev, pasid);
+
+	if (flags & INTEL_PASID_TEARDOWN_DRAIN_PRQ)
+		intel_drain_pasid_prq(dev, pasid);
 }
 
 /*
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index dde6d3ba5ae0..7dc9e4dfbd88 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -303,9 +303,11 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct device *dev, u32 pasid);
 int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 			     u32 pasid, struct dmar_domain *domain);
-void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
-				 struct device *dev, u32 pasid,
-				 bool fault_ignore);
+
+#define INTEL_PASID_TEARDOWN_IGNORE_FAULT	BIT(0)
+#define INTEL_PASID_TEARDOWN_DRAIN_PRQ		BIT(1)
+void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
+				 u32 pasid, u32 flags);
 void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
 					  struct device *dev, u32 pasid);
 int intel_pasid_setup_sm_context(struct device *dev);
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 3b5e3da24f19..f6cb35e9e6a8 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -176,7 +176,8 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	list_for_each_entry(dev_pasid, &domain->dev_pasids, link_domain) {
 		info = dev_iommu_priv_get(dev_pasid->dev);
 		intel_pasid_tear_down_entry(info->iommu, dev_pasid->dev,
-					    dev_pasid->pasid, true);
+					    dev_pasid->pasid,
+					    INTEL_PASID_TEARDOWN_IGNORE_FAULT);
 	}
 	spin_unlock_irqrestore(&domain->lock, flags);
 
-- 
2.34.1


