Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457A435E66A
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347820AbhDMSaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347801AbhDMSaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:30:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729E9C061756
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h69so12519897ybg.10
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CEYCqY3YmprwzNzHmrb5PG3zL9vhoX2SFLxftmzmH28=;
        b=TBTjbKnx1EUQ2y9m+ZG68jdyp/Ip7on/lMBwHyHq64SuDLGtIFYP/c06SMP2sfo+k/
         NMSncL3PrXNBg+SAsCukB+lMCcmQ4TdgvKEKkQwiMMnHc1dDeTbK7/MjTMvWYsFrZZiM
         PFGwZ9BYCd6mhnyRFj/9IfStt6nTc6zLfm6qMdze7iTeqxpkwyN4uAucwv83EbrXC6eb
         CWa3dwqlYu0YwzgARENnwdEfmH9Y4vNeE9bx38RjzRoZtlcApAb2wLwG+rd05QNXZjSj
         VLIczG8FhfBDPD+OaCG4819gZzccst9RC6pgdqHhMpaLxgCrpd4oUjukUx0e9gxXxt1A
         a65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CEYCqY3YmprwzNzHmrb5PG3zL9vhoX2SFLxftmzmH28=;
        b=kndUdvBX57fX2MS+z3t0I+980VrFMEBy8dOJisz48wlPpui0Z8J22Da82mzo1AodJc
         yLZlC5o/E6T6MXY24Bm9HjpeqqpHcDk3LXtD4+FortSTSkiBQQCzCOkfIHO5DT634PpM
         eWPK+piw4y4zPgl0/zwr2W28W9Dbu/xydCCT4JqdxUVfeKAD9XnpjWGHCuyeuIX6p4tp
         rXX8oHQj0ov8yMkXZpPCaLbBl3C7xHoZP11jHSELwK7+y8hsWgbkOuHXoGA4uN6KWNt+
         3rOQ6sftNyVRG+t5RJXVd1wfHZiZNwcTxc3l4NEm2LcdjGhtBm9ui+Jes0JeBMjNr3nZ
         MywA==
X-Gm-Message-State: AOAM533A7S1RF5NofV+uh1sOnig9XdoSTdw3Dz+YrjxAy3atsGZysXKd
        DkgjgFZPY+2CbJVzNscwPOuQeprLqws=
X-Google-Smtp-Source: ABdhPJz0378Bfftq2L3C9vl/L1mZmRh3nq5AECtQL95uGhNpglOks/bpp90SbduruRCfzKVnP+wRa9C5PtY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a5b:452:: with SMTP id s18mr46985082ybp.482.1618338593729;
 Tue, 13 Apr 2021 11:29:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Apr 2021 11:29:32 -0700
In-Reply-To: <20210413182933.1046389-1-seanjc@google.com>
Message-Id: <20210413182933.1046389-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210413182933.1046389-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [RFC PATCH 6/7] KVM: x86: Consolidate guest enter/exit logic to
 common helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the enter/exit logic in {svm,vmx}_vcpu_enter_exit() to common
helpers.  In addition to deduplicating code, this will allow tweaking the
vtime accounting in the VM-Exit path without splitting logic across x86,
VMX, and SVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 39 ++----------------------------------
 arch/x86/kvm/vmx/vmx.c | 39 ++----------------------------------
 arch/x86/kvm/x86.h     | 45 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48b396f33bee..0677595d07e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3713,25 +3713,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
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
 		__svm_sev_es_vcpu_run(svm->vmcb_pa);
@@ -3745,24 +3727,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
-	/*
-	 * VMEXIT disables interrupts (host state), but tracing and lockdep
-	 * have them in state 'on' as recorded before entering guest mode.
-	 * Same as enter_from_user_mode().
-	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
-	 *
-	 * This needs to be done before the below as native_read_msr()
-	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
-	 * into world and some more.
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
-
-	instrumentation_begin();
-	trace_hardirqs_off_finish();
-	instrumentation_end();
+	kvm_guest_exit_irqoff();
 }
 
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c05e6e2854b5..19b0e25bf598 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6600,25 +6600,7 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
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
@@ -6634,24 +6616,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = native_read_cr2();
 
-	/*
-	 * VMEXIT disables interrupts (host state), but tracing and lockdep
-	 * have them in state 'on' as recorded before entering guest mode.
-	 * Same as enter_from_user_mode().
-	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
-	 *
-	 * This needs to be done before the below as native_read_msr()
-	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
-	 * into world and some more.
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
-
-	instrumentation_begin();
-	trace_hardirqs_off_finish();
-	instrumentation_end();
+	kvm_guest_exit_irqoff();
 }
 
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index daccf20fbcd5..74ef92f47db8 100644
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
+	 * guest_exit_irqoff() restores host context and reinstates RCU if
+	 * enabled and required.
+	 *
+	 * This needs to be done before the below as native_read_msr()
+	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
+	 * into world and some more.
+	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	guest_exit_irqoff();
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
2.31.1.295.g9ea45b61b8-goog

