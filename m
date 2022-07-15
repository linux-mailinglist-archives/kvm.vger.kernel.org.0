Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00F657686F
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiGOUoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiGOUnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053DA88CC7
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:04 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 81-20020a630054000000b0041978b2aa9eso3220231pga.9
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Lq65jfR1J24WG80xh7f4oCkNLp9qIGLfz1I2sdOomcI=;
        b=L1iwONfh7mL5wU22om8aMrBMCr4v/wnGihmY3U7X/22jj61m9lAngjjE+C6eIU4oV2
         ww1oaIvbkIRIyEkOXgXFyospMgGm8/nepPGyATM2/bIHqTAHwz80N4yhc7ltrUjFbktC
         rzToK8WPn+tI2E9T08zthS4mcPAs53gKBA+7etTsbsVRwLcia+u8TNHzC/4wCZCQ3Xr7
         3jSkLsJVw714RJmPpiK5HhcOupooF5GoWi4Vfbe3Odz1z0Effi7p49XHbDe+R8CA9Upm
         +zeXGcQRyyjf5L4OcJHMUkIc6iZyAnYfvNIEG8l52uwhW3fO5uE5VxgoktDJJkZD4nG9
         bMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Lq65jfR1J24WG80xh7f4oCkNLp9qIGLfz1I2sdOomcI=;
        b=KOZ0uwFQOIApx5KUd2lrZ0Hty0+YkE6BFRxpm3wkn031kVN5AlfKtj4EPNHoFfSw3q
         OcBtkT77G8b9k+B27wNrxztQcgyj/PKq54NE/MHEeOS7y0oHbCoelm2k2pFacw0pYlCu
         gI3FX17Rt9+xeAhTInmUUgB526nFFYTKGYvXsi8bUXuGR8/9DlK9a5wa80c+ueeY45Lz
         gsc0CVxqcrIHcjHceTQBJ1CcQqGxFlXKu8WT42y44kXCg+ftlOKSti48gW0rDH6u07Ml
         xk4u6karIFNSMVv9bIUsb/jpHkCUbTeLycthKuDXB/x0cJ7iB6teW+FK21OgSOUzYsiX
         1fVg==
X-Gm-Message-State: AJIora+G6/CcBmdPZEY9lntcyWfS5jMKNT99RzsLGAy0kGAQ0OpPoRlv
        8nQByOK1T42ELeOH7w04fA8YVp9TqCs=
X-Google-Smtp-Source: AGRyM1st6mgXvo0WFhUvEDhm3y41jlJPs/tvJL6MUJBfM+OteBRMgKWq9ce2ywOy6/kDBOSGZnIJcBVyQJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fe0c:b0:16c:1683:2dfd with SMTP id
 g12-20020a170902fe0c00b0016c16832dfdmr15043777plj.24.1657917772681; Fri, 15
 Jul 2022 13:42:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:13 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 11/24] KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm.c             | 4 ++--
 arch/x86/kvm/vmx/vmx.c             | 4 ++--
 arch/x86/kvm/x86.c                 | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 51f777071584..82ba4a564e58 100644
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
index e8281d64a431..dbb9eab979d4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1523,7 +1523,7 @@ struct kvm_x86_ops {
 				unsigned char *hypercall_addr);
 	void (*inject_irq)(struct kvm_vcpu *vcpu, bool reinjected);
 	void (*inject_nmi)(struct kvm_vcpu *vcpu);
-	void (*queue_exception)(struct kvm_vcpu *vcpu);
+	void (*inject_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ba81a7e58f75..a254d3b9926c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -452,7 +452,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void svm_queue_exception(struct kvm_vcpu *vcpu)
+static void svm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -4796,7 +4796,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.patch_hypercall = svm_patch_hypercall,
 	.inject_irq = svm_inject_irq,
 	.inject_nmi = svm_inject_nmi,
-	.queue_exception = svm_queue_exception,
+	.inject_exception = svm_inject_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2b3d30d6afb..34d3f29bfa50 100644
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
@@ -8013,7 +8013,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vmx_inject_irq,
 	.inject_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
+	.inject_exception = vmx_inject_exception,
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 37d686dbb6aa..dbf95dc53c66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9659,7 +9659,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
-	static_call(kvm_x86_queue_exception)(vcpu);
+	static_call(kvm_x86_inject_exception)(vcpu);
 }
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
-- 
2.37.0.170.g444d1eabd0-goog

