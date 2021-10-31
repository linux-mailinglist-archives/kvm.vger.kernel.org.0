Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3D7440D49
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJaF7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhJaF7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:13 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC5CC061570
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 187so13276945pfc.10
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wLq/o3L9faxzjpO4dTXlYCgSvE5SKd/tnXGve6D6V/0=;
        b=P5W5463ujMqLbqTdTsh6I3VL9pCBV8tIT3v/NLXCTtRqmaznF7avGTytQsy4oG2jH5
         N9WLQEYZl7c9rbMZQ58PKwbYtiM6+dpNv9szJl5VIW1LyEW2HW0Ch+EeCw3z7jXCg0rI
         sktvw3F4+KynwTzBpnikPL+hvUKC/6oY5/j1YDCfQyZrdjcVOW8fEou2u5knGYVfXlv4
         T3ZWgjfsfFcn53fRfBCaIjFl0god7dtqsgvZfutyCga1zxsUVgAKIAYVNxKMfQ0q0I9k
         YsLCtB5+fhYNuA613J0/23x2l6KHatz+wkP6a9MYI9RycZVI3x9QqrdFOqfWURsFeNi1
         zEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLq/o3L9faxzjpO4dTXlYCgSvE5SKd/tnXGve6D6V/0=;
        b=HeK/NbEenJw1oL3V3yxiuosvyW+gmFv8z0WTEyyV60iVAX3AUIM8hxnYqEn46NyQcT
         kqicB6rq4xHjmg8EQCTKrlLzaDHmEbCYoSCZwU/2JVZGZq6KYKz2D/qiw4CzZtH3gbE5
         qmtnM+Y3O7u+/bQXpgnOKQAPtpR0teDDpFFhm72S61/htR4TjKVcPlOkTc4g37/vTdl8
         a/u1QBH4D4ogkmCV/hU7slHRFyP6R6zy+1dcVoS/EYc67KJkboktybS7Fhhfs0D7Kvly
         eRmW5AIVYBgkB06PqhelZ34aYF44yVynT2MQT4GluaHlvgr1n5mnU7GVZZh7nuwzUz1H
         Mq/A==
X-Gm-Message-State: AOAM5330o5Q859xYG2D47Zz3qaT6W+OfBKr1XL4l12SReCyLrBDO9Zpv
        pQ56q9F3gmXONhBRyDmldXb+xe2dwY7Y6Q==
X-Google-Smtp-Source: ABdhPJyimAb0kRY/FqJkvUBJmMCWxwSmjqMemC/rr5UuAIvKndP9p7eWePXujkcXwcUSljIqqBBWGw==
X-Received: by 2002:a63:6e03:: with SMTP id j3mr15820405pgc.465.1635659801476;
        Sat, 30 Oct 2021 22:56:41 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:41 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 3/7] x86 UEFI: Convert x86 test cases to PIC
Date:   Sat, 30 Oct 2021 22:56:30 -0700
Message-Id: <20211031055634.894263-4-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

UEFI loads EFI applications to dynamic runtime addresses, so it requires
all applications to be compiled as PIC (position independent code). PIC
does not allow the usage of compile time absolute address.

This commit converts multiple x86 test cases to PIC so they can compile
and run in UEFI:

- x86/cet.efi

- x86/emulator.c: x86/emulator.c depends on lib/x86/usermode.c. But
usermode.c contains non-PIC inline assembly code. This commit converts
lib/x86/usermode.c and x86/emulator.c to PIC, so x86/emulator.c can
compile and run in UEFI.

- x86/vmware_backdoors.c: it depends on lib/x86/usermode.c and now works
without modifications

- x86/eventinj.c

- x86/smap.c

- x86/access.c

- x86/umip.c

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/usermode.c  |  3 ++-
 x86/Makefile.common | 10 +++++-----
 x86/Makefile.x86_64 |  7 ++++---
 x86/access.c        |  9 +++++----
 x86/cet.c           |  8 +++++---
 x86/emulator.c      |  5 +++--
 x86/eventinj.c      |  8 ++++++++
 x86/smap.c          | 13 +++++++++----
 x86/umip.c          | 26 +++++++++++++++++++++++---
 9 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index 2e77831..5b657fd 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -58,7 +58,8 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"pushq %[user_stack_top]\n\t"
 			"pushfq\n\t"
 			"pushq %[user_cs]\n\t"
-			"pushq $user_mode\n\t"
+			"lea user_mode(%%rip), %%rdx\n\t"
+			"pushq %%rdx\n\t"
 			"iretq\n"
 
 			"user_mode:\n\t"
diff --git a/x86/Makefile.common b/x86/Makefile.common
index deaa386..119f4b2 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -81,16 +81,16 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/init.$(exe) \
                $(TEST_DIR)/hyperv_synic.$(exe) $(TEST_DIR)/hyperv_stimer.$(exe) \
                $(TEST_DIR)/hyperv_connections.$(exe) \
