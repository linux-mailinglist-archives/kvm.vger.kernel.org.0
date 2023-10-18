Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4E67CE8EF
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjJRUa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjJRUaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:30:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D5E10EC
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:29:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IImurS006129;
        Wed, 18 Oct 2023 20:28:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=75N00iRmgIX8EaDs4ZX1DN/bGYrjedUfoLbvZrd3lH4=;
 b=qrWyzJx5AYDZsfJvW5Gy3uw8XqUw6Cd16G3ciW87EEXDdY7bU+G50atqfwFT/S/R2Jv3
 Mqb5QOCBhaVfzvE/ZFFjO0Q2y5FhkD8MmsGvtnbxhK/lP2GV7oGrs+qOt+Nkg9xPeW4N
 tVNfX3GsWOmJUmWFVTHL1iNicjm26xQy5/qidYBU/PAQnbo9BRT8UlXGyKmjmA2LRkad
 h8ktLKsTL9XLhBEFjJZcgNBN4CcrF2EmUsQQfYRpTB2CXoYzusiY6kiXjDo8nOSSIRou
 QfSOUSFbOHxtAZXk3PBY7jviG2J7KdajbTboUHktNpeBUvT8AdBDG7BamsHjW/ImnyjZ JA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynghuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IJs8JP009825;
        Wed, 18 Oct 2023 20:28:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps7wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:50 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5t040635;
        Wed, 18 Oct 2023 20:28:50 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-17;
        Wed, 18 Oct 2023 20:28:50 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v4 16/18] iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_IOVA
Date:   Wed, 18 Oct 2023 21:27:13 +0100
Message-Id: <20231018202715.69734-17-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-1-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180169
X-Proofpoint-GUID: uyeXpdOvC8x-VzO3UYMMEiEs4UtyErNP
X-Proofpoint-ORIG-GUID: uyeXpdOvC8x-VzO3UYMMEiEs4UtyErNP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new test ioctl for simulating the dirty IOVAs in the mock domain, and
implement the mock iommu domain ops that get the dirty tracking supported.

The selftest exercises the usual main workflow of:

1) Setting dirty tracking from the iommu domain
2) Read and clear dirty IOPTEs

Different fixtures will test different IOVA range sizes, that exercise
corner cases of the bitmaps.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/iommufd_test.h          |   9 ++
 drivers/iommu/iommufd/selftest.c              |  88 +++++++++++++-
 tools/testing/selftests/iommu/iommufd.c       |  99 ++++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h | 109 ++++++++++++++++++
 4 files changed, 302 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 9817edcd8968..1f2e93d3d4e8 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -20,6 +20,7 @@ enum {
 	IOMMU_TEST_OP_MOCK_DOMAIN_REPLACE,
 	IOMMU_TEST_OP_ACCESS_REPLACE_IOAS,
 	IOMMU_TEST_OP_MOCK_DOMAIN_FLAGS,
+	IOMMU_TEST_OP_DIRTY,
 };
 
 enum {
@@ -107,6 +108,14 @@ struct iommu_test_cmd {
 		struct {
 			__u32 ioas_id;
 		} access_replace_ioas;
+		struct {
+			__u32 flags;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+			__aligned_u64 page_size;
+			__aligned_u64 uptr;
+			__aligned_u64 out_nr_dirty;
+		} dirty;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index fcbb4e1d88d4..4ba10dbc63d0 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -37,6 +37,7 @@ enum {
 	_MOCK_PFN_START = MOCK_PFN_MASK + 1,
 	MOCK_PFN_START_IOVA = _MOCK_PFN_START,
 	MOCK_PFN_LAST_IOVA = _MOCK_PFN_START,
+	MOCK_PFN_DIRTY_IOVA = _MOCK_PFN_START << 1,
 };
 
 /*
@@ -181,6 +182,31 @@ static int mock_domain_read_and_clear_dirty(struct iommu_domain *domain,
 					    unsigned long flags,
 					    struct iommu_dirty_bitmap *dirty)
 {
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	unsigned long i, max = size / MOCK_IO_PAGE_SIZE;
+	void *ent, *old;
+
+	if (!(mock->flags & MOCK_DIRTY_TRACK) && dirty->bitmap)
+		return -EINVAL;
+
+	for (i = 0; i < max; i++) {
+		unsigned long cur = iova + i * MOCK_IO_PAGE_SIZE;
+
+		ent = xa_load(&mock->pfns, cur / MOCK_IO_PAGE_SIZE);
+		if (ent &&
+		    (xa_to_value(ent) & MOCK_PFN_DIRTY_IOVA)) {
+			unsigned long val;
+
+			/* Clear dirty */
+			val = xa_to_value(ent) & ~MOCK_PFN_DIRTY_IOVA;
+			old = xa_store(&mock->pfns, cur / MOCK_IO_PAGE_SIZE,
+				       xa_mk_value(val), GFP_KERNEL);
+			WARN_ON_ONCE(ent != old);
+			iommu_dirty_bitmap_record(dirty, cur, MOCK_IO_PAGE_SIZE);
+		}
+	}
+
 	return 0;
 }
 
