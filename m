Return-Path: <kvm+bounces-38316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F340A37226
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 06:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6936516E89D
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 05:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30460149DF0;
	Sun, 16 Feb 2025 05:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bxi6Xdpx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC81014F9C4
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739684806; cv=none; b=YPwRF7v6VyQQxN6sLlej+hHr1eGlYmCvFkSuDg7Jh0ziNn1TnY9Vf0sm2al+mBb/zOCQroYd8cFDFGTpNXGXKXIkUxErDoOg53/LuihbIOTrZhCF0wWoYrmoH0qnPCUAbMy3syUCOkMDgHK2POUlLGOIBH5zDXX/BLNUYMWCWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739684806; c=relaxed/simple;
	bh=KLRlVbfN9Mq3LqsdUBLgHzYS3vNKy5RYq7vjJeIsBQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u+A6Y7omq0rhUdoil3rx9EgRTBLcI4WBzPEkyhrWAb9Ws4JCtxmBuIuE5Qc8YxRMd7ZAYY8nTBytbNZzY66//sIvaWQ8Wi4pV8n4f8sghHewuAXCrHYmHNBrHmJNr7GfbozMZQzH7kVA/6VsY1zUSrKQLqhEaKuEm2EPimLfBkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bxi6Xdpx; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739684805; x=1771220805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KLRlVbfN9Mq3LqsdUBLgHzYS3vNKy5RYq7vjJeIsBQs=;
  b=Bxi6Xdpx1I86EVz6XFztNCj8nE8RP20NPS53yuwKtac08Y7YZCfPkTMK
   Y0OWWeEUUUG++X/YwGF/PQxXCKt2icxyJQKdI9UK68NjzR2QMHRbXu+G2
   jQ9uWhEjs4ruewLMhNuJnMn3hZjq17jTO/fl+mK1aYnYNZB9Qk/9JBOue
   DvAXVClyDYCQsSLBa63MTXDhJKCd1I7zCJkHdnmBhysPzluFbX361RQOy
   W2Ff6ptfe/rW1BhhaEGzljRXmQ8DxlHOidVKsIotXx49QAZi+TUrzv7fM
   U+dOrXbZHMEITbyGRvYbYvM+/m3E2haeY6hEJeqqkM2McMRXX5R/Gk5wj
   Q==;
X-CSE-ConnectionGUID: e5QLc1ENQNu/eCtC4NRavw==
X-CSE-MsgGUID: 2lSHCPiKQFKroNiVzuXOOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11346"; a="51373272"
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="51373272"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 21:46:43 -0800
X-CSE-ConnectionGUID: HtiJphHOTgypScNO3IvTWA==
X-CSE-MsgGUID: Z6ja7XHYSSiW//oDGO+upg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="114330754"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 15 Feb 2025 21:46:42 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	kevin.tian@intel.com
Cc: jgg@nvidia.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com
Subject: [PATCH v7 5/5] iommufd/selftest: Add coverage for reporting max_pasid_log2 via IOMMU_HW_INFO
Date: Sat, 15 Feb 2025 21:46:38 -0800
Message-Id: <20250216054638.24603-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250216054638.24603-1-yi.l.liu@intel.com>
References: <20250216054638.24603-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOMMU_HW_INFO is extended to report max_pasid_log2, hence add coverage
for it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 tools/testing/selftests/iommu/iommufd.c        | 18 ++++++++++++++++++
 .../testing/selftests/iommu/iommufd_fail_nth.c |  3 ++-
 tools/testing/selftests/iommu/iommufd_utils.h  | 17 +++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 575a9289dfdb..9f35076878cc 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -342,12 +342,14 @@ FIXTURE(iommufd_ioas)
 	uint32_t hwpt_id;
 	uint32_t device_id;
 	uint64_t base_iova;
+	uint32_t pasid_device_id;
 };
 
 FIXTURE_VARIANT(iommufd_ioas)
 {
 	unsigned int mock_domains;
 	unsigned int memory_limit;
+	bool pasid_capable;
 };
 
 FIXTURE_SETUP(iommufd_ioas)
