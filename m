Return-Path: <kvm+bounces-33015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4969E3A25
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C640B2B3A1
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81AD1B87EE;
	Wed,  4 Dec 2024 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kWuMXF5y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B341A1B87E3
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315378; cv=none; b=CIvubDU1cer/FLCwg5SNehBlx9dF0u7+X4wD4DUB1n8Eyzhs8JjniP6IHELsgZMTbRVycJS/S+l3HJg9kjk4Zf1WB2NuhT8qJOtc8Y8yRCtQtmgNW/dy9i3Tv5yaSzu5nP543jEd+oWlwP7oQPkzX47WVO0Gkj3tjz+Em4Auiw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315378; c=relaxed/simple;
	bh=VEF5JTZJ0HODvvZPNIWVl7SRFTtTIocoY5r3pvrFnt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BXYD1MscJCYHYPMZV27BrNPdVa3a8v5WOULkci7H9rCdxM7LChJWwn1fKBKRynuNEN/io1bhtZyae2nqsQyGBYHK9M/mAQB7TTgA4vULGkQ0EGPA8o0wcxO4qsjMW49JV7oOE7HNvzmOT5AyF7RBzjnumA/abTGIWQt80kufNZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kWuMXF5y; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733315376; x=1764851376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VEF5JTZJ0HODvvZPNIWVl7SRFTtTIocoY5r3pvrFnt4=;
  b=kWuMXF5yjKyyUjhjH8bINAfOhJNrcHr2tweWvvu6mx+aNM0lOZrxUtEJ
   ZCusduQwcOvMM/Ho7i2oBaXlL86awW5LqANa8ItZIkcJa5Ac8pMk2JU/a
   GMoHbAfC7gtgMbeeHW65PIaXD8btkbIcMW9ysiCkWoOuS36xmladhzIid
   r/G0mZFQ3x1aEuuKAsxPEd9tRQTkRtKg71snN7C/boAz4KaC49EejPUB7
   IXL00KL6jXkCljKdTipHflzWSyLJ89gAzxvnom1AYg9F5Y8mOZujp9mDB
   HK6uiUJt1xy2OAPmtoCDoTNoEh1DZuqPexLApVGkGgjBwzGaQ/ovBVUIV
   g==;
X-CSE-ConnectionGUID: LyIKszRrT8S4tkVL8HLOsg==
X-CSE-MsgGUID: jYQTOmRxS92k2u/n5u2+Uw==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="32937915"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32937915"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 04:29:34 -0800
X-CSE-ConnectionGUID: PpKwsQmmS9GInsg+umxAKA==
X-CSE-MsgGUID: JNjNj00nTdeXu0dzwCLnbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93599088"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 04 Dec 2024 04:29:33 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v6 6/7] iommu/amd: Make the blocked domain support PASID
Date: Wed,  4 Dec 2024 04:29:27 -0800
Message-Id: <20241204122928.11987-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241204122928.11987-1-yi.l.liu@intel.com>
References: <20241204122928.11987-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Remove PASID from old domain and device GCR3 table. No need to attach
PASID to the blocked domain as clearing PASID from GCR3 table will make
sure all DMAs for that PASID are blocked.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/iommu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3f691e1fd22c..7814ec98cf0c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2467,10 +2467,19 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
+					struct device *dev, ioasid_t pasid,
+					struct iommu_domain *old)
+{
+	amd_iommu_remove_dev_pasid(dev, pasid, old);
+	return 0;
+}
+
 static struct iommu_domain blocked_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev     = blocked_domain_attach_device,
+		.set_dev_pasid  = blocked_domain_set_dev_pasid,
 	}
 };
 
@@ -2893,7 +2902,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.def_domain_type = amd_iommu_def_domain_type,
 	.dev_enable_feat = amd_iommu_dev_enable_feature,
 	.dev_disable_feat = amd_iommu_dev_disable_feature,
-	.remove_dev_pasid = amd_iommu_remove_dev_pasid,
 	.page_response = amd_iommu_page_response,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
-- 
2.34.1


