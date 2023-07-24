Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34375F048
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjGXJun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjGXJt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:49:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A788710D1;
        Mon, 24 Jul 2023 02:47:57 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9dMFF005721;
        Mon, 24 Jul 2023 09:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WHe6yOMNLc/q+wDEOAR8tNydOITsjCcz+eaD2Uu+x7s=;
 b=sDEX2oVLlRCUmxLMo0zkU6WCjAHhiztHKisTUhWTCuMFoywdw2GVWhHbbfYA4ht3dWN0
 nWZSq9DdlNyX+OPmXh+5nJXuMLL5NJtTDwWYYMR8O8Hp6b/aDe/C8BEGxSBjtM9VAbWr
 o5mcb68G4zdVqOeasvU2LnauPegM/EE4dHYlfQvS94Z2RRyW2WgdQG3K+iGT/GdPHXH4
 CAiZfZwFQM8vMNkLjfWaH/Bk5XzMVRJuVIs+SwTT0U60gPy0qqYWN34LYO1sMe2sdV1T
 AJFHZXdMB9P6xNNjXdOo2+31AchxJ9EZvhiNT8VkUiBhRR4CrAar9zfEee8oY9W1SLpe pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1muwkhdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:39 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O9dVm9006672;
        Mon, 24 Jul 2023 09:47:39 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1muwkhdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:39 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O8e1Om002065;
        Mon, 24 Jul 2023 09:47:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0temj1fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O9lYOe46596484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 09:47:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5A32004D;
        Mon, 24 Jul 2023 09:47:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BAD02004B;
        Mon, 24 Jul 2023 09:47:34 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.171.11.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 09:47:34 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 6/6] KVM: s390: selftests: Add selftest for single-stepping
Date:   Mon, 24 Jul 2023 11:44:12 +0200
Message-ID: <20230724094716.91510-7-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230724094716.91510-1-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q4kwdY-dPsnD5OotQVpQ0QvDK5H10kWr
X-Proofpoint-GUID: Qru8N8vwwc0QV1H3RPiF44tuIxYk6rE6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxlogscore=952 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test different variations of single-stepping into interrupts:

- SVC and PGM interrupts;
- Interrupts generated by ISKE;
- Interrupts generated by instructions emulated by KVM;
- Interrupts generated by instructions emulated by userspace.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/s390x/debug_test.c  | 160 ++++++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da..f3306eaa7031 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -166,6 +166,7 @@ TEST_GEN_PROGS_s390x += s390x/resets
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
 TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += s390x/cmma_test
