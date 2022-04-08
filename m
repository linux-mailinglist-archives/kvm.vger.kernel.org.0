Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D3A4F92FA
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbiDHKdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiDHKdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E095331B176
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 99FDC1F85F;
        Fri,  8 Apr 2022 10:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhxPfIHnfOIG3U9KP0MtC2yht9B0W9qTf11TVQ12Zoc=;
        b=F0JxTDKkIfunCaIRzPxK8V/zjFbgCDWEc1Gheyb2IdDsFnauKr4WHFr1UARW8DkD9jW37M
        rqlVMjVzf6TirafpuD5WNcBMIYOvQNezjxeZRjS2Vo/2g5ZsvUQEfW5G6puJTkez+O8y+K
        jTYQlifPQwmHEHM/Wz5LQorTOFSK85w=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A76F132B9;
        Fri,  8 Apr 2022 10:31:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YNNsAP4OUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:26 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 2/9] x86: Move load_idt() to desc.c
Date:   Fri,  8 Apr 2022 12:31:20 +0200
Message-Id: <20220408103127.19219-3-varad.gautam@suse.com>
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
index c2eb16e..355a428 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -293,6 +293,11 @@ void setup_idt(void)
     handle_exception(13, check_exception_table);
 }
 
+void load_idt(void)
+{
+	lidt(&idt_descr);
+}
+
 unsigned exception_vector(void)
 {
     unsigned char vector;
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index ad6277b..602e9f7 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -4,6 +4,7 @@
 #include <setjmp.h>
 
 void setup_idt(void);
+void load_idt(void);
 void setup_alt_stack(void);
 
 struct ex_regs {
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 8be39cb..eab035f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -170,7 +170,6 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 #ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
-extern void load_idt(void);
 extern void load_gdt_tss(size_t tss_offset);
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 06daa7c..b867791 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -69,7 +69,6 @@ MSR_GS_BASE = 0xc0000101
 .endm
 
 .macro load_tss
-	lidtq idt_descr
 	movq %rsp, %rdi
 	call setup_tss
 	ltr %ax
@@ -198,6 +197,7 @@ ap_start64:
 	lock btsl %eax, ap_lock
 	jc .retry
 	call reset_apic
+	call load_idt
 	load_tss
 	call enable_apic
 	call save_id
@@ -213,6 +213,7 @@ ap_start64:
 
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
2.32.0

