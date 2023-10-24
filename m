Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0617E7D5355
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343699AbjJXN4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343730AbjJXNzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E996EB5
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJPNT032351;
        Tue, 24 Oct 2023 13:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=e0xwDxvcPUGqBtr7AAjKxySyEbjWLd8tjXLNj11aeIc=;
 b=acSHsFWrONAaxqnsoRomGUtByT/1snfpwhJjFdsZl5qbWptthiCsoNXrXgcOCRtnJEqm
 +J3gz8vuOhLed4uJPRo1WvLGgnNyTUeDCpyHeFTlWPuL/eM82sFY/8LLtDlxWZR9nkfI
 ZuPqcKn7QZStVJqQ5WzwyUCZ+v0AzGtkLp61ySCDOOtle1xwvzRbHKN8EAFX5Uez15zP
 Vxuk+Qb95UyEj6LuLOvh8vJmROt3sFJdCCE3yueFLD7+S8NbC574HIiKJK/+QanRLCus
 iLaOIQUWLHE+H1fdoUzfwsxceG6n4ZBVt3usPshgzXnAH95XOasoFk4+PFXkKVEFo4+D 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68tdg6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39ODCCqL034774;
        Tue, 24 Oct 2023 13:52:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:22 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL9K030007;
        Tue, 24 Oct 2023 13:52:22 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-16;
        Tue, 24 Oct 2023 13:52:21 +0000
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
Subject: [PATCH v6 15/18] iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY_TRACKING
Date:   Tue, 24 Oct 2023 14:51:06 +0100
Message-Id: <20231024135109.73787-16-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-ORIG-GUID: rU9p12oh4FAB6ZwzWb4Sf32ZyXVMdsLY
X-Proofpoint-GUID: rU9p12oh4FAB6ZwzWb4Sf32ZyXVMdsLY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/iommu/iommufd/selftest.c              | 16 ++++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 15 +++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h | 17 +++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 78362f2334f5..2773275566af 100644
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
@@ -155,6 +157,20 @@ static void *mock_domain_hw_info(struct device *dev, u32 *length, u32 *type)
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
+	flags = (enable ? flags | MOCK_DIRTY_TRACK : flags & ~MOCK_DIRTY_TRACK);
+
+	mock->flags = flags;
 	return 0;
 }
 
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 6bebba183426..8c46012006e1 100644
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
index 4ddafa29e638..e37af6291b22 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -179,6 +179,23 @@ static int _test_cmd_access_replace_ioas(int fd, __u32 access_id,
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

