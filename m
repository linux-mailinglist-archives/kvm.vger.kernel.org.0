Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC14218A2
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhJDUv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhJDUvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1714EC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t11so744004plq.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fnoNH14Q0HbTfzGd4rffMzlYIvIU57Kx4gAb9gX9Tbc=;
        b=GeF7aqzjC1ZR1xtqOPnvNazHqxAD58qzI+M+dpiv5qVxAoF6RbtsJD6HNEHZuTx9/Z
         mucPKHz52+dzQC+Y6xCydzsPdYj7uE9zzQ0m2jKmkam4S307l9RC97/l7P6cuAdWfCJD
         ELNiBf1+VmlIDsB+O2IBKAOWHFt14WHWXHtTZSTgNCutVMUPbsUVT/fq2/sBbP6aysHG
         yrvtQW0ujY9ruP+Oyu9wL9g0xrwlSLSxaxrLgCrcOTiRCQf1lowIQ4ShuychgcUU6ZWp
         iXjXRGt1WvOy/EIsgrSv7KCBQ601M5M2RPzw6E7C0RXiOWSmXjkDC+H6r5omEyZ/kT1g
         TJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fnoNH14Q0HbTfzGd4rffMzlYIvIU57Kx4gAb9gX9Tbc=;
        b=yLsuAEooWTyJLaojCXFsE9M7zRNE1auHUshiCfuWnpr7umKA/wHqv13PCVZfIQUpOD
         7nBH4MAeNzYZ/2JNGSCwYf/YrzdEUa/ZbKxpbyLmW1Nd5JgXpRP+fBxh3KqCybq/cOJA
         weVucQkbljAd/jyF+6/Tg9VghMiVABhicCl7wLWZ9Z3nOK/xiUKQqKPSogrtjwvOeU1T
         h0+QXalgr12NOzn/pJCt9pIs9QuIDmdOmYCCnRCAYxoiEhl68Z/aeV9Zs/HSQ1S4gKOp
         tiVWFPR0NzLwkK4TUNtor5IW2xAlkeW8M63VPcZd6jJjgKrWJOZhI6mXnF1A+o9U36c4
         bRQQ==
X-Gm-Message-State: AOAM532s/kpnplfEm06hBfaaYYAa5cCtgYznzJ+QMyACj43XIBd+FdBT
        NGGN88acbTTlyHl9AkUQsCng8wg8WNyMNg==
X-Google-Smtp-Source: ABdhPJw/ABF6wn4QhiA0SBcr5YJ+Zs0jNJi2w5j8UoUbCSJlacucuLIsMG9xl0nENUX9EbKlAMJfpQ==
X-Received: by 2002:a17:90a:345:: with SMTP id 5mr38682686pjf.189.1633380575172;
        Mon, 04 Oct 2021 13:49:35 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:34 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 01/17] x86: Move IDT, GDT and TSS to desc.c
Date:   Mon,  4 Oct 2021 13:49:15 -0700
Message-Id: <20211004204931.1537823-2-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

Move the IDT, GDT and TSS data structures from x86/cstart64.S to
lib/x86/desc.c, so that the follow-up UEFI support commits can reuse
these definitions, without re-defining them in UEFI's boot up assembly
code.

In this commit, tss_descr is defined as a pointer, instead of an
assembly label. This type change leads to several updates in the
x86/vmx.c. Fortunately x86/vmx.c is only used in x86_64, so it is not
necessary to be compatible with i386's tss_descr type which is an
assembly label.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/asm/setup.h |  8 +++++
 lib/x86/desc.c      | 46 ++++++++++++++++++++++++++-
 lib/x86/desc.h      |  6 +++-
 lib/x86/setup.c     | 43 +++++++++++++++++++++++++
 x86/cstart64.S      | 77 ++-------------------------------------------
 x86/vmx.c           |  8 ++---
 6 files changed, 107 insertions(+), 81 deletions(-)
 create mode 100644 lib/x86/asm/setup.h

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
new file mode 100644
index 0000000..19ded12
--- /dev/null
+++ b/lib/x86/asm/setup.h
@@ -0,0 +1,8 @@
+#ifndef _X86_ASM_SETUP_H_
+#define _X86_ASM_SETUP_H_
+
+#ifdef __x86_64__
+unsigned long setup_tss(void);
+#endif /* __x86_64__ */
+
+#endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1..d1eb97b 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -3,6 +3,50 @@
 #include "processor.h"
 #include <setjmp.h>
 
