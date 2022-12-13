Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686DA64BD6B
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 20:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiLMTlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 14:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236532AbiLMTlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 14:41:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CA0220DF
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:41:04 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJJKjV003937;
        Tue, 13 Dec 2022 19:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=dMDTpkbvKpVTy+8NBOjaHpYFCHDLSlyAIcZ1JHFTZbQ=;
 b=1X4qM5E+koqY+U2We71UG9OVylLgE+w4ucWfKvlXxWYLSQc8G0a/Ky5UxZ3IgoMMSp8G
 G/FjCzA4VjXvM9veJVKomDZE0m5yASa0hs8f4Eg1RuWpG0lTAuKLcVjUiSI+8b3NAv05
 8Cu6t8s6SIwjQPVH+uFSw7zbsDWmQ21hJfSwqjZ5M6B/vo580CYkBNSSRM1HNewywGOd
 /HiP98lvtnfS7LU1B+QnGiVFPN33Mk/AtGY+tgN8VFjKkfDS/BCZEa1FLRHlwkE+mZDd
 1D+qXmHBvBHhBr+6wf+ge6xIVG6IbBti6vDJMD1QIpPimLl4ROdGwKa/YeXfyefP6TIN Dg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerr20k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJJFsZ031305;
        Tue, 13 Dec 2022 19:41:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesrs0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:01 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDJf0Gl028128;
        Tue, 13 Dec 2022 19:41:01 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyesrry8-3;
        Tue, 13 Dec 2022 19:41:01 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 2/5] vfio/type1: prevent locked_vm underflow
Date:   Tue, 13 Dec 2022 11:40:56 -0800
Message-Id: <1670960459-415264-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130171
X-Proofpoint-ORIG-GUID: kshmGCNbDnWUxil7Ey9MXyZRRIAIN9Pf
X-Proofpoint-GUID: kshmGCNbDnWUxil7Ey9MXyZRRIAIN9Pf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
dma mapping, locked_vm underflows to a large unsigned value, and a
subsequent dma map request fails with ENOMEM in __account_locked_vm.

To avoid underflow, do not decrement locked_vm during unmap if the
dma's mm has changed.  To restore the correct locked_vm count, when
VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
the mapping's pinned page count to the new mm->locked_vm, subject
to the rlimit.  Now that mediated devices are excluded when using
VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
the mapping.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 80bdb4d..35a1a52 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -1165,7 +1166,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 					    &iotlb_gather);
 	}
 
-	if (do_accounting) {
+	if (do_accounting && current->mm == dma->mm) {
 		vfio_lock_acct(dma, -unlocked, true);
 		return 0;
 	}
@@ -1178,6 +1179,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1623,9 +1625,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
-			dma->vaddr = vaddr;
-			dma->vaddr_invalid = false;
-			iommu->vaddr_invalid_count--;
+			if (current->mm != dma->mm) {
+				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
+						     0);
+				if (!ret) {
+					mmdrop(dma->mm);
+					dma->mm = current->mm;
+					mmgrab(dma->mm);
+				}
+			}
+			if (!ret) {
+				dma->vaddr = vaddr;
+				dma->vaddr_invalid = false;
+				iommu->vaddr_invalid_count--;
+			}
 			wake_up_all(&iommu->vaddr_wait);
 		}
 		goto out_unlock;
@@ -1683,6 +1696,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = dma->task->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
-- 
1.8.3.1

