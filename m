Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C74F74F186
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjGKOQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbjGKOQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B751989
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:32 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEF1Sn031644;
        Tue, 11 Jul 2023 14:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=sdO356FLpMBoNnzawuemZ4/KnwSpcXiMMJSodrHTaUQ=;
 b=DBgBi0LQBZuz3xnEdSjjbABNaoKYPvMtegpxslpO22kGZC2kQLBzNfWd/5AOJ2qN0TqZ
 CI97d3r0exf7kE+mMue/0p/4b40Uikem52hwdbM2eNkmLL8ZX5Go8jdd8cFr9S0HUgfb
 sjVOhN5t/9YU+8I5ZzxHF8RxOs8YWqYN1A8SWTSX8wfgVJKKNHEux0cvo4N7qPnjFVxv
 YbAZElyKb5a4KOnZOn469DNbiD/58jz5S026ewgEr7xp3IPBFerg8coVobGbXpJBvTux
 NrXmUCuO2idJKcw/RWhfTeoWGT/SCWVuXIgIkwsG8jNPnqa1KSytn15Hdv9Nc7p7OmNG QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8p482fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:23 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEFbIb002215;
        Tue, 11 Jul 2023 14:16:21 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8p4829x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B5uOlt030259;
        Tue, 11 Jul 2023 14:16:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59tty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGDQ07930254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D24A20049;
        Tue, 11 Jul 2023 14:16:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C32A2005A;
        Tue, 11 Jul 2023 14:16:13 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:13 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 06/22] s390x: pv-diags: Drop snippet from snippet names
Date:   Tue, 11 Jul 2023 16:15:39 +0200
Message-ID: <20230711141607.40742-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: baVdty1daqnPyBenBVX_qPnJBK78pTkU
X-Proofpoint-ORIG-GUID: g-nzaIZf0U-LTrXAXLLJJ23lCgVaFAkw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

It's a bit redundant.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-5-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                                |  6 +--
 .../{snippet-pv-diag-288.S => pv-diag-288.S}  |  0
 .../{snippet-pv-diag-500.S => pv-diag-500.S}  |  0
 ...nippet-pv-diag-yield.S => pv-diag-yield.S} |  0
 s390x/pv-diags.c                              | 48 +++++++++----------
 5 files changed, 27 insertions(+), 27 deletions(-)
 rename s390x/snippets/asm/{snippet-pv-diag-288.S => pv-diag-288.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-500.S => pv-diag-500.S} (100%)
 rename s390x/snippets/asm/{snippet-pv-diag-yield.S => pv-diag-yield.S} (100%)

diff --git a/s390x/Makefile b/s390x/Makefile
index a80db53..8d1cfc7 100644
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
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 096ac61..fa4e553 100644
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
-- 
2.41.0