+#ifdef __x86_64__
+#include "apic-defs.h"
+
+/* Boot-related data structures */
+
+/* IDT and IDT descriptor */
+idt_entry_t boot_idt[256] = {0};
+
+struct descriptor_table_ptr idt_descr = {
+	.limit = sizeof(boot_idt) - 1,
+	.base = (phys_addr_t)boot_idt,
+};
+
+/* GDT, TSS and descriptors */
+gdt_entry_t gdt64[GDT64_PRE_TSS_ENTRIES + MAX_TEST_CPUS * 2] = {
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x00 null */
+	{0xffff, 0, 0, 0x9b, 0xaf, 0}, /* 0x08 64-bit code segment */
+	{0xffff, 0, 0, 0x93, 0xcf, 0}, /* 0x10 32/64-bit data segment */
+	{0xffff, 0, 0, 0x1b, 0xaf, 0}, /* 0x18 64-bit code segment, not present */
+	{0xffff, 0, 0, 0x9b, 0xcf, 0}, /* 0x20 32-bit code segment */
+	{0xffff, 0, 0, 0x9b, 0x8f, 0}, /* 0x28 16-bit code segment */
+	{0xffff, 0, 0, 0x93, 0x8f, 0}, /* 0x30 16-bit data segment */
+	{0xffff, 0, 0, 0xfb, 0xcf, 0}, /* 0x38 32-bit code segment (user) */
+	{0xffff, 0, 0, 0xf3, 0xcf, 0}, /* 0x40 32/64-bit data segment (user) */
+	{0xffff, 0, 0, 0xfb, 0xaf, 0}, /* 0x48 64-bit code segment (user) */
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x50 null */
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x58 null */
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x60 null */
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x68 null */
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x70 null */
+	{     0, 0, 0, 0x00, 0x00, 0}, /* 0x78 null */
+};
+
+struct descriptor_table_ptr gdt64_desc = {
+	.limit = sizeof(gdt64) - 1,
+	.base = (phys_addr_t)gdt64,
+};
+
+struct descriptor_table_ptr *tss_descr =
+	(struct descriptor_table_ptr *)&gdt64[GDT64_PRE_TSS_ENTRIES];
+
+tss64_t tss[MAX_TEST_CPUS] = {0};
+#endif
+
 #ifndef __x86_64__
 __attribute__((regparm(1)))
 #endif
@@ -374,7 +418,7 @@ void set_intr_alt_stack(int e, void *addr)
 
 void setup_alt_stack(void)
 {
-	tss.ist1 = (u64)intr_alt_stack + 4096;
+	tss[0].ist1 = (u64)intr_alt_stack + 4096;
 }
 #endif
 
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38..c7ee881 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -208,7 +208,11 @@ void set_idt_task_gate(int vec, u16 sel);
 void set_intr_task_gate(int vec, void *fn);
 void setup_tss32(void);
 #else
-extern tss64_t tss;
+extern tss64_t tss[];
+/* In gdt64, there are 16 entries before TSS entries */
+#define GDT64_PRE_TSS_ENTRIES (16)
+#define GDT64_TSS_OFFSET (GDT64_PRE_TSS_ENTRIES)
+extern gdt_entry_t gdt64[];
 #endif
 
 unsigned exception_vector(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7befe09..8c73156 100644
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
 
@@ -97,6 +102,44 @@ void find_highmem(void)
 		phys_alloc_init(best_start, best_end - best_start);
 	}
 }
