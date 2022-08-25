Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B865C5A19E8
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbiHYT75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243258AbiHYT7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:59:54 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F11365A1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:48 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i3-20020aa78b43000000b005320ac5b724so9430481pfd.4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=QBL3Ll2KlDWYTUw2RbqLVRJBT33egoXsT8NCuDNR9rk=;
        b=N5fa4MnD8UlILrVCEZwRnsRkFLU0CXGLLGoFO0vuZO1BtWgPB3K6My/2wHSYrMmfvI
         XaF4zHuIgqjaDd9Ha/dBcFyEGq+mlHyZCCXudoaIBxNlEGCaRQlXXr3axD+u//7c2oVS
         0s7H8Gz+Sj5MjfWh6bjr3Jc/A6rSmCNKwN7EqarrmgH2Z2uQ7w4Ur1kMlDEU918PkFCm
         SEXvCoWwUlwdt05i9cItog8OYohj68Zvw1JcoPNN55WYllRFSHfF+kblwxLbd96umXI/
         oXDYDx2n8le5C2oJJ9HHgtrgS8KIL/t38+I7RN+QxbejgWQ9COa3UaJmo9hmzajKPhzO
         mZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=QBL3Ll2KlDWYTUw2RbqLVRJBT33egoXsT8NCuDNR9rk=;
        b=UzlwwhNveEBkoIaqk/Xg0sFE0YMcvU5yiuIVT+PIToROT1eWH3STQRBMWevxNapAXG
         hGzbHifIG2oLrYYR2ITq1iwLPs9SD0RhCQ6YrkoxEyjjO3GFBecEbEOMMKzq2KJlBFk+
         tKUF7qRQD2IpAoejtxoD6IBFoqHXwga1ioyHaJRx826dd+h8ZS2YTv+eHfanb0I+Gqc2
         yHFVfydTuZkJ2MmPNrOwelzofshg68kHDHcgQV6Yk8DIDXUEbBKFeFN5fpZA2XaSiU/S
         dZWbcp5NSQnRuEfU1hbGsRpBTK/J4I6uIPv535N0llDCk6M2LsBasStGA+lW6zskLbhk
         w1BQ==
X-Gm-Message-State: ACgBeo0F7+UEhUijanelZ2P3joWvPX+Ar7jq8uQaeyCXHBw4tpqs+Z3k
        EAXB3VSChusNwjf6wuyCmh4JXvLN+6E=
X-Google-Smtp-Source: AA6agR66360XjM97MdQJrpVXfHws9/nltTOQQofH4M42Xs/HbXvnC0HWIXCFab6fXV3HPIElJBg95WZ+e68=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e558:b0:1fb:c4b7:1a24 with SMTP id
 ei24-20020a17090ae55800b001fbc4b71a24mr36756pjb.1.1661457587785; Thu, 25 Aug
 2022 12:59:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 19:59:37 +0000
In-Reply-To: <20220825195939.3959292-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825195939.3959292-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825195939.3959292-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 3/5] x86/emulator: Make chunks of "emulator"
 test 32-bit friendly
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the emulator tests that are truly 64-bit only (or will require
substantial rework) to a separate file and turn "emulator" into a common
test.  Many of the tests apply to both 32-bit and 64-bit guests, and the
lack of a 32-bit emulator test makes it awkward to validate instructions
that are 32-bit only, e.g. POP SS.

Opportunistically convert spaces to tabs for the moved code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/Makefile.common |   1 +
 x86/Makefile.x86_64 |   2 +-
 x86/emulator.c      | 576 ++++++--------------------------------------
 x86/emulator64.c    | 464 +++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   1 -
 5 files changed, 538 insertions(+), 506 deletions(-)
 create mode 100644 x86/emulator64.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b7010e2..a108da8 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -83,6 +83,7 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/hyperv_synic.$(exe) $(TEST_DIR)/hyperv_stimer.$(exe) \
                $(TEST_DIR)/hyperv_connections.$(exe) \
                $(TEST_DIR)/tsx-ctrl.$(exe) \
+               $(TEST_DIR)/emulator.$(exe) \
                $(TEST_DIR)/eventinj.$(exe) \
                $(TEST_DIR)/smap.$(exe) \
                $(TEST_DIR)/umip.$(exe)
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8f9463c..9903d5c 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -21,7 +21,7 @@ cflatobjs += lib/x86/intel-iommu.o
 cflatobjs += lib/x86/usermode.o
 
 tests = $(TEST_DIR)/apic.$(exe) \
-	  $(TEST_DIR)/emulator.$(exe) $(TEST_DIR)/idt_test.$(exe) \
+	  $(TEST_DIR)/idt_test.$(exe) \
 	  $(TEST_DIR)/xsave.$(exe) $(TEST_DIR)/rmap_chain.$(exe) \
 	  $(TEST_DIR)/pcid.$(exe) $(TEST_DIR)/debug.$(exe) \
 	  $(TEST_DIR)/ioapic.$(exe) $(TEST_DIR)/memory.$(exe) \
diff --git a/x86/emulator.c b/x86/emulator.c
index fe29540..f91f6e7 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -12,11 +12,12 @@
 
 #define TESTDEV_IO_PORT 0xe0
 
-#define MAGIC_NUM 0xdeadbeefdeadbeefUL
-#define GS_BASE 0x400000
-
 static int exceptions;
 
+#ifdef __x86_64__
+#include "emulator64.c"
+#endif
+
 static char st1[] = "abcdefghijklmnop";
 
 static void test_stringio(void)
@@ -74,12 +75,14 @@ static void test_cmps_one(unsigned char *m1, unsigned char *m3)
 		     : : "cc");
 	report(rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28, "repe cmpll (1)");
 
+#ifdef __x86_64__
 	rsi = m1; rdi = m3; rcx = 4;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
 		     "repe cmpsq"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32, "repe cmpsq (1)");
+#endif
 
 	rsi = m1; rdi = m3; rcx = 130;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
@@ -105,6 +108,7 @@ static void test_cmps_one(unsigned char *m1, unsigned char *m3)
 	report(rcx == 6 && rsi == m1 + 104 && rdi == m3 + 104,
 	       "repe cmpll (2)");
 
+#ifdef __x86_64__
 	rsi = m1; rdi = m3; rcx = 16;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
 		     "repe cmpsq"
@@ -112,7 +116,7 @@ static void test_cmps_one(unsigned char *m1, unsigned char *m3)
 		     : : "cc");
 	report(rcx == 3 && rsi == m1 + 104 && rdi == m3 + 104,
 	       "repe cmpsq (2)");
-
+#endif
 }
 
 static void test_cmps(void *mem)
@@ -133,7 +137,7 @@ static void test_scas(void *mem)
     bool z;
     void *di;
 
-    *(ulong *)mem = 0x77665544332211;
+    *(uint64_t *)mem = 0x77665544332211;
 
     di = mem;
     asm ("scasb; setz %0" : "=rm"(z), "+D"(di) : "a"(0xff11));
