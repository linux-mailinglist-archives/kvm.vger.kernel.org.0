Return-Path: <kvm+bounces-31753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EB29C714A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D82101F22FA7
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4051B1FF05A;
	Wed, 13 Nov 2024 13:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cS7C+pNK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3431EB39
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505577; cv=none; b=qmjI2X+I+usczF1RNtO6E9VlhUNjZUOuc8JcU6y1+lSdq//CJ9N/EUNxHJHKx43o0WK1Z0TeoxqdjzsSoDAUihQxWZLWSKvwqylEfxbtN7WzBr0wdSlRs075BCOLqOQK+GuQyfuJhABfATyGLv4tyojR9QChiGdb5SpupCm41hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505577; c=relaxed/simple;
	bh=8O0UPd4f0xiTKsDYtaxlewWERwRuyZEzf6mwe09KVnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hfEdXphDqWZ6jqyOsf3SCP513SSmARNQhaiAErvy88GBKLbYKKgCV9m9Yz6CfxxgqaY5Xa7/DVgLaEiP2bAG5azUWP2B9EA0NFH0PtGPdh/ZPYU62bYSq3o3wfJf6r50G5dz13M1LobpP/1QjPFdkQ759nNP8IHOeP+yRs674v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cS7C+pNK; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731505575; x=1763041575;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8O0UPd4f0xiTKsDYtaxlewWERwRuyZEzf6mwe09KVnQ=;
  b=cS7C+pNKuosli/sxWi2M9Jr84XBgpE9ae7+1eXZi2VTh148b+TLKtH+h
   Ncmd9urpgAK7P7wGLTJUU3peX657sMTfg7E3eFzKsX9Kw7nAYPKaHiYP1
   y+DHqDswjUV3b4r+2Qqs7sadPWkA6wOzf5GnPv5V7F3ndhK4J9EC4xVep
   LAAN6/DbHOLx4PhnbNera01Ei2Cl99nyrKTdJphXTBvnVMKtpray9Ntm0
   29AOQq+UAKP2bFy/Q1KQ8hbvVVANXSUfGxYOmRKIe9nq7kCerodV29PlZ
   6BM4vAkTk6nEzHZ2DYYLQAGz2JsgEGqrzDzKt5DYtvweprTdJ2MJFp/lg
   g==;
X-CSE-ConnectionGUID: cYtcifgJRBaDLEfU+NTcCA==
X-CSE-MsgGUID: 3IoC55NpRQSr1cbAUZb0Jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42025677"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42025677"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 05:46:15 -0800
X-CSE-ConnectionGUID: X/Q2Pfc8SWuAP3AGOcT49w==
X-CSE-MsgGUID: PFBwHNWtSqurKZ8fMl3MsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="87445581"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2024 05:46:14 -0800
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
Subject: [PATCH v5 0/7] Support attaching PASID to the blocked_domain
Date: Wed, 13 Nov 2024 05:46:06 -0800
Message-Id: <20241113134613.7173-1-yi.l.liu@intel.com>
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

This series makes the Intel iommu driver, ARM SMMUv3 driver and AMD iommu
driver support attaching PASID to the blocked domain. And in the end remove
the remove_dev_pasid op from iommu_ops.

[1] https://lore.kernel.org/linux-iommu/20240816130202.GB2032816@nvidia.com/
[2] https://lore.kernel.org/linux-iommu/20241108021406.173972-1-baolu.lu@linux.intel.com/

v5:
 - Fix an issue spotted by Baolu in patch 01 of v4. The new version lifts the
   group check to be the first check, hence it can ensure a valid iommu_ops
   returned by dev_iommu_ops(). Per this changes, it also removes the
   dev_has_iommu() check as it is duplicated with the group check. Due to the
   changes, drop the r-b tags on this patch.
 - Add Baolu's r-b tag.

v4: https://lore.kernel.org/linux-iommu/20241108120427.13562-1-yi.l.liu@intel.com/
 - Remove unnecessary braces in patch 02 (Vasant)
 - Minor tweaks to patch 01 and 03 (Kevin)
 - Add r-b tags from Jason, Vasant, Kevin

v3: https://lore.kernel.org/linux-iommu/20241104132033.14027-1-yi.l.liu@intel.com/
 - Add a patch to check remove_dev_pasid() in iommu_attach_device_pasid()
 - Split patch 01 of v2 into two patches, drop the r-b of this patch due the
   split.
 - Add AMD iommu blocked domain pasid support (Jason)
 - Remove the remove_dev_pasid op as all the iommu drivers that support pasid
   attach have supported attaching pasid to blocked domain.

v2: https://lore.kernel.org/linux-iommu/20241018055824.24880-1-yi.l.liu@intel.com/#t
 - Add Kevin's r-b
 - Adjust the order of patch 03 of v1, it should be the first patch (Baolu)

v1: https://lore.kernel.org/linux-iommu/20240912130653.11028-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Make the blocked domain support PASID

Yi Liu (6):
  iommu: Prevent pasid attach if no ops->remove_dev_pasid
  iommu: Consolidate the ops->remove_dev_pasid usage into a helper
  iommu: Detaching pasid by attaching to the blocked_domain
  iommu/vt-d: Make the blocked domain support PASID
  iommu/amd: Make the blocked domain support PASID
  iommu: Remove the remove_dev_pasid op

 drivers/iommu/amd/iommu.c                   | 10 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 +++----
 drivers/iommu/intel/iommu.c                 | 15 ++++++---
 drivers/iommu/iommu.c                       | 35 +++++++++++++--------
 include/linux/iommu.h                       |  5 ---
 5 files changed, 48 insertions(+), 29 deletions(-)

-- 
2.34.1


