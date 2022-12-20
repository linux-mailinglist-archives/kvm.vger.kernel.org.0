Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB7C652557
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiLTRMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiLTRL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:11:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6861D312;
        Tue, 20 Dec 2022 09:11:23 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH8WWN020849;
        Tue, 20 Dec 2022 17:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7SROP4uJWjnISTY55j1o/ZmTnUqyYyDoHqkvGM+aVl0=;
 b=czF5pm5Kg4nOAG7tCwpmnhjiSoRKeUp+DUcAU3DmD7bJ4oYSmw3iH7ze6dObJtHeGOpW
 7FJUeAXSrUr4A6lX8A4HSV5fE+jEjVFr1soAG0GTqidmBqUZUrP+r+0dGFKZsxKG8LoT
 eDXGIiC55sQCttRZvAFCETojlNP7MA1XeW6LgfBdW7yfnVB4+1d2sYrN6CIyPZq6k1VZ
 Z2nKP9ndozd54FeNlTdtT0zpFeHcq3B0bT+qPa1dLeN2voHv7SeMUuSA9OykKf/YRQWe
 YIw+xuKA+DZQYtSjv3yLGVHSzrI3Txvi71wigNDIlUwmEg7ueBSHWx/l0mPa6Cx2h2Y6 zg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgbw9x1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:11:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK5civD021285;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yy4amu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAAJ25494072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B28920040;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2598B20049;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 93F0CE08CC; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 09/16] vfio/ccw: populate page_array struct inline
Date:   Tue, 20 Dec 2022 18:10:01 +0100
Message-Id: <20221220171008.1362680-10-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iil3IdI8rgWl7vd1TZ-qRFqTp0f1eNMi
X-Proofpoint-ORIG-GUID: iil3IdI8rgWl7vd1TZ-qRFqTp0f1eNMi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two possible ways the list of addresses that get passed
to vfio are calculated. One is from a guest IDAL, which would be
an array of (probably) non-contiguous addresses. The other is
built from contiguous pages that follow the starting address
provided by ccw->cda.

page_array_alloc() attempts to simplify things by pre-populating
this array from the starting address, but that's not needed for
a CCW with an IDAL anyway so doesn't need to be in the allocator.
Move it to the caller in the non-IDAL case, since it will be
overwritten when reading the guest IDAL.

Remove the initialization of the pa_page output pointers,
since it won't be explicitly needed for either case.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index b1436736b7b6..f448aa93007f 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -42,7 +42,6 @@ struct ccwchain {
 /*
  * page_array_alloc() - alloc memory for page array
  * @pa: page_array on which to perform the operation
- * @iova: target guest physical address
  * @len: number of pages that should be pinned from @iova
  *
  * Attempt to allocate memory for page array.
@@ -56,10 +55,8 @@ struct ccwchain {
  *   -EINVAL if pa->pa_nr is not initially zero, or pa->pa_iova is not NULL
  *   -ENOMEM if alloc failed
  */
-static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
+static int page_array_alloc(struct page_array *pa, unsigned int len)
 {
-	int i;
-
 	if (pa->pa_nr || pa->pa_iova)
 		return -EINVAL;
 
@@ -78,13 +75,6 @@ static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
 		return -ENOMEM;
 	}
 
-	pa->pa_iova[0] = iova;
-	pa->pa_page[0] = NULL;
-	for (i = 1; i < pa->pa_nr; i++) {
-		pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
-		pa->pa_page[i] = NULL;
-	}
-
 	return 0;
 }
 
@@ -548,7 +538,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	 * required for the data transfer, since we only only support
 	 * 4K IDAWs today.
 	 */
-	ret = page_array_alloc(pa, iova, idaw_nr);
+	ret = page_array_alloc(pa, idaw_nr);
 	if (ret < 0)
 		goto out_free_idaws;
 
@@ -565,11 +555,9 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 		for (i = 0; i < idaw_nr; i++)
 			pa->pa_iova[i] = idaws[i];
 	} else {
-		/*
-		 * No action is required here; the iova addresses in page_array
-		 * were initialized sequentially in page_array_alloc() beginning
-		 * with the contents of ccw->cda.
-		 */
+		pa->pa_iova[0] = iova;
+		for (i = 1; i < pa->pa_nr; i++)
+			pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
 	}
 
 	if (ccw_does_data_transfer(ccw)) {
-- 
2.34.1

