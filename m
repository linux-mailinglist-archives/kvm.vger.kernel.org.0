Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3EE7D1927
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbjJTW3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjJTW3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:29:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77B010E3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:29:27 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KL9Jqo030393;
        Fri, 20 Oct 2023 22:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=pfs1jH2FUT9Rysmfg8lwy9UqmKESs/j0fbJpUGlzv9U=;
 b=ENPZjbIEHfyr6MKeKVTkU0yDkeAA0E4d30u1kQj34mI6gZkrsDp3BuIWo3n+6MBa0kBM
 xPPtfQzedHetr7qGXqoEwgHAIogdWP9JgvGHewuvpM3i/JwEzYigUc/d+61hBoT9WwLK
 tDoQ1RNQbyZtiD1YIwf/dsT7/68nnZpwZO5+wLa/T4db966faZpGhpPn4Jxq2A2uAYyE
 u8nteO7NkHgNbfUxABp1p6/FNbthG6rhJC8JGL1h5TdMvhiJSe7Iw3N6ViEfZ9sbn55z
 49FWhqL3GuFjR0P+8/2saupgsjCw5pF6QnpIc/hyxolapDMz7tWGFzRuI2GYZGeq807s pg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwdau3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:29:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KKrolX025876;
        Fri, 20 Oct 2023 22:29:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdud5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:29:05 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KMSAsO018735;
        Fri, 20 Oct 2023 22:29:05 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-179-153.vpn.oracle.com [10.175.179.153])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tubwduch3-16;
        Fri, 20 Oct 2023 22:29:05 +0000
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
Subject: [PATCH v5 15/18] iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY_TRACKING
Date:   Fri, 20 Oct 2023 23:28:01 +0100
Message-Id: <20231020222804.21850-16-joao.m.martins@oracle.com>
In-Reply-To: <20231020222804.21850-1-joao.m.martins@oracle.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200191
X-Proofpoint-ORIG-GUID: rqDDuhJ2gbhk0IbgqXBSwNo6AACj901h
X-Proofpoint-GUID: rqDDuhJ2gbhk0IbgqXBSwNo6AACj901h
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
the new SET_DIRTY_TRACKING API in the iommufd_dirty_tracking selftest
fixture.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/iommufd/selftest.c              | 17 +++++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 15 +++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h | 17 +++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 99fee9a13232..c93b19e20c59 100644
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
index e35274582b78..c921b50eddc8 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1482,6 +1482,21 @@ TEST_F(iommufd_dirty_tracking, enforce_dirty)
 	test_ioctl_destroy(stddev_id);
 }
 
+TEST_F(iommufd_dirty_tracking, set_dirty_tracking)
+{
+	uint32_t stddev_id;
+	uint32_t hwpt_id;
+
+	test_cmd_hwpt_alloc(self->idev_id, self->ioas_id,
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_cmd_set_dirty_tracking(hwpt_id, true);
+	test_cmd_set_dirty_tracking(hwpt_id, false);
+
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 930edfe693c7..757781d5c5a2 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -180,6 +180,23 @@ static int _test_cmd_access_replace_ioas(int fd, __u32 access_id,
 #define test_cmd_access_replace_ioas(access_id, ioas_id) \
 	ASSERT_EQ(0, _test_cmd_access_replace_ioas(self->fd, access_id, ioas_id))
 
+static int _test_cmd_set_dirty_tracking(int fd, __u32 hwpt_id, bool enabled)
+{
+	struct iommu_hwpt_set_dirty_tracking cmd = {
+		.size = sizeof(cmd),
+		.flags = enabled ? IOMMU_HWPT_DIRTY_TRACKING_ENABLE : 0,
+		.hwpt_id = hwpt_id,
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_HWPT_SET_DIRTY_TRACKING, &cmd);
+	if (ret)
+		return -errno;
+	return 0;
+}
+#define test_cmd_set_dirty_tracking(hwpt_id, enabled) \
+	ASSERT_EQ(0, _test_cmd_set_dirty_tracking(self->fd, hwpt_id, enabled))
+
 static int _test_cmd_create_access(int fd, unsigned int ioas_id,
 				   __u32 *access_id, unsigned int flags)
 {
-- 
2.17.2

