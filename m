Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CB07089D7
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjERUtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjERUtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:49:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2631735
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:49:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIxA4f015466;
        Thu, 18 May 2023 20:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=ik0nQef5BcCOZZtfW1MdDQzVXmMsarHrUpNkmcjWPVw=;
 b=0v7RRdoUi18G5JxKodk1mB6yGwEvGjsP+hdXpgg5YQMRR3mK+0EiEecqSdPrLK3Xg4iv
 EyYvvuDaktLYjgi7zvpDp0TX9iyeopyndH2fYzMZd38qKMWNi7cTtCUsmrSvzUuq8/ss
 pr18BlF4G+atA/vOckFt6Yj5++t3aVpwnAzoUoWZ10pg7XjXtITQdNjkJAJxhced9vlO
 FQTmATAnNCKZj5unhiVo/AttUUY0hCEdwh+hCeR22y0pmGP+sIJxK10IZNHoJ7+6DQQ8
 FeJ+zJzYNt4Le9BxLzkTTgdIoOn9egxJY5FxnCRBS9VVkkZE2JmA6NheBIkHruj8jfXK qQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j3n5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJFRxh032132;
        Thu, 18 May 2023 20:48:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dafa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3F033533;
        Thu, 18 May 2023 20:48:40 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-15;
        Thu, 18 May 2023 20:48:40 +0000
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
Subject: [PATCH RFCv2 14/24] iommufd/selftest: Test IOMMU_DEVICE_GET_CAPS
Date:   Thu, 18 May 2023 21:46:40 +0100
Message-Id: <20230518204650.14541-15-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180171
X-Proofpoint-GUID: bSS_9b94F57sYjNVj6g-8CDmDIJAYvYR
X-Proofpoint-ORIG-GUID: bSS_9b94F57sYjNVj6g-8CDmDIJAYvYR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enumerate the capabilities from the mock device and test whether it
advertises as expected. Include it as part of the iommufd_dirty_tracking
suite.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/selftest.c              | 10 +++++++++-
 tools/testing/selftests/iommu/iommufd.c       | 14 ++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h | 19 +++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 3ec0eb4dfe97..d81a977bf3af 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -275,7 +275,15 @@ static phys_addr_t mock_domain_iova_to_phys(struct iommu_domain *domain,
 
 static bool mock_domain_capable(struct device *dev, enum iommu_cap cap)
 {
-	return cap == IOMMU_CAP_CACHE_COHERENCY;
+	switch (cap) {
+		case IOMMU_CAP_CACHE_COHERENCY:
+		case IOMMU_CAP_DIRTY:
+			return true;
+		default:
+			break;
+	}
+
+	return false;
 }
 
 static void mock_domain_set_plaform_dma_ops(struct device *dev)
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 818e78cd889a..dad1eca3aa09 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1475,6 +1475,19 @@ TEST_F(iommufd_dirty_tracking, set_dirty)
 	test_ioctl_destroy(hwpt_id);
 }
 
+TEST_F(iommufd_dirty_tracking, device_dirty_capability)
+{
+	uint32_t stddev_id;
+	uint32_t hwpt_id;
+
+	test_cmd_hwpt_alloc(self->idev_id, self->ioas_id, 0, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_cmd_get_device_caps(self->idev_id, IOMMUFD_CAP_DIRTY_TRACKING);
+
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
 TEST_F(iommufd_dirty_tracking, get_dirty_iova)
 {
 	uint32_t stddev_id;
@@ -1507,6 +1520,7 @@ TEST_F(iommufd_dirty_tracking, get_dirty_iova)
 	test_ioctl_destroy(hwpt_id);
 }
 
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 4d428fbb12e2..e942bc781f34 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -146,6 +146,25 @@ static int _test_cmd_set_dirty(int fd, __u32 hwpt_id, bool enabled)
 #define test_cmd_set_dirty(hwpt_id, enabled) \
 	ASSERT_EQ(0, _test_cmd_set_dirty(self->fd, hwpt_id, enabled))
 
+static int _test_cmd_get_device_caps(int fd, __u32 dev_id, __u64 capability)
+{
+	struct iommu_device_get_caps cmd = {
+		.size = sizeof(cmd),
+		.dev_id = dev_id,
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_DEVICE_GET_CAPS, &cmd);
+	if (ret)
+		return ret;
+
+	return cmd.out_caps & capability;
+}
+
+#define test_cmd_get_device_caps(dev_id, expected) \
+	ASSERT_EQ(expected, _test_cmd_get_device_caps(self->fd, dev_id, \
+						      expected))
+
 static int _test_cmd_get_dirty_iova(int fd, __u32 hwpt_id, size_t length,
 				    __u64 iova, size_t page_size, __u64 *bitmap)
 {
-- 
2.17.2

