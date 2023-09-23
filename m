Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CD67ABCFF
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjIWB2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjIWB2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7577619B
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:08 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLY6KI026786;
        Sat, 23 Sep 2023 01:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=1ckNKJMrMDr36TfHvhkVBJ9QK1JDK4hTX9G9JRv2puk=;
 b=BzALGyxbyJzv8xJJtPLSVL0kZmDVFrkVvc3cY/WFAr5aB/zrH3eQJ49FJdqMd0pey8OP
 CpI5Fb7gJIQl7QzNpi/JM42uvMb/3qVYG3FrAfhpdYz0LJQSmm2KQU4I0h9U+RQ3D8+E
 WL8adRFtbRAMvSGyyEZ8pPWeoFRelLYLKRItS0RePj53mYwr42MVm2pgP7Rxk9s5peDy
 ZDW6czqPGxv41KDou+ybhyM6O/13MKt8P25JcAIL6s+PzjAUbl5tv7OGpMxJLTxifiFL
 xhkFwnpf6lScZVYXjD060Q1FUXygWMHBSh6CntHVIMjIoRA3oj5uSpUAC9jDGDilJSwR 9w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsxu2y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0q08T007773;
        Sat, 23 Sep 2023 01:27:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hM040930;
        Sat, 23 Sep 2023 01:27:48 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-14;
        Sat, 23 Sep 2023 01:27:47 +0000
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 13/19] iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
Date:   Sat, 23 Sep 2023 02:25:05 +0100
Message-Id: <20230923012511.10379-14-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-ORIG-GUID: 2Dz1jyvan0pEYlnoL6Ab1A5SKRdNyi77
X-Proofpoint-GUID: 2Dz1jyvan0pEYlnoL6Ab1A5SKRdNyi77
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enumerate the capabilities from the mock device and test whether it
advertises as expected. Include it as part of the iommufd_dirty_tracking
fixture.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/selftest.c                | 13 ++++++++++++-
 tools/testing/selftests/iommu/iommufd.c         | 17 +++++++++++++++++
 .../testing/selftests/iommu/iommufd_fail_nth.c  |  2 +-
 tools/testing/selftests/iommu/iommufd_utils.h   | 14 +++++++++++---
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index d8fb7328f93c..6a2c82eed19e 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -375,7 +375,18 @@ static phys_addr_t mock_domain_iova_to_phys(struct iommu_domain *domain,
 
 static bool mock_domain_capable(struct device *dev, enum iommu_cap cap)
 {
-	return cap == IOMMU_CAP_CACHE_COHERENCY;
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
+
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return true;
+	case IOMMU_CAP_DIRTY:
+		return !(mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY);
+	default:
+		break;
+	}
+
+	return false;
 }
 
 static void mock_domain_set_plaform_dma_ops(struct device *dev)
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 6eba8e880a55..1005282ced56 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1561,6 +1561,23 @@ TEST_F(iommufd_dirty_tracking, set_dirty)
 	test_ioctl_destroy(hwpt_id);
 }
 
+TEST_F(iommufd_dirty_tracking, device_dirty_capability)
+{
+	uint32_t caps = 0;
+	uint32_t stddev_id;
+	uint32_t hwpt_id;
+
+	test_cmd_hwpt_alloc(self->idev_id, self->ioas_id, 0, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_cmd_get_hw_capabilities(self->idev_id, caps,
+				     IOMMU_HW_CAP_DIRTY_TRACKING);
+	ASSERT_EQ(IOMMU_HW_CAP_DIRTY_TRACKING,
+		  caps & IOMMU_HW_CAP_DIRTY_TRACKING);
+
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
 TEST_F(iommufd_dirty_tracking, get_dirty_iova)
 {
 	uint32_t stddev_id;
diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
index 3d7838506bfe..1fcd69cb0e41 100644
--- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
+++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
@@ -612,7 +612,7 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 				  &idev_id))
 		return -1;
 
-	if (_test_cmd_get_hw_info(self->fd, idev_id, &info, sizeof(info)))
+	if (_test_cmd_get_hw_info(self->fd, idev_id, &info, sizeof(info), NULL))
 		return -1;
 
 	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0, &hwpt_id))
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 8c0c1bc91128..0b83cf200e9f 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -525,7 +525,8 @@ static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
 
 /* @data can be NULL */
 static int _test_cmd_get_hw_info(int fd, __u32 device_id,
-				 void *data, size_t data_len)
+				 void *data, size_t data_len,
+				 uint32_t *capabilities)
 {
 	struct iommu_test_hw_info *info = (struct iommu_test_hw_info *)data;
 	struct iommu_hw_info cmd = {
@@ -533,6 +534,7 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id,
 		.dev_id = device_id,
 		.data_len = data_len,
 		.data_uptr = (uint64_t)data,
+		.out_capabilities = 0,
 	};
 	int ret;
 
@@ -569,14 +571,20 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id,
 			assert(!info->flags);
 	}
 
+	if (capabilities)
+		*capabilities = cmd.out_capabilities;
+
 	return 0;
 }
 
 #define test_cmd_get_hw_info(device_id, data, data_len)         \
 	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, \
-					   data, data_len))
+					   data, data_len, NULL))
 
 #define test_err_get_hw_info(_errno, device_id, data, data_len) \
 	EXPECT_ERRNO(_errno,                                    \
 		     _test_cmd_get_hw_info(self->fd, device_id, \
-					   data, data_len))
+					   data, data_len, NULL))
+
+#define test_cmd_get_hw_capabilities(device_id, caps, mask)     \
+	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, 0, &caps))
-- 
2.17.2

