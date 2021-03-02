Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA632A71B
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449073AbhCBQD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:03:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350497AbhCBMVx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 07:21:53 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122BckTF098198
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zs0MDkZa0YEgL+7LQksZfDhCW8b2ByN847XQvMdZfIk=;
 b=mccvClZRvEnWhXgGp5/pIYSs0jkHg7K8q0RKYczy+wQq7nNNwOFglIVHSZAdhS+0IgXG
 Sw+y2Uae+UKNWgBc/S/UaNtcHJGwBIt1LAhbjxKLY8K8rkHSUx99NIGPZkFJBXbko/VD
 6kXYYz47nBLG5JhiMSt/7SXh1zTABgRPI8jHy3C9Osr0jrl7A6ackCs6Df56VL9tpSOZ
 5eV97crbTPjuGalW+yvnwAOzYAt3xLCxkXKzVkXlEgUoycq2POUYj39oCFA4uNTS3xU5
 0kjS6aUoyX50oQwvFpH2esV4n7eNsNfTdCUbuA0CIdXnolVJwfHxnFgd4W+0+1/jOA3M aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371k0dbgpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:41:13 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122BcoOR098530
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:13 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371k0dbgp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 06:41:13 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122BbIhA009204;
        Tue, 2 Mar 2021 11:41:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmgsqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 11:41:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Bf9Oi45678904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 11:41:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09B81AE055;
        Tue,  2 Mar 2021 11:41:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2B0BAE053;
        Tue,  2 Mar 2021 11:41:08 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 11:41:08 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v4 2/3] s390x: mvpg: simple test
Date:   Tue,  2 Mar 2021 12:41:06 +0100
Message-Id: <20210302114107.501837-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302114107.501837-1-imbrenda@linux.ibm.com>
References: <20210302114107.501837-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_03:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A simple unit test for the MVPG instruction.

The timeout is set to 10 seconds because the test should complete in a
fraction of a second even on busy machines. If the test is run in VSIE
and the host of the host is not handling MVPG properly, the test will
probably hang.

Testing MVPG behaviour in VSIE is the main motivation for this test.

Anything related to storage keys is not tested.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile      |   1 +
 s390x/mvpg.c        | 267 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 272 insertions(+)
 create mode 100644 s390x/mvpg.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 08d85c9f..770eaa0b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -20,6 +20,7 @@ tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
 tests += $(TEST_DIR)/sie.elf
