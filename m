Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26034FE729
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358352AbiDLRgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358338AbiDLRg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:36:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C626400
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:34:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 45CA4215FE;
        Tue, 12 Apr 2022 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4PRv9+ImH8TQbJxAxi3US041m63h4v7n9rw1HODXXU=;
        b=IX0oIlPJ6E/O9C+UgNYq5WnUM2xm6OjsB0vv+I3Sq4wVQ8144a5C3OINpwFzxQ5slcjx9i
        RW2N44nM8rRKQXL3r2ibsGNUqwop/SXvdInX0mr/7OJWwNx27ymSayjhSyc97Y1WHxiNzY
        UPi/fPVlLAZhQBo7NhP4JUCJcoyEAZ0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD20313780;
        Tue, 12 Apr 2022 17:34:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MMn8JxC4VWLAewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:34:08 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 07/10] x86: efi, smp: Transition APs from 16-bit to 32-bit mode
Date:   Tue, 12 Apr 2022 19:34:04 +0200
Message-Id: <20220412173407.13637-8-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173407.13637-1-varad.gautam@suse.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 lib/x86/smp.c        | 56 ++++++++++++++++++++++++++++++++++++++++++++
 x86/efi/efistart64.S | 29 ++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index d7f5aba..5cc1648 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -6,6 +6,7 @@
 #include "apic.h"
 #include "fwcfg.h"
 #include "desc.h"
+#include "asm/page.h"
 
 #define IPI_VECTOR 0x20
 
@@ -144,16 +145,71 @@ void smp_reset_apic(void)
 	atomic_inc(&active_cpus);
 }
 
+#ifdef CONFIG_EFI
+extern u8 gdt32_descr, gdt32, gdt32_end;
+extern u8 ap_start32;
+#endif
+
 void ap_init(void)
 {
 	u8 *dst_addr = 0;
 	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
 
+	assert(sipi_sz < PAGE_SIZE);
+
 	asm volatile("cld");
 
 	/* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
+	memset(dst_addr, 0, PAGE_SIZE);
 	memcpy(dst_addr, &sipi_entry, sipi_sz);
 
+#ifdef CONFIG_EFI
+	volatile struct descriptor_table_ptr *gdt32_descr_rel;
+	idt_entry_t *gate_descr;
+	u16 *gdt32_descr_reladdr = (u16 *) (PAGE_SIZE - sizeof(u16));
+
+	/*
+	 * gdt32_descr for CONFIG_EFI needs to be filled here dynamically
+	 * since compile time calculation of offsets is not allowed when
+	 * building with -shared, and rip-relative addressing is not supported
+	 * in 16-bit mode.
+	 *
+	 * Use the last two bytes of SIPI page to store relocated gdt32_descr
+	 * addr.
+	 */
+	*gdt32_descr_reladdr = (&gdt32_descr - &sipi_entry);
+
+	gdt32_descr_rel = (struct descriptor_table_ptr *) ((u64) *gdt32_descr_reladdr);
+	gdt32_descr_rel->limit = (u16) (&gdt32_end - &gdt32 - 1);
+	gdt32_descr_rel->base = (ulong) ((u32) (&gdt32 - &sipi_entry));
+
+	/*
+	 * EFI may not load the 32-bit AP entrypoint (ap_start32) low enough
+	 * to be reachable from the SIPI vector. Since we build with -shared, this
+	 * location needs to be fetched at runtime, and rip-relative addressing is
+	 * not supported in 16-bit mode.
+	 * To perform 16-bit -> 32-bit far jump, our options are:
+	 * - ljmpl $cs, $label : unusable since $label is not known at build time.
+	 * - push $cs; push $label; lret : requires an intermediate trampoline since
+	 *	 $label must still be within 0 - 0xFFFF for 16-bit far return to work.
+	 * - lcall into a call-gate : best suited.
+	 *
+	 * Set up call gate to ap_start32 within GDT.
+	 *
+	 * gdt32 layout:
+	 *
+	 * Entry | Segment
+	 * 0	 | NULL descr
+	 * 1	 | Code segment descr
+	 * 2	 | Data segment descr
+	 * 3	 | Call gate descr
+	 */
+	gate_descr = (idt_entry_t *) ((u8 *)(&gdt32 - &sipi_entry)
+		+ 3 * sizeof(gdt_entry_t));
+	set_idt_entry_t(gate_descr, sizeof(gdt_entry_t), (void *) &ap_start32,
+		0x8 /* sel */, 0xc /* type */, 0 /* dpl */);
+#endif
+
 	/* INIT */
 	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
 
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 1c38355..00279b8 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -65,7 +65,34 @@ setup_segments64:
 
 .globl sipi_entry
 sipi_entry:
-	jmp sipi_entry
+	mov %cr0, %eax
+	or $1, %eax
+	mov %eax, %cr0
+
+	/* Retrieve relocated gdt32_descr address at (PAGE_SIZE - 2). */
+	mov (PAGE_SIZE - 2), %ebx
+	lgdtl (%ebx)
+
+	lcall $0x18, $0x0
+
+.globl gdt32
+gdt32:
+	.quad 0
+	.quad 0x00cf9b000000ffff // flat 32-bit code segment
+	.quad 0x00cf93000000ffff // flat 32-bit data segment
+	.quad 0                  // call gate to 32-bit AP entrypoint
+.globl gdt32_end
+gdt32_end:
+
+.globl gdt32_descr
+gdt32_descr:
+	.word 0
+	.long 0
 
 .globl sipi_end
 sipi_end:
+
+.code32
+.globl ap_start32
+ap_start32:
+	jmp ap_start32
-- 
2.32.0

