Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117644360C6
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhJULvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:51:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231207AbhJULvk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwHVxTFBrKDt/sbLPThjJc+qd37lhQscjKcpLysTxGE=;
        b=Agn+woZs3G2T7KVWhgVN9fGVdx8VCivUtuNyHjuvgJ8v5csXQhNOCnql9m1G43tpa5rK0X
        wg0UPhoIVLL19SBGfca7Xid9L97aTfxggC6qIcSrqUKrDMhLE5jTxCaHbkQD+XmXwnnG/w
        jAGNImU9hc3XU6Jb4lWJCLeFwCsfoDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-5_tRAFSxN3C_NVpjIjeyLA-1; Thu, 21 Oct 2021 07:49:19 -0400
X-MC-Unique: 5_tRAFSxN3C_NVpjIjeyLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F404802B52;
        Thu, 21 Oct 2021 11:49:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A84FF6788F;
        Thu, 21 Oct 2021 11:49:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com, Zixuan Wang <zixuanwang@google.com>
Subject: [PATCH kvm-unit-tests 8/9] x86: Move 64-bit GDT and TSS to desc.c
Date:   Thu, 21 Oct 2021 07:49:09 -0400
Message-Id: <20211021114910.1347278-9-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-1-pbonzini@redhat.com>
References: <20211021114910.1347278-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

Move the GDT and TSS data structures from x86/cstart64.S to
lib/x86/desc.c, so that the follow-up UEFI support commits can reuse
these definitions, without re-defining them in UEFI's boot up assembly
code.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
Message-Id: <20211004204931.1537823-2-zxwang42@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/asm/setup.h |  6 ++++
 lib/x86/desc.c      | 38 +++++++++++++++++++++--
 lib/x86/desc.h      |  4 +--
 lib/x86/setup.c     | 25 +++++++++++++++
 lib/x86/usermode.c  |  2 +-
 x86/access.c        |  2 +-
 x86/cstart64.S      | 76 +++++----------------------------------------
 x86/umip.c          |  2 +-
 8 files changed, 79 insertions(+), 76 deletions(-)
 create mode 100644 lib/x86/asm/setup.h

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
new file mode 100644
index 0000000..e3c3bfb
--- /dev/null
+++ b/lib/x86/asm/setup.h
@@ -0,0 +1,6 @@
+#ifndef _X86_ASM_SETUP_H_
+#define _X86_ASM_SETUP_H_
+
+unsigned long setup_tss(void);
+
+#endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index ac167d0..c185c01 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -2,6 +2,7 @@
 #include "desc.h"
 #include "processor.h"
 #include <setjmp.h>
+#include "apic-defs.h"
 
 /* Boot-related data structures */
 
@@ -13,6 +14,29 @@ struct descriptor_table_ptr idt_descr = {
 	.base = (unsigned long)boot_idt,
 };
 
+#ifdef __x86_64__
+/* GDT, TSS and descriptors */
+gdt_entry_t gdt[TSS_MAIN / 8 + MAX_TEST_CPUS * 2] = {
+	{     0, 0, 0, .type_limit_flags = 0x0000}, /* 0x00 null */
+	{0xffff, 0, 0, .type_limit_flags = 0xaf9b}, /* 0x08 64-bit code segment */
+	{0xffff, 0, 0, .type_limit_flags = 0xcf93}, /* 0x10 32/64-bit data segment */
+	{0xffff, 0, 0, .type_limit_flags = 0xaf1b}, /* 0x18 64-bit code segment, not present */
+	{0xffff, 0, 0, .type_limit_flags = 0xcf9b}, /* 0x20 32-bit code segment */
+	{0xffff, 0, 0, .type_limit_flags = 0x8f9b}, /* 0x28 16-bit code segment */
+	{0xffff, 0, 0, .type_limit_flags = 0x8f93}, /* 0x30 16-bit data segment */
+	{0xffff, 0, 0, .type_limit_flags = 0xcffb}, /* 0x38 32-bit code segment (user) */
+	{0xffff, 0, 0, .type_limit_flags = 0xcff3}, /* 0x40 32/64-bit data segment (user) */
+	{0xffff, 0, 0, .type_limit_flags = 0xaffb}, /* 0x48 64-bit code segment (user) */
+};
+
+tss64_t tss[MAX_TEST_CPUS] = {0};
+
+struct descriptor_table_ptr gdt_descr = {
+	.limit = sizeof(gdt) - 1,
+	.base = (unsigned long)gdt,
+};
+#endif
+
 #ifndef __x86_64__
 __attribute__((regparm(1)))
 #endif
