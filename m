Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33317D534A
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343623AbjJXNzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbjJXNzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AFB6A56
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJNvD016025;
        Tue, 24 Oct 2023 13:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=IxOW2fXhEDRujdlbZfpjzprybVUr34TDN6D2bzHOaeA=;
 b=yEJD+mCiJh9O5YFcUuS2/PcXOm62aSKNKb3cWPgl620zzFgc9/ps3F7SrKkRZC8RPbUV
 wSX6JpxYtbWdv87k8JtvGvgVibI7ldJbRyzOxnZkApDpCrC/mXVtttw6fw43ZH+F5Dr5
 3oicKf9CC2sGmayZuYy01ChYj8ehsRVijEDtjr6bXX7Xln6j7NW7P6AR97JKKG1S3r+y
 0yaBXGRuW0/G9srHm3syT1RYs6aPVyA6IvJJ6HY4upwcRyTlcEQPoHrgzBaiYRb9b+6L
 x8bJj6l00sYpHdIldwWdi/C32y3ZzHhA1lnkUxUPNCySNmAAeCAsEW/x9aKmg8vvXZya ZA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv5e35gdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCLolU034524;
        Tue, 24 Oct 2023 13:51:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL98030007;
        Tue, 24 Oct 2023 13:51:57 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-10;
        Tue, 24 Oct 2023 13:51:57 +0000
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
Subject: [PATCH v6 09/18] iommufd: Add a flag to skip clearing of IOPTE dirty
Date:   Tue, 24 Oct 2023 14:51:00 +0100
Message-Id: <20231024135109.73787-10-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=908 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-GUID: I4tTiXRegro2KYx5Ki6A-QwM1GwqQTGd
X-Proofpoint-ORIG-GUID: I4tTiXRegro2KYx5Ki6A-QwM1GwqQTGd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO has an operation where it unmaps an IOVA while returning a bitmap with
the dirty data. In reality the operation doesn't quite query the IO
pagetables that the PTE was dirty or not. Instead it marks as dirty on
anything that was mapped, and doing so in one syscall.

In IOMMUFD the equivalent is done in two operations by querying with
GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two TLB
flushes given that after clearing dirty bits IOMMU implementations require
invalidating their IOTLB, plus another invalidation needed for the UNMAP.
To allow dirty bits to be queried faster, add a flag
(IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR) that requests to not clear the dirty
bits from the PTE (but just reading them), under the expectation that the
next operation is the unmap. An alternative is to unmap and just
perpectually mark as dirty as that's the same behaviour as today. So here
equivalent functionally can be provided with unmap alone, and if real dirty
info is required it will amortize the cost while querying.

There's still a race against DMA where in theory the unmap of the IOVA
(when the guest invalidates the IOTLB via emulated iommu) would race
against the VF performing DMA on the same IOVA. As discussed in [0], we are
accepting to resolve this race as throwing away the DMA and it doesn't
matter if it hit physical DRAM or not, the VM can't tell if we threw it
away because the DMA was blocked or because we failed to copy the DRAM.

[0] https://lore.kernel.org/linux-iommu/20220502185239.GR8364@nvidia.com/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/iommufd/hw_pagetable.c |  3 ++-
 drivers/iommu/iommufd/io_pagetable.c |  9 +++++++--
 include/uapi/linux/iommufd.h         | 15 ++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 7316f69110ef..72a5269984b0 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -228,7 +228,8 @@ int iommufd_hwpt_get_dirty_bitmap(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc = -EOPNOTSUPP;
 
-	if ((cmd->flags || cmd->__reserved))
+	if ((cmd->flags & ~(IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR)) ||
+	    cmd->__reserved)
 		return -EOPNOTSUPP;
 
 	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 255264e796fb..9f060abe53b6 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -414,6 +414,7 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 }
 
 struct iova_bitmap_fn_arg {
+	unsigned long flags;
 	struct io_pagetable *iopt;
 	struct iommu_domain *domain;
 	struct iommu_dirty_bitmap *dirty;
@@ -430,13 +431,14 @@ static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
 	struct iommu_dirty_bitmap *dirty = arg->dirty;
 	const struct iommu_dirty_ops *ops = domain->dirty_ops;
 	unsigned long last_iova = iova + length - 1;
+	unsigned long flags = arg->flags;
 	int ret;
 
 	iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
 		unsigned long last = min(last_iova, iopt_area_last_iova(area));
 
 		ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
-						last - iter.cur_iova + 1, 0,
+						last - iter.cur_iova + 1, flags,
 						dirty);
 		if (ret)
 			return ret;
@@ -470,12 +472,15 @@ iommu_read_and_clear_dirty(struct iommu_domain *domain,
 
 	iommu_dirty_bitmap_init(&dirty, iter, &gather);
 
+	arg.flags = flags;
 	arg.iopt = iopt;
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
index 036ebc6c19cf..c44eecf5d318 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -500,11 +500,24 @@ struct iommu_hwpt_set_dirty_tracking {
 #define IOMMU_HWPT_SET_DIRTY_TRACKING _IO(IOMMUFD_TYPE, \
 					  IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING)
 
+/**
+ * enum iommufd_hwpt_get_dirty_bitmap_flags - Flags for getting dirty bits
+ * @IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR: Just read the PTEs without clearing
+ *                                        any dirty bits metadata. This flag
+ *                                        can be passed in the expectation
+ *                                        where the next operation is an unmap
+ *                                        of the same IOVA range.
+ *
+ */
+enum iommufd_hwpt_get_dirty_bitmap_flags {
+	IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR = 1,
+};
+
 /**
  * struct iommu_hwpt_get_dirty_bitmap - ioctl(IOMMU_HWPT_GET_DIRTY_BITMAP)
  * @size: sizeof(struct iommu_hwpt_get_dirty_bitmap)
  * @hwpt_id: HW pagetable ID that represents the IOMMU domain
- * @flags: Must be zero
+ * @flags: Combination of enum iommufd_hwpt_get_dirty_bitmap_flags
  * @__reserved: Must be 0
  * @iova: base IOVA of the bitmap first bit
  * @length: IOVA range size
-- 
2.17.2

