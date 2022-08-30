Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD015A6291
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiH3L4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 07:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiH3L4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 07:56:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCF1D21DB
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 04:56:30 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UBmanY004877
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ucKZxFw9PU/v9tcspyMKx8R/6SycFhm09Gk81Q7wMv0=;
 b=BW3FpryihoDRY9MuJwnNyBtRv3V5MPz0/1ZWX+G99eADmGxSreYl6019q9OR7UPF9+pq
 E5IirF5lNkWWDYCzW8iKKkgd92rjCcEogLDEq1xJQEF5N/JneJyxOO6z6qQ1CilrxpAK
 zOFvPrx2JVGbL3Gs4Z8oN3XZedpOCIDJKDHEb+wi5X0y5iUusmvYYMnW63iMdLSTwRW7
 Z8h7MKFtI4pdldOSdFxzf0b2hl8qgINwQgtfhQiqAhztoH1K/q2AJln3JRB3t/SLqUHX
 WV0DKxvJVxsjBkSj1CGGexdmk3eLccqrnYk7kn2fPKagazpePe5xnH561HQ5QvWDjZ7X vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9j0kg6cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:30 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27UBnldh009683
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9j0kg6bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 11:56:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UBpjdE007851;
        Tue, 30 Aug 2022 11:56:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3j7aw93nxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 11:56:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UBuObq39256542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 11:56:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22F5411C04A;
        Tue, 30 Aug 2022 11:56:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD8DE11C04C;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: add exittime tests
Date:   Tue, 30 Aug 2022 13:56:23 +0200
Message-Id: <20220830115623.515981-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220830115623.515981-1-nrb@linux.ibm.com>
References: <20220830115623.515981-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -Xj154cL2we2MvQUOlYjEoF_AqX1kVw7
X-Proofpoint-ORIG-GUID: 0cyILxMgc2uFBPDgBsoahT7dUgGRISsr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_06,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=993
 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208300057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/exittime.c    | 258 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 263 insertions(+)
 create mode 100644 s390x/exittime.c

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..5dcac244767f 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
+tests += $(TEST_DIR)/exittime.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/exittime.c b/s390x/exittime.c
new file mode 100644
index 000000000000..dc8329116b77
--- /dev/null
+++ b/s390x/exittime.c
@@ -0,0 +1,258 @@
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
+char pagebuf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+
+static void test_sigp_sense_running(long destcpu)
+{
+	smp_sigp(destcpu, SIGP_SENSE_RUNNING, 0, NULL);
+}
+
+static void test_nop(long ignore)
+{
+	asm volatile("nop" : : : "memory");
+}
+
+static void test_diag9c(long destcpu)
+{
+	asm volatile("diag %[destcpu],0,0x9c"
+		:
+		: [destcpu] "d" (destcpu)
+		:
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
+	asm volatile("diag 0,0,0x44" : : : );
+}
+
+static void test_stnsm(long ignore)
+{
+	int out;
+
+	asm volatile(
+		"stnsm %[out],0xff"
+		: [out] "=Q" (out)
+		:
+		: "memory"
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
+		:
+		: "memory"
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
+		:
+		: "memory"
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
+		:
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
+		:
+		: "memory"
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
+		:
+	);
+}
+
+static void test_stpx(long ignore)
+{
+	unsigned int prefix;
+
+	asm volatile(
+		"stpx %[prefix]"
+		: [prefix] "=S" (prefix)
+		:
+		: "memory"
+	);
+}
+
+static void test_stfl(long ignore)
+{
+	asm volatile(
+		"stfl 0" : : : "memory"
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
+		:
+		:
+	);
+}
+
+static void test_illegal(long ignore)
+{
+	expect_pgm_int();
+	asm volatile(
+		".word 0"
+		:
+		:
+		:
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
+	SCCB *sccb = (SCCB*) pagebuf;
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
+	char name[100];
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
+static uint64_t tod_to_us(uint64_t tod)
+{
+	return tod >> STCK_SHIFT_US;
+}
+
+int main(void)
+{
+	int i, j, k, testfunc_arg;
+	const int outer_iters = 100;
+	struct test const *current_test;
+	uint64_t start, end, elapsed, worst, best, total;
+
+	report_prefix_push("exittime");
+	report_pass("reporting total/best/worst of %d outer iterations", outer_iters);
+
+	for (i = 0; i < ARRAY_SIZE(exittime_tests); i++) {
+		current_test = &exittime_tests[i];
+		total = 0;
+		worst = 0;
+		best = -1;
+		report_prefix_pushf("%s", current_test->name);
+
+		testfunc_arg = current_test->arg;
+		if (current_test->setupfunc) {
+			testfunc_arg = current_test->setupfunc(testfunc_arg);
+		}
+
+		for (j = 0; j < outer_iters; j++) {
+			start = get_clock_fast();
+			for (k = 0; k < current_test->iters; k++)
+				current_test->testfunc(testfunc_arg);
+			end = get_clock_fast();
+			elapsed = end - start;
+			best = MIN(best, elapsed);
+			worst = MAX(worst, elapsed);
+			total += elapsed;
+		}
+		report_pass("iters/total/best/worst %lu/%lu/%lu/%lu us", current_test->iters, tod_to_us(total), tod_to_us(best), tod_to_us(worst));
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f7b1fc3dbca1..c11d1d987c82 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -185,3 +185,7 @@ groups = migration
 [migration-skey]
 file = migration-skey.elf
 groups = migration
+
+[exittime]
+file = exittime.elf
+smp = 2
-- 
2.36.1

