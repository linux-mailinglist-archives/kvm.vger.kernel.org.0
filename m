Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8A61B8F93
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 13:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgDZLxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 07:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgDZLxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 07:53:05 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED53C061A0E
        for <kvm@vger.kernel.org>; Sun, 26 Apr 2020 04:53:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k1so17128056wrx.4
        for <kvm@vger.kernel.org>; Sun, 26 Apr 2020 04:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XHG/8raY/sNsCvqJxNKRfA970Dv5Wyt5EYrzke/beHI=;
        b=b4XCUq7PlQRs0ksWZgSlunAMQSnV1kPIMQyqkc6EbU7JgSk1MLfLZ/Ggie2G35aPHK
         GRMdF8ts0WKc+gY4/T8wS63LX/W+04fSQYABLIOE9e+S0QhS0Vrxtqlau03Vjhm5GMPp
         tFg/GONDORkbh74dUg/hsW0UNP0/zyavovzIfujGGmxCPG9dt9Q49m+i3LugZJU6sCtL
         tKXYuz4Jjo1ocKlPoS3V21XzzKxsh/S/MwA48T34tg4TNqFtLTMLfqurzgXwwdZIK3bp
         tOfh0J1x6HemeW5UE4cKaucFxCo6gOlZ3aBYcEn/KxVDfZyWa87b//ftH9AZwEZi29gA
         hjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XHG/8raY/sNsCvqJxNKRfA970Dv5Wyt5EYrzke/beHI=;
        b=YvAv7y2Tcqs4oshjky4nVV4eqzZ3cZiUCPAIaNpRyDWP6Vq36axoikCPnPPgR/lH2/
         7/GgeEsZjoyXSe8C7JYmHvASi9Fj3HGyv/BWAENRqsJ0P5a8gnCXa55lmNX0p4M7Hq4s
         1lgvSG5l6KpR2Km6b1mPhrI+hFNGfM65l2tUJrcLprorztWe2MC/azMlgnZ6lQ3DGT3h
         /i2QdOp8F8q+67pn0tAoo4ngMkgnEGdt1t+DL214lDQMBvqENwG0Sc5CEtyRpPObUqWN
         O50NBnl/yLOGZaK0P9ioDCYaCSYfvt0fcvutncqiV1sM0n7tHHfZVnY+Vf5Gj6DR4dbh
         Sk6Q==
X-Gm-Message-State: AGi0Pubc5EFCKZS5hErijGln7AgoMRajrywqXaV7zMFIBS4BP23+H8NG
        MPxSMvnRiOrUdLc7UlrCTBv4wjJ92vw=
X-Google-Smtp-Source: APiQypKT6U5iFWVWGfBb8r2IYcT670b2zDQ6YjkSiDSmQiKGrbBpFpAeMuVc2nS2y+e0N0qtu45rvQ==
X-Received: by 2002:adf:9d85:: with SMTP id p5mr22726396wre.101.1587901983275;
        Sun, 26 Apr 2020 04:53:03 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id g6sm16387565wrw.34.2020.04.26.04.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 04:53:02 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly
Date:   Sun, 26 Apr 2020 13:52:55 +0200
Message-Id: <20200426115255.305060-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve handle_external_interrupt_irqoff inline assembly in several ways:
- use "n" operand constraint instead of "i" and remove
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
index c2c6335a998c..7471f1b948b3 100644
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
+		[ss]"n"(__KERNEL_DS),
+#endif
+		[cs]"n"(__KERNEL_CS)
 	);
 
 	kvm_after_interrupt(vcpu);
-- 
2.25.3

