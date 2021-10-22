Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23BF43765A
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 14:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJVMFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 08:05:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229842AbhJVMFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 08:05:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M9ZV04007687;
        Fri, 22 Oct 2021 08:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iieJ2Y6rhpgSvEw4IZLEBcRizHP7M27aqse77ePPDFs=;
 b=eHat7MRk/i3J350GMNOjtxm5wnZVegresuI7AhDMZxQokU9n7bZ0Mo+WGS3/0kxZ0B7d
 hczjl3AQttkzxgWLkcE+uCJDl8n6SKX40CQXcWiCIgkzQgzG4P4UHfSdsTJ1AT9FPpL3
 pntsxdYx8KZKylaxYQlezTboMjHkWEuWwJYSadRoURyx1I28ST/xsE82njhiNVfSdrjq
 R3QtE1y26M2R5Tj4ugzL4Drf/rqeBt3GyC35QmGFhTJ2x5FefRGOA59NqeK3e00NJ0xv
 giExJcLAJwdjN5GjM5kWInabTwKR+wcGv9iwXNct2t89kDu9ro1LPj6ZDnUSAYCNEVpV qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu773j0kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:03:06 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19MBoaoY027336;
        Fri, 22 Oct 2021 08:03:05 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu773j0jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:03:05 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MBwOnu014817;
        Fri, 22 Oct 2021 12:03:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcbg25r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 12:02:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MBu4Bd60555692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 11:56:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47DCC5208E;
        Fri, 22 Oct 2021 12:02:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 14C2852063;
        Fri, 22 Oct 2021 12:02:00 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/2] s390x: Add specification exception test
Date:   Fri, 22 Oct 2021 14:01:55 +0200
Message-Id: <20211022120156.281567-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022120156.281567-1-scgl@linux.ibm.com>
References: <20211022120156.281567-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L3tDLzTOE5swrom9CuO_YbibfkZZL_HL
X-Proofpoint-GUID: 4nOMLOV-BOuvs7pu9_JvPPeFinO9kZ0m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generate specification exceptions and check that they occur.
With the iterations argument one can check if specification
exception interpretation occurs, e.g. by using a high value and
checking that the debugfs counters are substantially lower.
The argument is also useful for estimating the performance benefit
of interpretation.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/spec_ex.c     | 181 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 185 insertions(+)
 create mode 100644 s390x/spec_ex.c

