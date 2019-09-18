Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDAAB62B4
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbfIRMEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1917 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730560AbfIRMEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC40B307D9D0;
        Wed, 18 Sep 2019 12:04:42 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E5A6600C8;
        Wed, 18 Sep 2019 12:04:41 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 4/9] s390x: STSI tests
Date:   Wed, 18 Sep 2019 14:04:21 +0200
Message-Id: <20190918120426.20832-5-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 18 Sep 2019 12:04:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

For now let's concentrate on the error conditions.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20190826163502.1298-5-frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
[thuth: Replaced a "%3" in inline assembly with "%[addr]"]
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile      |  1 +
 s390x/stsi.c        | 84 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 ++
 3 files changed, 88 insertions(+)
 create mode 100644 s390x/stsi.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 3453373..76db0bb 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -13,6 +13,7 @@ tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
 tests += $(TEST_DIR)/cpumodel.elf
 tests += $(TEST_DIR)/diag288.elf
+tests += $(TEST_DIR)/stsi.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/stsi.c b/s390x/stsi.c
new file mode 100644
index 0000000..7232cb0
--- /dev/null
+++ b/s390x/stsi.c
@@ -0,0 +1,84 @@
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
+static void test_specs(void)
+{
+	report_prefix_push("specification");
+
+	report_prefix_push("inv r0");
+	expect_pgm_int();
+	stsi(pagebuf, 0, 1 << 8, 0);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("inv r1");
+	expect_pgm_int();
+	stsi(pagebuf, 1, 0, 1 << 16);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("unaligned");
+	expect_pgm_int();
+	stsi(pagebuf + 42, 1, 0, 0);
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
+	stsi(pagebuf, 0, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+static inline unsigned long stsi_get_fc(void *addr)
+{
+	register unsigned long r0 asm("0") = 0;
+	register unsigned long r1 asm("1") = 0;
+	int cc;
+
+	asm volatile("stsi	0(%[addr])\n"
+		     "ipm	%[cc]\n"
+		     "srl	%[cc],28\n"
+		     : "+d" (r0), [cc] "=d" (cc)
+		     : "d" (r1), [addr] "a" (addr)
+		     : "cc", "memory");
+	assert(!cc);
+	return r0 >> 28;
+}
+
+static void test_fc(void)
+{
+	report("invalid fc",  stsi(pagebuf, 7, 0, 0) == 3);
+	report("query fc >= 2",  stsi_get_fc(pagebuf) >= 2);
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
index 9dd288a..cc79a4e 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -68,3 +68,6 @@ file = cpumodel.elf
 [diag288]
 file = diag288.elf
 extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
+
+[stsi]
+file = stsi.elf
-- 
2.18.1

