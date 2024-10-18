Return-Path: <kvm+bounces-29143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E149A34EF
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5887428539D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F4E189B9D;
	Fri, 18 Oct 2024 05:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fgNUZdyZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F439188A06
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231110; cv=none; b=EiMmTqn7AZEHEmoiKs2zTSPGXAPFI0qw0PRiVERaDCcKVIgHXrxR/6rOqhL6sWGzcjqzHfR1sIOV5tAxGbR1UfT0zf//O43zF6kEWdhmVsV+gmqEBhqwPSBtTGfBYlg0mgvp7KrWW4G0g4e3tnet75iqnTbSHfiati2SiULXVVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231110; c=relaxed/simple;
	bh=1d3TsI4vymaiOMQGByLF7JVCA3jll3YyxdnZnCcwgPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gn4G6miq3m19mLGqi8i5zPoqaH7bVIH/cq4DNi/MnZwrEV5eXrbZTuHAYvMoRlAKZpSJhinwIC//fhYLg+pFJqHF+PHwh3cDouLsHmlnXtANUWoF+twL/9XtyCfRQi2NOCgIdd8VIiFBmOqzNS0n3DLpBijfs3j5jb8kDAOmU+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fgNUZdyZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729231109; x=1760767109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1d3TsI4vymaiOMQGByLF7JVCA3jll3YyxdnZnCcwgPU=;
  b=fgNUZdyZSex3KdP4Yy/yJZiXHhdGAEZuiggNlDv5ebhHuutsDhkxk93f
   u+7+Hw0HAMkM3ObeZHOqTTLjrfUV6wO4KyQZZfjprbeCZ5ttTC1NIoEap
   58Cp+1YlMTEKciQgHoh0C2NN9AwLVYba4zMBPbMMmM5qnFIHnVDc0Io+Z
   4Osk266d1Bf6NoM+lFW3fxzt2yVQ0eWvcpKyv7QdTXl4QfIneLzSO5EiL
   wzkTsHRBsnPEOVoTkbU6Ea/i9aS62FAd2bRXY2P4n+XHTmxQitYr37qAo
   /dsxr2JIQXsBH8sqqx76AMkOflcm3xMGY3+n0sk0GblKzZgAjblBHzkSs
   g==;
X-CSE-ConnectionGUID: 8aWba9LKRtOGBrnn2GIMLQ==
X-CSE-MsgGUID: 60K4DaH/RtOFJ0Tqylataw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39879138"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39879138"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:58:28 -0700
X-CSE-ConnectionGUID: QNvYhXqTScaYVOYvaAkHWw==
X-CSE-MsgGUID: uoNzn0OOTFWZITBkAYCikg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="78675735"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa009.jf.intel.com with ESMTP; 17 Oct 2024 22:58:28 -0700
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
Subject: [PATCH v2 3/3] iommu/vt-d: Make the blocked domain support PASID
Date: Thu, 17 Oct 2024 22:58:24 -0700
Message-Id: <20241018055824.24880-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241018055824.24880-1-yi.l.liu@intel.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 19 +++++++++++++------
 drivers/iommu/intel/pasid.c |  3 ++-
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d089ac148a7e..f814fadcf34e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3412,10 +3412,15 @@ static int blocking_domain_attach_dev(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old);
+
 static struct iommu_domain blocking_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= blocking_domain_attach_dev,
+		.set_dev_pasid	= blocking_domain_set_dev_pasid,
 	}
 };
 
@@ -4282,8 +4287,9 @@ static void domain_remove_dev_pasid(struct iommu_domain *domain,
 	kfree(dev_pasid);
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-					 struct iommu_domain *domain)
+static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
@@ -4292,10 +4298,12 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 				    INTEL_PASID_TEARDOWN_DRAIN_PRQ);
 
 	/* Identity domain has no meta data for pasid. */
-	if (domain->type == IOMMU_DOMAIN_IDENTITY)
-		return;
+	if (old->type == IOMMU_DOMAIN_IDENTITY)
+		goto out;
 
-	domain_remove_dev_pasid(domain, dev, pasid);
+	domain_remove_dev_pasid(old, dev, pasid);
+out:
+	return 0;
 }
 
 static struct dev_pasid_info *
@@ -4653,7 +4661,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.dev_disable_feat	= intel_iommu_dev_disable_feat,
 	.is_attach_deferred	= intel_iommu_is_attach_deferred,
 	.def_domain_type	= device_def_domain_type,
-	.remove_dev_pasid	= intel_iommu_remove_dev_pasid,
 	.pgsize_bitmap		= SZ_4K,
 #ifdef CONFIG_INTEL_IOMMU_SVM
 	.page_response		= intel_svm_page_response,
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index ce0a3bf701df..abf2f54e847e 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -238,7 +238,8 @@ devtlb_invalidation_with_pasid(struct intel_iommu *iommu,
 
 /*
  * Caller can request to drain PRQ in this helper if it hasn't done so,
- * e.g. in a path which doesn't follow remove_dev_pasid().
+ * e.g. in a path which doesn't follow the set_dev_pasid() op of the
+ * blocked domain.
  * Return the pasid entry pointer if the entry is found or NULL if no
  * entry found.
  */
-- 
2.34.1


