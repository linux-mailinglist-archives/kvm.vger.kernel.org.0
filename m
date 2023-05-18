Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD92E7089CB
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjERUsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjERUsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:48:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0D8E7F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:48:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx8m9032118;
        Thu, 18 May 2023 20:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=iMktio9VTgbJ1yfqMEUUnV1ANkjO6zvNSUX5TxAJMrU=;
 b=ptwdTBuf1JcJzHelS2lyO/TdiOfO+V4FJmr4k2i45kDclFjYYylPnwSFn+KkGwVjzdd0
 M7mluSL+e4tpC5whfaaHsEqHiJwGpDgdLKYAIN8IoAaKuozMYwzQzvGoSyxdfKvwgKKo
 WCYf7XrRCCAYQjQyAU0b9UjDYLfaETf36PL3KBNSxWTF+L+UwUPzhmsaDKrvuheAVvNh
 5PSZf0bWA8V8Ao4tErxH3IIwobuRuFYg0IyaEc2mZc/yg9heTeGYrCkLvDV3Z26TGPY6
 s0YSZXsoA9Y752HqssDs53x2LP7zBxDKB3x8go7O7bJA+j2F6wyUZRGZkUKJ4Yaueh2q 5Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj33v0v9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJkARw032121;
        Thu, 18 May 2023 20:47:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daeff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE2x033533;
        Thu, 18 May 2023 20:47:39 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-7;
        Thu, 18 May 2023 20:47:39 +0000
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
Subject: [PATCH RFCv2 06/24] iommufd/selftest: Add a flags to _test_cmd_{hwpt_alloc,mock_domain}
Date:   Thu, 18 May 2023 21:46:32 +0100
Message-Id: <20230518204650.14541-7-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=865 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180170
X-Proofpoint-GUID: 5j-peOTwN9q8QBBoW7Zrh2AkwgJ4B1n7
X-Proofpoint-ORIG-GUID: 5j-peOTwN9q8QBBoW7Zrh2AkwgJ4B1n7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to test passing flags to HWPT_ALLOC (particularly
IOMMU_HWPT_ALLOC_ENFORCE_DIRTY), add a flags argument into the test
functions.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 tools/testing/selftests/iommu/iommufd.c       |  3 ++-
 .../selftests/iommu/iommufd_fail_nth.c        | 24 +++++++++++--------
 tools/testing/selftests/iommu/iommufd_utils.h | 22 ++++++++++-------
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index dc09c1de319f..771e4a40200f 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1346,7 +1346,8 @@ TEST_F(iommufd_mock_domain, alloc_hwpt)
 		uint32_t stddev_id;
 		uint32_t hwpt_id;
 
-		test_cmd_hwpt_alloc(self->idev_ids[0], self->ioas_id, &hwpt_id);
+		test_cmd_hwpt_alloc(self->idev_ids[0], self->ioas_id,
+				    0, &hwpt_id);
 		test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
 		test_ioctl_destroy(stddev_id);
 		test_ioctl_destroy(hwpt_id);
diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
index d4c552e56948..0e003069bb2a 100644
--- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
+++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
@@ -315,7 +315,8 @@ TEST_FAIL_NTH(basic_fail_nth, map_domain)
 
 	fail_nth_enable();
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, &hwpt_id, NULL))
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0, &stdev_id,
+				  &hwpt_id, NULL))
 		return -1;
 
 	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, 262144, &iova,
@@ -326,7 +327,8 @@ TEST_FAIL_NTH(basic_fail_nth, map_domain)
 	if (_test_ioctl_destroy(self->fd, stdev_id))
 		return -1;
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, &hwpt_id, NULL))
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0,
+				  &stdev_id, &hwpt_id, NULL))
 		return -1;
 	return 0;
 }
@@ -350,13 +352,14 @@ TEST_FAIL_NTH(basic_fail_nth, map_two_domains)
 	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
 		return -1;
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, &hwpt_id, NULL))
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0,
+				  &stdev_id, &hwpt_id, NULL))
 		return -1;
 
 	fail_nth_enable();
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id2, &hwpt_id2,
-				  NULL))
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0,
+				  &stdev_id2, &hwpt_id2, NULL))
 		return -1;
 
 	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, 262144, &iova,
@@ -370,9 +373,9 @@ TEST_FAIL_NTH(basic_fail_nth, map_two_domains)
 	if (_test_ioctl_destroy(self->fd, stdev_id2))
 		return -1;
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, &hwpt_id, NULL))
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0, &stdev_id, &hwpt_id, NULL))
 		return -1;
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id2, &hwpt_id2,
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0, &stdev_id2, &hwpt_id2,
 				  NULL))
 		return -1;
 	return 0;
