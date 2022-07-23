Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B05357EAD0
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiGWAxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiGWAwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:52:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352C59FE38
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:03 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e11-20020a17090301cb00b0016c3375abd3so3409253plh.3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=U+ChLRWvMU/fIzZxpmNafRsKDwWA1g7ApLuxjnHhUZw=;
        b=lnvvi6aa7qkzYWZk5ceD+06rKpRg2vHyB1FYeqp/jy3gVBz7Gg5MWxOI5pwtUJUNgF
         NVGCj2O4ldzkSd/aYhj2n34ZlXaI5SOOfQxeez6k4YQRWHZU2Y1gUQzZFy298fusg7uU
         Q6XrVS0ST21JcyhFJqqcgFugswcXL5Q1o4PaRsCigS8gEp7xEA5aClFoEC14OiKM6V+h
         iDRMF8ktBgdsgReZTMKf7kknJYgcAhoChtVSSYOQ3/IuzraPrIqrD6Sgv+aR3zoCogSx
         8Zy5AvfslloJ228W8iFuFjqf2NtageRNDCo4Owp8cj43X3RxmT4wG/6IzopxhGaNtoZm
         SMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=U+ChLRWvMU/fIzZxpmNafRsKDwWA1g7ApLuxjnHhUZw=;
        b=2veuqIQ5X9QfRzNa+qUgB/xROHghpUOgCaYjEJTKIl7pfcDmbM7VNH5+p11lhGN2Xx
         B2FsbrqUMusX8Trq+Rjf66BpwCg70IN5Vlt3XKg9Fnz4PciNvruA6jUge2LkjnFZQY6H
         4cwdO2ajidO08eOCaHJfga4XUermpvLTtzRZEsXm7lmIkRpvZAygNO43gjw1iMfxUoIi
         /PV9KuEDFKYccVZZ4+DsgskHNsd8FViTOqKnytgvqry7bRFPdQGkWJAS4DjQfFWrD1Gj
         FqlXQdVkOwdSyuCmr8gNVrR//IrtBq6JWuPP6iKFPTRpZAY/WQfhF+8UbVWGthIP3yw4
         4hIQ==
X-Gm-Message-State: AJIora/seCftRJSOmUyQ00EvdQdKJfqup+r+pW+jE57eWDPklMhulujK
        1/Lj+YbkjsDeJXEel+vTWniabQc5/NY=
X-Google-Smtp-Source: AGRyM1s771km4rIGBISQqnv/L1ZFT5Xnbynw2dphoKMl6hBPyElH4HxpmYrg266gy0UCvEi5DIuMCneei5g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2310:b0:16d:38b9:2c78 with SMTP id
 d16-20020a170903231000b0016d38b92c78mr2086921plh.122.1658537522968; Fri, 22
 Jul 2022 17:52:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:26 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 13/24] KVM: x86: Formalize blocking of nested pending exceptions
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 0f5a7aec82a2..361c788a73d5 100644
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
2.37.1.359.gd136c6c3e2-goog

