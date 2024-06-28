Return-Path: <kvm+bounces-20641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFBC91BA78
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CE56B22DCD
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BE314F117;
	Fri, 28 Jun 2024 08:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U2r/dkMY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850B714EC60
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 08:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719564942; cv=none; b=FBb/egjsVudT/mzrKPJ125c21HBB/5JZNj72oAAqPceOAXKDZm8L6+OX/dpcibsoqxW1qWd42ZPQFJc7TGN4SRv0szEfVL6UGzE+WoWuJo/dTmEPPwADQtp7kd3uIA6CfWINnPbQicHvguQLfGfR682FybPD9p4WrD2C/zsLM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719564942; c=relaxed/simple;
	bh=3U+Ux+E6qw1/ARk/9c3HYPu/nmaEIhQ/fDsaBM8zaZw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K9dNpEo0Hj/o55FAPUphl7Kr1tzT/EnyDA1c5EbJelI9xI0jF+wB1oIfbVbECCzejCensG44el29leGV1Yr6WnJpM6hNTI6HcDnztigOWcIDOKkS96X9NeZFBgmOEkYDTm1D5waKvXxdfNNdk3qIrSHkRlnq281qG6EPcnSEXvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U2r/dkMY; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719564940; x=1751100940;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3U+Ux+E6qw1/ARk/9c3HYPu/nmaEIhQ/fDsaBM8zaZw=;
  b=U2r/dkMYYQloG2L02JFflLg0y0IZNsYJICw7bwB7hedhZdmGUNBgF4+k
   6aqhX7PXq8fPninjzWJF4fv9HfamT1dXy/jxB8LsDzmZf9jwjJXIWmMUI
   SMRllQRTpopWyJhTYjJxGKImj4FfQYpKPHvbXQ5pP3fOoAnwUmf9R50hW
   1kI33u5kRpLtFLAGE3zYSAi7UxH69IRliVDn33xsgHOYl+4nTh+uQ0aQD
   TobWwx4h9h2B0N8GGBFuHH4HKzKfb+R5ui0EuoyPeA0AfLUmLm4GqqXxn
   zRAMIE0vfYN3FgmhOkh7XIN+53umNGKIdzxemOLjpOY9eEhdPT+gkrWrA
   g==;
X-CSE-ConnectionGUID: 8QaPwmvQQVSf4R33rFpA+A==
X-CSE-MsgGUID: 4YG0mkfFTXavDlHFjOSsAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="34277470"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="34277470"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 01:55:40 -0700
X-CSE-ConnectionGUID: x+vvwGnrT7SU3YKMj8VY2A==
X-CSE-MsgGUID: eZUubXSATg2Y6VcowTkU1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44584518"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 28 Jun 2024 01:55:40 -0700
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
	iommu@lists.linux.dev
Subject: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Date: Fri, 28 Jun 2024 01:55:32 -0700
Message-Id: <20240628085538.47049-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This splits the preparation works of the iommu and the Intel iommu driver
out from the iommufd pasid attach/replace series. [1]

To support domain replacement, the definition of the set_dev_pasid op
needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
should be extended as well to suit the new definition.

pasid attach/replace is mandatory on Intel VT-d given the PASID table
locates in the physical address space hence must be managed by the kernel,
both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
which allow configuring the PASID/CD table either in host physical address
space or nested on top of an GPA address space. This series only extends
the Intel iommu driver as the minimal requirement.

This series first prepares the Intel iommu set_dev_pasid op for the new
definition, adds the missing set_dev_pasid support for nested domain, and
in the end enhances the definition of set_dev_pasid op. The ARM and AMD
set_dev_pasid callbacks is extended to fail if the caller tries to do domain
replacement to meet the new definition of set_dev_pasid op.

This series is on top of Baolu's paging domain alloc refactor, where his
code can be found at [2].

[1] https://lore.kernel.org/linux-iommu/20240412081516.31168-1-yi.l.liu@intel.com/
[2] https://github.com/LuBaolu/intel-iommu/commits/vtd-paging-domain-refactor-v1

Regards,
	Yi Liu

Lu Baolu (1):
  iommu/vt-d: Add set_dev_pasid callback for nested domain

Yi Liu (5):
  iommu: Pass old domain to set_dev_pasid op
  iommu/vt-d: Move intel_drain_pasid_prq() into
    intel_pasid_tear_down_entry()
  iommu/vt-d: Make helpers support modifying present pasid entry
  iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
    replacement
  iommu: Make set_dev_pasid op support domain replacement

 drivers/iommu/amd/amd_iommu.h                 |   3 +-
 drivers/iommu/amd/pasid.c                     |   6 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
 drivers/iommu/intel/debugfs.c                 |   2 +
 drivers/iommu/intel/iommu.c                   | 117 ++++++++++++------
 drivers/iommu/intel/iommu.h                   |   3 +
 drivers/iommu/intel/nested.c                  |   1 +
 drivers/iommu/intel/pasid.c                   |  46 +++----
 drivers/iommu/intel/pasid.h                   |   5 +-
 drivers/iommu/intel/svm.c                     |   9 +-
 drivers/iommu/iommu.c                         |   3 +-
 include/linux/iommu.h                         |   5 +-
 12 files changed, 132 insertions(+), 74 deletions(-)

-- 
2.34.1


