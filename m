Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C8352A0E3
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345866AbiEQL5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345714AbiEQL4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:56:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7CF07;
        Tue, 17 May 2022 04:56:16 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBlloH006758;
        Tue, 17 May 2022 11:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ErKUEhaubZ/QJoRSkyX1CMQmt18aZoiFNNJuRS/vO1g=;
 b=pbrzwxQmmdJENys0LQUZZpgFGD1+qE7PsXQvdZnnwGNV3u2kvHzsN+EzH+pgdKLobmjg
 frZlfKGQmLx0D3t8SwfPGqNLqpsHZHM9E6UGxfFaZKy11WQGQI52OJRliQFSIltfsiG/
 WmsZfhFu6UNCMDkML6X4gOe/6nNHkkSuH2Eh0kpIcKE+xTrfIbb6fGwg4leEIdDzZb7/
 rForHjgWkhKDI4DsNye/ENaI7/1vIvOANCaou2xLr/J9UQULJBqd1J+dp1lQ7trNgad/
 CQL1kY1rQk9xc706Rzv3IfP6O4GTKLultDsq98BhFMQZ49QPz191ZQ7NSLA+B2ImgbAc tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b50r4tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:16 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBo0en016212;
        Tue, 17 May 2022 11:56:15 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b50r4t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBrDJX009475;
        Tue, 17 May 2022 11:56:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428ub3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBuAuP44695920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:56:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58659A404D;
        Tue, 17 May 2022 11:56:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B196A4040;
        Tue, 17 May 2022 11:56:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:56:10 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: Test TEID values in storage key test
Date:   Tue, 17 May 2022 13:56:05 +0200
Message-Id: <20220517115607.3252157-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220517115607.3252157-1-scgl@linux.ibm.com>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FGSzAzrtsvGmFBnMc2EN0wxuHlZjmVEs
X-Proofpoint-ORIG-GUID: DzXkwj6GS_VpSrxDCDp7FozMc7eEFdJ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 adultscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
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
 lib/s390x/asm/facility.h | 21 ++++++++++++++
 lib/s390x/sclp.h         |  4 +++
 lib/s390x/sclp.c         |  2 ++
 s390x/skey.c             | 60 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index ef0fd037..f21bb9d7 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -12,6 +12,7 @@
 #include <asm/facility.h>
 #include <asm/arch_def.h>
 #include <bitops.h>
+#include <sclp.h>
 
 #define NB_STFL_DOUBLEWORDS 32
 extern uint64_t stfl_doublewords[];
@@ -44,4 +45,24 @@ static inline void setup_facilities(void)
 		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
 }
 
+enum supp_on_prot_facility {
+	SOP_NONE,
+	SOP_BASIC,
+	SOP_ENHANCED_1,
+	SOP_ENHANCED_2,
+};
+
+static inline enum supp_on_prot_facility get_supp_on_prot_facility(void)
+{
+	if (sclp_facilities.has_esop) {
+		if (test_facility(131)) /* side-effect-access facility */
+			return SOP_ENHANCED_2;
+		else
+			return SOP_ENHANCED_1;
+	}
+	if (sclp_facilities.has_sop)
+		return SOP_BASIC;
+	return SOP_NONE;
+}
+
 #endif
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 3488f4d2..853529bf 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -123,7 +123,9 @@ struct sclp_facilities {
 	uint64_t has_cei : 1;
 
 	uint64_t has_diag318 : 1;
+	uint64_t has_sop : 1;
 	uint64_t has_gsls : 1;
+	uint64_t has_esop : 1;
 	uint64_t has_cmma : 1;
 	uint64_t has_64bscao : 1;
 	uint64_t has_esca : 1;
@@ -134,7 +136,9 @@ struct sclp_facilities {
 };
 
 /* bit number within a certain byte */
+#define SCLP_FEAT_80_BIT_SOP		2
 #define SCLP_FEAT_85_BIT_GSLS		0
+#define SCLP_FEAT_85_BIT_ESOP		6
 #define SCLP_FEAT_98_BIT_KSS		7
 #define SCLP_FEAT_116_BIT_64BSCAO	0
 #define SCLP_FEAT_116_BIT_CMMA		1
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index b8204c5f..e6017f64 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -152,7 +152,9 @@ void sclp_facilities_setup(void)
 	cpu = sclp_get_cpu_entries();
 	if (read_info->offset_cpu > 134)
 		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	sclp_facilities.has_sop = sclp_feat_check(80, SCLP_FEAT_80_BIT_SOP);
 	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_BIT_GSLS);
+	sclp_facilities.has_esop = sclp_feat_check(85, SCLP_FEAT_85_BIT_ESOP);
 	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_BIT_KSS);
 	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
 	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);
diff --git a/s390x/skey.c b/s390x/skey.c
index 7aa91d19..19fa5721 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -8,6 +8,7 @@
  *  Janosch Frank <frankja@linux.vnet.ibm.com>
  */
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <vmalloc.h>
@@ -158,6 +159,53 @@ static void test_test_protection(void)
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
+	struct lowcore *lc = 0;
+	union teid teid;
+
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_push("TEID");
+	teid.val = lc->trans_exc_id;
+	switch (get_supp_on_prot_facility()) {
+	case SOP_NONE:
+	case SOP_BASIC:
+		break;
+	case SOP_ENHANCED_1:
+		if ((teid.val & (BIT(63 - 61))) == 0)
+			report_pass("key-controlled protection");
+		break;
+	case SOP_ENHANCED_2:
+		if ((teid.val & (BIT(63 - 56) | BIT(63 - 61))) == 0) {
+			report_pass("key-controlled protection");
+			if (teid.val & BIT(63 - 60)) {
+				int access_code = teid.fetch << 1 | teid.store;
+
+				if (access_code == 2)
+					report((access & 2) && (prot & 2),
+					       "exception due to fetch");
+				if (access_code == 1)
+					report((access & 1) && (prot & 1),
+					       "exception due to store");
+				/* no relevant information if code is 0 or 3 */
+			}
+		}
+		break;
+	}
+	report_prefix_pop();
+}
+
 /*
  * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
  * with access key 1.
@@ -199,7 +247,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -210,7 +258,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -228,7 +276,7 @@ static void test_store_cpu_address(void)
 	expect_pgm_int();
 	*out = 0xbeef;
 	store_cpu_address_key_1(out);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_STORE, PROT_STORE);
 	report(*out == 0xbeef, "no store occurred");
 	report_prefix_pop();
 
@@ -321,7 +369,7 @@ static void test_set_prefix(void)
 	set_storage_key(pagebuf, 0x28, 0);
 	expect_pgm_int();
 	set_prefix_key_1(prefix_ptr);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
@@ -334,7 +382,7 @@ static void test_set_prefix(void)
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
 	set_prefix_key_1((uint32_t *)0);
 	install_page(root, 0, 0);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
@@ -358,7 +406,7 @@ static void test_set_prefix(void)
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
 	set_prefix_key_1((uint32_t *)2048);
 	install_page(root, 0, 0);
-	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
 	report(get_prefix() == old_prefix, "did not set prefix");
 	report_prefix_pop();
 
-- 
2.33.1

