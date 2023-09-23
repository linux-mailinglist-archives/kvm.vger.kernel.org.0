Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4267ABCF8
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjIWB2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjIWB2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B29F19C
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLXxeK023248;
        Sat, 23 Sep 2023 01:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=+xNpJEZ6aoWG91kGb6yfnzXjrMHDQJHGVL2GOPlWkVc=;
 b=zeE/DTGmQ1zDFaQq7h7Skyt3hOsF2Rcgzy+9uBPBp0GgwgVgKP/a2G26vfHLRNir510z
 YuQZBsScB40BydDy8NpCsuO/SD4GzRNclhzeY6wLVM6a7HT5QgN59IXl2SlqE6r5SVpU
 vfCiQmjuV8t2law9QU+abU2aFpEh8JzYdERH8j/HbjNusMVbsAHAfMz9BpTaBSgIDRXz
 Z03SCZDSQN5hLQWOVr5WHNG6fDaDq8O3M/v29i6LRgI5D7dgn5iI20+9GZLLDuC9VoDs
 NYrfIQnXS+2yxL3Lblr1Y9Q4TvOZTRQwnBlldPKFFnoqGSk1LJ/V2qlXOSc4oQJ3QvMo hA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt034n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0dTxW007693;
        Sat, 23 Sep 2023 01:27:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3h8040930;
        Sat, 23 Sep 2023 01:27:24 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-7;
        Sat, 23 Sep 2023 01:27:24 +0000
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
Subject: [PATCH v3 06/19] iommufd/selftest: Test IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Date:   Sat, 23 Sep 2023 02:24:58 +0100
Message-Id: <20230923012511.10379-7-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: BhYfvTjuEL86lpAvyeHTlENUmVbYyCGM
X-Proofpoint-ORIG-GUID: BhYfvTjuEL86lpAvyeHTlENUmVbYyCGM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to selftest the iommu domain dirty enforcing implement the
mock_domain necessary support and add a new dev_flags to test that the
hwpt_alloc/attach_device fails as expected.

Expand the existing mock_domain fixture with a enforce_dirty test that
exercises the hwpt_alloc and device attachment.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/selftest.c              | 36 ++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 49 +++++++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h |  3 ++
 3 files changed, 88 insertions(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 966a98c0935e..4cf5a2b859e7 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -119,6 +119,12 @@ static void mock_domain_blocking_free(struct iommu_domain *domain)
 static int mock_domain_nop_attach(struct iommu_domain *domain,
 				  struct device *dev)
 {
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
+
+	if (domain->dirty_ops &&
+	    (mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -147,6 +153,26 @@ static void *mock_domain_hw_info(struct device *dev, u32 *length, u32 *type)
 	return info;
 }
 
+static int mock_domain_set_dirty_tracking(struct iommu_domain *domain,
+					  bool enable)
+{
+	return 0;
+}
+
+static int mock_domain_read_and_clear_dirty(struct iommu_domain *domain,
+					    unsigned long iova, size_t size,
+					    unsigned long flags,
+					    struct iommu_dirty_bitmap *dirty)
+{
+	return 0;
+}
+
+const struct iommu_dirty_ops dirty_ops = {
+	.set_dirty_tracking = mock_domain_set_dirty_tracking,
+	.read_and_clear_dirty = mock_domain_read_and_clear_dirty,
+};
+
+
 static const struct iommu_ops mock_ops;
 
 static struct iommu_domain *mock_domain_alloc(unsigned int iommu_domain_type)
@@ -174,9 +200,16 @@ static struct iommu_domain *mock_domain_alloc(unsigned int iommu_domain_type)
 static struct iommu_domain *
 mock_domain_alloc_user(struct device *dev, u32 flags)
 {
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
 	struct iommu_domain *domain;
 
+	if ((flags & IOMMU_HWPT_ALLOC_ENFORCE_DIRTY) &&
+	    (mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	domain = mock_domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+	if (domain && !(mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
+		domain->dirty_ops = &dirty_ops;
 	if (!domain)
 		domain = ERR_PTR(-ENOMEM);
 	return domain;
@@ -384,6 +417,9 @@ static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 	struct mock_dev *mdev;
 	int rc;
 
+	if (dev_flags & ~(MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return ERR_PTR(-EINVAL);
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return ERR_PTR(-ENOMEM);
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 9c129e63d7c7..71ad12867da6 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1430,6 +1430,55 @@ TEST_F(iommufd_mock_domain, alloc_hwpt)
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
+	uint32_t ioas_id, stddev_id, idev_id;
+	uint32_t hwpt_id, _hwpt_id;
+	uint32_t dev_flags;
+
+	/* Regular case */
+	dev_flags = MOCK_FLAGS_DEVICE_NO_DIRTY;
+	test_cmd_hwpt_alloc(self->idev_id, self->ioas_id,
+			    IOMMU_HWPT_ALLOC_ENFORCE_DIRTY, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_err_mock_domain_flags(EINVAL, hwpt_id, dev_flags,
+				   &stddev_id, NULL);
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+
+	/* IOMMU device does not support dirty tracking */
+	test_ioctl_ioas_alloc(&ioas_id);
+	test_cmd_mock_domain_flags(ioas_id, dev_flags,
+				   &stddev_id, &_hwpt_id, &idev_id);
+	test_err_hwpt_alloc(EOPNOTSUPP, idev_id, ioas_id,
+			    IOMMU_HWPT_ALLOC_ENFORCE_DIRTY, &hwpt_id);
+	test_ioctl_destroy(stddev_id);
+}
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 8e84d2592f2d..930edfe693c7 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -99,6 +99,9 @@ static int _test_cmd_mock_domain_flags(int fd, unsigned int ioas_id,
 		*idev_id = cmd.mock_domain_flags.out_idev_id;
 	return 0;
 }
+#define test_cmd_mock_domain_flags(ioas_id, flags, stdev_id, hwpt_id, idev_id)       \
+	ASSERT_EQ(0, _test_cmd_mock_domain_flags(self->fd, ioas_id, flags, \
+						 stdev_id, hwpt_id, idev_id))
 #define test_err_mock_domain_flags(_errno, ioas_id, flags, stdev_id, hwpt_id) \
 	EXPECT_ERRNO(_errno, _test_cmd_mock_domain_flags(self->fd, ioas_id, \
 							 flags, stdev_id, \
-- 
2.17.2

