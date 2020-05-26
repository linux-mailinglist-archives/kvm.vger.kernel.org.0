Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C41C3F2D
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgEDP5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgEDP5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 11:57:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8275BC061A0E
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 08:57:15 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x4so55969wmj.1
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 08:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X1WqU9HNBXbnLtwhNjQWNZBJ+A0XFPN2T0T20+XM+FU=;
        b=r6p8lve4t2fTdGX29pInoSZbKrDADNQLJHVOm5YwQAq13OxxihnpYfNa26bdga78Fu
         ig2KRr7cXrtrbbN6EHmOHn5k/yiU/5pkXmj8Au9iT0k0lmTQVLYxOGumAE/qaTxX1WD/
         04grJ2RIN6sPqnYqSFmY+TKbTThrCVzWUr5jiygcW2WRzdt3CpCkR3OD2qELX6NSGnnB
         QBmF1V7qT5DkGZ4TBwSLBqm7+RzRQzgfugo4YENi0gIHRRiBkb9jpQzGrvOHZOlN0OrW
         UtYr6Mc/g7hoD5WxiXLkzwdVEgk2AjZc4Y+FgOyv7VeHNv4w8wpxJw3H6YATh+P16J16
         BmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X1WqU9HNBXbnLtwhNjQWNZBJ+A0XFPN2T0T20+XM+FU=;
        b=OpV7zo7EJtVc6xhEncC/lqzt0/JhH9XVK0uljIMkE+h0uHC3HzAoExRiz7BrB8jxEk
         MV5uTnygqh+KsvPK9xzUmcHoOwGwVmJ+A6y8xhJTYzmPrdNiMwdsVrHsost8q1HZ55D9
         t+HfrclIdgR1armsxMspXQooMX/xzcGKCalvtWYJ7PKBFPoXxHUepc3Nn3UKQ8Sg1Wqb
         wvgjrRLk+oefKKaEtBq1Si6iWV8zLsGIixwmGJFdK/qegcajUWUrHksEeMzkyupIkWUN
         Lk8q423OGbQAeuAq0hV6xqBF7nBYBY5V4G4crPosE0jPrUXLLxd/KEyg3oKw1D5cf22W
         zRhw==
X-Gm-Message-State: AGi0PuZKnT/l7EoJ6a7MbTP+c5d0RAgfkDOi0hPX20yQDjo5RVAcKRav
        vuJY945T7HDVB+2x8sCGEOsrr/t1Q88=
X-Google-Smtp-Source: APiQypKGX0gm27mN8Mfsm008qocKLMe8Tj3esRGrj9PoTav/ZRjxJ2U+Z+V2Z5ZI20gabDwH65ao0g==
X-Received: by 2002:a05:600c:218e:: with SMTP id e14mr16453544wme.140.1588607833947;
        Mon, 04 May 2020 08:57:13 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id n6sm13827545wmc.28.2020.05.04.08.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 08:57:13 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v5] KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly
Date:   Mon,  4 May 2020 17:57:06 +0200
Message-Id: <20200504155706.2516956-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve handle_external_interrupt_irqoff inline assembly in several ways:
- remove unneeded %c operand modifiers and "$" prefixes
- use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
- use $-16 immediate to align %rsp
- remove unneeded use of __ASM_SIZE macro
- define "ss" named operand only for X86_64

The patch introduces no functional changes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..22f3324600e1 100644
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
@@ -6298,7 +6298,9 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		ASM_CALL_CONSTRAINT
 		:
 		[thunk_target]"r"(entry),
+#ifdef CONFIG_X86_64
 		[ss]"i"(__KERNEL_DS),
+#endif
 		[cs]"i"(__KERNEL_CS)
 	);
 
-- 
2.25.4

