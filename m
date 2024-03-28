Return-Path: <kvm+bounces-13007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF27788FF00
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0BAE1C24165
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC357F489;
	Thu, 28 Mar 2024 12:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0hPxs/6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D365B1EE
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 12:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711629002; cv=none; b=mneYvdWXd+zrAh1O1uqjwW6Fb/PNQEZvWQkucM50ti891HA0XAn71FoySm5WYam3tMPhJoSWjENkePHUBHUqflvqLxxR0yDbBGRPpABZtTkHyoem8H34rukfGHl7FwRTG1ODsduR6+oStOwXfb8tRlss3xSS3D/HFTHPFOh70qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711629002; c=relaxed/simple;
	bh=V4X5Mgzj5RO3nYJCCI8M8/zfMP4g0aia9ewIHZHCjIM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uf2MeF3gLxlrFO2cS7B+Y0ws78qNYEUebmYGWCIRfxQf6ZLGXfFPJRVf7Lk4SnUENluyr97btvfw+NIkJtjgsOt7oBFnb3iTupy8dSW56kXG4xAD4ZvJvKc2NHMQYp1GzIWPIBW90uuqTIWyRNmfHEft+UsY1YAXkg2DRDupZ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0hPxs/6; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711629001; x=1743165001;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V4X5Mgzj5RO3nYJCCI8M8/zfMP4g0aia9ewIHZHCjIM=;
  b=a0hPxs/6bgsSpIIS/SI2b45fQ3ynM2YFM3DuMsX1O36w5eY9+4BJrqM0
   o+AGCzUdCn/R8UMl1evPAcfw99wvm1Fgri42buGfy1mSUofI9Eam9gmhR
   ZSJCe1zlnt41OVg0IOFdAltkJnF1jQ6UCrJ0NzQLiVki5YlytQ19nTZL1
   XM56ZE//B6bM6rqsmYZhxciClsX5JWZMNdm2C5HMvT4PshPKeI1RFz5DE
   31bgEFC0VGwRlS+hu6UQM9Ya0Se/uYv+QPpN5F0UJjRkVPdGdOJjwnhuI
   qZXm6l5BKvT/hEYqcu67hkNGwcRT0D87VNEpTi5N1KmfQy77nrCBg3BoQ
   g==;
X-CSE-ConnectionGUID: 7inhl/oyS6Otnunrd5+UNA==
X-CSE-MsgGUID: pKfThaFeS7aUWSgNciq/Cw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="18212536"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="18212536"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 05:30:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17038470"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 28 Mar 2024 05:30:00 -0700
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
Subject: [PATCH v2 0/2] Two enhancements to iommu_at[de]tach_device_pasid()
Date: Thu, 28 Mar 2024 05:29:56 -0700
Message-Id: <20240328122958.83332-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are minor mistakes in the iommu set_dev_pasid() and remove_dev_pasid()
paths. The set_dev_pasid() path updates the group->pasid_array first, and
then call into remove_dev_pasid() in error handling when there are devices
within the group that failed to set_dev_pasid. The remove_dev_pasid()
callbacks of the underlying iommu drivers get the domain for pasid from the
group->pasid_array. So the remove_dev_pasid() callback may get a wrong domain
in the set_dev_pasid() path. [1] Even if the group is singleton, the existing
code logic would have unnecessary warnings in the error handling of the
set_dev_pasid() path. e.g. intel iommu driver.

The above issue can be fixed by improving the error handling in the
set_dev_pasid() path. Also, this reminds that it is not reliable for the
underlying iommu driver callback to get the domain from group->pasid_array.
So, the second patch of this series passes the domain to remove_dev_pasid
op.

[1] https://lore.kernel.org/linux-iommu/20240320123803.GD159172@nvidia.com/

Change log:

v2:
 - Make clear that the patch 1/2 of v1 does not fix the problem (Kevin)
 - Swap the order of patch 1/2 and 2/2 of v1. In this new series, patch 1/2
   fixes the real issue, patch 2/2 is to avoid potential issue in the future.

v1: https://lore.kernel.org/linux-iommu/20240327125433.248946-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (2):
  iommu: Undo pasid attachment only for the devices that have succeeded
  iommu: Pass domain to remove_dev_pasid() op

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++-----
 drivers/iommu/intel/iommu.c                 | 11 +++-----
 drivers/iommu/iommu.c                       | 28 ++++++++++++++-------
 include/linux/iommu.h                       |  3 ++-
 4 files changed, 26 insertions(+), 25 deletions(-)

-- 
2.34.1


