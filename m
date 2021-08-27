Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D653F92B2
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbhH0DN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:24 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26F9C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q23-20020a6562570000b029023cbfb4fd73so2584921pgv.14
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gka1dI7P9lBEiuUdPc0CEpOt/++HLm6/PwfPOTzYM3w=;
        b=tlfMhVaYZoAVW30vTZlQaIKPt+70XCyCGQNXMcfNgYYwZn0fCX/6ZzjK8gI99uhw17
         gexcVZ2YdM+f+5+zAy9a2+Blxne8AikeLCZoADtR34opQ/7b/8+KW4tTdj75b2xGlXF7
         1/SLaF89pAQn1188fZxV3IHy7rDucxkg1o+oeKICpwbt4cd7YwkuYFTWFiqPkETF+q9i
         XoFsVBmQb/0cfCIWolwAQAjJKRQ1w0mms7idksc6YQs6awqRQw4UP5y6FFxlJPsJ2KRd
         wzmyHGEkWmxZst70CUa3dZRbD8p9uSKniQQmgC3m8bP3uOn4WyLmp1lTvh/aIdwJCxoB
         /oEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gka1dI7P9lBEiuUdPc0CEpOt/++HLm6/PwfPOTzYM3w=;
        b=YgKiUv7ByFUIpUoq04LtO9UpI1zk+6zOwpZmRybXLZx/FthxPbielzLT1UJyndceFC
         SLLjvPATK8JtkWfo2JH8hPog0Ek0AfgHitcsdwLvDmnoaOeIuCz4MwDFIJgQm0kx0lv9
         MitwQERI0/ITKuZ+vddHkQgyjfbn7sn0Bfcv+HitqYg06MuJpFtdT2MPusp9M1pSNQo2
         vYIiWjxRZ5HxJXXERI1gmd+a7U/shfcJrPOIWRekq/DTTdDKj7pJl3kbrcBdZVuYqnwk
         P7/w3nCbt3blXldtqkS8fX68hlr+E60YvKi+Kh01AnYOAk8unHVgAOpOFvlipZdGVOs5
         NDYw==
X-Gm-Message-State: AOAM532qAbPAbXa+dbVocKB55SAWQ9uhG6+8DH2Pmma0n7ag18G9r0n4
        gEMaJbgaP6ZGgQZKaLS19Ba8V4etqDYtuhZPZI+n7RH5mM22opbv9LUl9/w2umQ/nr215woukqC
        VNJf6vzvdmUh8ihE9s7CGEP082WjsDDCgHNM1Y5D0P+NG/gQ3kLJbWGC6shfiR1dKpzp3
X-Google-Smtp-Source: ABdhPJxVz0IYCgfoc97yWjYgpmf9Tk101wMzGjAPDmw/Z8jaDEIPkPvtcrtK1+5nySDWw1J3kY+Oe5xqo5ePv3uE
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a17:90a:2e0e:: with SMTP id
 q14mr20437134pjd.16.1630033955274; Thu, 26 Aug 2021 20:12:35 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:11 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-7-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 06/17] x86 UEFI: Load GDT and TSS after UEFI
 boot up
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Global Descriptor Table (GDT) defines x86 memory areas, e.g. memory area
for data or code. UEFI has a different GDT compared to KVM-Unit-Tests,
e.g., in UEFI, 3rd GDT entry defines a code segment, while in
KVM-Unit-Tests, 3rd GDT entry is data segment.

Without loading KVM-Unit-Tests GDT, the UEFI GDT is used and is
incompatible with KVM-Unit-Tests. This causes QEMU to silently crash
when a test case changes segments.

This commit fixes this issue by loading KVM-Unit-Tests GDT to replace
UEFI GDT. And since Task State Segment (TSS) is tightly coupled with
GDT, this commit also loads TSS on boot-up.

The GDT and TSS loading function is originally written in assembly code,
see cstart64.S load_tss function. This commit provides a similar C
function setup_gdt_tss() which is more readable and easier to modify.

In this commit, x86/debug.c can run in UEFI and pass all sub-tests.

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/setup.c      | 44 ++++++++++++++++++++++
 x86/efi/efistart64.S | 88 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 5e369ea..0a065fe 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -125,10 +125,54 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 /* From x86/efi/efistart64.S */
 extern void load_idt(void);
