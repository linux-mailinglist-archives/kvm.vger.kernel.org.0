Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC144CB40
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhKJVXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbhKJVXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:15 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFAFC061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:27 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f7-20020a63f107000000b002db96febb74so2141414pgi.7
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1WpvXB0uniUiD9TX/k3pJ/CV0aW3BeA8lnHLDvkSFfo=;
        b=b99CzGQuK3YlEBaWHN1RVgVuX+u9EG/rFuZxVviqaSWUqGBJoeeBp9vLJrzj7+D5EX
         plnP4aRK2p5LPYnziOy4G4AxpatMKR2Ch5zVVL21KQKR32Qesu6ecZV9IX5Sb6Pp6j/E
         p8wDPG8xpfEj0pVYGR4QK0LbSxbbFKygsSd/yV29YCnFMkvDJGsXE5Z8S677GvMg2TRn
         gRCham92vZ7EHitDya/l3V+qkXgrjp/kLHHsgg0EyKX1y4QPuzejZatEtB0mLxKyrtF+
         PKXerGuIv/reLYF421vg6xCLJ6A5a1Kxz/V/yrq9H7IOJlvMhw8bfKmUtRUwqSBCv6VS
         l3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1WpvXB0uniUiD9TX/k3pJ/CV0aW3BeA8lnHLDvkSFfo=;
        b=l30hij/b+10+oJd9+MGshdfBoYgdpahWaxq21BIR9RFC7Q3syDadqsGI6kfPW6faUy
         jWbjZ1KflVraB3f3gh4y66l83wwt1CYnvzG2J8gkxQa5vjgaSqP+glsysYpCNniIJRlK
         nhJGzC8GOwe7q53IAg+Lfs9F2DYFuTTcKmtMJe5ci3x46bqFLcAYeWhb3hc0mpS2dX91
         P/cKd4p2fSeD05wWKgm+wUfFIEHLgykotdn7iV61LRjoRQxaA8vZHD1SrjUmKjN65c27
         ItXxXKAWIfUCyvOK60dhyDgzOogC0cI/Xlck2dXx3V3khWsfsuvhfRvh8CkQaAlRvCBC
         qVDQ==
X-Gm-Message-State: AOAM531hxDYXB14JXVi+O8aiKeNhRLxEczglQn86e1SZ91qUach2Nt6Z
        cxa1srSEb7BcMUC2ixKqlYVHHobL1WFO1GsNG7J6FIsSBmuezUI4uNpPa9ncSD6FsOrpePscmow
        Ycd4mf448uehmn64lD5q8svVKA384yu3DXCPMYsV/Y6Xf/zKoh+W6g8aqrJdnY9czOHVH
X-Google-Smtp-Source: ABdhPJxHdiVbS0IRrjTL26OOUuHRwy6eLassXrxksjwIfHEduhCIHNEfve42DMdkkxQFLoQdL1FMjwW0FHarJkIk
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:aa7:8081:0:b0:49f:adfd:4be4 with SMTP
 id v1-20020aa78081000000b0049fadfd4be4mr1943572pff.85.1636579227097; Wed, 10
 Nov 2021 13:20:27 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:56 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-10-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 09/14] x86: Move 32-bit GDT and TSS to desc.c
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the GDT and TSS data structures from x86/cstart.S to
lib/x86/desc.c, for consistency with the 64-bit version.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/asm/setup.h |  2 +-
 lib/x86/desc.c      | 22 ++++++++--
 lib/x86/desc.h      |  2 +-
 lib/x86/setup.c     | 26 +++++++++++-
 x86/cstart.S        | 98 +++++++--------------------------------------
 x86/cstart64.S      |  1 +
 x86/smap.c          |  2 +-
 x86/taskswitch.c    |  2 +-
 x86/umip.c          |  2 +-
 9 files changed, 63 insertions(+), 94 deletions(-)

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index e3c3bfb..4310132 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -1,6 +1,6 @@
 #ifndef _X86_ASM_SETUP_H_
 #define _X86_ASM_SETUP_H_
 
