Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FD78C3D0
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbjH2MJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbjH2MJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC549A3;
        Tue, 29 Aug 2023 05:09:29 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC8e5e011570;
        Tue, 29 Aug 2023 12:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w/EkkSgfdqcR2zuLkv6WP9DFoBFsJl52sZzbZE8ebMc=;
 b=NLCOKvIiBEv0efN1MbinDgvn76KuHLlXh3iE8CsNl/wry11tbuVjgqiIth75Pguw4R5t
 H/p96jqi90RVbWuuc0jTtDRt4WMv2FXv6GuC2uomW6MDFfyM1QnArCmMcm3hpRTAfpBn
 TPSE+LAYVkL+FDD58IT7bcWtGlBEOU8JfyAYOrwJth4B3kuF/9yOzutl++TpPxa+6L2Z
 P2J+cwDIU6RZXVGEsbLzw7V/bAEilbRZ8FKkUfUFIuAGPYN3H9T9OX1+BIM3s+SjJfsD
 aG/f95yEBN5eHl/AHcSYKzo69afL7MHHWHQqhcJqlEWjmC0Zyp818RhY053cxX1ts9w7 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssdqgv34h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:28 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TC8vJW013383;
        Tue, 29 Aug 2023 12:09:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssdqgv334-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:28 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TA73e0014345;
        Tue, 29 Aug 2023 12:09:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqvqn36ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9OlK13239018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0243120040;
        Tue, 29 Aug 2023 12:09:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DAA12004D;
        Tue, 29 Aug 2023 12:09:23 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 06/10] KVM: s390: selftests: Add selftest for single-stepping
Date:   Tue, 29 Aug 2023 14:04:01 +0200
Message-ID: <20230829120843.66637-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ShYnt1QbsKeBYGlXg6K-pueLCy_5oql0
X-Proofpoint-ORIG-GUID: L3T7wTJ9NQnUjOBpWPwbqCNED22cYWXq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 spamscore=0 adultscore=0 clxscore=1015 mlxscore=0 mlxlogscore=768
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308290105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

Test different variations of single-stepping into interrupts:

- SVC and PGM interrupts;
- Interrupts generated by ISKE;
- Interrupts generated by instructions emulated by KVM;
- Interrupts generated by instructions emulated by userspace.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-ID: <20230725143857.228626-7-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
[frankja@de.igm.com: s/ASSERT_EQ/TEST_ASSERT_EQ/ because function was
renamed in the selftest printf series]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/s390x/debug_test.c  | 160 ++++++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 77026907968f..6092ccfc49ac 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -169,6 +169,7 @@ TEST_GEN_PROGS_s390x += s390x/resets
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
 TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += s390x/cmma_test
+TEST_GEN_PROGS_s390x += s390x/debug_test
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += guest_print_test
diff --git a/tools/testing/selftests/kvm/s390x/debug_test.c b/tools/testing/selftests/kvm/s390x/debug_test.c
new file mode 100644
index 000000000000..84313fb27529
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
+	TEST_ASSERT_EQ(vcpu->run->psw_mask, new_psw[0]);
+	TEST_ASSERT_EQ(vcpu->run->psw_addr, new_psw[1]);
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
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_INSTRUCTION);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa & 0xff00, IPA0_DIAG);
+	vcpu_ioctl(vcpu, KVM_S390_IRQ, &irq);
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
+	TEST_ASSERT_EQ(vcpu->run->psw_mask, new_psw[0]);
+	TEST_ASSERT_EQ(vcpu->run->psw_addr, new_psw[1]);
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

