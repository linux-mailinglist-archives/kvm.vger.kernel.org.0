Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A117BF677
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjJJIvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjJJIvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:51:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1131CB7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 01:51:19 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A8k4Ep020345
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3D0CbE6WYDMx7GxiLswZEJn/rW4fCetV57TVns8ea5M=;
 b=mzOa13PzZml7oPIaDu1x+FFgt0lhDYLrwwU0vPbfcMsIX2IiGGu5P0rOGb/cyE3rH3io
 6JxUIqRfyd0Wx9EGB4BnJU/dRZqbmrpfA5vmkf4FKQcXPkwXnzBdWIK2rLIPViFZnH5Q
 g1fW8uF3m+wT2s0iJfWermS160nnn08jdQekIOFXcrzCftnVeZaFdOs+/0f+pzKZ7ISE
 xVNIOW/bDEXRd7FB3AXEt6ajdw2ei+FiJo+sIXMKJ9PoLMfMWi/Z9HkIl/LwJ8P8Gzz9
 V5osE/V7jqugESsGQJB47pnhfFAGjOYcjARRZ3+OHq+1laTvEawNnr0jA8E5SzeFlPcN Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3ct089g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:18 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A8lKhm024659
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:51:13 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn3ct07ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:12 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6jnhN028191;
        Tue, 10 Oct 2023 08:51:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkj1xybym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 08:51:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A8p5HY7144172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 08:51:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A64F42004D;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 729972005A;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 08:51:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/7] s390x: Add guest 2 AP test
Date:   Tue, 10 Oct 2023 08:49:31 +0000
Message-Id: <20231010084936.70773-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010084936.70773-1-frankja@linux.ibm.com>
References: <20231010084936.70773-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i7iVR3BwarXe_mOwqLGpGpJvGaVXvcaa
X-Proofpoint-GUID: 7yYrK0CyeUHAjV_oMUnPLAiq8qI-4Pc7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=696 mlxscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 s390x/Makefile      |   1 +
 s390x/ap.c          | 309 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 313 insertions(+)
 create mode 100644 s390x/ap.c

diff --git a/s390x/Makefile b/s390x/Makefile
index d9abe5c1..d75845b6 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -41,6 +41,7 @@ tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
 tests += $(TEST_DIR)/ex.elf
 tests += $(TEST_DIR)/topology.elf
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
index 68e119e4..2f190a22 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -247,3 +247,6 @@ file = topology.elf
 [topology-2]
 file = topology.elf
 extra_params = -cpu max,ctop=on -smp sockets=31,cores=8,maxcpus=248  -append '-sockets 31 -cores 8'
+
+[ap]
+file = ap.elf
-- 
2.34.1

