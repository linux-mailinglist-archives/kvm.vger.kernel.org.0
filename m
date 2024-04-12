Return-Path: <kvm+bounces-14400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF8E8A28FE
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D93F41F23160
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE8951026;
	Fri, 12 Apr 2024 08:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WodLea8V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D2A1CAA1
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909736; cv=none; b=VXc/MzbhRTuPoegMKHqoidt7nvvEg1i4mymkUbRH5XT6sx7WP22ofmkpEEMrk6Unj46f9436/W2qJwHSRyAGbO7lA1XyODQbTCjXbcmWtPgzjetUcbwPuY/Oe/tkuabLQsaPetKG0y0G3qm93Sp4g2VSbz+BisoEbG9M5xsM/G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909736; c=relaxed/simple;
	bh=IdGVpq99NNO+hKs44+lGcKfOIZlHBFrTSuNJuQcc74M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oEIK6iNEwf81Y2GpSQLw7vW1yAbfgGJe8uzvlhRm0BvljHT/YijMdiCsjKT3rxP9vHwFYx6andcaM0zkl68ch0HmpfB3w9B1K7btr+fpdfHu2vvdcEzOb58OiJ+tcTNUxpmAjq4wv+mMA3X9xDmgXdZFUrYGbPETBCoAtWV2ZGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WodLea8V; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909735; x=1744445735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IdGVpq99NNO+hKs44+lGcKfOIZlHBFrTSuNJuQcc74M=;
  b=WodLea8VzdmcDwJBauP8yLV7m38Ns3GRJCMqc3KQ1yxyuzkejeTuz8Td
   Dl+J4ba1RWzUMj0z3LXAAwIP8dF8pLB4lXurIBn2W4yjESmKDbMlkVSll
   K6vr3Wgl0WrlnshmIptD48CSdx1QpHdrTutgwBcNLUN9tgYY9XuMN2ymU
   L7t8p6mttFmiiJmUzwCYUzRDPmPvYRqjFp33F6Jej6KMSGlMOVJ3yhyuX
   agRlenxXXJogjqTP/py4cvk8bcdHuoaOLCcZm5empW/yZK2TIcI3GzDhL
   PIUgXfQ2763sBdNhtZ2RKXD+PL7kbVKz4TqsZpMaH+Xrtq4uyB4veg8wu
   Q==;
X-CSE-ConnectionGUID: apEeIkQgT9SJwlIhOBED6g==
X-CSE-MsgGUID: pAXpwrC9TOO2Gj9eQkPS5Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465080"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465080"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:35 -0700
X-CSE-ConnectionGUID: vuvOm5lwQjeVQfgKlRyHMw==
X-CSE-MsgGUID: D9L7gTzXTAWqr0a0GPgB3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137851"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:34 -0700
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
Subject: [PATCH v2 06/12] iommufd/selftest: Add set_dev_pasid and remove_dev_pasid in mock iommu
Date: Fri, 12 Apr 2024 01:15:10 -0700
Message-Id: <20240412081516.31168-7-yi.l.liu@intel.com>
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

The two callbacks are needed to make pasid_attach/detach path complete for
mock device. A nop is enough for set_dev_pasid, a domain type check in the
remove_dev_pasid is also helpful.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/selftest.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 7a2199470f31..45e1328f0f5d 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -511,9 +511,35 @@ static struct iommu_device *mock_probe_device(struct device *dev)
 {
 	if (dev->bus != &iommufd_mock_bus_type.bus)
 		return ERR_PTR(-ENODEV);
+
+	dev->iommu->max_pasids = 1 << 20;//20 bits
 	return &mock_iommu_device;
 }
 
+static void mock_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+					struct iommu_domain *domain)
+{
+	/* Domain type specific cleanup: */
+	if (domain) {
+		switch (domain->type) {
+		case IOMMU_DOMAIN_NESTED:
+		case IOMMU_DOMAIN_UNMANAGED:
+			break;
+		default:
+			/* should never reach here */
+			WARN_ON(1);
+			break;
+		}
+	}
+}
+
+static int mock_domain_set_dev_pasid_nop(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old)
+{
+	return 0;
+}
+
 static const struct iommu_ops mock_ops = {
 	/*
 	 * IOMMU_DOMAIN_BLOCKED cannot be returned from def_domain_type()
@@ -529,6 +555,7 @@ static const struct iommu_ops mock_ops = {
 	.capable = mock_domain_capable,
 	.device_group = generic_device_group,
 	.probe_device = mock_probe_device,
+	.remove_dev_pasid = mock_iommu_remove_dev_pasid,
 	.default_domain_ops =
 		&(struct iommu_domain_ops){
 			.free = mock_domain_free,
@@ -536,6 +563,7 @@ static const struct iommu_ops mock_ops = {
 			.map_pages = mock_domain_map_pages,
 			.unmap_pages = mock_domain_unmap_pages,
 			.iova_to_phys = mock_domain_iova_to_phys,
+			.set_dev_pasid = mock_domain_set_dev_pasid_nop,
 		},
 };
 
@@ -600,6 +628,7 @@ static struct iommu_domain_ops domain_nested_ops = {
 	.free = mock_domain_free_nested,
 	.attach_dev = mock_domain_nop_attach,
 	.cache_invalidate_user = mock_domain_cache_invalidate_user,
+	.set_dev_pasid = mock_domain_set_dev_pasid_nop,
 };
 
 static inline struct iommufd_hw_pagetable *
@@ -1491,6 +1520,8 @@ int __init iommufd_test_init(void)
 				  &iommufd_mock_bus_type.nb);
 	if (rc)
 		goto err_sysfs;
+
+	mock_iommu_device.max_pasids = (1 << 20);//20 bits
 	return 0;
 
 err_sysfs:
-- 
2.34.1


