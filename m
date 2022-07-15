Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC7576877
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiGOUoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiGOUnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:25 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF14489EAD
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q4-20020a170902dac400b0016becde3dfbso2615757plx.17
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y6jCF48MVo5fuzjN3mvXwjtKtvMAQ8JrrLuQpGVNpI4=;
        b=Spcn0k60rY5UAdqP5D1VRgd7ObmBCpSfMYLDPlhmosZW6NBD1lCA/q0el2X1KduXEy
         Gf1QSsu8hCYCmfJLjghCdQRrjVP+1eRtUd9enMxqSDryUTGNC4xthjKzDwi4WAOC79G9
         eEivs1cSKf+k1XPD0RTYM95YYH39S9BQVwBp0KZdxn52doJO6x+ApuiMChPLmtpFz4i2
         1uFKUYnoOWoPSrE10nVAZ97QFBIyOc1rk/3CZS1RfVSlVvyadyxjZNHzWel83hDlS+WM
         9bVSPWZBHIlGRFEkGZVfvH3SzLDbwQPMjjHky0n4wOgB3jYCz34+tkCj8/zzaVzL1B44
         3FRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y6jCF48MVo5fuzjN3mvXwjtKtvMAQ8JrrLuQpGVNpI4=;
        b=ABAA0zlSvIQ5nIFNjP16MtvM0mmpHQsGBQCordvWd3sanFztb6gM13ecEgl4RoBy4F
         4UKs49+ao7ItK3nS2kw4zSKV2KaqjolmpQy5XBnB3DvcqVA3WzTxraAQHN3hc6NxUh5H
         ILx4xF1xnzlTZzDJkSaS/xhCOjUsF88vmxkOgCvyT9bE6W7X+XlXAzRL5bESY+Xk0KKu
         imfKHI4DvLKKRH9WIW5NR5zGUj6ytV/4NJjUIJz+AIW+y/p4GTwLQcRq0dxdqcgvikOB
         SFv7rY7sKKppA0a58cTUXMYcHsdnkRiA4Dh6HwcEmRIMqNi8hqS6SZWkysC9mDNetre0
         n6Iw==
X-Gm-Message-State: AJIora+jRoUwPROC+Ca9jmfiV5nGUVb3dWew80PGRNsf3XVNnr+Ukdau
        0S+dm9nO0aydJrqUlqLJcBS0yNQHaGY=
X-Google-Smtp-Source: AGRyM1uVPzljt+EDiuYsddvk2PkYhAr45PoKALQhbZgvRnTCbm0jGwwoeXwZwn9xD4JT9sl2s3L7nIXnAzo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id
 s2-20020a170902a50200b0015182890b19mr15244120plq.149.1657917776180; Fri, 15
 Jul 2022 13:42:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:15 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 13/24] KVM: x86: Formalize blocking of nested pending exceptions
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
index f4cc12ee21d1..f5676c2679d0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1352,10 +1352,22 @@ static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 
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
@@ -1368,13 +1380,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
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
index 42eccdcc2a4b..a0a4eddce445 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3892,11 +3892,23 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 
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
@@ -3935,15 +3947,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
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
@@ -3960,7 +3967,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (vmx->nested.nested_run_pending)
+		if (block_nested_exceptions)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
-- 
2.37.0.170.g444d1eabd0-goog

