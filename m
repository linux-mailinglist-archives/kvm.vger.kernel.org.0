Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415FA54D53B
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347077AbiFOX34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346170AbiFOX3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:29:55 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D7013E93
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u71-20020a63854a000000b004019c5cac3aso7166403pgd.19
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+1k/Z16nuoJyCB7Sl5SBm/MLvI1YKFcWfcLGapioqcs=;
        b=qziGcinLGSvrdoEe3iIkn9RnXp8hgODS3/kl6NmI2Vu/LN2/qynAc0fbzgH2XVFM4I
         K+FQO0Ig87u6O/qDcpJb2+VJ5d6LPPVv9IoMlOblq+uYlLVjAytO8gHxeeks/uCvERFx
         Qpmd309keFg7H+MLNamiEZIcsf6Hni7wLBZOJYAHNDdWiKwA+QqXBf0QmzjE9xVf0RQN
         pgmiaUePxKjo2h4/Nh9kGlGqjVb88RQz9id0MEuYFtPHWAxD1liHj7zJq3FB/laGV4Gr
         RNF03Rn6XgceLvscykndACrBOBTf+pPsEtwSycqdslEUohDauD0lj9Fmp0o7w09Vru4G
         HzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+1k/Z16nuoJyCB7Sl5SBm/MLvI1YKFcWfcLGapioqcs=;
        b=szF7Mhlm91cYX0zDfGZh2gp3FM0OrrSIImL+Z5mFngduTO0F1+3GCrXCNRYeFXAgv9
         rJqRa0hiZsswj0R/8Klq16e8mCoTd8C90wdXq0Rq77HcwfqxH9ujRNNOdlLA7jv/q6Ol
         TjggbDl7y13k9BZ3io6yL7KvU624LRHJcmBdWJggvQkxpE2f59xfxcGyw+xAt8DTqWhy
         totZ0IBUPhrH+LSMuzZd05x3X5LQ2BCZ3Jbg2TBwmTzDhHDSDxPtTY9KNBrFJhcsGn/B
         oMw3yPH45P67YQsjEPHFMHNExN0ksMnLSeKgAakuWRL7YgYV45Kh3tHzGHrnVFBgSOlp
         nytw==
X-Gm-Message-State: AJIora+yhio9Ih4qn8hs9S0OlLd5RQPFcIiqwyEymFw8OMZuwLhgWEM8
        Ne8kAmlDaplJqwtNc+XXSmPhv7zU5Rs=
X-Google-Smtp-Source: AGRyM1vb68hEOQlI3eH1f8mpGVUmi+gl5iq39x2IK7w6YWeC1DyFQtZ40fSB1e4d5TXm+UAfWklTP3wsRlM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c2:b0:166:46c9:577b with SMTP id
 o2-20020a170902d4c200b0016646c9577bmr1709247plg.66.1655335794176; Wed, 15 Jun
 2022 16:29:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:32 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 02/13] x86: Share realmode trampoline
 between i386 and x86_64
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

i386 and x86_64 each maintain their own copy of the realmode trampoline
(sipi_entry). Move the 16-bit SIPI vector and GDT to a new trampolines.S
to be shared by both.  The common trampoline file will also be used to
shared 32-bit to 64-bit trampoline code.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
[sean: rename to trampolines.S to avoid naming conundrum]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart.S      | 20 ++++----------------
 x86/cstart64.S    | 21 ++++-----------------
 x86/trampolines.S | 30 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 33 deletions(-)
 create mode 100644 x86/trampolines.S

diff --git a/x86/cstart.S b/x86/cstart.S
index 6db6a38..8aa29ee 100644
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
+#include "trampolines.S"
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 7272452..129ef0b 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -45,8 +45,9 @@ mb_boot_info:	.quad 0
 
 pt_root:	.quad ptl4
 
+#include "trampolines.S"
+
 .section .init
-
 .code32
 
 mb_magic = 0x1BADB002
@@ -156,20 +157,6 @@ gdt32:
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
-
 .code32
 ap_start32:
 	setup_segments
@@ -243,9 +230,9 @@ online_cpus:
 
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
diff --git a/x86/trampolines.S b/x86/trampolines.S
new file mode 100644
index 0000000..9640c66
--- /dev/null
+++ b/x86/trampolines.S
@@ -0,0 +1,30 @@
+/* Common bootstrapping code to transition from 16-bit to 32-bit code. */
+
+/* EFI provides it's own SIPI sequence to handle relocation. */
+#ifndef CONFIG_EFI
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
+#endif
-- 
2.36.1.476.g0c4daa206d-goog

