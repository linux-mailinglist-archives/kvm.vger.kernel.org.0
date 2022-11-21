Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3B632F04
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiKUVlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiKUVlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C093D06E0;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJRh9I036608;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DYtkR7yAPFhD4lU6hvEKtH4bpIwH2L62l6vX5SbWXTg=;
 b=narr6cBhPc6JlI6mxCl42w+vxKz4lWaoyS0LzfVBF0vOxmOBwo0/s+RVBybU4SVLx1Mx
 cD+IXG2PTHygMSoTmuUpanb5z/oHvP5cmHmRg157eSYAisYmoNsD9wS+FkQOJ6GQ3tNw
 2nY5tEEq7MrbbBeuw2kbAXDMLJ6H3W0hSa2k4Ydjw8z37SJ0eCgueqwZa9dFlL+Hn54A
 sTkK+xGg6q4N6JdgYYGSTAbA7ylepxMXJ0LM4jAI0O3+9Suf2GyI/4y1/yT7NL1ueGim
 +HDBS4jrwEy36mnA2YHPiuLm/HksGhjKh7viJjkSicS/XMh6+c7zrT364yuKkCJDRMnV qA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0fguav39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLcK0J024342;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdhu80k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf27n32965080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AF54A405C;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 369D1A4054;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 92959E08E0; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 15/16] vfio/ccw: don't group contiguous pages on 2K IDAWs
Date:   Mon, 21 Nov 2022 22:40:55 +0100
Message-Id: <20221121214056.1187700-16-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4AFioQ0sbdoPSwdsffYhUjCpJPFVKqsS
X-Proofpoint-ORIG-GUID: 4AFioQ0sbdoPSwdsffYhUjCpJPFVKqsS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
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
---
 drivers/s390/cio/vfio_ccw_cp.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 9527f3d8da77..3829c346583c 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -88,7 +88,7 @@ static int page_array_alloc(struct page_array *pa, unsigned int len)
  * otherwise only clear pa->pa_nr
  */
 static void page_array_unpin(struct page_array *pa,
-			     struct vfio_device *vdev, int pa_nr)
+			     struct vfio_device *vdev, int pa_nr, bool unaligned)
 {
 	int unpinned = 0, npage = 1;
 
@@ -97,7 +97,8 @@ static void page_array_unpin(struct page_array *pa,
 		dma_addr_t *last = &first[npage];
 
 		if (unpinned + npage < pa_nr &&
-		    *first + npage * PAGE_SIZE == *last) {
+		    *first + npage * PAGE_SIZE == *last &&
+		    !unaligned) {
 			npage++;
 			continue;
 		}
@@ -119,7 +120,7 @@ static void page_array_unpin(struct page_array *pa,
  * If the pin request partially succeeds, or fails completely,
  * all pages are left unpinned and a negative error value is returned.
  */
-static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
+static int page_array_pin(struct page_array *pa, struct vfio_device *vdev, bool unaligned)
 {
 	int pinned = 0, npage = 1;
 	int ret = 0;
@@ -129,7 +130,8 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
 		dma_addr_t *last = &first[npage];
 
 		if (pinned + npage < pa->pa_nr &&
-		    *first + npage * PAGE_SIZE == *last) {
+		    *first + npage * PAGE_SIZE == *last &&
+		    !unaligned) {
 			npage++;
 			continue;
 		}
@@ -151,14 +153,14 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
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
@@ -638,7 +640,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	}
 
 	if (ccw_does_data_transfer(ccw)) {
-		ret = page_array_pin(pa, vdev);
+		ret = page_array_pin(pa, vdev, idal_is_2k(cp));
 		if (ret < 0)
 			goto out_unpin;
 	} else {
@@ -654,7 +656,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	return 0;
 
 out_unpin:
-	page_array_unpin_free(pa, vdev);
+	page_array_unpin_free(pa, vdev, idal_is_2k(cp));
 out_free_idaws:
 	kfree(idaws);
 out_init:
@@ -752,7 +754,7 @@ void cp_free(struct channel_program *cp)
 	cp->initialized = false;
 	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++) {
-			page_array_unpin_free(chain->ch_pa + i, vdev);
+			page_array_unpin_free(chain->ch_pa + i, vdev, idal_is_2k(cp));
 			ccwchain_cda_free(chain, i);
 		}
 		ccwchain_free(chain);
-- 
2.34.1

