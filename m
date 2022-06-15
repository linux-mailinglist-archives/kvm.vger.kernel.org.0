Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBA554D555
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349879AbiFOXaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349436AbiFOXaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:09 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ACC13F73
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id k71-20020a63844a000000b00408e66049e0so560579pgd.16
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iBNOcXzOzdiL6TlX0DnZI//Y/yZM2ilodfIit+PGvCc=;
        b=QHNEtXsRI/hKZMPobPTxzltbKmsr88S67dpMpjMi+JyQbuozp0boJZOGQbIlxP8Xeb
         sz0QWPG42vbz1gIa53MsGd7RGEzJebk7Y3wErf4danB/f37PgH7clMKTh1oMHZkagoy8
         0W2+KlVyrku1o4RyVEOlhjSJx14LJCWsMAR7OFCnuunvw0eyvXtktE4zXkfnDStWwCEq
         PLDjpcIgJ6njg1EwSialOwemQhJFzk7Lfm6Tua+Si1r6owIfNgCBz3s5K+nclGzd6RmL
         PrnGhxufEk4KN5ZPbeguB5kPeBfZyHMh/czBFJK06gkKpcot9/wjovN4e84ldkkdJ/a7
         w4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iBNOcXzOzdiL6TlX0DnZI//Y/yZM2ilodfIit+PGvCc=;
        b=oFNTLtWtBjQTAyYzHjbgXGeCqTfFlAw/TFSB0HcSN06grkhKlWEQsPaYDbgoe1Pejg
         xZcsPNjiDGfTYgMjiD675EROZPc4gSftym2kjadQnqXcpifpI13V4JSnb4EWId570QFz
         rZz6S6wmus9bR1XBxM7IKo7MPyiKtT2rK/5gTaQSTRjtWJS6M4nzzLu/W9ADRp6qw5Ra
         cpR2lMOSp6SnSZk432k+Tjc2ZRUtc2BkmfvjWzR4hk/oGTFDhNFyrAhfU7tG8gMB96bE
         fcd9XX4WbP2Dr5Vnam3OvpzDvqEnGG4CD3FbHSNBpajU4uMFmpfiLsRyIH1kageK9ZHa
         kucg==
X-Gm-Message-State: AJIora95LAdRLbvOTKLM05EOuCOEB0o9mHzUTzb9rG03QYAWd9+3v1uu
        F9f9GESvN+wT6SVqfY4OZ1F66/hVcHI=
X-Google-Smtp-Source: AGRyM1sJPidkyxIez2mFDeVqU7v2n5Quh4NKL90J5cw5b9OzcqIlUvLlsPyK7oHwbVm6bRoD+1D+c9z3u00=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a03:b0:522:990c:c795 with SMTP id
 p3-20020a056a000a0300b00522990cc795mr1958932pfh.15.1655335806600; Wed, 15 Jun
 2022 16:30:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:40 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 10/13] x86: efi, smp: Transition APs from
 16-bit to 32-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
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

From: Varad Gautam <varad.gautam@suse.com>

Sending INIT/SIPI to APs from ap_init() resets them into 16-bit mode
to loop into sipi_entry().

To drive the APs into 32-bit mode, the SIPI vector needs:
1. A GDT descriptor reachable from 16-bit code (gdt32_descr).
2. A 32-bit entrypoint reachable from 16-bit code (ap_start32).
3. The locations of GDT and the 32-bit entrypoint.

Setting these up at compile time (like on non-EFI builds) is not
possible since EFI builds with -shared -fPIC and efistart64.S cannot
reference any absolute addresses.

Relative addressing is unavailable on 16-bit mode.

Moreover, EFI may not load the 32-bit entrypoint to be reachable from
16-bit mode.

To overcome these problems,
1. Fill the GDT descriptor at runtime after relocating
   [sipi_entry-sipi_end] to lowmem. Since sipi_entry does not know the
   address of this descriptor, use the last two bytes of SIPI page to
   communicate it.
2. Place a call gate in the GDT to point to ap_start32.
3. Popluate sipi_entry() to lcall to ap_start32.

With this, the APs can transition to 32-bit mode and loop at a known
location.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/setup.c      |  2 +-
 lib/x86/smp.c        | 81 +++++++++++++++++++++++++++++++++++++++++++-
 lib/x86/smp.h        |  3 ++
 x86/efi/efistart64.S | 35 ++++++++++++++++++-
 x86/trampolines.S    | 38 +++++++++++++++++++--
 5 files changed, 153 insertions(+), 6 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index c7c0983..2d199b4 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -347,11 +347,11 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
+	setup_page_table();
 	enable_apic();
 	ap_init();
 	enable_x2apic();
 	smp_init();