@@ -152,13 +156,14 @@ static void test_scas(void *mem)
     report(di == mem + 2 && !z, "scasw mismatch");
 
     di = mem;
-    asm ("scasl; setz %0" : "=rm"(z), "+D"(di) : "a"(0xff44332211ul));
+    asm ("scasl; setz %0" : "=rm"(z), "+D"(di) : "a"((ulong)0xff44332211ul));
     report(di == mem + 4 && z, "scasd match");
 
     di = mem;
     asm ("scasl; setz %0" : "=rm"(z), "+D"(di) : "a"(0x45332211));
     report(di == mem + 4 && !z, "scasd mismatch");
 
+#ifdef __x86_64__
     di = mem;
     asm ("scasq; setz %0" : "=rm"(z), "+D"(di) : "a"(0x77665544332211ul));
     report(di == mem + 8 && z, "scasq match");
@@ -166,136 +171,7 @@ static void test_scas(void *mem)
     di = mem;
     asm ("scasq; setz %0" : "=rm"(z), "+D"(di) : "a"(3));
     report(di == mem + 8 && !z, "scasq mismatch");
-}
-
-static void test_cr8(void)
-{
-	unsigned long src, dst;
-
-	dst = 777;
-	src = 3;
-	asm volatile("mov %[src], %%cr8; mov %%cr8, %[dst]"
-		     : [dst]"+r"(dst), [src]"+r"(src));
-	report(dst == 3 && src == 3, "mov %%cr8");
-}
-
-static void test_push(void *mem)
-{
-	unsigned long tmp;
-	unsigned long *stack_top = mem + 4096;
-	unsigned long *new_stack_top;
-	unsigned long memw = 0x123456789abcdeful;
-
-	memset(mem, 0x55, (void *)stack_top - mem);
-
-	asm volatile("mov %%rsp, %[tmp] \n\t"
-		     "mov %[stack_top], %%rsp \n\t"
-		     "pushq $-7 \n\t"
-		     "pushq %[reg] \n\t"
-		     "pushq (%[mem]) \n\t"
-		     "pushq $-7070707 \n\t"
-		     "mov %%rsp, %[new_stack_top] \n\t"
-		     "mov %[tmp], %%rsp"
-		     : [tmp]"=&r"(tmp), [new_stack_top]"=r"(new_stack_top)
-		     : [stack_top]"r"(stack_top),
-		       [reg]"r"(-17l), [mem]"r"(&memw)
-		     : "memory");
-
-	report(stack_top[-1] == -7ul, "push $imm8");
-	report(stack_top[-2] == -17ul, "push %%reg");
-	report(stack_top[-3] == 0x123456789abcdeful, "push mem");
-	report(stack_top[-4] == -7070707, "push $imm");
-}
-
-static void test_pop(void *mem)
-{
-	unsigned long tmp, tmp3, rsp, rbp;
-	unsigned long *stack_top = mem + 4096;
-	unsigned long memw = 0x123456789abcdeful;
-	static unsigned long tmp2;
-
-	memset(mem, 0x55, (void *)stack_top - mem);
-
-	asm volatile("pushq %[val] \n\t"
-		     "popq (%[mem])"
-		     : : [val]"m"(memw), [mem]"r"(mem) : "memory");
-	report(*(unsigned long *)mem == memw, "pop mem");
-
-	memw = 7 - memw;
-	asm volatile("mov %%rsp, %[tmp] \n\t"
-		     "mov %[stack_top], %%rsp \n\t"
-		     "pushq %[val] \n\t"
-		     "popq %[tmp2] \n\t"
-		     "mov %[tmp], %%rsp"
-		     : [tmp]"=&r"(tmp), [tmp2]"=m"(tmp2)
-		     : [val]"r"(memw), [stack_top]"r"(stack_top)
-		     : "memory");
-	report(tmp2 == memw, "pop mem (2)");
-
-	memw = 129443 - memw;
-	asm volatile("mov %%rsp, %[tmp] \n\t"
-		     "mov %[stack_top], %%rsp \n\t"
-		     "pushq %[val] \n\t"
-		     "popq %[tmp2] \n\t"
-		     "mov %[tmp], %%rsp"
-		     : [tmp]"=&r"(tmp), [tmp2]"=r"(tmp2)
-		     : [val]"r"(memw), [stack_top]"r"(stack_top)
-		     : "memory");
-	report(tmp2 == memw, "pop reg");
-
-	asm volatile("mov %%rsp, %[tmp] \n\t"
-		     "mov %[stack_top], %%rsp \n\t"
-		     "lea 1f(%%rip), %%rax \n\t"
-		     "push %%rax \n\t"
-		     "ret \n\t"
-		     "2: jmp 2b \n\t"
-		     "1: mov %[tmp], %%rsp"
-		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
-		     : "memory", "rax");
-	report_pass("ret");
-
-	stack_top[-1] = 0x778899;
-	asm volatile("mov %[stack_top], %%r8 \n\t"
-		     "mov %%rsp, %%r9 \n\t"
-		     "xchg %%rbp, %%r8 \n\t"
-		     "leave \n\t"
-		     "xchg %%rsp, %%r9 \n\t"
-		     "xchg %%rbp, %%r8 \n\t"
-		     "mov %%r9, %[tmp] \n\t"
-		     "mov %%r8, %[tmp3]"
-		     : [tmp]"=&r"(tmp), [tmp3]"=&r"(tmp3) : [stack_top]"r"(stack_top-1)
-		     : "memory", "r8", "r9");
-	report(tmp == (ulong)stack_top && tmp3 == 0x778899, "leave");
-
-	rbp = 0xaa55aa55bb66bb66ULL;
-	rsp = (unsigned long)stack_top;
-	asm volatile("mov %[rsp], %%r8 \n\t"
-		     "mov %[rbp], %%r9 \n\t"
-		     "xchg %%rsp, %%r8 \n\t"
-		     "xchg %%rbp, %%r9 \n\t"
-		     "enter $0x1238, $0 \n\t"
-		     "xchg %%rsp, %%r8 \n\t"
-		     "xchg %%rbp, %%r9 \n\t"
-		     "xchg %%r8, %[rsp] \n\t"
-		     "xchg %%r9, %[rbp]"
-		     : [rsp]"+a"(rsp), [rbp]"+b"(rbp) : : "memory", "r8", "r9");
-	report(rsp == (unsigned long)stack_top - 8 - 0x1238
-	       && rbp == (unsigned long)stack_top - 8
-	       && stack_top[-1] == 0xaa55aa55bb66bb66ULL,
-	       "enter");
-}
-
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
+#endif
 }
 
 static void test_incdecnotneg(void *mem)
@@ -325,10 +201,12 @@ static void test_incdecnotneg(void *mem)
 
     *m = v;
 
+#ifdef __x86_64__
     asm ("lock negq %0" : "+m"(*m)); v = -v;
     report(*m == v, "lock negl");
     asm ("lock notq %0" : "+m"(*m)); v = ~v;
     report(*m == v, "lock notl");
