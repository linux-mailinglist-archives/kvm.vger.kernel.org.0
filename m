Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002304EABF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFUOeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfFUOeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CA572F8BC7;
        Fri, 21 Jun 2019 14:34:20 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC06760920;
        Fri, 21 Jun 2019 14:34:19 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 09/14] s390/cio: Combine direct and indirect CCW paths
Date:   Fri, 21 Jun 2019 16:33:50 +0200
Message-Id: <20190621143355.29175-10-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 21 Jun 2019 14:34:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

With both the direct-addressed and indirect-addressed CCW paths
simplified to this point, the amount of shared code between them is
(hopefully) more easily visible.  Move the processing of IDA-specific
bits into the direct-addressed path, and add some useful commentary of
what the individual pieces are doing.  This allows us to remove the
entire ccwchain_fetch_idal() routine and maintain a single function
for any non-TIC CCW.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190606202831.44135-10-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 115 +++++++++++----------------------
 1 file changed, 39 insertions(+), 76 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 8205d0b527fc..90d86e1354c1 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -534,10 +534,12 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 {
 	struct ccw1 *ccw;
 	struct pfn_array *pa;
+	u64 iova;
 	unsigned long *idaws;
 	int ret;
 	int bytes = 1;
-	int idaw_nr;
+	int idaw_nr, idal_len;
+	int i;
 
 	ccw = chain->ch_ccw + idx;
 
@@ -545,7 +547,17 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 		bytes = ccw->count;
 
 	/* Calculate size of IDAL */
-	idaw_nr = idal_nr_words((void *)(u64)ccw->cda, bytes);
+	if (ccw_is_idal(ccw)) {
+		/* Read first IDAW to see if it's 4K-aligned or not. */
+		/* All subsequent IDAws will be 4K-aligned. */
+		ret = copy_from_iova(cp->mdev, &iova, ccw->cda, sizeof(iova));
+		if (ret)
+			return ret;
+	} else {
+		iova = ccw->cda;
+	}
+	idaw_nr = idal_nr_words((void *)iova, bytes);
+	idal_len = idaw_nr * sizeof(*idaws);
 
 	/* Allocate an IDAL from host storage */
 	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
@@ -555,15 +567,36 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	}
 
 	/*
-	 * Pin data page(s) in memory.
-	 * The number of pages actually is the count of the idaws which will be
-	 * needed when translating a direct ccw to a idal ccw.
+	 * Allocate an array of pfn's for pages to pin/translate.
+	 * The number of pages is actually the count of the idaws
+	 * required for the data transfer, since we only only support
+	 * 4K IDAWs today.
 	 */
 	pa = chain->ch_pa + idx;
-	ret = pfn_array_alloc(pa, ccw->cda, bytes);
+	ret = pfn_array_alloc(pa, iova, bytes);
 	if (ret < 0)
 		goto out_free_idaws;
 
+	if (ccw_is_idal(ccw)) {
+		/* Copy guest IDAL into host IDAL */
+		ret = copy_from_iova(cp->mdev, idaws, ccw->cda, idal_len);
+		if (ret)
+			goto out_unpin;
+
+		/*
+		 * Copy guest IDAWs into pfn_array, in case the memory they
+		 * occupy is not contiguous.
+		 */
+		for (i = 0; i < idaw_nr; i++)
+			pa->pa_iova_pfn[i] = idaws[i] >> PAGE_SHIFT;
+	} else {
+		/*
+		 * No action is required here; the iova addresses in pfn_array
+		 * were initialized sequentially in pfn_array_alloc() beginning
+		 * with the contents of ccw->cda.
+		 */
+	}
+
 	if (ccw_does_data_transfer(ccw)) {
 		ret = pfn_array_pin(pa, cp->mdev);
 		if (ret < 0)
@@ -589,73 +622,6 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	return ret;
 }
 
-static int ccwchain_fetch_idal(struct ccwchain *chain,
-			       int idx,
-			       struct channel_program *cp)
-{
-	struct ccw1 *ccw;
-	struct pfn_array *pa;
-	unsigned long *idaws;
-	u64 idaw_iova;
-	unsigned int idaw_nr, idaw_len;
-	int i, ret;
-	int bytes = 1;
-
-	ccw = chain->ch_ccw + idx;
-
-	if (ccw->count)
-		bytes = ccw->count;
-
-	/* Calculate size of idaws. */
-	ret = copy_from_iova(cp->mdev, &idaw_iova, ccw->cda, sizeof(idaw_iova));
-	if (ret)
-		return ret;
-	idaw_nr = idal_nr_words((void *)(idaw_iova), bytes);
-	idaw_len = idaw_nr * sizeof(*idaws);
-
-	/* Pin data page(s) in memory. */
-	pa = chain->ch_pa + idx;
-	ret = pfn_array_alloc(pa, idaw_iova, bytes);
-	if (ret)
-		goto out_init;
-
-	/* Translate idal ccw to use new allocated idaws. */
-	idaws = kzalloc(idaw_len, GFP_DMA | GFP_KERNEL);
-	if (!idaws) {
-		ret = -ENOMEM;
-		goto out_unpin;
-	}
-
-	ret = copy_from_iova(cp->mdev, idaws, ccw->cda, idaw_len);
-	if (ret)
-		goto out_free_idaws;
-
-	ccw->cda = virt_to_phys(idaws);
-
-	for (i = 0; i < idaw_nr; i++)
-		pa->pa_iova_pfn[i] = idaws[i] >> PAGE_SHIFT;
-
-	if (ccw_does_data_transfer(ccw)) {
-		ret = pfn_array_pin(pa, cp->mdev);
-		if (ret < 0)
-			goto out_free_idaws;
-	} else {
-		pa->pa_nr = 0;
-	}
-
-	pfn_array_idal_create_words(pa, idaws);
-
-	return 0;
-
-out_free_idaws:
-	kfree(idaws);
-out_unpin:
-	pfn_array_unpin_free(pa, cp->mdev);
-out_init:
-	ccw->cda = 0;
-	return ret;
-}
-
 /*
  * Fetch one ccw.
  * To reduce memory copy, we'll pin the cda page in memory,
@@ -671,9 +637,6 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
 	if (ccw_is_tic(ccw))
 		return ccwchain_fetch_tic(chain, idx, cp);
 
-	if (ccw_is_idal(ccw))
-		return ccwchain_fetch_idal(chain, idx, cp);
-
 	return ccwchain_fetch_direct(chain, idx, cp);
 }
 
-- 
2.20.1

