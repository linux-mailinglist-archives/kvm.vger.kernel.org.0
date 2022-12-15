Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B90864E38D
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLOV5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiLOV5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:57:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFD62CC87
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:57:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3k4g010954;
        Thu, 15 Dec 2022 21:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=zYk+81lsgpnrXOpcBndRm09MGc/rQbyq/9Tg6QPGmsU=;
 b=1vNtnmYmx1ZxTTXm5NpYvw5mcuv7xJew6b8jwSdAvrni86/GXyjyjwTxg49nZufke+5E
 mi4cvjI+P7DxEHRzoQHK8zh5Wrtj/1yRmW5SwY5F+7QLMcRpCI214+MjAD50vW2QbuZQ
 0Xj3Mkgi717TSyf06Ub5mpJCi5x1Z1IX52UQp2vPXbE1UYvHE1L9nFHmUpNOk76F0NqO
 LquMsS3R8yRPAx+C86DlzVRHNzKkslcTglkVGM8Lkhw5NprrXEQ4HWI2YIPlT4nl0hYv
 U4uPq3ZqnYzZ+2bXgvi3mwHJE3WyXZ8myKCHZi9n2lIhNrPGHqTVkpbb27OwV1kpsu0m 0g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewx8wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKHqtn032951;
        Thu, 15 Dec 2022 21:57:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdf3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:06 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLv5XK007209;
        Thu, 15 Dec 2022 21:57:06 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyerdf2f-3;
        Thu, 15 Dec 2022 21:57:06 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Date:   Thu, 15 Dec 2022 13:56:59 -0800
Message-Id: <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-GUID: H43UNB0ZP0NJk3rhufUzX1zEm3ptvS5v
X-Proofpoint-ORIG-GUID: H43UNB0ZP0NJk3rhufUzX1zEm3ptvS5v
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vfio container is preserved across exec, the task does not change,
but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
mapping, locked_vm underflows to a large unsigned value, and a subsequent
dma map request fails with ENOMEM in __account_locked_vm.

To avoid underflow, grab and save the mm at the time a dma is mapped.
Use that mm when adjusting locked_vm, rather than re-acquiring the saved
task's mm, which may have changed.  If the saved mm is dead, do nothing.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 144f5bb..cd49b656 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!npage)
 		return 0;
 
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
+	mm = dma->mm;
+	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
 	ret = mmap_write_lock_killable(mm);
@@ -794,8 +795,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	struct mm_struct *mm;
 	int ret;
 
-	mm = get_task_mm(dma->task);
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
@@ -1180,6 +1181,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1687,6 +1689,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = dma->task->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
@@ -3122,9 +3126,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			!(dma->prot & IOMMU_READ))
 		return -EPERM;
 
-	mm = get_task_mm(dma->task);
-
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -EPERM;
 
 	if (kthread)
-- 
1.8.3.1

