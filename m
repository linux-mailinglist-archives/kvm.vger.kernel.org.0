Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353A49778C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfHUKsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 06:48:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726984AbfHUKsY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Aug 2019 06:48:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LAmGhS039206
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:23 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uh3mca9gj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:22 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 21 Aug 2019 11:48:19 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 11:48:16 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LAlt1039780768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 10:47:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A581AE056;
        Wed, 21 Aug 2019 10:48:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65537AE045;
        Wed, 21 Aug 2019 10:48:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.179])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 10:48:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: Diag288 test
Date:   Wed, 21 Aug 2019 12:47:34 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821104736.1470-1-frankja@linux.ibm.com>
References: <20190821104736.1470-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082110-0012-0000-0000-000003411152
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082110-0013-0000-0000-0000217B3877
Message-Id: <20190821104736.1470-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small test for the watchdog via diag288.

Minimum timer value is 15 (seconds) and the only supported action with
QEMU is restart.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |   1 +
 s390x/Makefile           |   1 +
 s390x/diag288.c          | 131 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 ++
 4 files changed, 137 insertions(+)
 create mode 100644 s390x/diag288.c

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index d2cd727..4bbb428 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -15,6 +15,7 @@ struct psw {
 	uint64_t	addr;
 };
 
+#define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 
diff --git a/s390x/Makefile b/s390x/Makefile
index 574a9a2..3453373 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -12,6 +12,7 @@ tests += $(TEST_DIR)/vector.elf
 tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
 tests += $(TEST_DIR)/cpumodel.elf
+tests += $(TEST_DIR)/diag288.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/diag288.c b/s390x/diag288.c
new file mode 100644
index 0000000..c129b6a
--- /dev/null
+++ b/s390x/diag288.c
@@ -0,0 +1,131 @@
+/*
+ * Timer Event DIAG288 test
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+
+struct lowcore *lc = (struct lowcore *)0x0;
+
+#define CODE_INIT	0
+#define CODE_CHANGE	1
+#define CODE_CANCEL	2
+
+#define ACTION_RESTART	0
+
+static inline void diag288(unsigned long code, unsigned long time,
+			   unsigned long action)
+{
+	register unsigned long fc asm("0") = code;
+	register unsigned long tm asm("1") = time;
+	register unsigned long ac asm("2") = action;
+
+	asm volatile("diag %0,%2,0x288"
+		     : : "d" (fc), "d" (tm), "d" (ac));
+}
+
+static void test_specs(void)
+{
+	report_prefix_push("specification");
+
+	report_prefix_push("uneven");
+	expect_pgm_int();
+	asm volatile("diag %r1,%r2,0x288");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("unsupported action");
+	expect_pgm_int();
+	diag288(CODE_INIT, 15, 42);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("unsupported function");
+	expect_pgm_int();
+	diag288(42, 15, ACTION_RESTART);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("no init");
+	expect_pgm_int();
+	diag288(CODE_CANCEL, 15, ACTION_RESTART);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("min timer");
+	expect_pgm_int();
+	diag288(CODE_INIT, 14, ACTION_RESTART);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
+static void test_priv(void)
+{
+	report_prefix_push("privileged");
+	expect_pgm_int();
+	enter_pstate();
+	diag288(CODE_INIT, 15, ACTION_RESTART);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static inline void get_tod_clock_ext(char *clk)
+{
+	typedef struct { char _[16]; } addrtype;
+
+	asm volatile("stcke %0" : "=Q" (*(addrtype *) clk) : : "cc");
+}
+
+static inline unsigned long long get_tod_clock(void)
+{
+	char clk[16];
+
+	get_tod_clock_ext(clk);
+	return *((unsigned long long *)&clk[1]);
+}
+
+static void test_bite(void)
+{
+	unsigned long time;
+	uint64_t mask;
+
+	/* If watchdog doesn't bite, the cpu timer does */
+	time = get_tod_clock();
+	time += (uint64_t)(16000 * 1000) << 12;
+	asm volatile("sckc %0" : : "Q" (time));
+	ctl_set_bit(0, 11);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+
+	/* Arm watchdog */
+	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
+	diag288(CODE_INIT, 15, ACTION_RESTART);
+	asm volatile("		larl	%r0, 1f\n"
+		     "		stg	%r0, 424\n"
+		     "0:	nop\n"
+		     "		j	0b\n"
+		     "1:");
+	report("restart", true);
+	return;
+}
+
+int main(void)
+{
+	report_prefix_push("diag288");
+	test_priv();
+	test_specs();
+	test_bite();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index db58bad..9dd288a 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -64,3 +64,7 @@ file = iep.elf
 
 [cpumodel]
 file = cpumodel.elf
+
+[diag288]
+file = diag288.elf
+extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
-- 
2.17.0

