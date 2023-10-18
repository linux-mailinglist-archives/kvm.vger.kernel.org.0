Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347297CE8EE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjJRUaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbjJRU3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:29:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169F2D7B
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:29:17 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IImtdP006120;
        Wed, 18 Oct 2023 20:28:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=iaHoItBRAEysMtThzHhY/pnVURSX5SY+/Mks2GyN3Qc=;
 b=0Rs2IlV6NcoahkkiWGz9y2daanRA/PUSvpMo4lRCmRBWibrtloFi2NjFkht7BTNHfdbJ
 Y08v32zXjfmJM1PWvqdL894wk2kBcpg+gdOxPvh17/2MW3aWpHXc0OadUwVUzFQmsKKs
 /VOEXkPT4tBXSDIxdP0W+lUMmyvAEVWChToVhznM0hI9BpNzqQaHwhZzY6d74nlYm6Lo
 THy4Dv48D/0R8Rf5zvv3pzwJXgZl9l4+YKB5115heTIBzPr6FQkL8C/RB+7dIrP0bznA
 kkgm9hfor1XJBeqvnY2ienmm19IKOJLufMW4x6ojAwZGXU/4/mXwkxOkvt4RpLAmfydK kQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynghus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IK1418009042;
        Wed, 18 Oct 2023 20:28:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps7yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:54 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5v040635;
        Wed, 18 Oct 2023 20:28:53 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-18;
        Wed, 18 Oct 2023 20:28:53 +0000
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
Subject: [PATCH v4 17/18] iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
Date:   Wed, 18 Oct 2023 21:27:14 +0100
Message-Id: <20231018202715.69734-18-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: zGCJS73SmK9uPsolxO8jmylfQJf_86T7
X-Proofpoint-ORIG-GUID: zGCJS73SmK9uPsolxO8jmylfQJf_86T7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 4ba10dbc63d0..322254a2bbc1 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -379,7 +379,18 @@ static phys_addr_t mock_domain_iova_to_phys(struct iommu_domain *domain,
 
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
index e12e0731e414..2865dc271a26 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1564,6 +1564,23 @@ TEST_F(iommufd_dirty_tracking, set_dirty)
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
index 31386be42439..ff735bdd833e 100644
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
index 1ff93f812a32..790b5c0769cc 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -522,7 +522,8 @@ static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
 
 /* @data can be NULL */
 static int _test_cmd_get_hw_info(int fd, __u32 device_id,
-				 void *data, size_t data_len)
+				 void *data, size_t data_len,
+				 uint32_t *capabilities)
 {
 	struct iommu_test_hw_info *info = (struct iommu_test_hw_info *)data;
 	struct iommu_hw_info cmd = {
@@ -530,6 +531,7 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id,
 		.dev_id = device_id,
 		.data_len = data_len,
 		.data_uptr = (uint64_t)data,
+		.out_capabilities = 0,
 	};
 	int ret;
 
@@ -566,14 +568,20 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id,
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

