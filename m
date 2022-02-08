Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17184AD503
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 10:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354933AbiBHJcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 04:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355145AbiBHJcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:32:01 -0500
Received: from out0-154.mail.aliyun.com (out0-154.mail.aliyun.com [140.205.0.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5706C03FEF0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 01:31:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047187;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.Mn.4efn_1644312706;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mn.4efn_1644312706)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 17:31:47 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/2] x86/emulator: Add some tests for ljmp instruction emulation
Date:   Tue, 08 Feb 2022 17:30:57 +0800
Message-Id: <4d8a505095cc6106371462db2513fbbe000d8b4d.1644311445.git.houwenlong.hwl@antgroup.com>
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
loading segment descriptor for ljmp, not-present segment
check should be after all type and privilege checks. However,
__load_segment_descriptor() in x86's emulator does not-present
segment check first, so it would trigger #NP instead of #GP
if type or privilege checks fail and the segment is not present.

So add some tests for ljmp instruction, and it will test
those tests in hardware and emulator. Enable
kvm.force_emulation_prefix when try to test them in emulator.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 x86/emulator.c | 75 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index a68debaabef0..b4e474356ff7 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -35,6 +35,7 @@ struct far_xfer_test_case {
 
 enum far_xfer_insn {
 	FAR_XFER_RET,
+	FAR_XFER_JMP,
 };
 
 struct far_xfer_test {
@@ -61,6 +62,24 @@ static struct far_xfer_test far_ret_test = {
 	.nr_testcases = sizeof(far_ret_testcases) / sizeof(struct far_xfer_test_case),
 };
 
+static struct far_xfer_test_case far_jmp_testcases[] = {
+	{0, DS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "ljmp desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "jmp non-conforming && dpl!=cpl && desc.p=0"},
+	{3, NON_CONFORM_CS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "ljmp conforming && rpl>cpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "ljmp conforming && dpl>cpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, FIRST_SPARE_SEL, "ljmp desc.p=0"},
+	{3, CONFORM_CS_TYPE, 0, 1, true, -1, -1, "ljmp dpl<cpl"},
+};
+
+static struct far_xfer_test far_jmp_test = {
+	.insn = FAR_XFER_JMP,
+	.testcases = &far_jmp_testcases[0],
+	.nr_testcases = sizeof(far_jmp_testcases) / sizeof(struct far_xfer_test_case),
+};
+
+static unsigned long fep_jmp_buf[2];
+static unsigned long *fep_jmp_buf_ptr = &fep_jmp_buf[0];
+
 #define TEST_FAR_RET_ASM(seg, prefix)		\
 	asm volatile("lea 1f(%%rip), %%rax\n\t" \
 		     "pushq %[asm_seg]\n\t"	\
@@ -80,6 +99,24 @@ static inline void test_far_ret_asm(uint16_t seg, bool force_emulation)
 	}
 }
 
+#define TEST_FAR_JMP_ASM(seg, prefix)		\
+	*(uint16_t *)(&fep_jmp_buf[1]) = seg;	\
+	asm volatile("lea 1f(%%rip), %%rax\n\t" \
+		     "movq $1f, (%[mem])\n\t"	\
+		      prefix "rex64 ljmp *(%[mem])\n\t"\
+		     "1:"			\
+		     : : [mem]"r"(fep_jmp_buf_ptr)\
+		     : "eax", "memory");
+
+static inline void test_far_jmp_asm(uint16_t seg, bool force_emulation)
+{
+	if (force_emulation) {
+		TEST_FAR_JMP_ASM(seg, KVM_FEP);
+	} else {
+		TEST_FAR_JMP_ASM(seg, "");
+	}
+}
+
 struct regs {
 	u64 rax, rbx, rcx, rdx;
 	u64 rsi, rdi, rsp, rbp;
@@ -362,19 +399,6 @@ static void test_pop(void *mem)
 	       "enter");
 }
 
-static void test_ljmp(void *mem)
-{
-    unsigned char *m = mem;
-    volatile int res = 1;
-
-    *(unsigned long**)m = &&jmpf;
-    asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
-    asm volatile ("rex64 ljmp *%0"::"m"(*m));
-    res = 0;
-jmpf:
-    report(res, "ljmp");
-}
-
 static void test_incdecnotneg(void *mem)
 {
     unsigned long *m = mem, v = 1234;
@@ -965,6 +989,9 @@ static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
 	case FAR_XFER_RET:
 		test_far_ret_asm(seg, force_emulation);
 		break;
+	case FAR_XFER_JMP:
+		test_far_jmp_asm(seg, force_emulation);
+		break;
 	default:
 		report_fail("unknown instructions");
 		break;
@@ -1007,6 +1034,27 @@ static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
 	handle_exception(NP_VECTOR, 0);
 }
 
+static void test_ljmp(uint64_t *mem)
+{
+	unsigned char *m = (unsigned char *)mem;
+	volatile int res = 1;
+
+	*(unsigned long**)m = &&jmpf;
+	asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
+	asm volatile ("rex64 ljmp *%0"::"m"(*m));
+	res = 0;
+jmpf:
+	report(res, "ljmp");
+
+	printf("test ljmp in hw\n");
+	test_far_xfer(false, &far_jmp_test);
+}
+
+static void test_em_ljmp(uint64_t *mem)
+{
+	printf("test ljmp in emulator\n");
+	test_far_xfer(true, &far_jmp_test);
+}
 static void test_lret(uint64_t *mem)
 {
 	printf("test lret in hw\n");
@@ -1318,6 +1366,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_em_ljmp(mem);
 		test_em_lret(mem);
 	} else {
 		report_skip("skipping register-only tests, "
-- 
2.31.1