-unsigned long setup_tss(void);
+unsigned long setup_tss(u8 *stacktop);
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index c185c01..16b7256 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -14,8 +14,22 @@ struct descriptor_table_ptr idt_descr = {
 	.base = (unsigned long)boot_idt,
 };
 
-#ifdef __x86_64__
+#ifndef __x86_64__
 /* GDT, TSS and descriptors */
+gdt_entry_t gdt[TSS_MAIN / 8 + MAX_TEST_CPUS * 2] = {
+	{     0, 0, 0, .type_limit_flags = 0x0000}, /* 0x00 null */
+	{0xffff, 0, 0, .type_limit_flags = 0xcf9b}, /* flat 32-bit code segment */
+	{0xffff, 0, 0, .type_limit_flags = 0xcf93}, /* flat 32-bit data segment */
+	{0xffff, 0, 0, .type_limit_flags = 0xcf1b}, /* flat 32-bit code segment, not present */
+	{     0, 0, 0, .type_limit_flags = 0x0000}, /* TSS for task gates */
+	{0xffff, 0, 0, .type_limit_flags = 0x8f9b}, /* 16-bit code segment */
+	{0xffff, 0, 0, .type_limit_flags = 0x8f93}, /* 16-bit data segment */
+	{0xffff, 0, 0, .type_limit_flags = 0xcffb}, /* 32-bit code segment (user) */
+	{0xffff, 0, 0, .type_limit_flags = 0xcff3}, /* 32-bit data segment (user) */
+};
+
+tss32_t tss[MAX_TEST_CPUS] = {0};
+#else
 gdt_entry_t gdt[TSS_MAIN / 8 + MAX_TEST_CPUS * 2] = {
 	{     0, 0, 0, .type_limit_flags = 0x0000}, /* 0x00 null */
 	{0xffff, 0, 0, .type_limit_flags = 0xaf9b}, /* 0x08 64-bit code segment */
@@ -30,12 +44,12 @@ gdt_entry_t gdt[TSS_MAIN / 8 + MAX_TEST_CPUS * 2] = {
 };
 
 tss64_t tss[MAX_TEST_CPUS] = {0};
+#endif
 
 struct descriptor_table_ptr gdt_descr = {
 	.limit = sizeof(gdt) - 1,
 	.base = (unsigned long)gdt,
 };
-#endif
 
 #ifndef __x86_64__
 __attribute__((regparm(1)))
@@ -365,7 +379,7 @@ void setup_tss32(void)
 {
 	u16 desc_size = sizeof(tss32_t);
 
-	tss.cr3 = read_cr3();
+	tss[0].cr3 = read_cr3();
 	tss_intr.cr3 = read_cr3();
 	tss_intr.ss0 = tss_intr.ss1 = tss_intr.ss2 = 0x10;
 	tss_intr.esp = tss_intr.esp0 = tss_intr.esp1 = tss_intr.esp2 =
@@ -401,7 +415,7 @@ void print_current_tss_info(void)
 		printf("Unknown TSS %x\n", tr);
 	else
 		printf("TR=%x (%s) Main TSS back link %x. Intr TSS back link %x\n",
-		       tr, tr ? "interrupt" : "main", tss.prev, tss_intr.prev);
+		       tr, tr ? "interrupt" : "main", tss[0].prev, tss_intr.prev);
 }
 #else
 void set_intr_alt_stack(int e, void *addr)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index ddfae04..b65539e 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -197,7 +197,7 @@ struct system_desc64 {
 extern idt_entry_t boot_idt[256];
 
 #ifndef __x86_64__
-extern tss32_t tss;
+extern tss32_t tss[];
 extern tss32_t tss_intr;
 void set_gdt_task_gate(u16 tss_sel, u16 sel);
 void set_idt_task_gate(int vec, u16 sel);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index ec005b5..9c4393f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -104,7 +104,7 @@ void find_highmem(void)
 }
 
 /* Setup TSS for the current processor, and return TSS offset within GDT */
