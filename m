Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59C05A9B47
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiIAPKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 11:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiIAPKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 11:10:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5FB19281
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 08:10:04 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281EZ2Lx019287
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 15:10:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z3WjtSp8cZwfyhVgIoM48cJ0kpIpHcW3rWv74xhDG7k=;
 b=gYQ4DcniNPR+a+tbpVw8sFy2TkWAJdnFuW50TJLuqpl0TOgPfoepgYRlAohDYPxIHYa1
 hbjUEfKpD8r2KflXjOYYD+eIm1y9eEjyzKxAVReWdbZx2TApHYTmunSCMz0DWNyegv+y
 aJeK0A9sYJrGCfs3kpC5DkDbSA29uUvU8UMbXBBb7HUvEMjlrCeKQoE5vnVxYonUCfXz
 qHipiqIhFYNytMWXWyZZe8cLNqOWKYy3QaLnxeO+kTysHq+rR+wI4GbPQy3e21A2S/jG
 D2hxDqghSlBSyMavDMK3TkxQ8tLved2BjqVi/nHd7TvBkcwyyx1JYc93XgAHeKF1Iuaq oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jax0mcnda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 15:10:03 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 281F5mOl010690
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 15:10:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jax0mcnb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 15:10:02 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 281F60kE014124;
        Thu, 1 Sep 2022 15:10:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3j8hkabwyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 15:10:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281FAJV435652094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 15:10:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16056AE045;
        Thu,  1 Sep 2022 15:09:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE710AE053;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: add exittime tests
Date:   Thu,  1 Sep 2022 17:09:56 +0200
Message-Id: <20220901150956.1075828-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220901150956.1075828-1-nrb@linux.ibm.com>
References: <20220901150956.1075828-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HB60kxOIWa8bIgCIKPXlGYG1M3jgZTGD
X-Proofpoint-ORIG-GUID: qz8ZVNbcUTyFlEWx7ThECqYz6du4tidE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=954
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010068
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
 s390x/exittime.c    | 255 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 260 insertions(+)
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
index 000000000000..543c82ff3906
--- /dev/null
+++ b/s390x/exittime.c
@@ -0,0 +1,255 @@
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
+	asm volatile("diag 0,0,0x44");
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
+		:
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
+		:
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
+		: [prefix] "=Q" (prefix)
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
+		if (current_test->setupfunc)
+			testfunc_arg = current_test->setupfunc(testfunc_arg);
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

