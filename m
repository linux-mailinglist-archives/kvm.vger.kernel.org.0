Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F9364D1BB
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLNVZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiLNVZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:25:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA9E36D5C
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:25:05 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BELO92M002336;
        Wed, 14 Dec 2022 21:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=eJvH5/KQ+BGX25Ooc3nwA+7lejsPcwbvdUMXXRjglKg=;
 b=xEEzwZCWU9/YReDRqzr7L89p1OxLCOQ0fHGx/VyMww6TCugd/PSfi67gxC+xXFtNQjHM
 HIXRUrIvjfBOXB0Y9SHsRYJW0b7FkjTLZmDl74R6QAqgHLuOK2K9eDC+MfZyZjwf2HSV
 P6DB5cXuHLVaGC4D9LMfFEQ3Tx4p+higvcnkaBNPa/H5+8LI5Hr5vjdpQuihdQ7B+U5P
 UX0D4DBcA26WxJnFJEzWSaTB8Qorv0qjlnwcwjWA9L2DcTgXoIeJkHKNkrX6GFkInz1O
 +G6Q9mu/F0O9rB2PXiht+ldHfCtfF14G8/5sb5tovvd9FrKIekXcCN8qGSVYTQ5hWlSl 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewucvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 21:25:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEL2Ac7004023;
        Wed, 14 Dec 2022 21:25:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewpxm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 21:25:00 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BELOwGE024340;
        Wed, 14 Dec 2022 21:25:00 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyewpxhh-3;
        Wed, 14 Dec 2022 21:25:00 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Date:   Wed, 14 Dec 2022 13:24:54 -0800
Message-Id: <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140175
X-Proofpoint-GUID: DCagwKt3-iU4_Dl1hvBv45e67bd-zAyo
X-Proofpoint-ORIG-GUID: DCagwKt3-iU4_Dl1hvBv45e67bd-zAyo
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
 drivers/vfio/vfio_iommu_type1.c | 50 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bdfc13c..33dc8ec 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -415,7 +416,7 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct mm_struct *mm;
-	int ret;
+	int ret = 0;
 
 	if (!npage)
 		return 0;
@@ -424,6 +425,10 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!mm)
 		return -ESRCH; /* process exited */
 
+	/* Avoid locked_vm underflow */
+	if (dma->mm != mm && npage < 0)
+		goto out;
+
 	ret = mmap_write_lock_killable(mm);
 	if (!ret) {
 		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
@@ -431,6 +436,7 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 		mmap_write_unlock(mm);
 	}
 
+out:
 	if (async)
 		mmput(mm);
 
@@ -1180,6 +1186,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1578,6 +1585,42 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
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
@@ -1627,6 +1670,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
+			ret = vfio_change_dma_owner(dma);
+			if (ret)
+				goto out_unlock;
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
@@ -1687,6 +1733,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = dma->task->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
-- 
1.8.3.1

