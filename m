Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBE14DB53
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgA3NL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727247AbgA3NLz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 08:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7iQQFT+qJHHOuRaogKDsStL+M+fzum2Xs6BYqSDmKwY=;
        b=X9HupmHtAmsqFNVJ14Bm3rINV2iW7uDI4cqqK+8CoICWmIimOOAtCgvk+O4aard4BzfF22
        naJWHzN03ODlA0vOmom+k9cTrTu3V4HE3UtiSYJvBPp1eTQLy+PPPLocGAyT6pTlx904Eu
        l+FW0RpFZcWKF6Vc0OK7sQgrTVoKHNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-EuhV-gRvNf6bI0px3dQV1A-1; Thu, 30 Jan 2020 08:11:50 -0500
X-MC-Unique: EuhV-gRvNf6bI0px3dQV1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22AFF10054E3;
        Thu, 30 Jan 2020 13:11:49 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC6A17793C;
        Thu, 30 Jan 2020 13:11:46 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 6/6] s390x: SCLP unit test
Date:   Thu, 30 Jan 2020 14:11:16 +0100
Message-Id: <20200130131116.12386-7-david@redhat.com>
In-Reply-To: <20200130131116.12386-1-david@redhat.com>
References: <20200130131116.12386-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200120184256.188698-7-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/Makefile      |   1 +
 s390x/sclp.c        | 479 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   8 +
 3 files changed, 488 insertions(+)
 create mode 100644 s390x/sclp.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 3744372..ddb4b48 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -16,6 +16,7 @@ tests +=3D $(TEST_DIR)/diag288.elf
 tests +=3D $(TEST_DIR)/stsi.elf
 tests +=3D $(TEST_DIR)/skrf.elf
 tests +=3D $(TEST_DIR)/smp.elf
+tests +=3D $(TEST_DIR)/sclp.elf
 tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
=20
 all: directories test_cases test_cases_binary
diff --git a/s390x/sclp.c b/s390x/sclp.c
new file mode 100644
index 0000000..7d92bf3
--- /dev/null
+++ b/s390x/sclp.c
@@ -0,0 +1,479 @@
+/*
+ * Service Call tests
+ *
+ * Copyright (c) 2020 IBM Corp
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
+static uint8_t pagebuf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/* sc=
ratch pages used for some tests */
+static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/*=
 temporary lowcore for test_sccb_prefix */
+/* SCCB template to be used */
+static union {
+	uint8_t raw[PAGE_SIZE];
+	SCCBHeader header;
+	WriteEventData data;
+} sccb_template;
+static uint32_t valid_code;						/* valid command code for READ SCP INFO=
 */
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
+	cc =3D servc(command, __pa(sccb));
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
+ * Perform one test at the given address, optionally using the SCCB temp=
late,
+ * checking for the expected program interrupts and return codes.
+ *
+ * The parameter buf_len indicates the number of bytes of the template t=
hat
+ * should be copied to the test address, and should be 0 when the test
+ * address is invalid, in which case nothing is copied.
+ *
+ * The template is used to simplify tests where the same buffer content =
is
+ * used many times in a row, at different addresses.
+ *
+ * Returns true in case of success or false in case of failure
+ */
+static bool test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t buf_len,=
 uint64_t exp_pgm, uint16_t exp_rc)
