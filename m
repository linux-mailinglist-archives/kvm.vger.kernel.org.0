Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDF9573C1D
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 19:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiGMRkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 13:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiGMRkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 13:40:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2161A2CDDE;
        Wed, 13 Jul 2022 10:40:16 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DH7EHp030740;
        Wed, 13 Jul 2022 17:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LRubS37RenMhHRu4zexbbSjV7u4ealIKrhgo7e+q15E=;
 b=LmRMWQLu4M/4IzluLWZLco05svCr2NbRenGOBQDMARNUJjsgt7sL20dYRR9SEzzMWEQL
 pWMYr20vYqOOcdeeWG7Qf8R2sW/y9VBC1wZHBhliakG8I57Ixgba09xJADaL+nS2xwxx
 Ybuhw/RfrRd57a1ONtp4IuW6jTJa3MfsXgFBM/EdMPtwSG2vNuYGdjDGv/iE+WBwn8ge
 gVMQz0BCTA47rpKy734plYzN+yb/BBoFCmLUZZfR2UwaYqIHUx1rz+OXwlSc4XzIRFtv
 Pvlvi4pLK66a2c9It/weOFFhFBxx5uWehslNvV77rBPdGx3nUIBoVIJYwQERvebG/ciC Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ha25w8sp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:40:15 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DHbMJk009824;
        Wed, 13 Jul 2022 17:40:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ha25w8snc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:40:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DHKDvx007329;
        Wed, 13 Jul 2022 17:40:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhx0ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:40:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DHe93R21430752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 17:40:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C43CC5204F;
        Wed, 13 Jul 2022 17:40:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.0.75])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 74CD952051;
        Wed, 13 Jul 2022 17:40:09 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 2/3] s390x: skey.c: rework the interrupt handler
Date:   Wed, 13 Jul 2022 19:39:59 +0200
Message-Id: <20220713174000.195695-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713174000.195695-1-imbrenda@linux.ibm.com>
References: <20220713174000.195695-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I3Lx-Nud8om2I3lIjKP0vpGlSvtQzG0r
X-Proofpoint-ORIG-GUID: NJzgsWbhCbW8HEHM3F6pNAtIF5SRVHxn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_07,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=782
 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The skey test currently uses a cleanup function to work around the
issues that arise when the lowcore is not mapped, since the interrupt
handler needs to access it.

Instead of a cleanup function, simply disable DAT for the interrupt
handler for the tests that remap page 0. This is needed in preparation
of and upcoming patch that will cause the interrupt handler to read
from lowcore before calling the cleanup function.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/skey.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 445476a0..d2752328 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -250,19 +250,6 @@ static void set_prefix_key_1(uint32_t *prefix_ptr)
 	);
 }
 
-/*
- * We remapped page 0, making the lowcore inaccessible, which breaks the normal
- * handler and breaks skipping the faulting instruction.
- * Just disable dynamic address translation to make things work.
- */
-static void dat_fixup_pgm_int(void)
-{
-	uint64_t psw_mask = extract_psw_mask();
-
-	psw_mask &= ~PSW_MASK_DAT;
-	load_psw_mask(psw_mask);
-}
-
 #define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
 static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
 
@@ -318,7 +305,13 @@ static void test_set_prefix(void)
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
-	register_pgm_cleanup_func(dat_fixup_pgm_int);
+	/*
+	 * Page 0 will be remapped, making the lowcore inaccessible, which
+	 * breaks the normal handler and breaks skipping the faulting
+	 * instruction. Disable dynamic address translation for the
+	 * interrupt handler to make things work.
+	 */
+	lowcore.pgm_new_psw.mask &= ~PSW_MASK_DAT;
 
 	report_prefix_push("remapped page, fetch protection");
 	set_prefix(old_prefix);
@@ -356,7 +349,7 @@ static void test_set_prefix(void)
 	report_prefix_pop();
 
 	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
-	register_pgm_cleanup_func(NULL);
+	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
 	report_prefix_pop();
 	set_storage_key(pagebuf, 0x00, 0);
 	report_prefix_pop();
-- 
2.36.1

