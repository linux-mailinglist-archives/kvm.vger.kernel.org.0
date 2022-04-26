Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D4150FC27
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349632AbiDZLra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349615AbiDZLrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04973C4B9
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2B1C5210EB;
        Tue, 26 Apr 2022 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1w4sJ/X4GyaZaMMPIfpd4dTcx3KKpzj8Ggp2LO5pItE=;
        b=g3qeSzsXyFmuLKB5RMGCNmp73gyIrrMdQCGykyXZ5+87wOKLVB1MgJWOszxRtfEpsygz+J
        8sJFC8L9gYY9/1RPW5W1nsQ5ASl+bbTyxgiF33CGNkvG9HFtQb6EWB9AR1aL9lCULxTu7e
        G2LYXBWVTdpxkucnqaIQq+seFx9DOFM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 791E513223;
        Tue, 26 Apr 2022 11:44:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8GoWGw/bZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:15 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 08/11] x86: efi, smp: Transition APs from 16-bit to 32-bit mode
Date:   Tue, 26 Apr 2022 13:43:49 +0200
Message-Id: <20220426114352.1262-9-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426114352.1262-1-varad.gautam@suse.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 lib/x86/smp.c        | 73 +++++++++++++++++++++++++++++++++++++++++++-
 lib/x86/smp.h        |  3 ++
 x86/efi/efistart64.S | 30 +++++++++++++++++-
 3 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 90f6210..360ae82 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -21,9 +21,13 @@ static volatile bool ipi_wait;
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
+#endif
 atomic_t cpu_online_count = { .counter = 1 };
 
 static __attribute__((used)) void ipi(void)
@@ -158,6 +162,73 @@ static void setup_rm_gdt(void)
 	 * the vector code.
 	 */
 	sgdt(rm_gdt);
+#elif defined(CONFIG_EFI)
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
+	idt_entry_t *gate_descr = (idt_entry_t *) ((u8 *)(&ap_rm_gdt - &rm_trampoline)
+		+ 3 * sizeof(gdt_entry_t));
+	set_desc_entry(gate_descr, sizeof(gdt_entry_t), (void *) &ap_start32,
+		0x8 /* sel */, 0xc /* type */, 0 /* dpl */);
 #endif
 }
 
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
index 3a4135e..c6b1a5b 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -33,16 +33,44 @@ ptl4:
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
+.code32
+.globl ap_start32
+ap_start32:
+	jmp ap_start32
-- 
2.32.0

