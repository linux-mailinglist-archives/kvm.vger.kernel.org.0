Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B101850FC26
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349635AbiDZLrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349617AbiDZLrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01853C49E
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0DC0B210FC;
        Tue, 26 Apr 2022 11:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2UD6f4L1AQtEn5HxDZ93lLe5Oj0Dof9qCT286c1f54A=;
        b=loWlrhhiW48Zd1AnIwheG9X6ZhuQ6x0AuwVG9lD8qx/Kb05mh3Bp8963NKv4h7GUGseGZh
        ihrO5RYZDTcKSCAcUUsvfvvYdomhV1RE1ncAv94gBGyFZuZwW7XWbxUWyCbSaoxyJdNkCq
        Vzzr8MO708d1+X96Fw1OQFphq+6CUGQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F04C13223;
        Tue, 26 Apr 2022 11:44:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uMzKFA3bZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:13 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 05/11] x86: Move load_gdt_tss() to desc.c
Date:   Tue, 26 Apr 2022 13:43:46 +0200
Message-Id: <20220426114352.1262-6-varad.gautam@suse.com>
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

Split load_gdt_tss() functionality into:
1. Load gdt/tss
2. Setup segments in 64-bit mode and update %cs via far-return

and move load_gdt_tss() to desc.c to share this code between
EFI and non-EFI tests.

Move the segment setup code specific to EFI into
setup.c:setup_segments64().

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/desc.c       |  6 ++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      | 25 +++++++++++++++++++++++--
 x86/efi/efistart64.S | 27 ---------------------------
 4 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index a3e7255..bb0b7b2 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -362,6 +362,12 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
 #endif
 }
 
+void load_gdt_tss(size_t tss_offset)
+{
+	lgdt(&gdt_descr);
+	ltr(tss_offset);
+}
+
 #ifndef __x86_64__
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
 {
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index d743504..7ac505a 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -222,6 +222,7 @@ void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
 void set_gdt_entry(int sel, unsigned long base, u32 limit, u8 access, u8 gran);
+void load_gdt_tss(size_t tss_offset);
 void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index dd2b916..367c13f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -169,8 +169,27 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 #ifdef CONFIG_EFI
 
-/* From x86/efi/efistart64.S */
-extern void load_gdt_tss(size_t tss_offset);
+static void setup_segments64(void)
+{
+	/* Update data segments */
+	write_ds(KERNEL_DS);
+	write_es(KERNEL_DS);
+	write_fs(KERNEL_DS);
+	write_gs(KERNEL_DS);
+	write_ss(KERNEL_DS);
+
+	/*
+	 * Update the code segment by putting it on the stack before the return
+	 * address, then doing a far return: this will use the new code segment
+	 * along with the address.
+	 */
+	asm volatile("pushq %1\n\t"
+		"lea 1f(%%rip), %0\n\t"
+		"pushq %0\n\t"
+		"lretq\n\t"
+		"1:"
+		:: "r" ((u64)KERNEL_DS), "i" (KERNEL_CS));
+}
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
@@ -275,6 +294,8 @@ static void setup_gdt_tss(void)
 	/* 64-bit setup_tss does not use the stacktop argument.  */
 	tss_offset = setup_tss(NULL);
 	load_gdt_tss(tss_offset);
+
+	setup_segments64();
 }
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 98cc965..b94c5ab 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -26,33 +26,6 @@ ptl4:
 .code64
 .text
 
-.globl load_gdt_tss
-load_gdt_tss:
-	/* Load GDT */
-	lgdt gdt_descr(%rip)
-
-	/* Load TSS */
-	mov %rdi, %rax
-	ltr %ax
-
-	/* Update data segments */
-	mov $0x10, %ax /* 3rd entry in gdt64: 32/64-bit data segment */
-	mov %ax, %ds
-	mov %ax, %es
-	mov %ax, %fs
-	mov %ax, %gs
-	mov %ax, %ss
-
-	/*
-	 * Update the code segment by putting it on the stack before the return
-	 * address, then doing a far return: this will use the new code segment
-	 * along with the address.
-	 */
-	popq %rdi
-	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
-	pushq %rdi
-	lretq
-
 .code16
 
 .globl rm_trampoline
-- 
2.32.0

