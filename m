Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31668134762
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgAHQNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 11:13:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729394AbgAHQNa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 11:13:30 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008GCqtj006903
        for <kvm@vger.kernel.org>; Wed, 8 Jan 2020 11:13:29 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xaq80d7ud-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:13:28 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Wed, 8 Jan 2020 16:13:23 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Jan 2020 16:13:21 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 008GCWUL48497016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jan 2020 16:12:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 952FAAE053;
        Wed,  8 Jan 2020 16:13:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4652FAE051;
        Wed,  8 Jan 2020 16:13:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jan 2020 16:13:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 4/4] s390x: SCLP unit test
Date:   Wed,  8 Jan 2020 17:13:17 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108161317.268928-1-imbrenda@linux.ibm.com>
References: <20200108161317.268928-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20010816-0020-0000-0000-0000039EF795
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010816-0021-0000-0000-000021F657ED
Message-Id: <20200108161317.268928-5-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_04:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=1 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080133
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
 s390x/sclp.c        | 462 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   8 +
 3 files changed, 471 insertions(+)
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
index 0000000..7aefdc8
--- /dev/null
+++ b/s390x/sclp.c
@@ -0,0 +1,462 @@
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
+#define LC_SIZE (2 * PAGE_SIZE)
+
+static uint8_t pagebuf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/* scratch pages used for some tests */
+static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/* temporary lowcore for test_sccb_prefix */
+static uint8_t sccb_template[PAGE_SIZE];				/* SCCB template to be used */
+static uint32_t valid_code;						/* valid command code for READ SCP INFO */
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
+	/* perform the actual call */
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
+	report(len == 8, "SCCB too short");
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
+	report(offset == 8, "SCCB unaligned");
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
+	prefix = stpx();
+	/*
+	 * save the current content of absolute pages 0 and 1, so we can
+	 * restore them after we trash them later on
+	 */
+	memcpy(scratch, (void *)(intptr_t)prefix, 2 * PAGE_SIZE);
+	/* set the new prefix to prefix_buf */
+	new_prefix = (uint32_t)(intptr_t)prefix_buf;
+	spx(new_prefix);
+
+	/*
+	 * testing with SCCB addresses in the lowcore; since we can't
+	 * actually trash the lowcore (unsurprisingly, things break if we
+	 * do), this will be a read-only test.
+	 */
+	for (offset = 0; offset < 2 * PAGE_SIZE; offset += 8)
+		if (!test_one_sccb(valid_code, MKPTR(offset), 0, PGM_BIT_SPEC, 0))
+			break;
+	report(offset == 2 * PAGE_SIZE, "SCCB low pages");
+
+	/*
+	 * this will trash the contents of the two pages at absolute
+	 * address 0; we will need to restore them later.
+	 */
+	for (offset = 0; offset < 2 * PAGE_SIZE; offset += 8)
+		if (!test_one_simple(valid_code, MKPTR(new_prefix + offset), 8, 8, PGM_BIT_SPEC, 0))
+			break;
+	report(offset == 2 * PAGE_SIZE, "SCCB prefix pages");
+
+	/* restore the previous contents of absolute pages 0 and 1 */
+	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
+	/* restore the prefix to the original value */
+	spx(prefix);
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
+	report(i == len, "SCCB high addresses");
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
+	report(i == 65536, "Command detail code");
+
+	for (i = 0; i < 256; i++) {
+		cmd = (valid_code & ~0xff) | i;
+		if (cmd == valid_code)
+			continue;
+		if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE, res))
+			break;
+	}
+	report(i == 256, "Command class code");
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
+	report(len == 144, "Insufficient SCCB length (Read SCP info)");
+
+	for (len = 8; len < 40; len++)
+		if (!test_one_simple(SCLP_READ_CPU_INFO, pagebuf, len, len, PGM_NONE, res))
+			break;
+	report(len == 40, "Insufficient SCCB length (Read CPU info)");
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
+	report(len > 4096 && offset == 4096, "SCCB page boundary violation");
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
+	report(len == 8192, "SCCB bigger than 4k");
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
+	report(i >= 0x80000000, "Invalid SCCB address");
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
+	report(cc == 0, "Instruction format ignored bits");
+}
+
+/**
+ * Find a valid READ INFO command code; not all codes are always allowed, and
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
index f1b07cd..07013b2 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -75,3 +75,11 @@ file = stsi.elf
 [smp]
 file = smp.elf
 extra_params =-smp 2
+
+[sclp-1g]
+file = sclp.elf
+extra_params = -m 1G
+
+[sclp-3g]
+file = sclp.elf
+extra_params = -m 3G
-- 
2.24.1

