Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEF564E385
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLOVyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiLOVyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:54:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1885C759
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:54:00 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3tuj026496;
        Thu, 15 Dec 2022 21:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=eJvH5/KQ+BGX25Ooc3nwA+7lejsPcwbvdUMXXRjglKg=;
 b=ASKCnQTF3/9b0wS1CFDs+T+9XAhoTK+wS5WpTW2rSmfDyzIEf99KfqvvtX3PzcWkH8wP
 iBNvJBoRGhy23Qabt4/84QfvykpIZsMZCaEZ8wixpK/eN90GfA5QWQo3+yi0HTtakTaO
 VPE5sFdWtiead3hnSlm44iSQk2wx9rU0IoOhaQ43Ihr/QlJlApX6JuP30ws5hywpEQIm
 TRiJm83NDYHJVowJbtvQN3DamiaUFGkzN/z4OGYMUTDMwy6sdSSGgOzDwi/lFXK7rypL
 gPpNajyfxBlD0T/53lqQdJ2+YM9taXk4ZdkHAk48y48uoWVgn4QO0bzbmZOo2rNiwIdr 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerxaum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:53:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKuQMs010026;
        Thu, 15 Dec 2022 21:53:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyepnw2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:53:54 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLrrDs005013;
        Thu, 15 Dec 2022 21:53:54 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyepnw0y-3;
        Thu, 15 Dec 2022 21:53:54 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Date:   Thu, 15 Dec 2022 13:53:49 -0800
Message-Id: <1671141232-81814-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671141232-81814-1-git-send-email-steven.sistare@oracle.com>
References: <1671141232-81814-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-ORIG-GUID: 9S7Eb0Ogw3VpYy6Ps1Hfc62HXo6Cpa_y
X-Proofpoint-GUID: 9S7Eb0Ogw3VpYy6Ps1Hfc62HXo6Cpa_y
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

