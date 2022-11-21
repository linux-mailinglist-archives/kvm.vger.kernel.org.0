Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86C632F21
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKUVma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiKUVll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30EADC326;
        Mon, 21 Nov 2022 13:41:09 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJh9rO015929;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=xRYie8FlZJUzhA4r8LVMzjTBECxX57Mwq4KqrApSDvg=;
 b=nddzcvj9sWBCHh7R7g31ugMBFlfBirZbg29nfhFRJQEeXpYFAGEI+LPwQZWMRxNx/oT3
 0Y5yZpd3TaCeEDTfiFqXmN0H23m3D+pp9Btpj8hC/zf90U1+1n1Ew2BFaPwam+iXKwha
 im4TwgSUzDHosqkWxg19rafxvqhzn3aqx6foDT/0AsPNG1Qd4FLY8tvy8Opeo6QkRaHV
 O0rfpoZL4U3rscyUn3BZnoilna0ELLcaefVPhczwr1DoB5wbFu6gK3/FYEVGDOOlyq69
 6pPBfHcvbQUcVvc+oqcZIyh2PvKAKUtjZw5W9scVyZlm8cE5vocgD9ypAYf2PB+3bfQo Hg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0fr02mp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLcQmK009250;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8tcya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf2wY32965074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05F0911C04C;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E655311C04A;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 732C1E0732; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 05/16] vfio/ccw: replace copy_from_iova with vfio_dma_rw
Date:   Mon, 21 Nov 2022 22:40:45 +0100
Message-Id: <20221121214056.1187700-6-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1hLN3E3TarX2NtoKx7ZVWQRe5dz2MYYw
X-Proofpoint-GUID: 1hLN3E3TarX2NtoKx7ZVWQRe5dz2MYYw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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

It was suggested [1] that we replace the old copy_from_iova() routine
(which pins a page, does a memcpy, and unpins the page) with the
newer vfio_dma_rw() interface.

This has a modest improvement in the overall time spent through the
fsm_io_request() path, and simplifies some of the code to boot.

[1] https://lore.kernel.org/r/20220706170553.GK693670@nvidia.com/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
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

