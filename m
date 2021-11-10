Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED1A44CB3E
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhKJVXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbhKJVXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3297EC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:23 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x18-20020a17090a789200b001a7317f995cso1880435pjk.4
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0Mn3/0vsl/BqcHzl4h7JC934taELWq7FYXUNRPu9fe4=;
        b=VGLGjfYD/RZA7DWwdCiVpo1kuvYiLVAxgr74Y2PXnz8Sst5Aafg/T66OX1SAxojGFC
         kO+vXF4+8B14E3aE5eVORO0vq5Kzwt8g3GlqHOpVOfC+PqTCZd0NO34HhbgFm5WudgfI
         UbVzn2ZGmxEJen2+cK/5W3nKkhlB7D9X8g9Qzov4qfMIh+Gw8xuRVe7JYSql1j7zohOg
         8kwwlARnbUdE7nUNA2/eW+3cDTA2rfTeRc9ve8CL/FedXBB8mwEOM24ZzTDJs8NpBXlc
         OdKnOLw1kbRQ3RRqVM0Gfe7pGC3ALKTfHqLnie/LPnJGU+qYde5Ew4pH0UVufkAEBl0o
         BoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0Mn3/0vsl/BqcHzl4h7JC934taELWq7FYXUNRPu9fe4=;
        b=3mQ3/KTvkSzlaGBimlPaBpmPzE5009zghtKkuERnXKqxMYP+G2fNGXkQwB3Ch4m6kw
         J7breFHdOQ/K/dgNjZ+UB93UY1O1Vh+r3XoetTDZSKKVVtBP1ZC6S0bKtt1VTA0K2Yes
         D1Gv24h4OhWN1HDtUEwmuV7kZ1yx/DZvdqfExa7VJvYGIhC01xnW1mz0YaC0iWnFgP8G
         pgmfXMcupT01msih/1mf1Xi4aFgmyEDBmu3tN2BvQWj+aXpJqTHOP2LqsyMf7zjuVRbD
         tdeIGa49tR1qCJccPkLa28sJxJLi4TvVCyTqs/GiAFaGM88OMgdNx8ba8j5NoMBSQ2A2
         Ttog==
X-Gm-Message-State: AOAM530S4TWJjbWpoYo+mDpOgGNTt1Vok8xWwn3DcdsdjIXI0G8S/zXH
        wYFHCQdnytfJkHQzyE6Wo5FamiwzKt74/tzsZVpcpQS8tcw3/u09iqEvTPpX/k4MCGsDzCAo1RH
        rUMKXyvj0RrcXY3HUI+f8xYKNC1PckrgcBGR/HfMg7jpfeck6D/d40v1DmT4JNgdn0z+n
X-Google-Smtp-Source: ABdhPJz/KzX2+dGq3iFCuJzmY3Se5ybolVrQyLT5Cj0cvtMnXrPA+uOLG+V+TUENjPYJZcexxhZw5xGbtOVxRwIt
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:778a:b0:13f:672c:103a with SMTP
 id o10-20020a170902778a00b0013f672c103amr1965298pll.55.1636579222611; Wed, 10
 Nov 2021 13:20:22 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:54 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-8-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 07/14] x86: get rid of ring0stacktop
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ring3 switch code relied on a special stack page that was used
for the ring0 stack during the ring3 part of the test.  This special
stack page was used if an exception handler ran during the ring3 part
of the test.

This method is quite complex; it is easier to just use the same
stack for the "outer" part of the test and the exception handler.
To do so, store esp/rsp in the TSS just before doing the PUSH/IRET
sequence.  On 64-bit, the TSS can also be used to restore rsp after
coming back from ring3.

Unifying the three copies of the ring switching code is left as an
exercise to the reader.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[aaron: removed commas after (tss.rsp0) in usermode.c and umips.c]
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 lib/x86/usermode.c |  9 +++++----
 x86/access.c       | 16 ++++++++--------
 x86/cstart.S       |  6 +-----
 x86/cstart64.S     |  6 +-----
 x86/umip.c         | 19 ++++++++++++-------
 5 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f032523..49b87b2 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -47,8 +47,8 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 	}
 
 	asm volatile (
-			/* Backing Up Stack in rdi */
-			"mov %%rsp, %%rdi\n\t"
+			/* Prepare kernel SP for exception handlers */
+			"mov %%rsp, %[rsp0]\n\t"
 			/* Load user_ds to DS and ES */
 			"mov %[user_ds], %%ax\n\t"
 			"mov %%ax, %%ds\n\t"
@@ -92,9 +92,10 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"int %[kernel_entry_vector]\n\t"
 			/* Kernel Mode */
 			"ret_to_kernel:\n\t"
-			"mov %%rdi, %%rsp\n\t"
+			"mov %[rsp0], %%rsp\n\t"
 			:
-			"+a"(rax)
+			"+a"(rax),
+			[rsp0]"=m"(tss.rsp0)
 			:
 			[arg1]"m"(arg1),
 			[arg2]"m"(arg2),
diff --git a/x86/access.c b/x86/access.c
index 4725bbd..49d31b1 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -711,7 +711,7 @@ static int ac_test_do_access(ac_test_t *at)
     }
 
     asm volatile ("mov $fixed1, %%rsi \n\t"
-		  "mov %%rsp, %%rdx \n\t"
+		  "mov %%rsp, %[rsp0] \n\t"
 		  "cmp $0, %[user] \n\t"
 		  "jz do_access \n\t"
 		  "push %%rax; mov %[user_ds], %%ax; mov %%ax, %%ds; pop %%rax  \n\t"
@@ -734,8 +734,14 @@ static int ac_test_do_access(ac_test_t *at)
 		  "done: \n"
 		  "fixed1: \n"
 		  "int %[kernel_entry_vector] \n\t"
+		  ".section .text.entry \n\t"
+		  "kernel_entry: \n\t"
+		  "mov %[rsp0], %%rsp \n\t"
+		  "jmp back_to_kernel \n\t"
+		  ".section .text \n\t"
 		  "back_to_kernel:"
-		  : [reg]"+r"(r), "+a"(fault), "=b"(e), "=&d"(rsp)
+		  : [reg]"+r"(r), "+a"(fault), "=b"(e), "=&d"(rsp),
+		    [rsp0]"=m"(tss.rsp0)
 		  : [addr]"r"(at->virt),
 		    [write]"r"(F(AC_ACCESS_WRITE)),
 		    [user]"r"(F(AC_ACCESS_USER)),
@@ -754,12 +760,6 @@ static int ac_test_do_access(ac_test_t *at)
 		  "iretq \n\t"
 		  ".section .text");
 
