Return-Path: <kvm+bounces-29140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D779A34EC
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A52BB1C20F05
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8066817E8F7;
	Fri, 18 Oct 2024 05:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5wttA5J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB217E918
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231107; cv=none; b=q5Cmun7YD75aU5VITu2agq/UsXG97U+T+7waBpc0TMvrI4uJhGfGV8v0MMpOPzdDW3sSXfxKDg5gVw2CDN3u9970vu07zdT8X9glwBcFYJ9Lgfcnx81/tTLJ6ITPTys75O8CoeiElaRT8MVF7s64eJSEaZ0y4LZjScmd42HDTfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231107; c=relaxed/simple;
	bh=anh/7ifcMitvfZ8PgN/A+zUPUjBS0XS75RBtInw9vVU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=euulqs7lyo98+eS3o1WWnAoKE6HgtlZAh/U2z10aEbuA4/NN5GjmMSwqYasLDKwRF1l8CMAzm5mYdHgRG4XzbMS/Lg3ku4R+BR3E0dUgU7nvmSJ97IQAuoXwHTb3inkckI6xKwdYWx29GjaAdmD164RpBOxRJccuAT8wvxoak1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5wttA5J; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729231106; x=1760767106;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=anh/7ifcMitvfZ8PgN/A+zUPUjBS0XS75RBtInw9vVU=;
  b=G5wttA5JQIKCsBOEsmh9yljYhZhvABpR0fWixeNfRLqhbHinlft9rteX
   4LzAd/QLwuGChyi5milKI7zZpWG3D1aJluvrW4K37L+6hJe0PG5MPxzPW
   xiKKC93RJ1Adv0QJlHWzG9ABTbu++mMCV1oSH8XJvoKTuxS7Ls0m/4O0c
   nDb4kfmFpZA1OJ1tG8O35LKEve6MahxeZdZgnJuPpT3VpSMBA5Q7acknR
   7AZGxtJ9rwMRZ+AzGSBN2n+Gt4aZyGnISpacbINfksvSH1uogt55dMSjz
   rXKXK59XOWdljo7bfW6qJ1Lkg+gEYU/ZYajo08bajq8uwlbBf4kW2Jp97
   Q==;
X-CSE-ConnectionGUID: aVgzw0M/T4y6xjtdwEVAfg==
X-CSE-MsgGUID: XhjKgXfnTkuYhRY7xPgo7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39879114"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39879114"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:58:26 -0700
X-CSE-ConnectionGUID: 6mJ9z1/kTJ2/jOAHTNUAuw==
X-CSE-MsgGUID: VqAYaTPIT3qEVZSbSqDydA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="78675715"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa009.jf.intel.com with ESMTP; 17 Oct 2024 22:58:25 -0700
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
Subject: [PATCH v2 0/3] Support attaching PASID to the blocked_domain
Date: Thu, 17 Oct 2024 22:58:21 -0700
Message-Id: <20241018055824.24880-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During the review of iommufd pasid series, Kevin and Jason suggested
attaching PASID to the blocked domain hence replacing the usage of
remove_dev_pasid() op [1]. This makes sense as it makes the PASID path
aligned with the RID path which attaches the RID to the blocked_domain
when it is to be blocked. To do it, it requires passing the old domain
to the iommu driver. This has been done in [2].

This series makes the Intel iommu driver and ARM SMMUv3 driver support
attaching PASID to the blocked domain. While the AMD iommu driver does
not have the blocked domain yet, so still uses the remove_dev_pasid() op.

[1] https://lore.kernel.org/linux-iommu/20240816130202.GB2032816@nvidia.com/
[2] https://lore.kernel.org/linux-iommu/20241018055402.23277-2-yi.l.liu@intel.com/

v2:
 - Add Kevin's r-b
 - Adjust the order of patch 03 of v1, it should be the first patch (Baolu)

v1: https://lore.kernel.org/linux-iommu/20240912130653.11028-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Make the blocked domain support PASID

Yi Liu (2):
  iommu: Add a wrapper for remove_dev_pasid
  iommu/vt-d: Make the blocked domain support PASID

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++-----
 drivers/iommu/intel/iommu.c                 | 19 ++++++++-----
 drivers/iommu/intel/pasid.c                 |  3 ++-
 drivers/iommu/iommu.c                       | 30 ++++++++++++++++-----
 4 files changed, 45 insertions(+), 19 deletions(-)

-- 
2.34.1


