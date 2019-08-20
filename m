Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189C595CB7
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 12:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfHTK4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 06:56:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728842AbfHTK4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 06:56:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KAr2Bg115168
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 06:56:13 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uge7a40by-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 06:56:13 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 20 Aug 2019 11:56:11 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 11:56:08 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KAu8em42598470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 10:56:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BC94C04E;
        Tue, 20 Aug 2019 10:56:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ADA14C046;
        Tue, 20 Aug 2019 10:56:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 10:56:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 3/3] s390x: STSI tests
Date:   Tue, 20 Aug 2019 12:55:50 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190820105550.4991-1-frankja@linux.ibm.com>
References: <20190820105550.4991-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082010-0012-0000-0000-00000340AA37
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082010-0013-0000-0000-0000217ACDD4
Message-Id: <20190820105550.4991-4-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=938 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For now let's concentrate on the error conditions.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/stsi.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   5 +-
 3 files changed, 128 insertions(+), 1 deletion(-)
 create mode 100644 s390x/stsi.c

diff --git a/s390x/Makefile b/s390x/Makefile
index b654c56..311ab77 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -12,6 +12,7 @@ tests += $(TEST_DIR)/vector.elf
 tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
 tests += $(TEST_DIR)/diag288.elf
+tests += $(TEST_DIR)/stsi.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/stsi.c b/s390x/stsi.c
new file mode 100644
index 0000000..005f337
--- /dev/null
+++ b/s390x/stsi.c
@@ -0,0 +1,123 @@
+/*
+ * Store System Information tests
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
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+
+static inline unsigned long stsi(unsigned long *addr,
+				 unsigned long fc, uint8_t sel1, uint8_t sel2)
+{
+	register unsigned long r0 asm("0") = (fc << 28) | sel1;
+	register unsigned long r1 asm("1") = sel2;
+	int cc;
+
+	asm volatile("stsi	0(%3)\n"
+		     "ipm	 %[cc]\n"
+		     "srl	 %[cc],28\n"
+		     : "+d" (r0), [cc] "=d" (cc)
+		     : "d" (r1), "a" (addr)
+		     : "cc", "memory");
+	return cc;
+}
+
+static inline void stsi_zero_r0(unsigned long *addr,
+				unsigned long fc, uint8_t sel1, uint8_t sel2)
+{
+	register unsigned long r0 asm("0") = (fc << 28) | (1 << 8) | sel1;
+	register unsigned long r1 asm("1") = sel2;
+
+
+	asm volatile("stsi	0(%2)"
+		     : "+d" (r0)
+		     : "d" (r1), "a" (addr)
+		     : "cc", "memory");
+}
+
+static inline void stsi_zero_r1(unsigned long *addr,
+				unsigned long fc, uint8_t sel1, uint8_t sel2)
+{
+	register unsigned long r0 asm("0") = (fc << 28) | sel1;
+	register unsigned long r1 asm("1") = (1 << 16) | sel2;
+
+
+	asm volatile("stsi	0(%2)"
+		     : "+d" (r0)
+		     : "d" (r1), "a" (addr)
+		     : "cc", "memory");
+}
+
+static inline unsigned long stsi_get_fc(unsigned long *addr)
+{
+	register unsigned long r0 asm("0") = 0;
+	register unsigned long r1 asm("1") = 0;
+
+
+	asm volatile("stsi	0(%2)"
+		     : "+d" (r0)
+		     : "d" (r1), "a" (addr)
+		     : "cc", "memory");
+	return r0 >> 28;
+}
+
+static void test_specs(void)
+{
+	report_prefix_push("spec ex");
+
+	report_prefix_push("inv r0");
+	expect_pgm_int();
+	stsi_zero_r0((void *)pagebuf, 1, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("inv r1");
+	expect_pgm_int();
+	stsi_zero_r1((void *)pagebuf, 1, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("unaligned");
+	expect_pgm_int();
+	stsi((void *)pagebuf + 42, 1, 0, 0);
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
+	stsi((void *)pagebuf, 0, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_fc(void)
+{
+	report("cc == 3", stsi((void *)pagebuf, 7, 0, 0));
+	report("r0 == 3", stsi_get_fc((void *)pagebuf));
+}
+
+int main(void)
+{
+	report_prefix_push("stsi");
+	test_priv();
+	test_specs();
+	test_fc();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index ca10f38..c56258a 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -64,4 +64,7 @@ file = iep.elf
 
 [diag288]
 file = diag288.elf
-extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
\ No newline at end of file
+extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
+
+[stsi]
+file = stsi.elf
-- 
2.17.0

