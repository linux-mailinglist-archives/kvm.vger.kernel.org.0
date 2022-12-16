Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192A664F141
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 19:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiLPSvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 13:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiLPSux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 13:50:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23E41FCED
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:50:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGGhUV0020047;
        Fri, 16 Dec 2022 18:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=8PHEbKgj1tHU3TIqmf+6KMlAmCE2QHG0IvmpgzB5Wec=;
 b=oWuxiY3LfjHrE49TwQlnctZWKyRC6or8640i2IoBVQqcOQqLdBDAaJSkpGv0LTQbedc6
 iknhKuth6ox7TZETZVbk+j0zkml0ig62LR+7hWhOy6x4xS23jW+c3DMlMZnm71F8WMkp
 ssMSWjaRbjjY3qscHtN4W5n+Yfne27rCNqYiPa0GGfpeSsPA4xjHsgPBN8V3M5UxPOv5
 /l5rtSJ9Q2netL9fBaOd0YoV8Usxyv1RulGD8yM6eepf9GadO407LzKPAOLvkXeq6F4z
 LT+IbZ7fvQkkGy5LSt8KIX9qkMy3lYB2BFPCLY/wbol14JCyu27z86lLnAd3JXR/acyy Uw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeug6m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGH93IO027701;
        Fri, 16 Dec 2022 18:50:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesnv5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:43 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BGIofeQ032502;
        Fri, 16 Dec 2022 18:50:43 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyesnv2x-6;
        Fri, 16 Dec 2022 18:50:43 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V6 5/7] vfio/type1: revert "block on invalid vaddr"
Date:   Fri, 16 Dec 2022 10:50:38 -0800
Message-Id: <1671216640-157935-6-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-ORIG-GUID: SlhzuIzOE_3xm6SCKvCh29JK5uBe7FmZ
X-Proofpoint-GUID: SlhzuIzOE_3xm6SCKvCh29JK5uBe7FmZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert this dead code:
  commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 94 +++--------------------------------------
 1 file changed, 5 insertions(+), 89 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4e79bce..2471f87 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,7 +72,6 @@ struct vfio_iommu {
 	unsigned int		vaddr_invalid_count;
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
-	wait_queue_head_t	vaddr_wait;
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
@@ -154,8 +153,6 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
-#define WAITED 1
-
 static int put_pfn(unsigned long pfn, int prot);
 
 static struct vfio_iommu_group*
@@ -606,61 +603,6 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
-static int vfio_wait(struct vfio_iommu *iommu)
-{
-	DEFINE_WAIT(wait);
-
-	prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
-	mutex_unlock(&iommu->lock);
-	schedule();
-	mutex_lock(&iommu->lock);
-	finish_wait(&iommu->vaddr_wait, &wait);
-	if (kthread_should_stop() || !iommu->container_open ||
-	    fatal_signal_pending(current)) {
-		return -EFAULT;
-	}
-	return WAITED;
-}
-
-/*
- * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
- * if the task waits, but is re-locked on return.  Return result in *dma_p.
- * Return 0 on success with no waiting, WAITED on success if waited, and -errno
- * on error.
- */
-static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
-			       size_t size, struct vfio_dma **dma_p)
-{
-	int ret = 0;
-
-	do {
-		*dma_p = vfio_find_dma(iommu, start, size);
-		if (!*dma_p)
-			return -EINVAL;
-		else if (!(*dma_p)->vaddr_invalid)
-			return ret;
-		else
-			ret = vfio_wait(iommu);
-	} while (ret == WAITED);
-
-	return ret;
-}
-
-/*
- * Wait for all vaddr in the dma_list to become valid.  iommu lock is dropped
- * if the task waits, but is re-locked on return.  Return 0 on success with no
- * waiting, WAITED on success if waited, and -errno on error.
- */
-static int vfio_wait_all_valid(struct vfio_iommu *iommu)
-{
-	int ret = 0;
-
-	while (iommu->vaddr_invalid_count && ret >= 0)
-		ret = vfio_wait(iommu);
-
-	return ret;
-}
-
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -861,7 +803,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
-	dma_addr_t iova;
 
 	if (!iommu || !pages)
 		return -EINVAL;
@@ -878,22 +819,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		goto pin_done;
 	}
 
-	/*
-	 * Wait for all necessary vaddr's to be valid so they can be used in
-	 * the main loop without dropping the lock, to avoid racing vs unmap.
-	 */
-again:
-	if (iommu->vaddr_invalid_count) {
-		for (i = 0; i < npage; i++) {
-			iova = user_iova + PAGE_SIZE * i;
-			ret = vfio_find_dma_valid(iommu, iova, PAGE_SIZE, &dma);
-			if (ret < 0)
-				goto pin_done;
-			if (ret == WAITED)
-				goto again;
-		}
-	}
-
 	/* Fail if no dma_umap notifier is registered */
 	if (list_empty(&iommu->device_list)) {
 		ret = -EINVAL;
@@ -909,6 +834,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 	for (i = 0; i < npage; i++) {
 		unsigned long phys_pfn;
+		dma_addr_t iova;
 		struct vfio_pfn *vpfn;
 
 		iova = user_iova + PAGE_SIZE * i;
@@ -1193,10 +1119,8 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	put_task_struct(dma->task);
 	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
-	if (dma->vaddr_invalid) {
+	if (dma->vaddr_invalid)
 		iommu->vaddr_invalid_count--;
-		wake_up_all(&iommu->vaddr_wait);
-	}
 	kfree(dma);
 	iommu->dma_avail++;
 }
@@ -1674,7 +1598,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
-			wake_up_all(&iommu->vaddr_wait);
 		}
 		goto out_unlock;
 	} else if (dma) {
@@ -1757,10 +1680,6 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
-	ret = vfio_wait_all_valid(iommu);
-	if (ret < 0)
-		return ret;
-
 	/* Arbitrarily pick the first domain in the list for lookups */
 	if (!list_empty(&iommu->domain_list))
 		d = list_first_entry(&iommu->domain_list,
@@ -2651,7 +2570,6 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	mutex_init(&iommu->lock);
 	mutex_init(&iommu->device_list_lock);
 	INIT_LIST_HEAD(&iommu->device_list);
-	init_waitqueue_head(&iommu->vaddr_wait);
 	iommu->pgsize_bitmap = PAGE_MASK;
 	INIT_LIST_HEAD(&iommu->emulated_iommu_groups);
 
@@ -3148,13 +3066,12 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	bool kthread = current->mm == NULL;
 	size_t offset;
-	int ret;
 
 	*copied = 0;
 
-	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
-	if (ret < 0)
-		return ret;
+	dma = vfio_find_dma(iommu, user_iova, 1);
+	if (!dma)
+		return -EINVAL;
 
 	if ((write && !(dma->prot & IOMMU_WRITE)) ||
 			!(dma->prot & IOMMU_READ))
@@ -3263,7 +3180,6 @@ static void vfio_iommu_type1_notify(void *iommu_data,
 	mutex_lock(&iommu->lock);
 	iommu->container_open = false;
 	mutex_unlock(&iommu->lock);
-	wake_up_all(&iommu->vaddr_wait);
 }
 
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
-- 
1.8.3.1

