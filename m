Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB50B3F1846
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 13:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbhHSLfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238812AbhHSLfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 07:35:53 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D3FC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15so3650752wmj.1
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F7CUliUhTh7aYBcRJq4Ct3KX4RaFX+ihicrQzvXmF1k=;
        b=Lh7mKG1xnrUE0QX/clk3lJQL/rB5ItP2bbJuP/gbfx2gzYCFM2F18LqVTAcg2QLRb8
         HmRv/QT7kcpz5Bm7emUi4DL368v22ogZXl4RZCkTEW1SeAPlEETo2nNfRFa17DDjxiPz
         PKVppsQRzE5tEDWPdz8SNwdP6zEtGatq1/if4j/6T+2ca3gPyPLXnAyzBtKOHJSryHq4
         tzFXnJkyBP6xhiaaqIx89dGZ+eyw57b688V6VhBZKTQWiD4HamWYJb1quPIM6ZaTO9J2
         hyKJ8weMatJJkx7fCpdAbxV8gpjEXuNoN0D6P1MrtKZNbjq2SBjdiKAE9FG/8sTWJt2w
         n24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F7CUliUhTh7aYBcRJq4Ct3KX4RaFX+ihicrQzvXmF1k=;
        b=M6d2sinS9Lzs7rOFVfiEu1H3DkTfet3cgMrHUgP7TsUX8dWeFO/wib8kXRRD1oeor0
         JwcNPudJqw7sYV6nJMU4C4kTYCagGbLBFLK7D4hklxzWLVCk8RBdYKI0lubCf1Nxl/B0
         32uik7s+X60ImZKuceqvXoenV/LWaYAGtss4EMb8VoVlD5A3Rb0qsHKCQKELO4fdADCh
         ZDbJjFaHUbbIxyoEPh4yI3Ykr8VvOoPd8EXpHaWCN/WFgkKbSIOq16uHmYASBlr/jkwe
         x6EIEXIL7I0tH50/uBFwpLyxWzIkfdgVGL+YdGNHMkDGtow2ETl6G5cuU4oExYocZcYe
         KCyA==
X-Gm-Message-State: AOAM530z1oH9X/BoiwasSiY5qyo4QH8hJqswBwBhzzxygYbfPAYQfsgl
        grzoxTAAxEdgzLgxQEaUEWzrL2F++9N1tyHB
X-Google-Smtp-Source: ABdhPJy1g7Kbjvf5xddOt0JuhNey4fL7UoxK+qFu1AzhGMA8ugyF1w/mrT1hSsP8vbn+ZZ7SqT/H8g==
X-Received: by 2002:a1c:f314:: with SMTP id q20mr13453730wmq.154.1629372915735;
        Thu, 19 Aug 2021 04:35:15 -0700 (PDT)
Received: from xps13.suse.de (ip5f5a5c19.dynamic.kabel-deutschland.de. [95.90.92.25])
        by smtp.gmail.com with ESMTPSA id w11sm2682859wrr.48.2021.08.19.04.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:35:15 -0700 (PDT)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v2 5/6] cstart64.S: x86_64 bootstrapping after exiting EFI
Date:   Thu, 19 Aug 2021 13:33:59 +0200
Message-Id: <20210819113400.26516-6-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819113400.26516-1-varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
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
v2: Fix TSS setup in cstart64 on CONFIG_EFI.

 x86/cstart64.S | 70 +++++++++++++++++++++++++++++++++++++++++++++-----
 x86/efi_main.c |  1 +
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 98e7848..547f3fb 100644
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
@@ -259,12 +260,38 @@ ap_start64:
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
+	call load_tss
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
@@ -276,15 +303,27 @@ _efi_pe_entry:
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
+#ifndef CONFIG_EFI
 	call load_tss
+#endif
 	call mask_pic_interrupts
 	call enable_apic
 	call save_id
+#ifndef CONFIG_EFI
 	mov mb_boot_info(%rip), %rbx
 	mov %rbx, %rdi
 	call setup_multiboot
@@ -292,18 +331,24 @@ start64:
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
@@ -330,6 +375,7 @@ online_cpus:
 load_tss:
 #ifndef CONFIG_EFI
 	lidtq idt_descr
+#endif
 	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
 	mov (%rax), %eax
 	shr $24, %eax
@@ -337,6 +383,18 @@ load_tss:
 	shl $4, %ebx
 	mov $((tss_end - tss) / max_cpus), %edx
 	imul %edx
+#ifdef CONFIG_EFI
+	lea tss(%rip), %rax
+	lea tss_descr(%rip), %rcx
+	add %rbx, %rcx
+	mov %ax, 2(%rcx)
+	shr $16, %rax
+	mov %al, 4(%rcx)
+	shr $8, %rax
+	mov %al, 7(%rcx)
+	shr $8, %rax
+	mov %eax, 8(%rcx)
+#else
 	add $tss, %rax
 	mov %ax, tss_descr+2(%rbx)
 	shr $16, %rax
@@ -345,9 +403,9 @@ load_tss:
 	mov %al, tss_descr+7(%rbx)
 	shr $8, %rax
 	mov %eax, tss_descr+8(%rbx)
+#endif
 	lea tss_descr-gdt64(%rbx), %rax
 	ltr %ax
-#endif
 	ret
 
 ap_init:
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

