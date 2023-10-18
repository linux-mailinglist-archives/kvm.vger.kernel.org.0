Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF12A7CE8ED
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbjJRU3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbjJRU3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:29:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A7912E
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:29:08 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIn01s011272;
        Wed, 18 Oct 2023 20:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=hfPlHaSKnVDKTaCBUM3vYx8LN+gKAE13c24dYNrrQn0=;
 b=FWUakFOlhiq23fDb/82IDwARaLKpvhrOLokQT6UGIawYPQI7UTkBmu542+sbtanBlVFU
 hiucnNt4bQ3HZj4GvH4kDcZJ2gjBI0pzGiakAshKyDyvX3b1AXuE3JN8sKZ+hxa4DX5Z
 UGxGQWeItybN6zFKf5LKCH08ZYWDyZpyEhvWtNRTZpZe/8SLotHlGcZyZATQ/4mV/Odc
 rD1fYlGWvLz+54xAzdAUipadt3azhpVkH5dJ+Mz5OhCQFEaQ9sKednkUHCkdYmTPmp5C
 49L0wvgts45GDARJYWC9jOgpWnYfvEuFQxHwV0T82CY2FdY6WGR/8wxYVjXvDg8JHlkh sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cgnj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IJvfIh010427;
        Wed, 18 Oct 2023 20:28:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps7sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5n040635;
        Wed, 18 Oct 2023 20:28:39 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-14;
        Wed, 18 Oct 2023 20:28:38 +0000
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
Subject: [PATCH v4 13/18] iommufd/selftest: Expand mock_domain with dev_flags
Date:   Wed, 18 Oct 2023 21:27:10 +0100
Message-Id: <20231018202715.69734-14-joao.m.martins@oracle.com>
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
X-Proofpoint-ORIG-GUID: nIuNMu2Z99FNPs4KW5iRI-1CxumTCVsi
X-Proofpoint-GUID: nIuNMu2Z99FNPs4KW5iRI-1CxumTCVsi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand mock_domain test to be able to manipulate the device capabilities.
This allows testing with mockdev without dirty tracking support advertised
and thus make sure enforce_dirty test does the expected.

To avoid breaking IOMMUFD_TEST UABI replicate the mock_domain struct and
thus add an input dev_flags at the end.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/iommufd_test.h          | 12 ++++++++
 drivers/iommu/iommufd/selftest.c              | 11 +++++--
 tools/testing/selftests/iommu/iommufd_utils.h | 30 +++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 3f3644375bf1..9817edcd8968 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -19,6 +19,7 @@ enum {
 	IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT,
 	IOMMU_TEST_OP_MOCK_DOMAIN_REPLACE,
 	IOMMU_TEST_OP_ACCESS_REPLACE_IOAS,
+	IOMMU_TEST_OP_MOCK_DOMAIN_FLAGS,
 };
 
 enum {
@@ -40,6 +41,10 @@ enum {
 	MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES = 1 << 0,
 };
 
+enum {
+	MOCK_FLAGS_DEVICE_NO_DIRTY = 1 << 0,
+};
+
 struct iommu_test_cmd {
 	__u32 size;
 	__u32 op;
@@ -56,6 +61,13 @@ struct iommu_test_cmd {
 			/* out_idev_id is the standard iommufd_bind object */
 			__u32 out_idev_id;
 		} mock_domain;
+		struct {
+			__u32 out_stdev_id;
+			__u32 out_hwpt_id;
+			__u32 out_idev_id;
+			/* Expand mock_domain to set mock device flags */
+			__u32 dev_flags;
+		} mock_domain_flags;
 		struct {
 			__u32 pt_id;
 		} mock_domain_replace;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index fe7e3c7d933a..bd3704b28bfb 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -96,6 +96,7 @@ enum selftest_obj_type {
 
 struct mock_dev {
 	struct device dev;
+	unsigned long flags;
 };
 
 struct selftest_obj {
@@ -381,7 +382,7 @@ static void mock_dev_release(struct device *dev)
 	kfree(mdev);
 }
 
-static struct mock_dev *mock_dev_create(void)
+static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 {
 	struct mock_dev *mdev;
 	int rc;
@@ -391,6 +392,7 @@ static struct mock_dev *mock_dev_create(void)
 		return ERR_PTR(-ENOMEM);
 
 	device_initialize(&mdev->dev);
+	mdev->flags = dev_flags;
 	mdev->dev.release = mock_dev_release;
 	mdev->dev.bus = &iommufd_mock_bus_type.bus;
 
@@ -426,6 +428,7 @@ static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
 	struct iommufd_device *idev;
 	struct selftest_obj *sobj;
 	u32 pt_id = cmd->id;
+	u32 dev_flags = 0;
 	u32 idev_id;
 	int rc;
 
@@ -436,7 +439,10 @@ static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
 	sobj->idev.ictx = ucmd->ictx;
 	sobj->type = TYPE_IDEV;
 
-	sobj->idev.mock_dev = mock_dev_create();
+	if (cmd->op == IOMMU_TEST_OP_MOCK_DOMAIN_FLAGS)
+		dev_flags = cmd->mock_domain_flags.dev_flags;
+
+	sobj->idev.mock_dev = mock_dev_create(dev_flags);
 	if (IS_ERR(sobj->idev.mock_dev)) {
 		rc = PTR_ERR(sobj->idev.mock_dev);
 		goto out_sobj;
@@ -1019,6 +1025,7 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 						 cmd->add_reserved.start,
 						 cmd->add_reserved.length);
 	case IOMMU_TEST_OP_MOCK_DOMAIN:
+	case IOMMU_TEST_OP_MOCK_DOMAIN_FLAGS:
 		return iommufd_test_mock_domain(ucmd, cmd);
 	case IOMMU_TEST_OP_MOCK_DOMAIN_REPLACE:
 		return iommufd_test_mock_domain_replace(
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index be4970a84977..8e84d2592f2d 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -74,6 +74,36 @@ static int _test_cmd_mock_domain(int fd, unsigned int ioas_id, __u32 *stdev_id,
 	EXPECT_ERRNO(_errno, _test_cmd_mock_domain(self->fd, ioas_id, \
 						   stdev_id, hwpt_id, NULL))
 
+static int _test_cmd_mock_domain_flags(int fd, unsigned int ioas_id,
+				       __u32 stdev_flags,
+				       __u32 *stdev_id, __u32 *hwpt_id,
+				       __u32 *idev_id)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN_FLAGS,
+		.id = ioas_id,
+		.mock_domain_flags = { .dev_flags = stdev_flags },
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_TEST_CMD, &cmd);
+	if (ret)
+		return ret;
+	if (stdev_id)
+		*stdev_id = cmd.mock_domain_flags.out_stdev_id;
+	assert(cmd.id != 0);
+	if (hwpt_id)
+		*hwpt_id = cmd.mock_domain_flags.out_hwpt_id;
+	if (idev_id)
+		*idev_id = cmd.mock_domain_flags.out_idev_id;
+	return 0;
+}
+#define test_err_mock_domain_flags(_errno, ioas_id, flags, stdev_id, hwpt_id) \
+	EXPECT_ERRNO(_errno, _test_cmd_mock_domain_flags(self->fd, ioas_id, \
+							 flags, stdev_id, \
+							 hwpt_id, NULL))
+
 static int _test_cmd_mock_domain_replace(int fd, __u32 stdev_id, __u32 pt_id,
 					 __u32 *hwpt_id)
 {
-- 
2.17.2

