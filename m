Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD956573489
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 12:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiGMKqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 06:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiGMKqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 06:46:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798F2FE511;
        Wed, 13 Jul 2022 03:46:10 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DACjZQ026454;
        Wed, 13 Jul 2022 10:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h6Vpl19zVoupuEzCmdVVguJoEyaUm+IzWmTNI+MXWnU=;
 b=mlh5XdYKudRw6NJtCVq928UiwPBZ8AnbYStH2cMgHjsVooM6s2lUhmc1Ws4u5FhrMULe
 psYDEjBGki6djzq2qFj/xNCsJ59uWK2YsspjgoK4njOsPRPxn3QBmT2QNcKu1THbGvsm
 9tIRYi6zNvx/Xu+u2A4pIJO6vPhKLIb92hs0Wx5g3rWUd9JqeySZgDjal99mRwc+t9ln
 LO2mQBpb0iMT4stxX+jt1wiKFMSNCGAx3DkKyLk+Bl//QLrsjFiQwxZLTU5ikIffzbHs
 QOHRfl5YtMy7Ive+s9JMmi7SHON07NI88f9dhVYgM3kc4wJzLYqnNABV81NUDtCvPt8z GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9v3h8sux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:46:10 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DAXdo8019856;
        Wed, 13 Jul 2022 10:46:09 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9v3h8su8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:46:09 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DAa363012212;
        Wed, 13 Jul 2022 10:46:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3h99s78yf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:46:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DAk4Oa22675864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 10:46:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB316A4053;
        Wed, 13 Jul 2022 10:46:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99B0FA404D;
        Wed, 13 Jul 2022 10:46:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.0.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 10:46:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/3] s390x: skey.c: rework the interrupt handler
Date:   Wed, 13 Jul 2022 12:45:56 +0200
Message-Id: <20220713104557.168113-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713104557.168113-1-imbrenda@linux.ibm.com>
References: <20220713104557.168113-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5-aBtriJ0AhB3UkG6TscpOonukXtwV3L
X-Proofpoint-GUID: RoEHCwB9yeWK5b9W6q0FCcgScaTKGopf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=766 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207130043
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

