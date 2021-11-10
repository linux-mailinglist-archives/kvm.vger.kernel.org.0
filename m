Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB94A44CB3F
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhKJVXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbhKJVXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DA2C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:25 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x14-20020a627c0e000000b0049473df362dso2635137pfc.12
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WYON61i+BiQGdw3Qu+0D+mgUfA2363/6ERGQ1SkKSaU=;
        b=B1QT22zlv66BcGokcNmyTkG1UxwMBVfwK3oBntIZA8WlvvGI3yFbW+Inqa8uwMCZk+
         xIFSCXT1F44jXYbb/mH9bFARH8GfuDwF7k3w4VJkfdeQam5uHiYwwIf51/KPKsXbPfQ3
         LsfIdueIDlCP2qPG0M0Ro+/E0Fa5A4rImWcSruE6BSlgYXJ3iJNvt6zlCcHeV6X8hHlg
         HOQAdnyEzIhIfj2dLYW+FzfO/Wk7k9rZsB1sc+7SzIMHlosLWRnXyASsmho/BOy37FHs
         fktswS965XgFySEMsSjBoedFBRR1hzESaTRRqbvAMU0WrtiIw+RHxMLj9o6ZB+2mr3g7
         TLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WYON61i+BiQGdw3Qu+0D+mgUfA2363/6ERGQ1SkKSaU=;
        b=hwSGoU/z0f7OYv/iF56wduKVw/3H0AhvUCtG67BC9xxlP0JZ70ugZckS7C61hgyBZd
         XHrq/WpOb1046vfPApreRiNO14cI4sreq1vBB3zHzJgBXefo0kP2Ngo+pc5kUbqk/JMi
         jCbtZ3opcVN7H8jbbxKuLo6R/KEXov12ds90SVBpkHlgXlilvmMsTLQghPrV+zemgylr
         cqAV6ESL7CKuDSUTcjgnPBch7+eMlRHSXbnR8gKM3Xi80Cljq1h6xZ6V9N6Iv1S3qUif
         yNztwmlAeMKQad8Qam+M2/mmc6ZF6hZftGRh0jzwJ9hFMwQO926mBj40gQbzTGlO8VdG
         H2Qw==
X-Gm-Message-State: AOAM531GJMkzsT3REhcSOCKVHzp6K4G6kslfn8w1pOGtype3OT1GNXdd
        ajVwNHa0DEOicPtfyr4hq7XZhNbXBCfa0/sJoqye5d6vgzQH6OgmYgL22Xl2zvhGO4SXkD4uroK
        tQ95YUae/et4gU3NgzVJnFqvFRVspJOmhmxKov5ITccX75DtZ2ytcPiG2AhOi/afqWs7Y
X-Google-Smtp-Source: ABdhPJxY9y+aWuKKkkNVlSeWxPxQSp5iD8ktUkikIrsbxjQ/5A23l7yeQJIPqSgX/cNQGdw2elAK2kqhd+DLzTFU
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:e353:b0:142:d33:9acd with SMTP
 id p19-20020a170902e35300b001420d339acdmr2028661plc.78.1636579224656; Wed, 10
 Nov 2021 13:20:24 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:55 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-9-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 08/14] x86: Move 64-bit GDT and TSS to desc.c
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 49b87b2..2e77831 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -95,7 +95,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"mov %[rsp0], %%rsp\n\t"
 			:
 			"+a"(rax),
-			[rsp0]"=m"(tss.rsp0)
+			[rsp0]"=m"(tss[0].rsp0)
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
index 1936989..0a52342 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -159,7 +159,7 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 		  "1:\n\t"
 		  : [ret] "=&a" (ret),
 #ifdef __x86_64__
-		    [sp0] "=m" (tss.rsp0)
+		    [sp0] "=m" (tss[0].rsp0)
 #else
 		    [sp0] "=m" (tss.esp0)
 #endif
-- 
2.34.0.rc1.387.gb447b232ab-goog

