Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465BA5FE972
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJNHXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJNHXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:23:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7104619B67D
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 00:23:19 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29E6xBpK020729
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4YcnCDCSofthhzp19S65lB7pQrwog0PIeKN/cqVvOY8=;
 b=YNhLBzCs33OOOe/UbS1zL/fpD59uDXx0iPKb9ay+rg7b7SSvi/BjWSJ7Dg7nsa/rYauk
 UN7Qg/p2oXHBnvVq/ZEzYe2szIfd8lHZYnkwfLp43HJlGFX82mnCt4OPEtmoVAsN3c2L
 FVHoxJkOwAznIKwGbB/nlfs2gGl7Hqw+r2vGrL/REL1El9xLqNPd8OXuJ+w9o93T67jJ
 CEsNJ02rTL5C/pHDjy4R0CjSuuLMaMCFNTR6/SvLhSRm/veELFS+8M94KvkV/xtYJlwR
 nVKbRJicHY72JhyAJukzZAg8jXa1in79A1Olc5Ee4HTfs3CrNqrwwUCRMmARb8O0ZqPj ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6dc9g617-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:23:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29E6wnN0017407
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:23:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6dc9g60k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 07:23:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29E7Kq3h028103;
        Fri, 14 Oct 2022 07:23:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9gs3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 07:23:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29E7NC9Y60227918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 07:23:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE1F5A4054;
        Fri, 14 Oct 2022 07:23:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84206A405F;
        Fri, 14 Oct 2022 07:23:12 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Oct 2022 07:23:12 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 1/1] s390x: add exittime tests
Date:   Fri, 14 Oct 2022 09:23:12 +0200
Message-Id: <20221014072312.198606-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221014072312.198606-1-nrb@linux.ibm.com>
References: <20221014072312.198606-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lp4c8fnodRolp-o1N3rpThTmrPxH06s5
X-Proofpoint-ORIG-GUID: bQFimOWSJz4maPDqJ7hpnPX0ktjNQOg5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_02,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210140041
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
 s390x/exittime.c    | 296 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 301 insertions(+)
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
index 000000000000..6f01471ce082
--- /dev/null
+++ b/s390x/exittime.c
@@ -0,0 +1,296 @@
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
+#include <hardware.h>
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
+	bool supports_tcg;
+	/*
+	 * When non-null, will be called once before running the test loop.
+	 * Its return value will be given as argument to testfunc.
+	 */
+	long (*setupfunc)(long arg);
+	void (*testfunc)(long arg);
+	long arg;
+	long iters;
+} const exittime_tests[] = {
+	{"nop",                   true,  NULL,                   test_nop,                0, 200000 },
+	{"sigp sense running(0)", true,  NULL,                   test_sigp_sense_running, 0, 20000 },
+	{"sigp sense running(1)", true,  NULL,                   test_sigp_sense_running, 1, 20000 },
+	{"diag9c(self)",          false, setup_get_this_cpuaddr, test_diag9c,             0, 2000 },
+	{"diag9c(0)",             false, NULL,                   test_diag9c,             0, 2000 },
+	{"diag9c(1)",             false, NULL,                   test_diag9c,             1, 2000 },
+	{"diag44",                true,  NULL,                   test_diag44,             0, 2000 },
+	{"stnsm",                 true,  NULL,                   test_stnsm,              0, 200000 },
+	{"stosm",                 true,  NULL,                   test_stosm,              0, 200000 },
+	{"ssm",                   true,  setup_ssm,              test_ssm,                0, 200000 },
+	{"lctl4",                 true,  setup_lctl4,            test_lctl4,              0, 20000 },
+	{"stpx",                  true,  NULL,                   test_stpx,               0, 2000 },
+	{"stfl",                  true,  NULL,                   test_stfl,               0, 2000 },
+	{"epsw",                  true,  NULL,                   test_epsw,               0, 20000 },
+	{"illegal",               true,  NULL,                   test_illegal,            0, 2000 },
+	{"servc",                 true,  setup_servc,            test_servc,              0, 2000 },
+	{"stsi122",               true,  NULL,                   test_stsi,               1, 200 },
+	{"stsi222",               true,  NULL,                   test_stsi,               2, 200 },
+	{"stsi322",               true,  NULL,                   test_stsi,               3, 200 },
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
+static uint64_t tod_to_ns(uint64_t tod)
+{
+	return tod_to_us(tod * 1000);
+}
+
+static uint64_t normalize_iters(uint64_t value_to_normalize, uint64_t iters)
+{
+	return value_to_normalize * iters_to_normalize_to / iters;
+}
+
+static void report_iteration_result(struct test const* test, struct test_result const* test_result)
+{
+	uint64_t total = tod_to_ns(normalize_iters(test_result->total, test->iters)),
+		 best = tod_to_ns(normalize_iters(test_result->best, test->iters)),
+		 average = tod_to_ns(normalize_iters(test_result->average, test->iters)),
+		 worst = tod_to_ns(normalize_iters(test_result->worst, test->iters));
+
+	report_pass(
+		"total/best/avg/worst %lu.%03lu/%lu.%03lu/%lu.%03lu/%lu.%03lu us",
+		total / 1000, total % 1000,
+		best / 1000, best % 1000,
+		average / 1000, average % 1000,
+		worst / 1000, worst % 1000
+	);
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
+		if (host_is_tcg() && !current_test->supports_tcg) {
+			report_skip("not supported under TCG");
+			report_prefix_pop();
+			continue;
+		}
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

