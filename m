Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70855361557
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhDOWVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbhDOWVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:21:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C21DC061756
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k199so3963264ybf.0
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5k2yPQB3tTqToSff4yHkVz7D+OA/2KiSXpBAyhB9+lI=;
        b=P+X4dRzttCOn1AtwO3Us9bAYEEDl7hRiwPFkhyXs45yQw5GmsnydX6gAcaDzLpHeps
         IDvv9a7x9KP/VxIoj4nZZhaXocUOljqtWhWzfopnChTUZndQRs/5rwlaLMnZpSDHpp0H
         3y3ZkHKKtOUGfLl02dp+/xvDfihLq4xeku0TYPZA6EERlxk+1jf6I75OI4vFgO0qDpyd
         T7syDagEV6jXbMtbCXTFBNbfkUOoNrdWvkEpVT/XyLRVX5OQJkVqiE3W/MjUzn0bUY7e
         XT1VcpdvDWYRc0TEDF1n0w9Q4s/vRD3hEBsWzTNRy7GuD5csqfhFnnpKoa8AsKQzfcA5
         RXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5k2yPQB3tTqToSff4yHkVz7D+OA/2KiSXpBAyhB9+lI=;
        b=MdeO3u8p0xPc6r0Te2td0mlOqa2Cl9LcXoG5uenem/XyRCN/M5jO6FqzzD5ijAdoXj
         H74S3PFz5TaqX3I5AnhU4emEyGOX0yDqkUeUlBXIx/yYC8L4iSk86rOWqn6ldzsqmR6r
         yGR2JAECspu/YwYV2ArYZQthvNR8ZfKsfGwNUeDQrXbKfNeZtwZnYfAyj1zKbgOLMc/g
         TdLuo4wtKnb0IlSWZfD+ufYnUtavoNIfeEZUktQ33MHe88HW5/EvoEA8cp+4oTZ/bNy/
         UnvfUt6CbVMBUC5q1eGB5ZsR8Ws0Wh2hRSU/QrGaEA57ZKao9ymfoVgvocgTC3AuF/Hg
         NuyQ==
X-Gm-Message-State: AOAM532mk00ur+F4dUemnueN96Lq6WOQoe+5CA3E36wQBbp3trKrKDFW
        21srHneifsVS9cADVhbrg1VbHdRpt5M=
X-Google-Smtp-Source: ABdhPJz1oundGzIq0A2am+wei1yKQWeOWwOHUCr74uXl2hTR4OvZmcPrkn5oxqDnj08dAOy94TF8YMQdc5o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c93:ada0:6bbf:e7db])
 (user=seanjc job=sendgmr) by 2002:a25:b983:: with SMTP id r3mr8023430ybg.238.1618525280362;
 Thu, 15 Apr 2021 15:21:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 15 Apr 2021 15:21:00 -0700
In-Reply-To: <20210415222106.1643837-1-seanjc@google.com>
Message-Id: <20210415222106.1643837-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210415222106.1643837-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v3 3/9] KVM: x86: Defer tick-based accounting 'til after IRQ handling
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When using tick-based accounting, defer the call to account guest time
until after servicing any IRQ(s) that happened in the guest or
immediately after VM-Exit.  Tick-based accounting of vCPU time relies on
PF_VCPU being set when the tick IRQ handler runs, and IRQs are blocked
throughout {svm,vmx}_vcpu_enter_exit().

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
 arch/x86/kvm/svm/svm.c | 13 ++++++++++---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++++++---
 arch/x86/kvm/x86.c     |  8 ++++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48b396f33bee..bb2aa0dde7c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3750,17 +3750,24 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit_irqoff() restores host context and
+	 * reinstates RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit_irqoff();
 
 	instrumentation_begin();
+	/*
+	 * Account guest time when precise accounting based on context tracking
+	 * is enabled.  Tick based accounting is deferred until after IRQs that
+	 * occurred within the VM-Enter/VM-Exit "window" are handled.
+	 */
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_account_guest_exit();
 	trace_hardirqs_off_finish();
 	instrumentation_end();
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c05e6e2854b5..5ae9dc197048 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6639,17 +6639,24 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit_irqoff() restores host context and
+	 * reinstates RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit_irqoff();
 
 	instrumentation_begin();
+	/*
+	 * Account guest time when precise accounting based on context tracking
+	 * is enabled.  Tick based accounting is deferred until after IRQs that
+	 * occurred within the VM-Enter/VM-Exit "window" are handled.
+	 */
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_account_guest_exit();
 	trace_hardirqs_off_finish();
 	instrumentation_end();
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16fb39503296..e4d475df1d4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9230,6 +9230,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
+	/*
+	 * When using tick-based accounting, wait until after servicing IRQs to
+	 * account guest time so that any ticks that occurred while running the
+	 * guest are properly accounted to the guest.
+	 */
+	if (!vtime_accounting_enabled_this_cpu())
+		vtime_account_guest_exit();
+
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {
-- 
2.31.1.368.gbe11c130af-goog