+
+extern phys_addr_t ring0stacktop;
+
+/* Setup TSS for the current processor, and return TSS offset within gdt64 */
+unsigned long setup_tss(void)
+{
+	u32 id;
+	gdt_entry_t *gdt_entry_lo, *gdt_entry_hi;
+	tss64_t *tss_entry;
+	phys_addr_t tss_entry_addr;
+
+	id = apic_id();
+
+	/* Runtime address of current TSS */
+	tss_entry = &tss[id];
+	tss_entry_addr = (phys_addr_t)tss_entry;
+
+	/* Update TSS */
+	memset((void *)tss_entry, 0, sizeof(tss64_t));
+	tss_entry->rsp0 = (u64)((u8*)&ring0stacktop - id * 4096);
+
+	/* Each TSS descriptor takes up 2 GDT entries */
+	gdt_entry_lo = &gdt64[GDT64_PRE_TSS_ENTRIES + id * 2 + 0];
+	gdt_entry_hi = &gdt64[GDT64_PRE_TSS_ENTRIES + id * 2 + 1];
+
+	/* Update TSS descriptors */
+	memset((void *)gdt_entry_lo, 0, sizeof(gdt_entry_t));
+	memset((void *)gdt_entry_hi, 0, sizeof(gdt_entry_t));
+	gdt_entry_lo->access      = 0x89;
+	gdt_entry_lo->limit_low   = 0xffff;
+	gdt_entry_lo->base_low    = (u16)(tss_entry_addr & 0xffff);
+	gdt_entry_lo->base_middle =  (u8)((tss_entry_addr >> 16) & 0xff);
+	gdt_entry_lo->base_high   =  (u8)((tss_entry_addr >> 24) & 0xff);
+	gdt_entry_hi->limit_low   = (u16)((tss_entry_addr >> 32) & 0xffff);
+	gdt_entry_hi->base_low    = (u16)((tss_entry_addr >> 48) & 0xffff);
+
+	return (GDT64_PRE_TSS_ENTRIES + id * 2) * sizeof(gdt_entry_t);
+}
 #endif
 
 void setup_multiboot(struct mbi_bootinfo *bi)
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..57383c1 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,11 +1,7 @@
 
 #include "apic-defs.h"
 
-.globl boot_idt
-
-.globl idt_descr
-.globl tss_descr
-.globl gdt64_desc
+.globl ring0stacktop
 .globl online_cpus
 .globl cpu_online_count
 
@@ -51,56 +47,6 @@ ptl5:
 
 .align 4096
 
-boot_idt:
-	.rept 256
-	.quad 0
-	.quad 0
-	.endr
-end_boot_idt:
-
-gdt64_desc:
-	.word gdt64_end - gdt64 - 1
-	.quad gdt64
-
-gdt64:
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
-gdt64_end:
-
-i = 0
-.globl tss
-tss:
-	.rept max_cpus
-	.long 0
-	.quad ring0stacktop - i * 4096
-	.quad 0, 0
-	.quad 0, 0, 0, 0, 0, 0, 0, 0
-	.long 0, 0, 0
-i = i + 1
-	.endr
-tss_end:
-
 mb_boot_info:	.quad 0
 
 pt_root:	.quad ptl4
@@ -291,31 +237,12 @@ setup_5level_page_table:
 lvl5:
 	retq
 
-idt_descr:
-	.word end_boot_idt - boot_idt - 1
-	.quad boot_idt
-
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
 load_tss:
 	lidtq idt_descr
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
-	lea tss_descr-gdt64(%rbx), %rax
+	call setup_tss
 	ltr %ax
 	ret
 
diff --git a/x86/vmx.c b/x86/vmx.c
index f0b853a..37aff12 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -75,7 +75,7 @@ union vmx_ept_vpid  ept_vpid;
 
 extern struct descriptor_table_ptr gdt64_desc;
 extern struct descriptor_table_ptr idt_descr;
-extern struct descriptor_table_ptr tss_descr;
+extern struct descriptor_table_ptr *tss_descr;
 extern void *vmx_return;
 extern void *entry_sysenter;
 extern void *guest_entry;
@@ -1276,7 +1276,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_SEL_FS, KERNEL_DS);
 	vmcs_write(HOST_SEL_GS, KERNEL_DS);
 	vmcs_write(HOST_SEL_TR, TSS_MAIN);
-	vmcs_write(HOST_BASE_TR, tss_descr.base);
+	vmcs_write(HOST_BASE_TR, tss_descr->base);
 	vmcs_write(HOST_BASE_GDTR, gdt64_desc.base);
 	vmcs_write(HOST_BASE_IDTR, idt_descr.base);
 	vmcs_write(HOST_BASE_FS, 0);
@@ -1332,7 +1332,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_BASE_DS, 0);
 	vmcs_write(GUEST_BASE_FS, 0);
 	vmcs_write(GUEST_BASE_GS, 0);
-	vmcs_write(GUEST_BASE_TR, tss_descr.base);
+	vmcs_write(GUEST_BASE_TR, tss_descr->base);
 	vmcs_write(GUEST_BASE_LDTR, 0);
 
 	vmcs_write(GUEST_LIMIT_CS, 0xFFFFFFFF);
@@ -1342,7 +1342,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_LIMIT_FS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_GS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_LDTR, 0xffff);
-	vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
+	vmcs_write(GUEST_LIMIT_TR, tss_descr->limit);
 
 	vmcs_write(GUEST_AR_CS, 0xa09b);
 	vmcs_write(GUEST_AR_DS, 0xc093);
-- 
2.33.0

