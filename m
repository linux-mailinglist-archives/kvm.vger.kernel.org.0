Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5F94FE72F
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358337AbiDLRgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358325AbiDLRg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:36:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D7BE32
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:34:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 644F71F859;
        Tue, 12 Apr 2022 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EALYIIe8Si8OIFCQWRRurbv8AiCbIknDiKJkHwc3/Ok=;
        b=RFPjBzeF8WjNKGlQ1ZbWhE0SkIiSUYkFnkT0JhjA1lnslBWP4ncmi6zVs3EIYVU3nnpK/d
        U4LU2SN8acgG/Cu/EYCq78Zlod+ewldbuxn1WMBzP/3EAOvVZTID0HrgQZAYDdDcZHGv1D
        FLQsTV37lQqVjy0KoB4PSTEmQF+jS/A=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CFF5313780;
        Tue, 12 Apr 2022 17:34:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4B+YMA64VWLAewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:34:06 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 04/10] x86: Move load_gdt_tss() to desc.c
Date:   Tue, 12 Apr 2022 19:34:01 +0200
Message-Id: <20220412173407.13637-5-varad.gautam@suse.com>
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

Split load_gdt_tss() functionality into:
1. Load gdt/tss
2. Setup segments in 64-bit mode and update %cs via far-return

and move load_gdt_tss() to desc.c to share this code between
EFI and non-EFI tests.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/desc.c       |  6 ++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      |  4 +++-
 x86/efi/efistart64.S | 11 ++---------
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 049adeb..3b1208b 100644
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
index ae0928f..83a16dd 100644
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
index 94e9f86..7dd6677 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -170,7 +170,7 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 #ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
-extern void load_gdt_tss(size_t tss_offset);
+extern void setup_segments64(void);
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
@@ -275,6 +275,8 @@ static void setup_gdt_tss(void)
 	/* 64-bit setup_tss does not use the stacktop argument.  */
 	tss_offset = setup_tss(NULL);
 	load_gdt_tss(tss_offset);
+
+	setup_segments64();
 }
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index ea3d1c0..8eadca5 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -26,15 +26,8 @@ ptl4:
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
-- 
2.32.0

