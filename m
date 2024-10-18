Return-Path: <kvm+bounces-29130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57D3A9A34D2
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 875B41C20AF5
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE9C184528;
	Fri, 18 Oct 2024 05:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bH3UepUg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D51547C3
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230846; cv=none; b=mGZZ0umBLP2TXsgkgECoPGlsL9gSslqzBDEpeysIfp+7cbtGErItl/3x8G9IjYHfIP9ceudHMgVcPYkEmMhlDxvy46cCUVVn4Z59WRvddLAA7wKC4J4IlM4bLyyXp5Nn219EmWldVOZZsalx6asqRYy5vPFzMdCwZWdblri6oiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230846; c=relaxed/simple;
	bh=nWySUEwdZ0+DrN8a8Ux1UxIrk8MUMeS39WR4TFtGPFE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zffl7k9HRnwnYXvyAuXx9H6b4spEko22YSceJhawf/wTYQsJ/iLgKl8UAnql7F3f4HOQoxu55STAbA1OrgcDmXziFfoApyS2a2NNfCQ8XB4LJNxd4kjxtnN+GCAmG0baJzk7WFcmJ9yQbr+v4NfyrSIYdQKLtheWENT9bUc3RI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bH3UepUg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230845; x=1760766845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nWySUEwdZ0+DrN8a8Ux1UxIrk8MUMeS39WR4TFtGPFE=;
  b=bH3UepUgu4olHO0XwByaLPisMePRM+KVyngq0K8eqeuMyKPBtEoXP/TA
   yLJ53Ib/3KDyKQiB29wkJ70eQRR9qNoMnEwU/Ak48t/WAR4B+jjegMEt+
   yAPemCYTvlleytOergwjUDQlO0rX5KKQADnRRTUF2dgVZILb7dO7JBg46
   pHFL343dGUtnaVGgMruevo7ihU01x/2oFv0TokTvuidZcIdhl0HAvcoFZ
   68bkJRnpd7PfV5fe7hjfeygvlyLKAJYUUqXON7uJn7D0+h4wJSu4uu6QN
   L400CxKCkjqQONDCp3Sk7mdoA3LuPnl2anaJ/wfogaLtb57A8LJtoKbTe
   A==;
X-CSE-ConnectionGUID: oUVSNdOPSeiBQPcZy7Zf0w==
X-CSE-MsgGUID: qDy8mf8oSIW7GoWNCDEDGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708764"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708764"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:04 -0700
X-CSE-ConnectionGUID: YJI7/+vvS3mPQ5dYHHCqxw==
X-CSE-MsgGUID: wNiECL3bSaCFk9ocAYWwVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188549"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:04 -0700
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
Subject: [PATCH v3 0/9] Make set_dev_pasid op supporting domain replacement
Date: Thu, 17 Oct 2024 22:53:53 -0700
Message-Id: <20241018055402.23277-1-yi.l.liu@intel.com>
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

This series first prepares the Intel iommu set_dev_pasid op for the new
definition, adds the missing set_dev_pasid support for nested domain, makes
ARM SMMUv3 set_dev_pasid op to suit the new definition, and in the end
enhances the definition of set_dev_pasid op. The AMD set_dev_pasid callback
is extended to fail if the caller tries to do domain replacement to meet the
new definition of set_dev_pasid op. AMD iommu driver would support it later
per Vasant [2].

[1] https://lore.kernel.org/linux-iommu/20240412081516.31168-1-yi.l.liu@intel.com/
[2] https://lore.kernel.org/linux-iommu/fa9c4fc3-9365-465e-8926-b4d2d6361b9c@amd.com/

v3:
 - Add Kevin and Jason's r-b to patch 01, 02, 04, 05 and 06 of v2
 - Add back the patch 03 of v1 to make the pasid setup helpers do all the pasid entry
   modification, hence the set_dev_pasid path is really rollback-less, which is spotted
   by Baolu.
 - Rename prepare_domain_attach_device() (Baolu)
 - Use unsigned int instead of u32 for flags (Baolu)
 - Remove a stale comment in arm_smmu_set_pasid (Will)

v2: https://lore.kernel.org/linux-iommu/20240912130427.10119-1-yi.l.liu@intel.com/
 - Make ARM SMMUv3 set_dev_pasid op support domain replacement (Jason)
 - Drop patch 03 of v1 (Kevin)
 - Multiple tweaks in VT-d driver (Kevin)

v1: https://lore.kernel.org/linux-iommu/20240628085538.47049-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Make set_dev_pasid() op support replace

Lu Baolu (1):
  iommu/vt-d: Add set_dev_pasid callback for nested domain

Yi Liu (7):
  iommu: Pass old domain to set_dev_pasid op
  iommu/vt-d: Move intel_drain_pasid_prq() into
    intel_pasid_tear_down_entry()
  iommu/vt-d: Let intel_pasid_tear_down_entry() return pasid entry
  iommu/vt-d: Make pasid setup helpers support modifying present pasid
    entry
  iommu/vt-d: Rename prepare_domain_attach_device()
  iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
    replacement
  iommu: Make set_dev_pasid op support domain replacement

 drivers/iommu/amd/amd_iommu.h                 |   3 +-
 drivers/iommu/amd/pasid.c                     |   6 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  12 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 drivers/iommu/intel/iommu.c                   | 128 ++++++++++++------
 drivers/iommu/intel/iommu.h                   |   7 +-
 drivers/iommu/intel/nested.c                  |   3 +-
 drivers/iommu/intel/pasid.c                   |  82 ++++++-----
 drivers/iommu/intel/pasid.h                   |   9 +-
 drivers/iommu/intel/svm.c                     |   6 +-
 drivers/iommu/iommu.c                         |   3 +-
 include/linux/iommu.h                         |   5 +-
 13 files changed, 163 insertions(+), 108 deletions(-)

-- 
2.34.1


