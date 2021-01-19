Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A32FBEBA
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392526AbhASSRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:17:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392468AbhASSQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIA07S129787;
        Tue, 19 Jan 2021 18:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dDpXfadblilGc5EqleAg7mSmfHiRvtcqtezY1uBfnJo=;
 b=iR3UyyPXOLi2/KFOGClWWxuw2vAWzSe+5f37jkmVn6uNRHzKN4+nftb+CpIXGFkv8hac
 qSgbATnfpu/yLQMZ/kCaqR5mabTSfp5Daes2z96J+w4gececRn/pJuUVHgBCpm7oAtLq
 7/rkWdoFN33eudB+0l/qtSHJopwhkmWTA99u04g22Ml98Rlk11rrrUOv1CO0nULTaso5
 /x5JGosA+5cm5PM6Mn5Pd7t0/cdkyP2ALB5St/2SPJmOhtljGw0307kq0WsTLNj8nUmd
 s+ODmhLa9sWuGibDDv0b774/o5miBOlatLVTkLs0SNicj37CTRn7AVZq0pS8bf+jhBcu wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 363xyhsrrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JI9i50126571;
        Tue, 19 Jan 2021 18:16:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3661er45fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10JIG5HZ013262;
        Tue, 19 Jan 2021 18:16:05 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:03 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 9/9] vfio/type1: block on invalid vaddr
Date:   Tue, 19 Jan 2021 09:48:29 -0800
Message-Id: <1611078509-181959-10-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Block translation of host virtual address while an iova range has an
invalid vaddr.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 83 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0167996..c97573a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -31,6 +31,7 @@
 #include <linux/rbtree.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
+#include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
@@ -75,6 +76,7 @@ struct vfio_iommu {
 	bool			dirty_page_tracking;
 	bool			pinned_page_dirty_scope;
 	bool			controlled;
+	wait_queue_head_t	vaddr_wait;
 };
 
 struct vfio_domain {
@@ -145,6 +147,8 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
+#define WAITED 1
+
 static int put_pfn(unsigned long pfn, int prot);
 
 static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
@@ -505,6 +509,52 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 }
 
 /*
+ * Wait for vaddr of *dma_p to become valid.  iommu lock is dropped if the task
+ * waits, but is re-locked on return.  If the task waits, then return an updated
+ * dma struct in *dma_p.  Return 0 on success with no waiting, 1 on success if
+ * waited, and -errno on error.
+ */
+static int vfio_vaddr_wait(struct vfio_iommu *iommu, struct vfio_dma **dma_p)
+{
+	struct vfio_dma *dma = *dma_p;
+	unsigned long iova = dma->iova;
+	size_t size = dma->size;
+	int ret = 0;
+	DEFINE_WAIT(wait);
+
+	while (!dma->vaddr_valid) {
+		ret = WAITED;
+		prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
+		mutex_unlock(&iommu->lock);
+		schedule();
+		mutex_lock(&iommu->lock);
+		finish_wait(&iommu->vaddr_wait, &wait);
+		if (kthread_should_stop() || !iommu->controlled ||
+		    fatal_signal_pending(current)) {
+			return -EFAULT;
+		}
+		*dma_p = dma = vfio_find_dma(iommu, iova, size);
+		if (!dma)
+			return -EINVAL;
+	}
+	return ret;
+}
+
+/*
+ * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
+ * if the task waits, but is re-locked on return.  Return result in *dma_p.
+ * Return 0 on success, 1 on success if waited,  and -errno on error.
+ */
+static int vfio_find_vaddr(struct vfio_iommu *iommu, dma_addr_t start,
+			   size_t size, struct vfio_dma **dma_p)
+{
+	*dma_p = vfio_find_dma(iommu, start, size);
+	if (!*dma_p)
+		return -EINVAL;
+	return vfio_vaddr_wait(iommu, dma_p);
+}
+
+/*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
  * first page and all consecutive pages with the same locking.
@@ -693,11 +743,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		struct vfio_pfn *vpfn;
 
 		iova = user_pfn[i] << PAGE_SHIFT;
-		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
-		if (!dma) {
-			ret = -EINVAL;
+		ret = vfio_find_vaddr(iommu, iova, PAGE_SIZE, &dma);
+		if (ret < 0)
 			goto pin_unwind;
-		}
+		else if (ret == WAITED)
+			do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
 
 		if ((dma->prot & prot) != prot) {
 			ret = -EPERM;
@@ -1496,6 +1546,22 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
+	/*
+	 * Wait for all vaddr to be valid so they can be used in the main loop.
+	 * If we do wait, the lock was dropped and re-taken, so start over to
+	 * ensure the dma list is consistent.
+	 */
+again:
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		ret = vfio_vaddr_wait(iommu, &dma);
+		if (ret < 0)
+			return ret;
+		else if (ret == WAITED)
+			goto again;
+	}
+
 	/* Arbitrarily pick the first domain in the list for lookups */
 	if (!list_empty(&iommu->domain_list))
 		d = list_first_entry(&iommu->domain_list,
@@ -2522,6 +2588,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	iommu->controlled = true;
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
+	init_waitqueue_head(&iommu->vaddr_wait);
 
 	return iommu;
 }
@@ -2972,12 +3039,13 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	bool kthread = current->mm == NULL;
 	size_t offset;
+	int ret;
 
 	*copied = 0;
 
-	dma = vfio_find_dma(iommu, user_iova, 1);
-	if (!dma)
-		return -EINVAL;
+	ret = vfio_find_vaddr(iommu, user_iova, 1, &dma);
+	if (ret < 0)
+		return ret;
 
 	if ((write && !(dma->prot & IOMMU_WRITE)) ||
 			!(dma->prot & IOMMU_READ))
@@ -3055,6 +3123,7 @@ static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
 	mutex_lock(&iommu->lock);
 	iommu->controlled = false;
 	mutex_unlock(&iommu->lock);
+	wake_up_all(&iommu->vaddr_wait);
 }
 
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
-- 
1.8.3.1

