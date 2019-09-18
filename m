Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8DB62B2
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfIRMEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbfIRMEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 48DEA8A1C80;
        Wed, 18 Sep 2019 12:04:39 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E67CC600CC;
        Wed, 18 Sep 2019 12:04:37 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 2/9] s390x: Diag288 test
Date:   Wed, 18 Sep 2019 14:04:19 +0200
Message-Id: <20190918120426.20832-3-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 18 Sep 2019 12:04:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

A small test for the watchdog via diag288.

Minimum timer value is 15 (seconds) and the only supported action with
QEMU is restart.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190827074631.7184-1-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h |   1 +
 s390x/Makefile           |   1 +
 s390x/diag288.c          | 114 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 ++
 4 files changed, 120 insertions(+)
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
index 0000000..b4934bf
--- /dev/null
+++ b/s390x/diag288.c
@@ -0,0 +1,114 @@
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
+	asm volatile("diag 1,2,0x288");
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
+static void test_bite(void)
+{
+	uint64_t mask, time;
+
+	/* If watchdog doesn't bite, the cpu timer does */
+	asm volatile("stck %0" : "=Q" (time) : : "cc");
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
2.18.1