+tests += $(TEST_DIR)/mvpg.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/mvpg.c b/s390x/mvpg.c
new file mode 100644
index 00000000..1776ec6e
--- /dev/null
+++ b/s390x/mvpg.c
@@ -0,0 +1,267 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Move Page instruction tests
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm-generic/barrier.h>
+#include <asm/interrupt.h>
+#include <asm/pgtable.h>
+#include <mmu.h>
+#include <asm/page.h>
+#include <asm/facility.h>
+#include <asm/mem.h>
+#include <asm/sigp.h>
+#include <smp.h>
+#include <alloc_page.h>
+#include <bitops.h>
+
+/* Used to build the appropriate test values for register 0 */
+#define KFC(x) ((x) << 10)
+#define CCO 0x100
+
+/* How much memory to allocate for the test */
+#define MEM_ORDER 12
+/* How many iterations to perform in the loops */
+#define ITER 8
+
+/* Used to generate the simple pattern */
+#define MAGIC 42
+
+static uint8_t source[PAGE_SIZE]  __attribute__((aligned(PAGE_SIZE)));
+static uint8_t buffer[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+/* Keep track of fresh memory */
+static uint8_t *fresh;
+
+static inline int mvpg(unsigned long r0, void *dest, void *src)
+{
+	register unsigned long reg0 asm ("0") = r0;
+	int cc;
+
+	asm volatile("	mvpg    %1,%2\n"
+		     "	ipm     %0\n"
+		     "	srl     %0,28"
+		: "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0)
+		: "memory", "cc");
+	return cc;
+}
+
+/*
+ * Initialize a page with a simple pattern
+ */
+static void init_page(uint8_t *p)
+{
+	int i;
+
+	for (i = 0; i < PAGE_SIZE; i++)
+		p[i] = i + MAGIC;
+}
+
+/*
+ * Check if the given page contains the simple pattern
+ */
+static int page_ok(const uint8_t *p)
+{
+	int i;
+
+	for (i = 0; i < PAGE_SIZE; i++)
+		if (p[i] != (uint8_t)(i + MAGIC))
+			return 0;
+	return 1;
+}
+
+static void test_exceptions(void)
+{
+	int i, expected;
+
+	report_prefix_push("exceptions");
+
+	/*
+	 * Key Function Control values 4 and 5 are allowed only in supervisor
+	 * state, and even then, only if the move-page-and-set-key facility
+	 * is present (STFLE bit 149)
+	 */
+	report_prefix_push("privileged");
+	if (test_facility(149)) {
+		expected = PGM_INT_CODE_PRIVILEGED_OPERATION;
+		for (i = 4; i < 6; i++) {
+			expect_pgm_int();
+			enter_pstate();
+			mvpg(KFC(i), buffer, source);
+			report(clear_pgm_int() == expected, "Key Function Control value %d", i);
+		}
+	} else {
+		report_skip("Key Function Control value %d", 4);
+		report_skip("Key Function Control value %d", 5);
+		i = 4;
+	}
+	report_prefix_pop();
+
+	/*
+	 * Invalid values of the Key Function Control, or setting the
+	 * reserved bits, should result in a specification exception
+	 */
+	report_prefix_push("specification");
+	expected = PGM_INT_CODE_SPECIFICATION;
+	expect_pgm_int();
+	mvpg(KFC(3), buffer, source);
+	report(clear_pgm_int() == expected, "Key Function Control value 3");
+	for (; i < 32; i++) {
+		expect_pgm_int();
+		mvpg(KFC(i), buffer, source);
+		report(clear_pgm_int() == expected, "Key Function Control value %d", i);
+	}
+	report_prefix_pop();
+
+	/* Operands outside memory result in addressing exceptions, as usual */
+	report_prefix_push("addressing");
+	expected = PGM_INT_CODE_ADDRESSING;
+	expect_pgm_int();
+	mvpg(0, buffer, (void *)PAGE_MASK);
+	report(clear_pgm_int() == expected, "Second operand outside memory");
+
+	expect_pgm_int();
+	mvpg(0, (void *)PAGE_MASK, source);
+	report(clear_pgm_int() == expected, "First operand outside memory");
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
+static void test_success(void)
+{
+	int cc;
+
+	report_prefix_push("success");
+	/* Test successful scenarios, both in supervisor and problem state */
+	cc = mvpg(0, buffer, source);
+	report(page_ok(buffer) && !cc, "Supervisor state MVPG successful");
+	memset(buffer, 0xff, PAGE_SIZE);
+
+	enter_pstate();
+	cc = mvpg(0, buffer, source);
+	leave_pstate();
+	report(page_ok(buffer) && !cc, "Problem state MVPG successful");
+
+	report_prefix_pop();
+}
+
+static void test_small_loop(const void *string)
+{
+	uint8_t *dest;
+	int i, cc;
+
+	/* Looping over cold and warm pages helps catch VSIE bugs */
+	report_prefix_push(string);
+	dest = fresh;
+	for (i = 0; i < ITER; i++) {
+		cc = mvpg(0, fresh, source);
+		report(page_ok(fresh) && !cc, "cold: %p, %p", source, fresh);
+		fresh += PAGE_SIZE;
+	}
+
+	for (i = 0; i < ITER; i++) {
+		memset(dest, 0, PAGE_SIZE);
+		cc = mvpg(0, dest, source);
+		report(page_ok(dest) && !cc, "warm: %p, %p", source, dest);
+		dest += PAGE_SIZE;
+	}
+	report_prefix_pop();
+}
+
+static void test_mmu_prot(void)
+{
+	int cc;
+
+	report_prefix_push("protection");
+	report_prefix_push("cco=0");
+
+	/* MVPG should still succeed when the source is read-only */
+	protect_page(source, PAGE_ENTRY_P);
+	cc = mvpg(0, fresh, source);
+	report(page_ok(fresh) && !cc, "source read only");
+	unprotect_page(source, PAGE_ENTRY_P);
+	fresh += PAGE_SIZE;
+
+	/*
+	 * When the source or destination are invalid, a page translation
+	 * exception should be raised; when the destination is read-only,
+	 * a protection exception should be raised.
+	 */
+	protect_page(fresh, PAGE_ENTRY_P);
+	expect_pgm_int();
+	mvpg(0, fresh, source);
+	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
+	fresh += PAGE_SIZE;
+
+	protect_page(source, PAGE_ENTRY_I);
+	expect_pgm_int();
+	mvpg(0, fresh, source);
+	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "source invalid");
+	unprotect_page(source, PAGE_ENTRY_I);
+	fresh += PAGE_SIZE;
+
+	protect_page(fresh, PAGE_ENTRY_I);
+	expect_pgm_int();
+	mvpg(0, fresh, source);
+	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "destination invalid");
+	fresh += PAGE_SIZE;
+
+	report_prefix_pop();
+	report_prefix_push("cco=1");
+	/*
+	 * Setting the CCO bit should suppress page translation exceptions,
+	 * but not protection exceptions.
+	 */
+	protect_page(fresh, PAGE_ENTRY_P);
+	expect_pgm_int();
+	mvpg(CCO, fresh, source);
+	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
+	fresh += PAGE_SIZE;
+
+	protect_page(fresh, PAGE_ENTRY_I);
+	cc = mvpg(CCO, fresh, source);
+	report(cc == 1, "destination invalid");
+	fresh += PAGE_SIZE;
+
+	protect_page(source, PAGE_ENTRY_I);
+	cc = mvpg(CCO, fresh, source);
+	report(cc == 2, "source invalid");
+	fresh += PAGE_SIZE;
+
+	protect_page(fresh, PAGE_ENTRY_I);
+	cc = mvpg(CCO, fresh, source);
+	report(cc == 2, "source and destination invalid");
+	fresh += PAGE_SIZE;
+
+	unprotect_page(source, PAGE_ENTRY_I);
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("mvpg");
+
+	init_page(source);
+	fresh = alloc_pages_flags(MEM_ORDER, FLAG_DONTZERO | FLAG_FRESH);
+	assert(fresh);
+
+	test_exceptions();
+	test_success();
+	test_small_loop("nommu");
+
+	setup_vm();
+
+	test_small_loop("mmu");
+	test_mmu_prot();
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 2298be6c..9f81a608 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -99,3 +99,7 @@ file = uv-guest.elf
 
 [sie]
 file = sie.elf
+
+[mvpg]
+file = mvpg.elf
+timeout = 10
-- 
2.26.2

