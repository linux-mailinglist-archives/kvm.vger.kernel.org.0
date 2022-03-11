Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E384D58F7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbiCKDaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346043AbiCKD3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:50 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430CEF405D
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:28 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r11-20020a63440b000000b0038068f34b0cso4082069pga.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j3hSzQOulkLgoxGEFlrcU09LiC13RRkbJn8paPd8DUc=;
        b=IZGMuhv6pzNYzqCrDXwTWtRbqxddxRFhdCvZ8uoAaw7CmdfxwBc741x3qnVcQ9Xkaz
         X4OdaAQcEskKlCvOKDLt2IYqoyRMZgHbt4jXoJdsJ0S2ugv2iMIb2cM3Q1O4sEw3I8nv
         lZRuLv+uh9yGBXeLoylLAnUFVbJTSfjhUbV3T9xUOSG/+ylpjd2VuqC0Rray/+lTgZM0
         MHZj1nAjFcQvPw6lhCWEdvEhWSbbh/IC1U4iXZrx+033jhtPgBPukdQtopWrHIAC/IpE
         2oFAUJq+OrS568/b25v/U2sOPlsuMjwHC41YUhkwsQrOBJVrTcONRnfngzHsGuL9qPCQ
         SQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j3hSzQOulkLgoxGEFlrcU09LiC13RRkbJn8paPd8DUc=;
        b=uMC/9ihl4kTRoBXyEC16fUE6f90TfEQoQnx8br33G/wDZuyu2TW/s7ZcqV9HPKM3bE
         wkQxDHV0Hq1RleB906daxGXfPB6Q1HxaXmSTkbBJGXjpVqZ18JYyZVmpkHteCNv93pGt
         yB21Mmyuw/EOlpvhZyGo/EUQNyW/Sdob2wkZXaHyAnmAhJe8BNfgUAhe3HGDhvoCrqS7
         s2VEhplGetxGLqdYcIt+nOmopxy7pkGGzHKxjg1FVvVpqL51VF0SSYlT+rocqwbpHga3
         l+6HDjFUK6BE4iOcoMgV4ILDZzDkHNs4svcXT+KxekAn4/Xik3CqY18DW5zwitauDrcj
         9hFQ==
X-Gm-Message-State: AOAM532HxCJO3kgPE4TwRD15p7ffBCTAuFISRGf73NttJM7PZsCyRF82
        1FrRR3Gc26ra2ihaFJIjLpF44lPze/I=
X-Google-Smtp-Source: ABdhPJwVJ3a6Z6fMYsIBvTtrAVKhm73bHMtoC/OPFymL39Hecva/G3A1RMlXm4qBS+5MwK8oxpGI2jPsVEU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:70c6:b0:153:2444:6dcd with SMTP id
 l6-20020a17090270c600b0015324446dcdmr5228529plt.55.1646969307773; Thu, 10 Mar
 2022 19:28:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:54 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 14/21] KVM: x86: Formalize blocking of nested pending exceptions
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++----------
 arch/x86/kvm/vmx/nested.c | 23 ++++++++++++-----------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bef5a93166a8..60df9d4d19b5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1201,10 +1201,16 @@ static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 
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
+	bool block_nested_events = block_nested_exceptions ||
+				   kvm_event_needs_reinjection(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 	    test_bit(KVM_APIC_INIT, &apic->pending_events)) {
@@ -1217,13 +1223,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
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
index c88031d44148..01cf579c0260 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3878,11 +3878,17 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 
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
+	bool block_nested_events = block_nested_exceptions ||
+				   kvm_event_needs_reinjection(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
@@ -3916,15 +3922,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * Process exceptions that are higher priority than Monitor Trap Flag:
 	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
 	 * could theoretically come in from userspace), and ICEBP (INT1).
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
@@ -3941,7 +3942,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (vmx->nested.nested_run_pending)
+		if (block_nested_exceptions)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
-- 
2.35.1.723.g4982287a31-goog

