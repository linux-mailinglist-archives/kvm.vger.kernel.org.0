Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8CE54D544
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiFOXaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347985AbiFOX36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:29:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D21713E80
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y123-20020a253281000000b0066473f97bf1so11669553yby.3
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GSq0LANTbTiBfuHR8nD18GVrsdGZiBVMELH7kMaHGTQ=;
        b=qRe39Mhwwx59ppBm5yqeJrBU+gwNDin5b3MUeILgT3HmK+5oNCKLx/iHiKiaFB/p7Y
         PTlJKAWpm+CB4sBG+1HH18g7o++zKLXEtTzbSgD+SzhCiJh8aO8wvLx9kBCZF7k34hsc
         iKcuw6t7J50YIWCinI09poikq4fsxY3u5Aa15ELYo5dplTvqavFZzrhe4MdmjPBSAOwA
         4s4QR1SB2+3ABioXL+L+j9KRokOeYkQUV7srz+aYGAab1/LI4dsi6/M9ImAZ+iHqJBE2
         3PmmrGrJPwuKZmVi+4fWCzj5HgiRi+b4WRdoWj9GubT7lnCsJtDUVOQuAaEpIpimyE/a
         K8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GSq0LANTbTiBfuHR8nD18GVrsdGZiBVMELH7kMaHGTQ=;
        b=UW4ab6KQJjBUdoRSOK+jPS5glKRZ1PR0rggGDDoK9lAwR+qQe1w95y8ochtmgnS7Z9
         7h+U5r1npCNr/YDw+Eo3QCe6j6+dqlwpe+Si9ELGq8sKSEBRs8C8klQnJ4vwhIyG4hBM
         jNLQuvURntVR6SYLswG/ZPxjP6LqylBFMb+ptm9CZAlGrk2Or6dXlszE+5zqsp5MZX7h
         5LqIg51kFFJ36Y7cv/gGAGcMCJcvyAxKdBF1PdMVeERnozbP6ZBbBXVNM8hWKfgONyae
         CknHJsjqO87Vp3npih1OQoMkG81NzsdyTOyJ0BJZjlljwxVh9Z60BsHmuHDWDQUzpGyu
         FOqQ==
X-Gm-Message-State: AJIora/X851yUxXqwNCAohQJyM5+OWRCOOVZUvtXagIf/eMGQAait/83
        KfPrkv9AP524iWgcQyoaZtep8O5DL68=
X-Google-Smtp-Source: AGRyM1tFFTf2m30RIVyaGUnod8gV8vwqqm1wrntmCiUHekKcx1PV4KnhBAzjLiMFAPb1BpyncN5Na6/Qetk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4c57:0:b0:317:64b1:b347 with SMTP id
 z84-20020a814c57000000b0031764b1b347mr2239000ywa.300.1655335797359; Wed, 15
 Jun 2022 16:29:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:34 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 04/13] x86: Move load_idt() to desc.c
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

This allows sharing IDT setup code between EFI (-fPIC) and
non-EFI builds.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c       | 5 +++++
 lib/x86/desc.h       | 1 +
 lib/x86/setup.c      | 1 -
 x86/cstart.S         | 2 +-
 x86/cstart64.S       | 3 ++-
 x86/efi/efistart64.S | 5 -----
 6 files changed, 9 insertions(+), 8 deletions(-)

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
index 2004e7f..dd2b916 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -170,7 +170,6 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 #ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
-extern void load_idt(void);
 extern void load_gdt_tss(size_t tss_offset);
 
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/cstart.S b/x86/cstart.S
index 88d25fc..20fcb64 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -35,7 +35,7 @@ mb_flags = 0x0
 mb_cmdline = 16
 
 .macro setup_tr_and_percpu
-	lidt idt_descr
+	call load_idt
 	push %esp
 	call setup_tss
 	addl $4, %esp
diff --git a/x86/cstart64.S b/x86/cstart64.S
index f0d12fb..8ac6e9c 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -66,7 +66,6 @@ MSR_GS_BASE = 0xc0000101
 .endm
 
 .macro load_tss
-	lidtq idt_descr
 	movq %rsp, %rdi
 	call setup_tss
 	ltr %ax
@@ -175,6 +174,7 @@ save_id:
 
 ap_start64:
 	call reset_apic
+	call load_idt
 	load_tss
 	call enable_apic
 	call save_id
@@ -188,6 +188,7 @@ ap_start64:
 
 start64:
 	call reset_apic
+	call load_idt
 	load_tss
 	call mask_pic_interrupts
 	call enable_apic
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 7d50f96..98cc965 100644
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
2.36.1.476.g0c4daa206d-goog

