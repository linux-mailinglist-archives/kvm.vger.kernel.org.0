Return-Path: <kvm+bounces-30543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB989BB5F9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FD141F225EB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AC01B2186;
	Mon,  4 Nov 2024 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ii9VliHX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B2313D53D
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726728; cv=none; b=jvG7pZIFWMUMr5ClY9QBjkUGGkq4+vj7mzD2hdMm+/+iWz7L+h7O5GWsMLkyaZVe+NpK3J95lxyStiHen4bVALw917tIPLzQtokKGyTtL9renYgAaOi8MNW2rn3ZvzZwd5KIoAHI1282j/N284oRPYpmS2XCdCRpEdCxnVIVIM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726728; c=relaxed/simple;
	bh=WIkvyR2SPyUOp3vYWoZiGBHJktVqSnBxUhDb2fGeyxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AAUrvnif/rGmumo1efidv6JX7prDtoOblKOIO0bhJdU2d1XuOlLAlqwjcXrDBe6aUitotMB2gBZKdobCEleqjbOiBw42f8JsSq5WHbT7ZaNrKAU4YHcpCWokqzrr2cq/LcvMe7hCpZoCmoDJLQJohUbr5Y6TZ3r8AY1Fl2GM6iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ii9VliHX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726726; x=1762262726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WIkvyR2SPyUOp3vYWoZiGBHJktVqSnBxUhDb2fGeyxM=;
  b=Ii9VliHX61LhxOio5ijKBTfmWAXWAaND4bymgVJ2hYWF9AU6thqvyuRp
   +phmcTTdZvF6BW4EmPbJ//9zUynysN6L8Nkeq7GbJeuJryzRp/b3MEOLv
   htoCA9lBfx4VTp2PZNQFkhSVfaxu5KOfNJFCRBR+guzQ17B2isgSa0IyJ
   1EyToXSKK7Pvkz81y82WRn2AcyDJbD3sTFRZ8FFVn+GvlU6ZQ7COnufvj
   RV9fes8mlxhIImO3hBbFScX9oLZ6gJ+Mo8ygpd2s2M6GVmBNaav4qDulK
   KhsOfwYTmYLa7yO2KV/CJ4F3vGUB2he/qvRDrSW5C3MF6/MYv+W+xjXk7
   g==;
X-CSE-ConnectionGUID: RMXxElcMT+iOQ9JXVljh4Q==
X-CSE-MsgGUID: woQRZOqSRWCKjaybMlFWhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884100"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884100"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:23 -0800
X-CSE-ConnectionGUID: l8rfGudsRlCO8w+Zl/v4Yw==
X-CSE-MsgGUID: KQMqAJnuTzuvVe8XUu2yIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100510"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:22 -0800
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
Subject: [PATCH v5 12/12] iommufd/selftest: Add coverage for iommufd pasid attach/detach
Date: Mon,  4 Nov 2024 05:25:13 -0800
Message-Id: <20241104132513.15890-13-yi.l.liu@intel.com>
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

This tests iommufd pasid attach/replace/detach.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 tools/testing/selftests/iommu/iommufd.c       | 277 ++++++++++++++++++
 .../selftests/iommu/iommufd_fail_nth.c        |  35 ++-
 tools/testing/selftests/iommu/iommufd_utils.h |  78 +++++
 3 files changed, 384 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 4927b9add5ad..f44d55f53f15 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -2386,4 +2386,281 @@ TEST_F(vfio_compat_mock_domain, huge_map)
 	}
 }
 
