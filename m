Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1B5FD5AA
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 09:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJMHmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 03:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiJMHmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 03:42:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F012C88A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 00:41:59 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29D7e2UB011917
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qoHbsPfJhPq65g43PXZGTd/hTUIsQHa14VE0SUkBUt4=;
 b=XSScUTesY2MYeBxLwB2MDub040TiuCtnXkQqKGiLWDemk8mM8/I7KlOdJmRfQTHuxeED
 n+lNTwUuXRTEStdXvWK56+sZE+6pLG6HjCfIOlHDiUlkkZnycIFGyNk3vOaQcMTbc+dW
 Ep8Wp/FZdfschTiZSWzs8P+FDD9MQslFmqWxvnQxtkBrROVRxmM6dPYn6m8Qn1UM4Lmq
 iV/EmdbWUEh3VOhhgweWPRf4OUAQ3rs/KQXDGivuPPDqW97l5FIzzhuqcFfIJgglWobc
 +32d0dAtlYnzgUow0cxKux7aWegRf/FwnRoaAMl+OHCp5mOqFxSo6JYtzHJNVTOOsmYC jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6bwpm6bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:41:58 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29D7fwkr019384
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:41:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6bwpm6aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 07:41:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29D7aiAD011558;
        Thu, 13 Oct 2022 07:41:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9f6w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 07:41:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29D7b6BB48759166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 07:37:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3E4911C04C;
        Thu, 13 Oct 2022 07:41:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F4F311C054;
        Thu, 13 Oct 2022 07:41:52 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Oct 2022 07:41:52 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 1/1] s390x: add exittime tests
Date:   Thu, 13 Oct 2022 09:41:52 +0200
Message-Id: <20221013074152.1412545-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221013074152.1412545-1-nrb@linux.ibm.com>
References: <20221013074152.1412545-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dE77ARXe6mYNdy1_3_8iF8SCManLSbEp
X-Proofpoint-ORIG-GUID: vch9nxkCj1G5sUKkOZFCq9EMuA883ugI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-13_06,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=990
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210130044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test to measure the execution time of several instructions. This
can be helpful in finding performance regressions in hypervisor code.

All tests are currently reported as PASS, since the baseline for their
execution time depends on the respective environment and since needs to
be determined on a case-by-case basis.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/exittime.c    | 311 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 316 insertions(+)
 create mode 100644 s390x/exittime.c

diff --git a/s390x/Makefile b/s390x/Makefile
index fba09bc2df3a..a28c6746cf55 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -37,6 +37,7 @@ tests += $(TEST_DIR)/migration-skey.elf
 tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
