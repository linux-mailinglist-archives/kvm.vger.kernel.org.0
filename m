Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11996260BC4
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgIHHSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbgIHHSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:18:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ADEC061756;
        Tue,  8 Sep 2020 00:18:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so9399432pgm.11;
        Tue, 08 Sep 2020 00:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nu11smmO1MLPBr0YyFlQ7QMaiS4dHSCwCtOQC6QvghQ=;
        b=BeN69dOd73In3yvux1bQOAJFhMWC1wLnRHaJvcHqUsJ+Q63UGjkBTdGZeqfu9OGxay
         FNj8ecK/niHBS6Nnru8IExabjT20+zTvmH9KsgnL0n7FN9R86a45qN4Cb76Yfv4bJFXM
         Quj3T9q+qOX+3vLEkVGOXUh70rXFCIDeKE2lhW0JN7hoshxbe66OecvCZ1BpipR0MtcS
         EPJxBxSH1WCcmU/uMU5zP8WLFN4CFcFMAabSzZRhO/5kfoHwfAmlYTWWrBXNKA3LZKjc
         xc7mJEm01rN6q1Y7COCC1W29ebbIMiRiEdEa4MU4OxhjQRVj2Wzg5RbiBr95GwcS9Mut
         8YWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nu11smmO1MLPBr0YyFlQ7QMaiS4dHSCwCtOQC6QvghQ=;
        b=iiDbcE4lzcklQmiqDbsxujv2Y5Q8Bt3qjQQTtVdSruqJK5H+e7ueLbRHFbMgzAH605
         qBn9vIl+GZX2J54cEusvcxIedh3QNeYG4zFq1ujij6A0NPrfb06z6MxFX0XQAv5zLkKV
         ev+R9sTWXDVcAhvCfHgD4EzV8ym3Kys39wUuir4ffWstoEtdl3U6dPlLcq0IK3XxQOx+
         eKv2Yxtat97o+/LrUCqTl4rghRMvAtSQL6wlSHb6pCVVyw+NcuupxPiwgsy6Gf4xVszw
         7rPqemPpdKU0kxEoUSV9PN+Kid/RSDbutNqL/SumJgcbYmQa2NAFZ9LHlzPQvwy9VJQM
         3BHg==
X-Gm-Message-State: AOAM533o0e6ava7FzYcLbqalJCsIf23CmmBjnBpjmNbFWpuz7l+U3AHe
        LGT6B9iZz2UHkOYAWMqFa9wEpjCUrIU=
X-Google-Smtp-Source: ABdhPJyKWwWgF5Vgs/ibNYf3Ni3RsyjIpiAKFC6RiuRkTQz3Mvi0yRcD1cg9VmpKa34bPVoWn+pQpw==
X-Received: by 2002:a62:33c1:: with SMTP id z184mr23333624pfz.248.1599549492531;
        Tue, 08 Sep 2020 00:18:12 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id gt11sm6437801pjb.48.2020.09.08.00.18.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 00:18:11 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns
Date:   Tue,  8 Sep 2020 15:17:52 +0800
Message-Id: <1599549472-26052-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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
v1 -> v2:
 * move the check against apic->lapic_timer.expired_tscdeadline much earlier 
   instead of reset timer_advance_ns

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

