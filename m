Return-Path: <kvm+bounces-12853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF1088E5F4
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6B231F304DE
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0317115216C;
	Wed, 27 Mar 2024 12:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDY0IkaK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72386137939
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544083; cv=none; b=IeqZ5cqiWQ9ZAQa4nizf8UWnGm87yCCOwXhsZsRNI35MJhRmT6TQuWrcHAHykF0HZvw6m/sViYl2++d3Vt5pU0XsoZo4aAC4b5cjkx732KCEZutxlXq3IJbaTDYaHGzvs+ibuxHKRyEUkyWF2jHV1qWgKWS3SlJ7KZBjwT9Xa1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544083; c=relaxed/simple;
	bh=Nw+W+SdNr0QMlPMemdm1IOIa0D+ceqsV+bgMwHWTiOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WI/WtHmKLpGJDq1qMOzy7S3vT7No6S+Od4j4ZpbiitQYrXeUWkIk5cvw66oUnBdrz7lZEYtYaVSCh4gvuwGsPsOR2cW9yfEhWLK/ZAch+o0RL03jIdjKFZBWAvv30drUYd2l/dfE8yeiw8szzlfRt43na5HfRWe5e0BkqzI8mXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDY0IkaK; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711544081; x=1743080081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nw+W+SdNr0QMlPMemdm1IOIa0D+ceqsV+bgMwHWTiOg=;
  b=YDY0IkaKbia60Cfttsg/XR52PW8GU+WDKPq9n3XLaD8/4+noScBs41T4
   /EiCflyNfE1f/R8c++YBBCT988n0cl8MYI41yVBvJbc/Myxi8+/EmvsU1
   tF3Z10Lvv7JTMFeXvcWOqo4zxBcbeYFH1I/hNtF77a4R3/4vzlZ5kruMv
   E9PvjqrPOxW8M2Fq8h40w++oCIPbJbilaUj9hwoUty7R3IrAjI5VvRZPD
   85GF3ciHAmf6BuEa6qPoCjCYRZC10s+h7R17DGekcq1gjqjarKGTgzyo1
   wCTxLrQC89zI83I1Ps6sjBMp4Rc7yEObeG31XFAVALqZk6F36jLVZBqCZ
   w==;
X-CSE-ConnectionGUID: 16sUtOYBRO2o10VoTzZHKA==
X-CSE-MsgGUID: HGwedaUQRpOce5c46NiMjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="17271798"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="17271798"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 05:54:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20811209"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa003.fm.intel.com with ESMTP; 27 Mar 2024 05:54:38 -0700
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
Subject: [PATCH 2/2] iommu: Undo pasid attachment only for the devices that have succeeded
Date: Wed, 27 Mar 2024 05:54:33 -0700
Message-Id: <20240327125433.248946-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240327125433.248946-1-yi.l.liu@intel.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no error handling now in __iommu_set_group_pasid(), it relies on
its caller to loop all the devices to undo the pasid attachment. This is
not self-contained and has unnecessary remove_dev_pasid() calls on the
devices that have not changed in the __iommu_set_group_pasid() call. this
results in unnecessary warnings by the underlying iommu drivers. Like the
Intel iommu driver, it would warn when there is no pasid attachment to
destroy in the remove_dev_pasid() callback.

The ideal way is to handle the error within __iommu_set_group_pasid(). This
not only makes __iommu_set_group_pasid() self-contained, but also avoids
unnecessary warnings.

Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 681e916d285b..2a12c9c9e045 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3317,15 +3317,25 @@ EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
 				   struct iommu_group *group, ioasid_t pasid)
 {
-	struct group_device *device;
-	int ret = 0;
+	struct group_device *device, *last_gdev;
+	int ret;
 
 	for_each_group_device(group, device) {
 		ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
 		if (ret)
-			break;
+			goto err_revert;
 	}
 
+	return 0;
+
+err_revert:
+	last_gdev = device;
+	for_each_group_device(group, device) {
+		if (device == last_gdev)
+			break;
+		dev_iommu_ops(device->dev)->remove_dev_pasid(device->dev,
+							     pasid, domain);
+	}
 	return ret;
 }
 
@@ -3375,10 +3385,8 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	}
 
 	ret = __iommu_set_group_pasid(domain, group, pasid);
-	if (ret) {
-		__iommu_remove_group_pasid(group, pasid, domain);
+	if (ret)
 		xa_erase(&group->pasid_array, pasid);
-	}
 out_unlock:
 	mutex_unlock(&group->mutex);
 	return ret;
-- 
2.34.1


