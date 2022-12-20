Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1769B652548
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiLTRLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiLTRKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84F285;
        Tue, 20 Dec 2022 09:10:40 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrkv2011643;
        Tue, 20 Dec 2022 17:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S9DJSm07lACgE0U5Pt+npCO4U4ZicjNdfBa2FQnhQqg=;
 b=GprUrMetoDmvnTjcZkE3pWfVfCcZKrGFmbJjLclZuB84G+of6A4PY+Rjq22ITUrA4fPT
 aSq1EHXwl0Ctgwx5S62sv2FM/W4ZauH/nJNDC5ceZunqfzjIIZXIbWaWLsEXcyMcWmnX
 ifOmi2gQ3JWaO8/SZ9iHSA1HxpYkp+6rOSmUikGSL3Rer4vvkA5HbySqmtK7Z9MiGehR
 UjdcZyR26SC4bnESHGHcoNo62GSLOTZ02KFGYLH2m2Ny7Y0aWq2ysY4jCWuexdbkgvye
 JR+cj7zKdViohFgL/6LRvTEX79edqTbYtzbCX2un+2wVqNwjN9qhBuBvNLouzXLF1Ecz cA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:39 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKDFeDF024764;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mh6yw34h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAHh21496182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3160B2004F;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E39920043;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 8E3B5E08A6; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 07/16] vfio/ccw: remove unnecessary malloc alignment
Date:   Tue, 20 Dec 2022 18:09:59 +0100
Message-Id: <20221220171008.1362680-8-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ajls_3x1StKymNh499iWFXlS2S-5HZx4
X-Proofpoint-ORIG-GUID: Ajls_3x1StKymNh499iWFXlS2S-5HZx4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=972
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

Everything about this allocation is harder than necessary,
since the memory allocation is already aligned to our needs.
Break them apart for readability, instead of doing the
funky artithmetic.

Of the structures that are involved, only ch_ccw needs the
GFP_DMA flag, so the others can be allocated without it.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 43 ++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index d41d94cecdf8..99332c6f6010 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -311,40 +311,41 @@ static inline int is_tic_within_range(struct ccw1 *ccw, u32 head, int len)
 static struct ccwchain *ccwchain_alloc(struct channel_program *cp, int len)
 {
 	struct ccwchain *chain;
-	void *data;
-	size_t size;
-
-	/* Make ccw address aligned to 8. */
-	size = ((sizeof(*chain) + 7L) & -8L) +
-		sizeof(*chain->ch_ccw) * len +
-		sizeof(*chain->ch_pa) * len;
-	chain = kzalloc(size, GFP_DMA | GFP_KERNEL);
+
+	chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 	if (!chain)
 		return NULL;
 
-	data = (u8 *)chain + ((sizeof(*chain) + 7L) & -8L);
-	chain->ch_ccw = (struct ccw1 *)data;
-
-	data = (u8 *)(chain->ch_ccw) + sizeof(*chain->ch_ccw) * len;
-	chain->ch_pa = (struct page_array *)data;
+	chain->ch_ccw = kcalloc(len, sizeof(*chain->ch_ccw), GFP_DMA | GFP_KERNEL);
+	if (!chain->ch_ccw)
+		goto out_err;
 
-	chain->ch_len = len;
+	chain->ch_pa = kcalloc(len, sizeof(*chain->ch_pa), GFP_KERNEL);
+	if (!chain->ch_pa)
+		goto out_err;
 
 	list_add_tail(&chain->next, &cp->ccwchain_list);
 
 	return chain;
+
+out_err:
+	kfree(chain->ch_ccw);
+	kfree(chain);
+	return NULL;
 }
 
 static void ccwchain_free(struct ccwchain *chain)
 {
 	list_del(&chain->next);
+	kfree(chain->ch_pa);
+	kfree(chain->ch_ccw);
 	kfree(chain);
 }
 
 /* Free resource for a ccw that allocated memory for its cda. */
 static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 {
-	struct ccw1 *ccw = chain->ch_ccw + idx;
+	struct ccw1 *ccw = &chain->ch_ccw[idx];
 
 	if (ccw_is_tic(ccw))
 		return;
@@ -443,6 +444,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	chain = ccwchain_alloc(cp, len);
 	if (!chain)
 		return -ENOMEM;
+
+	chain->ch_len = len;
 	chain->ch_iova = cda;
 
 	/* Copy the actual CCWs into the new chain */
@@ -464,7 +467,7 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
 	int i, ret;
 
 	for (i = 0; i < chain->ch_len; i++) {
-		tic = chain->ch_ccw + i;
+		tic = &chain->ch_ccw[i];
 
 		if (!ccw_is_tic(tic))
 			continue;
@@ -681,7 +684,7 @@ void cp_free(struct channel_program *cp)
 	cp->initialized = false;
 	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++) {
-			page_array_unpin_free(chain->ch_pa + i, vdev);
+			page_array_unpin_free(&chain->ch_pa[i], vdev);
 			ccwchain_cda_free(chain, i);
 		}
 		ccwchain_free(chain);
@@ -739,8 +742,8 @@ int cp_prefetch(struct channel_program *cp)
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		len = chain->ch_len;
 		for (idx = 0; idx < len; idx++) {
-			ccw = chain->ch_ccw + idx;
-			pa = chain->ch_pa + idx;
+			ccw = &chain->ch_ccw[idx];
+			pa = &chain->ch_pa[idx];
 
 			ret = ccwchain_fetch_one(ccw, pa, cp);
 			if (ret)
@@ -866,7 +869,7 @@ bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length)
 
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++)
-			if (page_array_iova_pinned(chain->ch_pa + i, iova, length))
+			if (page_array_iova_pinned(&chain->ch_pa[i], iova, length))
 				return true;
 	}
 
-- 
2.34.1

