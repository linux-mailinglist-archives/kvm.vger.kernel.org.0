Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169C228E742
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390622AbgJNT13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 15:27:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389668AbgJNT13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 15:27:29 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EJI0hC190995
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RdrNMfvPfUwm8ntPfHZMrkgielRTP7iofjXSHaev1aA=;
 b=F63YmDiTVmuTUpwzB7bd2/ECBUh6Jq9K8z1LJBoGcdPxpWSJRaHV3fiVHcQp3oiDYATC
 Z3MkvCsoCt6DzuN4r+pBgzWzaLqpey5sOh6mlIgrBJHEqXGVXkmg5BCkJXPrF1TH/Wt8
 l0P+0b0vT0PzIJ5Fu8MlpGE4fK54zA0iIuWfVvNAfj2E69nIBdKvun81AgYHT4HE0lim
 yKMPM3QtvDwUrpkhmjGyXggNXV5RJ9nU5sqcx/3ce1YrQaIszxMLcIhjkZFDGg7lImnM
 AnuhgHGokOWEyu0EBdin7LHSu3CPr6O4EotY6cldTWyKHErX+ivJyInWKTSoQvI0krs0 SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3467a5rbkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:27:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09EJIVCB195054
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:27:28 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3467a5rbjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 15:27:28 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09EJN476021354;
        Wed, 14 Oct 2020 19:27:25 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 3434k93qcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 19:27:25 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09EJRK2g48300390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 19:27:20 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E426E136055;
        Wed, 14 Oct 2020 19:27:24 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C115136053;
        Wed, 14 Oct 2020 19:27:24 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.130.217])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 14 Oct 2020 19:27:24 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
Date:   Wed, 14 Oct 2020 15:27:10 -0400
Message-Id: <20201014192710.66578-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_11:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 suspectscore=38 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 clxscore=1011 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140132
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged call
that must be intercepted via SIE, handled in userspace, and the
information set by the instruction is communicated back to KVM.

To test the instruction interception, an ad-hoc handler is defined which
simply has a VM execute the instruction and then userspace will extract
the necessary info. The handler is defined such that the instruction
invocation occurs only once. It is up the the caller to determine how the
info returned by this handler should be used.

The diag318 info is communicated from userspace to KVM via a sync_regs
call. This is tested during a sync_regs test, where the diag318 info is
requested via the handler, then the info is stored in the appropriate
register in KVM via a sync registers call.

The diag318 info is checked to be 0 after a normal and clear reset.

If KVM does not support diag318, then the tests will print a message
stating that diag318 was skipped, and the asserts will simply test
against a value of 0.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../kvm/include/s390x/diag318_test_handler.h  | 13 +++
 .../kvm/lib/s390x/diag318_test_handler.c      | 80 +++++++++++++++++++
 tools/testing/selftests/kvm/s390x/resets.c    |  6 ++
 .../selftests/kvm/s390x/sync_regs_test.c      | 16 +++-
 5 files changed, 115 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4a166588d99f..ed172a0b83b6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -36,7 +36,7 @@ endif
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
-LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
+LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
diff --git a/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h b/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
new file mode 100644
index 000000000000..d8233ebf317b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test handler for the s390x DIAGNOSE 0x0318 instruction.
+ *
+ * Copyright (C) 2020, IBM
+ */
+
+#ifndef SELFTEST_KVM_DIAG318_TEST_HANDLER
+#define SELFTEST_KVM_DIAG318_TEST_HANDLER
+
+uint64_t get_diag318_info(void);
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
new file mode 100644
index 000000000000..024e3a9ffda7
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test handler for the s390x DIAGNOSE 0x0318 instruction.
+ *
+ * Copyright (C) 2020, IBM
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+
+#define VCPU_ID	5
+
+#define ICPT_INSTRUCTION	0x04
+#define IPA0_DIAG		0x8300
+
+static void guest_code(void)
+{
+	uint64_t diag318_info = 0x12345678;
+
+	asm volatile ("diag %0,0,0x318\n" : : "d" (diag318_info));
+}
+
+/*
+ * The DIAGNOSE 0x0318 instruction call must be handled via userspace. As such,
+ * we create an ad-hoc VM here to handle the instruction then extract the
+ * necessary data. It is up to the caller to decide what to do with that data.
+ */
+static uint64_t diag318_handler(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	uint64_t reg;
+	uint64_t diag318_info;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_run(vm, VCPU_ID);
+	run = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
+		    "DIAGNOSE 0x0318 instruction was not intercepted");
+	TEST_ASSERT(run->s390_sieic.icptcode == ICPT_INSTRUCTION,
+		    "Unexpected intercept code: 0x%x", run->s390_sieic.icptcode);
+	TEST_ASSERT((run->s390_sieic.ipa & 0xff00) == IPA0_DIAG,
+		    "Unexpected IPA0 code: 0x%x", (run->s390_sieic.ipa & 0xff00));
+
+	reg = (run->s390_sieic.ipa & 0x00f0) >> 4;
+	diag318_info = run->s.regs.gprs[reg];
+
+	kvm_vm_free(vm);
+
+	return diag318_info;
+}
+
+uint64_t get_diag318_info(void)
+{
+	static uint64_t diag318_info;
+	static bool printed_skip;
+
+	/*
+	 * If KVM does not support diag318, then return 0 to
+	 * ensure tests do not break.
+	 */
+	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
+		if (!printed_skip) {
+			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "
+				"Skipping diag318 test.\n");
+			printed_skip = true;
+		}
+		return 0;
+	}
+
+	/*
+	 * If a test has previously requested the diag318 info,
+	 * then don't bother spinning up a temporary VM again.
+	 */
+	if (!diag318_info)
+		diag318_info = diag318_handler();
+
+	return diag318_info;
+}
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index b143db6d8693..d0416ba94ec5 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -12,6 +12,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "diag318_test_handler.h"
 
 #define VCPU_ID 3
 #define LOCAL_IRQS 32