+extern void load_gdt_tss(size_t tss_offset);
+extern phys_addr_t tss_descr;
+extern phys_addr_t ring0stacktop;
+extern gdt_entry_t gdt64[];
+extern size_t ring0stacksize;
+
+static void setup_gdt_tss(void)
+{
+	gdt_entry_t *tss_lo, *tss_hi;
+	tss64_t *curr_tss;
+	phys_addr_t curr_tss_addr;
+	u32 id;
+	size_t tss_offset;
+	size_t pre_tss_entries;
+
+	/* Get APIC ID, see also x86/cstart64.S:load_tss */
+	id = apic_id();
+
+	/* Get number of GDT entries before TSS-related GDT entry */
+	pre_tss_entries = (size_t)((u8 *)&(tss_descr) - (u8 *)gdt64) / sizeof(gdt_entry_t);
+
+	/* Each TSS descriptor takes up 2 GDT entries */
+	tss_offset = (pre_tss_entries + id * 2) * sizeof(gdt_entry_t);
+	tss_lo = &(gdt64[pre_tss_entries + id * 2 + 0]);
+	tss_hi = &(gdt64[pre_tss_entries + id * 2 + 1]);
+
+	/* Runtime address of current TSS */
+	curr_tss_addr = (((phys_addr_t)&tss) + (phys_addr_t)(id * sizeof(tss64_t)));
+
+	/* Use runtime address for ring0stacktop, see also x86/cstart64.S:tss */
+	curr_tss = (tss64_t *)curr_tss_addr;
+	curr_tss->rsp0 = (u64)((u8*)&ring0stacktop - id * ring0stacksize);
+
+	/* Update TSS descriptors */
+	tss_lo->limit_low = sizeof(tss64_t);
+	tss_lo->base_low = (u16)(curr_tss_addr & 0xffff);
+	tss_lo->base_middle = (u8)((curr_tss_addr >> 16) & 0xff);
+	tss_lo->base_high = (u8)((curr_tss_addr >> 24) & 0xff);
+	tss_hi->limit_low = (u16)((curr_tss_addr >> 32) & 0xffff);
+	tss_hi->base_low = (u16)((curr_tss_addr >> 48) & 0xffff);
+
+	load_gdt_tss(tss_offset);
+}
 
 void setup_efi(void)
 {
 	reset_apic();
+	setup_gdt_tss();
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index ec607da..a14bd46 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -1,9 +1,24 @@
 /* Startup code and pre-defined data structures */
 
+#include "apic-defs.h"
+#include "asm-generic/page.h"
 #include "crt0-efi-x86_64.S"
 
 .globl boot_idt
 .globl idt_descr
+.globl tss_descr
+.globl gdt64_desc
+.globl ring0stacksize
+
+max_cpus = MAX_TEST_CPUS
+ring0stacksize = PAGE_SIZE
+
+.bss
+
+.globl ring0stacktop
+	. = . + ring0stacksize * max_cpus
+	.align 16
+ring0stacktop:
 
 .data
 
@@ -18,6 +33,48 @@ idt_descr:
 	.word end_boot_idt - boot_idt - 1
 	.quad 0 /* To be filled with runtime addr of boot_idt(%rip) */
 
+gdt64_desc:
+	.word gdt64_end - gdt64 - 1
+	.quad 0 /* To be filled with runtime addr of gdt64(%rip) */
+
+.globl gdt64
+gdt64:
+	.quad 0
+	.quad 0x00af9b000000ffff /* 64-bit code segment */
+	.quad 0x00cf93000000ffff /* 32/64-bit data segment */
+	.quad 0x00af1b000000ffff /* 64-bit code segment, not present */
+	.quad 0x00cf9b000000ffff /* 32-bit code segment */
+	.quad 0x008f9b000000FFFF /* 16-bit code segment */
+	.quad 0x008f93000000FFFF /* 16-bit data segment */
+	.quad 0x00cffb000000ffff /* 32-bit code segment (user) */
+	.quad 0x00cff3000000ffff /* 32/64-bit data segment (user) */
+	.quad 0x00affb000000ffff /* 64-bit code segment (user) */
+
+	.quad 0			 /* 6 spare selectors */
+	.quad 0
+	.quad 0
+	.quad 0
+	.quad 0
+	.quad 0
+
+tss_descr:
+	.rept max_cpus
+	.quad 0x000089000000ffff /* 64-bit avail tss */
+	.quad 0                  /* tss high addr */
+	.endr
+gdt64_end:
+
+.globl tss
+tss:
+	.rept max_cpus
+	.long 0
+	.quad 0
+	.quad 0, 0
+	.quad 0, 0, 0, 0, 0, 0, 0, 0
+	.long 0, 0, 0
+	.endr
+tss_end:
+
 .section .init
 .code64
 .text
@@ -32,3 +89,34 @@ load_idt:
 	lidtq idt_descr(%rip)
 
 	retq
+
+.globl load_gdt_tss
+load_gdt_tss:
+	/* Set GDT runtime address */
+	lea gdt64(%rip), %rax
+	mov %rax, gdt64_desc+2(%rip)
+
+	/* Load GDT */
+	lgdt gdt64_desc(%rip)
+
+	/* Load TSS */
+	mov %rdi, %rax
+	ltr %ax
+
+	/* Update data segments */
+	mov $0x10, %ax /* 3rd entry in gdt64: 32/64-bit data segment */
+	mov %ax, %ds
+	mov %ax, %es
+	mov %ax, %fs
+	mov %ax, %gs
+	mov %ax, %ss
+
+	/*
+	 * Update the code segment by putting it on the stack before the return
+	 * address, then doing a far return: this will use the new code segment
+	 * along with the address.
+	 */
+	popq %rdi
+	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
+	pushq %rdi
+	lretq
-- 
2.33.0.259.gc128427fd7-goog

