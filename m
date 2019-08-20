Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5951F95CB4
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 12:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfHTK4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 06:56:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729684AbfHTK4N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 06:56:13 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KArreJ091470
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 06:56:12 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ugekq2nv5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 06:56:12 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 20 Aug 2019 11:56:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 11:56:08 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KAu7OB40108218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 10:56:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 010074C046;
        Tue, 20 Aug 2019 10:56:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FBDD4C044;
        Tue, 20 Aug 2019 10:56:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 10:56:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 2/3] s390x: Diag288 test
Date:   Tue, 20 Aug 2019 12:55:49 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190820105550.4991-1-frankja@linux.ibm.com>
References: <20190820105550.4991-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082010-0028-0000-0000-00000391A84A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082010-0029-0000-0000-00002453CBBC
Message-Id: <20190820105550.4991-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small test for the watchdog via diag288.

Minimum timer value is 15 (seconds) and the only supported action with
QEMU is restart.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/diag288.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 ++
 3 files changed, 116 insertions(+)
 create mode 100644 s390x/diag288.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1f21ddb..b654c56 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
 tests += $(TEST_DIR)/vector.elf
 tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
+tests += $(TEST_DIR)/diag288.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/diag288.c b/s390x/diag288.c
new file mode 100644
index 0000000..5abcec4
--- /dev/null
+++ b/s390x/diag288.c
@@ -0,0 +1,111 @@
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
+struct lowcore *lc = (void *)0x0;
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
+static inline void diag288_uneven(void)
+{
+	register unsigned long fc asm("1") = 0;
+	register unsigned long time asm("1") = 15;
+	register unsigned long action asm("2") = 0;
+
+	asm volatile("diag %0,%2,0x288"
+		     : : "d" (fc), "d" (time), "d" (action));
+}
+
+static void test_specs(void)
+{
+	report_prefix_push("spec ex");
+
+	report_prefix_push("uneven");
+	expect_pgm_int();
+	diag288_uneven();
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("unsup act");
+	expect_pgm_int();
+	diag288(CODE_INIT, 15, 42);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("unsup fctn");
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
+	diag288(0, 15, 0);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_bite(void)
+{
+	if (lc->restart_old_psw.addr) {
+		report("restart", true);
+		return;
+	}
+	lc->restart_new_psw.addr = (uint64_t)test_bite;
+	diag288(CODE_INIT, 15, ACTION_RESTART);
+	while(1) {};
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
index 546b1f2..ca10f38 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -61,3 +61,7 @@ file = gs.elf
 
 [iep]
 file = iep.elf
+
+[diag288]
+file = diag288.elf
+extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
\ No newline at end of file
-- 
2.17.0

