Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55421E5B6
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfENXnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 19:43:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726677AbfENXm6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 19:42:58 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ENLtDH042043
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:57 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sg4n9xa9v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:56 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 00:42:55 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 00:42:53 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4ENgpuJ39059610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 23:42:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E6ED11C054;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 768C911C04C;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 31B09E13D1; Wed, 15 May 2019 01:42:51 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 3/7] s390/cio: Split pfn_array_alloc_pin into pieces
Date:   Wed, 15 May 2019 01:42:44 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190514234248.36203-1-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051423-0012-0000-0000-0000031BB7C2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051423-0013-0000-0000-000021545247
Message-Id: <20190514234248.36203-4-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=720 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 drivers/s390/cio/vfio_ccw_cp.c | 64 ++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 41f48b8790bc..60aa784717c5 100644
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
@@ -559,7 +578,11 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
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
 
@@ -589,6 +612,7 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 {
 	struct ccw1 *ccw;
 	struct pfn_array_table *pat;
+	struct pfn_array *pa;
 	unsigned long *idaws;
 	u64 idaw_iova;
 	unsigned int idaw_nr, idaw_len;
@@ -627,9 +651,13 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 
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
2.17.1

