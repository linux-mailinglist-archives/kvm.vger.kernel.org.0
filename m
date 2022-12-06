Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118F9644E3D
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLFV4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiLFVz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:55:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F3D4875E
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:55:58 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LIcve002852;
        Tue, 6 Dec 2022 21:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=woDX6dgFALfxPMTqVf1e0el2wgymWJeHZBAEvohyXt4=;
 b=VwsT0ADVU3MbY0mJsc8HiPgYnJ0qE81CL6AIamn/SgfFiUOcEuikOb/CokyFAeV2AXIw
 l2ZfRL0PLzk9Ui99GvLXc1XxQoUIeWViDzoC/3tsAiZRLZcFK4mKwfWgUUt9PusyntH4
 8EKnopreim8Z3jhsbSAiVhTQrrVQyuLgsFtxVEdck82I4xEn074aflNqQSzs+6Q3/vv2
 FclW1z5TtRIOrOFBEemIKYt7V7A35A8llC6QY/thhzWBEPoKeXXcvqnLL/cNY8odE42X
 a6XyUf+yKGrXuxFzkM0jcw9vNJGgWnpmisvscRgepVovOECP8ZAMshEs4lhre9iF0l2E 6w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yb3gpu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LFk1i033187;
        Tue, 6 Dec 2022 21:55:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2m9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:55 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0l038701;
        Tue, 6 Dec 2022 21:55:55 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-3;
        Tue, 06 Dec 2022 21:55:55 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 2/8] vfio/type1: dma owner permission
Date:   Tue,  6 Dec 2022 13:55:47 -0800
Message-Id: <1670363753-249738-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060184
X-Proofpoint-ORIG-GUID: 5kqJoSp08QD9pHeVt5dTdoXoebf0v_dh
X-Proofpoint-GUID: 5kqJoSp08QD9pHeVt5dTdoXoebf0v_dh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first task to pin any pages becomes the dma owner, and becomes the only
task allowed to pin.  This prevents an application from exceeding the
initial task's RLIMIT_MEMLOCK by fork'ing and pinning in children.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 64 +++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 02c6ea3..4429794 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -75,6 +75,7 @@ struct vfio_iommu {
 	bool			nesting;
 	bool			dirty_page_tracking;
 	struct list_head	emulated_iommu_groups;
+	struct task_struct	*task;
 };
 
 struct vfio_domain {
@@ -93,9 +94,9 @@ struct vfio_dma {
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
-	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct vfio_iommu	*iommu;		/* back pointer */
 };
 
 struct vfio_batch {
@@ -408,19 +409,29 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
+	struct task_struct *task = dma->iommu->task;
+	bool kthread = !current->mm;
 	struct mm_struct *mm;
 	int ret;
 
 	if (!npage)
 		return 0;
 
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
+	/* This is enforced at higher levels, so if it bites, it is a bug. */
+
+	if (!kthread && current->group_leader != task) {
+		WARN_ONCE(1, "%s: caller is pid %d, owner is pid %d\n",
+			  __func__, current->group_leader->pid, task->pid);
+		return -EPERM;
+	}
+
+	mm = async ? get_task_mm(task) : task->mm;
 	if (!mm)
 		return -ESRCH; /* process exited */
 
 	ret = mmap_write_lock_killable(mm);
 	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
+		ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
 					  dma->lock_cap);
 		mmap_write_unlock(mm);
 	}
@@ -609,6 +620,9 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
+	if (dma->iommu->task != current->group_leader)
+		return -EPERM;
+
 	if (batch->size) {
 		/* Leftover pages in batch from an earlier call. */
 		*pfn_base = page_to_pfn(batch->pages[batch->offset]);
@@ -730,11 +744,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
+	struct task_struct *task = dma->iommu->task;
 	struct page *pages[1];
 	struct mm_struct *mm;
 	int ret;
 
-	mm = get_task_mm(dma->task);
+	mm = get_task_mm(task);
 	if (!mm)
 		return -ENODEV;
 
@@ -751,8 +766,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 			if (ret == -ENOMEM)
 				pr_warn("%s: Task %s (%d) RLIMIT_MEMLOCK "
 					"(%ld) exceeded\n", __func__,
-					dma->task->comm, task_pid_nr(dma->task),
-					task_rlimit(dma->task, RLIMIT_MEMLOCK));
+					task->comm, task_pid_nr(task),
+					task_rlimit(task, RLIMIT_MEMLOCK));
 		}
 	}
 
