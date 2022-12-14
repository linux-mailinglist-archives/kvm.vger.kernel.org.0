Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD61864D00B
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbiLNTXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiLNTXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:23:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA22252D
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:23:04 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHFbvX026622;
        Wed, 14 Dec 2022 19:23:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=F6wd5vHnUczYXEWI4gpODb0AfCyk0fqOWivQLIc/Hvw=;
 b=R5hGPwiw5uqdmqByn/5woOOpkjv/YoJUbqZ7EjQRfgLXW3Jx9w99Nap4SjdYmpIEMkf3
 9i/1HuRB0H7K9O1er/xIaYoNfGa+3PojDtVdrLpRXa+SIsgfVKpIhIwaieDFBgLLgrGZ
 dNLXQ+ChDJUKMyUInjarl1MOVSV6KqOEFAHGJ3XO5T25R3n1OBkSyu6ekroY50vPvBt8
 4ag/3ckgKvLKzM2DvGppvsl1PfMfDpBsizudNM3pmzt4nlhERfFKx7FVJtDobK3Q5IUq
 j2HMKgS8jW1RMrWWPHbvfcmwfAKa/2BD1/E8Adgr7e819H2zxI7wZG9qTe8QCuyU4jMb zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewb4vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:23:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEJ2654007134;
        Wed, 14 Dec 2022 19:22:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqa84j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:22:59 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEJMv3B040903;
        Wed, 14 Dec 2022 19:22:59 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyeqa7y1-3;
        Wed, 14 Dec 2022 19:22:59 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 2/5] vfio/type1: prevent locked_vm underflow
Date:   Wed, 14 Dec 2022 11:22:48 -0800
Message-Id: <1671045771-59788-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_10,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140157
X-Proofpoint-GUID: WWZxxzkEYwCol5pcqDSx6mksfcr9iSBX
X-Proofpoint-ORIG-GUID: WWZxxzkEYwCol5pcqDSx6mksfcr9iSBX
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

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b04f485..e719c13 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -424,6 +425,12 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!mm)
 		return -ESRCH; /* process exited */
 
+	/* Avoid locked_vm underflow */
+	if (dma->mm != mm && npage < 0) {
+		mmput(mm);
+		return 0;
+	}
+
 	ret = mmap_write_lock_killable(mm);
 	if (!ret) {
 		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
@@ -1180,6 +1187,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1578,6 +1586,42 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+static int vfio_change_dma_owner(struct vfio_dma *dma)
+{
+	int ret = 0;
+	struct mm_struct *mm = get_task_mm(dma->task);
+
+	if (dma->mm != mm) {
+		long npage = dma->size >> PAGE_SHIFT;
+		bool new_lock_cap = capable(CAP_IPC_LOCK);
+		struct task_struct *new_task = current->group_leader;
+
+		ret = mmap_write_lock_killable(new_task->mm);
+		if (ret)
+			goto out;
+
+		ret = __account_locked_vm(new_task->mm, npage, true,
+					  new_task, new_lock_cap);
+		mmap_write_unlock(new_task->mm);
+		if (ret)
+			goto out;
+
+		if (dma->task != new_task) {
+			vfio_lock_acct(dma, -npage, 0);
+			put_task_struct(dma->task);
+			dma->task = get_task_struct(new_task);
+		}
+		mmdrop(dma->mm);
+		dma->mm = new_task->mm;
+		mmgrab(dma->mm);
+		dma->lock_cap = new_lock_cap;
+	}
+out:
+	if (mm)
+		mmput(mm);
+	return ret;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1627,6 +1671,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
+			ret = vfio_change_dma_owner(dma);
+			if (ret)
+				goto out_unlock;
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
@@ -1687,6 +1734,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = dma->task->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
-- 
1.8.3.1