-               $(TEST_DIR)/tsx-ctrl.$(exe)
+               $(TEST_DIR)/tsx-ctrl.$(exe) \
+	       $(TEST_DIR)/eventinj.$(exe) \
+               $(TEST_DIR)/umip.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
 # with the '-fPIC' flag
 ifneq ($(TARGET_EFI),y)
-tests-common += $(TEST_DIR)/eventinj.$(exe) \
-                $(TEST_DIR)/smap.$(exe) \
-                $(TEST_DIR)/realmode.$(exe) \
-                $(TEST_DIR)/umip.$(exe)
+tests-common += $(TEST_DIR)/smap.$(exe) \
+                $(TEST_DIR)/realmode.$(exe)
 endif
 
 test_cases: $(tests-common) $(tests)
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index fe6457c..3963840 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -30,6 +30,8 @@ tests += $(TEST_DIR)/intel-iommu.$(exe)
 tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
+tests += $(TEST_DIR)/emulator.$(exe)
+tests += $(TEST_DIR)/vmware_backdoors.$(exe)
 
 ifeq ($(TARGET_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
@@ -40,14 +42,13 @@ endif
 # with the '-fPIC' flag
 ifneq ($(TARGET_EFI),y)
 tests += $(TEST_DIR)/access.$(exe)
-tests += $(TEST_DIR)/emulator.$(exe)
 tests += $(TEST_DIR)/svm.$(exe)
 tests += $(TEST_DIR)/vmx.$(exe)
-tests += $(TEST_DIR)/vmware_backdoors.$(exe)
+endif
+
 ifneq ($(fcf_protection_full),)
 tests += $(TEST_DIR)/cet.$(exe)
 endif
-endif
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/access.c b/x86/access.c
index 911f0e3..a2ec049 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -700,7 +700,7 @@ static int ac_test_do_access(ac_test_t *at)
 
     if (F(AC_ACCESS_TWICE)) {
 	asm volatile (
-	    "mov $fixed2, %%rsi \n\t"
+	    "lea fixed2(%%rip), %%rsi \n\t"
 	    "mov (%[addr]), %[reg] \n\t"
 	    "fixed2:"
 	    : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
@@ -710,7 +710,7 @@ static int ac_test_do_access(ac_test_t *at)
 	fault = 0;
     }
 
-    asm volatile ("mov $fixed1, %%rsi \n\t"
+    asm volatile ("lea fixed1(%%rip), %%rsi \n\t"
 		  "mov %%rsp, %[rsp0] \n\t"
 		  "cmp $0, %[user] \n\t"
 		  "jz do_access \n\t"
@@ -719,7 +719,8 @@ static int ac_test_do_access(ac_test_t *at)
 		  "pushq %[user_stack_top] \n\t"
 		  "pushfq \n\t"
 		  "pushq %[user_cs] \n\t"
-		  "pushq $do_access \n\t"
+		  "lea do_access(%%rip), %%r8\n\t"
+		  "pushq %%r8\n\t"
 		  "iretq \n"
 		  "do_access: \n\t"
 		  "cmp $0, %[fetch] \n\t"
@@ -750,7 +751,7 @@ static int ac_test_do_access(ac_test_t *at)
 		    [user_cs]"i"(USER_CS),
 		    [user_stack_top]"r"(user_stack + sizeof user_stack),
 		    [kernel_entry_vector]"i"(0x20)
-		  : "rsi");
+		  : "rsi", "r8");
 
     asm volatile (".section .text.pf \n\t"
 		  "page_fault: \n\t"
diff --git a/x86/cet.c b/x86/cet.c
index a21577a..a4b79cb 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -52,7 +52,7 @@ static u64 cet_ibt_func(void)
 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
 	asm volatile ("movq $2, %rcx\n"
 		      "dec %rcx\n"
-		      "leaq 2f, %rax\n"
+		      "leaq 2f(%rip), %rax\n"
 		      "jmp *%rax \n"
 		      "2:\n"
 		      "dec %rcx\n");
@@ -67,7 +67,8 @@ void test_func(void) {
 			"pushq %[user_stack_top]\n\t"
 			"pushfq\n\t"
 			"pushq %[user_cs]\n\t"
-			"pushq $user_mode\n\t"
+			"lea user_mode(%%rip), %%rax\n\t"
+			"pushq %%rax\n\t"
 			"iretq\n"
 
 			"user_mode:\n\t"
@@ -77,7 +78,8 @@ void test_func(void) {
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack +
-					sizeof(user_stack)));
+					sizeof(user_stack))
+			: "rax");
 }
 
 #define SAVE_REGS() \
diff --git a/x86/emulator.c b/x86/emulator.c
index c5f584a..22a518f 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -262,12 +262,13 @@ static void test_pop(void *mem)
 
 	asm volatile("mov %%rsp, %[tmp] \n\t"
 		     "mov %[stack_top], %%rsp \n\t"
-		     "push $1f \n\t"
+		     "lea 1f(%%rip), %%rax \n\t"
+		     "push %%rax \n\t"
 		     "ret \n\t"
 		     "2: jmp 2b \n\t"
 		     "1: mov %[tmp], %%rsp"
 		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
-		     : "memory");
+		     : "memory", "rax");
 	report_pass("ret");
 
 	stack_top[-1] = 0x778899;
