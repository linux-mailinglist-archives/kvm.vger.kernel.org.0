Return-Path: <kvm+bounces-26984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5845A97A04B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 759D91C21BDB
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267EA1547C4;
	Mon, 16 Sep 2024 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="uCOR3esL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF2214F9FA;
	Mon, 16 Sep 2024 11:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486369; cv=none; b=fI9YuFuWTHipb48cFm7vdwOuJslJf7wCJMcGZgl63QBeueApHFB8RNwMblSZ4FID26oP2LSdbGFiMtAPCl9E+B0fwbIqhsNTluSo4jV3rhlGPmwnDyUIpsttYA4Xo7OWF8Bi/20k9lJ0k6U+3jhWgcToj7vdexJ5TU+d9Qh3+S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486369; c=relaxed/simple;
	bh=DdVs8r2AEn1WG2+lhc4MpBm5E2Yz6DBnB+uvR5C4mKI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4dv9K/beS/gxVisMeVSw1bmbcM682KmqAW/zCpl7+hwluhKU5ivOlH5se5uzSDDmbacx/2sW6J0qgcA5Ot1BfpoOJ71bY6UM0fPbwe54hhvIGJGCye01x/pn8k0Q9jXXpNcMGDT181NdP1mYPYEkPCVJmtt9IUurNiSgBwPRK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=uCOR3esL; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486367; x=1758022367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vf5kR9S6dXHOFbBgiKTEcIG+RP/hLGBiZ5b2JkKK8MA=;
  b=uCOR3esL6MABLwt1krLAfp26lzsN99OUuS/Lkn6oZjJ3dvWvmrFAVfU8
   WDsJwwxQj4icHnHjKYkWcfaVsxUpKDTQ7cuACpyvGUFolTyZIlKGdLQSB
   AgC3tvumIxMzs86J1/DoyVdM0ch5+maatp7ZSXaPWuzswvtr6Jf0KPlIX
   0=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="126592765"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:32:46 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:6868]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.15:2525] with esmtp (Farcaster)
 id 11e1b852-b74c-4c12-98c6-961bbe493613; Mon, 16 Sep 2024 11:32:45 +0000 (UTC)
X-Farcaster-Flow-ID: 11e1b852-b74c-4c12-98c6-961bbe493613
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:32:45 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:32:34 +0000
From: James Gowans <jgowans@amazon.com>
To: <linux-kernel@vger.kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg
 Roedel" <joro@8bytes.org>, =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?=
	<kw@linux.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Mike Rapoport <rppt@kernel.org>, "Madhavan T.
 Venkataraman" <madvenka@linux.microsoft.com>, <iommu@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Alexander Graf <graf@amazon.de>,
	<anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
	<nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: [RFC PATCH 04/13] iommu: Support marking domains as persistent on alloc
Date: Mon, 16 Sep 2024 13:30:53 +0200
Message-ID: <20240916113102.710522-5-jgowans@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240916113102.710522-1-jgowans@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWB004.ant.amazon.com (10.13.139.134) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

Adding the persistent ID field to the struct iommu_domain and allow it
to be set from the domain_alloc callback which is used by iommufd.
So far unused, and for now it will only be supported on Intel IOMMU as
proof of concept.

Going forward this ID will be used as a unique handle on the
iommu_domain so that after kexec the caller (iommufd) will be able to
restore a reference to the struct iommu_domain which existed before
kexec.
---
 drivers/iommu/amd/iommu.c                   |  4 +++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  3 ++-
 drivers/iommu/intel/iommu.c                 |  2 ++
 drivers/iommu/iommufd/hw_pagetable.c        |  5 ++++-
 drivers/iommu/iommufd/selftest.c            |  1 +
 include/linux/iommu.h                       | 11 +++++++++--
 6 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa..daeb609aa4f5 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2432,12 +2432,14 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
 static struct iommu_domain *
 amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
 			    struct iommu_domain *parent,
+			    unsigned long persistent_id,
 			    const struct iommu_user_data *user_data)
 
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
 