@@ -289,8 +313,7 @@ bool exception_rflags_rf(void)
 
 static char intr_alt_stack[4096];
 
-#ifndef __x86_64__
-void set_gdt_entry(int sel, u32 base,  u32 limit, u8 type, u8 flags)
+void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
 {
 	gdt_entry_t *entry = &gdt[sel >> 3];
 
@@ -302,8 +325,17 @@ void set_gdt_entry(int sel, u32 base,  u32 limit, u8 type, u8 flags)
 	/* Setup the descriptor limits, type and flags */
 	entry->limit1 = (limit & 0xFFFF);
 	entry->type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
+
+#ifdef __x86_64__
+	if (!entry->s) {
+		struct system_desc64 *entry16 = (struct system_desc64 *)entry;
+		entry16->zero = 0;
+		entry16->base4 = base >> 32;
+	}
+#endif
 }
 
+#ifndef __x86_64__
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
 {
     set_gdt_entry(sel, tss_sel, 0, 0x85, 0); // task, present
@@ -380,7 +412,7 @@ void set_intr_alt_stack(int e, void *addr)
 
 void setup_alt_stack(void)
 {
-	tss.ist1 = (u64)intr_alt_stack + 4096;
+	tss[0].ist1 = (u64)intr_alt_stack + 4096;
 }
 #endif
 
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index c0817d8..ddfae04 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -204,7 +204,7 @@ void set_idt_task_gate(int vec, u16 sel);
 void set_intr_task_gate(int vec, void *fn);
 void setup_tss32(void);
 #else
-extern tss64_t tss;
+extern tss64_t tss[];
 #endif
 extern gdt_entry_t gdt[];
 
@@ -215,7 +215,7 @@ bool exception_rflags_rf(void);
 void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
-void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran);
+void set_gdt_entry(int sel, unsigned long base, u32 limit, u8 access, u8 gran);
 void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7befe09..ec005b5 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -2,6 +2,7 @@
  * Initialize machine setup information
  *
  * Copyright (C) 2017, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ * Copyright (C) 2021, Google Inc, Zixuan Wang <zixuanwang@google.com>
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
@@ -9,6 +10,10 @@
 #include "fwcfg.h"
 #include "alloc_phys.h"
 #include "argv.h"
+#include "desc.h"
+#include "apic.h"
+#include "apic-defs.h"
+#include "asm/setup.h"
 
 extern char edata;
 
@@ -97,6 +102,26 @@ void find_highmem(void)
 		phys_alloc_init(best_start, best_end - best_start);
 	}
 }
+
+/* Setup TSS for the current processor, and return TSS offset within GDT */
+unsigned long setup_tss(void)
+{
+	u32 id;
+	tss64_t *tss_entry;
+
+	id = apic_id();
+
+	/* Runtime address of current TSS */
+	tss_entry = &tss[id];
+
+	/* Update TSS */
+	memset((void *)tss_entry, 0, sizeof(tss64_t));
+
+	/* Update TSS descriptors; each descriptor takes up 2 entries */
+	set_gdt_entry(TSS_MAIN + id * 16, (unsigned long)tss_entry, 0xffff, 0x89, 0);
+
+	return TSS_MAIN + id * 16;
+}
 #endif
 
 void setup_multiboot(struct mbi_bootinfo *bi)
diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index d511f4f..c44faba 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -95,7 +95,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"mov %[rsp0], %%rsp\n\t"
 			:
 			"+a"(rax),
-			[rsp0]"=m"(tss.rsp0),
+			[rsp0]"=m"(tss[0].rsp0),
 			:
 			[arg1]"m"(arg1),
 			[arg2]"m"(arg2),
diff --git a/x86/access.c b/x86/access.c
index 49d31b1..a781a0c 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -741,7 +741,7 @@ static int ac_test_do_access(ac_test_t *at)
 		  ".section .text \n\t"
 		  "back_to_kernel:"
 		  : [reg]"+r"(r), "+a"(fault), "=b"(e), "=&d"(rsp),