diff --git a/s390x/Makefile b/s390x/Makefile
index d18b08b..3e42784 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
+tests += $(TEST_DIR)/spec_ex.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
new file mode 100644
index 0000000..ec3322a
--- /dev/null
+++ b/s390x/spec_ex.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2021
+ *
+ * Specification exception test.
+ * Tests that specification exceptions occur when expected.
+ */
+#include <stdlib.h>
+#include <libcflat.h>
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+
+static struct lowcore *lc = (struct lowcore *) 0;
+
+static bool expect_invalid_psw;
+static struct psw expected_psw;
+static struct psw fixup_psw;
+
+/* The standard program exception handler cannot deal with invalid old PSWs,
+ * especially not invalid instruction addresses, as in that case one cannot
+ * find the instruction following the faulting one from the old PSW.
+ * The PSW to return to is set by load_psw.
+ */
+static void fixup_invalid_psw(void)
+{
+	if (expect_invalid_psw) {
+		report(expected_psw.mask == lc->pgm_old_psw.mask
+		       && expected_psw.addr == lc->pgm_old_psw.addr,
+		       "Invalid program new PSW as expected");
+		expect_invalid_psw = false;
+	}
+	lc->pgm_old_psw = fixup_psw;
+}
+
+/* Load possibly invalid psw, but setup fixup_psw before,
+ * so that *fixup_invalid_psw() can bring us back onto the right track.
+ */
+static void load_psw(struct psw psw)
+{
+	uint64_t scratch;
+
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile (
+		"	larl	%[scratch],nop%=\n"
+		"	stg	%[scratch],%[addr]\n"
+		"	lpswe	%[psw]\n"
+		"nop%=:	nop\n"
+		: [scratch] "=&r"(scratch),
+		  [addr] "=&T"(fixup_psw.addr)
+		: [psw] "Q"(psw)
+		: "cc", "memory"
+	);
+}
+
+static void psw_bit_12_is_1(void)
+{
+	expected_psw.mask = 0x0008000000000000;
+	expected_psw.addr = 0x00000000deadbeee;
+	expect_invalid_psw = true;
+	load_psw(expected_psw);
+}
+
+static void bad_alignment(void)
+{
+	uint32_t words[5] = {0, 0, 0};
+	uint32_t (*bad_aligned)[4];
+
+	register uint64_t r1 asm("6");
+	register uint64_t r2 asm("7");
+	if (((uintptr_t)&words[0]) & 0xf)
+		bad_aligned = (uint32_t (*)[4])&words[0];
+	else
+		bad_aligned = (uint32_t (*)[4])&words[1];
+	asm volatile ("lpq %0,%2"
+		      : "=r"(r1), "=r"(r2)
+		      : "T"(*bad_aligned)
+	);
+}
+
+static void not_even(void)
+{
+	uint64_t quad[2];
+
+	register uint64_t r1 asm("7");
+	register uint64_t r2 asm("8");
+	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq %0,%2
+		      : "=r"(r1), "=r"(r2)
+		      : "T"(quad)
+	);
+}
+
+struct spec_ex_trigger {
+	const char *name;
+	void (*func)(void);
+	void (*fixup)(void);
+};
+
+static const struct spec_ex_trigger spec_ex_triggers[] = {
+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
+	{ "bad_alignment", &bad_alignment, NULL},
+	{ "not_even", &not_even, NULL},
+	{ NULL, NULL, NULL},
+};
+
+struct args {
+	uint64_t iterations;
+};
+
+static void test_spec_ex(struct args *args,
+			 const struct spec_ex_trigger *trigger)
+{
+	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
+	uint16_t pgm;
+	unsigned int i;
+
+	for (i = 0; i < args->iterations; i++) {
+		expect_pgm_int();
+		register_pgm_cleanup_func(trigger->fixup);
+		trigger->func();
+		register_pgm_cleanup_func(NULL);
+		pgm = clear_pgm_int();
+		if (pgm != expected_pgm) {
+			report_fail("Program interrupt: expected(%d) == received(%d)",
+				    expected_pgm,
+				    pgm);
+			return;
+		}
+	}
+	report_pass("Program interrupt: always expected(%d) == received(%d)",
+		    expected_pgm,
+		    expected_pgm);
+}
+
+static struct args parse_args(int argc, char **argv)
+{
+	struct args args = {
+		.iterations = 1,
+	};
+	unsigned int i;
+	long arg;
+	bool no_arg;
+	char *end;
+
+	for (i = 1; i < argc; i++) {
+		no_arg = true;
+		if (i < argc - 1) {
+			no_arg = *argv[i + 1] == '\0';
+			arg = strtol(argv[i + 1], &end, 10);
+			no_arg |= *end != '\0';
+			no_arg |= arg < 0;
+		}
+
+		if (!strcmp("--iterations", argv[i])) {
+			if (no_arg)
+				report_abort("--iterations needs a positive parameter");
+			args.iterations = arg;
+			++i;
+		} else {
+			report_abort("Unsupported parameter '%s'",
+				     argv[i]);
+		}
+	}
+	return args;
+}
+
+int main(int argc, char **argv)
+{
+	unsigned int i;
+
+	struct args args = parse_args(argc, argv);
+
+	report_prefix_push("specification exception");
+	for (i = 0; spec_ex_triggers[i].name; i++) {
+		report_prefix_push(spec_ex_triggers[i].name);
+		test_spec_ex(&args, &spec_ex_triggers[i]);
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9e1802f..5f43d52 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -109,3 +109,6 @@ file = edat.elf
 
 [mvpg-sie]
 file = mvpg-sie.elf
+
+[spec_ex]
+file = spec_ex.elf
-- 
2.31.1