-	if ((flags & ~IOMMU_HWPT_ALLOC_DIRTY_TRACKING) || parent || user_data)
+	if ((flags & ~IOMMU_HWPT_ALLOC_DIRTY_TRACKING) || parent || user_data
+			|| persistent_id)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	return do_iommu_domain_alloc(type, dev, flags);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a31460f9f3d4..41c964891c84 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3049,6 +3049,7 @@ static struct iommu_domain arm_smmu_blocked_domain = {
 static struct iommu_domain *
 arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   struct iommu_domain *parent,
+			   unsigned long persistent_id,
 			   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -3058,7 +3059,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 
 	if (flags & ~PAGING_FLAGS)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent || user_data)
+	if (parent || user_data || persistent_id)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	smmu_domain = arm_smmu_domain_alloc();
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2297cbb0253f..f473a8c008a7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3729,6 +3729,7 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 static struct iommu_domain *
 intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 			      struct iommu_domain *parent,
+			      unsigned long persistent_id,
 			      const struct iommu_user_data *user_data)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
@@ -3761,6 +3762,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	domain->type = IOMMU_DOMAIN_UNMANAGED;
 	domain->owner = &intel_iommu_ops;
 	domain->ops = intel_iommu_ops.default_domain_ops;
+	domain->persistent_id = persistent_id;
 
 	if (nested_parent) {
 		dmar_domain->nested_parent = true;
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index aefde4443671..4bbf1dc98053 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -137,6 +137,7 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 
 	if (ops->domain_alloc_user) {
 		hwpt->domain = ops->domain_alloc_user(idev->dev, flags, NULL,
+						      ictx->persistent_id,
 						      user_data);
 		if (IS_ERR(hwpt->domain)) {
 			rc = PTR_ERR(hwpt->domain);
@@ -239,7 +240,9 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 
 	hwpt->domain = ops->domain_alloc_user(idev->dev,
 					      flags & ~IOMMU_HWPT_FAULT_ID_VALID,
-					      parent->common.domain, user_data);
+					      parent->common.domain,
+					      ictx->persistent_id,
+					      user_data);
 	if (IS_ERR(hwpt->domain)) {
 		rc = PTR_ERR(hwpt->domain);
 		hwpt->domain = NULL;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 222cfc11ebfd..7a9a454369d5 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -318,6 +318,7 @@ __mock_domain_alloc_nested(struct mock_iommu_domain *mock_parent,
 static struct iommu_domain *
 mock_domain_alloc_user(struct device *dev, u32 flags,
 		       struct iommu_domain *parent,
+		       unsigned long persistent_id,
 		       const struct iommu_user_data *user_data)
 {
 	struct mock_iommu_domain *mock_parent;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 04cbdae0052e..a616e8702a1c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -215,6 +215,11 @@ struct iommu_domain {
 	struct iommu_dma_cookie *iova_cookie;
 	int (*iopf_handler)(struct iopf_group *group);
 	void *fault_data;
+	/*
+	 * Persisting and restoring across kexec via KHO.
+	 * 0 indicates non-persistent.
+	 */
+	unsigned long persistent_id;
 	union {
 		struct {
 			iommu_fault_handler_t handler;
@@ -518,7 +523,9 @@ static inline int __iommu_copy_struct_from_user_array(
  *                     IOMMU_DOMAIN_NESTED type; otherwise, the @parent must be
  *                     NULL while the @user_data can be optionally provided, the
  *                     new domain must support __IOMMU_DOMAIN_PAGING.
- *                     Upon failure, ERR_PTR must be returned.
+ *                     Upon failure, ERR_PTR must be returned. Persistent ID is
+ *                     used to save/restore across kexec; 0 indicates not
+ *                     persistent.
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
  *                       UNMANAGED, DMA, and DMA_FQ domain types.
  * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
@@ -564,7 +571,7 @@ struct iommu_ops {
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
 	struct iommu_domain *(*domain_alloc_user)(
 		struct device *dev, u32 flags, struct iommu_domain *parent,
-		const struct iommu_user_data *user_data);
+		unsigned long persistent_id, const struct iommu_user_data *user_data);
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
 						 struct mm_struct *mm);
-- 
2.34.1


