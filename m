Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7520494AB9
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359550AbiATJ2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:28:39 -0500
Received: from out0-156.mail.aliyun.com ([140.205.0.156]:54761 "EHLO
        out0-156.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359532AbiATJ2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:28:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---.MfqJbYj_1642670913;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MfqJbYj_1642670913)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:28:33 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 2/2] x86/emulator: Add some tests for ljmp instruction emulation
Date:   Thu, 20 Jan 2022 17:26:59 +0800
Message-Id: <c91cbae0f98647917b7402ef4943dc061f54956d.1642669912.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
References: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 x86/emulator.c | 102 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 13 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 480333a40eba..c80e2cf8374e 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -34,6 +34,7 @@ struct fep_test_case {
 
 enum fep_test_inst_type {
 	FEP_TEST_LRET,
+	FEP_TEST_LJMP,
 };
 
 struct fep_test {
@@ -68,6 +69,29 @@ static struct fep_test fep_test_lret = {
 	.user_testcases_count = sizeof(lret_user_testcases) / sizeof(struct fep_test_case),
 };
 
+static struct fep_test_case ljmp_kernel_testcases[] = {
+	{0, DS_TYPE, 0, 0, GP_VECTOR, FIRST_SPARE_SEL, "ljmp desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, GP_VECTOR, FIRST_SPARE_SEL, "jmp non-conforming && dpl!=cpl && desc.p=0"},
+	{3, NON_CONFORM_CS_TYPE, 0, 0, GP_VECTOR, FIRST_SPARE_SEL, "ljmp conforming && rpl>cpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE, 3, 0, GP_VECTOR, FIRST_SPARE_SEL, "ljmp conforming && dpl>cpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, NP_VECTOR, FIRST_SPARE_SEL, "ljmp desc.p=0"},
+};
+
+static struct fep_test_case ljmp_user_testcases[] = {
+	{3, CONFORM_CS_TYPE, 0, 1, -1, -1, "ljmp dpl<cpl"},
+};
+
+static struct fep_test fep_test_ljmp = {
+	.type = FEP_TEST_LJMP,
+	.kernel_testcases = ljmp_kernel_testcases,
+	.kernel_testcases_count = sizeof(ljmp_kernel_testcases) / sizeof(struct fep_test_case),
+	.user_testcases = ljmp_user_testcases,
+	.user_testcases_count = sizeof(ljmp_user_testcases) / sizeof(struct fep_test_case),
+};
+
+static unsigned long fep_jmp_buf[2];
+static unsigned long *fep_jmp_buf_ptr = &fep_jmp_buf[0];
+
 static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type type);
 
 #define TEST_LRET_ASM(seg, prefix)		\
@@ -79,6 +103,14 @@ static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type typ
 		     : : [asm_seg]"r"(seg)	\
 		     : "memory");
 
+#define TEST_LJMP_ASM(seg, prefix)			\
+	*(uint16_t *)(&fep_jmp_buf[1]) = seg;		\
+	asm volatile("movq $1f, (%[mem])\n\t"		\
+		     prefix "rex64 ljmp *(%[mem])\n\t"	\
+		     "1:"				\
+		     : : [mem]"a"(fep_jmp_buf_ptr)	\
+		     : "memory"); \
+
 #define TEST_FEP_RESULT(vector, error_code, msg)	\
 	report(fep_vector == vector &&			\
 	       fep_error_code == error_code,msg);	\
@@ -383,19 +415,6 @@ static void test_pop(void *mem)
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
@@ -991,6 +1010,13 @@ static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type typ
 			TEST_LRET_ASM(seg, "");
 		}
 		break;
+	case FEP_TEST_LJMP:
+		if (emulate) {
+			TEST_LJMP_ASM(seg, KVM_FEP);
+		} else {
+			TEST_LJMP_ASM(seg, "");
+		}
+		break;
 	}
 }
 
@@ -1018,6 +1044,10 @@ static void test_fep_common(bool emulate, struct fep_test *test)
 			TEST_FEP_INST(emulate, LRET, seg, t[i].vector,
 				      t[i].error_code, t[i].msg);
 			break;
+		case FEP_TEST_LJMP:
+			TEST_FEP_INST(emulate, LJMP, seg, t[i].vector,
+				      t[i].error_code, t[i].msg);
+			break;
 		}
 	}
 
@@ -1034,6 +1064,11 @@ static void test_fep_common(bool emulate, struct fep_test *test)
 					      &dummy, t[i].vector,
 				              t[i].error_code, t[i].msg);
 			break;
+		case FEP_TEST_LJMP:
+			TEST_FEP_INST_IN_USER(LJMP, emulate, t[i].rpl,
+					      &dummy, t[i].vector,
+				              t[i].error_code, t[i].msg);
+			break;
 		}
 	}
 
@@ -1041,6 +1076,46 @@ static void test_fep_common(bool emulate, struct fep_test *test)
 	handle_exception(NP_VECTOR, 0);
 }
 
+static unsigned long get_ljmp_rip_advance(void)
+{
+	extern char ljmp_start, ljmp_end;
+	unsigned long ljmp_rip_advance = &ljmp_end - &ljmp_start;
+
+	fep_jmp_buf[0] = (unsigned long)&ljmp_end;
+	*(uint16_t *)(&fep_jmp_buf[1]) = KERNEL_CS;
+	asm volatile ("ljmp_start: rex64 ljmp *(%0); ljmp_end:\n\t"
+		      ::"a"(fep_jmp_buf_ptr) : "memory");
+
+	return ljmp_rip_advance;
+}
+
+static void test_ljmp(void *mem)
+{
+	unsigned char *m = mem;
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
+	fep_test_ljmp.rip_advance = get_ljmp_rip_advance();
+	test_fep_common(false, &fep_test_ljmp);
+	/* reset CS to KERNEL_CS */
+	(void)get_ljmp_rip_advance();
+}
+
+static void test_em_ljmp(void *mem)
+{
+	printf("test ljmp in emulator\n");
+	test_fep_common(true, &fep_test_ljmp);
+	/* reset CS to KERNEL_CS */
+	(void)get_ljmp_rip_advance();
+}
+
 static unsigned long get_lret_rip_advance(void)
 {
 	extern char lret_start, lret_end;
@@ -1368,6 +1443,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
+		test_em_ljmp(mem);
 		test_em_lret(mem);
 	} else {
 		report_skip("skipping register-only tests, "
-- 
2.31.1

