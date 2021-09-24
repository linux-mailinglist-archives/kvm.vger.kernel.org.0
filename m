Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3941758C
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345612AbhIXNZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346038AbhIXNY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:59 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2114C08EB35
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:40 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h18-20020a0cffd2000000b0037e78fb2552so30612113qvv.12
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i7uodwfDnDtJuiTS9rXdXYViFWYsjMsbxF8IoeW8/W4=;
        b=qF3Vw4AceYdu1L0PZ66LcU5WQ4Q0vt8paDyr76neaIiU7PKYTbrZLZonVtIrIyRczb
         DU5SbrytlGhkBB1E+t5EqBtBbVrDhV4CyzU/EB8ANPxuMebR0qF/QjT8hLecRLcdlZgw
         A3lfSu8T99yQYr4bozntQ9WdVOsOPmEACfCRd0tfsFq6yXyqa5QjOxnbUZyAZx0Kx8ue
         PsVAFTS6kdE4EA4R/FbZWcnFQc+koZXhZ9EpQ3BLPMpc8IFYdDeyrGBI8gHWC3W4GLB6
         P23Dlf8ES+p3OPOy3TiDL1x4KbFHLYAOvn+XGfAEiu3h6LwChGcFLWCRFl12kwRSLS+3
         ctBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i7uodwfDnDtJuiTS9rXdXYViFWYsjMsbxF8IoeW8/W4=;
        b=LiZIPIR7NIzVCQd1PrSESDZrnsBzHIfC8FcRvdhQ0YfyogHWv7jwdgAzCLh0meMMAT
         inxQqVFf/mXNeIYxvAbYH+HKmlHZPrPU/ztuhf7uYeMXzBfZnKIgiBU9la/MrxtfrSrr
         3wufyg5Rt8hMMTtOQ1wyr21lYST9bUhZ80qH6865D/iwjjCKA39xwPROPUa49sFmHzqg
         eUdOzxcLx4sjQDDC/BjZ06vZS6S+mY4wzCbANYkJn1FkVJ9bE/GfqdWXJvnDQYlRJ2wS
         5c9w5MMI4afZ+Dqus5+MyngOIjJXERijPfrD06OJoaP/cEKRYoaJSfiB98E5bp1XyyW7
         jxhA==
X-Gm-Message-State: AOAM531v4BWW7aw2gTsucQ+EibSnKIjrphDqyaZBQrprd35cHJ7MiURx
        VosI2bGyDAGoTJtbZ3JqKwRdajOqWA==
X-Google-Smtp-Source: ABdhPJyK06uYrGrDSvLnw7I0yxv76y3TWXx+xyK98z+cTJ0e/eyHwuj1vePAtlEsCveTt5zBbE9Rk8ddCA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:47a3:: with SMTP id a3mr9927375qvz.31.1632488079831;
 Fri, 24 Sep 2021 05:54:39 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:47 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-19-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 18/30] KVM: arm64: reduce scope of __guest_exit to only
 depend on kvm_cpu_context
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__guest_exit only needs kvm_cpu_context (via the offset
VCPU_CONTEXT). Only pass that to it, and fix it to ensure that it
only refers to kvm_cpu_context rather than vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/entry.S     | 7 ++-----
 arch/arm64/kvm/hyp/hyp-entry.S | 8 ++++----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e831d3dfd50d..996bdc9555da 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -99,15 +99,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	adr_l	x1, hyp_panic
 	str	x1, [x0, #CPU_XREG_OFFSET(30)]
 
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
-	// x1: vcpu
+	// x1: ctxt
 	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
-
-	add	x1, x1, #VCPU_CONTEXT
 
 	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5f49df4ffdd8..704b3388c86a 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -71,17 +71,17 @@ wa_epilogue:
 	sb
 
 el1_trap:
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
 
 el1_irq:
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
@@ -100,7 +100,7 @@ el2_sync:
 
 1:
 	/* Let's attempt a recovery from the illegal exception return */
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IL
 	b	__guest_exit
 
-- 
2.33.0.685.g46640cef36-goog

