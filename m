Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63E6494AB7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359501AbiATJ2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:28:34 -0500
Received: from out0-158.mail.aliyun.com ([140.205.0.158]:58139 "EHLO
        out0-158.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbiATJ2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:28:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---.Mft2meF_1642670907;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mft2meF_1642670907)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:28:27 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 1/2] x86/emulator: Add some tests for lret instruction emulation
Date:   Thu, 20 Jan 2022 17:26:58 +0800
Message-Id: <70e1054ea95f1935d5fbee417bbc6e88696287c3.1642669912.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
References: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM on the "Instruction Set Reference", when
loading segment descriptor for far return, not-present segment
check should be after all type and privilege checks. However,
__load_segment_descriptor() in x86's emulator does not-present
segment check first, so it would trigger #NP instead of #GP
if type or privilege checks fail and the segment is not present.

And if RPL < CPL, it should trigger #GP, but the check is missing
in emulator.

So add some tests for lret instruction, and it will test
those tests in hardware and emulator. Enable
kvm.force_emulation_prefix when try to test them in emulator.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 x86/emulator.c | 181 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 181 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index c5f584a9d8cc..480333a40eba 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -19,6 +19,88 @@ static int exceptions;
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 #define KVM_FEP_LENGTH 5
 static int fep_available = 1;