@@ -530,7 +533,8 @@ TEST_FAIL_NTH(basic_fail_nth, access_pin_domain)
 	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
 		return -1;
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, &hwpt_id, NULL))
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0,
+				  &stdev_id, &hwpt_id, NULL))
 		return -1;
 
 	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, BUFFER_SIZE, &iova,
@@ -607,11 +611,11 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 
 	fail_nth_enable();
 
-	if (_test_cmd_mock_domain(self->fd, ioas_id, &stdev_id, NULL,
+	if (_test_cmd_mock_domain(self->fd, ioas_id, 0, &stdev_id, NULL,
 				  &idev_id))
 		return -1;
 
-	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, &hwpt_id))
+	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0, &hwpt_id))
 		return -1;
 
 	if (_test_cmd_mock_domain_replace(self->fd, stdev_id, ioas_id2, NULL))
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 53b4d3f2d9fc..04871bcfd34b 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -40,7 +40,8 @@ static unsigned long PAGE_SIZE;
 				&test_cmd));                                  \
 	})
 
-static int _test_cmd_mock_domain(int fd, unsigned int ioas_id, __u32 *stdev_id,
+static int _test_cmd_mock_domain(int fd, unsigned int ioas_id,
+				 __u32 stdev_flags, __u32 *stdev_id,
 				 __u32 *hwpt_id, __u32 *idev_id)
 {
 	struct iommu_test_cmd cmd = {
@@ -64,10 +65,13 @@ static int _test_cmd_mock_domain(int fd, unsigned int ioas_id, __u32 *stdev_id,
 	return 0;
 }
 #define test_cmd_mock_domain(ioas_id, stdev_id, hwpt_id, idev_id)       \
-	ASSERT_EQ(0, _test_cmd_mock_domain(self->fd, ioas_id, stdev_id, \
-					   hwpt_id, idev_id))
-#define test_err_mock_domain(_errno, ioas_id, stdev_id, hwpt_id)      \
-	EXPECT_ERRNO(_errno, _test_cmd_mock_domain(self->fd, ioas_id, \
+	ASSERT_EQ(0, _test_cmd_mock_domain(self->fd, ioas_id, 0,	\
+					   stdev_id, hwpt_id, idev_id))
+#define test_err_mock_domain(_errno, ioas_id, stdev_id, hwpt_id)         \
+	EXPECT_ERRNO(_errno, _test_cmd_mock_domain(self->fd, ioas_id, 0, \
+						   stdev_id, hwpt_id, NULL))
+#define test_err_mock_domain_flags(_errno, ioas_id, flags, stdev_id, hwpt_id) \
+	EXPECT_ERRNO(_errno, _test_cmd_mock_domain(self->fd, ioas_id, flags,  \
 						   stdev_id, hwpt_id, NULL))
 
 static int _test_cmd_mock_domain_replace(int fd, __u32 stdev_id, __u32 pt_id,
@@ -99,10 +103,11 @@ static int _test_cmd_mock_domain_replace(int fd, __u32 stdev_id, __u32 pt_id,
 							   pt_id, NULL))
 
 static int _test_cmd_hwpt_alloc(int fd, __u32 device_id, __u32 pt_id,
-					 __u32 *hwpt_id)
+				__u32 flags, __u32 *hwpt_id)
 {
 	struct iommu_hwpt_alloc cmd = {
 		.size = sizeof(cmd),
+		.flags = flags,
 		.dev_id = device_id,
 		.pt_id = pt_id,
 	};
@@ -116,8 +121,9 @@ static int _test_cmd_hwpt_alloc(int fd, __u32 device_id, __u32 pt_id,
 	return 0;
 }
 
-#define test_cmd_hwpt_alloc(device_id, pt_id, hwpt_id) \
-	ASSERT_EQ(0, _test_cmd_hwpt_alloc(self->fd, device_id, pt_id, hwpt_id))
+#define test_cmd_hwpt_alloc(device_id, pt_id, flags, hwpt_id) \
+	ASSERT_EQ(0, _test_cmd_hwpt_alloc(self->fd, device_id, pt_id, flags, \
+					  hwpt_id))
 
 static int _test_cmd_create_access(int fd, unsigned int ioas_id,
 				   __u32 *access_id, unsigned int flags)
-- 
2.17.2

