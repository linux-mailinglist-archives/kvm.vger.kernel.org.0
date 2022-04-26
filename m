Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689DB50FC25
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349636AbiDZLrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349621AbiDZLrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C83C4BC
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DA72D210FD;
        Tue, 26 Apr 2022 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iI2tN0GDEMiWQdo3pR2heuhsahd8lnMsCoQ8S95YHgA=;
        b=n4wuEdy1Usk1E1ez1xu9QUk/kUe7bxa+kFoE/AgHnifLhfh84ScFrtGnDMEYOFMXL2+EjR
        jyqFx1Nf31vw0nsG28ExVZdRHVSU6OwHIqvERQszBeMLyvtL4SewjMH4YlZYyODCgbLvyA
        CFUJF8DmfmXEFNw5bhjQRxu+vWS4oYI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3B56513223;
        Tue, 26 Apr 2022 11:44:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kM/QCxDbZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:16 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 09/11] x86: Move 32-bit bringup routines to start32.S
Date:   Tue, 26 Apr 2022 13:43:50 +0200
Message-Id: <20220426114352.1262-10-varad.gautam@suse.com>
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

These can be shared across EFI and non-EFI builds.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/cstart64.S | 60 +-----------------------------------------------
 x86/start32.S  | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 59 deletions(-)
 create mode 100644 x86/start32.S

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 9465099..3c8d78f 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -55,35 +55,13 @@ mb_flags = 0x0
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
@@ -117,33 +95,6 @@ switch_to_5level:
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
@@ -156,15 +107,6 @@ gdt32_end:
 
 #include "start16.S"
 
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

