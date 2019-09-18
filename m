Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CFDB62B9
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfIRMEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730634AbfIRMEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B3EE18CB901;
        Wed, 18 Sep 2019 12:04:54 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38BA960167;
        Wed, 18 Sep 2019 12:04:50 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 9/9] s390x: Add storage key removal facility
Date:   Wed, 18 Sep 2019 14:04:26 +0200
Message-Id: <20190918120426.20832-10-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 18 Sep 2019 12:04:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The storage key removal facility (stfle bit 169) makes all key related
instructions result in a special operation exception if they handle a
key.

Let's make sure that the skey and pfmf tests only run non key code
(pfmf) or not at all (skey).

Also let's test this new facility. As lots of instructions are
affected by this, only some of them are tested for now.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20190828113615.4769-5-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile |   1 +
 s390x/pfmf.c   |  10 ++++
 s390x/skey.c   |   5 ++
 s390x/skrf.c   | 128 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 144 insertions(+)
 create mode 100644 s390x/skrf.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 07bd353..96033dd 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -14,6 +14,7 @@ tests += $(TEST_DIR)/iep.elf
 tests += $(TEST_DIR)/cpumodel.elf
 tests += $(TEST_DIR)/diag288.elf
 tests += $(TEST_DIR)/stsi.elf
+tests += $(TEST_DIR)/skrf.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 0b3e70b..e81f7c5 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -34,6 +34,10 @@ static void test_4k_key(void)
 	union skey skey;
 
 	report_prefix_push("4K");
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+		goto out;
+	}
 	r1.val = 0;
 	r1.reg.sk = 1;
 	r1.reg.fsc = PFMF_FSC_4K;
@@ -42,6 +46,7 @@ static void test_4k_key(void)
 	skey.val = get_storage_key(pagebuf);
 	skey.val &= SKEY_ACC | SKEY_FP;
 	report("set storage keys", skey.val == 0x30);
+out:
 	report_prefix_pop();
 }
 
@@ -53,6 +58,10 @@ static void test_1m_key(void)
 	union skey skey;
 
 	report_prefix_push("1M");
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+		goto out;
+	}
 	r1.val = 0;
 	r1.reg.sk = 1;
 	r1.reg.fsc = PFMF_FSC_1M;
@@ -67,6 +76,7 @@ static void test_1m_key(void)
 		}
 	}
 	report("set storage keys", rp);
+out:
 	report_prefix_pop();
 }
 
diff --git a/s390x/skey.c b/s390x/skey.c
index efc4eca..5020e99 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -126,10 +126,15 @@ static void test_priv(void)
 int main(void)
 {
 	report_prefix_push("skey");
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+		goto done;
+	}
 	test_priv();
 	test_set();
 	test_set_mb();
 	test_chg();
+done:
 	report_prefix_pop();
 	return report_summary();
 }
diff --git a/s390x/skrf.c b/s390x/skrf.c
new file mode 100644
index 0000000..e77ff35
--- /dev/null
+++ b/s390x/skrf.c
@@ -0,0 +1,128 @@
+/*
+ * Storage key removal facility tests
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <asm/facility.h>
+#include <asm/mem.h>
+
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+
+static void test_facilities(void)
+{
+	report_prefix_push("facilities");
+	report("!10", !test_facility(10));
+	report("!14", !test_facility(14));
+	report("!66", !test_facility(66));
+	report("!145", !test_facility(145));
+	report("!149", !test_facility(140));
+	report_prefix_pop();
+}
+
+static void test_skey(void)
+{
+	report_prefix_push("sske");
+	expect_pgm_int();
+	set_storage_key(pagebuf, 0x30, 0);
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	expect_pgm_int();
+	report_prefix_pop();
+	report_prefix_push("iske");
+	get_storage_key(pagebuf);
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_pfmf(void)
+{
+	union pfmf_r1 r1;
+
+	report_prefix_push("pfmf");
+	r1.val = 0;
+	r1.reg.sk = 1;
+	r1.reg.fsc = PFMF_FSC_4K;
+	r1.reg.key = 0x30;
+	expect_pgm_int();
+	pfmf(r1.val, pagebuf);
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_psw_key(void)
+{
+	uint64_t psw_mask = extract_psw_mask() | 0xF0000000000000UL;
+
+	report_prefix_push("psw key");
+	expect_pgm_int();
+	load_psw_mask(psw_mask);
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_mvcos(void)
+{
+	uint64_t r3 = 64;
+	uint8_t *src = pagebuf;
+	uint8_t *dst = pagebuf + PAGE_SIZE;
+	/* K bit set, as well as keys */
+	register unsigned long oac asm("0") = 0xf002f002;
+
+	report_prefix_push("mvcos");
+	expect_pgm_int();
+	asm volatile("mvcos	%[dst],%[src],%[len]"
+		     : [dst] "+Q" (*(dst))
+		     : [src] "Q" (*(src)), [len] "d" (r3), "d" (oac)
+		     : "cc", "memory");
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_spka(void)
+{
+	report_prefix_push("spka");
+	expect_pgm_int();
+	asm volatile("spka	0xf0(0)\n");
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	report_prefix_pop();
+}
+
+static void test_tprot(void)
+{
+	report_prefix_push("tprot");
+	expect_pgm_int();
+	asm volatile("tprot	%[addr],0xf0(0)\n"
+		     : : [addr] "a" (pagebuf) : );
+	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("skrf");
+	if (!test_facility(169)) {
+		report_skip("storage key removal facility not available\n");
+		goto done;
+	}
+
+	test_facilities();
+	test_skey();
+	test_pfmf();
+	test_psw_key();
+	test_mvcos();
+	test_spka();
+	test_tprot();
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
-- 
2.18.1

