Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857547ABCF4
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjIWB2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIWB2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F5FE8
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:27:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLY9JU025503;
        Sat, 23 Sep 2023 01:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=dQogBe98koTw0/XBBXfq6ENGVL3aBj8Pp1gIIJ1y/do=;
 b=ui3Sp1sXz4sduuSqpf+ai1y9g5xc79zmUMhzx2qjIr5t32ujPQSA8k1LmuGx7By8OYm/
 dhW8fydHcRFanuBXOTkGJQl0XvX86jfUIDj0LxrpOnPXPJEtGuqTF8uPJBHy8mRV4/Vh
 9Rn6uIVZt19Iky91R7FMgLnkXeMtb9znxjQZnaQ9g3gJUFVCLEKJmqZZoBtomSbETqS+
 JgAu7jP7naVJCRK82EKCsnOBMGqkMYCQnioTzqEqWGJmpQERcezJEvPpE450TF7HK/zQ
 MzlfIyUsX0A/6tqK4eLi6RYmC8uFEOVIcAiBAc2W1+4jLLSeCX0f2NCdizw2U30DlFNE cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt1k2p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0mOsF007626;
        Sat, 23 Sep 2023 01:27:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hE040930;
        Sat, 23 Sep 2023 01:27:34 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-10;
        Sat, 23 Sep 2023 01:27:34 +0000
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
Subject: [PATCH v3 09/19] iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
Date:   Sat, 23 Sep 2023 02:25:01 +0100
Message-Id: <20230923012511.10379-10-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: _PeuIM4WcyRdCmz6E1CRazXamT8oHra9
X-Proofpoint-ORIG-GUID: _PeuIM4WcyRdCmz6E1CRazXamT8oHra9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change mock_domain to supporting dirty tracking and add tests to exercise
the new SET_DIRTY API in the iommufd_dirty_tracking selftest fixture.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/selftest.c              | 17 +++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 15 +++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h | 21 +++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 4cf5a2b859e7..507ada06d5ad 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -24,6 +24,7 @@ static struct platform_device *selftest_iommu_dev;
 size_t iommufd_test_memory_limit = 65536;
 
 enum {
+	MOCK_DIRTY_TRACK = 1,
 	MOCK_IO_PAGE_SIZE = PAGE_SIZE / 2,
 
 	/*
@@ -86,6 +87,7 @@ void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd,
 }
 
 struct mock_iommu_domain {
+	unsigned long flags;
 	struct iommu_domain domain;
 	struct xarray pfns;
 };
@@ -156,6 +158,21 @@ static void *mock_domain_hw_info(struct device *dev, u32 *length, u32 *type)
 static int mock_domain_set_dirty_tracking(struct iommu_domain *domain,
 					  bool enable)
 {
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	unsigned long flags = mock->flags;
+
+	if (enable && !domain->dirty_ops)
+		return -EINVAL;
+
+	/* No change? */
+	if (!(enable ^ !!(flags & MOCK_DIRTY_TRACK)))
+		return 0;
+
+	flags = (enable ?
+		 flags | MOCK_DIRTY_TRACK : flags & ~MOCK_DIRTY_TRACK);
+
+	mock->flags = flags;
 	return 0;
 }
 
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 71ad12867da6..dba173d1dd02 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1479,6 +1479,21 @@ TEST_F(iommufd_dirty_tracking, enforce_dirty)
 	test_ioctl_destroy(stddev_id);
 }
 
+TEST_F(iommufd_dirty_tracking, set_dirty)
+{
+	uint32_t stddev_id;
+	uint32_t hwpt_id;
+
+	test_cmd_hwpt_alloc(self->idev_id, self->ioas_id,
+			    IOMMU_HWPT_ALLOC_ENFORCE_DIRTY, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_cmd_set_dirty(hwpt_id, true);
+	test_cmd_set_dirty(hwpt_id, false);
+
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 930edfe693c7..1626e2efbfb1 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -177,9 +177,30 @@ static int _test_cmd_access_replace_ioas(int fd, __u32 access_id,
 		return ret;
 	return 0;
 }
+
+
 #define test_cmd_access_replace_ioas(access_id, ioas_id) \
 	ASSERT_EQ(0, _test_cmd_access_replace_ioas(self->fd, access_id, ioas_id))
 
+static int _test_cmd_set_dirty(int fd, __u32 hwpt_id, bool enabled)
+{
+	struct iommu_hwpt_set_dirty cmd = {
+		.size = sizeof(cmd),
+		.flags = enabled ? IOMMU_DIRTY_TRACKING_ENABLED :
+				   IOMMU_DIRTY_TRACKING_DISABLED,
+		.hwpt_id = hwpt_id,
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_HWPT_SET_DIRTY, &cmd);
+	if (ret)
+		return -errno;
+	return 0;
+}
+
+#define test_cmd_set_dirty(hwpt_id, enabled) \
+	ASSERT_EQ(0, _test_cmd_set_dirty(self->fd, hwpt_id, enabled))
+
 static int _test_cmd_create_access(int fd, unsigned int ioas_id,
 				   __u32 *access_id, unsigned int flags)
 {
-- 
2.17.2

