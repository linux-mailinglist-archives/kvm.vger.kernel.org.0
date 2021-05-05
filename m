Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2482437331E
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhEEA3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbhEEA3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:29:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F74C06138C
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:28:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 184-20020a250cc10000b02904ee21d0e583so475356ybm.6
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nAq8b5zbDcnq4/b7mYll+jSK99onuEwFoGl5XtqXHxU=;
        b=uiir3jq6tkI0cD+XcQBhRYL7ZfyZb5z0vqaDYT7mZ6ROmEmJkCpcTRuwdFGKcO/DLy
         sVkWgjcJbp1WXYW+SpYR1CGOqWtq+8iBGCeCpdlRFFkVlf3nhj0L7KIgK2O/39ea/pF9
         +lvclTejVElLHEvWqcNZNeJRDcRmV7u4oeVE3LTlsh+ehT66+DHO/+XcIL9VXGRaU2zw
         7bSQohSOC6MTrgGe40elFWEMT3uI7eVc0vpWpjE2INg86G+J5at9phjO85xcJGY0Sr9f
         QT/CV0s9I0AV3aiDQIkIHRxJ/TNSRNAZEWzVQ/2Ey0kUkEiLhxIIh66qb5MgtrDCKvfs
         trIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nAq8b5zbDcnq4/b7mYll+jSK99onuEwFoGl5XtqXHxU=;
        b=cTCz1Om09mxH4tVJCMW7Q2jyZl6Jyz1i+nTUFcKNR90BWXCpCKHXtxLbPq+oM/Tf5j
         OJQQ2PejGI2pzI6nJ+u64EO4R0ND5zJq1fAYaaqYBlCaFaXtfS65R2ecYlBxlYANsWwP
         9qLOQ8dD5JojmASXK6Z9WTVqP7vWdelhO0jwye9jPaShbQevc6nr00CQBZz6ld7TrLrq
         WxSLMoBZRXc6G+svRcpr7J7pvg7NybvHtQbJSEpyY3hzYjhkcV/2/GNFkvZBwD5435HG
         v/yk+kAszJranrV4VXNE3uu15DCA3Fvs16pzVUybsFTvOtU8GL10rgJ/0jyKuXYKbYJV
         M/Yg==
X-Gm-Message-State: AOAM530vkomDFWPn/sBf0LERXOlQLKUmThd8BSCQolfehvVfzjx3Wr2F
        ckJo6vUv6adKz6Fept0QbY4LYJ5ko9g=
X-Google-Smtp-Source: ABdhPJxqn0mdZ0zuI6+rBzzSP88Uj3E5IxP7dwqzqtJWtMzfEYizgTDMkPV6hi24+M8sIrcRWIaHVU2f86A=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:5585:: with SMTP id j127mr36762359ybb.349.1620174483166;
 Tue, 04 May 2021 17:28:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:35 -0700
In-Reply-To: <20210505002735.1684165-1-seanjc@google.com>
Message-Id: <20210505002735.1684165-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210505002735.1684165-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 8/8] KVM: x86: Consolidate guest enter/exit logic to common helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the enter/exit logic in {svm,vmx}_vcpu_enter_exit() to common
helpers.  Opportunistically update the somewhat stale comment about the
updates needing to occur immediately after VM-Exit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 39 ++----------------------------------
 arch/x86/kvm/vmx/vmx.c | 39 ++----------------------------------
 arch/x86/kvm/x86.h     | 45 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7dd63545526b..8abaf4ec4f22 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3710,25 +3710,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long vmcb_pa = svm->current_vmcb->pa;
 
-	/*
-	 * VMENTER enables interrupts (host state), but the kernel state is
-	 * interrupts disabled when this is invoked. Also tell RCU about
-	 * it. This is the same logic as for exit_to_user_mode().
-	 *
-	 * This ensures that e.g. latency analysis on the host observes
-	 * guest mode as interrupt enabled.
-	 *
-	 * guest_enter_irqoff() informs context tracking about the
-	 * transition to guest mode and if enabled adjusts RCU state
-	 * accordingly.
-	 */
-	instrumentation_begin();
-	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	instrumentation_end();
-
-	guest_enter_irqoff();
-	lockdep_hardirqs_on(CALLER_ADDR0);
+	kvm_guest_enter_irqoff();
 
 	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(vmcb_pa);
