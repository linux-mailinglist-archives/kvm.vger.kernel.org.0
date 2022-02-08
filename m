Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFA4AD4FF
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 10:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355026AbiBHJcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 04:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355018AbiBHJb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:31:59 -0500
Received: from out0-151.mail.aliyun.com (out0-151.mail.aliyun.com [140.205.0.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FADC03FEDA
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 01:31:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047212;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.Mn.4eeJ_1644312701;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mn.4eeJ_1644312701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 17:31:41 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2 1/2] x86/emulator: Add some tests for lret instruction emulation
Date:   Tue, 08 Feb 2022 17:30:56 +0800
Message-Id: <006c75f53539958c1e5d5a0a5073566a5395414e.1644311445.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1644311445.git.houwenlong.hwl@antgroup.com>
References: <cover.1644311445.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 x86/emulator.c | 130 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index 22a518f4ad65..a68debaabef0 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -19,6 +19,66 @@ static int exceptions;
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 #define KVM_FEP_LENGTH 5
 static int fep_available = 1;
+static unsigned int far_xfer_vector = -1;
+static unsigned int far_xfer_error_code = -1;
+
+struct far_xfer_test_case {
+	uint16_t rpl;
+	uint16_t type;
+	uint16_t dpl;
+	uint16_t p;
+	bool usermode;
+	unsigned int vector;
+	unsigned int error_code;
+	const char *msg;
+};
+
+enum far_xfer_insn {
+	FAR_XFER_RET,
+};
+
+struct far_xfer_test {
+	enum far_xfer_insn insn;
+	struct far_xfer_test_case *testcases;
+	unsigned int nr_testcases;
+};
+
+#define NON_CONFORM_CS_TYPE	0xb
+#define CONFORM_CS_TYPE		0xf
+#define DS_TYPE			0x3
+
+static struct far_xfer_test_case far_ret_testcases[] = {
+	{0, DS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret non-conforming && dpl!=rpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "lret conforming && dpl>rpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, FIRST_SPARE_SEL, "lret desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 1, true, GP_VECTOR, FIRST_SPARE_SEL, "lret rpl<cpl"},
+};
+
+static struct far_xfer_test far_ret_test = {
+	.insn = FAR_XFER_RET,
+	.testcases = &far_ret_testcases[0],
+	.nr_testcases = sizeof(far_ret_testcases) / sizeof(struct far_xfer_test_case),
+};
+
+#define TEST_FAR_RET_ASM(seg, prefix)		\
+	asm volatile("lea 1f(%%rip), %%rax\n\t" \
+		     "pushq %[asm_seg]\n\t"	\
+		     "pushq $2f\n\t"		\
+		      prefix "lretq\n\t"	\
+		     "1: addq $16, %%rsp\n\t"	\
+		     "2:"			\
+		     : : [asm_seg]"r"(seg)	\
+		     : "eax", "memory");
+
+static inline void test_far_ret_asm(uint16_t seg, bool force_emulation)
+{
+	if (force_emulation) {
+		TEST_FAR_RET_ASM(seg, KVM_FEP);
+	} else {
+		TEST_FAR_RET_ASM(seg, "");
+	}
+}
 
 struct regs {
 	u64 rax, rbx, rcx, rdx;
@@ -891,6 +951,74 @@ static void test_mov_dr(uint64_t *mem)
 	report(rax == dr6_fixed_1, "mov_dr6");
 }
 
+static void far_xfer_exception_handler(struct ex_regs *regs)
+{
+	far_xfer_vector = regs->vector;
+	far_xfer_error_code = regs->error_code;
+	regs->rip = regs->rax;;
+}
+
+static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
+			    bool force_emulation)
+{
+	switch (insn) {
+	case FAR_XFER_RET:
+		test_far_ret_asm(seg, force_emulation);
+		break;
+	default:
+		report_fail("unknown instructions");
+		break;
+	}
+}
+
+static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
+{
+	struct far_xfer_test_case *t;
+	uint16_t seg;
+	bool ign;
+	int i;
+
+	handle_exception(GP_VECTOR, far_xfer_exception_handler);
+	handle_exception(NP_VECTOR, far_xfer_exception_handler);
+
+	for (i = 0; i < test->nr_testcases; i++) {
+		t = &test->testcases[i];
+
+		seg = FIRST_SPARE_SEL | t->rpl;
+		gdt[seg / 8] = gdt[(t->usermode ? USER_CS64 : KERNEL_CS) / 8];
+		gdt[seg / 8].type = t->type;
+		gdt[seg / 8].dpl = t->dpl;
+		gdt[seg / 8].p = t->p;
+
+		far_xfer_vector = -1;
+		far_xfer_error_code = -1;
+
+		if (t->usermode)
+			run_in_user((usermode_func)__test_far_xfer, UD_VECTOR,
+				    test->insn, seg, force_emulation, 0, &ign);
+		else
+			__test_far_xfer(test->insn, seg, force_emulation);
+
+		report(far_xfer_vector == t->vector &&
+		       far_xfer_error_code == t->error_code, t->msg);
+	}
+
+	handle_exception(GP_VECTOR, 0);
+	handle_exception(NP_VECTOR, 0);
+}
+
+static void test_lret(uint64_t *mem)
+{
+	printf("test lret in hw\n");
+	test_far_xfer(false, &far_ret_test);
+}
+
+static void test_em_lret(uint64_t *mem)
+{
+	printf("test lret in emulator\n");
+	test_far_xfer(true, &far_ret_test);
+}
+
 static void test_push16(uint64_t *mem)
 {
 	uint64_t rsp1, rsp2;
@@ -1165,6 +1293,7 @@ int main(void)
 	test_smsw(mem);
 	test_lmsw();
 	test_ljmp(mem);
+	test_lret(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
 	test_btc(mem);
@@ -1189,6 +1318,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_em_lret(mem);
 	} else {
 		report_skip("skipping register-only tests, "
 			    "use kvm.force_emulation_prefix=1 to enable");
-- 
2.31.1

