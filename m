Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF463A19CA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 14:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfH2MPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 08:15:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbfH2MPd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Aug 2019 08:15:33 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TC7wFG090343
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 08:15:31 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2updvy1h12-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 08:15:31 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 29 Aug 2019 13:15:29 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 13:15:26 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TCFPP961210742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 12:15:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B68A5204F;
        Thu, 29 Aug 2019 12:15:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.55.105])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2C15E52051;
        Thu, 29 Aug 2019 12:15:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 6/6] s390x: SMP test
Date:   Thu, 29 Aug 2019 14:14:59 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190829121459.1708-1-frankja@linux.ibm.com>
References: <20190829121459.1708-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082912-0012-0000-0000-000003443F0D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082912-0013-0000-0000-0000217E7F8E
Message-Id: <20190829121459.1708-7-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Testing SIGP emulation for the following order codes:
* start
* stop
* restart
* set prefix
* store status
* stop and store status
* reset
* initial reset
* external call
* emegergency call

restart and set prefix are part of the library and needed to start
other cpus.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile |   1 +
 s390x/smp.c    | 242 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+)
 create mode 100644 s390x/smp.c

diff --git a/s390x/Makefile b/s390x/Makefile
index d83dd0b..3744372 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -15,6 +15,7 @@ tests += $(TEST_DIR)/cpumodel.elf
 tests += $(TEST_DIR)/diag288.elf
 tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
+tests += $(TEST_DIR)/smp.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/smp.c b/s390x/smp.c
new file mode 100644
index 0000000..9363cd2
--- /dev/null
+++ b/s390x/smp.c
@@ -0,0 +1,242 @@
+/*
+ * Tests sigp emulation
+ *
+ * Copyright 2019 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <asm/facility.h>
+#include <asm-generic/barrier.h>
+#include <asm/sigp.h>
+
+#include <smp.h>
+#include <alloc_page.h>
+
+static int t = 0;
+
+static void cpu_loop(void)
+{
+	for (;;) {}
+}
+
+static void test_func(void)
+{
+	t = 1;
+	cpu_loop();
+}
+
+static void test_start(void)
+{
+	struct psw psw;
+	psw.mask =  extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+
+	smp_cpu_setup(1, psw);
+	while (!t) {
+		mb();
+	}
+	report("start", 1);
+}
+
+static void test_stop(void)
+{
+	int i = 0;
+
+	smp_cpu_stop(1);
+	/*
+	 * The smp library waits for the CPU to shut down, but let's
+	 * also do it here, so we don't rely on the library
+	 * implementation
+	 */
+	while (!smp_cpu_stopped(1)) {}
+	t = 0;
+	/* Let's leave some time for cpu #2 to change t */
+	for (; i < 0x100000; i++) {}
+	report("stop", !t);
+}
+
+static void test_stop_store_status(void)
+{
+	struct cpu *cpu = smp_cpu_from_addr(1);
+	struct lowcore *lc = (void *)0x0;
+
+	smp_cpu_stop_store_status(1);
+	mb();
+	report("stop store status",
+	       lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore);
+}
+
+static void test_store_status(void)
+{
+	struct cpu_status *status = alloc_pages(0);
+	uint32_t r;
+
+	report_prefix_push("status");
+	memset(status, 0, PAGE_SIZE);
+
+	smp_cpu_restart(1);
+	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
+	report("not stopped", r == SIGP_STATUS_INCORRECT_STATE);
+
+	memset(status, 0, PAGE_SIZE);
+	smp_cpu_stop(1);
+	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
+	while (!status->prefix) {}
+	report("store status", 1);
+	free_pages(status, PAGE_SIZE);
+	report_prefix_pop();
+}
+
+static void ecall(void)
+{
+	unsigned long mask;
+	struct lowcore *lc = (void *)0x0;
+
+	ctl_set_bit(0, 13);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+	expect_ext_int();
+	t = 1;
+	while (lc->ext_int_code != 0x1202) {mb();}
+	report("ecall", 1);
+	t = 1;
+}
+
+static void test_ecall(void)
+{
+	struct psw psw;
+	psw.mask =  extract_psw_mask();
+	psw.addr = (unsigned long)ecall;
+
+	report_prefix_push("ecall");
+	t = 0;
+	smp_cpu_destroy(1);
+
+	mb();
+	smp_cpu_setup(1, psw);
+	while (!t) {
+		mb();
+	}
+	t = 0;
+	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
+	while(!t) {mb();}
+	smp_cpu_stop(1);
+	report_prefix_pop();
+}
+
+static void emcall(void)
+{
+	unsigned long mask;
+	struct lowcore *lc = (void *)0x0;
+
+	ctl_set_bit(0, 14);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+	expect_ext_int();
+	t = 1;
+	while (lc->ext_int_code != 0x1201) {mb();}
+	report("ecall", 1);
+	t = 1;
+}
+
+static void test_emcall(void)
+{
+	struct psw psw;
+	psw.mask =  extract_psw_mask();
+	psw.addr = (unsigned long)emcall;
+
+	report_prefix_push("emcall");
+	t = 0;
+	smp_cpu_destroy(1);
+
+	mb();
+	smp_cpu_setup(1, psw);
+	while (!t) {
+		mb();
+	}
+	t = 0;
+	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	while(!t) {mb();}
+	smp_cpu_stop(1);
+	report_prefix_pop();
+}
+
+static void test_reset_initial(void)
+{
+	struct cpu_status *status = alloc_pages(0);
+	struct psw psw;
+
+	psw.mask =  extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+
+	report_prefix_push("reset initial");
+	smp_cpu_setup(1, psw);
+
+	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
+
+	report_prefix_push("clear");
+	report("psw", !status->psw.mask && !status->psw.addr);
+	report("prefix", !status->prefix);
+	report("fpc", !status->fpc);
+	report("cpu timer", !status->cputm);
+	report("todpr", !status->todpr);
+	report_prefix_pop();
+
+	report_prefix_push("initialized");
+	report("cr0 == 0xE0", status->crs[0] == 0xE0UL);
+	report("cr14 == 0xC2000000", status->crs[14] == 0xC2000000UL);
+	report_prefix_pop();
+
+	report("cpu stopped", smp_cpu_stopped(1));
+	free_pages(status, PAGE_SIZE);
+	report_prefix_pop();
+}
+
+static void test_reset(void)
+{
+	struct psw psw;
+
+	psw.mask =  extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+
+	report_prefix_push("cpu reset");
+	smp_cpu_setup(1, psw);
+
+	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
+	report("cpu stopped", smp_cpu_stopped(1));
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("smp");
+
+	if (smp_query_num_cpus() == 1) {
+		report_abort("need at least 2 cpus for this test");
+		goto done;
+	}
+
+	test_start();
+	test_stop();
+	test_stop_store_status();
+	test_store_status();
+	test_ecall();
+	test_emcall();
+	test_reset();
+	test_reset_initial();
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
-- 
2.17.0

