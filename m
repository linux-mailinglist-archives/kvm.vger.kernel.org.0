Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465D87D192B
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbjJTWaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjJTWaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:30:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453C4198A
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:29:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KLWBTv006466;
        Fri, 20 Oct 2023 22:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=oDONOfoOL7eeG9EmrC1/tZ8j+/FJpBmLl/Juigr7ezI=;
 b=HO5pK3oMzanwQ3h28CHBYfCbFvrR6QqhmxVI7/+xdXNDmSNRs7AnSLdOw8y6wnrdqejO
 X/61y+WpFE5/f6ZC6IKd9k6PjpMUz9zylHlpjL9N4KnkbV8udBX4ef/QyW9BhihajvRP
 RJZPeI0X/d6r1gLdSo+Hl7CLDS8kLN/Vvc2syMinzPjrUykr+wFGIfAUL5t8vLJnyHKo
 xN+36fro+8Ww+fyT3s6sIQA9KdvKZBCJLftubRLkJ4yssQD/rDNh3oYf7/lOjPdvC2pg
 Sppott8rkgkfTLLtP++N31QH+sE1kwU5iN3/z6n1jH5wahV6ZO6OhnIyiCgT7cCLDG1i 4g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwcjtug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:29:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KL7TPW025701;
        Fri, 20 Oct 2023 22:29:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdud93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:29:16 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KMSAsU018735;
        Fri, 20 Oct 2023 22:29:16 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-179-153.vpn.oracle.com [10.175.179.153])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tubwduch3-19;
        Fri, 20 Oct 2023 22:29:15 +0000
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
Subject: [PATCH v5 18/18] iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR flag
Date:   Fri, 20 Oct 2023 23:28:04 +0100
Message-Id: <20231020222804.21850-19-joao.m.martins@oracle.com>
In-Reply-To: <20231020222804.21850-1-joao.m.martins@oracle.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=933 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200191
X-Proofpoint-ORIG-GUID: mdXzkU6Tuh61ZIjrkX72iystZjXdYXeU
X-Proofpoint-GUID: mdXzkU6Tuh61ZIjrkX72iystZjXdYXeU
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change test_mock_dirty_bitmaps() to pass a flag where it specifies the flag
under test. The test does the same thing as the GET_DIRTY_BITMAP regular
test. Except that it tests whether the dirtied bits are fetched all the
same a second time, as opposed to observing them cleared.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/selftest.c              | 15 ++++---
 tools/testing/selftests/iommu/iommufd.c       | 40 ++++++++++++++++++-
 tools/testing/selftests/iommu/iommufd_utils.h | 27 ++++++++-----
 3 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index c28aeb94bbdf..9f298225fc46 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -196,13 +196,16 @@ static int mock_domain_read_and_clear_dirty(struct iommu_domain *domain,
 		ent = xa_load(&mock->pfns, cur / MOCK_IO_PAGE_SIZE);
 		if (ent &&
 		    (xa_to_value(ent) & MOCK_PFN_DIRTY_IOVA)) {
-			unsigned long val;
-
 			/* Clear dirty */
-			val = xa_to_value(ent) & ~MOCK_PFN_DIRTY_IOVA;
-			old = xa_store(&mock->pfns, cur / MOCK_IO_PAGE_SIZE,
-				       xa_mk_value(val), GFP_KERNEL);
-			WARN_ON_ONCE(ent != old);
+			if (!(flags & IOMMU_DIRTY_NO_CLEAR)) {
+				unsigned long val;
+
+				val = xa_to_value(ent) & ~MOCK_PFN_DIRTY_IOVA;
+				old = xa_store(&mock->pfns,
+					       cur / MOCK_IO_PAGE_SIZE,
+					       xa_mk_value(val), GFP_KERNEL);
+				WARN_ON_ONCE(ent != old);
+			}
 			iommu_dirty_bitmap_record(dirty, cur, MOCK_IO_PAGE_SIZE);
 		}
 	}
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 6fc803693e31..ed0e5fa6d494 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1601,13 +1601,49 @@ TEST_F(iommufd_dirty_tracking, get_dirty_bitmap)
 	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
 				MOCK_APERTURE_START,
 				self->page_size, self->bitmap,
-				self->bitmap_size, _metadata);
+				self->bitmap_size, 0, _metadata);
 
 	/* PAGE_SIZE unaligned bitmap */
 	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
 				MOCK_APERTURE_START,
 				self->page_size, self->bitmap + MOCK_PAGE_SIZE,