+FIXTURE(iommufd_device_pasid)
+{
+	int fd;
+	uint32_t ioas_id;
+	uint32_t hwpt_id;
+	uint32_t stdev_id;
+	uint32_t device_id;
+};
+
+FIXTURE_SETUP(iommufd_device_pasid)
+{
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	test_ioctl_ioas_alloc(&self->ioas_id);
+
+	test_cmd_mock_domain_flags(self->ioas_id,
+				   MOCK_FLAGS_DEVICE_PASID,
+				   &self->stdev_id, &self->hwpt_id,
+				   &self->device_id);
+}
+
+FIXTURE_TEARDOWN(iommufd_device_pasid)
+{
+	teardown_iommufd(self->fd, _metadata);
+}
+
+TEST_F(iommufd_device_pasid, pasid_attach)
+{
+	if (self->device_id) {
+		struct iommu_hwpt_selftest data = {
+			.iotlb =  IOMMU_TEST_IOTLB_DEFAULT,
+		};
+		uint32_t nested_hwpt_id[2] = {};
+		uint32_t no_pasid_compat_hwpt;
+		uint32_t parent_hwpt_id = 0;
+		uint32_t fault_id, fault_fd;
+		uint32_t iopf_hwpt_id;
+		uint32_t pasid = 100;
+		bool result;
+
+		/* Allocate two nested hwpts sharing one common parent hwpt */
+		test_cmd_hwpt_alloc(self->device_id, self->ioas_id,
+				    IOMMU_HWPT_ALLOC_NEST_PARENT |
+				    IOMMU_HWPT_ALLOC_PASID,
+				    &parent_hwpt_id);
+
+		test_cmd_hwpt_alloc_nested(self->device_id, parent_hwpt_id,
+					   IOMMU_HWPT_ALLOC_PASID,
+					   &nested_hwpt_id[0],
+					   IOMMU_HWPT_DATA_SELFTEST,
+					   &data, sizeof(data));
+		test_cmd_hwpt_alloc_nested(self->device_id, parent_hwpt_id,
+					   IOMMU_HWPT_ALLOC_PASID,
+					   &nested_hwpt_id[1],
+					   IOMMU_HWPT_DATA_SELFTEST,
+					   &data, sizeof(data));
+
+		test_ioctl_fault_alloc(&fault_id, &fault_fd);
+		test_cmd_hwpt_alloc_iopf(self->device_id, parent_hwpt_id, fault_id,
+					 IOMMU_HWPT_FAULT_ID_VALID | IOMMU_HWPT_ALLOC_PASID,
+					 &iopf_hwpt_id,
+					 IOMMU_HWPT_DATA_SELFTEST, &data,
+					 sizeof(data));
+		/*
+		 * Attach ioas to pasid 100, should succeed, domain should
+		 * be valid.
+		 */
+		test_cmd_pasid_attach(pasid, self->ioas_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, self->hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Try attach pasid 100 with self->ioas_id, should succeed
+		 * as it is the same with existing hwpt.
+		 */
+		test_cmd_pasid_attach(pasid, self->ioas_id);
+
+		/*
+		 * Try attach pasid 100 with another hwpt, should FAIL
+		 * as attach does not allow overwrite, use REPLACE instead.
+		 */
+		test_err_cmd_pasid_attach(EBUSY, pasid, nested_hwpt_id[0]);
+
+		/*
+		 * Detach hwpt from pasid 100, and check if the pasid 100
+		 * has null domain. Should be done before the next attach.
+		 */
+		test_cmd_pasid_detach(pasid);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, 0, &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Attach nested hwpt to pasid 100, should succeed, domain
+		 * should be valid.
+		 */
+		test_cmd_pasid_attach(pasid, nested_hwpt_id[0]);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, nested_hwpt_id[0],
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Detach hwpt from pasid 100, and check if the pasid 100
+		 * has null domain
+		 */
+		test_cmd_pasid_detach(pasid);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, 0, &result));
+		EXPECT_EQ(1, result);
+
+		/* Replace tests */
+		pasid = 200;
+
+		/*
+		 * Replace pasid 200 without attaching it first, should
+		 * fail with -EINVAL.
+		 */
+		test_err_cmd_pasid_replace(EINVAL, pasid, parent_hwpt_id);
+
+		/*
+		 * Attach a s2 hwpt to pasid 200, should succeed, domain should
+		 * be valid.
+		 */
+		test_cmd_pasid_attach(pasid, parent_hwpt_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, parent_hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Replace pasid 200 with self->ioas_id, should succeed,
+		 * and have valid domain.
+		 */
+		test_cmd_pasid_replace(pasid, self->ioas_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, self->hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Replace a nested hwpt for pasid 200, should succeed,
+		 * and have valid domain.
+		 */
+		test_cmd_pasid_replace(pasid, nested_hwpt_id[0]);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, nested_hwpt_id[0],
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Replace with another nested hwpt for pasid 200, should
+		 * succeed, and have valid domain.
+		 */
+		test_cmd_pasid_replace(pasid, nested_hwpt_id[1]);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, nested_hwpt_id[1],
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Detach hwpt from pasid 200, and check if the pasid 200
+		 * has null domain.
+		 */
+		test_cmd_pasid_detach(pasid);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, 0, &result));
+		EXPECT_EQ(1, result);
+
+		/* Negative Tests for pasid replace, use pasid 1024 */
+
+		/*
+		 * Attach a s2 hwpt to pasid 1024, should succeed, domain should
+		 * be valid.
+		 */
+		pasid = 1024;
+		test_cmd_pasid_attach(pasid, parent_hwpt_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, parent_hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Replace pasid 1024 with self->ioas_id, should fail,
+		 * but have the old valid domain. This is a designed
+		 * negative case, normally replace with self->ioas_id
+		 * could succeed.
+		 */
+		test_err_cmd_pasid_replace(ENOMEM, pasid, self->ioas_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, parent_hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Detach hwpt from pasid 1024, and check if the pasid 1024
+		 * has null domain.
+		 */
+		test_cmd_pasid_detach(pasid);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, 0, &result));
+		EXPECT_EQ(1, result);
+
+		/* Attach to iopf-capable hwpt */
+
+		/*
+		 * Attach an iopf hwpt to pasid 2048, should succeed, domain should
+		 * be valid.
+		 */
+		pasid = 2048;
+		test_cmd_pasid_attach(pasid, iopf_hwpt_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, iopf_hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Replace with parent_hwpt_id for pasid 2048, should
+		 * succeed, and have valid domain.
+		 */
+		test_cmd_pasid_replace(pasid, parent_hwpt_id);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, parent_hwpt_id,
+						      &result));
+		EXPECT_EQ(1, result);
+
+		/*
+		 * Detach hwpt from pasid 2048, and check if the pasid 2048
+		 * has null domain.
+		 */
+		test_cmd_pasid_detach(pasid);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, 0, &result));
+		EXPECT_EQ(1, result);
+
+		test_ioctl_destroy(iopf_hwpt_id);
+		close(fault_fd);
+		test_ioctl_destroy(fault_id);
+
+		/* Negative */
+		/*
+		 * Attach non pasid compat hwpt to pasid-capable device, should
+		 * fail, and have null domain.
+		 */
+		test_cmd_hwpt_alloc(self->device_id, self->ioas_id,
+				    IOMMU_HWPT_ALLOC_NEST_PARENT,
+				    &no_pasid_compat_hwpt);
+		test_err_cmd_pasid_attach(EINVAL, pasid, no_pasid_compat_hwpt);
+		ASSERT_EQ(0,
+			  test_cmd_pasid_check_domain(self->fd, self->stdev_id,
+						      pasid, 0, &result));
+		EXPECT_EQ(1, result);
+		test_ioctl_destroy(no_pasid_compat_hwpt);
+
+		test_ioctl_destroy(nested_hwpt_id[0]);
+		test_ioctl_destroy(nested_hwpt_id[1]);
+		test_ioctl_destroy(parent_hwpt_id);
+	}
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
index c5d5e69452b0..72b87ed82a6b 100644
--- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
+++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
@@ -206,12 +206,16 @@ FIXTURE(basic_fail_nth)
 {
 	int fd;
 	uint32_t access_id;
+	uint32_t stdev_id;
+	uint32_t pasid;
 };
 
 FIXTURE_SETUP(basic_fail_nth)
 {
 	self->fd = -1;
 	self->access_id = 0;
+	self->stdev_id = 0;
+	self->pasid = 0; //test should use a non-zero value
 }
 
 FIXTURE_TEARDOWN(basic_fail_nth)
