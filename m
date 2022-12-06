Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5452B644E3F
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLFV4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLFV4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B14490AC
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:55:59 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LKm1r003004;
        Tue, 6 Dec 2022 21:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=A2w30btZe93yB+ql/SDbdcTlM4I+kzIV+kUkmd5gBgE=;
 b=iqSC9s1dp8yi+Q7IN26TceQIxBjWxCgSBOUyyEbPHmzpWLFKdnxqSPuXpotwoDlB8a2b
 ti5nt/JwkXcppnh5FSIAXmBzObpqZkLRWvTPQuAtjsa8jmGb42AcIupk8aLaoZ/xQ6Bj
 UhA1qWgbAQJIIWQxUVTkgx95CMHXpNhjyZjFgXUUacicmT2d47FUcK1Ufj0bCMwWyWpN
 Ig7FElF6D85VUadZ1wf/5zaREejV2nhX7jh9r3r0AKT2hWv0cabvdYfGKOf02Emfcdb/
 3wPFKqXD5U4ZX6OncznSBG4Ioc3xrTdNGeQZoSM3nDyC2PzNfBBLE8Mbu1Eh3W/D6HSl dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ydjhbfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LDtiu032868;
        Tue, 6 Dec 2022 21:55:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2m9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:55 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0j038701;
        Tue, 6 Dec 2022 21:55:55 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-2;
        Tue, 06 Dec 2022 21:55:54 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Date:   Tue,  6 Dec 2022 13:55:46 -0800
Message-Id: <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-ORIG-GUID: zMdyQbEvqTmYkpr6ab_ALdYbHVSnBFXT
X-Proofpoint-GUID: zMdyQbEvqTmYkpr6ab_ALdYbHVSnBFXT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete the interfaces that allow an iova range to be re-mapped in a new
address space.  They allow userland to indefinitely block vfio mediated
device kernel threads, and do not propagate the locked_vm count to a
new mm.

  - disable the VFIO_UPDATE_VADDR extension
  - delete VFIO_DMA_UNMAP_FLAG_VADDR
  - delete most of VFIO_DMA_MAP_FLAG_VADDR (but keep some for use in a
    new implementation in a subsequent patch).

Revert most of the code of these commits:

  441e810 ("vfio: interfaces to update vaddr")
  c3cbab2 ("vfio/type1: implement interfaces to update vaddr")
  898b9ea ("vfio/type1: block on invalid vaddr")

Revert these commits.  They are harmless, but no longer used after the
above are reverted, and this kind of functionality is better handled by
adding new methods to vfio_iommu_driver_ops.

  ec5e329 ("vfio: iommu driver notify callback")
  487ace1 ("vfio/type1: implement notify callback")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/container.c        |   5 --
 drivers/vfio/vfio.h             |   7 --
 drivers/vfio/vfio_iommu_type1.c | 144 ++--------------------------------------
 include/uapi/linux/vfio.h       |  17 +----
 4 files changed, 8 insertions(+), 165 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index d74164a..5bfd10d 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -382,11 +382,6 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 static int vfio_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver = container->iommu_driver;
-
-	if (driver && driver->ops->notify)
-		driver->ops->notify(container->iommu_data,
-				    VFIO_IOMMU_CONTAINER_CLOSE);
 
 	filep->private_data = NULL;
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index bcad54b..8a439c6 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -62,11 +62,6 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 };
 
-/* events for the backend driver notify callback */
-enum vfio_iommu_notify_type {
-	VFIO_IOMMU_CONTAINER_CLOSE = 0,
-};
-
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
  */
@@ -97,8 +92,6 @@ struct vfio_iommu_driver_ops {
 				  void *data, size_t count, bool write);
 	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
 						   struct iommu_group *group);