+static unsigned int fep_vector = -1;
+static unsigned int fep_error_code = -1;
+
+struct fep_test_case {
+	uint16_t rpl;
+	uint16_t type;
+	uint16_t dpl;
+	uint16_t p;
+	unsigned int vector;
+	unsigned int error_code;
+	const char *msg;
+};
+
+enum fep_test_inst_type {
+	FEP_TEST_LRET,
+};
+
+struct fep_test {
+	enum fep_test_inst_type type;
+	unsigned long rip_advance;
+	struct fep_test_case *kernel_testcases;
+	unsigned int kernel_testcases_count;
+	struct fep_test_case *user_testcases;
+	unsigned int user_testcases_count;
+};
+
+#define NON_CONFORM_CS_TYPE	0xb
+#define CONFORM_CS_TYPE		0xf
+#define DS_TYPE			0x3
+
+static struct fep_test_case lret_kernel_testcases[] = {
+	{0, DS_TYPE, 0, 0, GP_VECTOR, FIRST_SPARE_SEL, "lret desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, GP_VECTOR, FIRST_SPARE_SEL, "lret non-conforming && dpl!=rpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE, 3, 0, GP_VECTOR, FIRST_SPARE_SEL, "lret conforming && dpl>rpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, NP_VECTOR, FIRST_SPARE_SEL, "lret desc.p=0"},
+};
+
+static struct fep_test_case lret_user_testcases[] = {
+	{0, NON_CONFORM_CS_TYPE, 3, 1, GP_VECTOR, FIRST_SPARE_SEL, "lret rpl<cpl"},
+};
+
+static struct fep_test fep_test_lret = {
+	.type = FEP_TEST_LRET,
+	.kernel_testcases = lret_kernel_testcases,
+	.kernel_testcases_count = sizeof(lret_kernel_testcases) / sizeof(struct fep_test_case),
+	.user_testcases = lret_user_testcases,
+	.user_testcases_count = sizeof(lret_user_testcases) / sizeof(struct fep_test_case),
+};
+
+static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type type);
+
+#define TEST_LRET_ASM(seg, prefix)		\
+	asm volatile("pushq %[asm_seg]\n\t"	\
+		     "pushq $1f\n\t"		\
+		      prefix "lretq\n\t"	\
+		     "addq $16, %%rsp\n\t"	\
+		     "1:"			\
+		     : : [asm_seg]"r"(seg)	\
+		     : "memory");
+
+#define TEST_FEP_RESULT(vector, error_code, msg)	\
+	report(fep_vector == vector &&			\
+	       fep_error_code == error_code,msg);	\
+	fep_vector = -1;				\
+	fep_error_code = -1;
+
+#define TEST_FEP_INST(emulate, inst, seg, vector, error_code, msg) \
+	do {							   \
+		if (emulate) {					   \
+			TEST_##inst##_ASM(seg, KVM_FEP);	   \
+		} else {					   \
+			TEST_##inst##_ASM(seg, "");		   \
+		}						   \
+		TEST_FEP_RESULT(vector, error_code, msg);	   \
+	} while (0)
+
+#define TEST_FEP_INST_IN_USER(inst, emulate, rpl, dummy, vector, error_code, msg)\
+	do {								\
+		run_in_user((usermode_func)test_in_user, UD_VECTOR,	\
+			     emulate, rpl, FEP_TEST_##inst, 0, dummy);	\
+		TEST_FEP_RESULT(vector, error_code, msg);		\
+	} while (0)
 
 struct regs {
 	u64 rax, rbx, rcx, rdx;
@@ -890,6 +972,103 @@ static void test_mov_dr(uint64_t *mem)
 	report(rax == dr6_fixed_1, "mov_dr6");
 }
 
+static void fep_exception_handler(struct ex_regs *regs)
+{
+	fep_vector = regs->vector;
+	fep_error_code = regs->error_code;
+	regs->rip += rip_advance;
+}
+
+static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type type)
+{
+	uint16_t seg = FIRST_SPARE_SEL | rpl;
+
+	switch (type) {
+	case FEP_TEST_LRET:
+		if (emulate) {
+			TEST_LRET_ASM(seg, KVM_FEP);
+		} else {
+			TEST_LRET_ASM(seg, "");
+		}
+		break;
+	}
+}
+
+static void test_fep_common(bool emulate, struct fep_test *test)
+{
+	int i;
+	bool dummy;
+	struct fep_test_case *t;
+	uint16_t seg = FIRST_SPARE_SEL;
+
+	handle_exception(GP_VECTOR, fep_exception_handler);
+	handle_exception(NP_VECTOR, fep_exception_handler);
+	rip_advance = test->rip_advance;
+
+	gdt[seg / 8] = gdt[KERNEL_CS / 8];
+	t = test->kernel_testcases;
+	for (i = 0; i < test->kernel_testcases_count; i++) {
+		seg = FIRST_SPARE_SEL | t[i].rpl;
+		gdt[seg / 8].type = t[i].type;
+		gdt[seg / 8].dpl = t[i].dpl;
+		gdt[seg / 8].p = t[i].p;
+
+		switch (test->type) {
+		case FEP_TEST_LRET:
+			TEST_FEP_INST(emulate, LRET, seg, t[i].vector,
+				      t[i].error_code, t[i].msg);
+			break;
+		}
+	}
+
+	gdt[seg / 8] = gdt[USER_CS64 / 8];
+	t = test->user_testcases;
+	for (i = 0; i < test->user_testcases_count; i++) {
+		gdt[seg / 8].type = t[i].type;
+		gdt[seg / 8].dpl = t[i].dpl;
+		gdt[seg / 8].p = t[i].p;
+
+		switch (test->type) {
+		case FEP_TEST_LRET:
+			TEST_FEP_INST_IN_USER(LRET, emulate, t[i].rpl,
+					      &dummy, t[i].vector,
+				              t[i].error_code, t[i].msg);
+			break;
+		}
+	}
+
+	handle_exception(GP_VECTOR, 0);
+	handle_exception(NP_VECTOR, 0);
+}
+
+static unsigned long get_lret_rip_advance(void)
+{
+	extern char lret_start, lret_end;
+	unsigned long lret_rip_advance = &lret_end - &lret_start;
+
+	asm volatile("data16 mov %%cs, %%rax\n\t"
+		     "pushq %%rax\n\t"
+		     "pushq $1f\n\t"
+		     "lret_start: lretq; lret_end:\n\t"
+		     "1:\n\t"
+		     : : : "ax", "memory");
+
+	return lret_rip_advance;
+}
+
+static void test_lret(uint64_t *mem)
+{
+	printf("test lret in hw\n");
+	fep_test_lret.rip_advance = get_lret_rip_advance();
+	test_fep_common(false, &fep_test_lret);
+}
+
+static void test_em_lret(uint64_t *mem)
+{
+	printf("test lret in emulator\n");
+	test_fep_common(true, &fep_test_lret);
+}
+
 static void test_push16(uint64_t *mem)
 {
 	uint64_t rsp1, rsp2;
@@ -1164,6 +1343,7 @@ int main(void)
 	test_smsw(mem);
 	test_lmsw();
 	test_ljmp(mem);
+	test_lret(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
 	test_btc(mem);
@@ -1188,6 +1368,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_em_lret(mem);
 	} else {
 		report_skip("skipping register-only tests, "
 			    "use kvm.force_emulation_prefix=1 to enable");
-- 
2.31.1

