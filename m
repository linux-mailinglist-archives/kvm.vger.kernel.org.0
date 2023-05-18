Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F286C7089D6
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjERUtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjERUth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:49:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0493F1727
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:49:12 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx57J025260;
        Thu, 18 May 2023 20:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=2D7UxbOumN8S0VQCXY9A6pctFVNdyDKDTmUQXX+6IOs=;
 b=aT8NjB7M4OPvcKWeYlK5EhZySaCUitE5tkeVu47DQXbB4M571j8XWwxVY7zE7UNKCwc3
 jPRHHVKUmnvuZQpQa7gFQq4ZdJ2CCgJzN+aT+Uxl6J9EKr/FPSNPspIb+GTCffuz4mHd
 WkykXXuGjJEZKLennSyKWw4Jy6H21lBPzRB29kpAzyWe3TpadxxGTmcf1DCux4Z6Cf9W
 eYUSPJNta47HFZQQZnU9DDYGl5Wmt0xIgJ4jpHF1RJ1wFL4KlYNC8eiiycwu4v52g4Vo
 7HGYsvBbE9QhFXukju6KmyjtD6LAysJAF4MF/83eB1LAUIrN7qTnSz5NXRPsEl8mNF4v jQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc97ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJQch1032127;
        Thu, 18 May 2023 20:48:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dafe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3J033533;
        Thu, 18 May 2023 20:48:49 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-17;
        Thu, 18 May 2023 20:48:48 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH RFCv2 16/24] iommufd/selftest: Test IOMMU_GET_DIRTY_IOVA_NO_CLEAR flag
Date:   Thu, 18 May 2023 21:46:42 +0100
Message-Id: <20230518204650.14541-17-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=899 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180171
X-Proofpoint-ORIG-GUID: Q7m0MiiD7sC4JYr4zEqgxCysLj3rQHmU
X-Proofpoint-GUID: Q7m0MiiD7sC4JYr4zEqgxCysLj3rQHmU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change test_mock_dirty_bitmaps() to pass a flag where we specify the flag
under test. The test does the same thing as the GET_DIRTY_IOVA regular
test. Except that we test whether the bits we dirtied are fetched all the
same a second time as opposed to observing them cleared.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/selftest.c              | 15 ++++---
 tools/testing/selftests/iommu/iommufd.c       | 40 ++++++++++++++++++-
 tools/testing/selftests/iommu/iommufd_utils.h | 26 +++++++-----
 3 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index d81a977bf3af..ae8e94259b21 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -331,13 +331,16 @@ static int mock_domain_read_and_clear_dirty(struct iommu_domain *domain,
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
+			if (!(flags & IOMMU_GET_DIRTY_IOVA_NO_CLEAR)) {
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
index dad1eca3aa09..7ee788ce80c8 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1508,13 +1508,49 @@ TEST_F(iommufd_dirty_tracking, get_dirty_iova)
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
+TEST_F(iommufd_dirty_tracking, get_dirty_iova_no_clear)
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
+				self->bitmap_size,
+				IOMMU_GET_DIRTY_IOVA_NO_CLEAR,
+				_metadata);
+
+	/* Unaligned bitmap */
+	test_mock_dirty_bitmaps(hwpt_id, variant->buffer_size,
+				MOCK_APERTURE_START,
+				self->page_size, self->bitmap + MOCK_PAGE_SIZE,
+				self->bitmap_size,
+				IOMMU_GET_DIRTY_IOVA_NO_CLEAR,
+				_metadata);
 
 	test_ioctl_destroy(stddev_id);
 	test_ioctl_destroy(hwpt_id);
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index e942bc781f34..1c0b942bcb4a 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -166,11 +166,13 @@ static int _test_cmd_get_device_caps(int fd, __u32 dev_id, __u64 capability)
 						      expected))
 
 static int _test_cmd_get_dirty_iova(int fd, __u32 hwpt_id, size_t length,
-				    __u64 iova, size_t page_size, __u64 *bitmap)
+				    __u64 iova, size_t page_size, __u64 *bitmap,
+				    __u32 flags)
 {
 	struct iommu_hwpt_get_dirty_iova cmd = {
 		.size = sizeof(cmd),
 		.hwpt_id = hwpt_id,
+		.flags = flags,
 		.bitmap = {
 			.iova = iova,
 			.length = length,
@@ -186,9 +188,10 @@ static int _test_cmd_get_dirty_iova(int fd, __u32 hwpt_id, size_t length,
 	return 0;
 }
 
-#define test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap) \
+#define test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap, \
+				flags) \
 	ASSERT_EQ(0, _test_cmd_get_dirty_iova(fd, hwpt_id, length,            \
-					      iova, page_size, bitmap))
+					      iova, page_size, bitmap, flags))
 
 static int _test_cmd_mock_domain_set_dirty(int fd, __u32 hwpt_id, size_t length,
 				           __u64 iova, size_t page_size,
@@ -224,6 +227,7 @@ static int _test_cmd_mock_domain_set_dirty(int fd, __u32 hwpt_id, size_t length,
 static int _test_mock_dirty_bitmaps(int fd, __u32 hwpt_id, size_t length,
 				    __u64 iova, size_t page_size,
 				    __u64 *bitmap, __u64 bitmap_size,
+				    __u32 flags,
 				    struct __test_metadata *_metadata)
 {
 	unsigned long i, count, nbits = bitmap_size * BITS_PER_BYTE;
@@ -242,26 +246,30 @@ static int _test_mock_dirty_bitmaps(int fd, __u32 hwpt_id, size_t length,
 
 	/* Expect all even bits as dirty in the user bitmap */
 	memset(bitmap, 0, bitmap_size);
-	test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap);
+	test_cmd_get_dirty_iova(fd, hwpt_id, length, iova,
+				page_size, bitmap, flags);
 	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
 		ASSERT_EQ(!(i % 2), test_bit(i, (unsigned long *) bitmap));
 	ASSERT_EQ(count, out_dirty);
 
 	memset(bitmap, 0, bitmap_size);
-	test_cmd_get_dirty_iova(fd, hwpt_id, length, iova, page_size, bitmap);
+	test_cmd_get_dirty_iova(fd, hwpt_id, length, iova,
+				page_size, bitmap, flags);
 
 	/* It as read already -- expect all zeroes */
-	for (i = 0; i < nbits; i++)
-		ASSERT_EQ(0, test_bit(i, (unsigned long *) bitmap));
+	for (i = 0; i < nbits; i++) {
+		ASSERT_EQ(!(i % 2) && (flags & IOMMU_GET_DIRTY_IOVA_NO_CLEAR),
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

