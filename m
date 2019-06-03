Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79F32DF6
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 12:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfFCKux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 06:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfFCKuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 06:50:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32CE43004425;
        Mon,  3 Jun 2019 10:50:52 +0000 (UTC)
Received: from localhost (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B80F85D71A;
        Mon,  3 Jun 2019 10:50:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 3/7] s390/cio: Split pfn_array_alloc_pin into pieces
Date:   Mon,  3 Jun 2019 12:50:34 +0200
Message-Id: <20190603105038.11788-4-cohuck@redhat.com>
In-Reply-To: <20190603105038.11788-1-cohuck@redhat.com>
References: <20190603105038.11788-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 03 Jun 2019 10:50:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The pfn_array_alloc_pin routine is doing too much.  Today, it does the
alloc of the pfn_array struct and its member arrays, builds the iova
address lists out of a contiguous piece of guest memory, and asks vfio
to pin the resulting pages.

Let's effectively revert a significant portion of commit 5c1cfb1c3948
("vfio: ccw: refactor and improve pfn_array_alloc_pin()") such that we
break pfn_array_alloc_pin() into its component pieces, and have one
routine that allocates/populates the pfn_array structs, and another
that actually pins the memory.  In the future, we will be able to
handle scenarios where pinning memory isn't actually appropriate.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190514234248.36203-4-farman@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 64 ++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 6e48b66ae31a..e33265fb80b0 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -50,28 +50,25 @@ struct ccwchain {
 };
 
 /*
- * pfn_array_alloc_pin() - alloc memory for PFNs, then pin user pages in memory
+ * pfn_array_alloc() - alloc memory for PFNs
  * @pa: pfn_array on which to perform the operation
- * @mdev: the mediated device to perform pin/unpin operations
  * @iova: target guest physical address
  * @len: number of bytes that should be pinned from @iova
  *
- * Attempt to allocate memory for PFNs, and pin user pages in memory.
+ * Attempt to allocate memory for PFNs.
  *
  * Usage of pfn_array:
  * We expect (pa_nr == 0) and (pa_iova_pfn == NULL), any field in
  * this structure will be filled in by this function.
  *
  * Returns:
- *   Number of pages pinned on success.
- *   If @pa->pa_nr is not 0, or @pa->pa_iova_pfn is not NULL initially,
- *   returns -EINVAL.
- *   If no pages were pinned, returns -errno.
+ *         0 if PFNs are allocated
+ *   -EINVAL if pa->pa_nr is not initially zero, or pa->pa_iova_pfn is not NULL
+ *   -ENOMEM if alloc failed
  */
-static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
-			       u64 iova, unsigned int len)
+static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
 {
-	int i, ret = 0;
+	int i;
 
 	if (!len)
 		return 0;
@@ -97,6 +94,22 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
 	for (i = 1; i < pa->pa_nr; i++)
 		pa->pa_iova_pfn[i] = pa->pa_iova_pfn[i - 1] + 1;
 
+	return 0;
+}
+
+/*
+ * pfn_array_pin() - Pin user pages in memory
+ * @pa: pfn_array on which to perform the operation
+ * @mdev: the mediated device to perform pin operations
+ *
+ * Returns number of pages pinned upon success.
+ * If the pin request partially succeeds, or fails completely,
+ * all pages are left unpinned and a negative error value is returned.
+ */
+static int pfn_array_pin(struct pfn_array *pa, struct device *mdev)
+{
+	int ret = 0;
+
 	ret = vfio_pin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr,
 			     IOMMU_READ | IOMMU_WRITE, pa->pa_pfn);
 
@@ -112,8 +125,6 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
 
 err_out:
 	pa->pa_nr = 0;
-	kfree(pa->pa_iova_pfn);
-	pa->pa_iova_pfn = NULL;
 
 	return ret;
 }
@@ -121,7 +132,9 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
 /* Unpin the pages before releasing the memory. */
 static void pfn_array_unpin_free(struct pfn_array *pa, struct device *mdev)
 {
-	vfio_unpin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr);
+	/* Only unpin if any pages were pinned to begin with */
+	if (pa->pa_nr)
+		vfio_unpin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr);
 	pa->pa_nr = 0;
 	kfree(pa->pa_iova_pfn);
 }
@@ -209,10 +222,16 @@ static long copy_from_iova(struct device *mdev,
 	int i, ret;
 	unsigned long l, m;
 
-	ret = pfn_array_alloc_pin(&pa, mdev, iova, n);
-	if (ret <= 0)
+	ret = pfn_array_alloc(&pa, iova, n);
+	if (ret < 0)
 		return ret;
 
+	ret = pfn_array_pin(&pa, mdev);
+	if (ret < 0) {
+		pfn_array_unpin_free(&pa, mdev);
+		return ret;
+	}
+
 	l = n;
 	for (i = 0; i < pa.pa_nr; i++) {
 		from = pa.pa_pfn[i] << PAGE_SHIFT;
@@ -560,7 +579,11 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ret)
 		goto out_init;
 
-	ret = pfn_array_alloc_pin(pat->pat_pa, cp->mdev, ccw->cda, ccw->count);
+	ret = pfn_array_alloc(pat->pat_pa, ccw->cda, ccw->count);
+	if (ret < 0)
+		goto out_unpin;
+
+	ret = pfn_array_pin(pat->pat_pa, cp->mdev);
 	if (ret < 0)
 		goto out_unpin;
 
@@ -590,6 +613,7 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 {
 	struct ccw1 *ccw;
 	struct pfn_array_table *pat;
+	struct pfn_array *pa;
 	unsigned long *idaws;
 	u64 idaw_iova;
 	unsigned int idaw_nr, idaw_len;
@@ -628,9 +652,13 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 
 	for (i = 0; i < idaw_nr; i++) {
 		idaw_iova = *(idaws + i);
+		pa = pat->pat_pa + i;
+
+		ret = pfn_array_alloc(pa, idaw_iova, 1);
+		if (ret < 0)
+			goto out_free_idaws;
 
-		ret = pfn_array_alloc_pin(pat->pat_pa + i, cp->mdev,
-					  idaw_iova, 1);
+		ret = pfn_array_pin(pa, cp->mdev);
 		if (ret < 0)
 			goto out_free_idaws;
 	}
-- 
2.20.1

