Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90453644E45
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiLFV4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLFV4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDC7490B2
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:56:02 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LKZmA001115;
        Tue, 6 Dec 2022 21:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=stCKyCwe1DtKtcKmwCK5zLeFZzzZlP4ToqqVr8lulfU=;
 b=frwR586PfuW//i50WUKBoCfsZBXwLmpNxpKIchRV3Mf+2l7+KcNo+v1BwZc+1qjsNQd6
 ksolbPDNQmwTWXAunPd3tWPvN5GWcje3Oo5Z/mbd8j6TSlkEnSVxqjJj/D9rwXsMxHhk
 HpxcFIBodGwVEZxBp3NA/EJCyJvqGYU3quVTBXNnNI3Skxzpk+IUyEdON6eq186eaarf
 R6hnT/DuCFjUDOiABuqTVO+rkEseMl6UEmiklB2hjnMy/Pi4pwFYrzxTFVtn6O4Em8u0
 B8Mq4O3PBsItfFeHDG9mm8dXAa6qjVXxgVVshOATVHLd48OT9iX+IC8nRqf7Kqrbvbfv 9w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya49497-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LLBQB032611;
        Tue, 6 Dec 2022 21:55:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2mb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:58 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0x038701;
        Tue, 6 Dec 2022 21:55:58 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-9;
        Tue, 06 Dec 2022 21:55:57 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 8/8] vfio/type1: change dma owner
Date:   Tue,  6 Dec 2022 13:55:53 -0800
Message-Id: <1670363753-249738-9-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-GUID: 2pyGb0icYQlCcT--7IJ38dX3ahIRiiD3
X-Proofpoint-ORIG-GUID: 2pyGb0icYQlCcT--7IJ38dX3ahIRiiD3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement VFIO_CHANGE_DMA_OWNER in the type1 iommu.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 119 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index fbea2b5..55ba1e7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1509,6 +1509,112 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+/*
+ * Return true if mm1 vaddr1 maps the same memory object as mm2 vaddr2.
+ * This does not prevent other tasks from concurrently modifying mappings
+ * and invalidating this test, but that would be an application bug.
+ */
+static bool same_file_mapping(struct mm_struct *mm1, unsigned long vaddr1,
+			      struct mm_struct *mm2, unsigned long vaddr2)
+{
+	const unsigned long mask = VM_READ | VM_WRITE | VM_EXEC | VM_SHARED;
+	struct inode *inode1 = NULL, *inode2 = NULL;
+	unsigned long pgoff1, len1, flags1;
+	unsigned long pgoff2, len2, flags2;
+	struct vm_area_struct *vma;
+
+	mmap_read_lock(mm1);
+	vma = find_vma(mm1, vaddr1);
+	if (vma && vma->vm_file) {
+		inode1 = vma->vm_file->f_inode;
+		pgoff1 = vma->vm_pgoff;
+		len1 = vma->vm_end - vma->vm_start;
+		flags1 = vma->vm_flags & mask;
+	}
+	mmap_read_unlock(mm1);
+
+	mmap_read_lock(mm2);
+	vma = find_vma(mm2, vaddr2);
+	if (vma && vma->vm_file) {
+		inode2 = vma->vm_file->f_inode;
+		pgoff2 = vma->vm_pgoff;
+		len2 = vma->vm_end - vma->vm_start;
+		flags2 = vma->vm_flags & mask;
+	}
+	mmap_read_unlock(mm2);
+
+	if (!inode1 || (inode1 != inode2) || (pgoff1 != pgoff2) ||
+	    (len1 != len2) || (flags1 != flags2)) {
+		pr_debug("vfio vma mismatch for old va %lx vs new va %lx\n",
+			 vaddr1, vaddr2);
+		return false;
+	} else {
+		return true;
+	}
+}
+
+static int change_dma_owner(struct vfio_iommu *iommu)
+{
+	struct rb_node *p;
+	struct vfio_dma *dma;
+	unsigned long new_vaddr;
+	uint64_t npages = 0;
+	int ret = 0, new_vaddrs = 0, total = 0;
+	bool new_lock_cap = capable(CAP_IPC_LOCK);
+	struct mm_struct *old_mm, *new_mm = current->mm;
+	struct task_struct *old_task = iommu->task;
+	struct task_struct *new_task = current->group_leader;
+
+	if (!old_task)
+		return 0;	/* nothing mapped, nothing to do */
+
+	old_mm = get_task_mm(old_task);
+	if (!old_mm)
+		return -ESRCH;
+
+	for (p = rb_first(&iommu->dma_list); p; p = rb_next(p)) {
+		dma = rb_entry(p, struct vfio_dma, node);
+		npages += dma->locked_vm;
+		total++;
+		new_vaddrs += (dma->new_vaddr != 0);
+
+		new_vaddr = dma->new_vaddr ? dma->new_vaddr : dma->vaddr;
+		if (!same_file_mapping(old_mm, dma->vaddr, new_mm, new_vaddr)) {
+			ret = -ENXIO;
+			goto out;
+		}
+	}
+
+	/* If any vaddrs change, all must change */
+	if (new_vaddrs && (total - new_vaddrs)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (npages) {
+		ret = mm_lock_vm(new_task, new_mm, new_lock_cap, npages);
+		if (ret)
+			goto out;
+		/* should always succeed */
+		mm_lock_vm(old_task, old_mm, dma->lock_cap, -npages);
+	}
+
+	for (p = rb_first(&iommu->dma_list); p; p = rb_next(p)) {
+		dma = rb_entry(p, struct vfio_dma, node);
+		dma->lock_cap = new_lock_cap;
+		if (dma->new_vaddr) {
+			dma->vaddr = dma->new_vaddr;
+			dma->new_vaddr = 0;
+		}
+	}
+
+	vfio_iommu_set_task(iommu, new_task);
+
+out:
+	mmput(old_mm);
+	return ret;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -2604,6 +2710,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
+	case VFIO_DMA_OWNER:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2944,6 +3051,17 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	return -EINVAL;
 }
 
+static int vfio_iommu_type1_change_dma_owner(void *iommu_data)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	ret = change_dma_owner(iommu);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static void vfio_iommu_type1_close_dma_owner(void *iommu_data)
 {
 	struct vfio_iommu *iommu = iommu_data;
@@ -3136,6 +3254,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	.unregister_device	= vfio_iommu_type1_unregister_device,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
+	.change_dma_owner	= vfio_iommu_type1_change_dma_owner,
 	.close_dma_owner	= vfio_iommu_type1_close_dma_owner,
 };
 
-- 
1.8.3.1

