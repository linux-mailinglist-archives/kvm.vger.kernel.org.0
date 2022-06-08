Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12360543ABE
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiFHRpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiFHRpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7B4182B86;
        Wed,  8 Jun 2022 10:45:44 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258GtqRa001388;
        Wed, 8 Jun 2022 17:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ABJHQzNWOSP5gYziBjPkb9FmITZKZBEKURyqk9IGuVk=;
 b=atfGuzTU/1noIHu6Oq1d+McEtuRpNSnJDLGFBuP6b5NGwfN4JVg0R/d6fFs5V28c0jUc
 8jLQlyLkxrtQ/qCSkirNkDoh60hOk8oBAMQb/spEEbQovXxjGO+dFixRAiFGngGc5nnD
 6cnD754iLZCYDRIMA+etUBLimm7BcXAu0E3x1lrTM91N6wWtPNvTVIbgXD9f6D5DM15/
 kVdXBJ9KUMlImdpqti117IAQdVW+W4HpH5/IfRTBY/mjZ3HJFXPX2arXc93G4bXBr08g
 0sI2utNLesUgspm+cr4gbz3nvh/MknL9tRanZm/tvTDp7VYcSXZvCEAj+JR8Zp9bGTUu 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjyqmh1sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:44 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258GuY4h002981;
        Wed, 8 Jun 2022 17:45:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjyqmh1s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258HMFx4008828;
        Wed, 8 Jun 2022 17:45:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhwtp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258Hjcba54919654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 17:45:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75D3811C054;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D60511C050;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/3] s390x: Test TEID values in storage key test
Date:   Wed,  8 Jun 2022 19:45:34 +0200
Message-Id: <20220608174536.1700357-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608174536.1700357-1-scgl@linux.ibm.com>
References: <20220608174536.1700357-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YLqLUsP42EWSVAkB0dVK04LR237SzTe4
X-Proofpoint-ORIG-GUID: bN-Ra58mB87pcKa8keigutbxXiM5sKC-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080070
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
 s390x/skey.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 6 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 445476a0..d05ebc09 100644
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
@@ -158,6 +159,73 @@ static void test_test_protection(void)
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
+	bool dat;
+
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_push("TEID");
+	teid.val = lowcore.trans_exc_id;
+	switch (get_supp_on_prot_facility()) {
+	case SOP_NONE:
+		break;
+	case SOP_BASIC:
+		dat = extract_psw_mask() & PSW_MASK_DAT;
+		report(!teid.sop_teid_predictable || !dat || !teid.sop_acc_list,
+		       "valid protection code");
+		break;
+	case SOP_ENHANCED_1:
+		report(!teid.sop_teid_predictable, "valid protection code");
+		break;
+	case SOP_ENHANCED_2:
+		switch (teid_esop2_prot_code(teid)) {
+		case PROT_KEY:
+			access_code = teid.acc_exc_f_s;
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
+		case PROT_KEY_LAP:
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
@@ -199,7 +267,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -210,7 +278,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -228,7 +296,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -314,7 +382,7 @@ static void test_set_prefix(void)
 	set_storage_key(pagebuf, 0x28, 0);
 	expect_pgm_int();
 	set_prefix_key_1(prefix_ptr);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
@@ -327,7 +395,7 @@ static void test_set_prefix(void)
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
 	set_prefix_key_1((uint32_t *)0);
 	install_page(root, 0, 0);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
@@ -351,7 +419,7 @@ static void test_set_prefix(void)
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
 	set_prefix_key_1(OPAQUE_PTR(2048));
 	install_page(root, 0, 0);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
-- 
2.33.1

