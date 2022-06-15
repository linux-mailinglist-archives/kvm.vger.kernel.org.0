Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02ED54D552
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348787AbiFOXaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348302AbiFOXaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271AC13E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so113984pjg.7
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DG6WalYERHkMR3Airm7dl51TN+7M6heKIE0NPiP3UMA=;
        b=DYAwpzflYcDSuqlm+Dddx6PjHh4neoYOIgWfjwdUWYmdW9UjeUnKyt1HbbyuCCfDEZ
         KvjStYumR9BB8Sx/WotTSnPMrGs2Z0r0MxVFVtiR5ky8RoDBlVLASEPKCG3xDhK812yv
         Dzf8FbzCjwCo5xfWTPWVhZpbLuyxJIFusZNNgCn6eSWoi+lbLW8/tMSln3tvdcPU8UWv
         ElofgwgKjw3LDlmWeAVmdChvlD98xQaDGDplfoRfcf0JEdZEOtPppLOS01Znsq07ufpO
         TR8xnt703NiKzCNCfyIL3T5O+PenE4p8DG3mXv8nDHulD2kkh8yDHqELI6UWd5GXgxx7
         SW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DG6WalYERHkMR3Airm7dl51TN+7M6heKIE0NPiP3UMA=;
        b=Vsqo11W7ftQWv/uko/bqZl0gT47qx2kQa2HLmLbkF03JnjgaRvKXsCybmMkWVPgOA7
         pHRZgrGpNvjYYlqnxeOWU3UQC/UlFvSXEQsPQxsC0qQ+hblnN7cWB4YXfAD8uHbmv8mH
         pQ7PTvaiZaubkqi+flZMVkeh2NG4kTaPEOk/bDQfpGm8LFh6twHiYqlePIhqRHnJCUxx
         u8qZKzgC37agOWfVhxYjoHBXZoThLGzQhs9NPTrM3+cX/9cpEQ8jfc3RDEGdCu04RdNI
         oo1Wyrggjs2KtFG2uL5nti44Dt7kpppbJKo1U2qx92HhL6nilOSs/o6PVAcDHStLE1N8
         XcIQ==
X-Gm-Message-State: AJIora8JHoa+1j48dgFCu07gmZvjMD8aMV7In8E+qh6inee8ZD0gDpwJ
        auSUHLnr+XJLrP23IqpL5SURGFgA80I=
X-Google-Smtp-Source: AGRyM1sjANQWXSqPbadq7zplTeVpepe4zVB8svqOkuW6VoeiDowfztJevlyJpx8iQgo9UAERaygV84UhR1s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b51:b0:51b:f772:40c5 with SMTP id
 p17-20020a056a000b5100b0051bf77240c5mr1805236pfo.22.1655335800640; Wed, 15
 Jun 2022 16:30:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:36 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 06/13] x86: Move load_gdt_tss() to desc.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>

Split load_gdt_tss() functionality into:
1. Load gdt/tss
2. Setup segments in 64-bit mode and update %cs via far-return

and move load_gdt_tss() to desc.c to share this code between
EFI and non-EFI tests.

Move the segment setup code specific to EFI into
setup.c:setup_segments64().

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c       |  6 ++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      | 25 +++++++++++++++++++++++--
 x86/efi/efistart64.S | 27 ---------------------------
 4 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 9512363..a7c3480 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -361,6 +361,12 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
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
index 1dc1ea0..9dcc92b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -223,6 +223,7 @@ void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
 void set_gdt_entry(int sel, unsigned long base, u32 limit, u8 access, u8 gran);
+void load_gdt_tss(size_t tss_offset);
 void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index dd2b916..9724465 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -169,8 +169,27 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 #ifdef CONFIG_EFI
 
-/* From x86/efi/efistart64.S */
-extern void load_gdt_tss(size_t tss_offset);
+static void setup_segments64(void)
+{
+	/* Update data segments */
+	write_ds(KERNEL_DS);
+	write_es(KERNEL_DS);
+	write_fs(KERNEL_DS);
+	write_gs(KERNEL_DS);
+	write_ss(KERNEL_DS);
+
+	/*
+	 * Update the code segment by putting it on the stack before the return
+	 * address, then doing a far return: this will use the new code segment
+	 * along with the address.
+	 */
+	asm volatile("pushq %1\n\t"
+		     "lea 1f(%%rip), %0\n\t"
+		     "pushq %0\n\t"
+		     "lretq\n\t"
+		     "1:"
+		     :: "r" ((u64)KERNEL_DS), "i" (KERNEL_CS));
+}
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
@@ -275,6 +294,8 @@ static void setup_gdt_tss(void)
 	/* 64-bit setup_tss does not use the stacktop argument.  */
 	tss_offset = setup_tss(NULL);
 	load_gdt_tss(tss_offset);
+
+	setup_segments64();
 }
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 98cc965..b94c5ab 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -26,33 +26,6 @@ ptl4:
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
-	/* Update data segments */
-	mov $0x10, %ax /* 3rd entry in gdt64: 32/64-bit data segment */
-	mov %ax, %ds
-	mov %ax, %es
-	mov %ax, %fs
-	mov %ax, %gs
-	mov %ax, %ss
-
-	/*
-	 * Update the code segment by putting it on the stack before the return
-	 * address, then doing a far return: this will use the new code segment
-	 * along with the address.
-	 */
-	popq %rdi
-	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
-	pushq %rdi
-	lretq
-
 .code16
 
 .globl rm_trampoline
-- 
2.36.1.476.g0c4daa206d-goog

