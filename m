Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496AA4B08C2
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 09:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiBJIrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 03:47:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiBJIrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 03:47:13 -0500
Received: from out0-143.mail.aliyun.com (out0-143.mail.aliyun.com [140.205.0.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7482B10E2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 00:47:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047187;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.MnuUIKp_1644482830;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MnuUIKp_1644482830)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 16:47:10 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v3 3/3] x86/emulator: Add some tests for far jmp instruction emulation
Date:   Thu, 10 Feb 2022 16:46:35 +0800
Message-Id: <9c1d2125cb8680aff8a69e04461c4d84edb85760.1644481282.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
References: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
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
loading segment descriptor for far jmp, not-present segment
check should be after all type and privilege checks. However,
__load_segment_descriptor() in x86's emulator does not-present
segment check first, so it would trigger #NP instead of #GP
if type or privilege checks fail and the segment is not present.

So add some tests for far jmp instruction, and it will test
those tests on hardware and emulator. Enable
kvm.force_emulation_prefix when try to test them on emulator.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 x86/emulator.c | 71 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 13 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 45972c2fe940..7e98bacd714a 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -36,6 +36,7 @@ struct far_xfer_test_case {
 
 enum far_xfer_insn {
 	FAR_XFER_RET,
+	FAR_XFER_JMP,
 };
 
 struct far_xfer_test {
@@ -64,6 +65,25 @@ static struct far_xfer_test far_ret_test = {
 	.nr_testcases = sizeof(far_ret_testcases) / sizeof(struct far_xfer_test_case),
 };
 
+static struct far_xfer_test_case far_jmp_testcases[] = {
+	{0, DS_TYPE,		 0, 0, false, GP_VECTOR, "desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, "non-conforming && dpl!=cpl && desc.p=0"},
+	{3, NON_CONFORM_CS_TYPE, 0, 0, false, GP_VECTOR, "conforming && rpl>cpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE,	 3, 0, false, GP_VECTOR, "conforming && dpl>cpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, "desc.p=0"},
+	{3, CONFORM_CS_TYPE,	 0, 1, true,  -1,	 "dpl<cpl"},
+};
+
+static struct far_xfer_test far_jmp_test = {
+	.insn = FAR_XFER_JMP,
+	.insn_name = "far jmp",
+	.testcases = &far_jmp_testcases[0],
+	.nr_testcases = sizeof(far_jmp_testcases) / sizeof(struct far_xfer_test_case),
+};
+
+static unsigned long fep_jmp_buf[2];
+static unsigned long *fep_jmp_buf_ptr = &fep_jmp_buf[0];
+
 #define TEST_FAR_RET_ASM(seg, prefix)		\
 ({						\
 	asm volatile("lea 1f(%%rip), %%rax\n\t" \
@@ -76,6 +96,17 @@ static struct far_xfer_test far_ret_test = {
 		     : "eax", "memory");	\
 })
 
+#define TEST_FAR_JMP_ASM(seg, prefix)		\
+({						\
+	*(uint16_t *)(&fep_jmp_buf[1]) = seg;	\
+	asm volatile("lea 1f(%%rip), %%rax\n\t" \
+		     "movq $1f, (%[mem])\n\t"	\
+		      prefix "rex64 ljmp *(%[mem])\n\t"\
+		     "1:"			\
+		     : : [mem]"r"(fep_jmp_buf_ptr)\
+		     : "eax", "memory");	\
+})
+
 struct regs {
 	u64 rax, rbx, rcx, rdx;
 	u64 rsi, rdi, rsp, rbp;
@@ -358,19 +389,6 @@ static void test_pop(void *mem)
 	       "enter");
 }
 
-static void test_far_jmp(void *mem)
-{
-    unsigned char *m = mem;
-    volatile int res = 1;
-
-    *(unsigned long**)m = &&jmpf;
-    asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
-    asm volatile ("rex64 ljmp *%0"::"m"(*m));
-    res = 0;
-jmpf:
-    report(res, "far jmp, via emulated MMIO");
-}
-
 static void test_incdecnotneg(void *mem)
 {
     unsigned long *m = mem, v = 1234;
@@ -966,6 +984,12 @@ static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
 		else
 			TEST_FAR_RET_ASM(seg, "");
 		break;
+	case FAR_XFER_JMP:
+		if (force_emulation)
+			TEST_FAR_JMP_ASM(seg, KVM_FEP);
+		else
+			TEST_FAR_JMP_ASM(seg, "");
+		break;
 	default:
 		report_fail("Unexpected insn enum = %d\n", insn);
 		break;
@@ -1012,6 +1036,26 @@ static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
 	handle_exception(NP_VECTOR, 0);
 }
 
+static void test_far_jmp(uint64_t *mem)
+{
+	unsigned char *m = (unsigned char *)mem;
+	volatile int res = 1;
+
+	*(unsigned long**)m = &&jmpf;
+	asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
+	asm volatile ("rex64 ljmp *%0"::"m"(*m));
+	res = 0;
+jmpf:
+	report(res, "far jmp, via emulated MMIO");
+
+	test_far_xfer(false, &far_jmp_test);
+}
+
+static void test_em_far_jmp(uint64_t *mem)
+{
+	test_far_xfer(true, &far_jmp_test);
+}
+
 static void test_far_ret(uint64_t *mem)
 {
 	test_far_xfer(false, &far_ret_test);
@@ -1321,6 +1365,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_em_far_jmp(mem);
 		test_em_far_ret(mem);
 	} else {
 		report_skip("skipping register-only tests, "
-- 
2.31.1

