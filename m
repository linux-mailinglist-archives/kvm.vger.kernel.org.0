Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050AC734E13
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjFSIhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjFSIhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:37:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B271718;
        Mon, 19 Jun 2023 01:35:06 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J8H7qY029013;
        Mon, 19 Jun 2023 08:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jEdA2/Knw/0wynKdIeM8WJn/SgRGQpUjAYdfunQ44Qw=;
 b=U00TcYj2276m1PomY7tWzJa4XOm4K9nuj/NOUTYDEcQOgYrrc4+aGhLlYSiersp5sR0a
 BdvzyUGXSQxVlnes98ES06+OYlqIb2dSJ6ZdX6pKuBk9YLdx+XAU7fP0iow3KfXvyR6Z
 gEYR6+Fb68G+b2e/XdZEIxMb2CGONZu4SegetLNKuhUZU3i/be3xC6gatNBaChXPmdwl
 sWoET5JeCMf83R644BWi505iLNhx2XX2IEczqoXAJDNSGzfXAznrA1zJgNpCp+mmcuuo
 iw4A6zaG/fgMSy4jPgIk0xxsoW9IEiAcMinhh3Zt8zrPrOKkLvYzHgXUWMHily6HLKqG 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakcf8a6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:02 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35J8HBG2029195;
        Mon, 19 Jun 2023 08:34:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakcf8a65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35J56e5J027760;
        Mon, 19 Jun 2023 08:33:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5980m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:33:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35J8XuA824576526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 08:33:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 503782004D;
        Mon, 19 Jun 2023 08:33:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BD3520043;
        Mon, 19 Jun 2023 08:33:55 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jun 2023 08:33:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 4/8] s390x: pv-diags: Drop snippet from snippet names
Date:   Mon, 19 Jun 2023 08:33:25 +0000
Message-Id: <20230619083329.22680-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230619083329.22680-1-frankja@linux.ibm.com>
References: <20230619083329.22680-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _iQ-N9KIBDhUL4j272VspAZ6P88xrr16
X-Proofpoint-ORIG-GUID: KRwkgy5e8yiHhdEXScSQUTO1kSdYEYYd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's a bit redundant.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                                |  6 +--
 s390x/pv-diags.c                              | 48 +++++++++----------
 .../{snippet-pv-diag-288.S => pv-diag-288.S}  |  0
 .../{snippet-pv-diag-500.S => pv-diag-500.S}  |  0
 ...nippet-pv-diag-yield.S => pv-diag-yield.S} |  0
 5 files changed, 27 insertions(+), 27 deletions(-)
 rename s390x/snippets/asm/{snippet-pv-diag-288.S => pv-diag-288.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-500.S => pv-diag-500.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-yield.S => pv-diag-yield.S} (100%)

diff --git a/s390x/Makefile b/s390x/Makefile
index a80db538..8d1cfc7c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -122,9 +122,9 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
 $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 
-$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
-$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-288.gbin
-$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-500.gbin
+$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-yield.gbin
+$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-288.gbin
+$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-500.gbin
 
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 096ac61f..fa4e5532 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -18,17 +18,17 @@ static struct vm vm;
 
 static void test_diag_500(void)
 {
-	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_500)[];
-	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_500)[];
-	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_500)[];
-	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_500)[];
-	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_500);
-	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_500);
+	extern const char SNIPPET_NAME_START(asm, pv_diag_500)[];
+	extern const char SNIPPET_NAME_END(asm, pv_diag_500)[];
+	extern const char SNIPPET_HDR_START(asm, pv_diag_500)[];
+	extern const char SNIPPET_HDR_END(asm, pv_diag_500)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_500);
+	int size_gbin = SNIPPET_LEN(asm, pv_diag_500);
 
 	report_prefix_push("diag 0x500");
 
-	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
-			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_500),
+			SNIPPET_HDR_START(asm, pv_diag_500),
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
@@ -70,17 +70,17 @@ static void test_diag_500(void)
 
 static void test_diag_288(void)
 {
-	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_288)[];
-	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_288)[];
-	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_288)[];
-	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_288)[];
-	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_288);
-	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_288);
+	extern const char SNIPPET_NAME_START(asm, pv_diag_288)[];
+	extern const char SNIPPET_NAME_END(asm, pv_diag_288)[];
+	extern const char SNIPPET_HDR_START(asm, pv_diag_288)[];
+	extern const char SNIPPET_HDR_END(asm, pv_diag_288)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_288);
+	int size_gbin = SNIPPET_LEN(asm, pv_diag_288);
 
 	report_prefix_push("diag 0x288");
 
-	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
-			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_288),
+			SNIPPET_HDR_START(asm, pv_diag_288),
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
@@ -111,17 +111,17 @@ static void test_diag_288(void)
 
 static void test_diag_yield(void)
 {
-	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_yield)[];
-	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_yield)[];
-	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_yield)[];
-	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_yield)[];
-	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_yield);
-	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_yield);
+	extern const char SNIPPET_NAME_START(asm, pv_diag_yield)[];
+	extern const char SNIPPET_NAME_END(asm, pv_diag_yield)[];
+	extern const char SNIPPET_HDR_START(asm, pv_diag_yield)[];
+	extern const char SNIPPET_HDR_END(asm, pv_diag_yield)[];
+	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_yield);
+	int size_gbin = SNIPPET_LEN(asm, pv_diag_yield);
 
 	report_prefix_push("diag yield");
 
-	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
-			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
+	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_yield),
+			SNIPPET_HDR_START(asm, pv_diag_yield),
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	/* 0x44 */
diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/pv-diag-288.S
similarity index 100%
rename from s390x/snippets/asm/snippet-pv-diag-288.S
rename to s390x/snippets/asm/pv-diag-288.S
diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/pv-diag-500.S
similarity index 100%
rename from s390x/snippets/asm/snippet-pv-diag-500.S
rename to s390x/snippets/asm/pv-diag-500.S
diff --git a/s390x/snippets/asm/snippet-pv-diag-yield.S b/s390x/snippets/asm/pv-diag-yield.S
similarity index 100%
rename from s390x/snippets/asm/snippet-pv-diag-yield.S
rename to s390x/snippets/asm/pv-diag-yield.S
-- 
2.34.1

