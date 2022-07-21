Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22FA57CCDF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiGUOHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiGUOHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5B6558F5
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:30 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LE4acp029475
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x9ADs/0p/eROhV4ZAMA2zhFkcSVnZEt8Vu2HWHtsH1g=;
 b=UZXtHVHr9mik9UNFexnmr/y9c5zwSd2nyOgW5BjS+7TWcG7tvcz1LrUsTT6kyCUG15TP
 p2UGO3RJsRPPYZXnHbUIWMSX3KC305bPFgj8Pt9vxy9VFi+xZJow0LAdpKxghP65KGqC
 L2xQ6rUbfIHfnQMDAGJUuk+TCv1hjTxKssLVnIfe8eelSwilbHe4njhkSvr9em70Xx5v
 ZwwH23iwVGn7bWdQzZBK6+/dKGhAC2S3pefcp8JxCbdui1TNHS3MUYUhWUMrWwXmeXUS
 gw2Z5xgrkPYyah9C7xyEl5o53uLugbGTRfpS7gBKS0wODRMH7iCRbC4AM2Iun1bCZck8 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf6mwkgre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDDIJE029519
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:22 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf6mwkgdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE5vRo022551;
        Thu, 21 Jul 2022 14:07:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nbw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE75O317433038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C5464C046;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE46A4C04E;
        Thu, 21 Jul 2022 14:07:04 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:04 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 09/12] s390x: skey.c: rework the interrupt handler
Date:   Thu, 21 Jul 2022 16:06:58 +0200
Message-Id: <20220721140701.146135-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iQigauNwykNcp0NFJID5U0p8IPioFhm7
X-Proofpoint-ORIG-GUID: NpZkRN7A0qsxgTnzmPThW3vAe6pMXkqP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=768
 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/skey.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 7e85f97d..1167e4d3 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -451,19 +451,6 @@ static void set_prefix_key_1(uint32_t *prefix_ptr)
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
 
@@ -519,7 +506,13 @@ static void test_set_prefix(void)
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
@@ -557,7 +550,7 @@ static void test_set_prefix(void)
 	report_prefix_pop();
 
 	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
-	register_pgm_cleanup_func(NULL);
+	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
 	report_prefix_pop();
 	set_storage_key(pagebuf, 0x00, 0);
 	report_prefix_pop();
@@ -664,7 +657,13 @@ static void test_msch(void)
 		report_fail("could not reset SCHIB");
 	}
 
-	register_pgm_cleanup_func(dat_fixup_pgm_int);
+	/*
+	 * Page 0 will be remapped, making the lowcore inaccessible, which
+	 * breaks the normal handler and breaks skipping the faulting
+	 * instruction. Disable dynamic address translation for the
+	 * interrupt handler to make things work.
+	 */
+	lowcore.pgm_new_psw.mask &= ~PSW_MASK_DAT;
 
 	schib->pmcw.intparm = 0;
 	if (!msch(test_device_sid, schib)) {
@@ -720,7 +719,7 @@ static void test_msch(void)
 	}
 
 	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
-	register_pgm_cleanup_func(NULL);
+	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
 	report_prefix_pop();
 	set_storage_key(schib, 0x00, 0);
 	report_prefix_pop();
-- 
2.36.1

