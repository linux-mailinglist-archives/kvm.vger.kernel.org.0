Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB22642DC
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgIJJwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbgIJJvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:16 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631EAC061796;
        Thu, 10 Sep 2020 02:51:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so4310995pfn.9;
        Thu, 10 Sep 2020 02:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gufdorb42rxA796FKLZhr27r+MpQ8Lg+JA5WYF7LC2E=;
        b=d3yUxF+w3w8haeWR3Vy+vCCEh0dNiyZEJrGs6Lh5O9GF7k55o9jPHkloPd98LUNmgO
         SHU1bsr3jZr6xGkviMlUYUH/Rs7VUfDUdDUt6FqBSr7S2ZLoym92Lzy77K1FVpLTNcr2
         E2ulQhXDyyEdrfGW3NpA11T7saQogULFFPsJ60VZF9/16qMQG+nXt1BrHiohXT6jmlj8
         mfs9rkVHL9Fz6h8Q6j4YVpT9sEODD03bfY2DQ2wc1qhYEIByvzD4wULIAV1vQy+wrJyg
         UcmDaJOXVXyjQ5pP/9MYfiaNpXNfW4c/vdTMt6ShNkTqAJ5c7oLWlFpeaipK2SOb4BSr
         /j6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gufdorb42rxA796FKLZhr27r+MpQ8Lg+JA5WYF7LC2E=;
        b=l+IcbcElu8Ovc2zOt6D38QNSd3NmUN60XWj8smJXDA/Ve24EToy3qodLNwhLNfBx1J
         QkFr60+pVLiQ6YlMNXjx47Shy4YUjIHQbmbbIGvLzOqh7Hah0EaipzLbhjKnCaJEKW1Q
         cMjASxyCFkEj4krx3obxbhXwMq470BZp8vDGY3Jdn2fglJym15lwn2AGNDDF47yeHoCB
         vijW+jFkXQYmWk8PnZq9am4XNMY3hYAf2XQ23jrG3uQyLvoi8Q8/4K/zvssOPInl5uYy
         oj2FKrv8QyESnMvRpDmf78AyLxy5BVBka/UfbLFC/qu580i/jwK7Kmvaqi4rsc14RObI
         q7sA==
X-Gm-Message-State: AOAM531mCrBOwk2pZ9OMIF1SewjHiYGS1VJFo272clVw73F11nyQFty8
        SWDaClJNlIEyrYYXSAC3dqoUxb0SR7I=
X-Google-Smtp-Source: ABdhPJxMWA1T1JI6YEp2ljHyfvQ74aImtlJz0UWdT2EcjTb5+nnHsfx9R+3I4NmN9DFm4UqVOglNYA==
X-Received: by 2002:a63:c40d:: with SMTP id h13mr3806713pgd.185.1599731473755;
        Thu, 10 Sep 2020 02:51:13 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:13 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 6/9] KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns
Date:   Thu, 10 Sep 2020 17:50:41 +0800
Message-Id: <1599731444-3525-7-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

All the checks in lapic_timer_int_injected(), __kvm_wait_lapic_expire(), and
these function calls waste cpu cycles when the timer mode is not tscdeadline.
We can observe ~1.3% world switch time overhead by kvm-unit-tests/vmexit.flat
vmcall testing on AMD server. This patch reduces the world switch latency
caused by timer_advance_ns feature when the timer mode is not tscdeadline by
simpling move the check against apic->lapic_timer.expired_tscdeadline much
earlier.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 11 +++++------
 arch/x86/kvm/svm/svm.c |  4 +---
 arch/x86/kvm/vmx/vmx.c |  4 +---
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3b32d3b..51ed4f0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1582,9 +1582,6 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
 
-	if (apic->lapic_timer.expired_tscdeadline == 0)
-		return;
-
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
@@ -1599,7 +1596,10 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
-	if (lapic_timer_int_injected(vcpu))
+	if (lapic_in_kernel(vcpu) &&
+	    vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
+	    vcpu->arch.apic->lapic_timer.timer_advance_ns &&
+	    lapic_timer_int_injected(vcpu))
 		__kvm_wait_lapic_expire(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
@@ -1635,8 +1635,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	}
 
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
-		if (apic->lapic_timer.timer_advance_ns)
-			__kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0194336..19e622a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3456,9 +3456,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
-	if (lapic_in_kernel(vcpu) &&
-		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a544351..d6e1656 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6800,9 +6800,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
 
-	if (lapic_in_kernel(vcpu) &&
-		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.7.4

