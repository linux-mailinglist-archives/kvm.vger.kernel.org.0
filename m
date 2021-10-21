Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981904360C4
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJULvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhJULvj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZAn/jTY0LziBZmH3pZ3RohY8m+Wz1EaELpR3UJa/64=;
        b=JwMUUIk9OH7/W1aMrCJEiw5QgN5HmFvFUeRkrEzinCVSj+2uU1RX+fItnMWG5920j0+rKr
        C916BN3xG578XtVi5xX7NhuOvViurE47Fe1H4s/i9z25DhsALDdO6GpuaocgDVfffeO/Qt
        vaCXdnVoCryMXkJ6fiEk8tMU1cQvhWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-em97JuSSPOuxJBxbfLK1EQ-1; Thu, 21 Oct 2021 07:49:18 -0400
X-MC-Unique: em97JuSSPOuxJBxbfLK1EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D07E802682;
        Thu, 21 Oct 2021 11:49:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5E296788F;
        Thu, 21 Oct 2021 11:49:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Subject: [PATCH kvm-unit-tests 7/9] x86: get rid of ring0stacktop
Date:   Thu, 21 Oct 2021 07:49:08 -0400
Message-Id: <20211021114910.1347278-8-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-1-pbonzini@redhat.com>
References: <20211021114910.1347278-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
---
 lib/x86/usermode.c |  9 +++++----
 x86/access.c       | 16 ++++++++--------
 x86/cstart.S       |  6 +-----
 x86/cstart64.S     |  6 +-----
 x86/umip.c         | 19 ++++++++++++-------
 5 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f032523..d511f4f 100644
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
+			[rsp0]"=m"(tss.rsp0),
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
index 0fc1f65..79e288d 100644
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
+		    [sp0] "=m" (tss.rsp0),
+#else
+		    [sp0] "=m" (tss.esp0),
+#endif
 		  : [user_ds] "i" (USER_DS),
 		    [user_cs] "i" (USER_CS),
 		    [user_stack_top]"m"(user_stack[sizeof(user_stack) -
-- 
2.27.0