+#endif
 
     *mb = vb;
 
@@ -338,7 +216,7 @@ static void test_incdecnotneg(void *mem)
     report(*mb == vb, "lock notb");
 }
 
-static void test_smsw(uint64_t *h_mem)
+static void test_smsw(unsigned long *h_mem)
 {
 	char mem[16];
 	unsigned short msw, msw_orig, *pmsw;
@@ -359,10 +237,10 @@ static void test_smsw(uint64_t *h_mem)
 	report(msw == pmsw[4] && zero, "smsw (2)");
 
 	/* Trigger exit on smsw */
-	*h_mem = 0x12345678abcdeful;
+	*h_mem = -1ul;
 	asm volatile("smsw %0" : "+m"(*h_mem));
 	report(msw == (unsigned short)*h_mem &&
-	       (*h_mem & ~0xfffful) == 0x12345678ab0000ul, "smsw (3)");
+	       (*h_mem & ~0xfffful) == (-1ul & ~0xfffful), "smsw (3)");
 }
 
 static void test_lmsw(void)
@@ -394,106 +272,6 @@ static void test_lmsw(void)
 	asm("lmsw %0" : : "r"(msw));
 }
 
-static void test_xchg(void *mem)
-{
-	unsigned long *memq = mem;
-	unsigned long rax;
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xchg %%al, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0xfedcba98765432ef && *memq == 0x123456789abcd10,
-	       "xchg reg, r/m (1)");
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xchg %%ax, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0xfedcba987654cdef && *memq == 0x123456789ab3210,
-	       "xchg reg, r/m (2)");
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xchg %%eax, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0x89abcdef && *memq == 0x123456776543210,
-	       "xchg reg, r/m (3)");
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xchg %%rax, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0x123456789abcdef && *memq == 0xfedcba9876543210,
-	       "xchg reg, r/m (4)");
-}
-
-static void test_xadd(void *mem)
-{
-	unsigned long *memq = mem;
-	unsigned long rax;
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xadd %%al, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0xfedcba98765432ef && *memq == 0x123456789abcdff,
-	       "xadd reg, r/m (1)");
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xadd %%ax, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0xfedcba987654cdef && *memq == 0x123456789abffff,
-	       "xadd reg, r/m (2)");
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xadd %%eax, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0x89abcdef && *memq == 0x1234567ffffffff,
-	       "xadd reg, r/m (3)");
-
-	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
-		     "mov %%rax, (%[memq])\n\t"
-		     "mov $0xfedcba9876543210, %%rax\n\t"
-		     "xadd %%rax, (%[memq])\n\t"
-		     "mov %%rax, %[rax]\n\t"
-		     : [rax]"=r"(rax)
-		     : [memq]"r"(memq)
-		     : "memory", "rax");
-	report(rax == 0x123456789abcdef && *memq == 0xffffffffffffffff,
-	       "xadd reg, r/m (4)");
-}
-
 static void test_btc(void *mem)
 {
 	unsigned int *a = mem;
@@ -508,17 +286,21 @@ static void test_btc(void *mem)
 	asm ("btcl %1, %0" :: "m"(a[3]), "r"(-1) : "memory");
 	report(a[0] == 1 && a[1] == 2 && a[2] == 0x80000004, "btcl reg, r/m");
 
+#ifdef __x86_64__
 	asm ("btcq %1, %0" : : "m"(a[2]), "r"(-1l) : "memory");
 	report(a[0] == 1 && a[1] == 0x80000002 && a[2] == 0x80000004 && a[3] == 0,
 	       "btcq reg, r/m");
+#endif
 }
 
 static void test_bsfbsr(void *mem)
 {
-	unsigned long rax, *memq = mem;
 	unsigned eax, *meml = mem;
 	unsigned short ax, *memw = mem;
+#ifdef __x86_64__
+	unsigned long rax, *memq = mem;
 	unsigned char z;
+#endif
 
 	*memw = 0xc000;
 	asm("bsfw %[mem], %[a]" : [a]"=a"(ax) : [mem]"m"(*memw));
@@ -528,6 +310,7 @@ static void test_bsfbsr(void *mem)
 	asm("bsfl %[mem], %[a]" : [a]"=a"(eax) : [mem]"m"(*meml));
 	report(eax == 30, "bsfl r/m, reg");
 
+#ifdef __x86_64__
 	*memq = 0xc00000000000;
 	asm("bsfq %[mem], %[a]" : [a]"=a"(rax) : [mem]"m"(*memq));
 	report(rax == 46, "bsfq r/m, reg");
@@ -536,6 +319,7 @@ static void test_bsfbsr(void *mem)
 	asm("bsfq %[mem], %[a]; setz %[z]"
 	    : [a]"=a"(rax), [z]"=rm"(z) : [mem]"m"(*memq));
 	report(z == 1, "bsfq r/m, reg");
+#endif
 
 	*memw = 0xc000;
 	asm("bsrw %[mem], %[a]" : [a]"=a"(ax) : [mem]"m"(*memw));
@@ -545,6 +329,7 @@ static void test_bsfbsr(void *mem)
 	asm("bsrl %[mem], %[a]" : [a]"=a"(eax) : [mem]"m"(*meml));
 	report(eax == 31, "bsrl r/m, reg");
 
+#ifdef __x86_64__
 	*memq = 0xc00000000000;
 	asm("bsrq %[mem], %[a]" : [a]"=a"(rax) : [mem]"m"(*memq));
 	report(rax == 47, "bsrq r/m, reg");
@@ -553,79 +338,51 @@ static void test_bsfbsr(void *mem)
 	asm("bsrq %[mem], %[a]; setz %[z]"
 	    : [a]"=a"(rax), [z]"=rm"(z) : [mem]"m"(*memq));
 	report(z == 1, "bsrq r/m, reg");
+#endif
 }
 
