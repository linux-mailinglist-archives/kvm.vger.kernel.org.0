Return-Path: <kvm+bounces-47946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1B9AC782E
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37D631C203DE
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B38263C91;
	Thu, 29 May 2025 05:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eHfukW4g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B045E2550D2;
	Thu, 29 May 2025 05:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497397; cv=none; b=T2uuvf1icyte/H5xUxm6zsJLSJrE9db9Tzz+zW1hZTPNHkqLTjkH+RHnT7ZMeYodkeRqXdx5mjLHpKZhO7IkDn0HbBh5wbPrYFWR5uuUhgsbZ7fvgfXuAhnW4RrZygdSy0xvJR8Nu00atvGaxNxOmkARowwG0R6aBLRru1noVn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497397; c=relaxed/simple;
	bh=yZxllDmS71frgFYePwIFmAbgOkfQeZNetfNQ4GrvCjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ta0sSAAuDzcsm+F24dDJ7I2VhG2JK2ckfZ7PcGdqNxsSB0GlmxJ4yTk2YZmjwlrCriiILpOmgWGYzX9meglDKBM1ARtE7tA5hrRMRvhkUn5TaNQ95VtYpLrO2yX4AqrySe51oLC45S8dCAA0WPJvsNUYW2aD+Teb5RntJk/CdJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eHfukW4g; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497396; x=1780033396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yZxllDmS71frgFYePwIFmAbgOkfQeZNetfNQ4GrvCjw=;
  b=eHfukW4gflWBoIkXvfe2M1bjF7vltpRCgx18yXA2wVzvJ+lRZkCxoJ4J
   iqkDtDZSLfkRSPD/1LJ0ODxd1sjh4Zt9/fqiFBYMCL9g60aPlSWFHh6mE
   k7deFwyNchrwXivIDewVv+D2wGpSbLirR+tjtjmBqOFGiPtHA1U+vxfHR
   AQHNdqs+y+fspgQS1A/Qh89RIHbqpYCF5NfnuXP+0FSzRNWBT5Vlr5OUz
   +L0bl6Kwccvb4EiKAaPgQUqA02U+RyDirETw3PP7HXS2yLRUWbWzOB79f
   7DMkyZsK1ZfJ8EbQiPKRQnqf1C+8oG4yoYzzadvIy91rIsS5GmpUnJJM7
   w==;
X-CSE-ConnectionGUID: 3Bpti7sET8mH4upW0Ml8lw==
X-CSE-MsgGUID: 6eJEecCLTBqVz2VDjE5GKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963185"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963185"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:43:15 -0700
X-CSE-ConnectionGUID: Fs3ze9vgS0+10ukv3r/wgw==
X-CSE-MsgGUID: egJESrszQraMvZPOBy2wlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443413"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:43:08 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 15/30] fixup: iommu/selftest: Sync .viommu_alloc() change to selftest
Date: Thu, 29 May 2025 13:34:58 +0800
Message-Id: <20250529053513.1592088-16-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sync up the additional struct kvm * parameter.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/iommu/iommufd/selftest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index d070807757f2..90e6d1d3aa62 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -734,6 +734,7 @@ static struct iommufd_viommu_ops mock_viommu_ops = {
 };
 
 static struct iommufd_viommu *mock_viommu_alloc(struct device *dev,
+						struct kvm *kvm,
 						struct iommu_domain *domain,
 						struct iommufd_ctx *ictx,
 						unsigned int viommu_type)
-- 
2.25.1


