Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D3D4F92FC
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiDHKdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbiDHKdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003745FD7
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 982841F862;
        Fri,  8 Apr 2022 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KeWHFQnA6KzOYga+wpfNCCA1gV6vEUYtVSCAwTCZLM=;
        b=Er/AOrBY3Tjf0eYuMNWjSbf+F2SXTeQStkjZkIxm1tUtwbRZa4LKh1+K3/cr5hmaFiq/8a
        1EKrJGU+/jhYmoWm5Spo4qZK0VJOnaBgSY0yQ6Ot+fNl84hQAqLsQcLhRm/60VPeieTEA6
        LrBCpsPt1ZzeeKSX3EBQ3CFzek274s4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F41F0132B9;
        Fri,  8 Apr 2022 10:31:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SPsKOf8OUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:27 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 5/9] x86: Move 32-bit bringup routines to start32.S
Date:   Fri,  8 Apr 2022 12:31:23 +0200
Message-Id: <20220408103127.19219-6-varad.gautam@suse.com>
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

These can be shared across EFI and non-EFI builds.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/cstart64.S | 60 +-----------------------------------------------
 x86/start32.S  | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 59 deletions(-)
 create mode 100644 x86/start32.S

diff --git a/x86/cstart64.S b/x86/cstart64.S
index b867791..45009d4 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -59,35 +59,13 @@ mb_flags = 0x0
 	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
 mb_cmdline = 16
 
-MSR_GS_BASE = 0xc0000101
-
-.macro setup_percpu_area
-	lea -4096(%esp), %eax
-	mov $0, %edx
-	mov $MSR_GS_BASE, %ecx
-	wrmsr
-.endm
-
 .macro load_tss
 	movq %rsp, %rdi
 	call setup_tss
 	ltr %ax
 .endm
 
-.macro setup_segments
-	mov $MSR_GS_BASE, %ecx
-	rdmsr
-
-	mov $0x10, %bx
-	mov %bx, %ds
-	mov %bx, %es
-	mov %bx, %fs
-	mov %bx, %gs
-	mov %bx, %ss
-
-	/* restore MSR_GS_BASE */
-	wrmsr
-.endm
+#include "start32.S"
 
 .globl start
 start:
@@ -121,33 +99,6 @@ switch_to_5level:
 	call enter_long_mode
 	jmpl $8, $lvl5
 
-prepare_64:
-	lgdt gdt_descr
-	setup_segments
-
-	xor %eax, %eax
-	mov %eax, %cr4
-
-enter_long_mode:
-	mov %cr4, %eax
-	bts $5, %eax  // pae
-	mov %eax, %cr4
-
-	mov pt_root, %eax
-	mov %eax, %cr3
-
-efer = 0xc0000080
-	mov $efer, %ecx
-	rdmsr
-	bts $8, %eax
-	wrmsr
-
-	mov %cr0, %eax
-	bts $0, %eax
-	bts $31, %eax
-	mov %eax, %cr0
-	ret
-
 smp_stacktop:	.long stacktop - 4096
 
 .align 16
@@ -174,15 +125,6 @@ gdt32_descr:
 .globl sipi_end
 sipi_end:
 
-.code32
-ap_start32:
-	setup_segments
-	mov $-4096, %esp
-	lock xaddl %esp, smp_stacktop
-	setup_percpu_area
-	call prepare_64
-	ljmpl $8, $ap_start64
-
 .code64
 save_id:
 	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
diff --git a/x86/start32.S b/x86/start32.S
new file mode 100644
index 0000000..9e00474
--- /dev/null
+++ b/x86/start32.S
@@ -0,0 +1,62 @@
+/* Common 32-bit code between EFI and non-EFI bootstrapping. */
+
+.code32
+
+MSR_GS_BASE = 0xc0000101
+
+.macro setup_percpu_area
+	lea -4096(%esp), %eax
+	mov $0, %edx
+	mov $MSR_GS_BASE, %ecx
+	wrmsr
+.endm
+
+.macro setup_segments
+	mov $MSR_GS_BASE, %ecx
+	rdmsr
+
+	mov $0x10, %bx
+	mov %bx, %ds
+	mov %bx, %es
+	mov %bx, %fs
+	mov %bx, %gs
+	mov %bx, %ss
+
+	/* restore MSR_GS_BASE */
+	wrmsr
+.endm
+
+prepare_64:
+	lgdt gdt_descr
+	setup_segments
+
+	xor %eax, %eax
+	mov %eax, %cr4
+
+enter_long_mode:
+	mov %cr4, %eax
+	bts $5, %eax  // pae
+	mov %eax, %cr4
+
+	mov pt_root, %eax
+	mov %eax, %cr3
+
+efer = 0xc0000080
+	mov $efer, %ecx
+	rdmsr
+	bts $8, %eax
+	wrmsr
+
+	mov %cr0, %eax
+	bts $0, %eax
+	bts $31, %eax
+	mov %eax, %cr0
+	ret
+
+ap_start32:
+	setup_segments
+	mov $-4096, %esp
+	lock xaddl %esp, smp_stacktop
+	setup_percpu_area
+	call prepare_64
+	ljmpl $8, $ap_start64
-- 
2.32.0