-	setup_page_table();
 
 	return EFI_SUCCESS;
 }
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 2f554ce..022d627 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -24,10 +24,17 @@ static volatile bool ipi_wait;
 static int _cpu_count;
 static atomic_t active_cpus;
 extern u8 rm_trampoline, rm_trampoline_end;
-#ifdef __i386__
+#if defined(__i386__) || defined(CONFIG_EFI)
 extern u8 ap_rm_gdt_descr;
 #endif
 
+#ifdef CONFIG_EFI
+extern u8 ap_rm_gdt, ap_rm_gdt_end;
+extern u8 ap_start32;
+extern u32 smp_stacktop;
+extern u8 stacktop;
+#endif
+
 /* The BSP is online from time zero. */
 atomic_t cpu_online_count = { .counter = 1 };
 
@@ -163,6 +170,74 @@ static void setup_rm_gdt(void)
 	 * the vector code.
 	 */
 	sgdt(rm_gdt);
+#elif defined(CONFIG_EFI)
+	idt_entry_t *gate_descr;
+
+	/*
+	 * The realmode trampoline on EFI has the following layout:
+	 *
+	 * |rm_trampoline:
+	 * |sipi_entry:
+	 * |  <AP bootstrapping code called from SIPI>
+	 * |ap_rm_gdt:
+	 * |  <GDT used for 16-bit -> 32-bit trasition>
+	 * |ap_rm_gdt_descr:
+	 * |  <GDT descriptor for ap_rm_gdt>
+	 * |sipi_end:
+	 * |  <End of trampoline>
+	 * |rm_trampoline_end:
+	 *
+	 * After relocating to the lowmem address pointed to by realmode_trampoline,
+	 * the realmode GDT descriptor needs to contain the relocated address of
+	 * ap_rm_gdt.
+	 */
+	volatile struct descriptor_table_ptr *rm_gdt_descr =
+			(struct descriptor_table_ptr *) (&ap_rm_gdt_descr - &rm_trampoline);
+	rm_gdt_descr->base = (ulong) ((u32) (&ap_rm_gdt - &rm_trampoline));
+	rm_gdt_descr->limit = (u16) (&ap_rm_gdt_end - &ap_rm_gdt - 1);
+
+	/*
+	 * Since 1. compile time calculation of offsets is not allowed when
+	 * building with -shared, and 2. rip-relative addressing is not supported in
+	 * 16-bit mode, the relocated address of ap_rm_gdt_descr needs to be stored at
+	 * a location known to / accessible from the trampoline.
+	 *
+	 * Use the last two bytes of the trampoline page (REALMODE_GDT_LOWMEM) to store
+	 * a pointer to relocated ap_rm_gdt_descr addr. This way, the trampoline code can
+	 * find the relocated descriptor using the lowmem address at pa=REALMODE_GDT_LOWMEM,
+	 * and this relocated descriptor points to the relocated GDT.
+	 */
+	*((u16 *)(REALMODE_GDT_LOWMEM)) = (u16) (u64) rm_gdt_descr;
+
+	/*
+	 * Set up a call gate to the 32-bit entrypoint (ap_start32) within GDT, since
+	 * EFI may not load the 32-bit AP entrypoint (ap_start32) low enough
+	 * to be reachable from the SIPI vector.
+	 *
+	 * Since kvm-unit-tests builds with -shared, this location needs to be fetched
+	 * at runtime, and rip-relative addressing is not supported in 16-bit mode. This
+	 * prevents using a long jump to ap_start32 (`ljmpl $cs, $ap_start32`).
+	 *
+	 * As an alternative, a far return via `push $cs; push $label; lret` would require
+	 * an intermediate trampoline since $label must still be within 0 - 0xFFFF for
+	 * 16-bit far return to work.
+	 *
+	 * Using a call gate allows for an easier 16-bit -> 32-bit transition via `lcall`.
+	 *
+	 * GDT layout:
+	 *
+	 * Entry | Segment
+	 * 0	 | NULL descr
+	 * 1	 | Code segment descr
+	 * 2	 | Data segment descr
+	 * 3	 | Call gate descr
+	 *
+	 * This layout is only used for reaching 32-bit mode. APs load a 64-bit GDT
+	 * later during boot, which does not need to follow this layout.
+	 */
+	gate_descr = ((void *)(&ap_rm_gdt - &rm_trampoline) + 3 * sizeof(gdt_entry_t));
+	set_desc_entry(gate_descr, sizeof(gdt_entry_t), (void *) &ap_start32,
+		       0x8 /* sel */, 0xc /* type */, 0 /* dpl */);
 #endif
 }
 
