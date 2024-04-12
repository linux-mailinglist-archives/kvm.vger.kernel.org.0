Return-Path: <kvm+bounces-14402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C2C8A2901
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA63428311E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8E750298;
	Fri, 12 Apr 2024 08:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gmu7cvqd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AEE5028B
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909738; cv=none; b=LTrqHImONztOk0+E1/zc7/8M59qwdK02kfHkMahsxO+HCOuqvR3SGtTD8BJgxNz1r0r2AxwiUP8WIPm7AUmamGLhK/9hVXXGfJNRFEKfKJitAvSjAZrtXNUwzbF59iBWlm8RTMUUx7YJNJchqTK3rM+oeOl/nKruP+DTw+/jyK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909738; c=relaxed/simple;
	bh=215NWd7XdkLGszQ3ypBe/6MHxaDS5c0uvB3nqJq+7o8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rWPdVp+Vfv9vs279Gx/IqPyPZsAzkYRrZCcHWjdlQy6IEnuv6GAvSH45RhldhzVISA8B3PSiDeaP6FSunJpzBa2IaFJwBRTWTcr+GSKuwL/yNgutmv5j9JGJbvLg6z8HRtlbNRySEE45glEARElk7/l5FiqhLTMThZtmikfK0H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gmu7cvqd; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909737; x=1744445737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=215NWd7XdkLGszQ3ypBe/6MHxaDS5c0uvB3nqJq+7o8=;
  b=Gmu7cvqdfhm+5KH3mORrfLW9eGXdRDLicH6D25+ntWRui666w5ow6jkV
   OCbhc7yNjbpKthIN0Q6VHnE8J8Scwuyo14cN95S9MSgUV3radsu5hIxkD
   G/uAEsfc3Yu4Hh0ydMnUSKxl+mdlSmTpKheFcmDtOnTpZDPMk73PDG+zG
   WVfAJINV2qBuVZLvGU3zjI01tNiWYdBJ/82z8QJeNK/Wjd4vOzgsQ3KHP
   3P7njXVazlFbG2/ZZcqtYoqMZGZj5jBmuI6m5SHle6kg+P7Mksz+fQ2uC
   6TpAirKJS5+sQubig0rHBmAT7l4ZXPXd6j2vIs2//3PHdPucQKfNAPHaW
   A==;
X-CSE-ConnectionGUID: j8+IIEUGRVaRjcpVfkmFDQ==
X-CSE-MsgGUID: L167YS5pR12Lj46P+9HRUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465092"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465092"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:36 -0700
X-CSE-ConnectionGUID: veMmGnm2TgSJsxptZ65Huw==
X-CSE-MsgGUID: zcqH2YMCThahoYJ37qkDOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137862"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:35 -0700
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
Subject: [PATCH v2 08/12] iommufd/selftest: Add test ops to test pasid attach/detach
Date: Fri, 12 Apr 2024 01:15:12 -0700
Message-Id: <20240412081516.31168-9-yi.l.liu@intel.com>
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

