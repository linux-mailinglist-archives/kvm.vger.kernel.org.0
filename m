Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD3D652549
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiLTRLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiLTRKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B06300;
        Tue, 20 Dec 2022 09:10:41 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrkv6011643;
        Tue, 20 Dec 2022 17:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IbzD+v2I/BlX64RNSBJ+jwrZm9kzjWYTmHxcLoMGx74=;
 b=VYfqtthtQ+bXy6mJyp1agLNuJGd0nLp+5EeaCI+44LNXWuV8TO1BnB6wZjedAUx3UcLA
 bDjWZEMKYs/JUrBrLRjzajlIusAEbhFfUiA2+tmE30saXWffKB7hfXVxTU09PAykZz01
 9ET2gADHgCQ9oxfFgZO39KOy4SU0FsGwFblhKMdnkFyc+yuyZYroGHqylhTGJukSJJTD
 cEpGn8rkZVnkjmFxKLi4XqC9lCDHqI2wED8EBMvyGJJ4k5r30LSbMWXJIn3Hnc6ljAXi
 EWTNXFiT/QimHjzkMt/65rQeWr2EZB6BPFKe2X/iCqSr5U/qAAF1uD8OsuejhIFv9qn3 zg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp1716-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK7b15L014065;
        Tue, 20 Dec 2022 17:10:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw4axm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAA1T20119808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 610922004F;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47EFB20043;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A4AECE08FE; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 15/16] vfio/ccw: don't group contiguous pages on 2K IDAWs
Date:   Tue, 20 Dec 2022 18:10:07 +0100
Message-Id: <20221220171008.1362680-16-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vA18dqw7PEs1lfxh82ZiGoskjSr-clHH
X-Proofpoint-ORIG-GUID: vA18dqw7PEs1lfxh82ZiGoskjSr-clHH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_pin_pages() interface allows contiguous pages to be
pinned as a single request, which is great for the 4K pages
that are normally processed. Old IDA formats operate on 2K
chunks, which makes this logic more difficult.

Since these formats are rare, let's just invoke the page
pinning one-at-a-time, instead of trying to group them.
We can rework this code at a later date if needed.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 52e5abce5827..098d1e9f0c97 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -83,12 +83,13 @@ static int page_array_alloc(struct page_array *pa, unsigned int len)
  * @pa: page_array on which to perform the operation
  * @vdev: the vfio device to perform the operation
  * @pa_nr: number of user pages to unpin
+ * @unaligned: were pages unaligned on the pin request
  *
  * Only unpin if any pages were pinned to begin with, i.e. pa_nr > 0,
  * otherwise only clear pa->pa_nr
  */
 static void page_array_unpin(struct page_array *pa,
-			     struct vfio_device *vdev, int pa_nr)
+			     struct vfio_device *vdev, int pa_nr, bool unaligned)
 {
 	int unpinned = 0, npage = 1;
 
@@ -97,7 +98,8 @@ static void page_array_unpin(struct page_array *pa,
 		dma_addr_t *last = &first[npage];
 
 		if (unpinned + npage < pa_nr &&
-		    *first + npage * PAGE_SIZE == *last) {
+		    *first + npage * PAGE_SIZE == *last &&
+		    !unaligned) {
 			npage++;
 			continue;
 		}
@@ -114,12 +116,19 @@ static void page_array_unpin(struct page_array *pa,
  * page_array_pin() - Pin user pages in memory
  * @pa: page_array on which to perform the operation
  * @vdev: the vfio device to perform pin operations
+ * @unaligned: are pages aligned to 4K boundary?
  *
  * Returns number of pages pinned upon success.
  * If the pin request partially succeeds, or fails completely,
  * all pages are left unpinned and a negative error value is returned.
+ *
+ * Requests to pin "aligned" pages can be coalesced into a single
+ * vfio_pin_pages request for the sake of efficiency, based on the
+ * expectation of 4K page requests. Unaligned requests are probably
+ * dealing with 2K "pages", and cannot be coalesced without
+ * reworking this logic to incorporate that math.
  */
-static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
+static int page_array_pin(struct page_array *pa, struct vfio_device *vdev, bool unaligned)
 {
 	int pinned = 0, npage = 1;
 	int ret = 0;
@@ -129,7 +138,8 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
 		dma_addr_t *last = &first[npage];
 
 		if (pinned + npage < pa->pa_nr &&
-		    *first + npage * PAGE_SIZE == *last) {
+		    *first + npage * PAGE_SIZE == *last &&
+		    !unaligned) {
 			npage++;
 			continue;
 		}
@@ -151,14 +161,14 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
 	return ret;
 
 err_out:
-	page_array_unpin(pa, vdev, pinned);
+	page_array_unpin(pa, vdev, pinned, unaligned);
 	return ret;
 }
 
 /* Unpin the pages before releasing the memory. */
-static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev)
+static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev, bool unaligned)
 {
-	page_array_unpin(pa, vdev, pa->pa_nr);
+	page_array_unpin(pa, vdev, pa->pa_nr, unaligned);
 	kfree(pa->pa_page);
 	kfree(pa->pa_iova);
 }
@@ -640,7 +650,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	}
 
 	if (ccw_does_data_transfer(ccw)) {
-		ret = page_array_pin(pa, vdev);
+		ret = page_array_pin(pa, vdev, idal_is_2k(cp));
 		if (ret < 0)
 			goto out_unpin;
 	} else {
@@ -656,7 +666,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	return 0;
 
 out_unpin:
-	page_array_unpin_free(pa, vdev);
+	page_array_unpin_free(pa, vdev, idal_is_2k(cp));
 out_free_idaws:
 	kfree(idaws);
 out_init:
@@ -754,7 +764,7 @@ void cp_free(struct channel_program *cp)
 	cp->initialized = false;
 	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++) {
-			page_array_unpin_free(&chain->ch_pa[i], vdev);
+			page_array_unpin_free(&chain->ch_pa[i], vdev, idal_is_2k(cp));
 			ccwchain_cda_free(chain, i);
 		}
 		ccwchain_free(chain);
-- 
2.34.1

