Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC4F6F1432
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345614AbjD1J3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 05:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345848AbjD1J3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 05:29:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBCA6A74;
        Fri, 28 Apr 2023 02:28:28 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S9RuwS007810;
        Fri, 28 Apr 2023 09:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=oSU/ybL2zzGUTrYzf9n7Vec87nb0Ddx26dEQX1P5FyM=;
 b=hhcLMMjVquOCZ4r/SESeqj9nIG7GJPuQ4M6ss13OQZL7mLmy3pyGulX/TVP3uwGSvvEb
 8sRm1CIAj2s2G27yr46UZLdfwqWnvXbTNzmlFHx12/vZM6NfXXYIo396xauSM/gzZssx
 ir4L5LDV3F5Utpz9JO32/wgjuGsb0nC9axOscMs+j+avMTXY164/ZjjrRsjHaugU1/Dn
 S0RhbbqjHxLKX2q7EWs76DsDqS/vwDa3JufzLgzOtU8ZI2ycKEM5uknnsyQBNVEd2C4K
 H2fJo8qP4hZE1qC0pp9I4ZoiW76Vj8dK/JA3TnlUy3hSHyOCIeOddHZfgOu1a7m6FBF6 cA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q8avb198t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 09:28:02 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33S2vVFN001400;
        Fri, 28 Apr 2023 09:28:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47773ffx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 09:28:00 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33S9RsCN4129526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Apr 2023 09:27:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1DDA20043;
        Fri, 28 Apr 2023 09:27:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A92402004D;
        Fri, 28 Apr 2023 09:27:53 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Apr 2023 09:27:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, jgg@nvidia.com,
        hca@linux.ibm.com
Subject: [PATCH v3 1/1] KVM: s390: fix race in gmap_make_secure()
Date:   Fri, 28 Apr 2023 11:27:53 +0200
Message-Id: <20230428092753.27913-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428092753.27913-1-imbrenda@linux.ibm.com>
References: <20230428092753.27913-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z3xKEHHfgRqQwIwHtvKHdyG1w4PbqnBj
X-Proofpoint-ORIG-GUID: z3xKEHHfgRqQwIwHtvKHdyG1w4PbqnBj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=922 impostorscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304280073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a potential race in gmap_make_secure() and remove the last user of
follow_page() without FOLL_GET.

The old code is locking something it doesn't have a reference to, and
as explained by Jason and David in this discussion:
https://lore.kernel.org/linux-mm/Y9J4P%2FRNvY1Ztn0Q@nvidia.com/
it can lead to all kind of bad things, including the page getting
unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
unlock_page() would target the wrong bit.
There is also another race with the FOLL_WRITE, which could race
between the follow_page() and the get_locked_pte().

The main point is to remove the last use of follow_page() without
FOLL_GET or FOLL_PIN, removing the races can be considered a nice
bonus.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/linux-mm/Y9J4P%2FRNvY1Ztn0Q@nvidia.com/
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
---
 arch/s390/kernel/uv.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9f18a4af9c13..cb2ee06df286 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -192,21 +192,10 @@ static int expected_page_refs(struct page *page)
 	return res;
 }
 
-static int make_secure_pte(pte_t *ptep, unsigned long addr,
-			   struct page *exp_page, struct uv_cb_header *uvcb)
+static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
 {
-	pte_t entry = READ_ONCE(*ptep);
-	struct page *page;
 	int expected, cc = 0;
 
-	if (!pte_present(entry))
-		return -ENXIO;
-	if (pte_val(entry) & _PAGE_INVALID)
-		return -ENXIO;
-
-	page = pte_page(entry);
-	if (page != exp_page)
-		return -ENXIO;
 	if (PageWriteback(page))
 		return -EAGAIN;
 	expected = expected_page_refs(page);
@@ -304,17 +293,18 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		goto out;
 
 	rc = -ENXIO;
-	page = follow_page(vma, uaddr, FOLL_WRITE);
-	if (IS_ERR_OR_NULL(page))
-		goto out;
-
-	lock_page(page);
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
-	if (should_export_before_import(uvcb, gmap->mm))
-		uv_convert_from_secure(page_to_phys(page));
-	rc = make_secure_pte(ptep, uaddr, page, uvcb);
+	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
+		page = pte_page(*ptep);
+		rc = -EAGAIN;
+		if (trylock_page(page)) {
+			if (should_export_before_import(uvcb, gmap->mm))
+				uv_convert_from_secure(page_to_phys(page));
+			rc = make_page_secure(page, uvcb);
+			unlock_page(page);
+		}
+	}
 	pte_unmap_unlock(ptep, ptelock);
-	unlock_page(page);
 out:
 	mmap_read_unlock(gmap->mm);
 
-- 
2.40.0

