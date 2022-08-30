Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9385A71A2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiH3XSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiH3XSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C84A2866
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:46 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-340e618b145so122163377b3.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=deckfdT/A/DPIznZY3aZvebzVPMaF1XxbtwHCNkJXFI=;
        b=Bue2rck+1YunO2USXcMoE1HA228yX08f9TqadNQEE+1XGV/0FP+x7Gu2Zo8TpSgiz4
         q+DdM/KnrnqLdr1/zmpW9ECG/C4QTM8BAqtQUnd4rQ2Qlz+c+l7gsF9ZSQYEjlc57WdK
         LcT+eY92SK6L/Uw3+4no8UqI99ijE5F8OqW6mnnT/SVsrd+2FglDkg+FPnYM0DKxjhh5
         oTZWMVgowRj6+bpMLu4+5t7KIIc/GstlnIHbGMafa6XSX/ECrjnBDBiLXfR4hKjdK5K3
         gJGUaDGLCAbtXUXqTmhMB2sXWhdswVkcqKGDegMBndHQMx0SQhDFkvdN3UAeB+iK/CaA
         C6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=deckfdT/A/DPIznZY3aZvebzVPMaF1XxbtwHCNkJXFI=;
        b=x2NJkREMMc2wMGmZ4yCAy6iruCq3n50eEgLZg4gEzSgG+rghuQ9IC8N1EeYIDE45Zr
         Batckv1xL0D74nP6Ib7K09UG79RCCTPe1yG99UTI3Y6lgz2NTzIuxBz2l5NeQ2yfo5wJ
         ffAAFoWJqjVtc+JizxhLgeJrfJyF1agAX8FSVI+XJ2CSnhGUzEEsOVQ1j1eHhE7F8OmB
         ACAq0b83z2IiG2p5sAynI+POt2h6Bay3jV2+OJbL59nlbVO33yoKw3GWCogK7m4r/BgA
         BUFLMtwSpMerlBg/nXbJm7GGH+PDAzGWGMn4lHfisOrddCksnfLMyXnnXFGf3uX5tPMt
         Ywhw==
X-Gm-Message-State: ACgBeo3gQxMKIK5/ylFqn8g5mnCgKdy6turjkyDktAChJFS0tHARAnqI
        sl/Kg8UORwmeyvcHB7WP4O+XWD5V2bs=
X-Google-Smtp-Source: AA6agR5PKKNgKEUCmv1CKdtSY4LvtPgGItctt3djDy6IoIEgN8l1lxsBwv9cqAVr5TR0V47Jd6tKWHdRgEY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100b:b0:695:bd4e:95d6 with SMTP id
 w11-20020a056902100b00b00695bd4e95d6mr13920950ybt.595.1661901395593; Tue, 30
 Aug 2022 16:16:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:58 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-12-seanjc@google.com>
Subject: [PATCH v5 11/27] KVM: nVMX: Unconditionally clear mtf_pending on
 nested VM-Exit
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear mtf_pending on nested VM-Exit instead of handling the clear on a
case-by-case basis in vmx_check_nested_events().  The pending MTF should
never survive nested VM-Exit, as it is a property of KVM's run of the
current L2, i.e. should never affect the next L2 run by L1.  In practice,
this is likely a nop as getting to L1 with nested_run_pending is
impossible, and KVM doesn't correctly handle morphing a pending exception
that occurs on a prior injected exception (need for re-injected exception
being the other case where MTF isn't cleared).  However, KVM will
hopefully soon correctly deal with a pending exception on top of an
injected exception.

Add a TODO to document that KVM has an inversion priority bug between
SMIs and MTF (and trap-like #DBS), and that KVM also doesn't properly
save/restore MTF across SMI/RSM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d11c785b2c1c..51005fef0148 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3905,16 +3905,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
-	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/*
-	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
-	 * this state is discarded.
-	 */
-	if (!block_nested_events)
-		vmx->nested.mtf_pending = false;
-
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
@@ -3923,6 +3915,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
 			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+
+		/* MTF is discarded if the vCPU is in WFS. */
+		vmx->nested.mtf_pending = false;
 		return 0;
 	}
 
@@ -3945,6 +3940,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
 	 * could theoretically come in from userspace), and ICEBP (INT1).
 	 *
+	 * TODO: SMIs have higher priority than MTF and trap-like #DBs (except
+	 * for TSS T flag #DBs).  KVM also doesn't save/restore pending MTF
+	 * across SMI/RSM as it should; that needs to be addressed in order to
+	 * prioritize SMI over MTF and trap-like #DBs.
+	 *
 	 * Note that only a pending nested run can block a pending exception.
 	 * Otherwise an injected NMI/interrupt should either be
 	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
@@ -3960,7 +3960,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (mtf_pending) {
+	if (vmx->nested.mtf_pending) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_update_pending_dbg(vcpu);
@@ -4557,6 +4557,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
+	/* Pending MTF traps are discarded on VM-Exit. */
+	vmx->nested.mtf_pending = false;
+
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-- 
2.37.2.672.g94769d06f0-goog

