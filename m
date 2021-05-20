Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE0238B9F9
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhETXF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbhETXFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7590AC0613ED
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id f8-20020a17090a9b08b0290153366612f7so10018994pjp.1
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aBFa8ajwJCwrX44qQPRgic2A0Aj9+F6IN0aDIw7SsiE=;
        b=K/Uwbulmu7yxdEXoEYu5G63siO16GsGEkUYM5KL7eIAIfmnM/fW2hlkitInu3BRtaY
         JG1uQwXIZJ7zDL72bEBgGnxFCrT6mP3GSEuUiVEbPIVO6czDQTWh2NaeE3pGdFdUvHI/
         0qRDCIyfADaXRcw3t1tW1M14kc5IIV7nUetulwZm8SdDoNAejlr+zkrslIUa3tRTAcfM
         JX4qyXJNN7d31pj1VE/2mp08fcFFRpdkKBU0F+AwtGC38ygj94Y1+w/KXixLeg07qCHW
         Cj6XqnAkkcEp0VAmIfCskAD67+W4iK9umXvYeYu08LDLxhtdAeLKQ7RSP9FtP9grlVDh
         ROeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aBFa8ajwJCwrX44qQPRgic2A0Aj9+F6IN0aDIw7SsiE=;
        b=pI/aKHInz+v3jbj0vrQ1t9Rdi4De/uqf6C2Gtf9Nm2FEGvBo68c9b/q0lNSb9vvOWE
         xB7aOHUshquuLQ0+on94UQJ7mDnclbuLq92DPZYI4vW1uPrDF+NBlZlO+MTUu6K0U+1O
         jPVj0urpDr4cOpd1NyMlKLpcRSgmTKTTRiDvmvTLPzlFEQHmg8r/O7N+kjZN4TgmdPoO
         wszu2ppfLPf7cMqjxYSeJEPl7g8WAN7P/jfloTuP5krouCogHon5NOAjcanwdQoShIM6
         LBRbXN0cGDctXmwYsC4Hf00ME9U+OGCBoyxgxLd+xMgvwTvvuPTqv1EcDylAAF2Vazde
         PF0g==
X-Gm-Message-State: AOAM5330/pwthKKkQ9RdyYhYUg+c/xgLm/05c87436659585nAI/pxHv
        RbCu8dRXRxC/bfxyjJjssh/jX+gJkfsW6tpPWCbEhGZuqHCeJqZwaBn3GQH1q4Yr3am3nl2b0J1
        FCRtLZg4GNeadM+dpsIuM0+XHyZs+l55wrZ+5M1+RYZgBsjjp3s6zA5O7jaq1kIU=
X-Google-Smtp-Source: ABdhPJyByHNYiGqwo88rP8wMWG3XiXvn46lUFfNTAKiuySapBSwgRaVFzvqonTiYPP1DA7V3Iq3RqRKdedQlRw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:aa7:8198:0:b029:274:8a92:51b5 with SMTP
 id g24-20020aa781980000b02902748a9251b5mr6849383pfi.5.1621551841840; Thu, 20
 May 2021 16:04:01 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:33 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-7-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 06/12] KVM: nVMX: Fail on MMIO completion for nested posted interrupts
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kernel has no mapping for the vmcs02 virtual APIC page,
userspace MMIO completion is necessary to process nested posted
interrupts. This is not a configuration that KVM supports. Rather than
silently ignoring the problem, try to exit to userspace with
KVM_INTERNAL_ERROR.

Note that the event that triggers this error is consumed as a
side-effect of a call to kvm_check_nested_events. On some paths
(notably through kvm_vcpu_check_block), the error is dropped. In any
case, this is an incremental improvement over always ignoring the
error.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7646e6e561ad..706c31821362 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3700,7 +3700,7 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	if (max_irr != 256) {
 		vapic_page = vmx->nested.virtual_apic_map.hva;
 		if (!vapic_page)
-			return 0;
+			goto mmio_needed;
 
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3714,6 +3714,10 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 
 	nested_mark_vmcs12_pages_dirty(vcpu);
 	return 0;
+
+mmio_needed:
+	kvm_handle_memory_failure(vcpu, X86EMUL_IO_NEEDED, NULL);
+	return -ENXIO;
 }
 
 static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
-- 
2.31.1.818.g46aad6cb9e-goog

