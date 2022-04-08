Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1F94F92FD
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiDHKdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbiDHKdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51CF19FF4D
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DDF281F85F;
        Fri,  8 Apr 2022 10:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sl4DCpe29zhNSfHZwFK9O1OxfnBoTVIlfikiVcuU0rc=;
        b=D9PssaJgqNADhmPIP6tczjBpm5fg0JRuEIfuT7n7VEcAl7NsDcm9k1HqKt2liEV1P5AgDt
        dM5gjfY9UvplC7R5Jk8AZlHGtzumMSPUtLjZ1m68/iPxEtUTjEXpHcHTepikyrFxMI6Gvc
        q1B/+DnBK8f4hZV/+3j58cmA4hkU6s4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4F6AE132B9;
        Fri,  8 Apr 2022 10:31:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AGHyEAEPUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:29 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 7/9] x86: Move load_gdt_tss() to desc.c
Date:   Fri,  8 Apr 2022 12:31:25 +0200
Message-Id: <20220408103127.19219-8-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408103127.19219-1-varad.gautam@suse.com>
References: <20220408103127.19219-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split load_gdt_tss() functionality into:
1. Load gdt/tss.
2. Setup segments in 64-bit mode.
3. Update cs segment via far-return.

and move load_gdt_tss() to desc.c to share this code between
EFI and non-EFI tests.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/desc.c       |  6 ++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      |  9 ++++++++-
 x86/efi/efistart64.S | 22 +++++++++++++---------
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 713ad0b..d627a22 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -370,6 +370,12 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
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
index 5eb21e4..30a0c90 100644
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
index 3f3b1e2..e5a690a 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -170,7 +170,9 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 #ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
-extern void load_gdt_tss(size_t tss_offset);
+extern void update_cs(void);
+extern void setup_segments64(u64 gs_base);
+extern u8 stacktop;
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
@@ -271,10 +273,15 @@ static void setup_page_table(void)
 static void setup_gdt_tss(void)
 {
 	size_t tss_offset;
+	u64 gs_base;
 
 	/* 64-bit setup_tss does not use the stacktop argument.  */
 	tss_offset = setup_tss(NULL);
 	load_gdt_tss(tss_offset);
+
+	update_cs();
+	gs_base = (u64)(&stacktop) - (PAGE_SIZE * (apic_id() + 1));
+	setup_segments64(gs_base);
 }
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 7e924dc..c8fd3a2 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -37,15 +37,8 @@ ptl4:
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
+.globl setup_segments64
+setup_segments64:
 	/* Update data segments */
 	mov $0x10, %ax /* 3rd entry in gdt64: 32/64-bit data segment */
 	mov %ax, %ds
@@ -54,6 +47,17 @@ load_gdt_tss:
 	mov %ax, %gs
 	mov %ax, %ss
 
+	/* Setup percpu base */
+	MSR_GS_BASE = 0xc0000101
+	mov %rdi, %rax
+	mov $0, %edx
+	mov $MSR_GS_BASE, %ecx
+	wrmsr
+
+	ret
+
+.globl update_cs
+update_cs:
 	/*
 	 * Update the code segment by putting it on the stack before the return
 	 * address, then doing a far return: this will use the new code segment
-- 
2.32.0

