Return-Path: <kvm+bounces-20642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96E891BA79
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D232B22E7B
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA6F14F9C4;
	Fri, 28 Jun 2024 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lRlGhgNy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A02414EC7F
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 08:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719564944; cv=none; b=taiB21ap6BkrPTx7DIxr9HO0wMa8YG3TCDLGvP+DXR0lBJEgLLjZmu/j4VxSWTUdkyul1/HZJ8OLoXKHQKU2wz+r13pmn63gX82/v3rwr3d5m5dZKG+jv/PYd9188LRnjTd1qY7R5Jtda/9Jywm2ip3j7TaXoYm7nG1NuNnofqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719564944; c=relaxed/simple;
	bh=+ZEwnp7TCKlAFHdsXqLeUVm5bqjBbJ1vbVGHIX1IMao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gu364DAjoAQyi1ZcwTA3EfRrx/C5nL3IT7VeAmWcIg4CAd8HUT14MIX2TGCxewh8apncgRWMryhllSXKZVcySBrB2v/LLEan5jBgyY0FfWQmU5QMGaIS2HSl3cntdXGaNg32PZxyExSujYqtDUEX0Il0nKp1bmTV7PI/5gExj4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lRlGhgNy; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719564942; x=1751100942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ZEwnp7TCKlAFHdsXqLeUVm5bqjBbJ1vbVGHIX1IMao=;
  b=lRlGhgNy1rWRkzawsdrGu0njXuamlu0VifkbRgwj2l1iH2550Mlrk8hw
   bygF/Y/GS0RgenDozKtvXi0HA163oZgMos7aaDt3yus73oChqK4moOMa1
   iVyHlggKUZKqES3NYRHPresVLDVnaPuKfpn3u1uaLXGAJUUk+5tBQCPm7
   5S/Ow/qqqoiW2UKlPYWaPiAtvwoS+g3FOOWGW5gjzuAxKArYH+nzdxh8n
   QvbZ3ElpA8gx1FQokTMukKmqWr0tjD1WzVNX8E/gwnNV3G8oSnWxNLexS
   bEBRCAO2QSkw32gnIADKLkbGvMAmB3v+K4B0nuTlqDepOOYO8apIrbyIm
   g==;
X-CSE-ConnectionGUID: 6CjPRQurRieuvHMrMJwFfQ==
X-CSE-MsgGUID: SJnOZZYASCW5ff2el4ijeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="34277486"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="34277486"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 01:55:41 -0700
X-CSE-ConnectionGUID: 2JMLgg2XQ4GMg/mlYwcmjg==
X-CSE-MsgGUID: bIIgfXWaRpyt4seEX/VUiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44584529"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 28 Jun 2024 01:55:42 -0700
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
Subject: [PATCH 2/6] iommu/vt-d: Move intel_drain_pasid_prq() into intel_pasid_tear_down_entry()
Date: Fri, 28 Jun 2024 01:55:34 -0700
Message-Id: <20240628085538.47049-3-yi.l.liu@intel.com>
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

Draining PRQ is needed before repurposing a PASID. It makes sense to invoke
it in the intel_pasid_tear_down_entry().

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 5 ++---
 drivers/iommu/intel/pasid.c | 9 ++++++++-
 drivers/iommu/intel/pasid.h | 5 ++---
 drivers/iommu/intel/svm.c   | 6 +++++-
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 288c929b3d15..dd3de95c7122 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3241,7 +3241,7 @@ void device_block_translation(struct device *dev)
 	if (!dev_is_real_dma_subdevice(dev)) {
 		if (sm_supported(iommu))
 			intel_pasid_tear_down_entry(iommu, dev,
-						    IOMMU_NO_PASID, false);
+						    IOMMU_NO_PASID, false, false);
 		else
 			domain_context_clear(info);
 	}
@@ -4060,8 +4060,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
 	kfree(dev_pasid);
 out_tear_down:
-	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
-	intel_drain_pasid_prq(dev, pasid);
+	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
 }
 
 static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 573e1b8e3cfb..b18eebb479de 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -233,8 +233,12 @@ devtlb_invalidation_with_pasid(struct intel_iommu *iommu,
 		qi_flush_dev_iotlb_pasid(iommu, sid, pfsid, pasid, qdep, 0, 64 - VTD_PAGE_SHIFT);
 }
 
+/*
+ * Not all PASID entry destroy requires PRQ drain as it can be handled in
+ * the remove_dev_pasid path. Caller should be clear on it.
+ */
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
-				 u32 pasid, bool fault_ignore)
+				 u32 pasid, bool fault_ignore, bool drain_prq)
 {
 	struct pasid_entry *pte;
 	u16 did, pgtt;
@@ -264,6 +268,9 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 	/* Device IOTLB doesn't need to be flushed in caching mode. */
 	if (!cap_caching_mode(iommu->cap))
 		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+
+	if (drain_prq)
+		intel_drain_pasid_prq(dev, pasid);
 }
 
 /*
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index da9978fef7ac..8b77b0d21c6e 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -313,9 +313,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct device *dev, u32 pasid);
 int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 			     u32 pasid, struct dmar_domain *domain);
-void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
-				 struct device *dev, u32 pasid,
-				 bool fault_ignore);
+void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
+				 u32 pasid, bool fault_ignore, bool drain_prq);
 void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
 					  struct device *dev, u32 pasid);
 int intel_pasid_setup_sm_context(struct device *dev);
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index a5845ca94867..679e094d9f52 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -175,8 +175,12 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_lock_irqsave(&domain->lock, flags);
 	list_for_each_entry(dev_pasid, &domain->dev_pasids, link_domain) {
 		info = dev_iommu_priv_get(dev_pasid->dev);
+		/*
+		 * PRQ drain would happen in the remove_dev_pasid() path,
+		 * no need to do it here.
+		 */
 		intel_pasid_tear_down_entry(info->iommu, dev_pasid->dev,
-					    dev_pasid->pasid, true);
+					    dev_pasid->pasid, true, false);
 	}
 	spin_unlock_irqrestore(&domain->lock, flags);
 
-- 
2.34.1