-static void test_imul(ulong *mem)
+static void test_imul(uint64_t *mem)
 {
-    ulong a;
+	ulong a;
 
-    *mem = 51; a = 0x1234567812345678UL;
-    asm ("imulw %1, %%ax" : "+a"(a) : "m"(*mem));
-    report(a == 0x12345678123439e8, "imul ax, mem");
+	*mem = 51; a = 0x1234567812345678ULL & -1ul;;
+	asm ("imulw %1, %%ax" : "+a"(a) : "m"(*mem));
+	report(a == (0x12345678123439e8ULL & -1ul), "imul ax, mem");
 
-    *mem = 51; a = 0x1234567812345678UL;
-    asm ("imull %1, %%eax" : "+a"(a) : "m"(*mem));
-    report(a == 0xa06d39e8, "imul eax, mem");
+	*mem = 51; a = 0x1234567812345678ULL & -1ul;;
+	asm ("imull %1, %%eax" : "+a"(a) : "m"(*mem));
+	report(a == 0xa06d39e8, "imul eax, mem");
 
-    *mem = 51; a = 0x1234567812345678UL;
-    asm ("imulq %1, %%rax" : "+a"(a) : "m"(*mem));
-    report(a == 0xA06D39EBA06D39E8UL, "imul rax, mem");
+	*mem  = 0x1234567812345678ULL; a = 0x8765432187654321ULL & -1ul;
+	asm ("imulw $51, %1, %%ax" : "+a"(a) : "m"(*mem));
+	report(a == (0x87654321876539e8ULL & -1ul), "imul ax, mem, imm8");
 
-    *mem  = 0x1234567812345678UL; a = 0x8765432187654321L;
-    asm ("imulw $51, %1, %%ax" : "+a"(a) : "m"(*mem));
-    report(a == 0x87654321876539e8, "imul ax, mem, imm8");
+	*mem = 0x1234567812345678ULL;
+	asm ("imull $51, %1, %%eax" : "+a"(a) : "m"(*mem));
+	report(a == 0xa06d39e8, "imul eax, mem, imm8");
 
-    *mem = 0x1234567812345678UL;
-    asm ("imull $51, %1, %%eax" : "+a"(a) : "m"(*mem));
-    report(a == 0xa06d39e8, "imul eax, mem, imm8");
+	*mem  = 0x1234567812345678ULL; a = 0x8765432187654321ULL & -1ul;
+	asm ("imulw $311, %1, %%ax" : "+a"(a) : "m"(*mem));
+	report(a == (0x8765432187650bc8ULL & -1ul), "imul ax, mem, imm");
 
-    *mem = 0x1234567812345678UL;
-    asm ("imulq $51, %1, %%rax" : "+a"(a) : "m"(*mem));
-    report(a == 0xA06D39EBA06D39E8UL, "imul rax, mem, imm8");
+	*mem = 0x1234567812345678ULL;
+	asm ("imull $311, %1, %%eax" : "+a"(a) : "m"(*mem));
+	report(a == 0x1d950bc8, "imul eax, mem, imm");
 
-    *mem  = 0x1234567812345678UL; a = 0x8765432187654321L;
-    asm ("imulw $311, %1, %%ax" : "+a"(a) : "m"(*mem));
-    report(a == 0x8765432187650bc8, "imul ax, mem, imm");
+#ifdef __x86_64__
+	*mem = 51; a = 0x1234567812345678UL;
+	asm ("imulq %1, %%rax" : "+a"(a) : "m"(*mem));
+	report(a == 0xA06D39EBA06D39E8UL, "imul rax, mem");
 
-    *mem = 0x1234567812345678UL;
-    asm ("imull $311, %1, %%eax" : "+a"(a) : "m"(*mem));
-    report(a == 0x1d950bc8, "imul eax, mem, imm");
+	*mem = 0x1234567812345678UL;
+	asm ("imulq $51, %1, %%rax" : "+a"(a) : "m"(*mem));
+	report(a == 0xA06D39EBA06D39E8UL, "imul rax, mem, imm8");
 
-    *mem = 0x1234567812345678UL;
-    asm ("imulq $311, %1, %%rax" : "+a"(a) : "m"(*mem));
-    report(a == 0x1D950BDE1D950BC8L, "imul rax, mem, imm");
+	*mem = 0x1234567812345678UL;
+	asm ("imulq $311, %1, %%rax" : "+a"(a) : "m"(*mem));
+	report(a == 0x1D950BDE1D950BC8L, "imul rax, mem, imm");
+#endif
 }
-
-static void test_muldiv(long *mem)
-{
-    long a, d, aa, dd;
-    u8 ex = 1;
-
-    *mem = 0; a = 1; d = 2;
-    asm (ASM_TRY("1f") "divq %3; movb $0, %2; 1:"
-	 : "+a"(a), "+d"(d), "+q"(ex) : "m"(*mem));
-    report(a == 1 && d == 2 && ex, "divq (fault)");
-
-    *mem = 987654321098765UL; a = 123456789012345UL; d = 123456789012345UL;
-    asm (ASM_TRY("1f") "divq %3; movb $0, %2; 1:"
-	 : "+a"(a), "+d"(d), "+q"(ex) : "m"(*mem));
-    report(a == 0x1ffffffb1b963b33ul && d == 0x273ba4384ede2ul && !ex,
-           "divq (1)");
-    aa = 0x1111111111111111; dd = 0x2222222222222222;
-    *mem = 0x3333333333333333; a = aa; d = dd;
-    asm("mulb %2" : "+a"(a), "+d"(d) : "m"(*mem));
-    report(a == 0x1111111111110363 && d == dd, "mulb mem");
-    *mem = 0x3333333333333333; a = aa; d = dd;
-    asm("mulw %2" : "+a"(a), "+d"(d) : "m"(*mem));
-    report(a == 0x111111111111c963 && d == 0x2222222222220369, "mulw mem");
-    *mem = 0x3333333333333333; a = aa; d = dd;
-    asm("mull %2" : "+a"(a), "+d"(d) : "m"(*mem));
-    report(a == 0x962fc963 && d == 0x369d036, "mull mem");
-    *mem = 0x3333333333333333; a = aa; d = dd;
-    asm("mulq %2" : "+a"(a), "+d"(d) : "m"(*mem));
-    report(a == 0x2fc962fc962fc963 && d == 0x369d0369d0369d0, "mulq mem");
-}
-
 typedef unsigned __attribute__((vector_size(16))) sse128;
 
 static bool sseeq(uint32_t *v1, uint32_t *v2)
@@ -738,35 +495,6 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 	install_pte(current_page_table(), 1, page2, orig_pte, NULL);
 }
 
-static void test_mmx(uint64_t *mem)
-{
-    uint64_t v;
-
-    write_cr0(read_cr0() & ~6); /* EM, TS */
-    asm volatile("fninit");
-    v = 0x0102030405060708ULL;
-    asm("movq %1, %0" : "=m"(*mem) : "y"(v));
-    report(v == *mem, "movq (mmx, read)");
-    *mem = 0x8070605040302010ull;
-    asm("movq %1, %0" : "=y"(v) : "m"(*mem));
-    report(v == *mem, "movq (mmx, write)");
-}
-
-static void test_rip_relative(unsigned *mem, char *insn_ram)
-{
-    /* movb $1, mem+2(%rip) */
-    insn_ram[0] = 0xc6;
-    insn_ram[1] = 0x05;
-    *(unsigned *)&insn_ram[2] = 2 + (char *)mem - (insn_ram + 7);
-    insn_ram[6] = 0x01;
-    /* ret */
-    insn_ram[7] = 0xc3;
-
-    *mem = 0;
-    asm("callq *%1" : "+m"(*mem) : "r"(insn_ram));
-    report(*mem == 0x10000, "movb $imm, 0(%%rip)");
-}
-
 static void test_shld_shrd(u32 *mem)
 {
     *mem = 0x12345678;
@@ -777,75 +505,11 @@ static void test_shld_shrd(u32 *mem)
     report(*mem == ((0x12345678 >> 3) | (5u << 29)), "shrd (cl)");
 }
 