@@ -372,6 +374,12 @@ FIXTURE_SETUP(iommufd_ioas)
 					     IOMMU_TEST_DEV_CACHE_DEFAULT);
 		self->base_iova = MOCK_APERTURE_START;
 	}
+
+	if (variant->pasid_capable)
+		test_cmd_mock_domain_flags(self->ioas_id,
+					   MOCK_FLAGS_DEVICE_PASID,
+					   NULL, NULL,
+					   &self->pasid_device_id);
 }
 
 FIXTURE_TEARDOWN(iommufd_ioas)
@@ -387,6 +395,7 @@ FIXTURE_VARIANT_ADD(iommufd_ioas, no_domain)
 FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain)
 {
 	.mock_domains = 1,
+	.pasid_capable = true,
 };
 
 FIXTURE_VARIANT_ADD(iommufd_ioas, two_mock_domain)
@@ -748,6 +757,8 @@ TEST_F(iommufd_ioas, get_hw_info)
 	} buffer_smaller;
 
 	if (self->device_id) {
+		uint8_t max_pasid = 0;
+
 		/* Provide a zero-size user_buffer */
 		test_cmd_get_hw_info(self->device_id, NULL, 0);
 		/* Provide a user_buffer with exact size */
@@ -762,6 +773,13 @@ TEST_F(iommufd_ioas, get_hw_info)
 		 * the fields within the size range still gets updated.
 		 */
 		test_cmd_get_hw_info(self->device_id, &buffer_smaller, sizeof(buffer_smaller));
+		test_cmd_get_hw_info_pasid(self->device_id, &max_pasid);
+		ASSERT_EQ(0, max_pasid);
+		if (variant->pasid_capable) {
+			test_cmd_get_hw_info_pasid(self->pasid_device_id,
+						   &max_pasid);
+			ASSERT_EQ(20, max_pasid);
+		}
 	} else {
 		test_err_get_hw_info(ENOENT, self->device_id,
 				     &buffer_exact, sizeof(buffer_exact));
diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
index 6bbdc187a986..121e714a3183 100644
--- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
+++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
@@ -664,7 +664,8 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 					&self->stdev_id, NULL, &idev_id))
 		return -1;
 
-	if (_test_cmd_get_hw_info(self->fd, idev_id, &info, sizeof(info), NULL))
+	if (_test_cmd_get_hw_info(self->fd, idev_id, &info,
+				  sizeof(info), NULL, NULL))
 		return -1;
 
 	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0,
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 523ff28e4bc9..8ed05838787d 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -757,7 +757,8 @@ static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
 
 /* @data can be NULL */
 static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
-				 size_t data_len, uint32_t *capabilities)
+				 size_t data_len, uint32_t *capabilities,
+				 uint8_t *max_pasid)
 {
 	struct iommu_test_hw_info *info = (struct iommu_test_hw_info *)data;
 	struct iommu_hw_info cmd = {
@@ -802,6 +803,9 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
 			assert(!info->flags);
 	}
 
+	if (max_pasid)
+		*max_pasid = cmd.out_max_pasid_log2;
+
 	if (capabilities)
 		*capabilities = cmd.out_capabilities;
 
@@ -810,14 +814,19 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
 
 #define test_cmd_get_hw_info(device_id, data, data_len)               \
 	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, data, \
-					   data_len, NULL))
+					   data_len, NULL, NULL))
 
 #define test_err_get_hw_info(_errno, device_id, data, data_len)               \
 	EXPECT_ERRNO(_errno, _test_cmd_get_hw_info(self->fd, device_id, data, \
-						   data_len, NULL))
+						   data_len, NULL, NULL))
 
 #define test_cmd_get_hw_capabilities(device_id, caps, mask) \
-	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, 0, &caps))
+	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, \
+					   0, &caps, NULL))
+
+#define test_cmd_get_hw_info_pasid(device_id, max_pasid)              \
+	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, \
+					   0, NULL, max_pasid))
 
 static int _test_ioctl_fault_alloc(int fd, __u32 *fault_id, __u32 *fault_fd)
 {
-- 
2.34.1


