Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470471C850E
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgEGIo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 04:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEGIoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 04:44:55 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD8DC061A10
        for <kvm@vger.kernel.org>; Thu,  7 May 2020 01:44:55 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 188so5488947wmc.2
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 01:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PU7avU5KLld7I6xnGMnybddyyBfXBbnu4ZRjbpdICJw=;
        b=WU6iyPzXjetTb4A8FHXJ6TZ1lAnGwZ10FXhgUJdKGf/nLtAQwSN6FLvTLdBCPQs5e/
         haGqya1wJVGSnWblIX2mxmgIMlPRyMw0DndrJ0SSKY8uPY6TL38/7dlRCVxro98jLZwu
         Ytvv2SjUgBOqM7PSMEsDihXoVdIvNdRBau7mxR9vtsLf0ZS2IA5vXPsP0gDwuHDFvHie
         cPpP/i7rIsgZ7ml1NacOfHrM14ZXwqqo77anTzZN1vAInMXJrvJsw/vmM2EGxjx2gGAr
         e/87JXnbI9IkKvWfZCDdRAeVjvKcg++6v1UZLrsGOF3Yje8uaXOQQakkmci4D0Ut679J
         I8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PU7avU5KLld7I6xnGMnybddyyBfXBbnu4ZRjbpdICJw=;
        b=axxlVWgi42hjwfkXlMfgne92ledjXEBJeCzfTVeq5zWQqodyju9i3YJnHi3LPrQZl2
         uuiCJdbzonekRHmzNgFOL4wK6ssgDvxxwmt8QJoIY/ER4/PbYuRbawmJEHhf7OAcJ3hQ
         disZbBjNcXg1BfVx9rveuSB+remLk3pmK9qqa3Nt2L+hMl4c5XgRv6gacT0ACIjIKJC3
         07RBIp5SLvAzfG0Tm2fZvO2DsAdxCSDGYi+fCAcEJWBdBpKQtaUotfNCDm08BGW+X4/I
         VtnkVGj0/tw8uaPKapFma7ocpHACVJXNbVgTeN4eDzEaDHDr1iXwyIYEuUvjQYgiAc9a
         Psew==
X-Gm-Message-State: AGi0PuY8vxvSr4jq2K8dDUaZcYZgEB/rL1DB9Kloyfx8Zm7lw5du0QwG
        8fwsLiu4h5NDgKiFJKzSzCwDOoVKAp8=
X-Google-Smtp-Source: APiQypLXBKZPf9frSIx0Q/EiP927405tYWl11FO5QPPY2TAWgxz6TxS3Jw5pmSuBRdIitGL8IRV8PQ==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr9158534wmy.30.1588841093739;
        Thu, 07 May 2020 01:44:53 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id f26sm6943031wmj.11.2020.05.07.01.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 01:44:52 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2] KVM: VMX: Fix operand constraint of PUSH instructions
Date:   Thu,  7 May 2020 10:44:37 +0200
Message-Id: <20200507084437.321212-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PUSH instructions can't handle 64-bit immediate operands, so "i"
operand constraint is not correct. Use "er" operand constraint
to limit the range of the immediate operand to a signed 32-bit
value and also to leave the compiler the freedom to pass the value
via the register.

Please note that memory operands are not allowed here. These
operands include stack slots, and these are not valid in this
asm block due to the clobbered %rsp register.

v2: Add casts.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94f49c5ae89a..52cb150a9633 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6390,9 +6390,9 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		:
 		[thunk_target]"r"(entry),
 #ifdef CONFIG_X86_64
-		[ss]"i"(__KERNEL_DS),
+		[ss]"er"((unsigned long)__KERNEL_DS),
 #endif
-		[cs]"i"(__KERNEL_CS)
+		[cs]"er"((unsigned long)__KERNEL_CS)
 	);
 
 	kvm_after_interrupt(vcpu);
-- 
2.25.4

