Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72A64C41C1
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 10:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbiBYJuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 04:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbiBYJuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 04:50:21 -0500
Received: from out0-156.mail.aliyun.com (out0-156.mail.aliyun.com [140.205.0.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78FB24FB80
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 01:49:48 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.Mvtm13J_1645782586;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mvtm13J_1645782586)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Feb 2022 17:49:46 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>
Subject: [kvm-unit-tests PATCH v4 1/3] x86/emulator: Add some tests for far ret instruction emulation
Date:   Fri, 25 Feb 2022 17:49:25 +0800
Message-Id: <e71e643dedf779830152ec46543ef0fa41dad16d.1645672780.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1645672780.git.houwenlong.hwl@antgroup.com>
References: <cover.1645672780.git.houwenlong.hwl@antgroup.com>
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

So add some tests for far ret instruction, and it will test
those tests on hardware and emulator. Enable
kvm.force_emulation_prefix when try to test them on emulator.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 130 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index cd78e3cbbcd7..c62dcedac991 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -21,6 +21,61 @@ static int exceptions;
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 #define KVM_FEP_LENGTH 5
 static int fep_available = 1;
+static int far_xfer_vector = -1;
+static unsigned int far_xfer_error_code = -1;
+
+struct far_xfer_test_case {
+	uint16_t rpl;
+	uint16_t type;
+	uint16_t dpl;
+	uint16_t p;
+	bool usermode;
+	int vector;
+	const char *msg;
+};
+
+enum far_xfer_insn {
+	FAR_XFER_RET,
+};
+
+struct far_xfer_test {
+	enum far_xfer_insn insn;
+	const char *insn_name;
+	struct far_xfer_test_case *testcases;
+	unsigned int nr_testcases;
+};
+
+#define NON_CONFORM_CS_TYPE	0xb
+#define CONFORM_CS_TYPE		0xf
+#define DS_TYPE			0x3
+
+static struct far_xfer_test_case far_ret_testcases[] = {
+	{0, DS_TYPE,		 0, 0, false, GP_VECTOR, "desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, "non-conforming && dpl!=rpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE,	 3, 0, false, GP_VECTOR, "conforming && dpl>rpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, "desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 1, true,  GP_VECTOR, "rpl<cpl"},
+};
+
+static struct far_xfer_test far_ret_test = {
+	.insn = FAR_XFER_RET,
+	.insn_name = "far ret",
+	.testcases = &far_ret_testcases[0],
+	.nr_testcases = sizeof(far_ret_testcases) / sizeof(struct far_xfer_test_case),
+};
+
+#define TEST_FAR_RET_ASM(seg, prefix)		\
+({						\
+	asm volatile("pushq %[asm_seg]\n\t"	\
+		     "lea 2f(%%rip), %%rax\n\t" \
+		     "pushq %%rax\n\t"		\
+		     "lea 1f(%%rip), %%rax\n\t" \
+		      prefix "lretq\n\t"	\
+		     "1: addq $16, %%rsp\n\t"	\
+		     "2:"			\
+		     : : [asm_seg]"r"((u64)seg)	\
+		     : "eax", "memory");	\
+})
 
 struct regs {
 	u64 rax, rbx, rcx, rdx;
@@ -895,6 +950,79 @@ static void test_mov_dr(uint64_t *mem)
 		report(rax == DR6_ACTIVE_LOW, "mov_dr6");
 }
 
+static void far_xfer_exception_handler(struct ex_regs *regs)
+{
+	far_xfer_vector = regs->vector;
+	far_xfer_error_code = regs->error_code;
+	regs->rip = regs->rax;
+}
+
+static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
+			    bool force_emulation)
+{
+	switch (insn) {
+	case FAR_XFER_RET:
+		if (force_emulation)
+			TEST_FAR_RET_ASM(seg, KVM_FEP);
+		else
+			TEST_FAR_RET_ASM(seg, "");
+		break;
+	default:
+		report_fail("Unexpected insn enum = %d\n", insn);
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
+		       (far_xfer_vector < 0 || far_xfer_error_code == FIRST_SPARE_SEL),
+		       "%s on %s, %s: wanted %d (%d), got %d (%d)",
+		       test->insn_name, force_emulation ? "emulator" : "hardware", t->msg,
+		       t->vector, t->vector < 0 ? -1 : FIRST_SPARE_SEL,
+		       far_xfer_vector, far_xfer_error_code);
+	}
+
+	handle_exception(GP_VECTOR, 0);
+	handle_exception(NP_VECTOR, 0);
+}
+
+static void test_far_ret(uint64_t *mem)
+{
+	test_far_xfer(false, &far_ret_test);
+}
+
+static void test_em_far_ret(uint64_t *mem)
+{
+	test_far_xfer(true, &far_ret_test);
+}
+
 static void test_push16(uint64_t *mem)
 {
 	uint64_t rsp1, rsp2;
@@ -1169,6 +1297,7 @@ int main(void)
 	test_smsw(mem);
 	test_lmsw();
 	test_ljmp(mem);
+	test_far_ret(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
 	test_btc(mem);
@@ -1193,6 +1322,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_em_far_ret(mem);
 	} else {
 		report_skip("skipping register-only tests, "
 			    "use kvm.force_emulation_prefix=1 to enable");
-- 
2.31.1

