Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E32373314
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhEEA2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhEEA2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:28:48 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B4DC06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:27:52 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h12-20020a0cf44c0000b02901c0e9c3e1d0so492009qvm.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=h6JK13NBo79kgeijdsl/XACOJNOEDrS1vfGEPF8K2m8=;
        b=bBMrJre9BppTYU+GNRG3AcJK4VcCnP4ndqYIZ8cIXc32UMWnproV0PttLueCPJWppp
         dQSldY9G967LvyULabNPnmEWAqas6yiX9nbNlQAfmWg8r6t4p7ePRYdocTxAqdTbTWBo
         20T/G6U3OGPS1QzpTGiCLd+QmPhMzcCtydAtQSs0Ugkv/A5Jf0uUe/icOGrwI7NuU4wD
         xHVMDxkwnbFaN64wTsUdO96MwFCSGiGxCEAN4DuSVCC/hTyjNTG6NrH83Q4El5cH6Dg8
         qVOchLPYlWuRSDzaOs5Q6h2TCoO/wh2R3Ahw6Wvg3kj6M5w/OGpQ/sArpJ/zs3G9WCad
         fPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=h6JK13NBo79kgeijdsl/XACOJNOEDrS1vfGEPF8K2m8=;
        b=PMIIUxxP4CAOc2colKMuzUyWSkaZd5mrOQ5uIpqIVUGJhWU3IRRXIMsCpHMhed0mW4
         VJQ0rLgqvSzYNSu4XBJebSuk1y/evvHvpeJ2vWBkbDnW0fUlWJ6/RyJVj3fAZCKqJE16
         z2QW2phpcNNSDYGaNqoWL/vdS3Z8BVHygS0lRNPBm4Q8+HDeX2CWhhDPMrYfBynenf/V
         o8q0WpWGf0oyGZlLoTL33Na7Zj96Ms40p7ONH43nqUlH5bZpmsl+gnzfr4z5Go0ZEqJT
         uMRox5uYFRVywMSsk1OoAVpJfl71csh+qlyJ3nCjovRElpzsfGB6RN3tq+D73UIa0Qm4
         g33Q==
X-Gm-Message-State: AOAM5303023VvJCeO5TwIz4yVEPoUzlyhVuPB/Pzy6/LuKy1e/jFJGfD
        9HIDAJqmckFggMf8w16S8UxKV3JSzBY=
X-Google-Smtp-Source: ABdhPJxJ5Unb+wl1eR7T9l6AUF3aTSlpN9ha81MhtYYIDOPBCITlWA/zy0GMOZIoJvZaLCdxoYkHfwvRWl8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:ad4:5588:: with SMTP id e8mr28253896qvx.10.1620174471714;
 Tue, 04 May 2021 17:27:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:30 -0700
In-Reply-To: <20210505002735.1684165-1-seanjc@google.com>
Message-Id: <20210505002735.1684165-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210505002735.1684165-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 3/8] KVM: x86: Defer vtime accounting 'til after IRQ handling
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

From: Wanpeng Li <wanpengli@tencent.com>

Defer the call to account guest time until after servicing any IRQ(s)
that happened in the guest or immediately after VM-Exit.  Tick-based
accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
handler runs, and IRQs are blocked throughout the main sequence of
vcpu_enter_guest(), including the call into vendor code to actually
enter and exit the guest.

This fixes a bug[*] where reported guest time remains '0', even when
running an infinite loop in the guest.

[*] https://bugzilla.kernel.org/show_bug.cgi?id=209831

Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: stable@vger.kernel.org#v5.9-rc1+
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 6 +++---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 arch/x86/kvm/x86.c     | 9 +++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a7271f31df47..7dd63545526b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3753,15 +3753,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10b610fc7bbc..8425827068c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6701,15 +6701,15 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf52ba5f2bb..40e958617405 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9367,6 +9367,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
+	/*
+	 * Wait until after servicing IRQs to account guest time so that any
+	 * ticks that occurred while running the guest are properly accounted
+	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
+	 * of accounting via context tracking, but the loss of accuracy is
+	 * acceptable for all known use cases.
+	 */
+	vtime_account_guest_exit();
+
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {
-- 
2.31.1.527.g47e6f16901-goog