@@ -110,6 +111,8 @@ static void assert_clear(void)
 
 	TEST_ASSERT(!memcmp(sync_regs->vrs, regs_null, sizeof(sync_regs->vrs)),
 		    "vrs0-15 == 0 (sync_regs)");
+
+	TEST_ASSERT(sync_regs->diag318 == 0, "diag318 == 0 (sync_regs)");
 }
 
 static void assert_initial_noclear(void)
@@ -182,6 +185,7 @@ static void assert_normal(void)
 	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
 	TEST_ASSERT(sync_regs->pft == KVM_S390_PFAULT_TOKEN_INVALID,
 			"pft == 0xff.....  (sync_regs)");
+	TEST_ASSERT(sync_regs->diag318 == 0, "diag318 == 0 (sync_regs)");
 	assert_noirq();
 }
 
@@ -206,6 +210,7 @@ static void test_normal(void)
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
+	run->s.regs.diag318 = get_diag318_info();
 	sync_regs = &run->s.regs;
 
 	vcpu_run(vm, VCPU_ID);
@@ -250,6 +255,7 @@ static void test_clear(void)
 	pr_info("Testing clear reset\n");
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
+	run->s.regs.diag318 = get_diag318_info();
 	sync_regs = &run->s.regs;
 
 	vcpu_run(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index 5731ccf34917..caf7b8859a94 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -20,6 +20,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "diag318_test_handler.h"
 
 #define VCPU_ID 5
 
@@ -70,7 +71,7 @@ static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
 
 #undef REG_COMPARE
 
-#define TEST_SYNC_FIELDS   (KVM_SYNC_GPRS|KVM_SYNC_ACRS|KVM_SYNC_CRS)
+#define TEST_SYNC_FIELDS   (KVM_SYNC_GPRS|KVM_SYNC_ACRS|KVM_SYNC_CRS|KVM_SYNC_DIAG318)
 #define INVALID_SYNC_FIELD 0x80000000
 
 int main(int argc, char *argv[])
@@ -152,6 +153,12 @@ int main(int argc, char *argv[])
 
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	run->kvm_dirty_regs = KVM_SYNC_GPRS | KVM_SYNC_ACRS;
+
+	if (get_diag318_info() > 0) {
+		run->s.regs.diag318 = get_diag318_info();
+		run->kvm_dirty_regs |= KVM_SYNC_DIAG318;
+	}
+
 	rv = _vcpu_run(vm, VCPU_ID);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
@@ -164,6 +171,9 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(run->s.regs.acrs[0]  == 1 << 11,
 		    "acr0 sync regs value incorrect 0x%x.",
 		    run->s.regs.acrs[0]);
+	TEST_ASSERT(run->s.regs.diag318 == get_diag318_info(),
+		    "diag318 sync regs value incorrect 0x%llx.",
+		    run->s.regs.diag318);
 
 	vcpu_regs_get(vm, VCPU_ID, &regs);
 	compare_regs(&regs, &run->s.regs);
@@ -177,6 +187,7 @@ int main(int argc, char *argv[])
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	run->kvm_dirty_regs = 0;
 	run->s.regs.gprs[11] = 0xDEADBEEF;
+	run->s.regs.diag318 = 0x4B1D;
 	rv = _vcpu_run(vm, VCPU_ID);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
@@ -186,6 +197,9 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(run->s.regs.gprs[11] != 0xDEADBEEF,
 		    "r11 sync regs value incorrect 0x%llx.",
 		    run->s.regs.gprs[11]);
+	TEST_ASSERT(run->s.regs.diag318 != 0x4B1D,
+		    "diag318 sync regs value incorrect 0x%llx.",
+		    run->s.regs.diag318);
 
 	kvm_vm_free(vm);
 
-- 
2.26.2