-static void test_cmov(u32 *mem)
-{
-	u64 val;
-	*mem = 0xabcdef12u;
-	asm ("movq $0x1234567812345678, %%rax\n\t"
-	     "cmpl %%eax, %%eax\n\t"
-	     "cmovnel (%[mem]), %%eax\n\t"
-	     "movq %%rax, %[val]\n\t"
-	     : [val]"=r"(val) : [mem]"r"(mem) : "%rax", "cc");
-	report(val == 0x12345678ul, "cmovnel");
-}
-
-static unsigned long rip_advance;
-
-static void advance_rip_and_note_exception(struct ex_regs *regs)
-{
-    ++exceptions;
-    regs->rip += rip_advance;
-}
-
-static void test_mmx_movq_mf(uint64_t *mem)
-{
-	/* movq %mm0, (%rax) */
-	extern char movq_start, movq_end;
-	handler old;
-
-	uint16_t fcw = 0;  /* all exceptions unmasked */
-	write_cr0(read_cr0() & ~6);  /* TS, EM */
-	exceptions = 0;
-	old = handle_exception(MF_VECTOR, advance_rip_and_note_exception);
-	asm volatile("fninit; fldcw %0" : : "m"(fcw));
-	asm volatile("fldz; fldz; fdivp"); /* generate exception */
-
-	rip_advance = &movq_end - &movq_start;
-	asm(KVM_FEP "movq_start: movq %mm0, (%rax); movq_end:");
-	/* exit MMX mode */
-	asm volatile("fnclex; emms");
-	report(exceptions == 1, "movq mmx generates #MF");
-	handle_exception(MF_VECTOR, old);
-}
-
-static void test_jmp_noncanonical(uint64_t *mem)
-{
-	extern char nc_jmp_start, nc_jmp_end;
-	handler old;
-
-	*mem = 0x1111111111111111ul;
-
-	exceptions = 0;
-	rip_advance = &nc_jmp_end - &nc_jmp_start;
-	old = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
-	asm volatile ("nc_jmp_start: jmp *%0; nc_jmp_end:" : : "m"(*mem));
-	report(exceptions == 1, "jump to non-canonical address");
-	handle_exception(GP_VECTOR, old);
-}
-
-static void test_movabs(uint64_t *mem)
-{
-    /* mov $0x9090909090909090, %rcx */
-    unsigned long rcx;
-    asm(KVM_FEP "mov $0x9090909090909090, %0" : "=c" (rcx) : "0" (0));
-    report(rcx == 0x9090909090909090, "64-bit mov imm2");
-}
-
 static void test_smsw_reg(uint64_t *mem)
 {
 	unsigned long cr0 = read_cr0();
 	unsigned long rax;
-	const unsigned long in_rax = 0x1234567890abcdeful;
+	const unsigned long in_rax = 0x1234567890abcdefull & -1ul;
 
 	asm(KVM_FEP "smsww %w0\n\t" : "=a" (rax) : "0" (in_rax));
 	report((u16)rax == (u16)cr0 && rax >> 16 == in_rax >> 16,
@@ -854,14 +518,16 @@ static void test_smsw_reg(uint64_t *mem)
 	asm(KVM_FEP "smswl %k0\n\t" : "=a" (rax) : "0" (in_rax));
 	report(rax == (u32)cr0, "32-bit smsw reg");
 
+#ifdef __x86_64__
 	asm(KVM_FEP "smswq %q0\n\t" : "=a" (rax) : "0" (in_rax));
 	report(rax == cr0, "64-bit smsw reg");
+#endif
 }
 
 static void test_nop(uint64_t *mem)
 {
 	unsigned long rax;
-	const unsigned long in_rax = 0x1234567890abcdeful;
+	const unsigned long in_rax = 0x12345678ul;
 	asm(KVM_FEP "nop\n\t" : "=a" (rax) : "0" (in_rax));
 	report(rax == in_rax, "nop");
 }
@@ -870,8 +536,8 @@ static void test_mov_dr(uint64_t *mem)
 {
 	unsigned long rax;
 
-	asm(KVM_FEP "movq %0, %%dr6\n\t"
-	    KVM_FEP "movq %%dr6, %0\n\t" : "=a" (rax) : "a" (0));
+	asm(KVM_FEP "mov %0, %%dr6\n\t"
+	    KVM_FEP "mov %%dr6, %0\n\t" : "=a" (rax) : "a" (0));
 
 	if (this_cpu_has(X86_FEATURE_RTM))
 		report(rax == (DR6_ACTIVE_LOW & ~DR6_RTM), "mov_dr6");
@@ -893,21 +559,6 @@ static void test_illegal_lea(void)
 	       "Wanted #UD on LEA with /reg, got vector = %u", vector);
 }
 
-static void test_push16(uint64_t *mem)
-{
-	uint64_t rsp1, rsp2;
-	uint16_t r;
-
-	asm volatile (	"movq %%rsp, %[rsp1]\n\t"
-			"pushw %[v]\n\t"
-			"popw %[r]\n\t"
-			"movq %%rsp, %[rsp2]\n\t"
-			"movq %[rsp1], %%rsp\n\t" :
-			[rsp1]"=r"(rsp1), [rsp2]"=r"(rsp2), [r]"=r"(r)
-			: [v]"m"(*mem) : "memory");
-	report(rsp1 == rsp2, "push16");
-}
-
 static void test_crosspage_mmio(volatile uint8_t *mem)
 {
     volatile uint16_t w, *pw;
@@ -967,68 +618,6 @@ static void test_lgdt_lidt(volatile uint8_t *mem)
 }
 #endif
 
-static void ss_bad_rpl(struct ex_regs *regs)
-{
-    extern char ss_bad_rpl_cont;
-
-    ++exceptions;
-    regs->rip = (ulong)&ss_bad_rpl_cont;
-}
-
-static void test_sreg(volatile uint16_t *mem)
-{
-	u16 ss = read_ss();
-	handler old;
-
-	// check for null segment load
-	*mem = 0;
-	asm volatile("mov %0, %%ss" : : "m"(*mem));
-	report(read_ss() == 0, "mov null, %%ss");
-
-	// check for exception when ss.rpl != cpl on null segment load
-	exceptions = 0;
-	old = handle_exception(GP_VECTOR, ss_bad_rpl);
-	*mem = 3;
-	asm volatile("mov %0, %%ss; ss_bad_rpl_cont:" : : "m"(*mem));
-	report(exceptions == 1 && read_ss() == 0,
-	       "mov null, %%ss (with ss.rpl != cpl)");
-	handle_exception(GP_VECTOR, old);
-	write_ss(ss);
-}
-
-static uint64_t usr_gs_mov(void)
-{
-    static uint64_t dummy = MAGIC_NUM;
-    uint64_t dummy_ptr = (uint64_t)&dummy;
-    uint64_t ret;
-
-    dummy_ptr -= GS_BASE;
-    asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
-
-    return ret;
-}
-
-static void test_iret(void)
-{
-    uint64_t val;
-    bool raised_vector;
-
-    /* Update GS base to 4MiB */
-    wrmsr(MSR_GS_BASE, GS_BASE);
-
-    /*
-     * Per the SDM, jumping to user mode via `iret`, which is returning to
-     * outer privilege level, for segment registers (ES, FS, GS, and DS)
-     * if the check fails, the segment selector becomes null.
-     *
-     * In our test case, GS becomes null.
-     */
-    val = run_in_user((usermode_func)usr_gs_mov, GP_VECTOR,
-                      0, 0, 0, 0, &raised_vector);
-
-    report(val == MAGIC_NUM, "Test ret/iret with a nullified segment");
-}
-
 /* Broken emulation causes triple fault, which skips the other tests. */
 #if 0
 static void test_lldt(volatile uint16_t *mem)
