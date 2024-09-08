Return-Path: <kvm+bounces-26075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2658970701
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 13:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE2101C212C6
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 11:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE101586D0;
	Sun,  8 Sep 2024 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C9s0byn1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227951494C2
	for <kvm@vger.kernel.org>; Sun,  8 Sep 2024 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725795779; cv=none; b=REc0JK6+efs7tTLl3zU+PdK3FdiKYnK9qPr1zTk9PjrC1NoSpzJ1Z1dQJA1ECAZgIE+yyB56qY0ZJsiXY7lyazIeaCySkdXSijNwecia7W54mYlBoqC9yUM9qNtX0iq8n3H0qO1wZf/OdrWZ8DpOuf9ehuaS9/a/hF28TcqoB+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725795779; c=relaxed/simple;
	bh=t2sLnkInQWUKNBGiID4AD2togWX10HSlRhLqej6PRdM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SIVp3sgS4LRjcij9S45srxRa4V2tmnGSCQiH27W9UseNvTNcxcozPnpPka9MBDx0YMGq0ljbG73oZ28miy7m4BxK1AXWbNidmV3tD9/i1MglCIUWRDVqVDGEqOos0w8nd5SrNVP01mFxTDkMQLyOcxa92V1DLjubs+YYCbXI738=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C9s0byn1; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725795778; x=1757331778;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t2sLnkInQWUKNBGiID4AD2togWX10HSlRhLqej6PRdM=;
  b=C9s0byn1djIEwfqNw1qLfTSV/t2SRRqwdiZnnetpO1KYVOWEKUPKT5AK
   ch3VGtLEBMZ5pQLRgPxwaEQUhtVgV00QipEYwTTMm5ylDTtUrweqv1YZZ
   rVHeMn0T9s7HY4CrdOT0gdWEA8EJU7eY3A32Z+R++If+S/zxJ1cQQTKAy
   WVb4X39g3Vv9rH9fWNnEJn3Xgk9bU9BHSgh4uhi6xNF2s8xdnJXMpc7cz
   2Ju2o8e3uBbaFW690ihdM+JY6hDup/4TOpw0gkNoF3uodISI/uqCh2Evj
   YUTZAf+XPsC0kYTcVZSm+wgdFW77xRSi7wgxgKoPgeut/J3Vxoo+4lci7
   A==;
X-CSE-ConnectionGUID: h3ZpCCnMSS2oPjWX5Db5Bg==
X-CSE-MsgGUID: ekpcD0VtQf2kJ3PCWEqBCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11188"; a="27418265"
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="27418265"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 04:42:58 -0700
X-CSE-ConnectionGUID: z+zkYa8NTmeLIAV4cQu1IA==
X-CSE-MsgGUID: Wn6TD4u6R7SeBhRWM+nDRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="89668161"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa002.fm.intel.com with ESMTP; 08 Sep 2024 04:42:57 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: [PATCH 0/2] iommufd: Misc cleanups per iommufd iopf merging
Date: Sun,  8 Sep 2024 04:42:54 -0700
Message-Id: <20240908114256.979518-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Two misc patches per the iommufd iopf merging. Please feel free comment.

Regards,
	Yi Liu

Yi Liu (2):
  iommufd: Avoid duplicated __iommu_group_set_core_domain() call
  iommu: Set iommu_attach_handle->domain in core

 drivers/iommu/iommu.c                   | 1 +
 drivers/iommu/iommufd/fault.c           | 1 -
 drivers/iommu/iommufd/iommufd_private.h | 4 +++-
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.34.1


