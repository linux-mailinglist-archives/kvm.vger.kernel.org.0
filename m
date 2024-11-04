Return-Path: <kvm+bounces-30526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB819BB5C8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06D5A1C20D77
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EBA42AA9;
	Mon,  4 Nov 2024 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UFCfntvL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB141F942
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726442; cv=none; b=JuG8jgmjxT/NdNGxCBUXH4qyb6MckVrIs+bTGimFpMLkb4SjbRUSghqax5Wun7NduJZZaPLqzA00baxfOSemDxHD5nmUkbKpyJROyl6P5vWRh5WhgvDx5/ynz/tjAVlyfE4XagK5wsg7zwTXGFllaq3Zm4hZDgJETCH9JI4Ac5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726442; c=relaxed/simple;
	bh=KVVNqzJwZcqWIOZLJeNFFrvoYnsRSL5gYbyJzdsEuaE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tgiSShKvjFpwCbjkhs8k2gzjbhovTbvdsjqDWWiw1/Dwhgi484W/xOjhcqe0uE17StTFeP8aDHyE++xUvUBZu6zl83U2MWzsEfaZLIRSvGWlQJKB8Bdt8VaH/9zOVJQkShM84GihfRh1HX53Be/8riSWWIBPaZbJ1E/L0qDL60o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UFCfntvL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726440; x=1762262440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KVVNqzJwZcqWIOZLJeNFFrvoYnsRSL5gYbyJzdsEuaE=;
  b=UFCfntvLHZ5j23AyqZS256G80vVKB2pW3eiUv+1CPp4np/27ojTzl4FG
   rf20p2mgPQGuMhXQeo1AZHXuPhKJCzGRc85Gk3jAC5U0fPv8nq0GwM0Fp
   HUCgDENCU8uEa3t1tNGsMye37bU/vKcnKBvpjqeunS5TlQ7Pez/2oR4nF
   cdFMWpsEUA2KfLo5nc4zxOQPWpcj86tIZBxydMmnN81CBF9g1w2bL0Vf9
   vc8Bl+e1cXno6QnXEvDiqghb86H5HjY0oEu0m8qyBIwZVgB3bcQ7zP8gh
   9W9nRiy81fFlHHsDjJO7ODhN3NvkEd62x+QxXo0eW6IjOZTFWnxnV0QgV
   w==;
X-CSE-ConnectionGUID: 1snxp3pzRvyG2TMQS7Bg6Q==
X-CSE-MsgGUID: eiiJZf4GRKWsKbgQ6nz10Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883275"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883275"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:40 -0800
X-CSE-ConnectionGUID: njXVw/rvQpimk6Gp/H9rGQ==
X-CSE-MsgGUID: rV6Z7CncTdabYbRhPfdsJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099718"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:38 -0800
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
	will@kernel.org
Subject: [PATCH v3 3/7] iommu: Detaching pasid by attaching to the blocked_domain
Date: Mon,  4 Nov 2024 05:20:29 -0800
Message-Id: <20241104132033.14027-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132033.14027-1-yi.l.liu@intel.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu drivers are on the way to detach pasid by attaching to the blocked
domain. However, this cannot be done in one shot. During the transition, iommu
core would select between the remove_dev_pasid op and the blocked domain.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 21320578d801..e8b2850cc61f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3404,8 +3404,18 @@ static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 				   struct iommu_domain *domain)
 {
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_domain *blocked_domain = ops->blocked_domain;
+	int ret = 1;
+
+	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
+		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
+							 dev, pasid, domain);
+	} else if (ops->remove_dev_pasid) {
+		ops->remove_dev_pasid(dev, pasid, domain);
+		ret = 0;
+	}
 
-	ops->remove_dev_pasid(dev, pasid, domain);
+	WARN_ON(ret);
 }
 
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
@@ -3464,7 +3474,9 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	int ret;
 
 	if (!domain->ops->set_dev_pasid ||
-	    !ops->remove_dev_pasid)
+	    (!ops->remove_dev_pasid &&
+	     (!ops->blocked_domain ||
+	      !ops->blocked_domain->ops->set_dev_pasid)))
 		return -EOPNOTSUPP;
 
 	if (!group)
-- 
2.34.1


