Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A563EF689
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhHRAJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbhHRAJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD10C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n200-20020a25d6d10000b02905935ac4154aso903384ybg.23
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TtYaIM086ARiuj4puOOCeL+Cd/MLJ6i6m0oSG6EXPfI=;
        b=SiqEDdyy08adO5gZ9xXM04mgyFwkHByPed3LvhsL1T6lnuXPNKhMe0kVqm5m4p30dn
         E0K+iyPdGXypePQK6f2HyrRaF2rQAejiDSL3+tcWMbBlhxxrZb4YavAOXnJTay4w+DGn
         Hjkkz81hOeV5Mfp/ELoQvQZLyCf/V17AWGXhAtQXA8dG/xuwdK37pF6FO8vPplTm3mU6
         klug9mqzcvpCIhbIoF2uEGLAaWkhmbPH1Hmfvz88PQ32BD78pdT9MtU6J3Dz0/vsZEQ7
         +bPQH8+GPAHDJgjufkhArpJH77UKqCggq6uVmzatJfQ2szNDx+fpTPxdUHqShksCCOsO
         Np5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TtYaIM086ARiuj4puOOCeL+Cd/MLJ6i6m0oSG6EXPfI=;
        b=N9//g+NIaKR0y1enyurb/+kSoNHaA5FrI6VTnLqhQGtBDF2uiWnLowjoZV8qrK5Dqz
         aIb7f+zfEbTaVom2jxuNhxKD1VkGDrPD98Dzo//R8d4sIW8QZeScWkvPiP0wHpTH+h5I
         4B7byu29JVSYLpkv2M6s9l3qhOEYF/QUaCPat5OI/YkdWj1N4qW6RsdM8QCSCmGVo/qz
         s5Bf1mItkccZeCAgPzQOTdx/FFrUVYJh7lXz6BX2JvVV24HOM3LHG8FpX+S08wmr1XwC
         SN1lUA8YmCdh0fX8Cy4SVMmsBy1+BtZStFODTq6wIw/WT6vvuxdh0vAK+euIfQd7pftZ
         hExA==
X-Gm-Message-State: AOAM533e15Kpnypqj+PQpRsZ2WVR8d29WM3mLuDfLbWv7k3EoDVDal4u
        +khJKrd6U3+/uI63lfL53orOMd+j70IDvRWoddc1VXC7lD0tEiba61dwCZNanKefS8WSEFgBuVW
        aVBx7Z0bN4IlgmS/IUEVyZOQoFEwkyBNRVI1SBYWiQAwO1Rwg5Iwi7ApGT2POXIOgk4cF
X-Google-Smtp-Source: ABdhPJxGTHCGjf7a+OfF6en8JX7wnzzY/tEw+4jXah+DFs1Xgf1mY+UQIVwKOZJz/W8QT9X8WAbDthpYWoq4y0ZV
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:44c:: with SMTP id
 73mr7931986ybe.435.1629245363258; Tue, 17 Aug 2021 17:09:23 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:54 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-6-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 05/16] x86 UEFI: Load GDT and TSS after UEFI boot up
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
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

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/setup.c      | 44 ++++++++++++++++++++++
 x86/efi/efistart64.S | 88 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 9548c5b..51be241 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -124,10 +124,54 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
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
index e8d5ad6..cc993e5 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -1,7 +1,23 @@
 /* Startup code and pre-defined data structures */
 
+#include "apic-defs.h"
+#include "asm-generic/page.h"
+
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
 
@@ -16,6 +32,48 @@ idt_descr:
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
@@ -30,3 +88,33 @@ load_idt:
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
+	/* Update the code segment by putting it on the stack before the return
+	 * address, then doing a far return: this will use the new code segment
+	 * along with the address.
+	 */
+	popq %rdi
+	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
+	pushq %rdi
+	lretq
-- 
2.33.0.rc1.237.g0d66db33f3-goog

