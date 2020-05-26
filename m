Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F8F1C303C
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 01:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgECXGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 19:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgECXGC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 19:06:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC2DC061A0E
        for <kvm@vger.kernel.org>; Sun,  3 May 2020 16:06:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so6816032wma.4
        for <kvm@vger.kernel.org>; Sun, 03 May 2020 16:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVr7vzsal3m7P4Y5nEVSiXRYbrfFcH85cwwpdr26ZwA=;
        b=PeU7ScfBMxPlh1ueMzgw2R52MggxaS7bWMZXO5gkDaJt4FTVW9seMMBLs+ElbvDYvC
         WWOUkrX9kRV4OrRmLZ96EQmGiu/Ztq2dRnNtwWJ3c2FMEJr6viKbNjLSg8wkAMUdR+DS
         SAh54vjYJrQimB3iHBQ/KHNKqWVCdCgBV4YatfTrZkQ9xTENn5za5ZhUjDhf66nkbGlT
         L86qo4qz9N8ct9gc1iuz/SQBdoyta1B4JBS/R8BF8BWrjg2z+d/+sodC2SrsD6naZ5VP
         2T1PjgLTk6X9ooSyiEFEA4RkQMnPzIi7GpCB7WB0i7oeTQ8Qov4mwzEFR+nCg48qbNfh
         r07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVr7vzsal3m7P4Y5nEVSiXRYbrfFcH85cwwpdr26ZwA=;
        b=jvgUUK8AQvCzV0YOGwDsTPBNUJXxqn4rQ/Meya9fYEMayxP1XCZt3fPOwy7qnXIle1
         3rFxe3/v9sX7yXmQ+z7V6SyGpdVYyutuzEbxRYKg7jLxqQ5DuRQ+bhVLWKmiOFm4HxJ8
         LabOMi2tcveeMwt+MKA2bJ3KtWM6aGwMQfR1f8QDmo6yx7Gg1mEGxC1veLMcLJlkitgc
         /IfsViqxcxKG20gnfGojQRg+4UctuoKvVsbK/siZbGcTOqQqwmSkGfU6ZkSV+whLEMwa
         oysW/QYPg8NaAumD9955+EQBP+xlRJamP87nVwcm7JxjgroP9fyx/2iomVJ2t2twcxac
         ASkg==
X-Gm-Message-State: AGi0PuYoZQKuuRg0VPgQ5zT22+/WWs5qWReYUn2MW62ULXTru/s1pMt2
        rPe2JXdRQJNUw5QqY9+plwI2mJj/zPQ=
X-Google-Smtp-Source: APiQypI0g0GbAX/X9FyPgeAwt4W5oaUJq8QnfPndKICqtWvW/tDZeublhRb0I5LjAIJmcK19pB9lRw==
X-Received: by 2002:a7b:c4c9:: with SMTP id g9mr11148747wmk.171.1588547159664;
        Sun, 03 May 2020 16:05:59 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id c83sm12044677wmd.23.2020.05.03.16.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 16:05:58 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4] KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly
Date:   Mon,  4 May 2020 01:05:45 +0200
Message-Id: <20200503230545.442042-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve handle_external_interrupt_irqoff inline assembly in several ways:
- use "re" operand constraint instead of "i" and remove
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
index c2c6335a998c..56c742effb30 100644
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
+		[ss]"re"(__KERNEL_DS),
+#endif
+		[cs]"re"(__KERNEL_CS)
 	);
 
 	kvm_after_interrupt(vcpu);
-- 
2.25.4