-		    [rsp0]"=m"(tss.rsp0)
+		    [rsp0]"=m"(tss[0].rsp0)
 		  : [addr]"r"(at->virt),
 		    [write]"r"(F(AC_ACCESS_WRITE)),
 		    [user]"r"(F(AC_ACCESS_USER)),
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 18c7457..c6daa34 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,8 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl gdt
-.globl gdt_descr
 .globl online_cpus
 .globl cpu_online_count
 
@@ -44,49 +42,6 @@ ptl5:
 
 .align 4096
 
-gdt_descr:
-	.word gdt_end - gdt - 1
-	.quad gdt
-
-gdt:
-	.quad 0
-	.quad 0x00af9b000000ffff // 64-bit code segment
-	.quad 0x00cf93000000ffff // 32/64-bit data segment
-	.quad 0x00af1b000000ffff // 64-bit code segment, not present
-	.quad 0x00cf9b000000ffff // 32-bit code segment
-	.quad 0x008f9b000000FFFF // 16-bit code segment
-	.quad 0x008f93000000FFFF // 16-bit data segment
-	.quad 0x00cffb000000ffff // 32-bit code segment (user)
-	.quad 0x00cff3000000ffff // 32/64-bit data segment (user)
-	.quad 0x00affb000000ffff // 64-bit code segment (user)
-
-	.quad 0			 // 6 spare selectors
-	.quad 0
-	.quad 0
-	.quad 0
-	.quad 0
-	.quad 0
-
-tss_descr:
-	.rept max_cpus
-	.quad 0x000089000000ffff // 64-bit avail tss
-	.quad 0                  // tss high addr
-	.endr
-gdt_end:
-
-i = 0
-.globl tss
-tss:
-	.rept max_cpus
-	.long 0
-	.quad 0
-	.quad 0, 0
-	.quad 0, 0, 0, 0, 0, 0, 0, 0
-	.long 0, 0, 0
-i = i + 1
-	.endr
-tss_end:
-
 mb_boot_info:	.quad 0
 
 pt_root:	.quad ptl4
@@ -111,6 +66,12 @@ MSR_GS_BASE = 0xc0000101
 	wrmsr
 .endm
 
+.macro load_tss
+	lidtq idt_descr
+	call setup_tss
+	ltr %ax
+.endm
+
 .macro setup_segments
 	mov $MSR_GS_BASE, %ecx
 	rdmsr
@@ -228,7 +189,7 @@ save_id:
 
 ap_start64:
 	call reset_apic
-	call load_tss
+	load_tss
 	call enable_apic
 	call save_id
 	call enable_x2apic
@@ -241,7 +202,7 @@ ap_start64:
 
 start64:
 	call reset_apic
-	call load_tss
+	load_tss
 	call mask_pic_interrupts
 	call enable_apic
 	call save_id
@@ -280,27 +241,6 @@ lvl5:
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
-load_tss:
-	lidtq idt_descr
-	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-	mov (%rax), %eax
-	shr $24, %eax
-	mov %eax, %ebx
-	shl $4, %ebx
-	mov $((tss_end - tss) / max_cpus), %edx
-	imul %edx
-	add $tss, %rax
-	mov %ax, tss_descr+2(%rbx)
-	shr $16, %rax
-	mov %al, tss_descr+4(%rbx)
-	shr $8, %rax
-	mov %al, tss_descr+7(%rbx)
-	shr $8, %rax
-	mov %eax, tss_descr+8(%rbx)
-	lea tss_descr-gdt(%rbx), %rax
-	ltr %ax
-	ret
-
 ap_init:
 	cld
 	lea sipi_entry, %rsi
diff --git a/x86/umip.c b/x86/umip.c
index 79e288d..54f3884 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -159,7 +159,7 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		  "1:\n\t"
 		  : [ret] "=&a" (ret),
 #ifdef __x86_64__
-		    [sp0] "=m" (tss.rsp0),
+		    [sp0] "=m" (tss[0].rsp0),
 #else
 		    [sp0] "=m" (tss.esp0),
 #endif
-- 
2.27.0