@@ -784,6 +799,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 				      int npage, int prot,
 				      struct page **pages)
 {
+	bool kthread = !current->mm;
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
 	int i, j, ret;
@@ -807,6 +823,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		goto pin_done;
 	}
 
+	if (!kthread && iommu->task != current->group_leader) {
+		ret = -EPERM;
+		goto pin_done;
+	}
+
 	/*
 	 * If iommu capable domain exist in the container then all pages are
 	 * already pinned and accounted. Accounting should be done if there is no
@@ -1097,7 +1118,6 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
-	put_task_struct(dma->task);
 	vfio_dma_bitmap_free(dma);
 	kfree(dma);
 	iommu->dma_avail++;
@@ -1247,6 +1267,16 @@ static void vfio_notify_dma_unmap(struct vfio_iommu *iommu,
 	mutex_lock(&iommu->lock);
 }
 
+static void vfio_iommu_set_task(struct vfio_iommu *iommu,
+				struct task_struct *task)
+{
+	if (iommu->task)
+		put_task_struct(iommu->task);
+	if (task)
+		iommu->task = get_task_struct(task);
+	iommu->task = task;
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap,
 			     struct vfio_bitmap *bitmap)
@@ -1362,6 +1392,9 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 unlock:
+	if (RB_EMPTY_ROOT(&iommu->dma_list))
+		vfio_iommu_set_task(iommu, NULL);
+
 	mutex_unlock(&iommu->lock);
 
 	/* Report how much was unmapped */
@@ -1537,6 +1570,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	}
 
 	iommu->dma_avail--;
+	dma->iommu = iommu;
 	dma->iova = iova;
 	dma->vaddr = vaddr;
 	dma->prot = prot;
@@ -1566,8 +1600,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 * externally mapped.  Therefore track CAP_IPC_LOCK in vfio_dma at the
 	 * time of calling MAP_DMA.
 	 */
-	get_task_struct(current->group_leader);
-	dma->task = current->group_leader;
+	if (!iommu->task)
+		vfio_iommu_set_task(iommu, current->group_leader);
 	dma->lock_cap = capable(CAP_IPC_LOCK);
 
 	dma->pfn_list = RB_ROOT;
@@ -2528,6 +2562,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
 
 	vfio_iommu_iova_free(&iommu->iova_list);
 
+	vfio_iommu_set_task(iommu, NULL);
+
 	kfree(iommu);
 }
 
@@ -2963,6 +2999,7 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	bool kthread = current->mm == NULL;
 	size_t offset;
+	int ret = -EFAULT;
 
 	*copied = 0;
 
@@ -2974,15 +3011,18 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			!(dma->prot & IOMMU_READ))
 		return -EPERM;
 
-	mm = get_task_mm(dma->task);
+	mm = get_task_mm(iommu->task);
 
 	if (!mm)
 		return -EPERM;
 
 	if (kthread)
 		kthread_use_mm(mm);
-	else if (current->mm != mm)
+	else if (current->mm != mm) {
+		/* Must use matching mm for vaddr translation. */
+		ret = -EPERM;
 		goto out;
+	}
 
 	offset = user_iova - dma->iova;
 
@@ -3011,7 +3051,7 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 		kthread_unuse_mm(mm);
 out:
 	mmput(mm);
-	return *copied ? 0 : -EFAULT;
+	return *copied ? 0 : ret;
 }
 
 static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
-- 
1.8.3.1