@@ -184,6 +259,10 @@ void ap_init(void)
 
 	setup_rm_gdt();
 
+#ifdef CONFIG_EFI
+	smp_stacktop = ((u64) (&stacktop)) - PAGE_SIZE;
+#endif
+
 	/* INIT */
 	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
 
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index 77f8a19..b805be5 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -6,6 +6,9 @@
 #include "libcflat.h"
 #include "atomic.h"
 
+/* Address where to store the address of realmode GDT descriptor. */
+#define REALMODE_GDT_LOWMEM (PAGE_SIZE - 2)
+
 /* Offsets into the per-cpu page. */
 struct percpu_data {
 	uint32_t  smp_id;
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 3a4135e..a514612 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -12,6 +12,9 @@
 .globl stacktop
 stacktop:
 
+.globl smp_stacktop
+smp_stacktop:	.long 0
+
 .align PAGE_SIZE
 .globl ptl2
 ptl2:
@@ -33,16 +36,46 @@ ptl4:
 .text
 
 .code16
+REALMODE_GDT_LOWMEM = PAGE_SIZE - 2
 
 .globl rm_trampoline
 rm_trampoline:
 
 .globl sipi_entry
 sipi_entry:
-	jmp sipi_entry
+	mov %cr0, %eax
+	or $1, %eax
+	mov %eax, %cr0
+
+	/* Retrieve relocated ap_rm_gdt_descr address at REALMODE_GDT_LOWMEM. */
+	mov (REALMODE_GDT_LOWMEM), %ebx
+	lgdtl (%ebx)
+
+	lcall $0x18, $0x0
+
+.globl ap_rm_gdt
+ap_rm_gdt:
+	.quad 0
+	.quad 0x00cf9b000000ffff // flat 32-bit code segment
+	.quad 0x00cf93000000ffff // flat 32-bit data segment
+	.quad 0                  // call gate to 32-bit AP entrypoint
+.globl ap_rm_gdt_end
+ap_rm_gdt_end:
+
+.globl ap_rm_gdt_descr
+ap_rm_gdt_descr:
+	.word 0
+	.long 0
 
 .globl sipi_end
 sipi_end:
 
 .globl rm_trampoline_end
 rm_trampoline_end:
+
+#include "../trampolines.S"
+
+.code64:
+
+ap_start64:
+	jmp ap_start64
diff --git a/x86/trampolines.S b/x86/trampolines.S
index deb5057..6a3df9c 100644
--- a/x86/trampolines.S
+++ b/x86/trampolines.S
@@ -36,6 +36,23 @@ rm_trampoline_end:
 #ifdef __x86_64__
 .code32
 
+/*
+ * EFI builds with "-shared -fPIC" and so cannot directly reference any absolute
+ * address.  In 64-bit mode, RIP-relative addressing neatly solves the problem,
+ * but 32-bit code doesn't have that luxury.  Make a dummy CALL to get RIP into
+ * a GPR in order to emulate RIP-relative for 32-bit transition code.
+ */
+.macro load_absolute_addr, addr, reg
+#ifdef CONFIG_EFI
+	call 1f
+1:
+	pop \reg
+	add \addr - 1b, \reg
+#else
+	mov \addr, \reg
+#endif
+.endm
+
 MSR_GS_BASE = 0xc0000101
 
 .macro setup_percpu_area
@@ -61,7 +78,9 @@ MSR_GS_BASE = 0xc0000101
 .endm
 
 prepare_64:
-	lgdt gdt_descr
+	load_absolute_addr $gdt_descr, %edx
+	lgdtl (%edx)
+
 	setup_segments
 
 	xor %eax, %eax
@@ -72,7 +91,12 @@ enter_long_mode:
 	bts $5, %eax  // pae
 	mov %eax, %cr4
 
+	/* Note, EFI doesn't yet support 5-level paging. */
+#ifdef CONFIG_EFI
+	load_absolute_addr $ptl4, %eax
+#else
 	mov pt_root, %eax
+#endif
 	mov %eax, %cr3
 
 efer = 0xc0000080
@@ -87,11 +111,19 @@ efer = 0xc0000080
 	mov %eax, %cr0
 	ret
 
+.globl ap_start32
 ap_start32:
 	setup_segments
+
+	load_absolute_addr $smp_stacktop, %edx
 	mov $-4096, %esp
-	lock xaddl %esp, smp_stacktop
+	lock xaddl %esp, (%edx)
+
 	setup_percpu_area
 	call prepare_64
-	ljmpl $8, $ap_start64
+
+	load_absolute_addr $ap_start64, %edx
+	pushl $0x08
+	pushl %edx
+	lretl
 #endif
-- 
2.36.1.476.g0c4daa206d-goog

