Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500EE7089CC
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjERUsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjERUsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:48:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C40A170B
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:48:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIwuEr031068;
        Thu, 18 May 2023 20:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=L0Q7NWjsGheg+wnN5fTWgVsgopnQoZX5y/zPqPeSaRs=;
 b=U0U8y5pETs+0vjqBAjTiOz60zLgnWLHLzJhLXwX1XP43a3rvJo+8iEgkcjrSc5kIaqP5
 Hr6V7lKf5Z9SleArtuqDrr5VcRWcekykoIISWYdeA2N/+pHurFpJ5yHzl3qiJcb7vQ73
 TBqKIG2nFtdBI6iJChS9MaD4PYED6lSVzqDWx8/+5N/cBdKAxkc25ArrNcEpNWN2ME/i
 5ig2NDSCFCvr3BJ3WGlmDYEUvPVeCyKK23QFbJ8WuM+GCl7IdTKQwnOF9rDKqWJLfEvl
 I+3qOOlN1rfAoPscffmVyAn5LQ4n0Zk2DucyIbkNhQSEs2GJjg9Rowk51cJYPK5nz9rd 3g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0ye8t4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJ7NOv032193;
        Thu, 18 May 2023 20:47:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daehk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:44 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE31033533;
        Thu, 18 May 2023 20:47:43 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-8;
        Thu, 18 May 2023 20:47:43 +0000
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
Subject: [PATCH RFCv2 07/24] iommufd/selftest: Test IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Date:   Thu, 18 May 2023 21:46:33 +0100
Message-Id: <20230518204650.14541-8-joao.m.martins@oracle.com>
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
 engine=8.12.0-2304280000 definitions=main-2305180170
X-Proofpoint-ORIG-GUID: mtExfqFsCotpv87Lvg5oij-QJiEvRvVL
X-Proofpoint-GUID: mtExfqFsCotpv87Lvg5oij-QJiEvRvVL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to selftest the iommu domain dirty enforcing we implement the
mock_domain necessary support and add a new dev_flags to test that the
attach_device fails as expected.

Expand the existing mock_domain fixture with a enforce_dirty test that
exercises the hwpt_alloc and device attachment.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/iommufd_test.h          |  5 +++
 drivers/iommu/iommufd/selftest.c              | 16 +++++++-
 tools/testing/selftests/iommu/Makefile        |  3 ++
 tools/testing/selftests/iommu/iommufd.c       | 39 +++++++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h |  2 +-
 5 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index dd9168a20ddf..9abcc3231137 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -39,6 +39,10 @@ enum {
 	MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES = 1 << 0,
 };
 
+enum {
+	MOCK_FLAGS_DEVICE_NO_DIRTY = 1 << 0,
+};
+
 struct iommu_test_cmd {
 	__u32 size;
 	__u32 op;
@@ -50,6 +54,7 @@ struct iommu_test_cmd {
 			__aligned_u64 length;
 		} add_reserved;
 		struct {
+			__u32 dev_flags;
 			__u32 out_stdev_id;
 			__u32 out_hwpt_id;
 			/* out_idev_id is the standard iommufd_bind object */
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 9d43334e4faf..65daceb6e0dc 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -93,6 +93,7 @@ enum selftest_obj_type {
 
 struct mock_dev {
 	struct device dev;
+	unsigned long flags;
 };
 
 struct selftest_obj {
@@ -115,6 +116,12 @@ static void mock_domain_blocking_free(struct iommu_domain *domain)
 static int mock_domain_nop_attach(struct iommu_domain *domain,
 				  struct device *dev)
 {
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
+
+	if ((domain->flags & IOMMU_DOMAIN_F_ENFORCE_DIRTY) &&
+	    (mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -278,6 +285,7 @@ static void mock_domain_set_plaform_dma_ops(struct device *dev)
 
 static const struct iommu_ops mock_ops = {
 	.owner = THIS_MODULE,
+	.supported_flags = IOMMU_DOMAIN_F_ENFORCE_DIRTY,
 	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
 	.domain_alloc = mock_domain_alloc,
 	.capable = mock_domain_capable,
@@ -328,18 +336,22 @@ static void mock_dev_release(struct device *dev)
 	kfree(mdev);
 }
 
-static struct mock_dev *mock_dev_create(void)
+static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 {
 	struct iommu_group *iommu_group;
 	struct dev_iommu *dev_iommu;
 	struct mock_dev *mdev;
 	int rc;
 
+	if (dev_flags & ~(MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return ERR_PTR(-EINVAL);
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return ERR_PTR(-ENOMEM);
 
 	device_initialize(&mdev->dev);
+	mdev->flags = dev_flags;
 	mdev->dev.release = mock_dev_release;
 	mdev->dev.bus = &iommufd_mock_bus_type;
 
@@ -422,7 +434,7 @@ static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
 	sobj->idev.ictx = ucmd->ictx;
 	sobj->type = TYPE_IDEV;
 
-	sobj->idev.mock_dev = mock_dev_create();
+	sobj->idev.mock_dev = mock_dev_create(cmd->mock_domain.dev_flags);
 	if (IS_ERR(sobj->idev.mock_dev)) {
 		rc = PTR_ERR(sobj->idev.mock_dev);
 		goto out_sobj;
diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
index 32c5fdfd0eef..f1aee4e5ec2e 100644
--- a/tools/testing/selftests/iommu/Makefile
+++ b/tools/testing/selftests/iommu/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += -I../../../../tools/include/
+CFLAGS += -I../../../../include/uapi/
+CFLAGS += -I../../../../include/
 CFLAGS += $(KHDR_INCLUDES)
 
 CFLAGS += -D_GNU_SOURCE
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 771e4a40200f..da7d1dad1816 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1354,6 +1354,45 @@ TEST_F(iommufd_mock_domain, alloc_hwpt)
 	}
 }
 
+FIXTURE(iommufd_dirty_tracking)
+{
+	int fd;
+	uint32_t ioas_id;
+	uint32_t hwpt_id;
+	uint32_t stdev_id;
+	uint32_t idev_id;
+};
+
+FIXTURE_SETUP(iommufd_dirty_tracking)
+{
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+
+	test_ioctl_ioas_alloc(&self->ioas_id);
+	test_cmd_mock_domain(self->ioas_id, &self->stdev_id,
+			     &self->hwpt_id, &self->idev_id);
+}
+
+FIXTURE_TEARDOWN(iommufd_dirty_tracking)
+{
+	teardown_iommufd(self->fd, _metadata);
+}
+
+TEST_F(iommufd_dirty_tracking, enforce_dirty)
+{
+	uint32_t dev_flags = MOCK_FLAGS_DEVICE_NO_DIRTY;
+	uint32_t stddev_id;
+	uint32_t hwpt_id;
+
+	test_cmd_hwpt_alloc(self->idev_id, self->ioas_id,
+			    IOMMU_HWPT_ALLOC_ENFORCE_DIRTY, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_err_mock_domain_flags(EINVAL, hwpt_id, dev_flags,
+				   &stddev_id, NULL);
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+}
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 04871bcfd34b..f8c926f96f23 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -48,7 +48,7 @@ static int _test_cmd_mock_domain(int fd, unsigned int ioas_id,
 		.size = sizeof(cmd),
 		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
 		.id = ioas_id,
-		.mock_domain = {},
+		.mock_domain = { .dev_flags = stdev_flags },
 	};
 	int ret;
 
-- 
2.17.2

