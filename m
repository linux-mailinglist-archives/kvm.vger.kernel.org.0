Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796385FC50F
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 14:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJLMLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 08:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJLMLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 08:11:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77A7814C5
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 05:11:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CBxxOf005044
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=B4LXuI/P9byP1G0fd5bXNJ21UaIJmSefgZ/BnUa1o8o=;
 b=GkGpqXeF54LScSBnTRWN60t0U+GAH2amNCbvgJsR2Qh3D4uTx878FvXnm+lKWFow9DNn
 aZrwWhCV1tLLwObIQik7njSOM4Lo0RoCDglehV9AMPMIqzWWizsJ123rhREnX2tG86Sv
 DcwmKaB4Bt+DKfB2ai3k/7fFV3WLaT8mCroSN3I833ZWHWgbLP5Is6p+OxIkWeRO8BJn
 AN8V0G5qxdsNFcLK0k6WhguKco4mSYwI+r/sooL7AhJXpAHywsUHDhLF+C7XwZPDbQYk
 QyDNGAznQHU7+iXo54axJPqWDlBO7T7zH6L+ffXgQUhQEUzHrxVjbOzov7159U4Qo8Fg rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5u6044w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:11:35 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CAMDw6016561
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:11:34 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5u6044v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 12:11:34 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CC6ldd024269;
        Wed, 12 Oct 2022 12:11:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3k30u9cfys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 12:11:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CCBSXp66978248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 12:11:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D33DFAE04D;
        Wed, 12 Oct 2022 12:11:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94D22AE051;
        Wed, 12 Oct 2022 12:11:28 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 12:11:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/1] s390x: add exittime tests
Date:   Wed, 12 Oct 2022 14:11:28 +0200
Message-Id: <20221012121128.1179252-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221012121128.1179252-1-nrb@linux.ibm.com>
References: <20221012121128.1179252-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qKmrq_Hn3rlCJxO7bgy8ATmQmwgqoPeU
X-Proofpoint-ORIG-GUID: -Hr5jDWUUn0ktmOw6DGvN8Ey3BpRxpdQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_06,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120079
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
 s390x/exittime.c    | 253 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   5 +
 3 files changed, 259 insertions(+)
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
index 000000000000..8e00a3c3559a
--- /dev/null
+++ b/s390x/exittime.c
@@ -0,0 +1,253 @@
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
+	uint64_t start, end, elapsed, worst, best, total, average;
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
+		if (current_test->setupfunc)
+			testfunc_arg = current_test->setupfunc(testfunc_arg);
+
+		for (j = 0; j < outer_iters; j++) {
+			stckf(&start);
+			for (k = 0; k < current_test->iters; k++)
+				current_test->testfunc(testfunc_arg);
+			stckf(&end);
+			elapsed = end - start;
+			best = MIN(best, elapsed);
+			worst = MAX(worst, elapsed);
+			total += elapsed;
+		}
+		average = total / outer_iters;
+		report_pass("iters/total/best/avg/worst %lu/%lu/%lu/%lu/%lu us", current_test->iters, tod_to_us(total), tod_to_us(best), tod_to_us(average), tod_to_us(worst));
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 2c04ae7c7c15..11cac3ca135d 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -185,6 +185,7 @@ groups = migration
 [migration-skey]
 file = migration-skey.elf
 groups = migration
+<<<<<<< HEAD
 
 [panic-loop-extint]
 file = panic-loop-extint.elf
@@ -201,3 +202,7 @@ timeout = 5
 [migration-sck]
 file = migration-sck.elf
 groups = migration
+
+[exittime]
+file = exittime.elf
+smp = 2
-- 
2.36.1

