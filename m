Return-Path: <kvm+bounces-14405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0F28A2905
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E51EF1F22462
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574F850A93;
	Fri, 12 Apr 2024 08:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZP+6CS3r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED361B81F
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909740; cv=none; b=Zwd/kQxlhfSPmv1FZKZhmulo8ntQtreebBS26XJgHqdXA0e61IuFfxpFZXFV0VHPXGfG1MFuMuygclYoNU/urzqaTOPPtmpMHH3lqAjuati0GIpo9q3srpIX1mRivhgjy4VBdsed6m26Yxd3nRNT1pJGGqMlHSxh4Kh1r6lMZC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909740; c=relaxed/simple;
	bh=+YxNjmAnxPz08ugfMnJTp/OXUrhN2kOcrXB2YzepySE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P59i6610FnOfETUqRLncIM/YmlbGuJ6Y9UyT9hTRR790IKvqrscCZefvuBj8dD17saQUO06CXJlU7Xdc/k2USLtdb735PYI5I71gODSNHeX0bcDconBfVKxJn/gp+yMI8I3BPCRqCd1ImUlgwqJFWtLJL7xQ3gMl9/ZXQJf6Ix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZP+6CS3r; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909740; x=1744445740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+YxNjmAnxPz08ugfMnJTp/OXUrhN2kOcrXB2YzepySE=;
  b=ZP+6CS3rOUz8FgWsLbz0rZMGW6GdVc72yrW8Hxej5MMigXwzG4YvK92o
   m05jaegUmXUoh1+Cifbqm4abyzPGUEApx1K/gIN7sKE9kXZzz02ic/Jxk
   GkZYbdiqnRA5CKPQuok3oQuqWre2fgX2MAVDiUVnLrCIWb4CMDj+jB4V2
   O6dscsw5n+QSdpjgDaY6OrzJZnJ2iKa+2mfETnmLFqDBl5vE/he+KS3pF
   QX007pTYa9j//la99fAy/JixdV+kdS3gq1FZZcx6vzKSZFJTejb3VA2hx
   +9wzsBxehKGZ0YuQ5mNDCuoUxQKSHMY5zHtcJCAR8AaH4KTNsKi6mvEBK
   Q==;
X-CSE-ConnectionGUID: OS+Wesm8QoCkUKv+Y28MyA==
X-CSE-MsgGUID: Sh5bUgtxScqw0e/Gju1tEw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465114"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465114"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:38 -0700
X-CSE-ConnectionGUID: BLkJyJ6RT++WXfcfpW8FJw==
X-CSE-MsgGUID: Cp2l4cqISM+3TniCaJCaMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137881"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:37 -0700
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
Subject: [PATCH v2 11/12] iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain replacement
Date: Fri, 12 Apr 2024 01:15:15 -0700
Message-Id: <20240412081516.31168-12-yi.l.liu@intel.com>
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

Existing intel_iommu_set_dev_pasid() does not support domain replacement.
However, iommu layer requires set_dev_pasid() to handle domain replacement.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index fff7dea012a7..9e79ffdd47db 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4646,6 +4646,10 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (context_copied(iommu, info->bus, info->devfn))
 		return -EBUSY;
 
+	/* Block old translation */
+	if (old)
+		intel_iommu_remove_dev_pasid(dev, pasid, old);
+
 	ret = prepare_domain_attach_device(domain, dev);
 	if (ret)
 		return ret;
-- 
2.34.1


