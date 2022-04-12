Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006884FE712
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbiDLRfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358268AbiDLRfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:35:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107FB5BE4A
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:32:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C0F111F38D;
        Tue, 12 Apr 2022 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XbejgVpF5ZgYr/RTBSxRo0TSVOQLZCYLw9P+IhZ+VAg=;
        b=NY/l9y8VjIuuDGV9lU3c5QRRCa3ZKnrhYtvQyVJ/Uf4e62fmwkO3mEsr2ClSr5b4zh0S5U
        ArIJ8nQ2zJIvzB3+UreZ3bM5lDgiqu+EpotI2N3W3VFz5zgVnm9xBy11Mp+xOLYqTd3DbP
        HTychjkpOtG0CiLZlPqwMmOVvS53P2Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 366A413780;
        Tue, 12 Apr 2022 17:32:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IHfMCqi3VWJJewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:32:24 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [PATCH 02/10] x86: Move load_idt() to desc.c
Date:   Tue, 12 Apr 2022 19:32:13 +0200
Message-Id: <20220412173221.13315-2-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173221.13315-1-varad.gautam@suse.com>
References: <20220412173221.13315-1-varad.gautam@suse.com>
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

This allows sharing IDT setup code between EFI (-fPIC) and
non-EFI builds.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/desc.c       | 5 +++++
 lib/x86/desc.h       | 1 +
 lib/x86/setup.c      | 1 -
 x86/cstart64.S       | 3 ++-
 x86/efi/efistart64.S | 5 -----
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 0677fcd..087e85c 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -294,6 +294,11 @@ void setup_idt(void)
 	handle_exception(13, check_exception_table);
 }
 
+void load_idt(void)
+{
+	lidt(&idt_descr);
+}
+
 unsigned exception_vector(void)
 {
 	return this_cpu_read_exception_vector();
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 5224b58..3044409 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -4,6 +4,7 @@
 #include <setjmp.h>
 
 void setup_idt(void);
+void load_idt(void);
 void setup_alt_stack(void);
 
 struct ex_regs {
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 86ba6de..94e9f86 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -170,7 +170,6 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 #ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
-extern void load_idt(void);
 extern void load_gdt_tss(size_t tss_offset);
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/cstart64.S b/x86/cstart64.S
index f371d06..30012ca 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -66,7 +66,6 @@ MSR_GS_BASE = 0xc0000101
 .endm
 
 .macro load_tss
-	lidtq idt_descr
 	movq %rsp, %rdi
 	call setup_tss
 	ltr %ax
@@ -191,6 +190,7 @@ save_id:
 
 ap_start64:
 	call reset_apic
+	call load_idt
 	load_tss
 	call enable_apic
 	call save_id
@@ -204,6 +204,7 @@ ap_start64:
 
 start64:
 	call reset_apic
+	call load_idt
 	load_tss
 	call mask_pic_interrupts
 	call enable_apic
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 0425153..ea3d1c0 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -26,11 +26,6 @@ ptl4:
 .code64
 .text
 
-.globl load_idt
-load_idt:
-	lidtq idt_descr(%rip)
-	retq
-
 .globl load_gdt_tss
 load_gdt_tss:
 	/* Load GDT */
-- 
2.35.1

