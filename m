Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B681ADC43
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgDQLfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 07:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730267AbgDQLfm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 07:35:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E673EC061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 04:35:40 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id u13so2678568wrp.3
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CMuJlUa2xrrUdubk63aMvSEJCfbQVxpKSxcLKYf9XCA=;
        b=IiIR5pDKCnqXiawSXT03bf2ycyGhGY/nBwnpPrkxfT561D/JL838BwwlyjmmuHrjBs
         kRg0p/hAIXKAnDmSExhVCFNisdp+R9YVWd2MAkVevF8F6pvjnrlbeRm2LnM629w/wIhg
         EbmcowHDmkyWhacu3VuVZ+iPKTx1VFV8Su2kcfasOW+90juRpoZ07e9KGKuNNp8gctyU
         E6pDo+t7zBPNRow62eM1+W6M4kPBF37HajZGguzpmL2/HpeFoEtJgL1ZLAab/8vANTNL
         7nbiWBP+pQulNsxrQJ/4AshwXf96g7157u/SqUeHxQhZZHEKIMe5vjrTpnX+hsygnCZH
         gqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CMuJlUa2xrrUdubk63aMvSEJCfbQVxpKSxcLKYf9XCA=;
        b=b+mWrbWkt6oI9iYRM9EMw2unN9CPa3Uyc7PHU3786tlUj6MkyrMyM+AhtpzBSXmzLv
         J+buU784XOW7x4Gff5KSQ4yD8jgI8kcMaBQJu1eHsUMnKgvlNfLdbelDAVwe6fqEypgA
         uE7IHxM5aMDxhW0E2v+6NZ4xduSfv/rNRbVHu0CJDQPm4tFqzJV8qO0H8V7DWJNNEQPg
         VIt5JWFP/diribmOby4tAfBgdP2/6PIWtTgir1W/LQd/wbqbov/ulM2jZ8jKmuutg7kp
         Q3fZ56fzgyJNz+P+9KGKm6O3taM8r/FwyZNogTkgt/r899mMn1T7gZN4yy3eg3CIr1mH
         C3kg==
X-Gm-Message-State: AGi0PuaLa3D9LB8dMdM9Bitj/BilJMzjQQvvHZwW8Wac4K/HcmojDyG1
        bamSTm0uSzgapNK92h5tWN3svAtY37k=
X-Google-Smtp-Source: APiQypKiKUrzaJLh70hbIcZXyqpe5BdSXRKmFoNvPY1Xjt8IvnyaroZFLgjKx0DLtOvY1tRcASNt9A==
X-Received: by 2002:adf:e98a:: with SMTP id h10mr3501530wrm.370.1587123339127;
        Fri, 17 Apr 2020 04:35:39 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id u15sm29655312wrn.46.2020.04.17.04.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 04:35:38 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly
Date:   Fri, 17 Apr 2020 13:35:24 +0200
Message-Id: <20200417113524.1280130-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve handle_external_interrupt_irqoff inline assembly in several ways:
- use __stringify to use __KERNEL_DS and __KERNEL_CS directly in assembler
- use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
- use $-16 immediate to align %rsp
- avoid earlyclobber by using "l" GCC input operand constraint
- avoid temporary by using current_stack_pointer

The patch introduces no functional change.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 01330096ff3e..4b0d5f0044ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6233,9 +6233,6 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	unsigned int vector;
 	unsigned long entry;
-#ifdef CONFIG_X86_64
-	unsigned long tmp;
-#endif
 	gate_desc *desc;
 	u32 intr_info;
 
@@ -6252,23 +6249,19 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 
 	asm volatile(
 #ifdef CONFIG_X86_64
-		"mov %%" _ASM_SP ", %[sp]\n\t"
-		"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
-		"push $%c[ss]\n\t"
+		"and $-16, %%rsp\n\t"
+		"push $" __stringify(__KERNEL_DS) "\n\t"
 		"push %[sp]\n\t"
 #endif
 		"pushf\n\t"
-		__ASM_SIZE(push) " $%c[cs]\n\t"
+		__ASM_SIZE(push) " $" __stringify(__KERNEL_CS) "\n\t"
 		CALL_NOSPEC
+		: ASM_CALL_CONSTRAINT
 		:
 #ifdef CONFIG_X86_64
-		[sp]"=&r"(tmp),
+		[sp]"l"(current_stack_pointer),
 #endif
-		ASM_CALL_CONSTRAINT
-		:
-		[thunk_target]"r"(entry),
-		[ss]"i"(__KERNEL_DS),
-		[cs]"i"(__KERNEL_CS)
+		[thunk_target]"r"(entry)
 	);
 
 	kvm_after_interrupt(vcpu);
-- 
2.25.2

