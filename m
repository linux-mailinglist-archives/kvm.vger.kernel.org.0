Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12850683325
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjAaQ6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjAaQ6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:58:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AD8CC2B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:58:18 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VEE3q8000920;
        Tue, 31 Jan 2023 16:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=l7UuHSDh10o99DI2aWzR6iM5Tv7FbWtI6vOm9Oekv0k=;
 b=WnA/RILHDmhGqulPjwM8UO5ZUnTixc5he/KF7nFjqltVXsWsThqERVUmoxe5LFsq9TRY
 hrrZY27g5PMyz1vbPNy4fxeFBlldht8z4XQ9uBL6BcnxOrlg6EdY3rU7tgLzfXRo+FNu
 skZa13AXM1AgLl5QKUY4nTaLQzmg+vuMoVBkyJsZmU49qlRz9J41jZO+HSrAwme7m/sn
 T5srLbnxRrJiOD5SL2EMlZ07i4FQc6JwwJ+NuAp+Spi5UQoRpeBT2x0Rw1vm/J1IMg71
 3WYcr6vT+sqjEU/P5fkbUJ6N2QwiYl+6tvRLt6OZNz236BOV4vtoCDFZ6XHYMUgL9Zs5 Hg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvp165aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VGXHIg024942;
        Tue, 31 Jan 2023 16:58:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct566vbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:12 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VGw98p002013;
        Tue, 31 Jan 2023 16:58:11 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3nct566v9x-5;
        Tue, 31 Jan 2023 16:58:11 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V8 4/7] vfio/type1: restore locked_vm
Date:   Tue, 31 Jan 2023 08:58:06 -0800
Message-Id: <1675184289-267876-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
References: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310150
X-Proofpoint-GUID: 6-yR_AHlH9jN9bWuVeKLSEOykcfVUcba
X-Proofpoint-ORIG-GUID: 6-yR_AHlH9jN9bWuVeKLSEOykcfVUcba
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vfio container is preserved across exec or fork-exec, the new
task's mm has a locked_vm count of 0.  After a dma vaddr is updated using
VFIO_DMA_MAP_FLAG_VADDR, locked_vm remains 0, and the pinned memory does
not count against the task's RLIMIT_MEMLOCK.

To restore the correct locked_vm count, when VFIO_DMA_MAP_FLAG_VADDR is
used and the dma's mm has changed, add the dma's locked_vm count to
the new mm->locked_vm, subject to the rlimit, and subtract it from the
old mm->locked_vm.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5a08346..7fa68dc 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1591,6 +1591,38 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+static int vfio_change_dma_owner(struct vfio_dma *dma)
+{
+	struct task_struct *task = current->group_leader;
+	struct mm_struct *mm = current->mm;
+	long npage = dma->locked_vm;
+	bool lock_cap;
+	int ret;
+
+	if (mm == dma->mm)
+		return 0;
+
+	lock_cap = capable(CAP_IPC_LOCK);
+	ret = mm_lock_acct(task, mm, lock_cap, npage);
+	if (ret)
+		return ret;
+
+	if (mmget_not_zero(dma->mm)) {
+		mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage);
+		mmput(dma->mm);
+	}
+
+	if (dma->task != task) {
+		put_task_struct(dma->task);
+		dma->task = get_task_struct(task);
+	}
+	mmdrop(dma->mm);
+	dma->mm = mm;
+	mmgrab(dma->mm);
+	dma->lock_cap = lock_cap;
+	return 0;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1640,6 +1672,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
+			ret = vfio_change_dma_owner(dma);
+			if (ret)
+				goto out_unlock;
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
-- 
1.8.3.1

