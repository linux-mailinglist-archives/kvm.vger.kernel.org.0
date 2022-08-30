Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C305A71A9
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiH3XTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiH3XSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:24 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE0F9DF84
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:52 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d62-20020a621d41000000b00537e06bf5e8so4315717pfd.10
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=iFnSRJpXZ6ws+enk3niGAa+sQbQbq4VBntoKsU5VXE4=;
        b=J8t21ciPb4uclzBy8RdolHh16L4uHjSPlAR3W96eGY1NRgq0bwUnGyIb7/xB0zD6Mm
         t/Ekl8MwSi7XCmEjDayXQ66uLNr8dGluPrZS3VFbzGyvmcWjXi9ghNIf+szUOS7yv96Y
         ocFW1euJKtywYavEfbL0oQzuzrI8Q9YxOfyRl1dU/vxjJzyM7YV3K14yHzyLRLQPt12Q
         QpopCaiT9/frav6Jc0lR+u4VUsuCI0t3+brnQiGsxhf5Zfi4WHZjxYU2U5t7op40WobX
         hcgV/BsLdyyDtBPvyOoGr3A+jRCIYyLKCudgDC0XkCtx9uutRUd3A2fU4CVhGS8Tl4hZ
         ObdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=iFnSRJpXZ6ws+enk3niGAa+sQbQbq4VBntoKsU5VXE4=;
        b=HcbOa02zunCnEB4C8ok9WF6h4IAukHjSuGEoVLXsz/AgL9XCHhw2vAqLwwLqQLpNYL
         GFkjFqraOfvjPspRPFAa5NSkaxdt/BsqOwlx/0f/n6PVTEwrLRKUwbOsTm6xxLsYYxMq
         n2VzSu979bleTCC7478Kh5uqR8HUSlGnR6AvzDfd8Hcx1Jf8c0tmY6ZcMYF01AcnRZ5Y
         MTqkZR8MGSGe9b3Lerto6MRL1OVCDah6RGsae3owYMIGVp2oedivgFrkDu/s7kTW+/if
         Pt75m9TCYx9xTnAqd+G74VLvqBJv/tn3zRMD/VQ9FshomGbBqfAVdWtNJNmDNNa5hFrW
         BK5A==
X-Gm-Message-State: ACgBeo003P1iAz7EZsx6XU5NCj/sLemqOwGyjcu2d+iUW2tezRpW83Fn
        6u1qwRk+cUSXdUanqK0Ru6UdKA3fnkg=
X-Google-Smtp-Source: AA6agR5R7oF/e8SX6fs9t5XZLnurDaJZQwlYr9DoRuTdAPN9YKHOa5hFo6PDErSi/a1WPPTEyT8/sEFd4qw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa03:b0:172:9b18:ebb1 with SMTP id
 be3-20020a170902aa0300b001729b18ebb1mr22182966plb.24.1661901402413; Tue, 30
 Aug 2022 16:16:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:02 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-16-seanjc@google.com>
Subject: [PATCH v5 15/27] KVM: x86: Formalize blocking of nested pending exceptions
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture nested_run_pending as block_pending_exceptions so that the logic
of why exceptions are blocked only needs to be documented once instead of
at every place that employs the logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 26 ++++++++++++++++----------
 arch/x86/kvm/vmx/nested.c | 29 ++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8f991592d277..a6111392985c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1356,10 +1356,22 @@ static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 
 static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	bool block_nested_events =
-		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	/*
+	 * Only a pending nested run blocks a pending exception.  If there is a
+	 * previously injected event, the pending exception occurred while said
+	 * event was being delivered and thus needs to be handled.
+	 */
+	bool block_nested_exceptions = svm->nested.nested_run_pending;
+	/*
+	 * New events (not exceptions) are only recognized at instruction
+	 * boundaries.  If an event needs reinjection, then KVM is handling a
+	 * VM-Exit that occurred _during_ instruction execution; new events are
+	 * blocked until the instruction completes.
+	 */
+	bool block_nested_events = block_nested_exceptions ||
+				   kvm_event_needs_reinjection(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 	    test_bit(KVM_APIC_INIT, &apic->pending_events)) {
@@ -1372,13 +1384,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		/*
-		 * Only a pending nested run can block a pending exception.
-		 * Otherwise an injected NMI/interrupt should either be
-		 * lost or delivered to the nested hypervisor in the EXITINTINFO
-		 * vmcb field, while delivering the pending exception.
-		 */
-		if (svm->nested.nested_run_pending)
+		if (block_nested_exceptions)
                         return -EBUSY;
 		if (!nested_exit_on_exception(svm))
 			return 0;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbbe62a84493..4bc2250502ea 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3899,11 +3899,23 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qual;
-	bool block_nested_events =
-	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long exit_qual;
+	/*
+	 * Only a pending nested run blocks a pending exception.  If there is a
+	 * previously injected event, the pending exception occurred while said
+	 * event was being delivered and thus needs to be handled.
+	 */
+	bool block_nested_exceptions = vmx->nested.nested_run_pending;
+	/*
+	 * New events (not exceptions) are only recognized at instruction
+	 * boundaries.  If an event needs reinjection, then KVM is handling a
+	 * VM-Exit that occurred _during_ instruction execution; new events are
+	 * blocked until the instruction completes.
+	 */
+	bool block_nested_events = block_nested_exceptions ||
+				   kvm_event_needs_reinjection(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
@@ -3942,15 +3954,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * for TSS T flag #DBs).  KVM also doesn't save/restore pending MTF
 	 * across SMI/RSM as it should; that needs to be addressed in order to
 	 * prioritize SMI over MTF and trap-like #DBs.
-	 *
-	 * Note that only a pending nested run can block a pending exception.
-	 * Otherwise an injected NMI/interrupt should either be
-	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
-	 * while delivering the pending exception.
 	 */
 	if (vcpu->arch.exception.pending &&
 	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
-		if (vmx->nested.nested_run_pending)
+		if (block_nested_exceptions)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
@@ -3967,7 +3974,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (vmx->nested.nested_run_pending)
+		if (block_nested_exceptions)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
-- 
2.37.2.672.g94769d06f0-goog