+tests += $(TEST_DIR)/exittime.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/exittime.c b/s390x/exittime.c
new file mode 100644
index 000000000000..6c94e262cdfc
--- /dev/null
+++ b/s390x/exittime.c
@@ -0,0 +1,311 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Measure run time of various instructions. Can be used to find runtime
+ * regressions of instructions which cause exits.
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <smp.h>
+#include <sclp.h>
+#include <asm/time.h>
+#include <asm/sigp.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+
+const uint64_t iters_to_normalize_to = 10000;
+char pagebuf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+
+static void test_sigp_sense_running(long destcpu)
+{
+	smp_sigp(destcpu, SIGP_SENSE_RUNNING, 0, NULL);
+}
+
+static void test_nop(long ignore)
+{
+	/* nops don't trap into the hypervisor, so let's test them for reference */
+	asm volatile(
+		"nop"
+		:
+		:
+		: "memory"
+	);
+}
+
+static void test_diag9c(long destcpu)
+{
+	asm volatile(
+		"diag %[destcpu],0,0x9c"
+		:
+		: [destcpu] "d" (destcpu)
+	);
+}
+
+static long setup_get_this_cpuaddr(long ignore)
+{
+	return stap();
+}
+
+static void test_diag44(long ignore)
+{
+	asm volatile(
+		"diag 0,0,0x44"
+	);
+}
+
+static void test_stnsm(long ignore)
+{
+	int out;
+
+	asm volatile(
+		"stnsm %[out],0xff"
+		: [out] "=Q" (out)
+	);
+}
+
+static void test_stosm(long ignore)
+{
+	int out;
+
+	asm volatile(
+		"stosm %[out],0"
+		: [out] "=Q" (out)
+	);
+}
+
+static long setup_ssm(long ignore)
+{
+	long system_mask = 0;
+
+	asm volatile(
+		"stosm %[system_mask],0"
+		: [system_mask] "=Q" (system_mask)
+	);
+
+	return system_mask;
+}
+
+static void test_ssm(long old_system_mask)
+{
+	asm volatile(
+		"ssm %[old_system_mask]"
+		:
+		: [old_system_mask] "Q" (old_system_mask)
+	);
+}
+
+static long setup_lctl4(long ignore)
+{
+	long ctl4_orig = 0;
+
+	asm volatile(
+		"stctg 4,4,%[ctl4_orig]"
+		: [ctl4_orig] "=S" (ctl4_orig)
+	);
+
+	return ctl4_orig;
+}
+
+static void test_lctl4(long ctl4_orig)
+{
+	asm volatile(
+		"lctlg 4,4,%[ctl4_orig]"
+		:
+		: [ctl4_orig] "S" (ctl4_orig)
+	);
+}
+
+static void test_stpx(long ignore)
+{
+	unsigned int prefix;
+
+	asm volatile(
+		"stpx %[prefix]"
+		: [prefix] "=Q" (prefix)
+	);
+}
+
+static void test_stfl(long ignore)
+{
+	asm volatile(
+		"stfl 0"
+		:
+		:
+		: "memory"
+	);
+}
+
+static void test_epsw(long ignore)
+{
+	long r1, r2;
+
+	asm volatile(
+		"epsw %[r1], %[r2]"
+		: [r1] "=d" (r1), [r2] "=d" (r2)
+	);
+}
+
+static void test_illegal(long ignore)
+{
+	expect_pgm_int();
+	asm volatile(
+		".word 0"
+	);
+	clear_pgm_int();
+}
+
+static long setup_servc(long arg)
+{
+	memset(pagebuf, 0, PAGE_SIZE);
+	return arg;
+}
+
+static void test_servc(long ignore)
+{
+	SCCB *sccb = (SCCB *) pagebuf;
+
+	sccb->h.length = 8;
+	servc(0, (unsigned long) sccb);
+}
+
+static void test_stsi(long fc)
+{
+	stsi(pagebuf, fc, 2, 2);
+}
+
+struct test {
+	const char *name;
+	/*
+	 * When non-null, will be called once before running the test loop.
+	 * Its return value will be given as argument to testfunc.
+	 */
+	long (*setupfunc)(long arg);
+	void (*testfunc)(long arg);
+	long arg;
+	long iters;
+} const exittime_tests[] = {
+	{"nop",                   NULL,                   test_nop,                0, 200000 },
+	{"sigp sense running(0)", NULL,                   test_sigp_sense_running, 0, 20000 },
+	{"sigp sense running(1)", NULL,                   test_sigp_sense_running, 1, 20000 },
+	{"diag9c(self)",          setup_get_this_cpuaddr, test_diag9c,             0, 2000 },
+	{"diag9c(0)",             NULL,                   test_diag9c,             0, 2000 },
+	{"diag9c(1)",             NULL,                   test_diag9c,             1, 2000 },
+	{"diag44",                NULL,                   test_diag44,             0, 2000 },
+	{"stnsm",                 NULL,                   test_stnsm,              0, 200000 },
+	{"stosm",                 NULL,                   test_stosm,              0, 200000 },
+	{"ssm",                   setup_ssm,              test_ssm,                0, 200000 },
+	{"lctl4",                 setup_lctl4,            test_lctl4,              0, 20000 },
+	{"stpx",                  NULL,                   test_stpx,               0, 2000 },
+	{"stfl",                  NULL,                   test_stfl,               0, 2000 },
+	{"epsw",                  NULL,                   test_epsw,               0, 20000 },
+	{"illegal",               NULL,                   test_illegal,            0, 2000 },
+	{"servc",                 setup_servc,            test_servc,              0, 2000 },
+	{"stsi122",               NULL,                   test_stsi,               1, 200 },
+	{"stsi222",               NULL,                   test_stsi,               2, 200 },
+	{"stsi322",               NULL,                   test_stsi,               3, 200 },
+};
+
+struct test_result {
+	uint64_t total;
+	uint64_t best;
+	uint64_t average;
+	uint64_t worst;
+};
+
+static uint64_t tod_to_us(uint64_t tod)
+{
+	return tod >> STCK_SHIFT_US;
+}
+
+static uint64_t normalize_iters(uint64_t value_to_normalize, struct test const* test)
+{
+	return value_to_normalize / test->iters * iters_to_normalize_to;
+}
+
+static void normalize_result(struct test const* test, struct test_result const* test_result_in, struct test_result *test_result_out)
+{
+	test_result_out->total = normalize_iters(test_result_in->total, test);
+	test_result_out->best = normalize_iters(test_result_in->best, test);
+	test_result_out->average = normalize_iters(test_result_in->average, test);
+	test_result_out->worst = normalize_iters(test_result_in->worst, test);
+}
+
+static void report_test_result(uint64_t iters, struct test_result const* test_result)
+{
+	report_pass(
+		"iters/total/best/avg/worst %lu/%lu/%lu/%lu/%lu us",
+		iters,
+		tod_to_us(test_result->total),
+		tod_to_us(test_result->best),
+		tod_to_us(test_result->average),
+		tod_to_us(test_result->worst)
+	);
+}
+
+static void report_iteration_result(struct test const* test, struct test_result const* test_result)
+{
+	struct test_result test_result_normalized;
+
+	/*
+	 * The test result as measured. Useful to compare the runtime of a
+	 * single instruction in two runs, i.e. to identify performance
+	 * regressions.
+	 */
+	report_prefix_push("non-normalized");
+	report_test_result(test->iters, test_result);
+	report_prefix_pop();
+
+	/*
+	 * Normalize to a number of inner iterations. Useful to compare the
+	 * runtime of two instructions in a single run (i.e. instruction A is X
+	 * times faster than B).
+	 */
+	report_prefix_push("normalized");
+	normalize_result(test, test_result, &test_result_normalized);
+	report_test_result(iters_to_normalize_to, &test_result_normalized);
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	int i, j, k, testfunc_arg;
+	const int outer_iters = 100;
+	struct test const *current_test;
+	struct test_result result;
+	uint64_t start, end, elapsed;
+
+	report_prefix_push("exittime");
+	report_info("reporting total/best/worst of %d outer iterations", outer_iters);
+
+	for (i = 0; i < ARRAY_SIZE(exittime_tests); i++) {
+		current_test = &exittime_tests[i];
+		result.total = 0;
+		result.worst = 0;
+		result.best = -1;
+		report_prefix_pushf("%s", current_test->name);
+
+		testfunc_arg = current_test->arg;
+		if (current_test->setupfunc)
+			testfunc_arg = current_test->setupfunc(testfunc_arg);
+
+		for (j = 0; j < outer_iters; j++) {
+			stckf(&start);
+			for (k = 0; k < current_test->iters; k++)
+				current_test->testfunc(testfunc_arg);
+			stckf(&end);
+			elapsed = end - start;
+			result.best = MIN(result.best, elapsed);
+			result.worst = MAX(result.worst, elapsed);
+			result.total += elapsed;
+		}
+		result.average = result.total / outer_iters;
+		report_iteration_result(current_test, &result);
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 2c04ae7c7c15..feb9abf03745 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -201,3 +201,7 @@ timeout = 5
 [migration-sck]
 file = migration-sck.elf
 groups = migration
+
+[exittime]
+file = exittime.elf
+smp = 2
-- 
2.36.1

