Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4764EC45F
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344897AbiC3MjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241834AbiC3Mh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:37:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930DF91571;
        Wed, 30 Mar 2022 05:26:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBvkmX000675;
        Wed, 30 Mar 2022 12:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2zLdKaE85V+2qiG6JE8eqhAObTmnsmKJ0bLt2qUlZn8=;
 b=E96jGee0srGizkFv5B3hQuzcbV6U+uRdMYl+bjEd7dnbHvAftgESLrVg2rMFaIzWCg47
 J29v1sRNYBeX02hcKL80CGc/qA7u9a5sKTmu7vQIHogMZJGtU1cmvCzawUPiVrc/lSAU
 BzCCtsv1jdlVHTOqaTAhsfS/iOE/533IERk0F5y+LudpQQil4nAxd/F9+EODBvh2cupa
 SfKunpPB4vfRbeXvh9QCIIXH9I2hrCixPAiqR6JII5KMf+AyUSFCX9aByc0E1H99fHij
 pS0Y80B1dar+fxZP6aW4is9tpR6kWgLXmuz0t9fecYjECHAuXrI/NdU7CKFK4Cr3ZwdR 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f4psu0mev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:24 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UBvug8000812;
        Wed, 30 Mar 2022 12:26:23 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f4psu0mea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UCNCV0013721;
        Wed, 30 Mar 2022 12:26:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf8y9hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCQI8740567080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:26:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECDEB11C050;
        Wed, 30 Mar 2022 12:26:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64AC511C04A;
        Wed, 30 Mar 2022 12:26:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:26:17 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v9 11/18] s390/mm: KVM: pv: when tearing down, try to destroy protected pages
Date:   Wed, 30 Mar 2022 14:25:58 +0200
Message-Id: <20220330122605.247613-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330122605.247613-1-imbrenda@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M1jaYmfTaYuZWq6-3vV-c_h_txxO076J
X-Proofpoint-GUID: wW6xUb-XL1kddf_8poiLbf6Q4a6_U0Bn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_03,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=996
 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When ptep_get_and_clear_full is called for a mm teardown, we will now
attempt to destroy the secure pages. This will be faster than export.

In case it was not a teardown, or if for some reason the destroy page
UVC failed, we try with an export page, like before.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 23ca0d8e058a..72544a1b4a68 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1118,9 +1118,21 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
-	/* At this point the reference through the mapping is still present */
-	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	/* Nothing to do */
+	if (!mm_is_protected(mm) || !pte_present(res))
+		return res;
+	/*
+	 * At this point the reference through the mapping is still present.
+	 * The notifier should have destroyed all protected vCPUs at this
+	 * point, so the destroy should be successful.
+	 */
+	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
+		return res;
+	/*
+	 * But if something went wrong and the pages could not be destroyed,
+	 * the slower export is used as fallback instead.
+	 */
+	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
-- 
2.34.1