-unsigned long setup_tss(void)
+unsigned long setup_tss(u8 *stacktop)
 {
 	u32 id;
 	tss64_t *tss_entry;
@@ -122,6 +122,30 @@ unsigned long setup_tss(void)
 
 	return TSS_MAIN + id * 16;
 }
+#else
+/* Setup TSS for the current processor, and return TSS offset within GDT */
+unsigned long setup_tss(u8 *stacktop)
+{
+	u32 id;
+	tss32_t *tss_entry;
+
+	id = apic_id();
+
+	/* Runtime address of current TSS */
+	tss_entry = &tss[id];
+
+	/* Update TSS */
+	memset((void *)tss_entry, 0, sizeof(tss32_t));
+	tss_entry->ss0 = KERNEL_DS;
+
+	/* Update descriptors for TSS and percpu data segment.  */
+	set_gdt_entry(TSS_MAIN + id * 8,
+		      (unsigned long)tss_entry, 0xffff, 0x89, 0);
+	set_gdt_entry(TSS_MAIN + MAX_TEST_CPUS * 8 + id * 8,
+		      (unsigned long)stacktop - 4096, 0xfffff, 0x93, 0xc0);
+
+	return TSS_MAIN + id * 8;
+}
 #endif
 
 void setup_multiboot(struct mbi_bootinfo *bi)
diff --git a/x86/cstart.S b/x86/cstart.S
index e9100a4..2c0eec7 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -23,50 +23,6 @@ i = 0
         i = i + 1
         .endr
 
-.globl gdt
-gdt:
-	.quad 0
-	.quad 0x00cf9b000000ffff // flat 32-bit code segment
-	.quad 0x00cf93000000ffff // flat 32-bit data segment
-	.quad 0x00cf1b000000ffff // flat 32-bit code segment, not present
-	.quad 0                  // TSS for task gates
-	.quad 0x008f9b000000FFFF // 16-bit code segment
-	.quad 0x008f93000000FFFF // 16-bit data segment
-	.quad 0x00cffb000000ffff // 32-bit code segment (user)
-	.quad 0x00cff3000000ffff // 32-bit data segment (user)
-	.quad 0                  // unused
-
-	.quad 0			 // 6 spare selectors
-	.quad 0
-	.quad 0
-	.quad 0
-	.quad 0
-	.quad 0
-
-tss_descr:
-        .rept max_cpus
-        .quad 0x000089000000ffff // 32-bit avail tss
-        .endr
-percpu_descr:
-        .rept max_cpus
-        .quad 0x00cf93000000ffff // 32-bit data segment for perCPU area
-        .endr
-gdt_end:
-
-i = 0
-.globl tss
-tss:
-        .rept max_cpus
-        .long 0
-        .long 0
-        .long 16
-        .quad 0, 0
-        .quad 0, 0, 0, 0, 0, 0, 0, 0
-        .long 0, 0, 0
-        i = i + 1
-        .endr
-tss_end:
-
 .section .init
 
 .code32
@@ -78,21 +34,14 @@ mb_flags = 0x0
 	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
 mb_cmdline = 16
 
-.macro setup_percpu_area
-	lea -4096(%esp), %eax
-
-	/* fill GS_BASE in the GDT, do not clobber %ebx (multiboot info) */
-	mov (APIC_DEFAULT_PHYS_BASE + APIC_ID), %ecx
-	shr $24, %ecx
-	mov %ax, percpu_descr+2(,%ecx,8)
-
-	shr $16, %eax
-	mov %al, percpu_descr+4(,%ecx,8)
-	mov %ah, percpu_descr+7(,%ecx,8)
-
-	lea percpu_descr-gdt(,%ecx,8), %eax
+.macro setup_tr_and_percpu
+	lidt idt_descr
+	push %esp
+	call setup_tss
+	addl $4, %esp
+	ltr %ax
+	add $(max_cpus * 8), %ax
 	mov %ax, %gs
-
 .endm
 
 .macro setup_segments
