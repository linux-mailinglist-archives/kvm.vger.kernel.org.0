Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B3557B865
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiGTOZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 10:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiGTOZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 10:25:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581F1626C;
        Wed, 20 Jul 2022 07:25:42 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KE7VVf034594;
        Wed, 20 Jul 2022 14:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZtHmxjLQTHmExPXYWNQX2vExCQpFPQRg49w/BHBW6Vk=;
 b=da30V+uGQZa0ex4o6DODmkkT8pMvqcUj/4mFLkzyIJOexvgHh2jjG+MaaS+44IOrAJUz
 9OVP9lb0URwdxKw0iY93ARIP5gKPhLgzCJIlfmo0RxD4rcsfqzkyCXWm6s0rHPRqmPu/
 Npaf+wH1BGGJL2fYeb92RIauwvusdrjKGVX1UGXaHw7mrH5NHDNJ3Y5/UDaJU99nlvbU
 Qd5g6VcZA9RouII8YDY9ZImBtnfufrfA2mOeIylJta6qRUbRfrCQAYTABUNE8jrRbdoX
 vGUXOlcSzl3e6TJsEgKPZKknnG9R6BBf66p7V4fXdtrtSfizFG4woaG9Ss+vnCwqJieA QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hek0tgwns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 14:25:34 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26KE9LBY003532;
        Wed, 20 Jul 2022 14:25:34 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hek0tgwmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 14:25:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26KELRXp019049;
        Wed, 20 Jul 2022 14:25:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8vbfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 14:25:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26KEPS7P13238744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 14:25:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81ADC11C052;
        Wed, 20 Jul 2022 14:25:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36D5611C058;
        Wed, 20 Jul 2022 14:25:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jul 2022 14:25:28 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, qemu-s390x@nongnu.org
Subject: [kvm-unit-tests PATCH v5 1/2] s390x: Add specification exception test
Date:   Wed, 20 Jul 2022 16:25:25 +0200
Message-Id: <20220720142526.29634-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220720142526.29634-1-scgl@linux.ibm.com>
References: <20220720142526.29634-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qY6Mg08w1MEHBnMrj9Yg3y5_eY2C2Vmw
X-Proofpoint-GUID: 2wU1OyEHkyLIeFt-artWjtSs6VBjjvdM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_08,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generate specification exceptions and check that they occur.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   5 ++
 s390x/spec_ex.c          | 180 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 189 insertions(+)
 create mode 100644 s390x/spec_ex.c

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c1..58b1bf54 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -27,6 +27,7 @@ tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
+tests += $(TEST_DIR)/spec_ex.elf
 tests += $(TEST_DIR)/firq.elf
 tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 78b257b7..8fbc451c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -41,6 +41,11 @@ struct psw {
 	uint64_t	addr;
 };
 
