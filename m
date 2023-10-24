Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1C7D5354
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjJXNz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbjJXNzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8C26E95
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJOHW016074;
        Tue, 24 Oct 2023 13:52:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=EggU1ZaR16oH0CjAwVXIsT4mjygXDCdFHHu0QbOvxEs=;
 b=B7AF/9vgJqikS3hvWJP/ndj8kbxwrO3koh4tsKNKCMvOUL8sPaHhfcUPd0xioCEN+gGS
 kAB/GdzkEwtsr6StoWGwCwGfM4KYSpm8QKrT64KSJ7Y2ZA1PfOb5Gn+nyJ2eUiLRaCoQ
 GbCUdeeK4QBI7eK48fujGhrQHytWjJTg7KXM6MZLdTG6kmykKEqyYOi08LibIohZ+Os/
 5OSelyQt1l3De7VHdtyI2U+5T8aiNB/6RMQQeqGj8ogu0I4C5xXsO5uav4uaS1zdK3eG
 7DsUw/L9CSsllMoqMZcPaqvzEIbaN/dXX1BqHJY4SFXGQZ3Y/NbJV1EGgvsq1dvKTzkx Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv5e35gf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OC5LMj034624;
        Tue, 24 Oct 2023 13:52:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:18 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL9I030007;
        Tue, 24 Oct 2023 13:52:18 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-15;
        Tue, 24 Oct 2023 13:52:17 +0000
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
Subject: [PATCH v6 14/18] iommufd/selftest: Test IOMMU_HWPT_ALLOC_DIRTY_TRACKING
Date:   Tue, 24 Oct 2023 14:51:05 +0100
Message-Id: <20231024135109.73787-15-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: 9AjcFbRDoqunYbbN_Q0Hd4B7Unz1dxAw
X-Proofpoint-ORIG-GUID: 9AjcFbRDoqunYbbN_Q0Hd4B7Unz1dxAw
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/iommufd/selftest.c              | 37 +++++++++++++-
 tools/testing/selftests/iommu/iommufd.c       | 49 +++++++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h |  3 ++
 3 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index bd3704b28bfb..78362f2334f5 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -119,6 +119,11 @@ static void mock_domain_blocking_free(struct iommu_domain *domain)
 static int mock_domain_nop_attach(struct iommu_domain *domain,
 				  struct device *dev)
 {
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
+
+	if (domain->dirty_ops && (mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -147,6 +152,25 @@ static void *mock_domain_hw_info(struct device *dev, u32 *length, u32 *type)
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
 static const struct iommu_ops mock_ops;
 
 static struct iommu_domain *mock_domain_alloc(unsigned int iommu_domain_type)
@@ -174,12 +198,20 @@ static struct iommu_domain *mock_domain_alloc(unsigned int iommu_domain_type)
 static struct iommu_domain *
 mock_domain_alloc_user(struct device *dev, u32 flags)
 {
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
 	struct iommu_domain *domain;
 
-	if (flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT))
+	if (flags &
+	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
+	    (mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	domain = mock_domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+	if (domain && !(mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY))
+		domain->dirty_ops = &dirty_ops;
 	if (!domain)
 		domain = ERR_PTR(-ENOMEM);
 	return domain;
@@ -387,6 +419,9 @@ static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 	struct mock_dev *mdev;
 	int rc;
 
+	if (dev_flags & ~(MOCK_FLAGS_DEVICE_NO_DIRTY))
+		return ERR_PTR(-EINVAL);
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return ERR_PTR(-ENOMEM);
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 6323153d277b..6bebba183426 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1433,6 +1433,55 @@ TEST_F(iommufd_mock_domain, alloc_hwpt)
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
+	test_cmd_mock_domain(self->ioas_id, &self->stdev_id, &self->hwpt_id,
+			     &self->idev_id);
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
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING, &hwpt_id);
+	test_cmd_mock_domain(hwpt_id, &stddev_id, NULL, NULL);
+	test_err_mock_domain_flags(EINVAL, hwpt_id, dev_flags, &stddev_id,
+				   NULL);
+	test_ioctl_destroy(stddev_id);
+	test_ioctl_destroy(hwpt_id);
+
+	/* IOMMU device does not support dirty tracking */
+	test_ioctl_ioas_alloc(&ioas_id);
+	test_cmd_mock_domain_flags(ioas_id, dev_flags, &stddev_id, &_hwpt_id,
+				   &idev_id);
+	test_err_hwpt_alloc(EOPNOTSUPP, idev_id, ioas_id,
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING, &hwpt_id);
+	test_ioctl_destroy(stddev_id);
+}
+
 /* VFIO compatibility IOCTLs */
 
 TEST_F(iommufd, simple_ioctls)
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 1e0736adc991..4ddafa29e638 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -98,6 +98,9 @@ static int _test_cmd_mock_domain_flags(int fd, unsigned int ioas_id,
 		*idev_id = cmd.mock_domain_flags.out_idev_id;
 	return 0;
 }
+#define test_cmd_mock_domain_flags(ioas_id, flags, stdev_id, hwpt_id, idev_id) \
+	ASSERT_EQ(0, _test_cmd_mock_domain_flags(self->fd, ioas_id, flags,     \
+						 stdev_id, hwpt_id, idev_id))
 #define test_err_mock_domain_flags(_errno, ioas_id, flags, stdev_id, hwpt_id) \
 	EXPECT_ERRNO(_errno,                                                  \
 		     _test_cmd_mock_domain_flags(self->fd, ioas_id, flags,    \
-- 
2.17.2

