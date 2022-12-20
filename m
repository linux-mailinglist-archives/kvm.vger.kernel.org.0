Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E24A65253B
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiLTRKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiLTRKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5006E6142;
        Tue, 20 Dec 2022 09:10:38 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrldd011841;
        Tue, 20 Dec 2022 17:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+qnMp4zcu8llwLEoem5pXxT42hMVkaIvE8xny6R6AUo=;
 b=T101EA6+fJSPOivUIM7UdskKUVYXbYBrOfQP3VIOQ6iUok53QGx0s3cTK8GPb81FTn4+
 HjJCNHDcX//ypKU0UTVQj/BukqXxEXasaS67QQ32f/hh9ToqY8gjlEpSz43CDS6dB9ho
 e84UmXZeh7G/6C6AdRVu17oO4wYyh5gLC+YdwIruhQyomXI3NZP2aOx3Yl07ZXzkH7FM
 6gVsBeaUZFEjKyMm1To/h8V1M+nY98n3SsRO/sZL1TaNxT/XBJHIhgLJuJuH21Uvgw/K
 yNqJIXGcA/BaSr9Z4PKHJ3IrV/TVaykHQJAx5MmFB4anPVS54zNUBVmq2CMhx/K7ogsi lQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp16yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH2YKW002785;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mh6yvb402-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAgP45351200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07BCB2004D;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB1982004B;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 88789E0897; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
        Eric Farman <farman@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 05/16] vfio/ccw: replace copy_from_iova with vfio_dma_rw
Date:   Tue, 20 Dec 2022 18:09:57 +0100
Message-Id: <20221220171008.1362680-6-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p8ov1xQQO5nqw1XMADuFwwZ5lnyBcK6A
X-Proofpoint-ORIG-GUID: p8ov1xQQO5nqw1XMADuFwwZ5lnyBcK6A
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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

It was suggested [1] that we replace the old copy_from_iova() routine
(which pins a page, does a memcpy, and unpins the page) with the
newer vfio_dma_rw() interface.

This has a modest improvement in the overall time spent through the
fsm_io_request() path, and simplifies some of the code to boot.

[1] https://lore.kernel.org/r/20220706170553.GK693670@nvidia.com/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 56 +++-------------------------------
 1 file changed, 5 insertions(+), 51 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3a11132b1685..1eacbb8dc860 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -228,51 +228,6 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
 	}
 }
 
-/*
- * Within the domain (@vdev), copy @n bytes from a guest physical
- * address (@iova) to a host physical address (@to).
- */
-static long copy_from_iova(struct vfio_device *vdev, void *to, u64 iova,
-			   unsigned long n)
-{
-	struct page_array pa = {0};
-	int i, ret;
-	unsigned long l, m;
-
-	ret = page_array_alloc(&pa, iova, n);
-	if (ret < 0)
-		return ret;
-
-	ret = page_array_pin(&pa, vdev);
-	if (ret < 0) {
-		page_array_unpin_free(&pa, vdev);
-		return ret;
-	}
-
-	l = n;
-	for (i = 0; i < pa.pa_nr; i++) {
-		void *from = kmap_local_page(pa.pa_page[i]);
-
-		m = PAGE_SIZE;
-		if (i == 0) {
-			from += iova & (PAGE_SIZE - 1);
-			m -= iova & (PAGE_SIZE - 1);
-		}
-
-		m = min(l, m);
-		memcpy(to + (n - l), from, m);
-		kunmap_local(from);
-
-		l -= m;
-		if (l == 0)
-			break;
-	}
-
-	page_array_unpin_free(&pa, vdev);
-
-	return l;
-}
-
 /*
  * Helpers to operate ccwchain.
  */
@@ -471,10 +426,9 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	int len, ret;
 
 	/* Copy 2K (the most we support today) of possible CCWs */
-	len = copy_from_iova(vdev, cp->guest_cp, cda,
-			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
-	if (len)
-		return len;
+	ret = vfio_dma_rw(vdev, cda, cp->guest_cp, CCWCHAIN_LEN_MAX * sizeof(struct ccw1), false);
+	if (ret)
+		return ret;
 
 	/* Convert any Format-0 CCWs to Format-1 */
 	if (!cp->orb.cmd.fmt)
@@ -572,7 +526,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ccw_is_idal(ccw)) {
 		/* Read first IDAW to see if it's 4K-aligned or not. */
 		/* All subsequent IDAws will be 4K-aligned. */
-		ret = copy_from_iova(vdev, &iova, ccw->cda, sizeof(iova));
+		ret = vfio_dma_rw(vdev, ccw->cda, &iova, sizeof(iova), false);
 		if (ret)
 			return ret;
 	} else {
@@ -601,7 +555,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 
 	if (ccw_is_idal(ccw)) {
 		/* Copy guest IDAL into host IDAL */
-		ret = copy_from_iova(vdev, idaws, ccw->cda, idal_len);
+		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
 		if (ret)
 			goto out_unpin;
 
-- 
2.34.1