+TEST_GEN_PROGS_s390x += s390x/debug_test
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/s390x/debug_test.c b/tools/testing/selftests/kvm/s390x/debug_test.c
new file mode 100644
index 000000000000..a8fa9fe93b3c
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/debug_test.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Test KVM debugging features. */
+#include "kvm_util.h"
+#include "test_util.h"
+
+#include <linux/kvm.h>
+
+#define __LC_SVC_NEW_PSW 0x1c0
+#define __LC_PGM_NEW_PSW 0x1d0
+#define ICPT_INSTRUCTION 0x04
+#define IPA0_DIAG 0x8300
+#define PGM_SPECIFICATION 0x06
+
+/* Common code for testing single-stepping interruptions. */
+extern char int_handler[];
+asm("int_handler:\n"
+    "j .\n");
+
+static struct kvm_vm *test_step_int_1(struct kvm_vcpu **vcpu, void *guest_code,
+				      size_t new_psw_off, uint64_t *new_psw)
+{
+	struct kvm_guest_debug debug = {};
+	struct kvm_regs regs;
+	struct kvm_vm *vm;
+	char *lowcore;
+
+	vm = vm_create_with_one_vcpu(vcpu, guest_code);
+	lowcore = addr_gpa2hva(vm, 0);
+	new_psw[0] = (*vcpu)->run->psw_mask;
+	new_psw[1] = (uint64_t)int_handler;
+	memcpy(lowcore + new_psw_off, new_psw, 16);
+	vcpu_regs_get(*vcpu, &regs);
+	regs.gprs[2] = -1;
+	vcpu_regs_set(*vcpu, &regs);
+	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
+	vcpu_guest_debug_set(*vcpu, &debug);
+	vcpu_run(*vcpu);
+
+	return vm;
+}
+
+static void test_step_int(void *guest_code, size_t new_psw_off)
+{
+	struct kvm_vcpu *vcpu;
+	uint64_t new_psw[2];
+	struct kvm_vm *vm;
+
+	vm = test_step_int_1(&vcpu, guest_code, new_psw_off, new_psw);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
+	ASSERT_EQ(vcpu->run->psw_mask, new_psw[0]);
+	ASSERT_EQ(vcpu->run->psw_addr, new_psw[1]);
+	kvm_vm_free(vm);
+}
+
+/* Test single-stepping "boring" program interruptions. */
+extern char test_step_pgm_guest_code[];
+asm("test_step_pgm_guest_code:\n"
+    ".insn rr,0x1d00,%r1,%r0 /* dr %r1,%r0 */\n"
+    "j .\n");
+
+static void test_step_pgm(void)
+{
+	test_step_int(test_step_pgm_guest_code, __LC_PGM_NEW_PSW);
+}
+
+/*
+ * Test single-stepping program interruptions caused by DIAG.
+ * Userspace emulation must not interfere with single-stepping.
+ */
+extern char test_step_pgm_diag_guest_code[];
+asm("test_step_pgm_diag_guest_code:\n"
+    "diag %r0,%r0,0\n"
+    "j .\n");
+
+static void test_step_pgm_diag(void)
+{
+	struct kvm_s390_irq irq = {
+		.type = KVM_S390_PROGRAM_INT,
+		.u.pgm.code = PGM_SPECIFICATION,
+	};
+	struct kvm_vcpu *vcpu;
+	uint64_t new_psw[2];
+	struct kvm_vm *vm;
+
+	vm = test_step_int_1(&vcpu, test_step_pgm_diag_guest_code,
+			     __LC_PGM_NEW_PSW, new_psw);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
+	ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_INSTRUCTION);
+	ASSERT_EQ(vcpu->run->s390_sieic.ipa & 0xff00, IPA0_DIAG);
+	vcpu_ioctl(vcpu, KVM_S390_IRQ, &irq);
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
+	ASSERT_EQ(vcpu->run->psw_mask, new_psw[0]);
+	ASSERT_EQ(vcpu->run->psw_addr, new_psw[1]);
+	kvm_vm_free(vm);
+}
+
+/*
+ * Test single-stepping program interruptions caused by ISKE.
+ * CPUSTAT_KSS handling must not interfere with single-stepping.
+ */
+extern char test_step_pgm_iske_guest_code[];
+asm("test_step_pgm_iske_guest_code:\n"
+    "iske %r2,%r2\n"
+    "j .\n");
+
+static void test_step_pgm_iske(void)
+{
+	test_step_int(test_step_pgm_iske_guest_code, __LC_PGM_NEW_PSW);
+}
+
+/*
+ * Test single-stepping program interruptions caused by LCTL.
+ * KVM emulation must not interfere with single-stepping.
+ */
+extern char test_step_pgm_lctl_guest_code[];
+asm("test_step_pgm_lctl_guest_code:\n"
+    "lctl %c0,%c0,1\n"
+    "j .\n");
+
+static void test_step_pgm_lctl(void)
+{
+	test_step_int(test_step_pgm_lctl_guest_code, __LC_PGM_NEW_PSW);
+}
+
+/* Test single-stepping supervisor-call interruptions. */
+extern char test_step_svc_guest_code[];
+asm("test_step_svc_guest_code:\n"
+    "svc 0\n"
+    "j .\n");
+
+static void test_step_svc(void)
+{
+	test_step_int(test_step_svc_guest_code, __LC_SVC_NEW_PSW);
+}
+
+/* Run all tests above. */
+static struct testdef {
+	const char *name;
+	void (*test)(void);
+} testlist[] = {
+	{ "single-step pgm", test_step_pgm },
+	{ "single-step pgm caused by diag", test_step_pgm_diag },
+	{ "single-step pgm caused by iske", test_step_pgm_iske },
+	{ "single-step pgm caused by lctl", test_step_pgm_lctl },
+	{ "single-step svc", test_step_svc },
+};
+
+int main(int argc, char *argv[])
+{
+	int idx;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(testlist));
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		testlist[idx].test();
+		ksft_test_result_pass("%s\n", testlist[idx].name);
+	}
+	ksft_finished();
+}
-- 
2.41.0