-    asm volatile (".section .text.entry \n\t"
-		  "kernel_entry: \n\t"
-		  "mov %rdx, %rsp \n\t"
-		  "jmp back_to_kernel \n\t"
-		  ".section .text");
-
     ac_test_check(at, &success, fault && !at->expected_fault,
                   "unexpected fault");
     ac_test_check(at, &success, !fault && at->expected_fault,
diff --git a/x86/cstart.S b/x86/cstart.S
index 5e925d8..e9100a4 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -13,10 +13,6 @@ max_cpus = MAX_TEST_CPUS
 	.align 16
 stacktop:
 
-	. = . + 4096
-	.align 16
-ring0stacktop:
-
 .data
 
 .align 4096
@@ -62,7 +58,7 @@ i = 0
 tss:
         .rept max_cpus
         .long 0
-        .long ring0stacktop - i * 4096
+        .long 0
         .long 16
         .quad 0, 0
         .quad 0, 0, 0, 0, 0, 0, 0, 0
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 46b9d9b..18c7457 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -16,10 +16,6 @@ max_cpus = MAX_TEST_CPUS
 	.align 16
 stacktop:
 
-	. = . + 4096 * max_cpus
-	.align 16
-ring0stacktop:
-
 .data
 
 .align 4096
@@ -83,7 +79,7 @@ i = 0
 tss:
 	.rept max_cpus
 	.long 0
-	.quad ring0stacktop - i * 4096
+	.quad 0
 	.quad 0, 0
 	.quad 0, 0, 0, 0, 0, 0, 0, 0
 	.long 0, 0, 0
diff --git a/x86/umip.c b/x86/umip.c
index 0fc1f65..1936989 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -124,7 +124,7 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		  "mov %%dx, %%es\n\t"
 		  "mov %%dx, %%fs\n\t"
 		  "mov %%dx, %%gs\n\t"
-		  "mov %%" R "sp, %%" R "cx\n\t"
+		  "mov %%" R "sp, %[sp0]\n\t" /* kernel sp for exception handlers */
 		  "push" W " %%" R "dx \n\t"
 		  "lea %[user_stack_top], %%" R "dx \n\t"
 		  "push" W " %%" R "dx \n\t"
@@ -133,8 +133,6 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		  "push" W " $1f \n\t"
 		  "iret" W "\n"
 		  "1: \n\t"
-		  "push %%" R "cx\n\t"   /* save kernel SP */
-
 #ifndef __x86_64__
 		  "push %[arg]\n\t"
 #endif
@@ -142,13 +140,15 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 #ifndef __x86_64__
 		  "pop %%ecx\n\t"
 #endif
-
-		  "pop %%" R "cx\n\t"
 		  "mov $1f, %%" R "dx\n\t"
 		  "int %[kernel_entry_vector]\n\t"
 		  ".section .text.entry \n\t"
 		  "kernel_entry: \n\t"
-		  "mov %%" R "cx, %%" R "sp \n\t"
+#ifdef __x86_64__
+		  "mov %[sp0], %%" R "sp\n\t"
+#else
+		  "add $(5 * " S "), %%esp\n\t"
+#endif
 		  "mov %[kernel_ds], %%cx\n\t"
 		  "mov %%cx, %%ds\n\t"
 		  "mov %%cx, %%es\n\t"
@@ -157,7 +157,12 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		  "jmp *%%" R "dx \n\t"
 		  ".section .text\n\t"
 		  "1:\n\t"
-		  : [ret] "=&a" (ret)
+		  : [ret] "=&a" (ret),
+#ifdef __x86_64__
+		    [sp0] "=m" (tss.rsp0)
+#else
+		    [sp0] "=m" (tss.esp0)
+#endif
 		  : [user_ds] "i" (USER_DS),
 		    [user_cs] "i" (USER_CS),
 		    [user_stack_top]"m"(user_stack[sizeof(user_stack) -
-- 
2.34.0.rc1.387.gb447b232ab-goog