@@ -313,7 +339,7 @@ static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
 
 		for (cur = 0; cur != pgsize; cur += MOCK_IO_PAGE_SIZE) {
 			ent = xa_erase(&mock->pfns, iova / MOCK_IO_PAGE_SIZE);
-			WARN_ON(!ent);
+
 			/*
 			 * iommufd generates unmaps that must be a strict
 			 * superset of the map's performend So every starting
@@ -323,12 +349,12 @@ static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
 			 * passed to map_pages
 			 */
 			if (first) {
-				WARN_ON(!(xa_to_value(ent) &
+				WARN_ON(ent && !(xa_to_value(ent) &
 					  MOCK_PFN_START_IOVA));
 				first = false;
 			}
 			if (pgcount == 1 && cur + MOCK_IO_PAGE_SIZE == pgsize)
-				WARN_ON(!(xa_to_value(ent) &
+				WARN_ON(ent && !(xa_to_value(ent) &
 					  MOCK_PFN_LAST_IOVA));
 
 			iova += MOCK_IO_PAGE_SIZE;
@@ -1056,6 +1082,56 @@ static_assert((unsigned int)MOCK_ACCESS_RW_WRITE == IOMMUFD_ACCESS_RW_WRITE);
 static_assert((unsigned int)MOCK_ACCESS_RW_SLOW_PATH ==
 	      __IOMMUFD_ACCESS_RW_SLOW_PATH);
 
+static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
+			      unsigned int mockpt_id, unsigned long iova,
+			      size_t length, unsigned long page_size,
+			      void __user *uptr, u32 flags)
+{
+	unsigned long i, max = length / page_size;
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	int rc, count = 0;
+
+	if (iova % page_size || length % page_size ||
+	    (uintptr_t)uptr % page_size)
+		return -EINVAL;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	if (!(mock->flags & MOCK_DIRTY_TRACK)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+
+	for (i = 0; i < max; i++) {
+		unsigned long cur = iova + i * page_size;
+		void *ent, *old;
+
+		if (!test_bit(i, (unsigned long *) uptr))
+			continue;
+
+		ent = xa_load(&mock->pfns, cur / page_size);
+		if (ent) {
+			unsigned long val;
+
+			val = xa_to_value(ent) | MOCK_PFN_DIRTY_IOVA;
+			old = xa_store(&mock->pfns, cur / page_size,
+				       xa_mk_value(val), GFP_KERNEL);
+			WARN_ON_ONCE(ent != old);
+			count++;
+		}
+	}
+
+	cmd->dirty.out_nr_dirty = count;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
+
 void iommufd_selftest_destroy(struct iommufd_object *obj)
 {
 	struct selftest_obj *sobj = container_of(obj, struct selftest_obj, obj);
@@ -1121,6 +1197,12 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 			return -EINVAL;
 		iommufd_test_memory_limit = cmd->memory_limit.limit;
 		return 0;
+	case IOMMU_TEST_OP_DIRTY:
+		return iommufd_test_dirty(
+			ucmd, cmd->id, cmd->dirty.iova,
+			cmd->dirty.length, cmd->dirty.page_size,
+			u64_to_user_ptr(cmd->dirty.uptr),
+			cmd->dirty.flags);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index ab1536d6b4db..e12e0731e414 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -12,6 +12,7 @@
 static unsigned long HUGEPAGE_SIZE;
 
 #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
+#define BITS_PER_BYTE 8
 
 static unsigned long get_huge_page_size(void)
 {
@@ -1440,13 +1441,47 @@ FIXTURE(iommufd_dirty_tracking)
 	uint32_t hwpt_id;
 	uint32_t stdev_id;
 	uint32_t idev_id;
+	unsigned long page_size;
+	unsigned long bitmap_size;
+	void *bitmap;
+	void *buffer;
+};
+
+FIXTURE_VARIANT(iommufd_dirty_tracking)
+{
+	unsigned long buffer_size;
 };
 
 FIXTURE_SETUP(iommufd_dirty_tracking)
 {
+	void *vrc;
+	int rc;
+
 	self->fd = open("/dev/iommu", O_RDWR);
 	ASSERT_NE(-1, self->fd);
 
+	rc = posix_memalign(&self->buffer, HUGEPAGE_SIZE, variant->buffer_size);
+	if (rc || !self->buffer) {
+		SKIP(return, "Skipping buffer_size=%lu due to errno=%d",
+			     variant->buffer_size, rc);
+	}
+
+	assert((uintptr_t)self->buffer % HUGEPAGE_SIZE == 0);
+	vrc = mmap(self->buffer, variant->buffer_size, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	assert(vrc == self->buffer);
+
+	self->page_size = MOCK_PAGE_SIZE;
+	self->bitmap_size = variant->buffer_size /
+			     self->page_size / BITS_PER_BYTE;
+
+	/* Provision with an extra (MOCK_PAGE_SIZE) for the unaligned case */
+	rc = posix_memalign(&self->bitmap, PAGE_SIZE,
+			    self->bitmap_size + MOCK_PAGE_SIZE);
+	assert(!rc);
+	assert(self->bitmap);
+	assert((uintptr_t)self->bitmap % PAGE_SIZE == 0);
+
 	test_ioctl_ioas_alloc(&self->ioas_id);
 	test_cmd_mock_domain(self->ioas_id, &self->stdev_id,
 			     &self->hwpt_id, &self->idev_id);
@@ -1454,9 +1489,41 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 
 FIXTURE_TEARDOWN(iommufd_dirty_tracking)
 {
+	munmap(self->buffer, variant->buffer_size);
+	munmap(self->bitmap, self->bitmap_size);
 	teardown_iommufd(self->fd, _metadata);
 }
 
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128k)
+{
+	/* one u32 index bitmap */
+	.buffer_size = 128UL * 1024UL,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty256k)
+{
+	/* one u64 index bitmap */
+	.buffer_size = 256UL * 1024UL,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty640k)
+{
+	/* two u64 index and trailing end bitmap */
+	.buffer_size = 640UL * 1024UL,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128M)
+{
+	/* 4K bitmap (128M IOVA range) */
+	.buffer_size = 128UL * 1024UL * 1024UL,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty256M)
+{
+	/* 8K bitmap (256M IOVA range) */
+	.buffer_size = 256UL * 1024UL * 1024UL,
+};
+
 TEST_F(iommufd_dirty_tracking, enforce_dirty)
 {
 	uint32_t ioas_id, stddev_id, idev_id;
@@ -1497,6 +1564,38 @@ TEST_F(iommufd_dirty_tracking, set_dirty)
 	test_ioctl_destroy(hwpt_id);
 }
 
+TEST_F(iommufd_dirty_tracking, get_dirty_iova)
+{
+	uint32_t stddev_id;
+	uint32_t hwpt_id;
+	uint32_t ioas_id;
+
+	test_ioctl_ioas_alloc(&ioas_id);
+	test_ioctl_ioas_map_fixed_id(ioas_id, self->buffer,
+				     variant->buffer_size,
+				     MOCK_APERTURE_START);
+
+	test_cmd_hwpt_alloc(self->idev_id, ioas_id,
+			    IOMMU_HWPT_ALLOC_ENFORCE_DIRTY, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+
+	test_cmd_set_dirty(hwpt_id, true);
+
+	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
+				MOCK_APERTURE_START,
+				self->page_size, self->bitmap,
+				self->bitmap_size, _metadata);
+
+	/* PAGE_SIZE unaligned bitmap */
+	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
+				MOCK_APERTURE_START,
+				self->page_size, self->bitmap + MOCK_PAGE_SIZE,
+				self->bitmap_size, _metadata);
+
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 5214ae17b19a..1ff93f812a32 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -9,6 +9,8 @@
 #include <sys/ioctl.h>
 #include <stdint.h>
 #include <assert.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
 
 #include "../kselftest_harness.h"
 #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
@@ -200,6 +202,102 @@ static int _test_cmd_set_dirty(int fd, __u32 hwpt_id, bool enabled)
 #define test_cmd_set_dirty(hwpt_id, enabled) \
 	ASSERT_EQ(0, _test_cmd_set_dirty(self->fd, hwpt_id, enabled))
 
+static int _test_cmd_get_dirty_iova(int fd, __u32 hwpt_id, size_t length,
+				    __u64 iova, size_t page_size, __u64 *bitmap)
+{
+	struct iommu_hwpt_get_dirty_iova cmd = {
+		.size = sizeof(cmd),
+		.hwpt_id = hwpt_id,
+		.iova = iova,
+		.length = length,
+		.page_size = page_size,
+		.data = bitmap,
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_HWPT_GET_DIRTY_IOVA, &cmd);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+#define test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap) \
+	ASSERT_EQ(0, _test_cmd_get_dirty_iova(fd, hwpt_id, length,            \
+					      iova, page_size, bitmap))
+
+static int _test_cmd_mock_domain_set_dirty(int fd, __u32 hwpt_id, size_t length,
+					   __u64 iova, size_t page_size,
+					   __u64 *bitmap, __u64 *dirty)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_DIRTY,
+		.id = hwpt_id,
+		.dirty = {
+			.iova = iova,
+			.length = length,
+			.page_size = page_size,
+			.uptr = (uintptr_t) bitmap,
+		}
+	};
+	int ret;
+
+	ret = ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_DIRTY), &cmd);
+	if (ret)
+		return -ret;
+	if (dirty)
+		*dirty = cmd.dirty.out_nr_dirty;
+	return 0;
+}
+
+#define test_cmd_mock_domain_set_dirty(fd, hwpt_id, length, iova, page_size, bitmap, nr) \
+	ASSERT_EQ(0, _test_cmd_mock_domain_set_dirty(fd, hwpt_id,            \
+						     length, iova,           \
+						     page_size, bitmap,      \
+						     nr))
+
+static int _test_mock_dirty_bitmaps(int fd, __u32 hwpt_id, size_t length,
+				    __u64 iova, size_t page_size,
+				    __u64 *bitmap, __u64 bitmap_size,
+				    struct __test_metadata *_metadata)
+{
+	unsigned long i, count, nbits = bitmap_size * BITS_PER_BYTE;
+	unsigned long nr = nbits / 2;
+	__u64 out_dirty = 0;
+
+	/* Mark all even bits as dirty in the mock domain */
+	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
+		if (!(i % 2))
+			__set_bit(i, (unsigned long *) bitmap);
+	ASSERT_EQ(nr, count);
+
+	test_cmd_mock_domain_set_dirty(fd, hwpt_id, length, iova, page_size,
+				       bitmap, &out_dirty);
+	ASSERT_EQ(nr, out_dirty);
+
+	/* Expect all even bits as dirty in the user bitmap */
+	memset(bitmap, 0, bitmap_size);
+	test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap);
+	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
+		ASSERT_EQ(!(i % 2), test_bit(i, (unsigned long *) bitmap));
+	ASSERT_EQ(count, out_dirty);
+
+	memset(bitmap, 0, bitmap_size);
+	test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap);
+
+	/* It as read already -- expect all zeroes */
+	for (i = 0; i < nbits; i++)
+		ASSERT_EQ(0, test_bit(i, (unsigned long *) bitmap));
+
+	return 0;
+}
+#define test_mock_dirty_bitmaps(hwpt_id, length, iova, page_size, bitmap, \
+				bitmap_size, _metadata) \
+	ASSERT_EQ(0, _test_mock_dirty_bitmaps(self->fd, hwpt_id,      \
+					      length, iova,           \
+					      page_size, bitmap,      \
+					      bitmap_size, _metadata))
+
 static int _test_cmd_create_access(int fd, unsigned int ioas_id,
 				   __u32 *access_id, unsigned int flags)
 {
@@ -324,6 +422,17 @@ static int _test_ioctl_ioas_map(int fd, unsigned int ioas_id, void *buffer,
 					     IOMMU_IOAS_MAP_READABLE));       \
 	})
 
+#define test_ioctl_ioas_map_fixed_id(ioas_id, buffer, length, iova)           \
+	({                                                                    \
+		__u64 __iova = iova;                                          \
+		ASSERT_EQ(0, _test_ioctl_ioas_map(                            \
+				     self->fd, ioas_id, buffer, length,       \
+				     &__iova,                                 \
+				     IOMMU_IOAS_MAP_FIXED_IOVA |              \
+					     IOMMU_IOAS_MAP_WRITEABLE |       \
+					     IOMMU_IOAS_MAP_READABLE));       \
+	})
+
 #define test_err_ioctl_ioas_map_fixed(_errno, buffer, length, iova)           \
 	({                                                                    \
 		__u64 __iova = iova;                                          \
-- 
2.17.2

