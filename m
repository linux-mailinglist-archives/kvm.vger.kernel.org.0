Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707EC1C3018
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgECWd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729174AbgECWd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 18:33:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A166AC061A0E
        for <kvm@vger.kernel.org>; Sun,  3 May 2020 15:33:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d15so18727031wrx.3
        for <kvm@vger.kernel.org>; Sun, 03 May 2020 15:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hAuiYS+rJeIWnpRWOnSqTmst57oP0la/QQB21Glltq8=;
        b=h30bc2gZvKZOb48Bh4oXKnaPyyV30j1pL86UPmoWl7kqJH7pzhgBpCyJxhCmfdpC8d
         cEAz8CT4NyMiNNbn9OLwgJpHVK5xdiFd61vARl0ypP8n/0d0AV06lgfPVmif1PG43BH0
         ALGjLnxFNF/17XxnJ3RI+3HMkqiSnvAbY/Le6VE/I/avzQRw7OU08JTAcyd6Y3QkZXhB
         FhgV1nfhMbML2/uLTLYCxG2qtvrxjpdd4G5kX2OSa/KBemzUF6LHWA1AwpAi41gA1lG0
         STtQDpX8NqgqDv2ggq/heJCzMgeZrGCYOC0hNt7M7T77KzdxHhAU5dA6RLfCphA74C1u
         RhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hAuiYS+rJeIWnpRWOnSqTmst57oP0la/QQB21Glltq8=;
        b=QSgoegrqSer+fA1OYxLpT4PcZ/NNXy+sTBVkGvYO/Si8yCa7lYrHcS4RHAyLgW2qe6
         OlUh3JjYCwQs7IhExwriqUkJ+BkH5l6MkEJvJti+Llut1Cp8VLnK5ThiM+U8MZIWz8ll
         t04o45RGRNJHu58bwI1qifFRduoldv7hMAZjdYCg0g1kSpef3Tk5wq3TKFk7l/7UVn7w
         syuyQAExDRYdTtVq8mgH7PlLdsYTs5L/GKlscUDZPPtxSulJoFXtoBG+5aNfdgLFLotK
         CuaKb5dg/NiIzz9rIXDtQZHzZjnuTTjO8xiNoGMzcEViS303zz9DhVzi41uu/kfAaxaL
         pPwQ==
X-Gm-Message-State: AGi0PuZowJJTEu/Kh4u3SdeQ86bOY4ukuXvHE46vdxSUXkFJAv3PbeGS
        E/oUQesI3fPCl1WlUjhf5souriyjQmo=
X-Google-Smtp-Source: APiQypLQg7/H2HazrEILkrURaF5ETH8o+lfKjzkBgxjeCE5u+SGaSAPIRJLchwZQYUXP8o2LqF4JxA==
X-Received: by 2002:adf:fd83:: with SMTP id d3mr13068526wrr.249.1588545236156;
        Sun, 03 May 2020 15:33:56 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id u5sm2765150wrm.35.2020.05.03.15.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:33:55 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3] KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly
Date:   Mon,  4 May 2020 00:33:42 +0200
Message-Id: <20200503223342.440441-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve handle_external_interrupt_irqoff inline assembly in several ways:
- use "rme" operand constraint instead of "i" and remove
  unneeded %c operand modifiers and "$" prefixes
- use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
- use $-16 immediate to align %rsp
- remove unneeded use of __ASM_SIZE macro
- define "ss" named operand only for X86_64

The patch introduces no functional changes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..8354023c1157 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6283,13 +6283,13 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 
 	asm volatile(
 #ifdef CONFIG_X86_64
-		"mov %%" _ASM_SP ", %[sp]\n\t"
-		"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
-		"push $%c[ss]\n\t"
+		"mov %%rsp, %[sp]\n\t"
+		"and $-16, %%rsp\n\t"
+		"push %[ss]\n\t"
 		"push %[sp]\n\t"
 #endif
 		"pushf\n\t"
-		__ASM_SIZE(push) " $%c[cs]\n\t"
+		"push %[cs]\n\t"
 		CALL_NOSPEC
 		:
 #ifdef CONFIG_X86_64
@@ -6298,8 +6298,10 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		ASM_CALL_CONSTRAINT
 		:
 		[thunk_target]"r"(entry),
-		[ss]"i"(__KERNEL_DS),
-		[cs]"i"(__KERNEL_CS)
+#ifdef CONFIG_X86_64
+		[ss]"rme"(__KERNEL_DS),
+#endif
+		[cs]"rme"(__KERNEL_CS)
 	);
 
 	kvm_after_interrupt(vcpu);
-- 
2.25.4

