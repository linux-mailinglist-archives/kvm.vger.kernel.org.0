Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1452350FC2E
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbiDZLrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349604AbiDZLrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795D83C49E
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4D9B6210EB;
        Tue, 26 Apr 2022 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=870oAQkOnZfebUHtHN8TC5yN7thP8MfvlmdM9H+WTTQ=;
        b=DZxlNnudT9DlKvgMgiGXTxtwFdGgqOBcrZAZiQca/XaHTRRDzLOG3gHkJbdz0wSJRGWuXO
        YUq2ESHi/qi/TPvoC0EmCDgFbgxQKUucrIizllpDg4gESyNPzWIvh9NwMNOJk42SN3nU10
        0xmErK0C+U0FPJMMuXDL6tsdi/BFHqA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A319D13223;
        Tue, 26 Apr 2022 11:44:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KD3oJQrbZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:10 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 01/11] x86: Share realmode trampoline between i386 and x86_64
Date:   Tue, 26 Apr 2022 13:43:42 +0200
Message-Id: <20220426114352.1262-2-varad.gautam@suse.com>
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

i386 and x86_64 each maintain their own copy of the realmode trampoline
(sipi_entry). Move the 16-bit SIPI vector and GDT to a new start16.S to
be shared by both.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/cstart.S   | 20 ++++----------------
 x86/cstart64.S | 18 +++---------------
 x86/start16.S  | 27 +++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 31 deletions(-)
 create mode 100644 x86/start16.S

diff --git a/x86/cstart.S b/x86/cstart.S
index 6db6a38..06b5be6 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -126,10 +126,10 @@ start32:
 
 ap_init:
 	cld
-	sgdtl ap_gdt_descr // must be close to sipi_entry for real mode access to work
-	lea sipi_entry, %esi
+	sgdtl ap_rm_gdt_descr // must be close to rm_trampoline for real mode access to work
+	lea rm_trampoline, %esi
 	xor %edi, %edi
-	mov $(sipi_end - sipi_entry), %ecx
+	mov $(rm_trampoline_end - rm_trampoline), %ecx
 	rep movsb
 	mov $APIC_DEFAULT_PHYS_BASE, %eax
 	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%eax)
@@ -146,16 +146,4 @@ online_cpus:
 .align 2
 cpu_online_count:	.word 1
 
-.code16
-sipi_entry:
-	mov %cr0, %eax
-	or $1, %eax
-	mov %eax, %cr0
-	lgdtl ap_gdt_descr - sipi_entry
-	ljmpl $8, $ap_start32
-
-ap_gdt_descr:
-	.word 0
-	.long 0
-
-sipi_end:
+#include "start16.S"
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 7272452..cae6f51 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -156,19 +156,7 @@ gdt32:
 	.quad 0x00cf93000000ffff // flat 32-bit data segment
 gdt32_end:
 
-.code16
-sipi_entry:
-	mov %cr0, %eax
-	or $1, %eax
-	mov %eax, %cr0
-	lgdtl gdt32_descr - sipi_entry
-	ljmpl $8, $ap_start32
-
-gdt32_descr:
-	.word gdt32_end - gdt32 - 1
-	.long gdt32
-
-sipi_end:
+#include "start16.S"
 
 .code32
 ap_start32:
@@ -243,9 +231,9 @@ online_cpus:
 
 ap_init:
 	cld
-	lea sipi_entry, %rsi
+	lea rm_trampoline, %rsi
 	xor %rdi, %rdi
-	mov $(sipi_end - sipi_entry), %rcx
+	mov $(rm_trampoline_end - rm_trampoline), %rcx
 	rep movsb
 	mov $APIC_DEFAULT_PHYS_BASE, %eax
 	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%rax)
diff --git a/x86/start16.S b/x86/start16.S
new file mode 100644
index 0000000..e61b22a
--- /dev/null
+++ b/x86/start16.S
@@ -0,0 +1,27 @@
+/* Common 16-bit bootstrapping code. */
+
+.code16
+.globl rm_trampoline
+rm_trampoline:
+
+/* Store SIPI vector code at the beginning of trampoline. */
+sipi_entry:
+	mov %cr0, %eax
+	or $1, %eax
+	mov %eax, %cr0
+	lgdtl ap_rm_gdt_descr - sipi_entry
+	ljmpl $8, $ap_start32
+sipi_end:
+
+.globl ap_rm_gdt_descr
+ap_rm_gdt_descr:
+#ifdef __i386__
+	.word 0
+	.long 0
+#else
+	.word gdt32_end - gdt32 - 1
+	.long gdt32
+#endif
+
+.globl rm_trampoline_end
+rm_trampoline_end:
-- 
2.32.0

