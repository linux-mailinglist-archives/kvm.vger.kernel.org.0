Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851C56EA967
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjDULjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjDULjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:39:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444061727;
        Fri, 21 Apr 2023 04:38:35 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LBXATh022152;
        Fri, 21 Apr 2023 11:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=240hch4l3N6CNEKqjo7/3vdjo6Dat6MzH04SeI8Vnek=;
 b=FDl0Wn3A4VjzspJSzr+ov/XmU8w/1bVI3Y6qYjxc0aBVrCgGTgHObfRzs6fD/AC0HjrZ
 snEJTd8ZtUYP2RDxA7riOYrXnwjRQ2lgT+vDArMVBdZ6IKJ26XMJdbrC+wpPB5rhGS9+
 lSsTZd+fC4/8erGFE+QAJGcjoUis6+XoZUjFgjFMUbnmuepXmjkGTyGFVLTuMy17YHrM
 WVLnNCu3gbPQSZY4q+2ntDz4UsTOS1+0pO7vqs6g97giFZsW/vq1Xj5MyyXPBzZpA2tJ
 TmMAsSzbv8LvAZm8HYPTub1snlV1TMMgZnbwvvN3N0t1L7IHNu201vCH04xd/WBOA8db Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3scyrtdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:25 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LBYZXr002195;
        Fri, 21 Apr 2023 11:37:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3scyrtbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33KLakZB002549;
        Fri, 21 Apr 2023 11:37:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fm0yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 11:37:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LBbJei29753870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 11:37:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA2822004E;
        Fri, 21 Apr 2023 11:37:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECAD420043;
        Fri, 21 Apr 2023 11:37:18 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 11:37:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/7] s390x: pv-diags: Drop snippet from snippet names
Date:   Fri, 21 Apr 2023 11:36:43 +0000
Message-Id: <20230421113647.134536-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421113647.134536-1-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yczWsqP91wyJthRVMNGfgYEAKNdzM0wW
X-Proofpoint-ORIG-GUID: lsngeCX8-QCMBLhKK3fh6LXW9GlcRFGm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_04,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304210091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's a bit redundant.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

