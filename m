Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27687ABD00
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjIWB2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjIWB2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874151AB
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLYkO0010127;
        Sat, 23 Sep 2023 01:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=3u0RSMF1r05iTGVhgSGMRyxKCj1ZVYujVX+aUdcO+fI=;
 b=Ax9dJ7oGORI4fIBfkntShMzk9/VcfzS9JLsgfQ9jGtufZdKAFpihm3qiftDLYVYG7uek
 ODZxcKjYPucP2mcfYAckzBilS6COoPkVzfxu8XtGtYB0A6eMlQWPC0E/e7iUF3hdLb0M
 KnuE7TyMTamNi1PMyTlGu3F2NUn9RyKTr56CMlylFB7i4gJqTvHr4ZodugLM4uqFo/Eo
 76g0aJiq8NEVNnG283Hqc+YoAi8xJnBVHb0M6IVYwjgqrxUgsZKayFR/eN6wbL/Vh8kG
 gLinbvuYS+CxZXz/VaY1eF0277w4ErepOMZikJxOL8fJFfXqRKp51LFBKPKkHE18EhHV WA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvu317-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38MNLcPF007665;
        Sat, 23 Sep 2023 01:27:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:52 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hO040930;
        Sat, 23 Sep 2023 01:27:51 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-15;
        Sat, 23 Sep 2023 01:27:51 +0000
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
Subject: [PATCH v3 14/19] iommufd: Add a flag to skip clearing of IOPTE dirty
Date:   Sat, 23 Sep 2023 02:25:06 +0100
Message-Id: <20230923012511.10379-15-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=975 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-ORIG-GUID: QLL3uy1T2rC03CcqAbXWnMMXNe-XMqTB
X-Proofpoint-GUID: QLL3uy1T2rC03CcqAbXWnMMXNe-XMqTB
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO has an operation where it unmaps an IOVA while returning a bitmap
with the dirty data. In reality the operation doesn't quite query the IO
pagetables that the PTE was dirty or not. Instead it marks as dirty on
anything that was mapped, and doing so in one syscall.

In IOMMUFD the equivalent is done in two operations by querying with
GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two TLB
flushes given that after clearing dirty bits IOMMU implementations require
invalidating their IOTLB, plus another invalidation needed for the UNMAP.
To allow dirty bits to be queried faster, add a flag
(IOMMU_GET_DIRTY_IOVA_NO_CLEAR) that requests to not clear the dirty bits
from the PTE (but just reading them), under the expectation that the next
operation is the unmap. An alternative is to unmap and just perpectually
mark as dirty as that's the same behaviour as today. So here equivalent
functionally can be provided with unmap alone, and if real dirty info is
required it will amortize the cost while querying.

There's still a race against DMA where in theory the unmap of the IOVA
(when the guest invalidates the IOTLB via emulated iommu) would race
against the VF performing DMA on the same IOVA. As discussed in [0],
we are accepting to resolve this race as throwing away the DMA and it
doesn't matter if it hit physical DRAM or not, the VM can't tell if we
threw it away because the DMA was blocked or because we failed to copy
the DRAM.

[0] https://lore.kernel.org/linux-iommu/20220502185239.GR8364@nvidia.com/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c |  3 ++-
 drivers/iommu/iommufd/io_pagetable.c |  9 +++++++--
 include/uapi/linux/iommufd.h         | 12 ++++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index a5712992bb4b..386cf0e61b4e 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -255,7 +255,8 @@ int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc = -EOPNOTSUPP;
 
-	if ((cmd->flags || cmd->__reserved))
+	if ((cmd->flags & ~(IOMMU_GET_DIRTY_IOVA_NO_CLEAR)) ||
+	    cmd->__reserved)
 		return -EOPNOTSUPP;
 
 	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index b9e58601d1d4..e22c17da877c 100644
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
 	struct iommu_dirty_bitmap *dirty = arg->dirty;
 	const struct iommu_dirty_ops *ops = domain->dirty_ops;
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
index 34703683eb8e..796ebc7b60ac 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -512,6 +512,18 @@ struct iommufd_dirty_data {
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

