Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B4810213C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 10:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKSJxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 04:53:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbfKSJxu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 04:53:50 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ9qbtr017407
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:53:48 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wbxnbyhx1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:53:48 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 19 Nov 2019 09:53:46 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 19 Nov 2019 09:53:42 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJ9rfLD22085652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 09:53:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C31D52050;
        Tue, 19 Nov 2019 09:53:41 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id D42AE52051;
        Tue, 19 Nov 2019 09:53:40 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 3/3] s390x: SCLP unit test
Date:   Tue, 19 Nov 2019 10:53:39 +0100
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
References: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111909-0020-0000-0000-0000038A6D49
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111909-0021-0000-0000-000021E09864
Message-Id: <1574157219-22052-4-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_02:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=1 phishscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911190094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SCLP unit test. Testing the following:

* Correctly ignoring instruction bits that should be ignored
* Privileged instruction check
* Check for addressing exceptions
* Specification exceptions:
  - SCCB size less than 8
  - SCCB unaligned
  - SCCB overlaps prefix or lowcore
  - SCCB address higher than 2GB
* Return codes for
  - Invalid command
  - SCCB too short (but at least 8)
  - SCCB page boundary violation

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/sclp.c        | 465 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 469 insertions(+)
 create mode 100644 s390x/sclp.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 3744372..ddb4b48 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
 tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
