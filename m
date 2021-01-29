Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7A308B7C
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhA2RZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:25:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40734 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhA2RZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:25:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THOPwH066354;
        Fri, 29 Jan 2021 17:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Ka5ZCXx5I/uk3Qq7i3dHrxez7cn1/8uN1lmZX1hzWVc=;
 b=klHWr38S55RULHVRN9v3SvpnvFVgLpN/63ALL0rsFVee61KQl1uWScNsM2hwVYtWEanz
 BGC3lENAPy3FlyAGWu3YIlyfA6KnsP3C0FbO3u5mxKUY3lu0ghD+iZnIokmw6dIy/Lr3
 0BhRNEHQuQuuroR2d/J8qWnYIF0Yf0EpK0qB9AjL/m0nR3+yXrYQhXa6d/kBjOUZIRFl
 vGBjyeW1khcEIFuY6Bo0n604xN6ocqARPcYKh2MVvuENk2esjeKhSaQfbrFQZS9z37+Z
 udiXtFJ/OURpq+0osh/JLwpTe4aghhIvVKrC7PFXItaZJ1122YoeKYV+LnpbEt7jgYTd 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7rafby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:24:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH6J2u192602;
        Fri, 29 Jan 2021 17:22:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 368wr26wsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:23 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10THMMOQ002814;
        Fri, 29 Jan 2021 17:22:22 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:22 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 9/9] vfio/type1: block on invalid vaddr
Date:   Fri, 29 Jan 2021 08:54:12 -0800
Message-Id: <1611939252-7240-10-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Block translation of host virtual address while an iova range has an
invalid vaddr.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 95 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 90 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b74a5f3..e3fc450 100644
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
@@ -76,6 +77,7 @@ struct vfio_iommu {
 	bool			pinned_page_dirty_scope;
 	bool			container_open;
 	int			vaddr_invalid_count;
+	wait_queue_head_t	vaddr_wait;
 };
 
 struct vfio_domain {
@@ -146,6 +148,8 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
+#define WAITED 1
+
 static int put_pfn(unsigned long pfn, int prot);
 
 static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
@@ -507,6 +511,61 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
+static int vfio_wait(struct vfio_iommu *iommu)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
+	mutex_unlock(&iommu->lock);
+	schedule();
+	mutex_lock(&iommu->lock);
+	finish_wait(&iommu->vaddr_wait, &wait);
+	if (kthread_should_stop() || !iommu->container_open ||
+	    fatal_signal_pending(current)) {
+		return -EFAULT;
+	}
+	return WAITED;
+}
+
+/*
+ * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
+ * if the task waits, but is re-locked on return.  Return result in *dma_p.
+ * Return 0 on success with no waiting, WAITED on success if waited, and -errno
+ * on error.
+ */
+static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
+			       size_t size, struct vfio_dma **dma_p)
+{
+	int ret;
+
+	do {
+		*dma_p = vfio_find_dma(iommu, start, size);
+		if (!*dma_p)
+			ret = -EINVAL;
+		else if (!(*dma_p)->vaddr_invalid)
+			ret = 0;
+		else
+			ret = vfio_wait(iommu);
+	} while (ret > 0);
+
+	return ret;
+}
+
+/*
+ * Wait for all vaddr in the dma_list to become valid.  iommu lock is dropped
+ * if the task waits, but is re-locked on return.  Return 0 on success with no
+ * waiting, WAITED on success if waited, and -errno on error.
+ */
+static int vfio_wait_all_valid(struct vfio_iommu *iommu)
+{
+	int ret = 0;
+
+	while (iommu->vaddr_invalid_count && ret >= 0)
+		ret = vfio_wait(iommu);
+
+	return ret;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -668,6 +727,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
+	dma_addr_t iova;
 
 	if (!iommu || !user_pfn || !phys_pfn)
 		return -EINVAL;
@@ -678,6 +738,22 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
+	/*
+	 * Wait for all necessary vaddr's to be valid so they can be used in
+	 * the main loop without dropping the lock, to avoid racing vs unmap.
+	 */
+again:
+	if (iommu->vaddr_invalid_count) {
+		for (i = 0; i < npage; i++) {
+			iova = user_pfn[i] << PAGE_SHIFT;
+			ret = vfio_find_dma_valid(iommu, iova, PAGE_SIZE, &dma);
+			if (ret < 0)
+				goto pin_done;
+			if (ret == WAITED)
+				goto again;
+		}
+	}
+
 	/* Fail if notifier list is empty */
 	if (!iommu->notifier.head) {
 		ret = -EINVAL;
@@ -692,7 +768,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
 
 	for (i = 0; i < npage; i++) {
-		dma_addr_t iova;
 		struct vfio_pfn *vpfn;
 
 		iova = user_pfn[i] << PAGE_SHIFT;
@@ -976,8 +1051,10 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
 	vfio_dma_bitmap_free(dma);
-	if (dma->vaddr_invalid)
+	if (dma->vaddr_invalid) {
 		--iommu->vaddr_invalid_count;
+		wake_up_all(&iommu->vaddr_wait);
+	}
 	kfree(dma);
 	iommu->dma_avail++;
 }
@@ -1406,6 +1483,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			--iommu->vaddr_invalid_count;
+			wake_up_all(&iommu->vaddr_wait);
 		}
 		goto out_unlock;
 	} else if (dma) {
@@ -1506,6 +1584,10 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
+	ret = vfio_wait_all_valid(iommu);
+	if (ret < 0)
+		return ret;
+
 	/* Arbitrarily pick the first domain in the list for lookups */
 	if (!list_empty(&iommu->domain_list))
 		d = list_first_entry(&iommu->domain_list,
@@ -2533,6 +2615,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	iommu->container_open = true;
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
+	init_waitqueue_head(&iommu->vaddr_wait);
 
 	return iommu;
 }
@@ -2984,12 +3067,13 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	bool kthread = current->mm == NULL;
 	size_t offset;
+	int ret;
 
 	*copied = 0;
 
-	dma = vfio_find_dma(iommu, user_iova, 1);
-	if (!dma)
-		return -EINVAL;
+	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
+	if (ret < 0)
+		return ret;
 
 	if ((write && !(dma->prot & IOMMU_WRITE)) ||
 			!(dma->prot & IOMMU_READ))
@@ -3067,6 +3151,7 @@ static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
 	mutex_lock(&iommu->lock);
 	iommu->container_open = false;
 	mutex_unlock(&iommu->lock);
+	wake_up_all(&iommu->vaddr_wait);
 }
 
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
-- 
1.8.3.1

