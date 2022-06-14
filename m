Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A2654BC22
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353132AbiFNUsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357701AbiFNUsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B9520F45
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so5384920plg.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DvS0MK4rYpRtDe2fvh6ocxKN7mSQ+xkrM2pZGwGEGi0=;
        b=LJ3wp6JDRHV6sVfW5nAnFe2WOVDe8Ns3OwIoQoyRTK5yehEbrFRdZs26rivPhQZQmz
         HjW26zNG65VF3UfxnITX6UHlAA8Ft1CViBPyP04rGrZhWk2XPYHmceiYEV6pjJ+lxv7J
         nMIbdutaWyeQ5Vn5A8q4o6TpoyFLhxhJClmTHg9TcFJQNnkOiWVTqDoJ+DKrCFOZ2s9y
         2zzdNBHsJ+mbLn5XCilMcCW28Q25oqG2cUt+V7b/Pf06lI47rvPIuOo6y/IncdjAz1oG
         xVuv4L2EplswOkw1W4Ba9yuet+wfqYb9xVPv2GUNsbPml9pVy0k8hyngMGPL/h7vuPs1
         uooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DvS0MK4rYpRtDe2fvh6ocxKN7mSQ+xkrM2pZGwGEGi0=;
        b=yvzSec4q/qikArppCa8A9fanKXYXY3HV7Z0J5axWakMwOeMlo20LebImsVdhy/Vqpq
         OCJZmoVp9yxeVT6nz+NEuRXB0EsChPFhn6WOI393579T9tM6KhusbGeO0IcB1NL4QDrb
         nHEx+I1Uk89tEuxQVFsd3LBa4JhVz5zaefsiZgS4ctBEcm33sTyW1HwGTn7tNgKe6sJ9
         ccvpgoTHMmY7AG+UqgtVw5sHuf5N8QdLm08E2Sy1L96HoCYTghvHhwTimKMKKQ2ZU0gf
         W3HGmMIKGl1anbe1SqOW3xb33zTSqdDMMUIkh97H9zDEmv19/cDAh/LfQJr0dpRIgXmq
         t0Pg==
X-Gm-Message-State: AOAM533KE/mMChoR5d+unEiChJoAf+XQcP3DB4TXMw5hlat9HJMzweKx
        eDiVyRax0BV/KoxixQgBxo7ly9YnCLg=
X-Google-Smtp-Source: ABdhPJz4ke7bLqZx/KSNR4w7UoBgnHY5w/YAjtmqQr7Qf5jooPhCshyLJvD01vl3B4TVrPipJWjHkDsd7G0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a03:b0:522:990c:c795 with SMTP id
 p3-20020a056a000a0300b00522990cc795mr6250999pfh.15.1655239676339; Tue, 14 Jun
 2022 13:47:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:20 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 11/21] KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the kvm_x86_ops hook for exception injection to better reflect
reality, and to align with pretty much every other related function name
in KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm.c             | 4 ++--
 arch/x86/kvm/vmx/vmx.c             | 4 ++--
 arch/x86/kvm/x86.c                 | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 6f2f1affbb78..a42e2d9b04fe 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -67,7 +67,7 @@ KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
 KVM_X86_OP(inject_irq)
 KVM_X86_OP(inject_nmi)
-KVM_X86_OP(queue_exception)
+KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e98b2876380..16a7f91cdf75 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1505,7 +1505,7 @@ struct kvm_x86_ops {
 				unsigned char *hypercall_addr);
 	void (*inject_irq)(struct kvm_vcpu *vcpu, bool reinjected);
 	void (*inject_nmi)(struct kvm_vcpu *vcpu);
-	void (*queue_exception)(struct kvm_vcpu *vcpu);
+	void (*inject_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c6cca0ce127b..ca39f76ca44b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -430,7 +430,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void svm_queue_exception(struct kvm_vcpu *vcpu)
+static void svm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -4761,7 +4761,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.patch_hypercall = svm_patch_hypercall,
 	.inject_irq = svm_inject_irq,
 	.inject_nmi = svm_inject_nmi,
-	.queue_exception = svm_queue_exception,
+	.inject_exception = svm_inject_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ec98992024e2..26b863c78a9f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1610,7 +1610,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
-static void vmx_queue_exception(struct kvm_vcpu *vcpu)
+static void vmx_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -7993,7 +7993,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vmx_inject_irq,
 	.inject_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
+	.inject_exception = vmx_inject_exception,
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c3ce601bdcc..b63421d511c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9504,7 +9504,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
-	static_call(kvm_x86_queue_exception)(vcpu);
+	static_call(kvm_x86_inject_exception)(vcpu);
 }
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
-- 
2.36.1.476.g0c4daa206d-goog