@@ -223,6 +227,8 @@ FIXTURE_TEARDOWN(basic_fail_nth)
 		rc = _test_cmd_destroy_access(self->access_id);
 		assert(rc == 0);
 	}
+	if (self->pasid && self->stdev_id)
+		_test_cmd_pasid_detach(self->fd, self->stdev_id, self->pasid);
 	teardown_iommufd(self->fd, _metadata);
 }
 
@@ -579,7 +585,6 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 	struct iommu_test_hw_info info;
 	uint32_t ioas_id;
 	uint32_t ioas_id2;
-	uint32_t stdev_id;
 	uint32_t idev_id;
 	uint32_t hwpt_id;
 	__u64 iova;
@@ -608,22 +613,40 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 
 	fail_nth_enable();
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, NULL,
-				  &idev_id))
+	if (_test_cmd_mock_domain_flags(self->fd, ioas_id,
+					MOCK_FLAGS_DEVICE_PASID,
+					&self->stdev_id, NULL, &idev_id))
 		return -1;
 
 	if (_test_cmd_get_hw_info(self->fd, idev_id, &info, sizeof(info), NULL))
 		return -1;
 
-	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0, 0, &hwpt_id,
+	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0,
+				 IOMMU_HWPT_ALLOC_PASID, &hwpt_id,
 				 IOMMU_HWPT_DATA_NONE, 0, 0))
 		return -1;
 
