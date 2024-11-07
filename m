Return-Path: <kvm+bounces-31107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BF29C05A3
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49CE81C22023
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4482521216B;
	Thu,  7 Nov 2024 12:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K24j9wL1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E55020FABB
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982164; cv=none; b=W3k6TkfxXFAejx/FMTvVscveZt4J8kk6dsBhgc9JzADZ1vLfKa2wIgaYTKTEuSEemNmaJZKjaUFa3MrMesOl4YImp/1X/ORAndgg1TL624HPFeKwo1pZyfAZeOri+SZYzVqCwv5lJKcwqjeFSEFuRniWvO1JgsMi64GaFKRYnhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982164; c=relaxed/simple;
	bh=StPLIHdHMILZf4wA2ehuHqX9QaXNphD0GtF6wSM9b0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lG0dw3nNxCh6wtVH9Op5mWi1rpt9Om64rKPKBodrquP7PWqG3Ca9FsUKFkphHEJJ2RI7mgIw4wUFjbTIN+PHCsVJulHWLavXCHMAut0yVV5rAon/riqqZAT4oCt6I3SIUMVe8xr5txJK6cR+NS0/PsotWxoWrSLFu4tf7xVqpQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K24j9wL1; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982162; x=1762518162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=StPLIHdHMILZf4wA2ehuHqX9QaXNphD0GtF6wSM9b0E=;
  b=K24j9wL1fWhclF1cwrGCnPbzD+hBFbXigBF3bcBD/xIMMalzzaEIdnrI
   R61uVeQDpoVIreQJ4P7iFGMTAxCLYLsR3dGLQwVuocsgCeShHkkzqWIus
   TlTtsrlPlFHeUht2htAKLGpXpumbAApn/pH05W7A7hHSxcwRpPNXx1iDj
   415xt7K6pFjUWAwYnC2cPXdVnXlhRzenLvnH6t3m8r+o346eh0b/TX7sH
   MDXzaYtgtXq3FNHdYkPEQJeO34R+OYxtIGS2464RGOuT5e88QSEmdIQAK
   oCnFjUM/HihNcb8hW45+vXN5J0WphCxgXefl8j+IBIlrMRfJo6sMg2cZB
   A==;
X-CSE-ConnectionGUID: A6xwKfd+R7SACJB6bMQhEQ==
X-CSE-MsgGUID: 4x9Wti0SQc+s7bxbRqo6vA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744639"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744639"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:39 -0800
X-CSE-ConnectionGUID: ERIkXcjETGyUlfyBWEEsWg==
X-CSE-MsgGUID: 8gF9pmLZTCulZ/6kCHo00A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180591"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:40 -0800
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
Subject: [PATCH v6 08/13] iommu/vt-d: Limit intel_iommu_set_dev_pasid() for paging domain
Date: Thu,  7 Nov 2024 04:22:29 -0800
Message-Id: <20241107122234.7424-9-yi.l.liu@intel.com>
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

intel_iommu_set_dev_pasid() is only supposed to be used by paging domain,
so limit it.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6b7f48119502..3c1b92fa5877 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4156,6 +4156,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	struct dev_pasid_info *dev_pasid;
 	int ret;
 
+	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
+		return -EINVAL;
+
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
@@ -4184,8 +4187,7 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 
 	domain_remove_dev_pasid(old, dev, pasid);
 
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
-		intel_iommu_debugfs_create_dev_pasid(dev_pasid);
+	intel_iommu_debugfs_create_dev_pasid(dev_pasid);
 
 	return 0;
 
-- 
2.34.1


