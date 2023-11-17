Return-Path: <kvm+bounces-1965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C677B7EF50A
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52FA81F23442
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F756381BA;
	Fri, 17 Nov 2023 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GesCaqLm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE84D5D;
	Fri, 17 Nov 2023 07:20:01 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFGMq0023792;
	Fri, 17 Nov 2023 15:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=t13JTT466A/A29EtB1D3V/wekd72I7iQJmIq1hWvAto=;
 b=GesCaqLmuPJfiMrBk//YgiLaU+XMmT/ch+k8g5FcL1+btmn2djfiOXSbvhYw0L3qC/yT
 eLZygUsKBs4ILlxMX5OKcJur9K9wjqQ8J/6Dh805ICUtfETUFBFsC1kW9j5M0VxlFR2o
 OBqTPk4Q5NVUCgUX69GYZCxcRD7P5fsLEUpNLBcO7+S9EEqz3wwwnoBj1egQZRqQe+pb
 OkiYp2Zl92ikzqiRHTTwnRGvj6N64mhO3wTJWdBA/9K9k4NnODRGEBK3QpJNi07hBjdt
 PN3xVZSFiojNY56pyGquV9iDUOXwrHxx1nkv1Z+x612zulUXYAtV4cMV9Lf64x4VF1lK TA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueap083bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFGxFa025772;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueap083ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHD41BY023047;
	Fri, 17 Nov 2023 15:19:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uapn26ctt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJtDQ31064696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 791FB20040;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 347482004D;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:55 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 2/7] s390x: Add guest 2 AP test
Date: Fri, 17 Nov 2023 15:19:34 +0000
Message-Id: <20231117151939.971079-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117151939.971079-1-frankja@linux.ibm.com>
References: <20231117151939.971079-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5K0iN2h4pFz4VM-PF-oB2C0mhnTQLaIT
X-Proofpoint-ORIG-GUID: GsTbgUNo7aZfvpu4zQxy0Vg--K-LoIAS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=901 clxscore=1015
 mlxscore=0 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311170114

Add a test that checks the exceptions for the PQAP, NQAP and DQAP
adjunct processor (AP) crypto instructions.

Since triggering the exceptions doesn't require actual AP hardware,
this test can run without complicated setup.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/ap.c          | 309 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 313 insertions(+)
 create mode 100644 s390x/ap.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 2199eeba..ea760c6b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
 tests += $(TEST_DIR)/sie-dat.elf
+tests += $(TEST_DIR)/ap.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
diff --git a/s390x/ap.c b/s390x/ap.c
new file mode 100644
index 00000000..94f08783
--- /dev/null
+++ b/s390x/ap.c
@@ -0,0 +1,309 @@
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
+	/*
+	 * GR0 bits 41 - 47 are defined 0 and result in a
+	 * specification exception if set to 1.
+	 */
+	for (i = 0; i < 48 - 41; i++) {
+		grs[0] = BIT(63 - 47 + i);
+
+		expect_pgm_int();
+		pqap(grs);
+		pgm = clear_pgm_int();
+
+		if (pgm != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("fail on bit %d", 42 + i);
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
+	report(!fails, "All alignments tested");
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
+	report(!fails, "All alignments tested");
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
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("r2");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ad0000,2,7\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("both");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ad0000,3,7\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len==0");
+	expect_pgm_int();
+	asm volatile (
+		"xgr	0,0\n"
+		"xgr	5,5\n"
+		".insn	rre,0xb2ad0000,2,4\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("gr0_zero_bits");
+	fail = false;
+	for (i = 0; i < ARRAY_SIZE(gr0_zeroes_bits); i++) {
+		expect_pgm_int();
+		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
+		asm volatile (
+			"xgr	5,5\n"
+			"lghi	5, 128\n"
+			"lg	0, 0(%[val])\n"
+			".insn	rre,0xb2ad0000,2,4\n"
+			: : [val] "a" (&gr0)
+			: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_fail("setting gr0 bit %d did not result in a spec exception",
+				    gr0_zeroes_bits[i]);
+			fail = true;
+		}
+	}
+	report(!fail, "set bit gr0 pgms");
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
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("r2");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ae0000,2,7\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("both");
+	expect_pgm_int();
+	asm volatile (
+		".insn	rre,0xb2ae0000,3,7\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("len==0");
+	expect_pgm_int();
+	asm volatile (
+		"xgr	0,0\n"
+		"xgr	5,5\n"
+		".insn	rre,0xb2ae0000,2,4\n"
+		: : : "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("gr0_zero_bits");
+	fail = false;
+	for (i = 0; i < ARRAY_SIZE(gr0_zeroes_bits); i++) {
+		expect_pgm_int();
+		gr0 = BIT_ULL(63 - gr0_zeroes_bits[i]);
+		asm volatile (
+			"xgr	5,5\n"
+			"lghi	5, 128\n"
+			"lg	0, 0(%[val])\n"
+			".insn	rre,0xb2ae0000,2,4\n"
+			: : [val] "a" (&gr0)
+			: "cc", "memory", "0", "1", "2", "3", "4", "5", "6", "7");
+		if (clear_pgm_int() != PGM_INT_CODE_SPECIFICATION) {
+			report_info("setting gr0 bit %d did not result in a spec exception",
+				    gr0_zeroes_bits[i]);
+			fail = true;
+		}
+	}
+	report(!fail, "set bit pgms");
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
index f5024b6e..a2d6b197 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -383,3 +383,6 @@ extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
 
 [sie-dat]
 file = sie-dat.elf
+
+[ap]
+file = ap.elf
-- 
2.34.1