-				self->bitmap_size, _metadata);
+				self->bitmap_size, 0, _metadata);
+
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
+TEST_F(iommufd_dirty_tracking, get_dirty_bitmap_no_clear)
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
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+
+	test_cmd_set_dirty_tracking(hwpt_id, true);
+
+	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
+				MOCK_APERTURE_START,
+				self->page_size, self->bitmap,
+				self->bitmap_size,
+				IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR,
+				_metadata);
+
+	/* Unaligned bitmap */
+	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
+				MOCK_APERTURE_START,
+				self->page_size, self->bitmap + MOCK_PAGE_SIZE,
+				self->bitmap_size,
+				IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR,
+				_metadata);
 
 	test_ioctl_destroy(stddev_id);
 	test_ioctl_destroy(hwpt_id);
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index ad0dcae9cf22..6a4264d7a677 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -200,11 +200,13 @@ static int _test_cmd_set_dirty_tracking(int fd, __u32 hwpt_id, bool enabled)
 	ASSERT_EQ(0, _test_cmd_set_dirty_tracking(self->fd, hwpt_id, enabled))
 
 static int _test_cmd_get_dirty_bitmap(int fd, __u32 hwpt_id, size_t length,
-				    __u64 iova, size_t page_size, __u64 *bitmap)
+				    __u64 iova, size_t page_size, __u64 *bitmap,
+				    __u32 flags)
 {
 	struct iommu_hwpt_get_dirty_bitmap cmd = {
 		.size = sizeof(cmd),
 		.hwpt_id = hwpt_id,
+		.flags = flags,
 		.iova = iova,
 		.length = length,
 		.page_size = page_size,
@@ -218,9 +220,10 @@ static int _test_cmd_get_dirty_bitmap(int fd, __u32 hwpt_id, size_t length,
 	return 0;
 }
 
-#define test_cmd_get_dirty_bitmap(fd, hwpt_id, length, iova, page_size, bitmap) \
+#define test_cmd_get_dirty_bitmap(fd, hwpt_id, length, iova, page_size, bitmap, \
+				  flags) \
 	ASSERT_EQ(0, _test_cmd_get_dirty_bitmap(fd, hwpt_id, length,            \
-					      iova, page_size, bitmap))
+					      iova, page_size, bitmap, flags))
 
 static int _test_cmd_mock_domain_set_dirty(int fd, __u32 hwpt_id, size_t length,
 					   __u64 iova, size_t page_size,
@@ -256,6 +259,7 @@ static int _test_cmd_mock_domain_set_dirty(int fd, __u32 hwpt_id, size_t length,
 static int _test_mock_dirty_bitmaps(int fd, __u32 hwpt_id, size_t length,
 				    __u64 iova, size_t page_size,
 				    __u64 *bitmap, __u64 bitmap_size,
+				    __u32 flags,
 				    struct __test_metadata *_metadata)
 {
 	unsigned long i, count, nbits = bitmap_size * BITS_PER_BYTE;
@@ -274,26 +278,31 @@ static int _test_mock_dirty_bitmaps(int fd, __u32 hwpt_id, size_t length,
 
 	/* Expect all even bits as dirty in the user bitmap */
 	memset(bitmap, 0, bitmap_size);
-	test_cmd_get_dirty_bitmap(fd, hwpt_id, length, iova, page_size, bitmap);
+	test_cmd_get_dirty_bitmap(fd, hwpt_id, length, iova,
+				  page_size, bitmap, flags);
 	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
 		ASSERT_EQ(!(i % 2), test_bit(i, (unsigned long *) bitmap));
 	ASSERT_EQ(count, out_dirty);
 
 	memset(bitmap, 0, bitmap_size);
-	test_cmd_get_dirty_bitmap(fd, hwpt_id, length, iova, page_size, bitmap);
+	test_cmd_get_dirty_bitmap(fd, hwpt_id, length, iova,
+				  page_size, bitmap, flags);
 
 	/* It as read already -- expect all zeroes */
-	for (i = 0; i < nbits; i++)
-		ASSERT_EQ(0, test_bit(i, (unsigned long *) bitmap));
+	for (i = 0; i < nbits; i++) {
+		ASSERT_EQ(!(i % 2) &&
+			  (flags & IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR),
+			  test_bit(i, (unsigned long *) bitmap));
+	}
 
 	return 0;
 }
 #define test_mock_dirty_bitmaps(hwpt_id, length, iova, page_size, bitmap, \
-				bitmap_size, _metadata) \
+				bitmap_size, flags, _metadata) \
 	ASSERT_EQ(0, _test_mock_dirty_bitmaps(self->fd, hwpt_id,      \
 					      length, iova,           \
 					      page_size, bitmap,      \
-					      bitmap_size, _metadata))
+					      bitmap_size, flags, _metadata))
 
 static int _test_cmd_create_access(int fd, unsigned int ioas_id,
 				   __u32 *access_id, unsigned int flags)
-- 
2.17.2

