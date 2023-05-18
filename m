Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E107089D5
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjERUtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjERUt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:49:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9817170E
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:49:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx5IS032279;
        Thu, 18 May 2023 20:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=dgIJgLe0f4AFWEuVxcCq+v9L7jR0hnU2/PxyXCkvh9o=;
 b=MqkUnr7A91I4gDFzm0o7pqlkwC0CNqViM2MQMgbjmpUlnwiSRKwM6XuhCGe5fgzKA2Ys
 sj10UJdOZXmH5omQHXXutTfs0xr0nYZbpwqPI76/yC40RKYRPE1OTZZCqLAq/1jEhtLW
 LHaKDY9QD0ORBC2DG+FEfZSlwH7GZBZDkeROzSaPkgIzQhBs5Ax/rOACwPSxuJvaDL1s
 OP1UqC2Viuc127L3C+tt2wQgBQJOJKd9ITiOInXA8mWYr/M4Gw+iezLUcdW2NdfwCACt
 KecgKnfpjlAs36d0NHfXeo8u4eKUdbO4vTXOsm65lHo5uvXxrw6aUqvZKyOTTgCZJq11 gg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qnkux92n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJV8d6032116;
        Thu, 18 May 2023 20:48:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dafc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3H033533;
        Thu, 18 May 2023 20:48:44 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-16;
        Thu, 18 May 2023 20:48:44 +0000
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
Subject: [PATCH RFCv2 15/24] iommufd: Add a flag to skip clearing of IOPTE dirty
Date:   Thu, 18 May 2023 21:46:41 +0100
Message-Id: <20230518204650.14541-16-joao.m.martins@oracle.com>
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
X-Proofpoint-ORIG-GUID: fQO7HOcsGn1E-efwFHvDeN3M0s6hON-Q
X-Proofpoint-GUID: fQO7HOcsGn1E-efwFHvDeN3M0s6hON-Q
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO has an operation where you an unmap an IOVA while returning a bitmap
with the dirty data. In reality the operation doesn't quite query the IO
pagetables that the the PTE was dirty or not, but it marks as dirty in the
bitmap anything that was mapped all in one operation.

In IOMMUFD this equivalent can be done in two operations by querying with
GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two TLB
flushes given that after clearing dirty bits IOMMU implementations require
invalidating their IOTLB, plus another invalidation needed for the UNMAP.
To allow dirty bits to be queried faster, we add a flag
(IOMMU_GET_DIRTY_IOVA_NO_CLEAR) that requests to not clear the dirty bits
from the PTE (but just reading them), under the expectation that the next
operation is the unmap. An alternative is to unmap and just perpectually
mark as dirty as that's the same behaviour as today. So here equivalent
functionally can be provided, and if real dirty info is required we
amortize the cost while querying.

There's still a race against DMA where in theory the unmap of the IOVA
(when the guest invalidates the IOTLB via emulated iommu) would race
against the VF performing DMA on the same IOVA being invalidated which
would be marking the PTE as dirty but losing the update in the
unmap-related IOTLB flush. The way to actually prevent the race would be to
write-protect the IOPTE, then query dirty bits and flush the IOTLB in the
unmap after.  However, this remains an issue that is so far theoretically
possible, but lacks an use case or whether the race is relevant in the
first place that justifies such complexity.

Link: https://lore.kernel.org/linux-iommu/20220502185239.GR8364@nvidia.com/
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c |  3 ++-
 drivers/iommu/iommufd/io_pagetable.c |  9 +++++++--
 include/uapi/linux/iommufd.h         | 12 ++++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 25860aa0a1f8..bcb81eefe16c 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -260,7 +260,8 @@ int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc = -EOPNOTSUPP;
 
-	if ((cmd->flags || cmd->__reserved))
+	if ((cmd->flags & ~(IOMMU_GET_DIRTY_IOVA_NO_CLEAR)) ||
+	    cmd->__reserved)
 		return -EOPNOTSUPP;
 
 	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 01adb0f7e4d0..ef58910ec747 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -414,6 +414,7 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 }
 
 struct iova_bitmap_fn_arg {
+	unsigned long flags;
 	struct iommu_domain *domain;
 	struct iommu_dirty_bitmap *dirty;
 };
@@ -426,8 +427,9 @@ static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
 	struct iommu_domain *domain = arg->domain;
 	const struct iommu_domain_ops *ops = domain->ops;
 	struct iommu_dirty_bitmap *dirty = arg->dirty;
+	unsigned long flags = arg->flags;
 
-	return ops->read_and_clear_dirty(domain, iova, length, 0, dirty);
+	return ops->read_and_clear_dirty(domain, iova, length, flags, dirty);
 }
 
 static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
@@ -451,11 +453,14 @@ static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
 
 	iommu_dirty_bitmap_init(&dirty, iter, &gather);
 
+	arg.flags = flags;
 	arg.domain = domain;
 	arg.dirty = &dirty;
 	iova_bitmap_for_each(iter, &arg, __iommu_read_and_clear_dirty);
 
-	iommu_iotlb_sync(domain, &gather);
+	if (!(flags & IOMMU_DIRTY_NO_CLEAR))
+		iommu_iotlb_sync(domain, &gather);
+
 	iova_bitmap_free(iter);
 
 	return ret;
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index c256f7354867..a91bf845e679 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -427,6 +427,18 @@ struct iommufd_dirty_data {
 	__aligned_u64 *data;
 };
 
+/**
+ * enum iommufd_get_dirty_iova_flags - Flags for getting dirty bits
+ * @IOMMU_GET_DIRTY_IOVA_NO_CLEAR: Just read the PTEs without clearing any dirty
+ *                                 bits metadata. This flag can be passed in the
+ *                                 expectation where the next operation is
+ *                                 an unmap of the same IOVA range.
+ *
+ */
+enum iommufd_hwpt_get_dirty_iova_flags {
+	IOMMU_GET_DIRTY_IOVA_NO_CLEAR = 1,
+};
+
 /**
  * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
  * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
-- 
2.17.2