-	if (_test_cmd_mock_domain_replace(self->fd, stdev_id, ioas_id2, NULL))
+	if (_test_cmd_mock_domain_replace(self->fd, self->stdev_id, ioas_id2, NULL))
+		return -1;
+
+	if (_test_cmd_mock_domain_replace(self->fd, self->stdev_id, hwpt_id, NULL))
 		return -1;
 
-	if (_test_cmd_mock_domain_replace(self->fd, stdev_id, hwpt_id, NULL))
+	self->pasid = 200;
+
+	/* Tests for pasid attach/replace/detach */
+	if (_test_cmd_pasid_attach(self->fd, self->stdev_id, self->pasid, ioas_id)) {
+		self->pasid = 0;
 		return -1;
+	}
+
+	_test_cmd_pasid_replace(self->fd, self->stdev_id, self->pasid, ioas_id2);
+
+	if (_test_cmd_pasid_detach(self->fd, self->stdev_id, self->pasid))
+		return -1;
+
+	self->pasid = 0;
+
 	return 0;
 }
 
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 40f6f14ce136..399e023993fc 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -762,3 +762,81 @@ static int _test_cmd_trigger_iopf(int fd, __u32 device_id, __u32 fault_fd)
 
 #define test_cmd_trigger_iopf(device_id, fault_fd) \
 	ASSERT_EQ(0, _test_cmd_trigger_iopf(self->fd, device_id, fault_fd))
+
+static int _test_cmd_pasid_attach(int fd, __u32 stdev_id, __u32 pasid, __u32 pt_id)
+{
+	struct iommu_test_cmd test_attach = {
+		.size = sizeof(test_attach),
+		.op = IOMMU_TEST_OP_PASID_ATTACH,
+		.id = stdev_id,
+		.pasid_attach = {
+			.pasid = pasid,
+			.pt_id = pt_id,
+		},
+	};
+
+	return ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_PASID_ATTACH), &test_attach);
+}
+
+#define test_cmd_pasid_attach(pasid, hwpt_id) \
+	ASSERT_EQ(0, _test_cmd_pasid_attach(self->fd, self->stdev_id, pasid, hwpt_id))
+
+#define test_err_cmd_pasid_attach(_errno, pasid, hwpt_id) \
+	EXPECT_ERRNO(_errno, \
+		     _test_cmd_pasid_attach(self->fd, self->stdev_id, pasid, hwpt_id))
+
+static int _test_cmd_pasid_replace(int fd, __u32 stdev_id, __u32 pasid, __u32 pt_id)
+{
+	struct iommu_test_cmd test_replace = {
+		.size = sizeof(test_replace),
+		.op = IOMMU_TEST_OP_PASID_REPLACE,
+		.id = stdev_id,
+		.pasid_replace = {
+			.pasid = pasid,
+			.pt_id = pt_id,
+		},
+	};
+
+	return ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_PASID_REPLACE), &test_replace);
+}
+
+#define test_cmd_pasid_replace(pasid, hwpt_id) \
+	ASSERT_EQ(0, _test_cmd_pasid_replace(self->fd, self->stdev_id, pasid, hwpt_id))
+
+#define test_err_cmd_pasid_replace(_errno, pasid, hwpt_id) \
+	EXPECT_ERRNO(_errno, \
+		     _test_cmd_pasid_replace(self->fd, self->stdev_id, pasid, hwpt_id))
+
+static int _test_cmd_pasid_detach(int fd, __u32 stdev_id, __u32 pasid)
+{
+	struct iommu_test_cmd test_detach = {
+		.size = sizeof(test_detach),
+		.op = IOMMU_TEST_OP_PASID_DETACH,
+		.id = stdev_id,
+		.pasid_detach = {
+			.pasid = pasid,
+		},
+	};
+
+	return ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_PASID_DETACH), &test_detach);
+}
+
+#define test_cmd_pasid_detach(pasid) \
+	ASSERT_EQ(0, _test_cmd_pasid_detach(self->fd, self->stdev_id, pasid))
+
+static int test_cmd_pasid_check_domain(int fd, __u32 stdev_id, __u32 pasid,
+				       __u32 hwpt_id, bool *result)
+{
+	struct iommu_test_cmd test_pasid_check = {
+		.size = sizeof(test_pasid_check),
+		.op = IOMMU_TEST_OP_PASID_CHECK_DOMAIN,
+		.id = stdev_id,
+		.pasid_check = {
+			.pasid = pasid,
+			.hwpt_id = hwpt_id,
+			.out_result_ptr = (__u64)result,
+		},
+	};
+
+	return ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_PASID_CHECK_DOMAIN), &test_pasid_check);
+}
-- 
2.34.1