+tests += $(TEST_DIR)/sclp.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/sclp.c b/s390x/sclp.c
new file mode 100644
index 0000000..aeb0b04
--- /dev/null
+++ b/s390x/sclp.c
@@ -0,0 +1,465 @@
+/*
+ * Service Call tests
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <sclp.h>
+
+#define PGM_NONE	1
+#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
+#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
+#define PGM_BIT_PRIV	(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
+#define MKPTR(x) ((void *)(uint64_t)(x))
+
+/* two pages of scratch memory to be used for some of the tests */
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+/* used as prefix when testing prefix access, to guarantee that prefix != 0 */
+static uint8_t prefix_buf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+/* SCCB template used to */
+static uint8_t sccb_template[PAGE_SIZE];
+/* the valid command code to use for getting SCP information */
+static uint32_t valid_code;
+/* points to lowcore (real address 0) */
+static struct lowcore *lc;
+
+/**
+ * Perform one service call, handling exceptions and interrupts.
+ */
+static int sclp_service_call_test(unsigned int command, void *sccb)
+{
+	int cc;
+
+	sclp_mark_busy();
+	sclp_setup_int();
+	cc = servc(command, __pa(sccb));
+	if (lc->pgm_int_code) {
+		sclp_handle_ext();
+		return 0;
+	}
+	if (!cc)
+		sclp_wait_busy();
+	return cc;
+}
+
+/**
+ * Perform one test at the given address, optionally using the SCCB template,
+ * checking for the expected program interrupts and return codes.
+ *
+ * The parameter buf_len indicates the number of bytes of the template that
+ * should be copied to the test address, and should be 0 when the test
+ * address is invalid, in which case nothing is copied.
+ *
+ * The template is used to simplify tests where the same buffer content is
+ * used many times in a row, at different addresses.
+ *
+ * Returns true in case of success or false in case of failure
+ */
+static bool test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
+{
+	SCCBHeader *h = (SCCBHeader *)addr;
+	int res, pgm;
+
+	/* Copy the template to the test address if needed */
+	if (buf_len)
+		memcpy(addr, sccb_template, buf_len);
+	expect_pgm_int();
+	/* perform the actuall call */
+	res = sclp_service_call_test(cmd, h);
+	if (res) {
+		report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd, addr, res);
+		return false;
+	}
+	pgm = clear_pgm_int();
+	/* Check if the program exception was one of the expected ones */
+	if (!((1ULL << pgm) & exp_pgm)) {
+		report_info("First failure at addr %p, buf_len %d, cmd %#x, pgm code %d",
+				addr, buf_len, cmd, pgm);
+		return false;
+	}
+	/* Check if the response code is the one expected */
+	if (exp_rc && exp_rc != h->response_code) {
+		report_info("First failure at addr %p, buf_len %d, cmd %#x, resp code %#x",
+				addr, buf_len, cmd, h->response_code);
+		return false;
+	}
+	return true;
+}
+
+/**
+ * Wrapper for test_one_sccb to set up a simple SCCB template.
+ *
+ * The parameter sccb_len indicates the value that will be saved in the SCCB
+ * length field of the SCCB, buf_len indicates the number of bytes of
+ * template that need to be copied to the actual test address. In many cases
+ * it's enough to clear/copy the first 8 bytes of the buffer, while the SCCB
+ * itself can be larger.
+ *
+ * Returns true in case of success or false in case of failure
+ */
+static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
+			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
+{
+	memset(sccb_template, 0, sizeof(sccb_template));
+	((SCCBHeader *)sccb_template)->length = sccb_len;
+	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
+}
+
+/**
+ * Test SCCB lengths < 8.
+ */
+static void test_sccb_too_short(void)
+{
+	int len;
+
+	for (len = 0; len < 8; len++)
+		if (!test_one_simple(valid_code, pagebuf, len, 8, PGM_BIT_SPEC, 0))
+			break;
+
+	report("SCCB too short", len == 8);
+}
+
+/**
+ * Test SCCBs that are not 64-bit aligned.
+ */
+static void test_sccb_unaligned(void)
+{
+	int offset;
+
+	for (offset = 1; offset < 8; offset++)
+		if (!test_one_simple(valid_code, offset + pagebuf, 8, 8, PGM_BIT_SPEC, 0))
+			break;
+	report("SCCB unaligned", offset == 8);
+}
+
+/**
+ * Test SCCBs whose address is in the lowcore or prefix area.
+ */
+static void test_sccb_prefix(void)
+{
+	uint8_t scratch[2 * PAGE_SIZE];
+	uint32_t prefix, new_prefix;
+	int offset;
+
+	/*
+	 * copy the current lowcore to the future new location, otherwise we
+	 * will not have a valid lowcore after setting the new prefix.
+	 */
+	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
+	/* save the current prefix (it's probably going to be 0) */
+	asm volatile("stpx %0" : "=Q" (prefix));
+	/*
+	 * save the current content of absolute pages 0 and 1, so we can
+	 * restore them after we trash them later on
+	 */
+	memcpy(scratch, (void *)(intptr_t)prefix, 2 * PAGE_SIZE);
+	/* set the new prefix to prefix_buf */
+	new_prefix = (uint32_t)(intptr_t)prefix_buf;
+	asm volatile("spx %0" : : "Q" (new_prefix) : "memory");
+
+	/*
+	 * testing with SCCB addresses in the lowcore; since we can't
+	 * actually trash the lowcore (unsurprisingly, things break if we
+	 * do), this will be a read-only test.
+	 */
+	for (offset = 0; offset < 2 * PAGE_SIZE; offset += 8)
+		if (!test_one_sccb(valid_code, MKPTR(offset), 0, PGM_BIT_SPEC, 0))
+			break;
+	report("SCCB low pages", offset == 2 * PAGE_SIZE);
+
+	/*
+	 * this will trash the contents of the two pages at absolute
+	 * address 0; we will need to restore them later.
+	 */
+	for (offset = 0; offset < 2 * PAGE_SIZE; offset += 8)
+		if (!test_one_simple(valid_code, MKPTR(new_prefix + offset), 8, 8, PGM_BIT_SPEC, 0))
+			break;
+	report("SCCB prefix pages", offset == 2 * PAGE_SIZE);
+
+	/* restore the previous contents of absolute pages 0 and 1 */
+	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
+	/* restore the prefix to the original value */
+	asm volatile("spx %0" : : "Q" (prefix) : "memory");
+}
+
+/**
+ * Test SCCBs that are above 2GB. If outside of memory, an addressing
+ * exception is also allowed.
+ */
+static void test_sccb_high(void)
+{
+	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	uintptr_t a[33 * 4 * 2 + 2];	/* for the list of addresses to test */
+
+	uint64_t maxram;
+	int i, pgm, len = 0;
+
+	h->length = 8;
+	/* addresses with 1 bit set in the first 33 bits */
+	for (i = 0; i < 33; i++)
+		a[len++] = 1UL << (i + 31);
+	/* addresses with 2 consecutive bits set in the first 33 bits */
+	for (i = 0; i < 33; i++)
+		a[len++] = 3UL << (i + 31);
+	/* addresses with all bits set in bits 0..N */
+	for (i = 0; i < 33; i++)
+		a[len++] = 0xffffffff80000000UL << i;
+	/* addresses with all bits set in bits N..33 */
+	a[len++] = 0x80000000;
+	for (i = 1; i < 33; i++, len++)
+		a[len] = a[len - 1] | (1UL << (i + 31));
+	/* all the addresses above, but adding the offset of a valid buffer */
+	for (i = 0; i < len; i++)
+		a[len + i] = a[i] + (intptr_t)h;
+	len += i;
+	/* two more hand-crafted addresses */
+	a[len++] = 0xdeadbeef00000000;
+	a[len++] = 0xdeaddeadbeef0000;
+
+	maxram = get_ram_size();
+	for (i = 0; i < len; i++) {
+		pgm = PGM_BIT_SPEC | (a[i] >= maxram ? PGM_BIT_ADDR : 0);
+		if (!test_one_sccb(valid_code, (void *)a[i], 0, pgm, 0))
+			break;
+	}
+	report("SCCB high addresses", i == len);
+}
+
+/**
+ * Test invalid commands, both invalid command detail codes and valid
+ * ones with invalid command class code.
+ */
+static void test_inval(void)
+{
+	const uint16_t res = SCLP_RC_INVALID_SCLP_COMMAND;
+	uint32_t cmd;
+	int i;
+
+	report_prefix_push("Invalid command");
+	for (i = 0; i < 65536; i++) {
+		cmd = 0xdead0000 | i;
+		if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE, res))
+			break;
+	}
+	report("Command detail code", i == 65536);
+
+	for (i = 0; i < 256; i++) {
+		cmd = (valid_code & ~0xff) | i;
+		if (cmd == valid_code)
+			continue;
+		if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE, res))
+			break;
+	}
+	report("Command class code", i == 256);
+	report_prefix_pop();
+}
+
+
+/**
+ * Test short SCCBs (but larger than 8).
+ */
+static void test_short(void)
+{
+	const uint16_t res = SCLP_RC_INSUFFICIENT_SCCB_LENGTH;
+	int len;
+
+	for (len = 8; len < 144; len++)
+		if (!test_one_simple(valid_code, pagebuf, len, len, PGM_NONE, res))
+			break;
+	report("Insufficient SCCB length (Read SCP info)", len == 144);
+
+	for (len = 8; len < 40; len++)
+		if (!test_one_simple(SCLP_READ_CPU_INFO, pagebuf, len, len, PGM_NONE, res))
+			break;
+	report("Insufficient SCCB length (Read CPU info)", len == 40);
+}
+
+/**
+ * Test SCCB page boundary violations.
+ */
+static void test_boundary(void)
+{
+	const uint32_t cmd = SCLP_CMD_WRITE_EVENT_DATA;
+	const uint16_t res = SCLP_RC_SCCB_BOUNDARY_VIOLATION;
+	WriteEventData *sccb = (WriteEventData *)sccb_template;
+	int len, offset;
+
+	memset(sccb_template, 0, sizeof(sccb_template));
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	for (len = 32; len <= 4096; len++) {
+		offset = len & 7 ? len & ~7 : len - 8;
+		for (offset = 4096 - offset; offset < 4096; offset += 8) {
+			sccb->h.length = len;
+			if (!test_one_sccb(cmd, offset + pagebuf, len, PGM_NONE, res))
+				goto out;
+		}
+	}
+out:
+	report("SCCB page boundary violation", len > 4096 && offset == 4096);
+}
+
+/**
+ * Test excessively long SCCBs.
+ */
+static void test_toolong(void)
+{
+	const uint32_t cmd = SCLP_CMD_WRITE_EVENT_DATA;
+	const uint16_t res = SCLP_RC_SCCB_BOUNDARY_VIOLATION;
+	WriteEventData *sccb = (WriteEventData *)sccb_template;
+	int len;
+
+	memset(sccb_template, 0, sizeof(sccb_template));
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	for (len = 4097; len < 8192; len++) {
+		sccb->h.length = len;
+		if (!test_one_sccb(cmd, pagebuf, PAGE_SIZE, PGM_NONE, res))
+			break;
+	}
+	report("SCCB bigger than 4k", len == 8192);
+}
+
+/**
+ * Test privileged operation.
+ */
+static void test_priv(void)
+{
+	SCCBHeader *h = (SCCBHeader *)pagebuf;
+
+	report_prefix_push("Privileged operation");
+	h->length = 8;
+	expect_pgm_int();
+	enter_pstate();
+	servc(valid_code, __pa(h));
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+/**
+ * Test addressing exceptions. We need to test SCCB addresses between the
+ * end of available memory and 2GB, because after 2GB a specification
+ * exception is also allowed.
+ * Only applicable if the VM has less than 2GB of memory
+ */
+static void test_addressing(void)
+{
+	unsigned long i, maxram = get_ram_size();
+
+	/* the VM has more than 2GB of memory */
+	if (maxram >= 0x80000000) {
+		report_skip("Invalid SCCB address");
+		return;
+	}
+	/* test all possible valid addresses immediately after the end of memory
+	 * up to 64KB after the end of memory
+	 */
+	for (i = 0; i < 0x10000 && i + maxram < 0x80000000; i += 8)
+		if (!test_one_sccb(valid_code, MKPTR(i + maxram), 0, PGM_BIT_ADDR, 0))
+			goto out;
+	/* test more addresses until we reach 1MB after end of memory;
+	 * increment by a prime number (times 8) in order to test all
+	 * possible valid offsets inside pages
+	 */
+	for (; i < 0x100000 && i + maxram < 0x80000000 ; i += 808)
+		if (!test_one_sccb(valid_code, MKPTR(i + maxram), 0, PGM_BIT_ADDR, 0))
+			goto out;
+	/* test the remaining addresses until we reach address 2GB;
+	 * increment by a prime number (times 8) in order to test all
+	 * possible valid offsets inside pages
+	 */
+	for (; i < 0x80000000; i += 800024)
+		if (!test_one_sccb(valid_code, MKPTR(i + maxram), 0, PGM_BIT_ADDR, 0))
+			goto out;
+out:
+	report("Invalid SCCB address", i >= 0x80000000);
+}
+
+/**
+ * Test some bits in the instruction format that are specified to be ignored.
+ */
+static void test_instbits(void)
+{
+	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	int cc;
+
+	expect_pgm_int();
+	sclp_mark_busy();
+	h->length = 8;
+	sclp_setup_int();
+
+	asm volatile(
+		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
+		"       ipm     %0\n"
+		"       srl     %0,28"
+		: "=&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
+		: "cc", "memory");
+	if (lc->pgm_int_code) {
+		sclp_handle_ext();
+		cc = 1;
+	} else if (!cc)
+		sclp_wait_busy();
+	report("Instruction format ignored bits", cc == 0);
+}
+
+/**
+ * Find a valid SCLP command code; not all codes are always allowed, and
+ * probing should be performed in the right order.
+ */
+static void find_valid_sclp_code(void)
+{
+	const unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
+					  SCLP_CMDW_READ_SCP_INFO };
+	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	int i, cc;
+
+	for (i = 0; i < ARRAY_SIZE(commands); i++) {
+		sclp_mark_busy();
+		memset(h, 0, sizeof(*h));
+		h->length = 4096;
+
+		valid_code = commands[i];
+		cc = sclp_service_call(commands[i], h);
+		if (cc)
+			break;
+		if (h->response_code == SCLP_RC_NORMAL_READ_COMPLETION)
+			return;
+		if (h->response_code != SCLP_RC_INVALID_SCLP_COMMAND)
+			break;
+	}
+	valid_code = 0;
+	report_abort("READ_SCP_INFO failed");
+}
+
+int main(void)
+{
+	report_prefix_push("sclp");
+	find_valid_sclp_code();
+
+	/* Test some basic things */
+	test_instbits();
+	test_priv();
+	test_addressing();
+
+	/* Test the specification exceptions */
+	test_sccb_too_short();
+	test_sccb_unaligned();
+	test_sccb_prefix();
+	test_sccb_high();
+
+	/* Test the expected response codes */
+	test_inval();
+	test_short();
+	test_boundary();
+	test_toolong();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f1b07cd..75e3d37 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -75,3 +75,6 @@ file = stsi.elf
 [smp]
 file = smp.elf
 extra_params =-smp 2
+
+[sclp]
+file = sclp.elf
-- 
2.7.4

