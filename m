Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2795632F17
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiKUVmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiKUVld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C121DB846;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALLRYLP023110;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RWTEinkUOfGwVfNLy0j9eVeGAVK8WwXgacwNMdfi9iE=;
 b=ssWFy0fRwSxnzlj92z7aaKpoxxB4zwksPdzZSwYKknam+YAOJtU3sk0yKnTUl+LnzYdW
 fz1F7IVmq8O8AUzbB//llzd1nNrp6KjEpLUMIL8/hWXMwo81GlgPIlJUVYXIaejVdol2
 h4uXZQeCxsBWszK+Zd9bSo1edV6LtdOQbnhevtsLeaER9/aG/mTH0nHkbR5JWyRWXRjC
 Ad8OOXSFxds/xQrxAs+kTKSd1fcT839394HqayKLGjfYi9uijSrHMyZSy3yAMFzJbViJ
 w82VVg9R8WaCRemVe3ZH6tnC+biCICWycuQ6iQqDqwkngb9xeBWwhfCKPfaTZrE8/CPQ zg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0h910c87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLZefe011671;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8jchv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf25n48103876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C65142045;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDCAE42041;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 798AAE0818; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 07/16] vfio/ccw: remove unnecessary malloc alignment
Date:   Mon, 21 Nov 2022 22:40:47 +0100
Message-Id: <20221121214056.1187700-8-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qV1tXyCd_NLGbFKPlymbIcMrLTo5GG_O
X-Proofpoint-ORIG-GUID: qV1tXyCd_NLGbFKPlymbIcMrLTo5GG_O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=850 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
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
 drivers/s390/cio/vfio_ccw_cp.c | 39 ++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index d41d94cecdf8..4b6b5f9dc92d 100644
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
-- 
2.34.1

