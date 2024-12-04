Return-Path: <kvm+bounces-33012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B29619E39F7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 781092861C3
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FF01C07E7;
	Wed,  4 Dec 2024 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XS3GFoZE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80CB1B87E5
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315375; cv=none; b=rZKkOPLTcqisMwcQaN3iIPwa7A/vElAaCiQjwzvtQgWcLvpWIdWJfBZoP3CctKlotNPDdhW22s6ol6ZoezU8rqniGZk+MsuZOvLHHs2DCdODgRZdriOO7IrQTvTaTc/zE/DllI/cjACi1/iMcmx/Tcjg8FvDvdaKS12PKpf0dTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315375; c=relaxed/simple;
	bh=MIL5kqFgIT6RtORFgAFpmdic6w+g7VOz6BAcAW7q8lE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6nt1lMzVlpDTrdZQPVpfGab3aUP4/hjQfoRF+kqC8gYyC65Pr50AV4y42g71mqpQI2p+/6vnItDxl9dpWErQrHs6LCX2vF5a7g54ECdGxTzvK+22D9onj5NNOjHonp+6zMjv7EfH9awKZOvwQNdGxctbS8Y4FQkzkuQ2Om57vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XS3GFoZE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733315374; x=1764851374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MIL5kqFgIT6RtORFgAFpmdic6w+g7VOz6BAcAW7q8lE=;
  b=XS3GFoZE+cb8IROa94gp67MDTj0Oxd2tV4kBFE+4BBozO0FjDtvKAtAN
   LXed+plyb1FAGGQkO7Tx5bZ0ws28i350G3DU0sqDlXFC5sCQy4o6Qekhu
   Qn+o/u2DGNOdEyRkT/9K0xL6PUAyJu9grr67RSSO27O/avPPJQi+JG3sF
   Fj9RBF1lDmncv32xAP27Xxy4hYHCXXXzbhz9JTFXxEfCN/9+suCHtwECv
   xvQXGr46WivWPRMXUZ4l5OPsWzlrls4cz5xmD6RnVLx8X6R9JkRXg/oxl
   a6RVfl0v/503kVk3ORuZS00L8GgMdrYOQNdSSVkQ1TcV12Mo/lMZivfJ4
   g==;
X-CSE-ConnectionGUID: gLnoEdi/TRWOKEhAQQfSYw==
X-CSE-MsgGUID: t3HoG2VqTl2E36zR/frN4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="32937893"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32937893"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 04:29:33 -0800
X-CSE-ConnectionGUID: GnC8T37dSkag/IlByv1urw==
X-CSE-MsgGUID: Lx59OPTjTg67hhWYUp/sOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93599072"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 04 Dec 2024 04:29:33 -0800
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
Subject: [PATCH v6 3/7] iommu: Detaching pasid by attaching to the blocked_domain
Date: Wed,  4 Dec 2024 04:29:24 -0800
Message-Id: <20241204122928.11987-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241204122928.11987-1-yi.l.liu@intel.com>
References: <20241204122928.11987-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu drivers are on the way to detach pasid by attaching to the blocked
domain. However, this cannot be done in one shot. During the transition, iommu
core would select between the remove_dev_pasid op and the blocked domain.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0331dc30eb64..149ae5300cc4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3316,8 +3316,18 @@ static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 				   struct iommu_domain *domain)
 {
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_domain *blocked_domain = ops->blocked_domain;
+	int ret = 1;
 
-	ops->remove_dev_pasid(dev, pasid, domain);
+	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
+		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
+							 dev, pasid, domain);
+	} else {
+		ops->remove_dev_pasid(dev, pasid, domain);
+		ret = 0;
+	}
+
+	WARN_ON(ret);
 }
 
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
@@ -3380,7 +3390,9 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	ops = dev_iommu_ops(dev);
 
 	if (!domain->ops->set_dev_pasid ||
-	    !ops->remove_dev_pasid)
+	    (!ops->remove_dev_pasid &&
+	     (!ops->blocked_domain ||
+	      !ops->blocked_domain->ops->set_dev_pasid)))
 		return -EOPNOTSUPP;
 
 	if (ops != domain->owner || pasid == IOMMU_NO_PASID)
-- 
2.34.1