+struct short_psw {
+	uint32_t	mask;
+	uint32_t	addr;
+};
+
 #define AS_PRIM				0
 #define AS_ACCR				1
 #define AS_SECN				2
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
new file mode 100644
index 00000000..77fc6246
--- /dev/null
+++ b/s390x/spec_ex.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2021, 2022
+ *
+ * Specification exception test.
+ * Tests that specification exceptions occur when expected.
+ *
+ * Can be extended by adding triggers to spec_ex_triggers, see comments below.
+ */
+#include <stdlib.h>
+#include <libcflat.h>
+#include <asm/interrupt.h>
+
+static bool invalid_psw_expected;
+static struct psw expected_psw;
+static struct psw invalid_psw;
+static struct psw fixup_psw;
+
+/*
+ * The standard program exception handler cannot deal with invalid old PSWs,
+ * especially not invalid instruction addresses, as in that case one cannot
+ * find the instruction following the faulting one from the old PSW.
+ * The PSW to return to is set by load_psw.
+ */
+static void fixup_invalid_psw(void)
+{
+	/* signal occurrence of invalid psw fixup */
+	invalid_psw_expected = false;
+	invalid_psw = lowcore.pgm_old_psw;
+	lowcore.pgm_old_psw = fixup_psw;
+}
+
+/*
+ * Load possibly invalid psw, but setup fixup_psw before,
+ * so that fixup_invalid_psw() can bring us back onto the right track.
+ * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
+ */
+static void load_psw(struct psw psw)
+{
+	uint64_t scratch;
+
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile ( "larl	%[scratch],0f\n"
+		"	stg	%[scratch],%[addr]\n"
+		"	lpswe	%[psw]\n"
+		"0:	nop\n"
+		: [scratch] "=&d"(scratch),
+		  [addr] "=&T"(fixup_psw.addr)
+		: [psw] "Q"(psw)
+		: "cc", "memory"
+	);
+}
+
+static void load_short_psw(struct short_psw psw)
+{
+	uint64_t scratch;
+
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile ( "larl	%[scratch],0f\n"
+		"	stg	%[scratch],%[addr]\n"
+		"	lpsw	%[psw]\n"
+		"0:	nop\n"
+		: [scratch] "=&d"(scratch),
+		  [addr] "=&T"(fixup_psw.addr)
+		: [psw] "Q"(psw)
+		: "cc", "memory"
+	);
+}
+
+static void expect_invalid_psw(struct psw psw)
+{
+	expected_psw = psw;
+	invalid_psw_expected = true;
+}
+
+static int check_invalid_psw(void)
+{
+	/* toggled to signal occurrence of invalid psw fixup */
+	if (!invalid_psw_expected) {
+		if (expected_psw.mask == invalid_psw.mask &&
+		    expected_psw.addr == invalid_psw.addr)
+			return 0;
+		report_fail("Wrong invalid PSW");
+	} else {
+		report_fail("Expected exception due to invalid PSW");
+	}
+	return 1;
+}
+
+static int psw_bit_12_is_1(void)
+{
+	struct psw invalid = { .mask = 0x0008000000000000, .addr = 0x00000000deadbeee};
+
+	expect_invalid_psw(invalid);
+	load_psw(invalid);
+	return check_invalid_psw();
+}
+
+static int short_psw_bit_12_is_0(void)
+{
+	struct short_psw short_invalid = { .mask = 0x00000000, .addr = 0xdeadbeee};
+
+	/*
+	 * lpsw may optionally check bit 12 before loading the new psw
+	 * -> cannot check the expected invalid psw like with lpswe
+	 */
+	load_short_psw(short_invalid);
+	return 0;
+}
+
+static int bad_alignment(void)
+{
+	uint32_t words[5] __attribute__((aligned(16)));
+	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
+
+	asm volatile ("lpq %%r6,%[bad]"
+		      : : [bad] "T"(*bad_aligned)
+		      : "%r6", "%r7"
+	);
+	return 0;
+}
+
+static int not_even(void)
+{
+	uint64_t quad[2] __attribute__((aligned(16))) = {0};
+
+	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
+		      : : [quad] "T"(quad)
+		      : "%r7", "%r8"
+	);
+	return 0;
+}
+
+/*
+ * Harness for specification exception testing.
+ * func only triggers exception, reporting is taken care of automatically.
+ */
+struct spec_ex_trigger {
+	const char *name;
+	int (*func)(void);
+	void (*fixup)(void);
+};
+
+/* List of all tests to execute */
+static const struct spec_ex_trigger spec_ex_triggers[] = {
+	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
+	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, &fixup_invalid_psw },
+	{ "bad_alignment", &bad_alignment, NULL },
+	{ "not_even", &not_even, NULL },
+	{ NULL, NULL, NULL },
+};
+
+static void test_spec_ex(const struct spec_ex_trigger *trigger)
+{
+	int rc;
+
+	expect_pgm_int();
+	register_pgm_cleanup_func(trigger->fixup);
+	rc = trigger->func();
+	register_pgm_cleanup_func(NULL);
+	/* test failed, nothing to be done, reporting responsibility of trigger */
+	if (rc)
+		return;
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+}
+
+int main(int argc, char **argv)
+{
+	unsigned int i;
+
+	report_prefix_push("specification exception");
+	for (i = 0; spec_ex_triggers[i].name; i++) {
+		report_prefix_push(spec_ex_triggers[i].name);
+		test_spec_ex(&spec_ex_triggers[i]);
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 8e52f560..d2740a40 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -113,6 +113,9 @@ file = mvpg-sie.elf
 [spec_ex-sie]
 file = spec_ex-sie.elf
 
+[spec_ex]
+file = spec_ex.elf
+
 [firq-linear-cpu-ids-kvm]
 file = firq.elf
 timeout = 20
-- 
2.36.1

