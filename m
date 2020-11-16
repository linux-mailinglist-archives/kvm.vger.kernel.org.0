Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00B82B4FB1
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388669AbgKPSb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:31:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:20638 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388161AbgKPS2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:08 -0500
IronPort-SDR: tSRz0Edq9M/BnbHOeBeO5QjhyucvHcytcscaINjsciUT0/XXF2pU8K2jx4WDl41zZUrkhGHGns
 MzAt0sFwkWlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410044"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410044"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:07 -0800
IronPort-SDR: KuA76qT6+fBbBZrBxrNugSPCwPfmSI1+L6kV2+9GCK1cQJlWyrEiFsHYKiXVG/MmbMrsXmjLNP
 wcFA3pYIzMZA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528055"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:06 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 31/67] KVM: x86: Add option to force LAPIC expiration wait
Date:   Mon, 16 Nov 2020 10:26:16 -0800
Message-Id: <571d4b6878fbc96db4d4584957c8cafd6a01490e.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add an option to skip the IRR check in kvm_wait_lapic_expire().  This
will be used by TDX to wait if there is an outstanding notification for
a TD, i.e. a virtual interrupt is being triggered via posted interrupt
processing.  KVM TDX doesn't emulate PI processing, i.e. there will
never be a bit set in IRR/ISR, so the default behavior for APICv of
querying the IRR doesn't work as intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/lapic.c   | 6 +++---
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e6c0aaf4044e..41dce91f5df0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1601,12 +1601,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait)
 {
 	if (lapic_in_kernel(vcpu) &&
 	    vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
 	    vcpu->arch.apic->lapic_timer.timer_advance_ns &&
-	    lapic_timer_int_injected(vcpu))
+	    (force_wait || lapic_timer_int_injected(vcpu)))
 		__kvm_wait_lapic_expire(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
@@ -1642,7 +1642,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	}
 
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4fb86e3a9dd3..30f036678f5c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -237,7 +237,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait);
 
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 15836446a9b8..8be23240c74f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3580,7 +3580,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3559b51f566d..deeec105e963 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6720,7 +6720,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.17.1