@@ -109,7 +58,6 @@ start:
         lgdtl gdt_descr
         setup_segments
         mov $stacktop, %esp
-        setup_percpu_area
 
         push %ebx
         call setup_multiboot
@@ -147,11 +95,10 @@ ap_start32:
 	setup_segments
 	mov $-4096, %esp
 	lock xaddl %esp, smp_stacktop
-	setup_percpu_area
+	setup_tr_and_percpu
 	call prepare_32
 	call reset_apic
 	call save_id
-	call load_tss
 	call enable_apic
 	call enable_x2apic
 	sti
@@ -162,9 +109,9 @@ ap_start32:
 	jmp 1b
 
 start32:
+	setup_tr_and_percpu
 	call reset_apic
 	call save_id
-	call load_tss
 	call mask_pic_interrupts
 	call enable_apic
 	call ap_init
@@ -177,26 +124,9 @@ start32:
 	push %eax
 	call exit
 
-load_tss:
-	lidt idt_descr
-	mov $16, %eax
-	mov %ax, %ss
-	mov (APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-	shr $24, %eax
-	mov %eax, %ebx
-	mov $((tss_end - tss) / max_cpus), %edx
-	imul %edx
-	add $tss, %eax
-	mov %ax, tss_descr+2(,%ebx,8)
-	shr $16, %eax
-	mov %al, tss_descr+4(,%ebx,8)
-	mov %ah, tss_descr+7(,%ebx,8)
-	lea tss_descr-gdt(,%ebx,8), %eax
-	ltr %ax
-	ret
-
 ap_init:
 	cld
+	sgdtl ap_gdt_descr // must be close to sipi_entry for real mode access to work
 	lea sipi_entry, %esi
 	xor %edi, %edi
 	mov $(sipi_end - sipi_entry), %ecx
@@ -220,11 +150,11 @@ sipi_entry:
 	mov %cr0, %eax
 	or $1, %eax
 	mov %eax, %cr0
-	lgdtl gdt_descr - sipi_entry
+	lgdtl ap_gdt_descr - sipi_entry
 	ljmpl $8, $ap_start32
 
-gdt_descr:
-	.word gdt_end - gdt - 1
-	.long gdt
+ap_gdt_descr:
+	.word 0
+	.long 0
 
 sipi_end:
diff --git a/x86/cstart64.S b/x86/cstart64.S
index c6daa34..ddb83a0 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -68,6 +68,7 @@ MSR_GS_BASE = 0xc0000101
 
 .macro load_tss
 	lidtq idt_descr
+	movq %rsp, %rdi
 	call setup_tss
 	ltr %ax
 .endm
diff --git a/x86/smap.c b/x86/smap.c
index ac2c8d5..c6ddf38 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -20,7 +20,7 @@ void do_pf_tss(unsigned long error_code)
 	save = test;
 
 #ifndef __x86_64__
-	tss.eflags |= X86_EFLAGS_AC;
+	tss[0].eflags |= X86_EFLAGS_AC;
 #endif
 }
 
diff --git a/x86/taskswitch.c b/x86/taskswitch.c
index 1d6e6e2..0d31149 100644
--- a/x86/taskswitch.c
+++ b/x86/taskswitch.c
@@ -19,7 +19,7 @@ fault_handler(unsigned long error_code)
 	print_current_tss_info();
 	printf("error code %lx\n", error_code);
 
-	tss.eip += 2;
+	tss[0].eip += 2;
 
 	gdt[TSS_MAIN / 8].type &= ~DESC_BUSY;
 
diff --git a/x86/umip.c b/x86/umip.c
index 0a52342..af8db59 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -161,7 +161,7 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 #ifdef __x86_64__
 		    [sp0] "=m" (tss[0].rsp0)
 #else
-		    [sp0] "=m" (tss.esp0)
+		    [sp0] "=m" (tss[0].esp0)
 #endif
 		  : [user_ds] "i" (USER_DS),
 		    [user_cs] "i" (USER_CS),
-- 
2.34.0.rc1.387.gb447b232ab-goog

