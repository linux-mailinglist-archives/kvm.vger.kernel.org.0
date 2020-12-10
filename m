Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66A02D5D8E
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbgLJO06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:26:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731718AbgLJO05 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 09:26:57 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEHk64090505;
        Thu, 10 Dec 2020 09:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=KIYFCeCdetqCm0xSeaWaDc9j5zg0GqcQ6sHrtVrEtKM=;
 b=XYtd1TVGJUkHzEqP6iCEe1h4O2DwZaNQiXVtvzUHQ8eToH4kDNAxMqBYulnHti0zVxoi
 3/qRckF6r2MrmJFfj5DDGP0Ta4FOIcZaq1WKT20+fo3JRB/7iQVB1qQTprrXXg4PGjKb
 BovXGcqYeUyMJPQifEBOO7knLbPjg2wWGilS6hXtUHsHZAw67nrLacGtAZnmLUYaRAHZ
 J9CtI7iiPQa83hOQHIoaG08n1575yUeElYFt3TjZK78chO5Fa1G3KKL6ebZGqiltuzjJ
 oiL3k4h8k9XqrwsTGtT+D05pYT3qewEZpzwtz76QE8NKvLA3NVTGtRUqFUSxAM6KGDhb 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bna7g7k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:07 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAEI1tv090847;
        Thu, 10 Dec 2020 09:26:06 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bna7g7jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:06 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEI8xU011139;
        Thu, 10 Dec 2020 14:26:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3583svns1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:26:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAEQ2gh28705060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 14:26:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4684B4206C;
        Thu, 10 Dec 2020 14:26:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A07742068;
        Thu, 10 Dec 2020 14:26:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Dec 2020 14:26:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id CE962E0450; Thu, 10 Dec 2020 15:26:01 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 3/4] KVM: selftests: sync_regs test for diag318
Date:   Thu, 10 Dec 2020 15:25:58 +0100
Message-Id: <20201210142600.6771-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210142600.6771-1-borntraeger@de.ibm.com>
References: <20201210142600.6771-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_05:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Collin Walling <walling@linux.ibm.com>

The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged call
that must be intercepted via SIE, handled in userspace, and the
information set by the instruction is communicated back to KVM.

To test the instruction interception, an ad-hoc handler is defined which
simply has a VM execute the instruction and then userspace will extract
the necessary info. The handler is defined such that the instruction
invocation occurs only once. It is up to the caller to determine how the
info returned by this handler should be used.

The diag318 info is communicated from userspace to KVM via a sync_regs
call. This is tested during a sync_regs test, where the diag318 info is
requested via the handler, then the info is stored in the appropriate
register in KVM via a sync registers call.

If KVM does not support diag318, then the tests will print a message
stating that diag318 was skipped, and the asserts will simply test
against a value of 0.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Link: https://lore.kernel.org/r/20201207154125.10322-1-walling@linux.ibm.com
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../kvm/include/s390x/diag318_test_handler.h  | 13 +++
 .../kvm/lib/s390x/diag318_test_handler.c      | 82 +++++++++++++++++++
 .../selftests/kvm/s390x/sync_regs_test.c      | 16 +++-
 4 files changed, 111 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 30afbad36cd5..1b9c257fca5e 100644
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
index 000000000000..b0ed71302722
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
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
index 000000000000..86b9e611ad87
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
@@ -0,0 +1,82 @@
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
+#define VCPU_ID	6
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
+	TEST_ASSERT(diag318_info != 0, "DIAGNOSE 0x0318 info not set");
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
2.28.0

