Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30AE55349E
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242186AbiFUOgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349502AbiFUOgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:36:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4747320BCD;
        Tue, 21 Jun 2022 07:36:18 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEEmT5015267;
        Tue, 21 Jun 2022 14:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ApkbzL8sAV1lbIPSlvDRsg4ZhG/zzof/HUtLzNFxJ3c=;
 b=dLp7knRbW+rwHA/A5/Q8Xmg9PBeYOlrPdtCD/zITOuIBbeiNHA4GQXCatVyucq2PwTtQ
 Qyu4jSXr7pCm481zeiGdHtA1btf9XLHAWK22ZzVZx9AHLiUblfg3emQnwrYyYxRd3vI5
 /ND5Z3ZKzlF0qHPZstR68yeKv2dan9QsNLm5D2PcRhBZIGyDEfAZz5NxQcmRjgQZLxX3
 O/MailOs4uFmsaCka0l474QBa1nSem6Bp30xA0MoOAFp/r5qRCG0ZBvc6LGaUVo0wv7I
 3Xm+Qk3h+oPy9foSQHiVa0V+ha/TV96ZnaT4PBG0bMGtVXWUPCo9QSfArL1i+iPQJRFv DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrqq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:17 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEG296020143;
        Tue, 21 Jun 2022 14:36:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrqn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LEMpUr005879;
        Tue, 21 Jun 2022 14:36:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3gs5yhm6s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEZRVn21561830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:35:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0778A4054;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CB08A4062;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 1/3] s390x: Test TEID values in storage key test
Date:   Tue, 21 Jun 2022 16:36:07 +0200
Message-Id: <20220621143609.753452-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220621143609.753452-1-scgl@linux.ibm.com>
References: <20220621143609.753452-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bG_Rjo1GOSY19WM1W8jFXXtJNz0H1NKb
X-Proofpoint-ORIG-GUID: tDM8RgJ8dtXjcI53Ar94sYaHgQMS8gBh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_07,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a protection exception, test that the Translation-Exception
Identification (TEID) values are correct given the circumstances of the
particular test.
The meaning of the TEID values is dependent on the installed
suppression-on-protection facility.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/skey.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 6 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 445476a0..efce1fc3 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -8,6 +8,7 @@
  *  Janosch Frank <frankja@linux.vnet.ibm.com>
  */
 #include <libcflat.h>
+#include <asm/arch_def.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <vmalloc.h>
@@ -158,6 +159,71 @@ static void test_test_protection(void)
 	report_prefix_pop();
 }
 
+enum access {
+	ACC_STORE = 1,
+	ACC_FETCH = 2,
+	ACC_UPDATE = 3,
+};
+
+enum protection {
+	PROT_STORE = 1,
+	PROT_FETCH_STORE = 3,
+};
+
+static void check_key_prot_exc(enum access access, enum protection prot)
+{
+	union teid teid;
+	int access_code;
+
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_push("TEID");
+	teid.val = lowcore.trans_exc_id;
+	switch (get_supp_on_prot_facility()) {
+	case SOP_NONE:
+	case SOP_BASIC:
+		/* let's ignore ancient/irrelevant machines */
+		break;
+	case SOP_ENHANCED_1:
+		report(!teid.sop_teid_predictable, "valid protection code");
+		/* no access code in case of key protection */
+		break;
+	case SOP_ENHANCED_2:
+		switch (teid_esop2_prot_code(teid)) {
+		case PROT_KEY:
+			/* ESOP-2: no need to check facility */
+			access_code = teid.acc_exc_fetch_store;
+
+			switch (access_code) {
+			case 0:
+				report_pass("valid access code");
+				break;
+			case 1:
+			case 2:
+				report((access & access_code) && (prot & access_code),
+				       "valid access code");
+				break;
+			case 3:
+				/*
+				 * This is incorrect in that reserved values
+				 * should be ignored, but kvm should not return
+				 * a reserved value and having a test for that
+				 * is more valuable.
+				 */
+				report_fail("valid access code");
+				break;
+			}
+			/* fallthrough */
+		case PROT_KEY_OR_LAP:
+			report_pass("valid protection code");
+			break;
+		default:
+			report_fail("valid protection code");
+		}
+		break;
+	}
+	report_prefix_pop();
+}
+
 /*
  * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
  * with access key 1.
@@ -199,7 +265,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -210,7 +276,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -228,7 +294,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -314,7 +380,7 @@ static void test_set_prefix(void)
 	set_storage_key(pagebuf, 0x28, 0);
 	expect_pgm_int();
 	set_prefix_key_1(prefix_ptr);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
@@ -327,7 +393,7 @@ static void test_set_prefix(void)
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
 	set_prefix_key_1((uint32_t *)0);
 	install_page(root, 0, 0);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
@@ -351,7 +417,7 @@ static void test_set_prefix(void)
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
 	set_prefix_key_1(OPAQUE_PTR(2048));
 	install_page(root, 0, 0);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
-- 
2.36.1

