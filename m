Return-Path: <kvm+bounces-30542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 100BC9BB5F7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41BC01C2181E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D07D13CA99;
	Mon,  4 Nov 2024 13:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bPNwR4hx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C013B298
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726726; cv=none; b=e20esztIZiL4aHln0dW2f0S/RztElWwaWKb80s+z+EordssUvBlTYdInxukSybTHAR+tdR5Gd2yMGAbRqb3ej5UKEACMBGerf5CQCYXOqvXmygdZCDEwRoUl+GYN4G/K10+d+FVdOIoKUCDaM1lk5AWdT5f+lFN3jcTU++KVCdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726726; c=relaxed/simple;
	bh=rs1CcauSmGuHvUc+fH12I6MZ81SfrRk2kEoiRuQlhZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O8LePl4w+o4Wermr6dR38qzCjZ4jEp1E9ZU7rO0WhU6nNZSRmcqA9q3j0sWO+lO2Cy+6TT73tZOuRa781zWrU8oDeV3SlGF0HlX8YcC97ANmdE4rJbt7ANvi2sw95rzqeyNntHi3+7EN44bA+MK1VXxowpoP8D98maUBI2KBwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bPNwR4hx; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726725; x=1762262725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rs1CcauSmGuHvUc+fH12I6MZ81SfrRk2kEoiRuQlhZQ=;
  b=bPNwR4hxyIjfi7ZKxUrSycEVGQdm9ydAaKRmZdzQbP5l/LtJfgmtVNBS
   lkSx16o0tn8zQq0CY5vg1Yp/plQlh+v550u5EWZGgDQueH6wGomBjgfQq
   UTcpyz9T81T2lGwyL4gXnYGd5V3vXsKqFurYB/wTvukIJaAigaaC9CXwa
   qN1F2cIMJd74SdO8ALOy01wn7XAE4yk4/enU8+C+ADsf9efjXdfAUpbr/
   9jDicrFBxcNRf/L0TS0HY+MweuNcwOj7CNb+64E7wjyzMrcqtxcVyiawV
   jmKElgG4jFYeZWXZPGtoT4Ix9yoNIZfqzL8RgdMF2S8fTZWAJ8gVI4C8k
   g==;
X-CSE-ConnectionGUID: M5FvU3/1S4mmRffviFKOsA==
X-CSE-MsgGUID: gsm0FOvyRlWdRJixv3z/sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884087"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884087"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:22 -0800
X-CSE-ConnectionGUID: 6QWO4SvcTDCLrNa0j1PE5Q==
X-CSE-MsgGUID: uT/oSIgRRy6rpyIQLM5ZzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100484"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:21 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v5 10/12] iommufd/selftest: Add a helper to get test device
Date: Mon,  4 Nov 2024 05:25:11 -0800
Message-Id: <20241104132513.15890-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132513.15890-1-yi.l.liu@intel.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is need to get the selftest device (sobj->type == TYPE_IDEV) in
multiple places, so have a helper to for it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/selftest.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 635d8246691d..bfd2c50f64ec 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -825,29 +825,39 @@ static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
-/* Replace the mock domain with a manually allocated hw_pagetable */
-static int iommufd_test_mock_domain_replace(struct iommufd_ucmd *ucmd,
-					    unsigned int device_id, u32 pt_id,
-					    struct iommu_test_cmd *cmd)
+static struct selftest_obj *
+iommufd_test_get_self_test_device(struct iommufd_ctx *ictx, u32 id)
 {
 	struct iommufd_object *dev_obj;
 	struct selftest_obj *sobj;
-	int rc;
 
 	/*
 	 * Prefer to use the OBJ_SELFTEST because the destroy_rwsem will ensure
 	 * it doesn't race with detach, which is not allowed.
 	 */
-	dev_obj =
-		iommufd_get_object(ucmd->ictx, device_id, IOMMUFD_OBJ_SELFTEST);
+	dev_obj = iommufd_get_object(ictx, id, IOMMUFD_OBJ_SELFTEST);
 	if (IS_ERR(dev_obj))
-		return PTR_ERR(dev_obj);
+		return ERR_CAST(dev_obj);
 
 	sobj = container_of(dev_obj, struct selftest_obj, obj);
 	if (sobj->type != TYPE_IDEV) {
-		rc = -EINVAL;
-		goto out_dev_obj;
+		iommufd_put_object(ictx, dev_obj);
+		return ERR_PTR(-EINVAL);
 	}
+	return sobj;
+}
+
+/* Replace the mock domain with a manually allocated hw_pagetable */
+static int iommufd_test_mock_domain_replace(struct iommufd_ucmd *ucmd,
+					    unsigned int device_id, u32 pt_id,
+					    struct iommu_test_cmd *cmd)
+{
+	struct selftest_obj *sobj;
+	int rc;
+
+	sobj = iommufd_test_get_self_test_device(ucmd->ictx, device_id);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
 
 	rc = iommufd_device_replace(sobj->idev.idev, &pt_id);
 	if (rc)
@@ -857,7 +867,7 @@ static int iommufd_test_mock_domain_replace(struct iommufd_ucmd *ucmd,
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 
 out_dev_obj:
-	iommufd_put_object(ucmd->ictx, dev_obj);
+	iommufd_put_object(ucmd->ictx, &sobj->obj);
 	return rc;
 }
 
-- 
2.34.1


