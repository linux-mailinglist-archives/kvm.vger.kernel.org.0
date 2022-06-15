Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E209F54D549
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349282AbiFOXaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348918AbiFOXaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFC713E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s17-20020a170902ea1100b00168b7cad0efso7255404plg.14
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KOUNeTkbG+akxiwaletV/9PUjLoGLpOO55sty1IBjCM=;
        b=tjeL88b9rEvjGll2Nm1LVibZkIlFEU7TA2aI1dMhkQA7DUrW5ShO/lN/DhWwhuBq82
         ao2oe309dQ53GDPOfFnrZ0XAAHZvPbrfoNEmaSnHE8Mh+QZnVTpaq4Mkj1qfllAY6PCa
         lphDBjea6FpmiPdJoTwri2/9Gl5/VCob11iuOgY3bPDavB2bfkghRvXxYy/1fk52QsOh
         WZZI/gWur6hCE93f221uO5W2R3QMNprZvQ8ZM+kqakz3oHKPJqEltNKDTuouOIqOnkad
         yv+bGSiW0wekpo3RDB5cfEgxOGvj5Sxxrzdh541myava6TbrG8KYBXBK9UrYtuyRusGt
         6uLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KOUNeTkbG+akxiwaletV/9PUjLoGLpOO55sty1IBjCM=;
        b=mx0mIhV4I8TsjtqXMnp6Te+B74NKNUMn19K77VU7rYPOu9KPD3SSmey4Txut0MNAe0
         94walR4OKqyJi+X4Vk+Tut7i6rAkcK2x/AE/r+sbQLm0yGaj1RG7ucXoTkwMmSUzLmOZ
         kePZFDrm1AxHkqcvQfHeKnhQiBvXiVclUchQXq3v8J60wK8w1T5KZaSnP9PpMy73SgzC
         NAC0gjHDWxliQxlpWXqbvsW59nfJeWEyhphb++lLt5QCKBkCeENKRyisaXlYdsIQJ/MD
         SKKVONU7p3KFPA94qkaGWt0vNzELZnyl6lgULDHeoPmOIKdnC5b+swdKePLwx6E4cWzs
         A3AA==
X-Gm-Message-State: AJIora/8LsL+8UQa6uxZ2sTvet1CjyqpQDniLbb/iTJZxPcTvN68rEI5
        BIqr3bgBge/8yi6Cyro7ZDyTnTglnjU=
X-Google-Smtp-Source: AGRyM1vl64iN1UU/oVQwypVRxUuSsQHyTOMbEadkYEHsaygaj2+jrs8J9cS1T2K1rsf4DAa0otLXks6iat8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c407:b0:163:df01:bbbc with SMTP id
 k7-20020a170902c40700b00163df01bbbcmr1695241plk.4.1655335805048; Wed, 15 Jun
 2022 16:30:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:39 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 09/13] x86: Move 32-bit => 64-bit transition
 code to trampolines.S
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

Move the code for transitioning from unpaged 32-bit mode to paged 64-bit
mode to trampoline.S, it can be shared across EFI and non-EFI builds.

Leave 5-level paging behind for the time being, EFI doesn't yet support
support disabling paging, which is required to get from 4-level to
5-level paging.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
[sean: move to trampolines.S instead of start32.S, reword changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart64.S    | 60 ---------------------------------------
 x86/trampolines.S | 71 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 62 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 8ac6e9c..0a561ce 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -56,36 +56,12 @@ mb_flags = 0x0
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
-
 .globl start
 start:
 	mov %ebx, mb_boot_info
@@ -118,33 +94,6 @@ switch_to_5level:
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
@@ -155,15 +104,6 @@ gdt32:
 	.quad 0x00cf93000000ffff // flat 32-bit data segment
 gdt32_end:
 
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
diff --git a/x86/trampolines.S b/x86/trampolines.S
index 9640c66..deb5057 100644
--- a/x86/trampolines.S
+++ b/x86/trampolines.S
@@ -1,6 +1,9 @@
-/* Common bootstrapping code to transition from 16-bit to 32-bit code. */
+/*
+ * Common bootstrapping code to transition from 16-bit to 32-bit code, and to
+ * transition from 32-bit to 64-bit code (x86-64 only)
+ */
 
-/* EFI provides it's own SIPI sequence to handle relocation. */
+ /* EFI provides it's own SIPI sequence to handle relocation. */
 #ifndef CONFIG_EFI
 .code16
 .globl rm_trampoline
@@ -28,3 +31,67 @@ ap_rm_gdt_descr:
 .globl rm_trampoline_end
 rm_trampoline_end:
 #endif
+
+/* The 32-bit => 64-bit trampoline is x86-64 only. */
+#ifdef __x86_64__
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
+#endif
-- 
2.36.1.476.g0c4daa206d-goog