This adds 4 test ops for pasid attach/replace/detach testing. There are
ops to attach/detach pasid, and also op to check the attached domain of
a pasid.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/iommufd_test.h |  30 ++++++
 drivers/iommu/iommufd/selftest.c     | 135 +++++++++++++++++++++++++++
 2 files changed, 165 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index e854d3f67205..ee6310f07749 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -22,6 +22,10 @@ enum {
 	IOMMU_TEST_OP_MOCK_DOMAIN_FLAGS,
 	IOMMU_TEST_OP_DIRTY,
 	IOMMU_TEST_OP_MD_CHECK_IOTLB,
+	IOMMU_TEST_OP_PASID_ATTACH,
+	IOMMU_TEST_OP_PASID_REPLACE,
+	IOMMU_TEST_OP_PASID_DETACH,
+	IOMMU_TEST_OP_PASID_CHECK_DOMAIN,
 };
 
 enum {
@@ -127,6 +131,32 @@ struct iommu_test_cmd {
 			__u32 id;
 			__u32 iotlb;
 		} check_iotlb;
+		struct {
+			__u32 pasid;
+			__u32 pt_id;
+			/* @id is stdev_id for IOMMU_TEST_OP_PASID_ATTACH
+			 * pasid#1024 is for special test, avoid use it
+			 * in normal case.
+			 */
+		} pasid_attach;
+		struct {
+			__u32 pasid;
+			__u32 pt_id;
+			/* @id is stdev_id for IOMMU_TEST_OP_PASID_ATTACH
+			 * pasid#1024 is for special test, avoid use it
+			 * in normal case.
+			 */
+		} pasid_replace;
+		struct {
+			__u32 pasid;
+			/* @id is stdev_id for IOMMU_TEST_OP_PASID_DETACH */
+		} pasid_detach;
+		struct {
+			__u32 pasid;
+			__u32 hwpt_id;
+			__u64 out_result_ptr;
+			/* @id is stdev_id for IOMMU_TEST_OP_HWPT_GET_DOMAIN */
+		} pasid_check;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index e21b076b2223..45469213f2f9 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -516,6 +516,8 @@ static struct iommu_device *mock_probe_device(struct device *dev)
 	return &mock_iommu_device;
 }
 
