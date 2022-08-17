Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A4659718C
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240246AbiHQOlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 10:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiHQOk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 10:40:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44139AF93;
        Wed, 17 Aug 2022 07:40:58 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i14so24879770ejg.6;
        Wed, 17 Aug 2022 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=OYkBi6IJIzT1jwPLplqfUttZv3Vgq/u2jaSOjLFpJqA=;
        b=fwDyeTpkUcetEWKRjH4bzYDwOaTQUwQp3IKoqtDHu9n1ny1MRYQ74w/yg+sIyc4FGA
         aTjJX+U6lQsZQD0qLsMnbvQzn1lbTYAhKT1fGdR4CViBfodvfer1yIUmMW/yBZg0AyJi
         R4UyIHsOqjrNUAHWjdQvdhoEOCEWDMaP4kDX7dVGDyI3pPOf2FlBE9AA5rPFEaAtmxLg
         b4EEQqgdmQwAio8RJntfcOJ2SD9E32KDuriwmPpogKqTgEKY1a12pXtzuRwbXsDVRkJF
         5HGUxLiAW7biRK/8fx9vlf+C2F8ZSH9k6b/iZEuKhGbf8hzV0i3l3uwHBauELv/IvU6Y
         wDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=OYkBi6IJIzT1jwPLplqfUttZv3Vgq/u2jaSOjLFpJqA=;
        b=qrw4HcnDWmAT/QxHIfFzXagTyUSg8C77hCaMUKv60UcksYtu4flFL3qk/e4hcTWlNi
         Jle1xh3UdgPGmVCZq+O0mrj4SGxDTXSVUWWu6A4CZ0PmQlJMDAh3GaUYMeXSHDL7iDCx
         4HAd7896xucaix/BsZfvrOjffxIP+WXaaRsAuqADQaBPlg9+66MSz2ovXmOIzqLLXhMj
         /x1I5jVdKrioPu0reqfqKjJ8DsL1Oc+LJY8xQGzAbDPY6fj2dJfs2HRlN4QmFrupi1rQ
         nTXUFN/2dXhjGlVYc1eJnfp1OoMqN/hmd2nIAVVNR3WHcQVL5pNgN6VCBhhmjRffT3jb
         /WyQ==
X-Gm-Message-State: ACgBeo0D9Ovqj3xa2ee2ODcYGY4f1CAm3nhXmvCNGqibasTv3PSMEGH6
        MveBrjgbhJEzO9LO5KKgjb5Pfd1GxJME5A==
X-Google-Smtp-Source: AA6agR6efll/+5JYLS49lp5cCBPRwxMOs5NUeZQlmZF9pliBgu0d7BNxwtlXbM4emxEL8TSresvj9A==
X-Received: by 2002:a17:907:2da6:b0:730:8b30:e517 with SMTP id gt38-20020a1709072da600b007308b30e517mr17074250ejc.291.1660747256817;
        Wed, 17 Aug 2022 07:40:56 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id hr16-20020a1709073f9000b007317ad372c0sm6800199ejc.20.2022.08.17.07.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:40:56 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
Date:   Wed, 17 Aug 2022 16:40:45 +0200
Message-Id: <20220817144045.3206-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to declare vmread_error asmlinkage, its arguments
can be passed via registers for both, 32-bit and 64-bit targets.
Function argument registers are considered call-clobbered registers,
they are saved in the trampoline just before the function call and
restored afterwards.

Note that asmlinkage and __attribute__((regparm(0))) have no effect
on 64-bit targets. The trampoline is called from the assembler glue
code that implements its own stack-passing function calling convention,
so the attribute on the trampoline declaration does not change anything
for 64-bit as well as 32-bit targets. We can declare it asmlinkage for
documentation purposes.

The patch unifies trampoline function argument handling between 32-bit
and 64-bit targets and improves generated code for 32-bit targets.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 15 +++------------
 arch/x86/kvm/vmx/vmx.c     |  2 +-
 arch/x86/kvm/vmx/vmx_ops.h |  6 +++---
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 6de96b943804..2b83bab6e371 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -293,22 +293,13 @@ SYM_FUNC_START(vmread_error_trampoline)
 	push %r10
 	push %r11
 #endif
-#ifdef CONFIG_X86_64
+
 	/* Load @field and @fault to arg1 and arg2 respectively. */
-	mov 3*WORD_SIZE(%rbp), %_ASM_ARG2
-	mov 2*WORD_SIZE(%rbp), %_ASM_ARG1
-#else
-	/* Parameters are passed on the stack for 32-bit (see asmlinkage). */
-	push 3*WORD_SIZE(%ebp)
-	push 2*WORD_SIZE(%ebp)
-#endif
+	mov 3*WORD_SIZE(%_ASM_BP), %_ASM_ARG2
+	mov 2*WORD_SIZE(%_ASM_BP), %_ASM_ARG1
 
 	call vmread_error
 
-#ifndef CONFIG_X86_64
-	add $8, %esp
-#endif
-
 	/* Zero out @fault, which will be popped into the result register. */
 	_ASM_MOV $0, 3*WORD_SIZE(%_ASM_BP)
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..c940688ceaa4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -439,7 +439,7 @@ do {					\
 	pr_warn_ratelimited(fmt);	\
 } while (0)
 
-asmlinkage void vmread_error(unsigned long field, bool fault)
+void vmread_error(unsigned long field, bool fault)
 {
 	if (fault)
 		kvm_spurious_fault();
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 5cfc49ddb1b4..550a89394d9f 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -10,9 +10,9 @@
 #include "vmcs.h"
 #include "../x86.h"
 
-asmlinkage void vmread_error(unsigned long field, bool fault);
-__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
-							 bool fault);
+void vmread_error(unsigned long field, bool fault);
+asmlinkage void vmread_error_trampoline(unsigned long field,
+					bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
-- 
2.37.1

