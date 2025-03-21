Return-Path: <kvm+bounces-41706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F021A6C202
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 119A6464109
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8496A22FF5E;
	Fri, 21 Mar 2025 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BzjrrMWq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2492A22FAFD
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580111; cv=none; b=AuHgB+wwMjWD0igfM1oq/BeL94kWg3r9KzzZwbOvJuSp1CdWtrHh3oduIoCCda6+hKHWNIoG47L70PpDXyOOxVcjdXFFODL7rAit9sLqE0E9YtbHZLD8e68Rvo7V0uoC2CzdN1BQuTJWmSatMGcaggJlAiiuUIH0DSngIQMq/10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580111; c=relaxed/simple;
	bh=7PMTq5liFdrq9AL3d/OEmRder4cDS77P5CSA1CK+eWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=itEny19Ax/hBz7/PwIRjqcJVmEw1EphGWUvS9IGz5PRxscSVVGDWrJOnuf/uNrBFCkZuBbOOV5YPyxWNwx3B12D9PG0Tz8g4iaqsaZsERdsMHECOHjC8IvIc/Ou9xoJIYoPaEpj8DvNC+670dRrACKbeekZ22jxoDvZJqJ4EEaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BzjrrMWq; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742580110; x=1774116110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7PMTq5liFdrq9AL3d/OEmRder4cDS77P5CSA1CK+eWY=;
  b=BzjrrMWqjHXW+FvSuIWEZHle3lJToFNYbT7HpwDSN7U8CggCi4Mva4fa
   gI4N7HCkDqMxRdO5bNItTs1R46PWyufgNE8NUcGLIxk+6hHSD5F1C5JKz
   EP8KWdvX7GAx9VmY6EgRmGMgTgUUb3qSKjl/FJhuJcECpC2F4G0hzH+GC
   1alFSZ0ZoIixHCI04bPevYkwvPVzyfPpkXwkpHmoGLQNd+CeC3FwmEdUV
   8X9FUTD/o5eO3Mqlx/Cg3Ug7q/hxAxkccgy/xJzgnF4YMHfH4RCP1tvRY
   eFonf8VFbjNttuxd1Vh2XM2RTWTYbequVS2tygpXW+Nr/LpoUaGkPRyNq
   w==;
X-CSE-ConnectionGUID: +7wu/tfYQ0aLiEfTkWHpLQ==
X-CSE-MsgGUID: xJxhuvkvQlOqT0bmOmZe6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="55234687"
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="55234687"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 11:01:48 -0700
X-CSE-ConnectionGUID: vAJOZdh2QvWCU98TLX40gA==
X-CSE-MsgGUID: hPOg2vHkQwCKUluNJ8hJAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="160694127"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa001.jf.intel.com with ESMTP; 21 Mar 2025 11:01:48 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com
Cc: jgg@nvidia.com,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v9 5/5] iommufd/selftest: Add coverage for reporting max_pasid_log2 via IOMMU_HW_INFO
Date: Fri, 21 Mar 2025 11:01:43 -0700
Message-Id: <20250321180143.8468-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250321180143.8468-1-yi.l.liu@intel.com>
References: <20250321180143.8468-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOMMU_HW_INFO is extended to report max_pasid_log2, hence add coverage
for it.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 tools/testing/selftests/iommu/iommufd.c        | 18 ++++++++++++++++++
 .../testing/selftests/iommu/iommufd_fail_nth.c |  3 ++-
 tools/testing/selftests/iommu/iommufd_utils.h  | 17 +++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index c39222b9869b..7eb7ee149f2b 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -342,12 +342,14 @@ FIXTURE(iommufd_ioas)
 	uint32_t hwpt_id;
 	uint32_t device_id;
 	uint64_t base_iova;
+	uint32_t device_pasid_id;
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
+					   &self->device_pasid_id);
 }
 
 FIXTURE_TEARDOWN(iommufd_ioas)
@@ -387,6 +395,7 @@ FIXTURE_VARIANT_ADD(iommufd_ioas, no_domain)
 FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain)
 {
 	.mock_domains = 1,
+	.pasid_capable = true,
 };
 
 FIXTURE_VARIANT_ADD(iommufd_ioas, two_mock_domain)
@@ -752,6 +761,8 @@ TEST_F(iommufd_ioas, get_hw_info)
 	} buffer_smaller;
 
 	if (self->device_id) {
+		uint8_t max_pasid = 0;
+
 		/* Provide a zero-size user_buffer */
 		test_cmd_get_hw_info(self->device_id, NULL, 0);
 		/* Provide a user_buffer with exact size */
@@ -766,6 +777,13 @@ TEST_F(iommufd_ioas, get_hw_info)
 		 * the fields within the size range still gets updated.
 		 */
 		test_cmd_get_hw_info(self->device_id, &buffer_smaller, sizeof(buffer_smaller));
+		test_cmd_get_hw_info_pasid(self->device_id, &max_pasid);
+		ASSERT_EQ(0, max_pasid);
+		if (variant->pasid_capable) {
+			test_cmd_get_hw_info_pasid(self->device_pasid_id,
+						   &max_pasid);
+			ASSERT_EQ(MOCK_PASID_WIDTH, max_pasid);
+		}
 	} else {
 		test_err_get_hw_info(ENOENT, self->device_id,
 				     &buffer_exact, sizeof(buffer_exact));
diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
index 8fd6f4500090..e11ec4b121fc 100644
--- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
+++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
@@ -666,7 +666,8 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 					&self->stdev_id, NULL, &idev_id))
 		return -1;
 
-	if (_test_cmd_get_hw_info(self->fd, idev_id, &info, sizeof(info), NULL))
+	if (_test_cmd_get_hw_info(self->fd, idev_id, &info,
+				  sizeof(info), NULL, NULL))
 		return -1;
 
 	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0,
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 27794b6f58fc..72f6636e5d90 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -758,7 +758,8 @@ static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
 
 /* @data can be NULL */
 static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
-				 size_t data_len, uint32_t *capabilities)
+				 size_t data_len, uint32_t *capabilities,
+				 uint8_t *max_pasid)
 {
 	struct iommu_test_hw_info *info = (struct iommu_test_hw_info *)data;
 	struct iommu_hw_info cmd = {
@@ -803,6 +804,9 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
 			assert(!info->flags);
 	}
 
+	if (max_pasid)
+		*max_pasid = cmd.out_max_pasid_log2;
+
 	if (capabilities)
 		*capabilities = cmd.out_capabilities;
 
@@ -811,14 +815,19 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
 
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