+static bool pasid_1024_attached;
+
 static void mock_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 					struct iommu_domain *domain)
 {
@@ -524,6 +526,8 @@ static void mock_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 		switch (domain->type) {
 		case IOMMU_DOMAIN_NESTED:
 		case IOMMU_DOMAIN_UNMANAGED:
+			if (pasid == 1024)
+				pasid_1024_attached = false;
 			break;
 		default:
 			/* should never reach here */
@@ -537,6 +541,20 @@ static int mock_domain_set_dev_pasid_nop(struct iommu_domain *domain,
 					 struct device *dev, ioasid_t pasid,
 					 struct iommu_domain *old)
 {
+	/*
+	 * First attach with pasid 1024 succ, second attach would fail,
+	 * and so on. This is helpful to test the case in which the iommu
+	 * layer needs to rollback to old domain due to driver failure.
+	 */
+	if (pasid == 1024) {
+		if (pasid_1024_attached) {
+			pasid_1024_attached = false;
+			// Fake an error to fail the replacement
+			return -ENOMEM;
+		}
+		pasid_1024_attached = true;
+	}
+
 	return 0;
 }
 
@@ -1414,6 +1432,114 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	return rc;
 }
 
+static int iommufd_test_pasid_attach(struct iommufd_ucmd *ucmd,
+				     struct iommu_test_cmd *cmd)
+{
+	struct selftest_obj *sobj;
+	int rc;
+
+	sobj = iommufd_test_get_self_test_device(ucmd->ictx, cmd->id);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
+
+	rc = iommufd_device_pasid_attach(sobj->idev.idev,
+					 cmd->pasid_attach.pasid,
+					 &cmd->pasid_attach.pt_id);
+	iommufd_put_object(ucmd->ictx, &sobj->obj);
+	return rc;
+}
+
+static int iommufd_test_pasid_replace(struct iommufd_ucmd *ucmd,
+				      struct iommu_test_cmd *cmd)
+{
+	struct selftest_obj *sobj;
+	int rc;
+
+	sobj = iommufd_test_get_self_test_device(ucmd->ictx, cmd->id);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
+
+	rc = iommufd_device_pasid_replace(sobj->idev.idev,
+					  cmd->pasid_attach.pasid,
+					  &cmd->pasid_attach.pt_id);
+	iommufd_put_object(ucmd->ictx, &sobj->obj);
+	return rc;
+}
+
+static int iommufd_test_pasid_detach(struct iommufd_ucmd *ucmd,
+				     struct iommu_test_cmd *cmd)
+{
+	struct selftest_obj *sobj;
+
+	sobj = iommufd_test_get_self_test_device(ucmd->ictx, cmd->id);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
+
+	iommufd_device_pasid_detach(sobj->idev.idev,
+				    cmd->pasid_detach.pasid);
+	iommufd_put_object(ucmd->ictx, &sobj->obj);
+	return 0;
+}
+
+static inline struct iommufd_hw_pagetable *
+iommufd_get_hwpt(struct iommufd_ucmd *ucmd, u32 id)
+{
+	struct iommufd_object *pt_obj;
+
+	pt_obj = iommufd_get_object(ucmd->ictx, id, IOMMUFD_OBJ_ANY);
+	if (IS_ERR(pt_obj))
+		return ERR_CAST(pt_obj);
+
+	if (pt_obj->type != IOMMUFD_OBJ_HWPT_NESTED &&
+	    pt_obj->type != IOMMUFD_OBJ_HWPT_PAGING) {
+		iommufd_put_object(ucmd->ictx, pt_obj);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return container_of(pt_obj, struct iommufd_hw_pagetable, obj);
+}
+
+static int iommufd_test_pasid_check_domain(struct iommufd_ucmd *ucmd,
+					   struct iommu_test_cmd *cmd)
+{
+	struct iommu_domain *attached_domain, *expect_domain = NULL;
+	struct iommufd_hw_pagetable *hwpt = NULL;
+	struct selftest_obj *sobj;
+	struct mock_dev *mdev;
+	bool result;
+	int rc = 0;
+
+	sobj = iommufd_test_get_self_test_device(ucmd->ictx, cmd->id);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
+
+	mdev = sobj->idev.mock_dev;
+
+	attached_domain = iommu_get_domain_for_dev_pasid(&mdev->dev,
+							 cmd->pasid_check.pasid, 0);
+	if (IS_ERR(attached_domain))
+		attached_domain = NULL;
+
+	if (cmd->pasid_check.hwpt_id) {
+		hwpt = iommufd_get_hwpt(ucmd, cmd->pasid_check.hwpt_id);
+		if (IS_ERR(hwpt)) {
+			rc = PTR_ERR(hwpt);
+			goto out_put_dev;
+		}
+		expect_domain = hwpt->domain;
+	}
+
+	result = (attached_domain == expect_domain) ? 1 : 0;
+	if (copy_to_user(u64_to_user_ptr(cmd->pasid_check.out_result_ptr),
+			 &result, sizeof(result)))
+		rc = -EFAULT;
+	if (hwpt)
+		iommufd_put_object(ucmd->ictx, &hwpt->obj);
+out_put_dev:
+	iommufd_put_object(ucmd->ictx, &sobj->obj);
+	return rc;
+}
+
 void iommufd_selftest_destroy(struct iommufd_object *obj)
 {
 	struct selftest_obj *sobj = container_of(obj, struct selftest_obj, obj);
@@ -1489,6 +1615,14 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 					  cmd->dirty.page_size,
 					  u64_to_user_ptr(cmd->dirty.uptr),
 					  cmd->dirty.flags);
+	case IOMMU_TEST_OP_PASID_ATTACH:
+		return iommufd_test_pasid_attach(ucmd, cmd);
+	case IOMMU_TEST_OP_PASID_REPLACE:
+		return iommufd_test_pasid_replace(ucmd, cmd);
+	case IOMMU_TEST_OP_PASID_DETACH:
+		return iommufd_test_pasid_detach(ucmd, cmd);
+	case IOMMU_TEST_OP_PASID_CHECK_DOMAIN:
+		return iommufd_test_pasid_check_domain(ucmd, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1532,6 +1666,7 @@ int __init iommufd_test_init(void)
 		goto err_sysfs;
 
 	mock_iommu_device.max_pasids = (1 << 20);//20 bits
+	pasid_1024_attached = false;
 	return 0;
 
 err_sysfs:
-- 
2.34.1