-	void		(*notify)(void *iommu_data,
-				  enum vfio_iommu_notify_type event);
 };
 
 struct vfio_iommu_driver {
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..02c6ea3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -69,14 +69,11 @@ struct vfio_iommu {
 	struct list_head	device_list;
 	struct mutex		device_list_lock;
 	unsigned int		dma_avail;
-	unsigned int		vaddr_invalid_count;
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
-	wait_queue_head_t	vaddr_wait;
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			container_open;
 	struct list_head	emulated_iommu_groups;
 };
 
@@ -96,7 +93,6 @@ struct vfio_dma {
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
-	bool			vaddr_invalid;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -152,8 +148,6 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
-#define WAITED 1
-
 static int put_pfn(unsigned long pfn, int prot);
 
 static struct vfio_iommu_group*
@@ -595,60 +589,6 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
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
 
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
@@ -861,22 +801,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
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
@@ -1175,10 +1099,6 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
 	vfio_dma_bitmap_free(dma);
-	if (dma->vaddr_invalid) {
-		iommu->vaddr_invalid_count--;
-		wake_up_all(&iommu->vaddr_wait);
-	}
 	kfree(dma);
 	iommu->dma_avail++;
 }
@@ -1338,8 +1258,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	dma_addr_t iova = unmap->iova;
 	u64 size = unmap->size;
 	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
-	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
-	struct rb_node *n, *first_n;
+	struct rb_node *n;
 
 	mutex_lock(&iommu->lock);
 
@@ -1408,7 +1327,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 	ret = 0;
-	n = first_n = vfio_find_dma_first_node(iommu, iova, size);
+	n = vfio_find_dma_first_node(iommu, iova, size);
 
 	while (n) {
 		dma = rb_entry(n, struct vfio_dma, node);
@@ -1418,27 +1337,6 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (!iommu->v2 && iova > dma->iova)
 			break;
 
-		if (invalidate_vaddr) {
-			if (dma->vaddr_invalid) {
-				struct rb_node *last_n = n;
-
-				for (n = first_n; n != last_n; n = rb_next(n)) {
-					dma = rb_entry(n,
-						       struct vfio_dma, node);
-					dma->vaddr_invalid = false;
-					iommu->vaddr_invalid_count--;
-				}
-				ret = -EINVAL;
-				unmapped = 0;
-				break;
-			}
-			dma->vaddr_invalid = true;
-			iommu->vaddr_invalid_count++;
-			unmapped += dma->size;
-			n = rb_next(n);
-			continue;
-		}
-
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			if (dma_last == dma) {
 				BUG_ON(++retries > 10);
@@ -1611,14 +1509,10 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (set_vaddr) {
 		if (!dma) {
 			ret = -ENOENT;
-		} else if (!dma->vaddr_invalid || dma->iova != iova ||
-			   dma->size != size) {
+		} else if (dma->iova != iova || dma->size != size) {
 			ret = -EINVAL;
 		} else {
 			dma->vaddr = vaddr;
-			dma->vaddr_invalid = false;
-			iommu->vaddr_invalid_count--;
-			wake_up_all(&iommu->vaddr_wait);
 		}
 		goto out_unlock;
 	} else if (dma) {
@@ -1707,10 +1601,6 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
-	ret = vfio_wait_all_valid(iommu);
-	if (ret < 0)
-		return ret;
-
 	/* Arbitrarily pick the first domain in the list for lookups */
 	if (!list_empty(&iommu->domain_list))
 		d = list_first_entry(&iommu->domain_list,
@@ -2592,11 +2482,9 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
-	iommu->container_open = true;
 	mutex_init(&iommu->lock);
 	mutex_init(&iommu->device_list_lock);
 	INIT_LIST_HEAD(&iommu->device_list);
-	init_waitqueue_head(&iommu->vaddr_wait);
 	iommu->pgsize_bitmap = PAGE_MASK;
 	INIT_LIST_HEAD(&iommu->emulated_iommu_groups);
 
@@ -2668,7 +2556,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
-	case VFIO_UPDATE_VADDR:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2860,7 +2747,6 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dma_unmap unmap;
 	struct vfio_bitmap bitmap = { 0 };
 	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
-			VFIO_DMA_UNMAP_FLAG_VADDR |
 			VFIO_DMA_UNMAP_FLAG_ALL;
 	unsigned long minsz;
 	int ret;
@@ -2874,8 +2760,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 		return -EINVAL;
 
 	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
-	    (unmap.flags & (VFIO_DMA_UNMAP_FLAG_ALL |
-			    VFIO_DMA_UNMAP_FLAG_VADDR)))
+	    (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL))
 		return -EINVAL;
 
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
@@ -3078,13 +2963,12 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
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
@@ -3176,19 +3060,6 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	return domain;
 }
 
-static void vfio_iommu_type1_notify(void *iommu_data,
-				    enum vfio_iommu_notify_type event)
-{
-	struct vfio_iommu *iommu = iommu_data;
-
-	if (event != VFIO_IOMMU_CONTAINER_CLOSE)
-		return;
-	mutex_lock(&iommu->lock);
-	iommu->container_open = false;
-	mutex_unlock(&iommu->lock);
-	wake_up_all(&iommu->vaddr_wait);
-}
-
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -3203,7 +3074,6 @@ static void vfio_iommu_type1_notify(void *iommu_data,
 	.unregister_device	= vfio_iommu_type1_unregister_device,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
-	.notify			= vfio_iommu_type1_notify,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d7d8e09..5c5cc7e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -49,7 +49,7 @@
 /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
 #define VFIO_UNMAP_ALL			9
 
-/* Supports the vaddr flag for DMA map and unmap */
+/* Obsolete, not supported by any IOMMU. */
 #define VFIO_UPDATE_VADDR		10
 
 /*
@@ -1214,15 +1214,6 @@ struct vfio_iommu_type1_info_dma_avail {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
- *
- * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
- * unblock translation of host virtual addresses in the iova range.  The vaddr
- * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
- * maintain memory consistency within the user application, the updated vaddr
- * must address the same memory object as originally mapped.  Failure to do so
- * will result in user memory corruption and/or device misbehavior.  iova and
- * size must match those in the original MAP_DMA call.  Protection is not
- * changed, and the READ & WRITE flags must be 0.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
@@ -1265,18 +1256,12 @@ struct vfio_bitmap {
  *
  * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
  * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
- *
- * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
- * virtual addresses in the iova range.  Tasks that attempt to translate an
- * iova's vaddr will block.  DMA to already-mapped pages continues.  This
- * cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
 #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
-#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
-- 
1.8.3.1

