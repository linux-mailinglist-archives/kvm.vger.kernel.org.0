Return-Path: <kvm+bounces-40926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D2DA5F4DF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 13:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EF9642016D
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 12:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C97D267B06;
	Thu, 13 Mar 2025 12:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BeAchXyk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD712676F3
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741870081; cv=none; b=KlEZA7Pf4aalUurFqH+96Rgbqp+YldHfajeyatJ/Ac58NyriTF/IzR2BDeWPkBPw1KeT2utXZpAIpDFtMPF4Zn1CIN2WVI8xB1RsWRinCCLo868tKlQsCgCPzQXVpUvbuN72kGxRpTD1FDU/4uJHoBp6T1KstMOM+Kf7rBNZ8PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741870081; c=relaxed/simple;
	bh=LRaXO1+32bJRdfqcjTqD5LQPp1lOusyunjM2/8RSuoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MpH28uDzzCSPdBCqk0N4jON8J6JqAnWHeAIeOBsnUhzEaLMWmjJpycllNHGAPJ6CkR33TQHbqIul5Ci786JtXZh+/8gK92yPtQl6NCJwHsweJgQXIDj0TPRUAR3XlgiPX/v+r0ZEhM32e8A72qfC/Puo9D+X2oYTzt4KyuJQJnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BeAchXyk; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741870081; x=1773406081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LRaXO1+32bJRdfqcjTqD5LQPp1lOusyunjM2/8RSuoQ=;
  b=BeAchXykZqgk78B8k+RE6Zxj35YCPkfFOKn2AJJ1evxzMcHMp5mC/Ict
   DsRvWQW4dNMtspkqZBrH0b9ahjFOhgz+GT44SYAvkdh0NiXeN/s4fzJ1G
   j+v/KR6xgoKWoUJ0RVMED8HvCDqOe0lAQZC+Wpl3e/kjHsRhViDCwVD2B
   FKnSoY6E86DsMZGFxhgBU4eKVPalUg2flxTIYYBuPxsWE+6AqtiKpM//o
   MwHfM1lVMEU2qSSUkGYzC6EfgMLyELfqmlf2Ia8tMNkSsG6QNqbfb4GDn
   yaOWpy+ba46LniVw31iNOKmtBpsclai01MHLop3RzrIUVzSp/EkomJzE+
   g==;
X-CSE-ConnectionGUID: KhycJIAYTj65tVtt+rKLwg==
X-CSE-MsgGUID: 5Bl8R8EjQDmzeW9zwMDDeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="60383583"
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="60383583"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 05:47:56 -0700
X-CSE-ConnectionGUID: LaqVLtGzQxa9vNiItoNApw==
X-CSE-MsgGUID: F46jp/s6SeK6IFKOixQIgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="158095337"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa001.jf.intel.com with ESMTP; 13 Mar 2025 05:47:55 -0700
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
Subject: [PATCH v8 5/5] iommufd/selftest: Add coverage for reporting max_pasid_log2 via IOMMU_HW_INFO
Date: Thu, 13 Mar 2025 05:47:53 -0700
Message-Id: <20250313124753.185090-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250313124753.185090-1-yi.l.liu@intel.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
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
index c41d15e91983..f06e0f554608 100644
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