@@ -1074,13 +663,13 @@ static void test_mov(void *mem)
 	unsigned long t1, t2;
 
 	// test mov reg, r/m and mov r/m, reg
-	t1 = 0x123456789abcdef;
+	t1 = 0x123456789abcdefull & -1ul;
 	asm volatile("mov %[t1], (%[mem]) \n\t"
 		     "mov (%[mem]), %[t2]"
 		     : [t2]"=r"(t2)
 		     : [t1]"r"(t1), [mem]"r"(mem)
 		     : "memory");
-	report(t2 == 0x123456789abcdef, "mov reg, r/m (1)");
+	report(t2 == (0x123456789abcdefull & -1ul), "mov reg, r/m (1)");
 }
 
 static void test_simplealu(u32 *mem)
@@ -1130,73 +719,52 @@ static void test_illegal_movbe(void)
 int main(void)
 {
 	void *mem;
-	void *insn_page;
-	void *insn_ram;
 	void *cross_mem;
 
+	if (!is_fep_available())
+		report_skip("Skipping tests the require forced emulation, "
+			    "use kvm.force_emulation_prefix=1 to enable");
+
 	setup_vm();
 
 	mem = alloc_vpages(2);
 	install_page((void *)read_cr3(), IORAM_BASE_PHYS, mem);
 	// install the page twice to test cross-page mmio
 	install_page((void *)read_cr3(), IORAM_BASE_PHYS, mem + 4096);
-	insn_page = alloc_page();
-	insn_ram = vmap(virt_to_phys(insn_page), 4096);
 	cross_mem = vmap(virt_to_phys(alloc_pages(2)), 2 * PAGE_SIZE);
 
 	test_mov(mem);
 	test_simplealu(mem);
 	test_cmps(mem);
 	test_scas(mem);
-
-	test_push(mem);
-	test_pop(mem);
-
-	test_xchg(mem);
-	test_xadd(mem);
-
-	test_cr8();
-
 	test_smsw(mem);
 	test_lmsw();
-	test_ljmp(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
 	test_btc(mem);
 	test_bsfbsr(mem);
 	test_imul(mem);
-	test_muldiv(mem);
 	test_sse(mem);
 	test_sse_exceptions(cross_mem);
-	test_mmx(mem);
-	test_rip_relative(mem, insn_ram);
 	test_shld_shrd(mem);
 	//test_lgdt_lidt(mem);
-	test_sreg(mem);
-	test_iret();
 	//test_lldt(mem);
 	test_ltr(mem);
-	test_cmov(mem);
 
 	if (is_fep_available()) {
-		test_mmx_movq_mf(mem);
-		test_movabs(mem);
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
 		test_illegal_lea();
-	} else {
-		report_skip("skipping register-only tests, "
-			    "use kvm.force_emulation_prefix=1 to enable");
 	}
 
-	test_push16(mem);
 	test_crosspage_mmio(mem);
 
 	test_string_io_mmio(mem);
-
-	test_jmp_noncanonical(mem);
 	test_illegal_movbe();
 
+#ifdef __x86_64__
+	test_emulator_64(mem);
+#endif
 	return report_summary();
 }
diff --git a/x86/emulator64.c b/x86/emulator64.c
new file mode 100644
index 0000000..7f55d38
--- /dev/null
+++ b/x86/emulator64.c
@@ -0,0 +1,464 @@
+#define MAGIC_NUM 0xdeadbeefdeadbeefUL
+#define GS_BASE 0x400000
+
+static unsigned long rip_advance;
+
+static void advance_rip_and_note_exception(struct ex_regs *regs)
+{
+	++exceptions;
+	regs->rip += rip_advance;
+}
+
+static void test_cr8(void)
+{
+	unsigned long src, dst;
+
+	dst = 777;
+	src = 3;
+	asm volatile("mov %[src], %%cr8; mov %%cr8, %[dst]"
+		     : [dst]"+r"(dst), [src]"+r"(src));
+	report(dst == 3 && src == 3, "mov %%cr8");
+}
+
+static void test_push(void *mem)
+{
+	unsigned long tmp;
+	unsigned long *stack_top = mem + 4096;
+	unsigned long *new_stack_top;
+	unsigned long memw = 0x123456789abcdeful;
+
+	memset(mem, 0x55, (void *)stack_top - mem);
+
+	asm volatile("mov %%rsp, %[tmp] \n\t"
+		     "mov %[stack_top], %%rsp \n\t"
+		     "pushq $-7 \n\t"
+		     "pushq %[reg] \n\t"
+		     "pushq (%[mem]) \n\t"
+		     "pushq $-7070707 \n\t"
+		     "mov %%rsp, %[new_stack_top] \n\t"
+		     "mov %[tmp], %%rsp"
+		     : [tmp]"=&r"(tmp), [new_stack_top]"=r"(new_stack_top)
+		     : [stack_top]"r"(stack_top),
+		       [reg]"r"(-17l), [mem]"r"(&memw)
+		     : "memory");
+
+	report(stack_top[-1] == -7ul, "push $imm8");
+	report(stack_top[-2] == -17ul, "push %%reg");
+	report(stack_top[-3] == 0x123456789abcdeful, "push mem");
+	report(stack_top[-4] == -7070707, "push $imm");
+}
+
+static void test_pop(void *mem)
+{
+	unsigned long tmp, tmp3, rsp, rbp;
+	unsigned long *stack_top = mem + 4096;
+	unsigned long memw = 0x123456789abcdeful;
+	static unsigned long tmp2;
+
+	memset(mem, 0x55, (void *)stack_top - mem);
+
+	asm volatile("pushq %[val] \n\t"
+		     "popq (%[mem])"
+		     : : [val]"m"(memw), [mem]"r"(mem) : "memory");
+	report(*(unsigned long *)mem == memw, "pop mem");
+
+	memw = 7 - memw;
+	asm volatile("mov %%rsp, %[tmp] \n\t"
+		     "mov %[stack_top], %%rsp \n\t"
+		     "pushq %[val] \n\t"
+		     "popq %[tmp2] \n\t"
+		     "mov %[tmp], %%rsp"
+		     : [tmp]"=&r"(tmp), [tmp2]"=m"(tmp2)
+		     : [val]"r"(memw), [stack_top]"r"(stack_top)
+		     : "memory");
+	report(tmp2 == memw, "pop mem (2)");
+
+	memw = 129443 - memw;
+	asm volatile("mov %%rsp, %[tmp] \n\t"
+		     "mov %[stack_top], %%rsp \n\t"
+		     "pushq %[val] \n\t"
+		     "popq %[tmp2] \n\t"
+		     "mov %[tmp], %%rsp"
+		     : [tmp]"=&r"(tmp), [tmp2]"=r"(tmp2)
+		     : [val]"r"(memw), [stack_top]"r"(stack_top)
+		     : "memory");
+	report(tmp2 == memw, "pop reg");
+
+	asm volatile("mov %%rsp, %[tmp] \n\t"
+		     "mov %[stack_top], %%rsp \n\t"
+		     "lea 1f(%%rip), %%rax \n\t"
+		     "push %%rax \n\t"
+		     "ret \n\t"
+		     "2: jmp 2b \n\t"
+		     "1: mov %[tmp], %%rsp"
+		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
+		     : "memory", "rax");
+	report_pass("ret");
+
+	stack_top[-1] = 0x778899;
+	asm volatile("mov %[stack_top], %%r8 \n\t"
+		     "mov %%rsp, %%r9 \n\t"
+		     "xchg %%rbp, %%r8 \n\t"
+		     "leave \n\t"
+		     "xchg %%rsp, %%r9 \n\t"
+		     "xchg %%rbp, %%r8 \n\t"
+		     "mov %%r9, %[tmp] \n\t"
+		     "mov %%r8, %[tmp3]"
+		     : [tmp]"=&r"(tmp), [tmp3]"=&r"(tmp3) : [stack_top]"r"(stack_top-1)
+		     : "memory", "r8", "r9");
+	report(tmp == (ulong)stack_top && tmp3 == 0x778899, "leave");
+
+	rbp = 0xaa55aa55bb66bb66ULL;
+	rsp = (unsigned long)stack_top;
+	asm volatile("mov %[rsp], %%r8 \n\t"
+		     "mov %[rbp], %%r9 \n\t"
+		     "xchg %%rsp, %%r8 \n\t"
+		     "xchg %%rbp, %%r9 \n\t"
+		     "enter $0x1238, $0 \n\t"
+		     "xchg %%rsp, %%r8 \n\t"
+		     "xchg %%rbp, %%r9 \n\t"
+		     "xchg %%r8, %[rsp] \n\t"
+		     "xchg %%r9, %[rbp]"
+		     : [rsp]"+a"(rsp), [rbp]"+b"(rbp) : : "memory", "r8", "r9");
+	report(rsp == (unsigned long)stack_top - 8 - 0x1238
+	       && rbp == (unsigned long)stack_top - 8
+	       && stack_top[-1] == 0xaa55aa55bb66bb66ULL,
+	       "enter");
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
+}
+
+static void test_xchg(void *mem)
+{
+	unsigned long *memq = mem;
+	unsigned long rax;
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xchg %%al, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0xfedcba98765432ef && *memq == 0x123456789abcd10,
+	       "xchg reg, r/m (1)");
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xchg %%ax, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0xfedcba987654cdef && *memq == 0x123456789ab3210,
+	       "xchg reg, r/m (2)");
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xchg %%eax, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0x89abcdef && *memq == 0x123456776543210,
+	       "xchg reg, r/m (3)");
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xchg %%rax, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0x123456789abcdef && *memq == 0xfedcba9876543210,
+	       "xchg reg, r/m (4)");
+}
+
+static void test_xadd(void *mem)
+{
+	unsigned long *memq = mem;
+	unsigned long rax;
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xadd %%al, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0xfedcba98765432ef && *memq == 0x123456789abcdff,
+	       "xadd reg, r/m (1)");
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xadd %%ax, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0xfedcba987654cdef && *memq == 0x123456789abffff,
+	       "xadd reg, r/m (2)");
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xadd %%eax, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0x89abcdef && *memq == 0x1234567ffffffff,
+	       "xadd reg, r/m (3)");
+
+	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
+		     "mov %%rax, (%[memq])\n\t"
+		     "mov $0xfedcba9876543210, %%rax\n\t"
+		     "xadd %%rax, (%[memq])\n\t"
+		     "mov %%rax, %[rax]\n\t"
+		     : [rax]"=r"(rax)
+		     : [memq]"r"(memq)
+		     : "memory", "rax");
+	report(rax == 0x123456789abcdef && *memq == 0xffffffffffffffff,
+	       "xadd reg, r/m (4)");
+}
+
+static void test_muldiv(long *mem)
+{
+	long a, d, aa, dd;
+	u8 ex = 1;
+
+	*mem = 0; a = 1; d = 2;
+	asm (ASM_TRY("1f") "divq %3; movb $0, %2; 1:"
+	     : "+a"(a), "+d"(d), "+q"(ex) : "m"(*mem));
+	report(a == 1 && d == 2 && ex, "divq (fault)");
+
+	*mem = 987654321098765UL; a = 123456789012345UL; d = 123456789012345UL;
+	asm (ASM_TRY("1f") "divq %3; movb $0, %2; 1:"
+	     : "+a"(a), "+d"(d), "+q"(ex) : "m"(*mem));
+	report(a == 0x1ffffffb1b963b33ul && d == 0x273ba4384ede2ul && !ex, "divq (1)");
+
+	aa = 0x1111111111111111; dd = 0x2222222222222222;
+	*mem = 0x3333333333333333; a = aa; d = dd;
+	asm("mulb %2" : "+a"(a), "+d"(d) : "m"(*mem));
+	report(a == 0x1111111111110363 && d == dd, "mulb mem");
+	*mem = 0x3333333333333333; a = aa; d = dd;
+	asm("mulw %2" : "+a"(a), "+d"(d) : "m"(*mem));
+	report(a == 0x111111111111c963 && d == 0x2222222222220369, "mulw mem");
+	*mem = 0x3333333333333333; a = aa; d = dd;
+	asm("mull %2" : "+a"(a), "+d"(d) : "m"(*mem));
+	report(a == 0x962fc963 && d == 0x369d036, "mull mem");
+	*mem = 0x3333333333333333; a = aa; d = dd;
+	asm("mulq %2" : "+a"(a), "+d"(d) : "m"(*mem));
+	report(a == 0x2fc962fc962fc963 && d == 0x369d0369d0369d0, "mulq mem");
+}
+
+static void test_mmx(uint64_t *mem)
+{
+	uint64_t v;
+
+	write_cr0(read_cr0() & ~6); /* EM, TS */
+	asm volatile("fninit");
+	v = 0x0102030405060708ULL;
+	asm("movq %1, %0" : "=m"(*mem) : "y"(v));
+	report(v == *mem, "movq (mmx, read)");
+	*mem = 0x8070605040302010ull;
+	asm("movq %1, %0" : "=y"(v) : "m"(*mem));
+	report(v == *mem, "movq (mmx, write)");
+}
+
+static void test_rip_relative(unsigned *mem, char *insn_ram)
+{
+	/* movb $1, mem+2(%rip) */
+	insn_ram[0] = 0xc6;
+	insn_ram[1] = 0x05;
+	*(unsigned *)&insn_ram[2] = 2 + (char *)mem - (insn_ram + 7);
+	insn_ram[6] = 0x01;
+	/* ret */
+	insn_ram[7] = 0xc3;
+
+	*mem = 0;
+	asm("callq *%1" : "+m"(*mem) : "r"(insn_ram));
+	report(*mem == 0x10000, "movb $imm, 0(%%rip)");
+}
+
+static void test_cmov(u32 *mem)
+{
+	u64 val;
+	*mem = 0xabcdef12u;
+	asm ("movq $0x1234567812345678, %%rax\n\t"
+	     "cmpl %%eax, %%eax\n\t"
+	     "cmovnel (%[mem]), %%eax\n\t"
+	     "movq %%rax, %[val]\n\t"
+	     : [val]"=r"(val) : [mem]"r"(mem) : "%rax", "cc");
+	report(val == 0x12345678ul, "cmovnel");
+}
+
+
+static void test_mmx_movq_mf(uint64_t *mem)
+{
+	/* movq %mm0, (%rax) */
+	extern char movq_start, movq_end;
+	handler old;
+
+	uint16_t fcw = 0;  /* all exceptions unmasked */
+	write_cr0(read_cr0() & ~6);  /* TS, EM */
+	exceptions = 0;
+	old = handle_exception(MF_VECTOR, advance_rip_and_note_exception);
+	asm volatile("fninit; fldcw %0" : : "m"(fcw));
+	asm volatile("fldz; fldz; fdivp"); /* generate exception */
+
+	rip_advance = &movq_end - &movq_start;
+	asm(KVM_FEP "movq_start: movq %mm0, (%rax); movq_end:");
+	/* exit MMX mode */
+	asm volatile("fnclex; emms");
+	report(exceptions == 1, "movq mmx generates #MF");
+	handle_exception(MF_VECTOR, old);
+}
+
+static void test_jmp_noncanonical(uint64_t *mem)
+{
+	extern char nc_jmp_start, nc_jmp_end;
+	handler old;
+
+	*mem = 0x1111111111111111ul;
+
+	exceptions = 0;
+	rip_advance = &nc_jmp_end - &nc_jmp_start;
+	old = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
+	asm volatile ("nc_jmp_start: jmp *%0; nc_jmp_end:" : : "m"(*mem));
+	report(exceptions == 1, "jump to non-canonical address");
+	handle_exception(GP_VECTOR, old);
+}
+
+static void test_movabs(uint64_t *mem)
+{
+	/* mov $0x9090909090909090, %rcx */
+	unsigned long rcx;
+	asm(KVM_FEP "mov $0x9090909090909090, %0" : "=c" (rcx) : "0" (0));
+	report(rcx == 0x9090909090909090, "64-bit mov imm2");
+}
+
+static void test_push16(uint64_t *mem)
+{
+	uint64_t rsp1, rsp2;
+	uint16_t r;
+
+	asm volatile (	"movq %%rsp, %[rsp1]\n\t"
+			"pushw %[v]\n\t"
+			"popw %[r]\n\t"
+			"movq %%rsp, %[rsp2]\n\t"
+			"movq %[rsp1], %%rsp\n\t" :
+			[rsp1]"=r"(rsp1), [rsp2]"=r"(rsp2), [r]"=r"(r)
+			: [v]"m"(*mem) : "memory");
+	report(rsp1 == rsp2, "push16");
+}
+
+static void ss_bad_rpl(struct ex_regs *regs)
+{
+	extern char ss_bad_rpl_cont;
+
+	++exceptions;
+	regs->rip = (ulong)&ss_bad_rpl_cont;
+}
+
+static void test_sreg(volatile uint16_t *mem)
+{
+	u16 ss = read_ss();
+	handler old;
+
+	// check for null segment load
+	*mem = 0;
+	asm volatile("mov %0, %%ss" : : "m"(*mem));
+	report(read_ss() == 0, "mov null, %%ss");
+
+	// check for exception when ss.rpl != cpl on null segment load
+	exceptions = 0;
+	old = handle_exception(GP_VECTOR, ss_bad_rpl);
+	*mem = 3;
+	asm volatile("mov %0, %%ss; ss_bad_rpl_cont:" : : "m"(*mem));
+	report(exceptions == 1 && read_ss() == 0,
+	       "mov null, %%ss (with ss.rpl != cpl)");
+	handle_exception(GP_VECTOR, old);
+	write_ss(ss);
+}
+
+static uint64_t usr_gs_mov(void)
+{
+	static uint64_t dummy = MAGIC_NUM;
+	uint64_t dummy_ptr = (uint64_t)&dummy;
+	uint64_t ret;
+
+	dummy_ptr -= GS_BASE;
+	asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
+
+	return ret;
+}
+
+static void test_iret(void)
+{
+	uint64_t val;
+	bool raised_vector;
+
+	/* Update GS base to 4MiB */
+	wrmsr(MSR_GS_BASE, GS_BASE);
+
+	/*
+	* Per the SDM, jumping to user mode via `iret`, which is returning to
+	* outer privilege level, for segment registers (ES, FS, GS, and DS)
+	* if the check fails, the segment selector becomes null.
+	*
+	* In our test case, GS becomes null.
+	*/
+	val = run_in_user((usermode_func)usr_gs_mov, GP_VECTOR,
+			0, 0, 0, 0, &raised_vector);
+
+	report(val == MAGIC_NUM, "Test ret/iret with a nullified segment");
+}
+
+static void test_emulator_64(void *mem)
+{
+	void *insn_page = alloc_page();
+	void *insn_ram  = vmap(virt_to_phys(insn_page), 4096);
+
+	test_push(mem);
+	test_pop(mem);
+
+	test_xchg(mem);
+	test_xadd(mem);
+
+	test_cr8();
+
+	test_ljmp(mem);
+	test_muldiv(mem);
+	test_mmx(mem);
+	test_rip_relative(mem, insn_ram);
+	test_iret();
+	test_sreg(mem);
+	test_cmov(mem);
+
+	if (is_fep_available()) {
+		test_mmx_movq_mf(mem);
+		test_movabs(mem);
+	}
+
+	test_push16(mem);
+
+	test_jmp_noncanonical(mem);
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed65185..438efe2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -156,7 +156,6 @@ extra_params = -m 2048
 
 [emulator]
 file = emulator.flat
-arch = x86_64
 
 [eventinj]
 file = eventinj.flat
-- 
2.37.2.672.g94769d06f0-goog

