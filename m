Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9DD64F13C
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 19:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiLPSuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 13:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPSuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 13:50:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D3C1AF2F
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:50:47 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGGhfQh026410;
        Fri, 16 Dec 2022 18:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=+Mh7h28sCvR5hSoYlXWF10NzFjGIYGF73QcCnSD8fTo=;
 b=Q5DfFOsgRd1rpiDcnH9bAH+etQfezpRl4dqvN9fnKW1IAPVXJD02HRo98iYvEBzwOrWr
 veMITx4dg7KrBmMkNaaRZJRptkTxRU4z4tbc1oQudxoh53++wekWQ9SaweCbj9EkK5XP
 sycF5UJb+xdMoxewbnp5lPzBz6jdT3JHDAq/f00wE5lQFqE9X8Tx0cOq7alcpT9wA13A
 xlIGIpM0MT3Vw7hrqANc+cUMhKZBjyYI/++8un6mtFUrbVil7/JYYHd0og0Aq4F/Y+xG
 G8lvzdonWJFK40YFVJT22zJy5ZODegPvqRcyq5Ad1DYfiY715/7m2WedOaeGKQEmMyL9 ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu89xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGH93IM027701;
        Fri, 16 Dec 2022 18:50:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesnv4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BGIofeK032502;
        Fri, 16 Dec 2022 18:50:42 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyesnv2x-3;
        Fri, 16 Dec 2022 18:50:41 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V6 2/7] vfio/type1: prevent underflow of locked_vm via exec()
Date:   Fri, 16 Dec 2022 10:50:35 -0800
Message-Id: <1671216640-157935-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_12,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212160164
X-Proofpoint-ORIG-GUID: 8qlmbaTxOJTGLaVbN2bWAsEQTSYoLlwH
X-Proofpoint-GUID: 8qlmbaTxOJTGLaVbN2bWAsEQTSYoLlwH
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

Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 144f5bb..71f980b 100644
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
@@ -1664,15 +1666,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 * against the locked memory limit and we need to be able to do both
 	 * outside of this call path as pinning can be asynchronous via the
 	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires a
-	 * task_struct and VM locked pages requires an mm_struct, however
-	 * holding an indefinite mm reference is not recommended, therefore we
-	 * only hold a reference to a task.  We could hold a reference to
-	 * current, however QEMU uses this call path through vCPU threads,
-	 * which can be killed resulting in a NULL mm and failure in the unmap
-	 * path when called via a different thread.  Avoid this problem by
-	 * using the group_leader as threads within the same group require
-	 * both CLONE_THREAD and CLONE_VM and will therefore use the same
-	 * mm_struct.
+	 * task_struct and VM locked pages requires an mm_struct.
 	 *
 	 * Previously we also used the task for testing CAP_IPC_LOCK at the
 	 * time of pinning and accounting, however has_capability() makes use
@@ -1687,6 +1681,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = current->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
@@ -3122,9 +3118,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
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

