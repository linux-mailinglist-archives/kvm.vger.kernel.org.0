Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A320F57CCDE
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiGUOH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiGUOHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B3245986
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:17 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LE2GUH022444
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=of9xJittL/0Xnr7BUcGj89Rf2W+ghPH6IvZJCIgd3Lk=;
 b=YUDow8FheL38izjFB7hYBpSdRsUrVPrwTP/UuvRf/AU8ZVT7+2eygH7GVmaVGRAM5ci/
 5RTQJ6wSM+j8+u/71LRuSimiTF61qxButRNu5qiF0l451gaJIndrCWBFBcZwrHAUpbs/
 1x0urX/fpI1rYzTg/lRrAIqz+8PFE/TfMBDg3LfiYgJo6xTG/ijVA9wUoQNx5LO5kWYN
 sJjnlnyZo9XjyJUdzLX55zfnOXy1k6T1WWXRHVyVbYgrZ/pzLPQq14z2PWPc3ZCeWR90
 eKwGTew94EFldkWT1NPxRpEIctHOAsgU/v863exvWr+kOAfj/RuvF0WeH9VEJ0frkHL1 mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8790a11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE2Hd6022531
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:15 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf87909js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:14 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE5Trq022418;
        Thu, 21 Jul 2022 14:07:06 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nbvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE5F5u21692738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:05:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EBA64C04E;
        Thu, 21 Jul 2022 14:07:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E87E44C044;
        Thu, 21 Jul 2022 14:07:02 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 04/12] s390x: Test TEID values in storage key test
Date:   Thu, 21 Jul 2022 16:06:53 +0200
Message-Id: <20220721140701.146135-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i2pF65v8Z8J4FkJwW6A6SLogflKw6eK4
X-Proofpoint-ORIG-GUID: Lk4kfB9oXh1L2l-cHs25EDFmi-sPKrcf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

On a protection exception, test that the Translation-Exception
Identification (TEID) values are correct given the circumstances of the
particular test.
The meaning of the TEID values is dependent on the installed
suppression-on-protection facility.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Message-Id: <20220621143609.753452-2-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

