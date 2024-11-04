Return-Path: <kvm+bounces-30537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13DD19BB5F0
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F650B227B5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7371713B2A8;
	Mon,  4 Nov 2024 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bb/c312P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5AA137932
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726723; cv=none; b=l4hpBZIzwhk8Zj66GdGmOuDP4uPX4FZqjX+ZASmT7x8EYDWbKD0csQrUneVnSri/KITVKckHBx+0GEg/3polRzMEd2Gvw/Ed4nBKEnNvB+K0vN2Nbi9U0VccHvLz3P7ND+UxFX10JbeAsCpOtBxOxqA3BC+UG+vtwM7bv6IW42U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726723; c=relaxed/simple;
	bh=Bkqe8VrNbl1SWe3S/JPTAXM5/6kLm2sQVOQqXRBjpfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TY6fI5UXsb34D+yeaYDeOGtGMc6MAVNHoFun4CLh5oiPcL0jQB7h+q4xgd95Apyeilng5ee836/etCJ+B2e2Cp5sG928Yp8w1rrWxlh/YMeBeymH2ojq1iktpwy5sKrFNFUpA7P5J/FykMmxRg7HjM/e/7giLiDYAOB5loUI2nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bb/c312P; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726722; x=1762262722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bkqe8VrNbl1SWe3S/JPTAXM5/6kLm2sQVOQqXRBjpfw=;
  b=bb/c312PDdV//f43FIPybGPJqiGFcj1fgj2vvpvLZKuz/IDyHBx2HDch
   1ISPfVf5jMc2ffmABYt9gypNxeLxPxZU4kKoJlzfZDKUKu5l5euiSEVTj
   JlIfeWSgvkNse5oFVKi/ALu8J8nkkw0sCJGGfVbbL3MyAtOAesclsoCOA
   4ZY0R0231PbwXXY7ciLhS1tMJBG8vjTkeef1SxwRUZTTl4duMwEpGMdge
   MeBXmWoElp+H/E3QnZ+DoJ4Q7cZiIXM0eOdHfYue/uOlni1KBqAsw9dO/
   JR95RJihlMEaHAL5RMWpvW4o6QtmxzcSz5GLsItdg4ZKpHgH0EdZwQEBf
   w==;
X-CSE-ConnectionGUID: EzD6Ct7rRXCpXZSpDKszEg==
X-CSE-MsgGUID: S4p9/c6kTdG2/XEj/rfUmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884064"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884064"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:20 -0800
X-CSE-ConnectionGUID: WNzAQN2rRvqTXEZeeiD0hw==
X-CSE-MsgGUID: QN1Edy9yQTSzYZTiSoRFKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100461"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:19 -0800
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
	vasant.hegde@amd.com
Subject: [PATCH v5 07/12] iommufd: Allocate auto_domain with IOMMU_HWPT_ALLOC_PASID flag if device is PASID-capable
Date: Mon,  4 Nov 2024 05:25:08 -0800
Message-Id: <20241104132513.15890-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132513.15890-1-yi.l.liu@intel.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iommufd cannot predict if user will use pasid or not, but if user is
going to use it, the domains used by PASID-capable device should be
allocated with IOMMU_HWPT_ALLOC_PASID flag.

For domain allocated per userspace request, user should provide this
flag. While for the auto_domain, iommufd needs to make it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 4e7a473d0dd0..a52937fba366 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -650,7 +650,9 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev, ioasid_t pasid,
 		goto out_unlock;
 	}
 
-	hwpt_paging = iommufd_hwpt_paging_alloc(idev->ictx, ioas, idev, 0,
+	hwpt_paging = iommufd_hwpt_paging_alloc(idev->ictx, ioas, idev,
+						idev->dev->iommu->max_pasids ?
+						IOMMU_HWPT_ALLOC_PASID : 0,
 						immediate_attach, NULL);
 	if (IS_ERR(hwpt_paging)) {
 		destroy_hwpt = ERR_CAST(hwpt_paging);
-- 
2.34.1


