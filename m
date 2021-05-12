Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00037BBB2
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhELLWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhELLWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:22:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C13C061574;
        Wed, 12 May 2021 04:21:35 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w3so34443151ejc.4;
        Wed, 12 May 2021 04:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHzreHuweH97osIdaXwbfq/+CLsH9zkDVNipBCZFdw8=;
        b=NN/KgV2Yh68bcHPu0DFZE2mIb6JkHVqGKhAM1BUUN9OSI2tKsPy7+/pKdP/8RFjjsO
         NI8z+Y3I4XH1zMeAGEE0xhb+TxvqljEC1q1KY7PYUQ1LguKqtiw+o2AJ7Z4uDNwzHqF4
         SXvKIvfGFOjok6OAzc91MG/r4bSq35o07qdcq3ZXr99+GsoCJBqk7oFQ0iVIGVj5ko+m
         G7EIbWkftBHrAGk9rmr9zfdvOTA3TZPUlb7eFwjuI0+HllDUP/tqyK/VH7ygrg/eaPeO
         D1280JzzEJeNi3TPoVsHjXPrybb4p9vHccTqfgp7hJh9lb+tDH5ZpWag7eO1xY2kCG6t
         eZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHzreHuweH97osIdaXwbfq/+CLsH9zkDVNipBCZFdw8=;
        b=jtxFhybpST1BNuNg3f997SYyqrmBvM21cZvRi6ic/lp4iAYZ0H7p+kB8xulVMEVHzI
         9gCRxeEukughCoo6hIoqNeVr5CvFQLz32HemJfa7ntE4T/XV6Fq5nO/YclJ7WKfXgOml
         je8ZJJ7LgMdQvtLCsGvn/5VmRFiRMl69g8AdKCU9Ak399dco8E3FUngKlgR5zjBFQkA0
         HtYcL9XrJm/erp34x1VcWa3EPZV/IDCLnQok0WKwI2S1xaTb79giF6zakl6rx4faf08t
         lpw7Wn8OUZRbWu+1UcyNLfq2u9Rcst1E0WXAKQCYGn2JoOrLxubqtG5DQ7KapYI2+OKN
         HJ/Q==
X-Gm-Message-State: AOAM530CfWlJyq0XDIziuv89WOdkGmIZeA7DHnd0LZppP4EtmmRRzYRX
        qXTagAZ57boGDC9vX7pq0SdYsCYC/uuXYQ==
X-Google-Smtp-Source: ABdhPJwGNuBiiVAKjqaj/eiwSGpnSYkfNx81epAAbGKk5DYCb8fuTybvOZb+uEo84xR+OYNQLp8ddg==
X-Received: by 2002:a17:907:11db:: with SMTP id va27mr36365589ejb.174.1620818493453;
        Wed, 12 May 2021 04:21:33 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id w6sm11763192edc.25.2021.05.12.04.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 04:21:33 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: SVM/VMX: Use %rax instead of %__ASM_AX within CONFIG_X86_64
Date:   Wed, 12 May 2021 13:21:15 +0200
Message-Id: <20210512112115.70048-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to use %__ASM_AX within CONFIG_X86_64. The macro
will always expand to %rax.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/vmenter.S | 44 +++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmenter.S | 32 +++++++++++++--------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 4fa17df123cd..844b558bb021 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -64,14 +64,14 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
 	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
 #ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
+	mov VCPU_R8 (%rax),  %r8
+	mov VCPU_R9 (%rax),  %r9
+	mov VCPU_R10(%rax), %r10
+	mov VCPU_R11(%rax), %r11
+	mov VCPU_R12(%rax), %r12
+	mov VCPU_R13(%rax), %r13
+	mov VCPU_R14(%rax), %r14
+	mov VCPU_R15(%rax), %r15
 #endif
 
 	/* "POP" @vmcb to RAX. */
@@ -93,21 +93,21 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_AX
 
 	/* Save all guest registers.  */
-	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
-	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
-	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
-	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
-	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
+	mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
+	mov %_ASM_DX, VCPU_RDX(%_ASM_AX)
+	mov %_ASM_BX, VCPU_RBX(%_ASM_AX)
+	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
+	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
+	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
 #ifdef CONFIG_X86_64
-	mov %r8,  VCPU_R8 (%_ASM_AX)
-	mov %r9,  VCPU_R9 (%_ASM_AX)
-	mov %r10, VCPU_R10(%_ASM_AX)
-	mov %r11, VCPU_R11(%_ASM_AX)
-	mov %r12, VCPU_R12(%_ASM_AX)
-	mov %r13, VCPU_R13(%_ASM_AX)
-	mov %r14, VCPU_R14(%_ASM_AX)
-	mov %r15, VCPU_R15(%_ASM_AX)
+	mov %r8,  VCPU_R8 (%rax)
+	mov %r9,  VCPU_R9 (%rax)
+	mov %r10, VCPU_R10(%rax)
+	mov %r11, VCPU_R11(%rax)
+	mov %r12, VCPU_R12(%rax)
+	mov %r13, VCPU_R13(%rax)
+	mov %r14, VCPU_R14(%rax)
+	mov %r15, VCPU_R15(%rax)
 #endif
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 3a6461694fc2..9273709e4800 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -142,14 +142,14 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
 	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
 #ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
+	mov VCPU_R8 (%rax),  %r8
+	mov VCPU_R9 (%rax),  %r9
+	mov VCPU_R10(%rax), %r10
+	mov VCPU_R11(%rax), %r11
+	mov VCPU_R12(%rax), %r12
+	mov VCPU_R13(%rax), %r13
+	mov VCPU_R14(%rax), %r14
+	mov VCPU_R15(%rax), %r15
 #endif
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
@@ -175,14 +175,14 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
 	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
 #ifdef CONFIG_X86_64
-	mov %r8,  VCPU_R8 (%_ASM_AX)
-	mov %r9,  VCPU_R9 (%_ASM_AX)
-	mov %r10, VCPU_R10(%_ASM_AX)
-	mov %r11, VCPU_R11(%_ASM_AX)
-	mov %r12, VCPU_R12(%_ASM_AX)
-	mov %r13, VCPU_R13(%_ASM_AX)
-	mov %r14, VCPU_R14(%_ASM_AX)
-	mov %r15, VCPU_R15(%_ASM_AX)
+	mov %r8,  VCPU_R8 (%rax)
+	mov %r9,  VCPU_R9 (%rax)
+	mov %r10, VCPU_R10(%rax)
+	mov %r11, VCPU_R11(%rax)
+	mov %r12, VCPU_R12(%rax)
+	mov %r13, VCPU_R13(%rax)
+	mov %r14, VCPU_R14(%rax)
+	mov %r15, VCPU_R15(%rax)
 #endif
 
 	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
-- 
2.31.1

