Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2574FE734
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358359AbiDLRgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358309AbiDLRgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:36:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0559FC2
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:34:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8E80C1F85C;
        Tue, 12 Apr 2022 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJnP061Fih1FUA9BUQwMo1xMPjBq6jI83p6Xerukw6U=;
        b=LMKSSEBUHsFi7NKkcsCDtV3qx8BEEm8JaHeIbh7rxYBsj7i2qzpOoEaXmVOK888hokjOHh
        3gMBBIJIDI2QysHtKusFx2WaJRcxbcX2oxHYcyjVNEZVdT9DuD8/x+HMumEUTO3ZnAW671
        Tmf8wUovxyRX2waNUirBAzpPInBjy1s=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED4BE13780;
        Tue, 12 Apr 2022 17:34:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aAXJNxG4VWLAewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:34:09 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 09/10] x86: efi, smp: Transition APs from 32-bit to 64-bit mode
Date:   Tue, 12 Apr 2022 19:34:06 +0200
Message-Id: <20220412173407.13637-10-varad.gautam@suse.com>
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

Reaching 64-bit mode requires setting up a valid stack and percpu
regions for each CPU and configuring a page table before far-jumping to
the 64-bit entrypoint.

This functionality is already present as prepare_64() and ap_start32()
routines in start32.S for non-EFI test builds.

However since EFI builds (-fPIC) cannot use absolute addressing, and
32-bit mode does not allow RIP-relative addressing, these routines need
some changes.

Modify prepare_64() and ap_start32() asm routines to calculate label
addresses during runtime on CONFIG_EFI. To ease the common case, replace
the far-jump to ap_start64() with a far-return.

This brings the APs into 64-bit mode to loop at a known location.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/setup.c      |  2 +-
 lib/x86/smp.c        |  3 +++
 x86/efi/efistart64.S | 13 ++++++++++---
 x86/start32.S        | 46 +++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 5d32d3f..e2f7967 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -326,11 +326,11 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
+	setup_page_table();
 	enable_apic();
 	ap_init();
 	enable_x2apic();
 	smp_init();
-	setup_page_table();
 
 	return EFI_SUCCESS;
 }
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 5cc1648..cee82ac 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -148,6 +148,8 @@ void smp_reset_apic(void)
 #ifdef CONFIG_EFI
 extern u8 gdt32_descr, gdt32, gdt32_end;
 extern u8 ap_start32;
+extern u32 smp_stacktop;
+extern u8 stacktop;
 #endif
 
 void ap_init(void)
@@ -168,6 +170,7 @@ void ap_init(void)
 	idt_entry_t *gate_descr;
 	u16 *gdt32_descr_reladdr = (u16 *) (PAGE_SIZE - sizeof(u16));
 
+	smp_stacktop = ((u64) (&stacktop)) - 4096;
 	/*
 	 * gdt32_descr for CONFIG_EFI needs to be filled here dynamically
 	 * since compile time calculation of offsets is not allowed when
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 00279b8..149e3f7 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -14,6 +14,9 @@ max_cpus = MAX_TEST_CPUS
 .globl stacktop
 stacktop:
 
+.globl smp_stacktop
+smp_stacktop:	.long 0
+
 .align PAGE_SIZE
 .globl ptl2
 ptl2:
@@ -93,6 +96,10 @@ gdt32_descr:
 sipi_end:
 
 .code32
-.globl ap_start32
-ap_start32:
-	jmp ap_start32
+
+#include "../start32.S"
+
+.code64:
+
+ap_start64:
+	jmp ap_start64
diff --git a/x86/start32.S b/x86/start32.S
index 9e00474..2089be7 100644
--- a/x86/start32.S
+++ b/x86/start32.S
@@ -27,7 +27,16 @@ MSR_GS_BASE = 0xc0000101
 .endm
 
 prepare_64:
-	lgdt gdt_descr
+#ifdef CONFIG_EFI
+	call prepare_64_1
+prepare_64_1:
+	pop %edx
+	add $gdt_descr - prepare_64_1, %edx
+#else
+	mov $gdt_descr, %edx
+#endif
+	lgdtl (%edx)
+
 	setup_segments
 
 	xor %eax, %eax
@@ -38,7 +47,14 @@ enter_long_mode:
 	bts $5, %eax  // pae
 	mov %eax, %cr4
 
+#ifdef CONFIG_EFI
+	call prepare_64_2
+prepare_64_2:
+	pop %eax
+	add $ptl4 - prepare_64_2, %eax
+#else
 	mov pt_root, %eax
+#endif
 	mov %eax, %cr3
 
 efer = 0xc0000080
@@ -53,10 +69,34 @@ efer = 0xc0000080
 	mov %eax, %cr0
 	ret
 
+.globl ap_start32
 ap_start32:
 	setup_segments
+
+#ifdef CONFIG_EFI
+	call ap_start32_1
+ap_start32_1:
+	pop %edx
+	add $smp_stacktop - ap_start32_1, %edx
+#else
+	mov $smp_stacktop, %edx
+#endif
 	mov $-4096, %esp
-	lock xaddl %esp, smp_stacktop
+	lock xaddl %esp, (%edx)
+
 	setup_percpu_area
 	call prepare_64
-	ljmpl $8, $ap_start64
+
+#ifdef CONFIG_EFI
+	call ap_start32_2
+ap_start32_2:
+	pop %edx
+	add $ap_start64 - ap_start32_2, %edx
+#else
+	mov $ap_start64, %edx
+#endif
+
+	pushl $0x08
+	pushl %edx
+
+	lretl
-- 
2.32.0

