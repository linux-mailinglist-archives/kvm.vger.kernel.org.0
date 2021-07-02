Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630C13BA009
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhGBLvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:24 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44754 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhGBLvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0FDA82055A;
        Fri,  2 Jul 2021 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWVtsIZNVyli015FxwN2RGU3q5E2rKCEUllZcSA6C4A=;
        b=CDtHo6IdWNwWCIDk6UmBa1rnZ82B2bNRnzU0o9zJQnsU+VWB/zKN7nQKY8K5+EsnpkdHxw
        RG7dxeLZJWL1j8Skejt6jLylCBC8QxvJWXAxw9SmpYzw+2W+A7Z6SDU/h/YmIij2P4fH86
        IW1+wBUS+8QpqRTMynd/Xwz/9pnZFYc=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id AA22711C84;
        Fri,  2 Jul 2021 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWVtsIZNVyli015FxwN2RGU3q5E2rKCEUllZcSA6C4A=;
        b=CDtHo6IdWNwWCIDk6UmBa1rnZ82B2bNRnzU0o9zJQnsU+VWB/zKN7nQKY8K5+EsnpkdHxw
        RG7dxeLZJWL1j8Skejt6jLylCBC8QxvJWXAxw9SmpYzw+2W+A7Z6SDU/h/YmIij2P4fH86
        IW1+wBUS+8QpqRTMynd/Xwz/9pnZFYc=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id iPHlJyH93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:49 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 5/6] cstart64.S: x86_64 bootstrapping after exiting EFI
Date:   Fri,  2 Jul 2021 13:48:19 +0200
Message-Id: <20210702114820.16712-6-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFI sets up long mode with arbitrary state before calling the
image entrypoint. To run the testcases at hand, it is necessary
to redo some of the bootstrapping to not rely on what EFI
provided.

Adapt start64() for EFI testcases to fixup %rsp/GDT/IDT/TSS and
friends, and jump here after relocation from efi_main. Switch to
RIP-relative addressing where necessary.

Initially leave out:
- AP init - leave EFI to single CPU
- Testcase arg passing

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/cstart64.S | 57 ++++++++++++++++++++++++++++++++++++++++++++------
 x86/efi_main.c |  1 +
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 98e7848..d4448c2 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -242,16 +242,17 @@ ap_start32:
 
 .code64
 save_id:
-#ifndef CONFIG_EFI
 	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
 	movl (%rax), %eax
 	shrl $24, %eax
+#ifdef CONFIG_EFI
+	lock btsl %eax, online_cpus(%rip)
+#else
 	lock btsl %eax, online_cpus
 #endif
 	retq
 
 ap_start64:
-#ifndef CONFIG_EFI
 	call reset_apic
 	call load_tss
 	call enable_apic
@@ -259,12 +260,37 @@ ap_start64:
 	call enable_x2apic
 	sti
 	nop
+#ifdef CONFIG_EFI
+	lock incw cpu_online_count(%rip)
+#else
 	lock incw cpu_online_count
 #endif
+
 1:	hlt
 	jmp 1b
 
 #ifdef CONFIG_EFI
+setup_gdt64:
+	lgdt gdt64_desc(%rip)
+
+	setup_segments
+
+	movabsq $flush_cs, %rax
+	pushq $0x8
+	pushq %rax
+	retfq
+flush_cs:
+	ret
+
+setup_idt64:
+	lidtq idt_descr(%rip)
+	ret
+
+setup_cr3:
+	movabsq $ptl4, %rax
+	mov %rax, %cr3
+	ret
+
 .globl _efi_pe_entry
 _efi_pe_entry:
 	# EFI image loader calls this with rcx=efi_handle,
@@ -276,15 +302,25 @@ _efi_pe_entry:
 	pushq   %rsi
 
 	call efi_main
-#endif
 
+.globl start64
 start64:
-#ifndef CONFIG_EFI
+	cli
+	lea stacktop(%rip), %rsp
+
+	setup_percpu_area
+	call setup_gdt64
+	call setup_idt64
+	call setup_cr3
+#else
+start64:
+#endif
 	call reset_apic
 	call load_tss
 	call mask_pic_interrupts
 	call enable_apic
 	call save_id
+#ifndef CONFIG_EFI
 	mov mb_boot_info(%rip), %rbx
 	mov %rbx, %rdi
 	call setup_multiboot
@@ -292,18 +328,24 @@ start64:
 	mov mb_cmdline(%rbx), %eax
 	mov %rax, __args(%rip)
 	call __setup_args
+#endif
 
 	call ap_init
 	call enable_x2apic
 	call smp_init
 
+#ifdef CONFIG_EFI
+	mov $0, %edi
+	mov $0, %rsi
+	mov $0, %rdx
+#else
 	mov __argc(%rip), %edi
 	lea __argv(%rip), %rsi
 	lea __environ(%rip), %rdx
+#endif
 	call main
 	mov %eax, %edi
 	call exit
-#endif
 
 .globl setup_5level_page_table
 setup_5level_page_table:
@@ -328,7 +370,10 @@ online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
 load_tss:
-#ifndef CONFIG_EFI
+#ifdef CONFIG_EFI
+	mov $(tss_descr - gdt64), %rax
+	ltr %ax
+#else
 	lidtq idt_descr
 	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
 	mov (%rax), %eax
diff --git a/x86/efi_main.c b/x86/efi_main.c
index be3f9ab..c542fb9 100644
--- a/x86/efi_main.c
+++ b/x86/efi_main.c
@@ -7,6 +7,7 @@ efi_system_table_t *efi_system_table = NULL;
 
 extern char ImageBase;
 extern char _DYNAMIC;
+extern void start64(void);
 
 static void efi_free_pool(void *ptr)
 {
-- 
2.30.2

