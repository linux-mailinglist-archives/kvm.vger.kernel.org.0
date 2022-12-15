Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56A064E38C
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLOV5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLOV5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:57:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AA2275D4
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:57:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL4GWW017048;
        Thu, 15 Dec 2022 21:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=SPUSEnqDM0FplqJsRL2BQzqIIf2wc/+cPOCofrqSTgM=;
 b=xrqZMbBdUAbQRkubiQXGNhfACHPhoULgpQIKaVzpI3+pNSXRzjSQpugYfqeLRaqUK1FT
 vhz6hWmOnTZMQzPTjKalQHY28U+CE0kIigwi3dTSIfaMDAmYcrnwq3bvUnCnrQHRPEKU
 Jr+OzQcOSHaakp6rcjHH+SH0iGczQrO14RWwZnwkRmHF15Udz9cd6dHEdRO/094q/DLm
 jmSIiFNyKB5E81Xc3ZS4ubjE0DqebpLiUovT0rBKTFnW3c1eVm+TWnJXFe5NfTC/fimc
 dDTQdhNPOV4FD21LMPKKOQId7zkRkrTsaxM4S3ipSpqwdDY7DR4FOUAt4v/572uTZUxz jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewx9rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKY5w2032948;
        Thu, 15 Dec 2022 21:57:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdf3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLv5XM007209;
        Thu, 15 Dec 2022 21:57:06 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyerdf2f-4;
        Thu, 15 Dec 2022 21:57:06 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V5 3/7] vfio/type1: count reserved pages
Date:   Thu, 15 Dec 2022 13:57:00 -0800
Message-Id: <1671141424-81853-4-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-GUID: NDJePonI4mrUH0kS_-vPybZ4SOb2XGJo
X-Proofpoint-ORIG-GUID: NDJePonI4mrUH0kS_-vPybZ4SOb2XGJo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A pinned dma mapping may include reserved pages, which are not included
in the task's locked_vm count.  Maintain a count of reserved pages, for
iommu capable devices, so that locked_vm can be restored after fork or
exec in a subsequent patch.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index cd49b656..add87cd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,7 @@ struct vfio_dma {
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
 	struct mm_struct	*mm;
+	long			reserved_pages;
 };
 
 struct vfio_batch {
@@ -662,7 +663,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 {
 	unsigned long pfn;
 	struct mm_struct *mm = current->mm;
-	long ret, pinned = 0, lock_acct = 0;
+	long ret, pinned = 0, lock_acct = 0, reserved_pages = 0;
 	bool rsvd;
 	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
 
@@ -716,7 +717,9 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (rsvd) {
+				reserved_pages++;
+			} else if (!vfio_find_vpfn(dma, iova)) {
 				if (!dma->lock_cap &&
 				    mm->locked_vm + lock_acct + 1 > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
@@ -746,6 +749,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 out:
 	ret = vfio_lock_acct(dma, lock_acct, false);
+	if (!ret)
+		dma->reserved_pages += reserved_pages;
 
 unpin_out:
 	if (batch->size == 1 && !batch->offset) {
@@ -771,7 +776,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, long npage,
 				    bool do_accounting)
 {
-	long unlocked = 0, locked = 0;
+	long unlocked = 0, locked = 0, reserved_pages = 0;
 	long i;
 
 	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
@@ -779,9 +784,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 			unlocked++;
 			if (vfio_find_vpfn(dma, iova))
 				locked++;
+		} else {
+			reserved_pages++;
 		}
 	}
 
+	dma->reserved_pages -= reserved_pages;
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
 
-- 
1.8.3.1

