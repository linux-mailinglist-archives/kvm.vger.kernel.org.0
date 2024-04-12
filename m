Return-Path: <kvm+bounces-14404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C26A8A2904
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B23A3B255A8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4BB524B4;
	Fri, 12 Apr 2024 08:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XwsePGJM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE6E5102B
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909740; cv=none; b=Vz4e7at1apGsKwhKOttwc45SU/9nT4/Hbl47io/Gb9SJ7GWhx5G1Ed0Xy0g5qzEi/2hyygZeBUii53SsdYG/yijSG2kuEyHRiVEBwnZlJuyKEMFCF0jr9BMlUGhtZmmSCywTH6sBpTbHtxD/r8VuURSYWtNDV50OEOgikc3zKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909740; c=relaxed/simple;
	bh=VbKNr1VzuHL0JQ6LpoEN602hRMaWoWJn/sxBUpLCH6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EuCi4rVOf25jGUlah+gxADNUgFdhu8d11OoeLxkH6gpXdLdKapGzO9yWa0Eaz9UKTTVz6sAl2LgaBx/rBl2YJ0S6dXGpOYDcJa/pdGbI2URrNnDaO/TZNzNo8VVQ7uyFTDct2Hr5OFsIsmAjNx6KDMZN3RHTXxOByt6GvPnoX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XwsePGJM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909739; x=1744445739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VbKNr1VzuHL0JQ6LpoEN602hRMaWoWJn/sxBUpLCH6w=;
  b=XwsePGJMXFT/4fBnAGaJv5W/KXSd1EYD3ZhYWNKBgprtEwBhkxs8eOta
   9x1wThxwGYd0hn6U6hQDlzGUZH5mOVn+xbKjk0SuYHGGwfTQdR0aBHR9k
   IBymcA0IhQgxPJ4k8Gzkc0M6UyVMoq3nKAENVykTdbvfIpWidSVQpf9h+
   18o6CCYfwk1aSbD7D0nqqwp3E939r5cpJ23eXS6LxvQPU41JPlVaKMw4u
   ppvFzmgQ8PCljBto+1UD33yzewCPXEbBEofSGuN67l13TnF8FS9YS6dcV
   Mf6vhQB/pm2mYeW4M81J/qVHheCi1mjaC/Vqn4lsKMFu4pZT1In7x7wfZ
   w==;
X-CSE-ConnectionGUID: /s+7or3sT3CqzQvQ64nIZA==
X-CSE-MsgGUID: 2RJUyYEiSEmNvLNWKX8Ojg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465107"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465107"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:38 -0700
X-CSE-ConnectionGUID: r6KZQcsvTkWjs995ZdOV9g==
X-CSE-MsgGUID: l3tgAg2aRHeBQ2zY932b0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137877"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:36 -0700
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
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in domain
Date: Fri, 12 Apr 2024 01:15:14 -0700
Message-Id: <20240412081516.31168-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412081516.31168-1-yi.l.liu@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
is fine, but no need to go further as nothing to be cleanup and also it
may hit unknown issue.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index df49aed3df5e..fff7dea012a7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4614,8 +4614,9 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 			break;
 		}
 	}
-	WARN_ON_ONCE(!dev_pasid);
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	if (WARN_ON_ONCE(!dev_pasid))
+		return;
 
 	domain_detach_iommu(dmar_domain, iommu);
 	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
-- 
2.34.1