@@ -3748,24 +3730,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
-	/*
-	 * VMEXIT disables interrupts (host state), but tracing and lockdep
-	 * have them in state 'on' as recorded before entering guest mode.
-	 * Same as enter_from_user_mode().
-	 *
-	 * context_tracking_guest_exit() restores host context and reinstates
-	 * RCU if enabled and required.
-	 *
-	 * This needs to be done before the below as native_read_msr()
-	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
-	 * into world and some more.
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	context_tracking_guest_exit();
-
-	instrumentation_begin();
-	trace_hardirqs_off_finish();
-	instrumentation_end();
+	kvm_guest_exit_irqoff();
 }
 
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8425827068c3..dd6fae37b139 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6662,25 +6662,7 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
-	/*
-	 * VMENTER enables interrupts (host state), but the kernel state is
-	 * interrupts disabled when this is invoked. Also tell RCU about
-	 * it. This is the same logic as for exit_to_user_mode().
-	 *
-	 * This ensures that e.g. latency analysis on the host observes
-	 * guest mode as interrupt enabled.
-	 *
-	 * guest_enter_irqoff() informs context tracking about the
-	 * transition to guest mode and if enabled adjusts RCU state
-	 * accordingly.
-	 */
-	instrumentation_begin();
-	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	instrumentation_end();
-
-	guest_enter_irqoff();
-	lockdep_hardirqs_on(CALLER_ADDR0);
+	kvm_guest_enter_irqoff();
 
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
@@ -6696,24 +6678,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = native_read_cr2();
 
-	/*
-	 * VMEXIT disables interrupts (host state), but tracing and lockdep
-	 * have them in state 'on' as recorded before entering guest mode.
-	 * Same as enter_from_user_mode().
-	 *
-	 * context_tracking_guest_exit() restores host context and reinstates
-	 * RCU if enabled and required.
-	 *
-	 * This needs to be done before the below as native_read_msr()
-	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
-	 * into world and some more.
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	context_tracking_guest_exit();
-
-	instrumentation_begin();
-	trace_hardirqs_off_finish();
-	instrumentation_end();
+	kvm_guest_exit_irqoff();
 }
 
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8ddd38146525..521f74e5bbf2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,51 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+static __always_inline void kvm_guest_enter_irqoff(void)
+{
+	/*
+	 * VMENTER enables interrupts (host state), but the kernel state is
+	 * interrupts disabled when this is invoked. Also tell RCU about
+	 * it. This is the same logic as for exit_to_user_mode().
+	 *
+	 * This ensures that e.g. latency analysis on the host observes
+	 * guest mode as interrupt enabled.
+	 *
+	 * guest_enter_irqoff() informs context tracking about the
+	 * transition to guest mode and if enabled adjusts RCU state
+	 * accordingly.
+	 */
+	instrumentation_begin();
+	trace_hardirqs_on_prepare();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	instrumentation_end();
+
+	guest_enter_irqoff();
+	lockdep_hardirqs_on(CALLER_ADDR0);
+}
+
+static __always_inline void kvm_guest_exit_irqoff(void)
+{
+	/*
+	 * VMEXIT disables interrupts (host state), but tracing and lockdep
+	 * have them in state 'on' as recorded before entering guest mode.
+	 * Same as enter_from_user_mode().
+	 *
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
+	 *
+	 * This needs to be done immediately after VM-Exit, before any code
+	 * that might contain tracepoints or call out to the greater world,
+	 * e.g. before x86_spec_ctrl_restore_host().
+	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	context_tracking_guest_exit();
+
+	instrumentation_begin();
+	trace_hardirqs_off_finish();
+	instrumentation_end();
+}
+
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
 ({									\
 	bool failed = (consistency_check);				\
-- 
2.31.1.527.g47e6f16901-goog

