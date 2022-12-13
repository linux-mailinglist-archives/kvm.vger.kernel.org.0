Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C293064B8ED
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbiLMPtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbiLMPtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:49:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4731317E35
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 07:47:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDtThp013300;
        Tue, 13 Dec 2022 15:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=Jl8MqcUP7i6WwvUBNOvDL9IlaIBUhMbriHNYQ+2+wXE=;
 b=aIZcLKfGUCc3T9qNGqXiosWySS+aXBS8dVwfGXq1JT2Pqj7g+44dpfmkUUSX0PiBpy/C
 SfiMCvL3XxDfV2vHyUXVqpTuad6kJRyRz+mk9vKzIk1EkhtYGYiCzRP6fQG+lPbBRxGN
 xbdIcGG5kK4j9oqkZHoDhatEU8QPgO1U7G7v3hsAuYqlS5X/UaKi2dVFURFQqtJvjCXJ
 UKHItf56X8B1SuYijnUeLkprK29RSTpNsBnj5A45oIWs2xjz6ehxFJWm3y9KEXgLQpWR
 2llkQf6DVATZCQjgkeQ2s6pNFBdDE6gFqbcypoHQEUpw/2/h3MPP5CoTqxJ1GDSR0FQW Iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mchqswp3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:47:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCUVt040114;
        Tue, 13 Dec 2022 15:46:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjcg43p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:46:59 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFgwtK031631;
        Tue, 13 Dec 2022 15:46:59 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3mcgjcg40c-3;
        Tue, 13 Dec 2022 15:46:59 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 2/2] vfio/type1: prevent locked_vm underflow
Date:   Tue, 13 Dec 2022 07:46:56 -0800
Message-Id: <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130139
X-Proofpoint-ORIG-GUID: UuxHnpnxYSKfT247nRmYM7Teq6sllVRT
X-Proofpoint-GUID: UuxHnpnxYSKfT247nRmYM7Teq6sllVRT
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

To fix, when VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed,
add the mapping's pinned page count to the new mm->locked_vm, subject to
the rlimit.  Now that mediated devices are excluded when using
VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of the
mapping.

Underflow will not occur when all dma mappings are invalidated before exec.
An attempt to unmap before updating the vaddr with VFIO_DMA_MAP_FLAG_VADDR
will fail with EINVAL because the mapping is in the vaddr_invalid state.
Underflow may still occur in a buggy application that fails to invalidate
all before exec.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f81e925..e5a02f8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -1174,6 +1175,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1622,6 +1624,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
+			if (current->mm != dma->mm) {
+				mmdrop(dma->mm);
+				dma->mm = current->mm;
+				mmgrab(dma->mm);
+				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
+						     0);
+			}
 			wake_up_all(&iommu->vaddr_wait);
 		}
 		goto out_unlock;
@@ -1679,6 +1688,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = dma->task->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
-- 
1.8.3.1

