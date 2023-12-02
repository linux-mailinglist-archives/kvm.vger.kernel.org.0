Return-Path: <kvm+bounces-3227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E93801BD4
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 825F8281E1E
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B9813AF3;
	Sat,  2 Dec 2023 09:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avJdL1ij"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D84134;
	Sat,  2 Dec 2023 01:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510584; x=1733046584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Lo5VlYM9pcr8va0tr3dWmZ/2vpXpVd1PrW/H2X7PBXI=;
  b=avJdL1ijTwbTKlTIlEeFphxcjD+BQDaAQYMOEHo6LKb+6R77offDuTjp
   Kv18skulvLIg3B+yEDvGTXVUaM/kssdH+Eo99j/S0QzBygQaj2I9MqWyx
   tIqtJFtq0rp1fHe4syDerp9AWm2m1aW6IK7A9/A+alkLEABb8VM4Ak6yO
   zasIih/PIMSYxTTLGBX8YYDBKD/lO/7EXfa753eLjb/xwZm6CVvfm2q65
   TpcI9w+uy25oEr/7v2N/TGNO9KOKSfcDvrp83IENeFcEWJ2GD4kJpf//I
   i/VaqBSmyv1NCCMibMeJZWSiHJXmOoAX+dnAeDeNRz4QxKLSTWp3riT40
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="392459180"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="392459180"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:49:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="887937515"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="887937515"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:49:36 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 11/42] iommu: Add new domain op cache_invalidate_kvm
Date: Sat,  2 Dec 2023 17:20:41 +0800
Message-Id: <20231202092041.14084-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On KVM invalidates mappings that are shared to IOMMU stage 2 paging
structures, IOMMU driver needs to invalidate hardware TLBs accordingly.

The new op cache_invalidate_kvm is called from IOMMUFD to invalidate
hardware TLBs upon receiving invalidation notifications from KVM.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0ce23ee399d35..0b056d5a6b3a3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -636,6 +636,9 @@ struct iommu_ops {
  *                         forward a driver specific error code to user space.
  *                         Both the driver data structure and the error code
  *                         must be defined in include/uapi/linux/iommufd.h
+ * @cache_invalidate_kvm: Synchronously flush hardware TLBs for KVM managed
+ *                        stage 2 IO page tables.
+ *                        The @domain must be IOMMU_DOMAIN_KVM.
  * @iova_to_phys: translate iova to physical address
  * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
  *                           including no-snoop TLPs on PCIe or other platform
@@ -665,6 +668,8 @@ struct iommu_domain_ops {
 	int (*cache_invalidate_user)(struct iommu_domain *domain,
 				     struct iommu_user_data_array *array,
 				     u32 *error_code);
+	void (*cache_invalidate_kvm)(struct iommu_domain *domain,
+				     unsigned long iova, unsigned long size);
 
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    dma_addr_t iova);
-- 
2.17.1


