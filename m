Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D92E51F8
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409796AbfJYRGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 13:06:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409654AbfJYRGp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 13:06:45 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PH4B5t014035
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 13:06:43 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv3snjyhc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 13:06:43 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 25 Oct 2019 18:06:41 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 18:06:38 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PH6aGs53215314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:06:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC5ECA404D;
        Fri, 25 Oct 2019 17:06:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89EA9A4040;
        Fri, 25 Oct 2019 17:06:36 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 17:06:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
Date:   Fri, 25 Oct 2019 19:06:34 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102517-0028-0000-0000-000003AF94A4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102517-0029-0000-0000-00002471CB95
Message-Id: <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250157
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
 s390x/sclp.c        | 413 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 417 insertions(+)
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
index 0000000..29ac265
--- /dev/null
+++ b/s390x/sclp.c
@@ -0,0 +1,413 @@
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
+#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
+#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
+#define PGM_BIT_PRIV	(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
+#define MKPTR(x) ((void *)(uint64_t)(x))
+
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+static uint8_t prefix_buf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+static uint8_t sccb_template[PAGE_SIZE];
+static uint32_t valid_code;
+static struct lowcore *lc;
+
+/**
+ * Enable SCLP interrupt.
+ */
+static void sclp_setup_int_test(void)
+{
+	uint64_t mask;
+
+	ctl_set_bit(0, 9);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+}
+
+/**
+ * Perform one service call, handling exceptions and interrupts.
+ */
+static int sclp_service_call_test(unsigned int command, void *sccb)
+{
+	int cc;
+
+	sclp_mark_busy();
+	sclp_setup_int_test();
+	lc->pgm_int_code = 0;
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
+ */
+static int test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t len,
+			uint64_t exp_pgm, uint16_t exp_rc)
+{
+	SCCBHeader *h = (SCCBHeader *)addr;
+	int res, pgm;
+
+	if (len)
+		memcpy(addr, sccb_template, len);
+	if (!exp_pgm)
+		exp_pgm = 1;
+	expect_pgm_int();
+	res = sclp_service_call_test(cmd, h);
+	if (res) {
+		report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd, addr, res);
+		return 0;
+	}
+	pgm = lc->pgm_int_code;
+	if (!((1ULL << pgm) & exp_pgm)) {
+		report_info("First failure at addr %p, size %d, cmd %#x, pgm code %d", addr, len, cmd, pgm);
+		return 0;
+	}
+	if (exp_rc && (exp_rc != h->response_code)) {
+		report_info("First failure at addr %p, size %d, cmd %#x, resp code %#x",
+				addr, len, cmd, h->response_code);
+		return 0;
+	}
+	return 1;
+}
+
+/**
+ * Wrapper for test_one_sccb to set up an SCCB template
+ */
+static int test_one_run(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
+			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
+{
+	if (buf_len)
+		memset(sccb_template, 0, sizeof(sccb_template));
+	((SCCBHeader *)sccb_template)->length = sccb_len;
+	if (buf_len && buf_len < 8)
+		buf_len = 8;
+	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
+}
+
+/**
+ * Test SCCB lengths < 8
+ */
+static void test_sccb_too_short(void)
+{
+	int cx;
+
+	for (cx = 0; cx < 8; cx++)
+		if (!test_one_run(valid_code, pagebuf, cx, 8, PGM_BIT_SPEC, 0))
+			break;
+
+	report("SCCB too short", cx == 8);
+}
+
+/**
+ * Test SCCBs that are not 64bits aligned
+ */
+static void test_sccb_unaligned(void)
+{
+	int cx;
+
+	for (cx = 1; cx < 8; cx++)
+		if (!test_one_run(valid_code, cx + pagebuf, 8, 8, PGM_BIT_SPEC, 0))
+			break;
+	report("SCCB unaligned", cx == 8);
+}
+
+/**
+ * Test SCCBs whose address is in the lowcore or prefix area
+ */
+static void test_sccb_prefix(void)
+{
+	uint32_t prefix, new_prefix;
+	int cx;
+
+	// can't actually trash the lowcore, unsurprisingly things break if we do
+	for (cx = 0; cx < 8192; cx += 8)
+		if (!test_one_sccb(valid_code, MKPTR(cx), 0, PGM_BIT_SPEC, 0))
+			break;
+	report("SCCB low pages", cx == 8192);
+
+	memcpy(prefix_buf, 0, 8192);
+	new_prefix = (uint32_t)(intptr_t)prefix_buf;
+	asm volatile("stpx %0" : "=Q" (prefix));
+	asm volatile("spx %0" : : "Q" (new_prefix) : "memory");
+
+	for (cx = 0; cx < 8192; cx += 8)
+		if (!test_one_run(valid_code, MKPTR(new_prefix + cx), 8, 8, PGM_BIT_SPEC, 0))
+			break;
+	report("SCCB prefix pages", cx == 8192);
+
+	memcpy(prefix_buf, 0, 8192);
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
+	uintptr_t a[33 * 4 * 2 + 2];
+	uint64_t maxram;
+	int cx, i, pgm;
+
+	h->length = 8;
+
+	i = 0;
+	for (cx = 0; cx < 33; cx++)
+		a[i++] = 1UL << (cx + 31);
+	for (cx = 0; cx < 33; cx++)
+		a[i++] = 3UL << (cx + 31);
+	for (cx = 0; cx < 33; cx++)
+		a[i++] = 0xffffffff80000000UL << cx;
+	a[i++] = 0x80000000;
+	for (cx = 1; cx < 33; cx++, i++)
+		a[i] = a[i - 1] | (1UL << (cx + 31));
+	for (cx = 0; cx < i; cx++)
+		a[i + cx] = a[cx] + (intptr_t)pagebuf;
+	i += cx;
+	a[i++] = 0xdeadbeef00000000;
+	a[i++] = 0xdeaddeadbeef0000;
+
+	maxram = get_ram_size();
+	for (cx = 0; cx < i; cx++) {
+		pgm = PGM_BIT_SPEC | (a[cx] >= maxram ? PGM_BIT_ADDR : 0);
+		if (!test_one_sccb(valid_code, (void *)a[cx], 0, pgm, 0))
+			break;
+	}
+	report("SCCB high addresses", cx == i);
+}
+
+/**
+ * Test invalid commands, both invalid command detail codes and valid
+ * ones with invalid command class code.
+ */
+static void test_inval(void)
+{
+	uint32_t cmd;
+	int cx;
+
+	report_prefix_push("Invalid command");
+	for (cx = 0; cx < 65536; cx++) {
+		cmd = (0xdead0000) | cx;
+		if (!test_one_run(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, 0, SCLP_RC_INVALID_SCLP_COMMAND))
+			break;
+	}
+	report("Command detail code", cx == 65536);
+
+	for (cx = 0; cx < 256; cx++) {
+		cmd = (valid_code & ~0xff) | cx;
+		if (cmd == valid_code)
+			continue;
+		if (!test_one_run(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, 0, SCLP_RC_INVALID_SCLP_COMMAND))
+			break;
+	}
+	report("Command class code", cx == 256);
+	report_prefix_pop();
+}
+
+
+/**
+ * Test short SCCBs (but larger than 8).
+ */
+static void test_short(void)
+{
+	uint16_t res = SCLP_RC_INSUFFICIENT_SCCB_LENGTH;
+	int cx;
+
+	for (cx = 8; cx < 144; cx++)
+		if (!test_one_run(valid_code, pagebuf, cx, cx, 0, res))
+			break;
+	report("Insufficient SCCB length (Read SCP info)", cx == 144);
+
+	for (cx = 8; cx < 40; cx++)
+		if (!test_one_run(SCLP_READ_CPU_INFO, pagebuf, cx, cx, 0, res))
+			break;
+	report("Insufficient SCCB length (Read CPU info)", cx == 40);
+}
+
+/**
+ * Test SCCB page boundary violations.
+ */
+static void test_boundary(void)
+{
+	uint32_t cmd = SCLP_CMD_WRITE_EVENT_DATA;
+	uint16_t res = SCLP_RC_SCCB_BOUNDARY_VIOLATION;
+	WriteEventData *sccb = (WriteEventData *)sccb_template;
+	int len, cx;
+
+	memset(sccb_template, 0, sizeof(sccb_template));
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	for (len = 32; len <= 4096; len++) {
+		cx = len & 7 ? len & ~7 : len - 8;
+		for (cx = 4096 - cx; cx < 4096; cx += 8) {
+			sccb->h.length = len;
+			if (!test_one_sccb(cmd, cx + pagebuf, len, 0, res))
+				goto out;
+		}
+	}
+out:
+	report("SCCB page boundary violation", len > 4096 && cx == 4096);
+}
+
+static void test_toolong(void)
+{
+	uint32_t cmd = SCLP_CMD_WRITE_EVENT_DATA;
+	uint16_t res = SCLP_RC_SCCB_BOUNDARY_VIOLATION;
+	WriteEventData *sccb = (WriteEventData *)sccb_template;
+	int cx;
+
+	memset(sccb_template, 0, sizeof(sccb_template));
+	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
+	for (cx = 4097; cx < 8192; cx++) {
+		sccb->h.length = cx;
+		if (!test_one_sccb(cmd, pagebuf, PAGE_SIZE, 0, res))
+			break;
+	}
+	report("SCCB bigger than 4k", cx == 8192);
+}
+
+/**
+ * Test privileged operation.
+ */
+static void test_priv(void)
+{
+	report_prefix_push("Privileged operation");
+	pagebuf[0] = 0;
+	pagebuf[1] = 8;
+	expect_pgm_int();
+	enter_pstate();
+	servc(valid_code, __pa(pagebuf));
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
+	unsigned long cx, maxram = get_ram_size();
+
+	if (maxram >= 0x80000000) {
+		report_skip("Invalid SCCB address");
+		return;
+	}
+	for (cx = maxram; cx < MIN(maxram + 65536, 0x80000000); cx += 8)
+		if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
+			goto out;
+	for (; cx < MIN((maxram + 0x7fffff) & ~0xfffff, 0x80000000); cx += 4096)
+		if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
+			goto out;
+	for (; cx < 0x80000000; cx += 1048576)
+		if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
+			goto out;
+out:
+	report("Invalid SCCB address", cx == 0x80000000);
+}
+
+/**
+ * Test some bits in the instruction format that are specified to be ignored.
+ */
+static void test_instbits(void)
+{
+	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	unsigned long mask;
+	int cc;
+
+	sclp_mark_busy();
+	h->length = 8;
+
+	ctl_set_bit(0, 9);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+
+	asm volatile(
+		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
+		"       ipm     %0\n"
+		"       srl     %0,28"
+		: "=&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
+		: "cc", "memory");
+	sclp_wait_busy();
+	report("Instruction format ignored bits", cc == 0);
+}
+
+/**
+ * Find a valid SCLP command code; not all codes are always allowed, and
+ * probing should be performed in the right order.
+ */
+static void find_valid_sclp_code(void)
+{
+	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
+				    SCLP_CMDW_READ_SCP_INFO };
+	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	int i, cc;
+
+	for (i = 0; i < ARRAY_SIZE(commands); i++) {
+		sclp_mark_busy();
+		memset(h, 0, sizeof(pagebuf));
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