+{
+	SCCBHeader *h =3D (SCCBHeader *)addr;
+	int res, pgm;
+
+	/* Copy the template to the test address if needed */
+	if (buf_len)
+		memcpy(addr, sccb_template.raw, buf_len);
+	if (exp_pgm !=3D PGM_NONE)
+		expect_pgm_int();
+	/* perform the actual call */
+	res =3D sclp_service_call_test(cmd, h);
+	if (res) {
+		report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd, ad=
dr, res);
+		return false;
+	}
+	pgm =3D clear_pgm_int();
+	/* Check if the program exception was one of the expected ones */
+	if (!((1ULL << pgm) & exp_pgm)) {
+		report_info("First failure at addr %p, buf_len %d, cmd %#x, pgm code %=
d",
+				addr, buf_len, cmd, pgm);
+		return false;
+	}
+	/* Check if the response code is the one expected */
+	if (exp_rc && exp_rc !=3D h->response_code) {
+		report_info("First failure at addr %p, buf_len %d, cmd %#x, resp code =
%#x",
+				addr, buf_len, cmd, h->response_code);
+		return false;
+	}
+	return true;
+}
+
+/**
+ * Wrapper for test_one_sccb to be used when the template should not be
+ * copied and the memory address should not be touched.
+ */
+static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pgm, u=
int16_t exp_rc)
+{
+	return test_one_sccb(cmd, addr, 0, exp_pgm, exp_rc);
+}
+
+/**
+ * Wrapper for test_one_sccb to set up a simple SCCB template.
+ *
+ * The parameter sccb_len indicates the value that will be saved in the =
SCCB
+ * length field of the SCCB, buf_len indicates the number of bytes of
+ * template that need to be copied to the actual test address. In many c=
ases
+ * it's enough to clear/copy the first 8 bytes of the buffer, while the =
SCCB
+ * itself can be larger.
+ *
+ * Returns true in case of success or false in case of failure
+ */
+static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_l=
en,
+			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
+{
+	memset(sccb_template.raw, 0, sizeof(sccb_template.raw));
+	sccb_template.header.length =3D sccb_len;
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
+	for (len =3D 0; len < 8; len++)
+		if (!test_one_simple(valid_code, pagebuf, len, 8, PGM_BIT_SPEC, 0))
+			break;
+
+	report(len =3D=3D 8, "SCCB too short");
+}
+
+/**
+ * Test SCCBs that are not 64-bit aligned.
+ */
+static void test_sccb_unaligned(void)
+{
+	int offset;
+
+	for (offset =3D 1; offset < 8; offset++)
+		if (!test_one_simple(valid_code, offset + pagebuf, 8, 8, PGM_BIT_SPEC,=
 0))
+			break;
+	report(offset =3D=3D 8, "SCCB unaligned");
+}
+
+/**
+ * Test SCCBs whose address is in the lowcore or prefix area.
+ */
+static void test_sccb_prefix(void)
+{
+	uint8_t scratch[LC_SIZE];
+	uint32_t prefix, new_prefix;
+	int offset;
+
+	/*
+	 * copy the current lowcore to the future new location, otherwise we
+	 * will not have a valid lowcore after setting the new prefix.
+	 */
+	memcpy(prefix_buf, 0, LC_SIZE);
+	/* save the current prefix (it's probably going to be 0) */
+	prefix =3D get_prefix();
+	/*
+	 * save the current content of absolute pages 0 and 1, so we can
+	 * restore them after we trash them later on
+	 */
+	memcpy(scratch, (void *)(intptr_t)prefix, LC_SIZE);
+	/* set the new prefix to prefix_buf */
+	new_prefix =3D (uint32_t)(intptr_t)prefix_buf;
+	set_prefix(new_prefix);
+
+	/*
+	 * testing with SCCB addresses in the lowcore; since we can't
+	 * actually trash the lowcore (unsurprisingly, things break if we
+	 * do), this will be a read-only test.
+	 */
+	for (offset =3D 0; offset < LC_SIZE; offset +=3D 8)
+		if (!test_one_ro(valid_code, MKPTR(offset), PGM_BIT_SPEC, 0))
+			break;
+	report(offset =3D=3D LC_SIZE, "SCCB low pages");
+
+	/*
+	 * the SCLP should not even touch the memory, but we will write the
+	 * SCCBs all over the two pages starting at absolute address 0, thus
+	 * trashing them; we will need to restore them later.
+	 */
+	for (offset =3D 0; offset < LC_SIZE; offset +=3D 8)
+		if (!test_one_simple(valid_code, MKPTR(new_prefix + offset), 8, 8, PGM=
_BIT_SPEC, 0))
+			break;
+	report(offset =3D=3D LC_SIZE, "SCCB prefix pages");
+
+	/* restore the previous contents of absolute pages 0 and 1 */
+	memcpy(prefix_buf, 0, LC_SIZE);
+	/* restore the prefix to the original value */
+	set_prefix(prefix);
+}
+
+/**
+ * Test SCCBs that are above 2GB. If outside of memory, an addressing
+ * exception is also allowed.
+ */
+static void test_sccb_high(void)
+{
+	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
+	uintptr_t a[33 * 4 * 2 + 2];	/* for the list of addresses to test */
+
+	uint64_t maxram;
+	int i, pgm, len =3D 0;
+
+	h->length =3D 8;
+	/* addresses with 1 bit set in the first 33 bits */
+	for (i =3D 0; i < 33; i++)
+		a[len++] =3D 1UL << (i + 31);
+	/* addresses with 2 consecutive bits set in the first 33 bits */
+	for (i =3D 0; i < 33; i++)
+		a[len++] =3D 3UL << (i + 31);
+	/* addresses with all bits set in bits 0..N */
+	for (i =3D 0; i < 33; i++)
+		a[len++] =3D 0xffffffff80000000UL << i;
+	/* addresses with all bits set in bits N..33 */
+	a[len++] =3D 0x80000000;
+	for (i =3D 1; i < 33; i++, len++)
+		a[len] =3D a[len - 1] | (1UL << (i + 31));
+	/* all the addresses above, but adding the offset of a valid buffer */
+	for (i =3D 0; i < len; i++)
+		a[len + i] =3D a[i] + (intptr_t)h;
+	len +=3D i;
+	/* two more hand-crafted addresses */
+	a[len++] =3D 0xdeadbeef00000000;
+	a[len++] =3D 0xdeaddeadbeef0000;
+
+	maxram =3D get_ram_size();
+	for (i =3D 0; i < len; i++) {
+		pgm =3D PGM_BIT_SPEC | (a[i] >=3D maxram ? PGM_BIT_ADDR : 0);
+		if (!test_one_ro(valid_code, (void *)a[i], pgm, 0))
+			break;
+	}
+	report(i =3D=3D len, "SCCB high addresses");
+}
+
+/**
+ * Test invalid commands, both invalid command detail codes and valid
+ * ones with invalid command class code.
+ */
+static void test_inval(void)
+{
+	const uint16_t res =3D SCLP_RC_INVALID_SCLP_COMMAND;
+	uint32_t cmd;
+	int i;
+
+	report_prefix_push("Invalid command");
+	for (i =3D 0; i < 65536; i++) {
+		cmd =3D 0xdead0000 | i;
+		if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE, res=
))
+			break;
+	}
+	report(i =3D=3D 65536, "Command detail code");
+
+	for (i =3D 0; i < 256; i++) {
+		cmd =3D (valid_code & ~0xff) | i;
+		if (cmd =3D=3D valid_code)
+			continue;
+		if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE, res=
))
+			break;
+	}
+	report(i =3D=3D 256, "Command class code");
+	report_prefix_pop();
+}
+
+
+/**
+ * Test short SCCBs (but larger than 8).
+ */
+static void test_short(void)
+{
+	const uint16_t res =3D SCLP_RC_INSUFFICIENT_SCCB_LENGTH;
+	int len;
+
+	for (len =3D 8; len < 144; len++)
+		if (!test_one_simple(valid_code, pagebuf, len, len, PGM_NONE, res))
+			break;
+	report(len =3D=3D 144, "Insufficient SCCB length (Read SCP info)");
+
+	for (len =3D 8; len < 40; len++)
+		if (!test_one_simple(SCLP_READ_CPU_INFO, pagebuf, len, len, PGM_NONE, =
res))
+			break;
+	report(len =3D=3D 40, "Insufficient SCCB length (Read CPU info)");
+}
+
+/**
+ * Test SCCB page boundary violations.
+ */
+static void test_boundary(void)
+{
+	const uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
+	const uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
+	WriteEventData *sccb =3D &sccb_template.data;
+	int len, offset;
+
+	memset(sccb_template.raw, 0, sizeof(sccb_template.raw));
+	sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
+	for (len =3D 32; len <=3D 4096; len++) {
+		offset =3D len & 7 ? len & ~7 : len - 8;
+		for (offset =3D 4096 - offset; offset < 4096; offset +=3D 8) {
+			sccb->h.length =3D len;
+			if (!test_one_sccb(cmd, offset + pagebuf, len, PGM_NONE, res))
+				goto out;
+		}
+	}
+out:
+	report(len > 4096 && offset =3D=3D 4096, "SCCB page boundary violation"=
);
+}
+
+/**
+ * Test excessively long SCCBs.
+ */
+static void test_toolong(void)
+{
+	const uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
+	const uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
+	WriteEventData *sccb =3D &sccb_template.data;
+	int len;
+
+	memset(sccb_template.raw, 0, sizeof(sccb_template.raw));
+	sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
+	for (len =3D 4097; len < 8192; len++) {
+		sccb->h.length =3D len;
+		if (!test_one_sccb(cmd, pagebuf, PAGE_SIZE, PGM_NONE, res))
+			break;
+	}
+	report(len =3D=3D 8192, "SCCB bigger than 4k");
+}
+
+/**
+ * Test privileged operation.
+ */
+static void test_priv(void)
+{
+	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
+
+	report_prefix_push("Privileged operation");
+	h->length =3D 8;
+	expect_pgm_int();
+	enter_pstate();
+	servc(valid_code, __pa(h));
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+}
+
+/**
+ * Test addressing exceptions. We need to test SCCB addresses between th=
e
+ * end of available memory and 2GB, because after 2GB a specification
+ * exception is also allowed.
+ * Only applicable if the VM has less than 2GB of memory
+ */
+static void test_addressing(void)
+{
+	unsigned long i, maxram =3D get_ram_size();
+
+	/* the VM has more than 2GB of memory */
+	if (maxram >=3D 0x80000000) {
+		report_skip("Invalid SCCB address");
+		return;
+	}
+	/* test all possible valid addresses immediately after the end of memor=
y
+	 * up to 64KB after the end of memory
+	 */
+	for (i =3D 0; i < 0x10000 && i + maxram < 0x80000000; i +=3D 8)
+		if (!test_one_ro(valid_code, MKPTR(i + maxram), PGM_BIT_ADDR, 0))
+			goto out;
+	/* test more addresses until we reach 1MB after end of memory;
+	 * increment by a prime number (times 8) in order to test all
+	 * possible valid offsets inside pages
+	 */
+	for (; i < 0x100000 && i + maxram < 0x80000000 ; i +=3D 808)
+		if (!test_one_ro(valid_code, MKPTR(i + maxram), PGM_BIT_ADDR, 0))
+			goto out;
+	/* test the remaining addresses until we reach address 2GB;
+	 * increment by a prime number (times 8) in order to test all
+	 * possible valid offsets inside pages
+	 */
+	for (; i + maxram < 0x80000000; i +=3D 800024)
+		if (!test_one_ro(valid_code, MKPTR(i + maxram), PGM_BIT_ADDR, 0))
+			goto out;
+out:
+	report(i + maxram >=3D 0x80000000, "Invalid SCCB address");
+}
+
+/**
+ * Test some bits in the instruction format that are specified to be ign=
ored.
+ */
+static void test_instbits(void)
+{
+	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
+	int cc;
+
+	sclp_mark_busy();
+	h->length =3D 8;
+	sclp_setup_int();
+
+	asm volatile(
+		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
+		"       ipm     %0\n"
+		"       srl     %0,28"
+		: "=3D&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
+		: "cc", "memory");
+	/* No exception, but also no command accepted, so no interrupt is
+	 * expected. We need to clear the flag manually otherwise we will
+	 * loop forever when we try to report failure.
+	 */
+	if (cc)
+		sclp_handle_ext();
+	else
+		sclp_wait_busy();
+	report(cc =3D=3D 0, "Instruction format ignored bits");
+}
+
+/**
+ * Find a valid READ INFO command code; not all codes are always allowed=
, and
+ * probing should be performed in the right order.
+ */
+static void find_valid_sclp_code(void)
+{
+	const unsigned int commands[] =3D { SCLP_CMDW_READ_SCP_INFO_FORCED,
+					  SCLP_CMDW_READ_SCP_INFO };
+	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
+	int i, cc;
+
+	for (i =3D 0; i < ARRAY_SIZE(commands); i++) {
+		sclp_mark_busy();
+		memset(h, 0, sizeof(*h));
+		h->length =3D 4096;
+
+		valid_code =3D commands[i];
+		cc =3D sclp_service_call(commands[i], h);
+		if (cc)
+			break;
+		if (h->response_code =3D=3D SCLP_RC_NORMAL_READ_COMPLETION)
+			return;
+		if (h->response_code !=3D SCLP_RC_INVALID_SCLP_COMMAND)
+			break;
+	}
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
@@ -75,3 +75,11 @@ file =3D stsi.elf
 [smp]
 file =3D smp.elf
 extra_params =3D-smp 2
+
+[sclp-1g]
+file =3D sclp.elf
+extra_params =3D -m 1G
+
+[sclp-3g]
+file =3D sclp.elf
+extra_params =3D -m 3G
--=20
2.24.1

