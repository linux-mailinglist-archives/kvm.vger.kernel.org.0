Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EEA48B262
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350108AbiAKQjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:39:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349910AbiAKQjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 11:39:10 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BG6Hth004813;
        Tue, 11 Jan 2022 16:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bAzr/1d+D0tsijKT/bmm6BXasHN7Z9rZkiDEy4pq6KQ=;
 b=bCNGbolZtEExrJMyzVW1cXqPf5tQLHoNR+NBWyKePGpHPOSW5DGkD1mo+BtokybplIfv
 LTF145Z+w+Q+toSAj2AHiS7GbUcPKfbOyOSbcwXzmmLAPMJJtQPeX4X4jvlLgY+7e/em
 oSGCbwlCEyNq3FnhQW2mVNIU2/UJfSfIkLsbJdUyllQFT6KTjxRuha2OR0MXSZgU6LhD
 B9CDkwcMofrF2mVkl9a6lv9YIwlWzRfq6sn5Nl/nWeZ9t2O5r8Vfq9lZHuHHDrJb96rV
 egNRqvZjnIugsmOStGLYj79yXnD0ojnKwV6O4qclP0KuoJ7m3iitIBPK8xS7+JHD+Ncw YA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm05kdy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:09 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BGWCtW029177;
        Tue, 11 Jan 2022 16:39:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3df2897y1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:39:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BGd4v644499284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:39:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4C3052065;
        Tue, 11 Jan 2022 16:39:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9F425208E;
        Tue, 11 Jan 2022 16:39:03 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/2] s390x: Add specification exception test
Date:   Tue, 11 Jan 2022 17:39:00 +0100
Message-Id: <20220111163901.1263736-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220111163901.1263736-1-scgl@linux.ibm.com>
References: <20220111163901.1263736-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ORaTZkv2jlNbTaCYACI9DQqkH81xpFKi
X-Proofpoint-ORIG-GUID: ORaTZkv2jlNbTaCYACI9DQqkH81xpFKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generate specification exceptions and check that they occur.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/spec_ex.c     | 154 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 158 insertions(+)
 create mode 100644 s390x/spec_ex.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1e567c1..5635c08 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
+tests += $(TEST_DIR)/spec_ex.elf
 tests += $(TEST_DIR)/firq.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
new file mode 100644
index 0000000..a9f9f31
--- /dev/null
+++ b/s390x/spec_ex.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright IBM Corp. 2021
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
+static struct lowcore *lc = (struct lowcore *) 0;
+
+static bool invalid_psw_expected;
+static struct psw expected_psw;
+static struct psw invalid_psw;
+static struct psw fixup_psw;
+
+/* The standard program exception handler cannot deal with invalid old PSWs,
+ * especially not invalid instruction addresses, as in that case one cannot
+ * find the instruction following the faulting one from the old PSW.
+ * The PSW to return to is set by load_psw.
+ */
+static void fixup_invalid_psw(void)
+{
+	// signal occurrence of invalid psw fixup
+	invalid_psw_expected = false;
+	invalid_psw = lc->pgm_old_psw;
+	lc->pgm_old_psw = fixup_psw;
+}
+
+/* Load possibly invalid psw, but setup fixup_psw before,
+ * so that *fixup_invalid_psw() can bring us back onto the right track.
+ * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
+ */
+static void load_psw(struct psw psw)
+{
+	uint64_t scratch;
+
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile ( "larl	%[scratch],nop%=\n"
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
+static void expect_invalid_psw(struct psw psw)
+{
+	expected_psw = psw;
+	invalid_psw_expected = true;
+}
+
+static int check_invalid_psw(void)
+{
+	// toggled to signal occurrence of invalid psw fixup
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
+	load_psw(expected_psw);
+	return check_invalid_psw();
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
+	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" //lpq %%r7,%[quad]
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
+	{ "bad_alignment", &bad_alignment, NULL },
+	{ "not_even", &not_even, NULL },
+	{ NULL, NULL, NULL },
+};
+
+static void test_spec_ex(const struct spec_ex_trigger *trigger)
+{
+	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
+	uint16_t pgm;
+	int rc;
+
+	expect_pgm_int();
+	register_pgm_cleanup_func(trigger->fixup);
+	rc = trigger->func();
+	register_pgm_cleanup_func(NULL);
+	if (rc)
+		return;
+	pgm = clear_pgm_int();
+	report(pgm == expected_pgm, "Program interrupt: expected(%d) == received(%d)",
+	       expected_pgm, pgm);
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
index 054560c..26510cf 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -113,6 +113,9 @@ file = mvpg-sie.elf
 [spec_ex-sie]
 file = spec_ex-sie.elf
 
+[spec_ex]
+file = spec_ex.elf
+
 [firq-linear-cpu-ids]
 file = firq.elf
 timeout = 20
-- 
2.33.1

