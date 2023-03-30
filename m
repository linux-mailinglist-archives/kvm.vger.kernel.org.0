Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C956D03B1
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjC3LpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjC3Lo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:44:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC3C7692;
        Thu, 30 Mar 2023 04:44:33 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UA5CHu000789;
        Thu, 30 Mar 2023 11:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Jmn1eb4AJAv59DsdB/L1WZ1bSaO0fs7vOiW32aF/j2A=;
 b=bgVP1JShdCW9ZOY2XPTYE8S0lAGHw78Nyex41lHLr5IkITjuT4KsxYO5jYT+gRTjGBdw
 LKXmdTA/ZYNkE3qtyrDCxS7Nbh5PZ/CbVUrcq2LpE40w6fI6yN8bDrz2+q1jz1NEJCs3
 I71czkVC1evWpKkOzUf8JTLi+t6JPGJXhZO3c9HvMHQqgoAOGffSxEaBuofPmLbYFvNh
 4Y0UmqDUymWRzfxjc5fZlRqeB7yacXQXdYizZeEODNAszUeWei8WViy6Tuy7z6y0ppTa
 VpzhcQMt2EBVrOmEiV5TYrnJtvhdU2wWbBhcPU/NrO/9LF5LhjaK1A/A9AUXci4wA9Ec yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmkg2jaes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:46 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UBHTxE000568;
        Thu, 30 Mar 2023 11:43:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmkg2jaea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32TKaIMW028948;
        Thu, 30 Mar 2023 11:43:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fnu0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UBherm47776410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 11:43:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D41B020043;
        Thu, 30 Mar 2023 11:43:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BC0020040;
        Thu, 30 Mar 2023 11:43:40 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 11:43:40 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/5] s390x: Add guest 2 AP test
Date:   Thu, 30 Mar 2023 11:42:41 +0000
Message-Id: <20230330114244.35559-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330114244.35559-1-frankja@linux.ibm.com>
References: <20230330114244.35559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B09ED7n7aMi6rWKAQmwd7J-EdZWAzofx
X-Proofpoint-ORIG-GUID: sxadj7C6HcqdSXdOiKuniGYGgwX-aSBt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_06,2023-03-30_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300095
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test that checks the exceptions for the PQAP, NQAP and DQAP
adjunct processor (AP) crypto instructions.

Since triggering the exceptions doesn't require actual AP hardware,
this test can run without complicated setup.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   2 +
 s390x/ap.c          | 308 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 314 insertions(+)
 create mode 100644 s390x/ap.c

diff --git a/s390x/Makefile b/s390x/Makefile
index e8559a4e..f74241d5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
+tests += $(TEST_DIR)/ap.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
@@ -102,6 +103,7 @@ cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
 cflatobjs += lib/s390x/fault.o
