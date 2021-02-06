Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EFB3119D9
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 04:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhBFCbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 21:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhBFCa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 21:30:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E270AC033267
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 16:42:23 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 203so9099330ybz.2
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 16:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=/uKdxO7FbPiBVeLTlxl1CfT/Z9yqVnQz43NlcHgsGl4=;
        b=mgWuoDzKopp0TTA8rmgl4BKF9dbWHGsAISViQKsZV+FpaNv8jWFglKIcXKTrzgFB69
         kNHOOomBoBsz9/2bptFdvSLjwDtei0F+iDq20PqSNjdH9s9W2BCCswgtg1Oit+V2Z5C4
         cwLFOFb/IdcYnOicBwydv9W29TEIap1qs23mJtlwzmZV0VwQURljouLQaMubOP/SRULq
         H/9nsKNjKbNGzNfsfA0KS2rc1aUaRjHbW7rPalnIS4VaKcSTZEbEx6kl1kTJTcewCWoR
         BAyU8NRyX9tyHJoBUrLy1xKVjbcmdzasRMv9Zjz+v+caOPcW4gGHtTrHmRtXQiTeVrcQ
         yS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=/uKdxO7FbPiBVeLTlxl1CfT/Z9yqVnQz43NlcHgsGl4=;
        b=SJAsduTQuRI5Gayl4AFn3mN9fSzzd3F6GOJzhJtHJl9lUVJZ33XVSpP171kxQmayof
         cH4yEsTbmW5GnMbgDO+ejrazCLISKmjIwQ7YE/gHFurAKwH71lZev+hGJ/QnENaw3mve
         Cd3qi7WVQLatL3DQ0dRnpURRIIRau3dT+Pb7SsF2pdGnDMW1otnTEKhhT6fo607c7pTM
         yzkOYRHOGU7eIlJPtJvbGe1QdSc6++1taGw5JN2II38Z7+BKoQs9yLyzLXATwtSSJhDB
         8VXCpRYGtO4RN1pn7sKjvzg7+3mczKOZtZJD0CVP4953xdm4oOTtvamW3Gsd+bPo9VF5
         Kh2Q==
X-Gm-Message-State: AOAM532TEYWSshFKwxzh/+S8PwOZJbIG5+FtuDztxJ2xKqFWqyWa47iW
        1AhI5ymuRdVXCWYoA7dSmQCC046F1kw=
X-Google-Smtp-Source: ABdhPJx9PBagDThm3MGgi0E+HsklXIC0Oj8sYJAfylwTidtK3vM6ARhOOlcdB+sI6KDQltE+hHnREPZebQc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:d169:a9f7:513:e5])
 (user=seanjc job=sendgmr) by 2002:a25:24c:: with SMTP id 73mr9515183ybc.362.1612572143209;
 Fri, 05 Feb 2021 16:42:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Feb 2021 16:42:18 -0800
Message-Id: <20210206004218.312023-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [RFC PATCH] KVM: x86: Set PF_VCPU when processing IRQs to fix
 tick-based accounting
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Temporarily set PF_VCPU while processing IRQ VM-Exits so that a tick IRQ
accounts the time slice to the guest.  Tick-based accounting of guest
time is currently broken as PF_VCPU is only set during the relatively
short VM-Enter sequence, which runs entirely with IRQs disabled, and IRQs
that occur in the guest are processed well after PF_VCPU is cleared.

Keep PF_VCPU set across both VMX's processing of already-acked IRQs
(handle_exit_irqoff()) and the explicit IRQ window (SVM's processing,
plus ticks that occur immediately after VM-Exit on both VMX and SVM).

Fixes: 87fa7f3e98a1 ("x86/kvm: Move context tracking where it belongs")
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This is quite obnoxious, hence the RFC, but I can't think of a clever,
less ugly way to fix the accounting.

 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9f931c63293..6ddf341cd755 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9118,6 +9118,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
+	/*
+	 * Temporarily pretend this task is running a vCPU when potentially
+	 * processing an IRQ exit, including the below opening of an IRQ
+	 * window.  Tick-based accounting of guest time relies on PF_VCPU
+	 * being set when the tick IRQ handler runs.
+	 */
+	current->flags |= PF_VCPU;
 	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
 
 	/*
@@ -9132,6 +9139,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
+	current->flags &= ~PF_VCPU;
 
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
-- 
2.30.0.478.g8a0d178c01-goog

