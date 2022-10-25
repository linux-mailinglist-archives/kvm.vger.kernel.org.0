Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F24A60CB1C
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiJYLoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiJYLnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA451735AA
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:52 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8VKT011743
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CJZF97+gkskPQAwfBvUvguO3jii+7kPjgU9+Jx5RgUw=;
 b=jafm+DORJsES+EDCBrRosjobXejqIq1AG5VbYOqR5JT9pxXOjEQY3OJPLI/3qPhNDNPX
 +Ct1FyMj2MtogBZ3nooDtnv4G9pTO9lH2exwbIfTXnG3FVpz8BLdQ7dr43msba1RpeDD
 nElE2aRR+HB9mus6VTBGXZ1rXXx2kGfTf677GudHsUeWqexJSw6Vbl8b1wPTX0r9Rc5E
 q2e7sKvTDMzjLIU5sLlQl9QuRQMPbs7pYBmMsUBudH6wgAa2HY8BKqBy43LTrugWwt4N
 qsMiXBRi3V5zWR7OMJ9Szk+f2v+tn1sGJMPS1u0EOmQkmzbclKQeN/ReBqG7uJmGHaf1 pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee02tdm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB8mkU012955
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:51 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee02tdkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:51 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBd6Wv011295;
        Tue, 25 Oct 2022 11:43:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3kc8593yv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhkB94195048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC9F2AE045;
        Tue, 25 Oct 2022 11:43:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9D33AE053;
        Tue, 25 Oct 2022 11:43:45 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:45 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/22] s390x: Add specification exception test
Date:   Tue, 25 Oct 2022 13:43:24 +0200
Message-Id: <20221025114345.28003-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RBwwpG7CmPIrjGREK0yumShe8AIvkL9y
X-Proofpoint-ORIG-GUID: jftk3mH8RTpIKjyiDjWsgwGaXI4Y0_sT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Generate specification exceptions and check that they occur.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20220928201710.3185449-2-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   5 +
 s390x/spec_ex.c          | 203 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 212 insertions(+)
 create mode 100644 s390x/spec_ex.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 649486f2..6acb7b16 100644
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
index b92291e8..aca3af8e 100644
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
 struct cpu {
 	struct lowcore *lowcore;
 	uint64_t *stack;
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
new file mode 100644
index 00000000..2d4adb8c
--- /dev/null
+++ b/s390x/spec_ex.c
@@ -0,0 +1,203 @@
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
+#include <bitops.h>
+#include <asm/interrupt.h>
+
+/* toggled to signal occurrence of invalid psw fixup */
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
+static void fixup_invalid_psw(struct stack_frame_int *stack)
+{
+	assert_msg(invalid_psw_expected,
+		   "Unexpected invalid PSW during program interrupt fixup: %#lx %#lx",
+		   lowcore.pgm_old_psw.mask, lowcore.pgm_old_psw.addr);
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
+	/*
+	 * The fixup psw is the current psw with the instruction address replaced
+	 * by the address of the nop following the instruction loading the new psw.
+	 */
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile ( "larl	%[scratch],0f\n"
+		"	stg	%[scratch],%[fixup_addr]\n"
+		"	lpswe	%[psw]\n"
+		"0:	nop\n"
+		: [scratch] "=&d" (scratch),
+		  [fixup_addr] "=&T" (fixup_psw.addr)
+		: [psw] "Q" (psw)
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
+		"	stg	%[scratch],%[fixup_addr]\n"
+		"	lpsw	%[psw]\n"
+		"0:	nop\n"
+		: [scratch] "=&d" (scratch),
+		  [fixup_addr] "=&T" (fixup_psw.addr)
+		: [psw] "Q" (psw)
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
+	/* Since the fixup sets this to false we check for false here. */
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
+/* For normal PSWs bit 12 has to be 0 to be a valid PSW*/
+static int psw_bit_12_is_1(void)
+{
+	struct psw invalid = {
+		.mask = BIT(63 - 12),
+		.addr = 0x00000000deadbeee
+	};
+
+	expect_invalid_psw(invalid);
+	load_psw(invalid);
+	return check_invalid_psw();
+}
+
+/* A short PSW needs to have bit 12 set to be valid. */
+static int short_psw_bit_12_is_0(void)
+{
+	struct psw invalid = {
+		.mask = BIT(63 - 12),
+		.addr = 0x00000000deadbeee
+	};
+	struct short_psw short_invalid = {
+		.mask = 0x0,
+		.addr = 0xdeadbeee
+	};
+
+	expect_invalid_psw(invalid);
+	load_short_psw(short_invalid);
+	/*
+	 * lpsw may optionally check bit 12 before loading the new psw
+	 * -> cannot check the expected invalid psw like with lpswe
+	 */
+	return 0;
+}
+
+static int bad_alignment(void)
+{
+	uint32_t words[5] __attribute__((aligned(16)));
+	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
+
+	/* LOAD PAIR FROM QUADWORD (LPQ) requires quadword alignment */
+	asm volatile ("lpq %%r6,%[bad]"
+		      : : [bad] "T" (*bad_aligned)
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
+		      : : [quad] "T" (quad)
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
+	void (*fixup)(struct stack_frame_int *stack);
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
index f9f102ab..412fd130 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -114,6 +114,9 @@ file = mvpg-sie.elf
 [spec_ex-sie]
 file = spec_ex-sie.elf
 
+[spec_ex]
+file = spec_ex.elf
+
 [firq-linear-cpu-ids-kvm]
 file = firq.elf
 timeout = 20
-- 
2.37.3