diff --git a/x86/eventinj.c b/x86/eventinj.c
index 46593c9..3c0db56 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -155,9 +155,17 @@ asm("do_iret:"
 	"pushf"W" \n\t"
 	"mov %cs, %ecx \n\t"
 	"push"W" %"R "cx \n\t"
+#ifndef __x86_64__
 	"push"W" $2f \n\t"
 
 	"cmpb $0, no_test_device\n\t"	// see if need to flush
+#else
+	"leaq 2f(%rip), %rbx \n\t"
+	"pushq %rbx \n\t"
+
+	"mov no_test_device(%rip), %bl \n\t"
+	"cmpb $0, %bl\n\t"		// see if need to flush
+#endif
 	"jnz 1f\n\t"
 	"outl %eax, $0xe4 \n\t"		// flush page
 	"1: \n\t"
diff --git a/x86/smap.c b/x86/smap.c
index c6ddf38..0994c29 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -159,12 +159,17 @@ int main(int ac, char **av)
 		init_test(i);
 		stac();
 		test = -1;
+#ifndef __x86_64__
+		#define TEST "test"
+#else
+		#define TEST "test(%rip)"
+#endif
 		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
 		    "push $44 \n "
-		    "decl test\n"
+		    "decl " TEST "\n"
 		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
 		    "pop %"R "ax\n"
-		    "movl %eax, test");
+		    "movl %eax, " TEST "\n");
 		report(pf_count == 0 && test == 44,
 		       "write to user stack with AC=1");
 
@@ -173,10 +178,10 @@ int main(int ac, char **av)
 		test = -1;
 		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
 		    "push $45 \n "
-		    "decl test\n"
+		    "decl " TEST "\n"
 		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
 		    "pop %"R "ax\n"
-		    "movl %eax, test");
+		    "movl %eax, " TEST "\n");
 		report(pf_count == 1 && test == 45 && save == -1,
 		       "write to user stack with AC=0");
 
diff --git a/x86/umip.c b/x86/umip.c
index af8db59..fccdedc 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -20,10 +20,20 @@ static void gp_handler(struct ex_regs *regs)
     }
 }
 
+#ifndef __x86_64__
+#define GP_ASM_MOVE_TO_RIP                  \
+	"mov" W " $1f, %[expected_rip]\n\t"
+#else
+#define GP_ASM_MOVE_TO_RIP                  \
+	"pushq %%rax\n\t"                   \
+	"lea 1f(%%rip), %%rax\n\t"          \
+	"mov %%rax, %[expected_rip]\n\t"    \
+	"popq %%rax\n\t"
+#endif
 
 #define GP_ASM(stmt, in, clobber)                  \
     asm volatile (                                 \
-          "mov" W " $1f, %[expected_rip]\n\t"      \
+	  GP_ASM_MOVE_TO_RIP                       \
           "movl $2f-1f, %[skip_count]\n\t"         \
           "1: " stmt "\n\t"                        \
           "2: "                                    \
@@ -125,12 +135,18 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		  "mov %%dx, %%fs\n\t"
 		  "mov %%dx, %%gs\n\t"
 		  "mov %%" R "sp, %[sp0]\n\t" /* kernel sp for exception handlers */
+		  "mov %[sp0], %%" R "bx\n\t" /* ebx/rbx is preserved before and after 'call' instruction */
 		  "push" W " %%" R "dx \n\t"
 		  "lea %[user_stack_top], %%" R "dx \n\t"
 		  "push" W " %%" R "dx \n\t"
 		  "pushf" W "\n\t"
 		  "push" W " %[user_cs] \n\t"
+#ifndef __x86_64__
 		  "push" W " $1f \n\t"
+#else
+		  "lea 1f(%%rip), %%rdx \n\t"
+		  "pushq %%rdx \n\t"
+#endif
 		  "iret" W "\n"
 		  "1: \n\t"
 #ifndef __x86_64__
@@ -140,12 +156,16 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 #ifndef __x86_64__
 		  "pop %%ecx\n\t"
 #endif
+#ifndef __x86_64__
 		  "mov $1f, %%" R "dx\n\t"
+#else
+		  "lea 1f(%%" R "ip), %%" R "dx\n\t"
+#endif
 		  "int %[kernel_entry_vector]\n\t"
 		  ".section .text.entry \n\t"
 		  "kernel_entry: \n\t"
 #ifdef __x86_64__
-		  "mov %[sp0], %%" R "sp\n\t"
+		  "mov %%rbx, %%rsp\n\t"
 #else
 		  "add $(5 * " S "), %%esp\n\t"
 #endif
@@ -171,7 +191,7 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		    [arg]"D"(arg),
 		    [kernel_ds]"i"(KERNEL_DS),
 		    [kernel_entry_vector]"i"(0x20)
-		  : "rcx", "rdx");
+		  : "rcx", "rdx", "rbx");
     return ret;
 }
 
-- 
2.33.0

