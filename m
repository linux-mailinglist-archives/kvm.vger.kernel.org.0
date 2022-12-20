Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDBB652534
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiLTRKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiLTRKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCF82AEF;
        Tue, 20 Dec 2022 09:10:37 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrldc011841;
        Tue, 20 Dec 2022 17:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KxxynLEkXUDLBGcC83g11gQfMmRclh+wXGs7GGV5Erg=;
 b=PsLlNXrfCvjqJJmYn7kHNP41CBgK9QitzJ6qugNEXLSLCheO5qigKuqh0Tg4bdq4Rx0H
 oxgiIkRmHXhW8b4iGkF+WR9C5gf+7s7CtYl996dVsyoSOgNY3T3qZrwwjHix7nXMbXTI
 mJEKzx0m2uLRF/1CmxfADtUQLsJ9gB54RCC5rFMAyZIHCJTGYW91urM/2Ps+YU3ZP1tk
 yhNxOCfglq4cLi9jamuaWUEOhgljAZ9nbvkgXPWlQ0bgY0wZVspp7ChHYanV9qQVJxeK
 GOa+eFSkRpZpLpMMXc38tJFnbR6BXFIExT54yP4a1w+1BmyYuBRG6kSZ6bbmX3mQSqpU Fg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp1708-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:36 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK7N1Tt018666;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3mh6yuk47j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAZ448169402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1329120043;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0295520040;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 9128DE08BF; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 08/16] vfio/ccw: pass page count to page_array struct
Date:   Tue, 20 Dec 2022 18:10:00 +0100
Message-Id: <20221220171008.1362680-9-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DHEBeV_Xxr3THjOWqBa9hCjd17OYP6lB
X-Proofpoint-ORIG-GUID: DHEBeV_Xxr3THjOWqBa9hCjd17OYP6lB
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

The allocation of our page_array struct calculates the number
of 4K pages that would be needed to hold a certain number of
bytes. But, since the number of pages that will be pinned is
also calculated by the length of the IDAL, this logic is
unnecessary. Let's pass that information in directly, and
avoid the math within the allocator.

Also, let's make this two allocations instead of one,
to make it apparent what's happening within here.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 99332c6f6010..b1436736b7b6 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -43,7 +43,7 @@ struct ccwchain {
  * page_array_alloc() - alloc memory for page array
  * @pa: page_array on which to perform the operation
  * @iova: target guest physical address
- * @len: number of bytes that should be pinned from @iova
+ * @len: number of pages that should be pinned from @iova
  *
  * Attempt to allocate memory for page array.
  *
@@ -63,18 +63,20 @@ static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
 	if (pa->pa_nr || pa->pa_iova)
 		return -EINVAL;
 
-	pa->pa_nr = ((iova & ~PAGE_MASK) + len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
-	if (!pa->pa_nr)
+	if (len == 0)
 		return -EINVAL;
 
-	pa->pa_iova = kcalloc(pa->pa_nr,
-			      sizeof(*pa->pa_iova) + sizeof(*pa->pa_page),
-			      GFP_KERNEL);
-	if (unlikely(!pa->pa_iova)) {
-		pa->pa_nr = 0;
+	pa->pa_nr = len;
+
+	pa->pa_iova = kcalloc(len, sizeof(*pa->pa_iova), GFP_KERNEL);
+	if (!pa->pa_iova)
+		return -ENOMEM;
+
+	pa->pa_page = kcalloc(len, sizeof(*pa->pa_page), GFP_KERNEL);
+	if (!pa->pa_page) {
+		kfree(pa->pa_iova);
 		return -ENOMEM;
 	}
-	pa->pa_page = (struct page **)&pa->pa_iova[pa->pa_nr];
 
 	pa->pa_iova[0] = iova;
 	pa->pa_page[0] = NULL;
@@ -167,6 +169,7 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
 static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev)
 {
 	page_array_unpin(pa, vdev, pa->pa_nr);
+	kfree(pa->pa_page);
 	kfree(pa->pa_iova);
 }
 
@@ -545,7 +548,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	 * required for the data transfer, since we only only support
 	 * 4K IDAWs today.
 	 */
-	ret = page_array_alloc(pa, iova, bytes);
+	ret = page_array_alloc(pa, iova, idaw_nr);
 	if (ret < 0)
 		goto out_free_idaws;
 
-- 
2.34.1

