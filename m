Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38084632F1B
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiKUVmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiKUVli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC36DC30D;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJhFfg016014;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w6aBoLAR2T/JLQBJElTiZunMApZP8FGEtxeInH/d/4Y=;
 b=R7SYZKlhBMZBtmMTnsQW2JQOLjuSYobgwBnyqlVFhIH5mMQrgKixfmNC2L8Vqc9vtBzD
 iYdAEz74wgVBLpRAjLq4FTG1Bg6bjSgaAMBVxU7lcLAMOnpqV++fFVBwfetD8rZkyC9q
 bZejMpW4wwwS0Cn8nFikOSkYxajQd6SanB4jEd80WYoAKmArM3Bfx0ekRaaWV+KGF198
 NJI67UN/QY6PtKI/nutaxBIoAit96l9rilM2JIYk/1sj+9GwETbP6ePqpTlXKwV9Zhv2
 /I4AIJDhNQLOsCwa9kEbE68UHuJQS7xlyMmHN+fIsxw66mXk9MKn5hz62EI7HowH6XX3 kw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0fr02mp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLbSN9025182;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps92d0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf2oN55771612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1264AAE055;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00262AE04D;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7FCC8E0826; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 09/16] vfio/ccw: populate page_array struct inline
Date:   Mon, 21 Nov 2022 22:40:49 +0100
Message-Id: <20221121214056.1187700-10-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 49STRb-fb-_IAiZYfpHIa0xPRnTpmQC3
X-Proofpoint-GUID: 49STRb-fb-_IAiZYfpHIa0xPRnTpmQC3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_16,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
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
---
 drivers/s390/cio/vfio_ccw_cp.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 66e890441163..a30f26962750 100644
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