+cflatobjs += lib/s390x/ap.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/ap.c b/s390x/ap.c
new file mode 100644
index 00000000..82ddb6d2
--- /dev/null
+++ b/s390x/ap.c
@@ -0,0 +1,308 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AP instruction G2 tests
+ *
+ * Copyright (c) 2023 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <interrupt.h>
+#include <bitops.h>
+#include <alloc_page.h>
+#include <asm/facility.h>
+#include <asm/time.h>
+#include <ap.h>
+
+/* For PQAP PGM checks where we need full control over the input */
+static void pqap(unsigned long grs[3])
+{
+	asm volatile(
+		"	lgr	0,%[r0]\n"
+		"	lgr	1,%[r1]\n"
+		"	lgr	2,%[r2]\n"
+		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
+		::  [r0] "d" (grs[0]), [r1] "d" (grs[1]), [r2] "d" (grs[2])
+		: "cc", "memory", "0", "1", "2");
+}
+
+static void test_pgms_pqap(void)
+{
+	unsigned long grs[3] = {};
+	struct pqap_r0 *r0 = (struct pqap_r0 *)grs;
+	uint8_t *data = alloc_page();
+	uint16_t pgm;
+	int fails = 0;
+	int i;
+
+	report_prefix_push("pqap");
+
+	/* Wrong FC code */
+	report_prefix_push("invalid fc");
+	r0->fc = 42;
+	expect_pgm_int();
+	pqap(grs);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	memset(grs, 0, sizeof(grs));
+	report_prefix_pop();
+
+	report_prefix_push("invalid gr0 bits");
+	for (i = 42; i < 6; i++) {
+		expect_pgm_int();
+		grs[0] = BIT(63 - i);
+		pqap(grs);
+		pgm = clear_pgm_int();
+
+		if (pgm != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("fail on bit %d", i);
+			fails++;
+		}
+	}
+	report(!fails, "All bits tested");
+	memset(grs, 0, sizeof(grs));
+	fails = 0;
+	report_prefix_pop();
+
+	report_prefix_push("alignment");
+	report_prefix_push("fc=4");
+	r0->fc = PQAP_QUERY_AP_CONF_INFO;
+	grs[2] = (unsigned long)data;
+	for (i = 1; i < 8; i++) {
+		expect_pgm_int();
+		grs[2]++;
+		pqap(grs);
+		pgm = clear_pgm_int();
+		if (pgm != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("fail on bit %d", i);
+			fails++;
+		}
+	}
+	report(!fails, "All bits tested");
+	report_prefix_pop();
+	report_prefix_push("fc=6");
+	r0->fc = PQAP_BEST_AP;
+	grs[2] = (unsigned long)data;
+	for (i = 1; i < 8; i++) {
+		expect_pgm_int();
+		grs[2]++;
+		pqap(grs);
+		pgm = clear_pgm_int();
+		if (pgm != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("fail on bit %d", i);
+			fails++;
+		}
+	}
+	report(!fails, "All bits tested");
+	report_prefix_pop();
+	report_prefix_pop();
+
+	free_page(data);
+	report_prefix_pop();
+}
+
+static void test_pgms_nqap(void)
+{
+	uint8_t gr0_zeroes_bits[] = {
+		32, 34, 35, 40
+	};
+	uint64_t gr0;
+	bool fail;
+	int i;
+
+	report_prefix_push("nqap");
+
+	/* Registers 0 and 1 are always used, the others are even/odd pairs */
+	report_prefix_push("spec");
+	report_prefix_push("r1");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ad0000,3,6\n"
+		: : : "cc", "memory", "0", "1", "2", "3");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("r2");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ad0000,2,7\n"
+		: : : "cc", "memory", "0", "1", "3", "4");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len==0");
+	expect_pgm_int();
+	asm volatile (
+		"xgr	0,0\n"
+		"xgr	5,5\n"
+		".insn	rre,0xb2ad0000,2,4\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len>12288");
+	expect_pgm_int();
+	asm volatile (
+		"xgr	5,5\n"
+		"lghi	5, 12289\n"
+		".insn	rre,0xb2ad0000,2,4\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("gr0_zero_bits");
+	fail = false;
+	for (i = 0; i < 4; i++) {
+		expect_pgm_int();
+		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
+		asm volatile (
+			"xgr	5,5\n"
+			"lghi	5, 128\n"
+			"lg	0, 0(%[val])\n"
+			".insn	rre,0xb2ad0000,2,4\n"
+			: : [val] "a" (&gr0)
+			: "cc", "memory", "0", "1", "2", "3", "4", "5");
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("setting gr0 bit %d did not result in a spec exception",
+				    gr0_zeroes_bits[i]);
+			fail = true;
+		}
+	}
+	report(!fail, "set bit specification pgms");
+	report_prefix_pop();
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
+static void test_pgms_dqap(void)
+{
+	uint8_t gr0_zeroes_bits[] = {
+		33, 34, 35, 40, 41
+	};
+	uint64_t gr0;
+	bool fail;
+	int i;
+
+	report_prefix_push("dqap");
+
+	/* Registers 0 and 1 are always used, the others are even/odd pairs */
+	report_prefix_push("spec");
+	report_prefix_push("r1");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ae0000,3,6\n"
+		: : : "cc", "memory", "0", "1", "2", "3");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("r2");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ae0000,2,7\n"
+		: : : "cc", "memory", "0", "1", "3", "4");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len==0");
+	expect_pgm_int();
+	asm volatile (
+		"xgr	0,0\n"
+		"xgr	5,5\n"
+		".insn	rre,0xb2ae0000,2,4\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len>12288");
+	expect_pgm_int();
+	asm volatile (
+		"xgr	5,5\n"
+		"lghi	5, 12289\n"
+		".insn	rre,0xb2ae0000,2,4\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "5");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("gr0_zero_bits");
+	fail = false;
+	for (i = 0; i < 5; i++) {
+		expect_pgm_int();
+		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
+		asm volatile (
+			"xgr	5,5\n"
+			"lghi	5, 128\n"
+			"lg	0, 0(%[val])\n"
+			".insn	rre,0xb2ae0000,2,4\n"
+			: : [val] "a" (&gr0)
+			: "cc", "memory", "0", "1", "2", "3", "4", "5");
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_info("setting gr0 bit %d did not result in a spec exception",
+				    gr0_zeroes_bits[i]);
+			fail = true;
+		}
+	}
+	report(!fail, "set bit specification pgms");
+	report_prefix_pop();
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
+static void test_priv(void)
+{
+	struct ap_config_info info = {};
+
+	report_prefix_push("privileged");
+
+	report_prefix_push("pqap");
+	expect_pgm_int();
+	enter_pstate();
+	ap_pqap_qci(&info);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	/*
+	 * Enqueue and dequeue take too many registers so a simple
+	 * inline assembly makes more sense than using the library
+	 * functions.
+	 */
+	report_prefix_push("nqap");
+	expect_pgm_int();
+	enter_pstate();
+	asm volatile (
+		".insn	rre,0xb2ad0000,0,2\n"
+		: : : "cc", "memory", "0", "1", "2", "3");
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("dqap");
+	expect_pgm_int();
+	enter_pstate();
+	asm volatile (
+		".insn	rre,0xb2ae0000,0,2\n"
+		: : : "cc", "memory", "0", "1", "2", "3");
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("ap");
+	if (!ap_check()) {
+		report_skip("AP instructions not available");
+		goto done;
+	}
+
+	test_priv();
+	test_pgms_pqap();
+	test_pgms_nqap();
+	test_pgms_dqap();
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index d97eb5e9..9b7c65c8 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -215,3 +215,7 @@ file = migration-skey.elf
 smp = 2
 groups = migration
 extra_params = -append '--parallel'
+
+[ap]
+file = ap.elf
+
-- 
2.34.1

