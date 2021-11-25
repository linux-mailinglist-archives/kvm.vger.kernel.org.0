Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FD945D1AD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353224AbhKYAYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352913AbhKYAYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649714"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649714"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:13 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042209"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:13 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 29/59] KVM: x86: Add option to force LAPIC expiration wait
Date:   Wed, 24 Nov 2021 16:20:12 -0800
Message-Id: <9cc794352494e0ef4a2a1d4291b937653b39e780.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c   | 4 ++--
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1bfcd325d0d2..beef195b9d15 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1625,12 +1625,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
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
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..2a0119ef9e96 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -233,7 +233,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait);
 
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1bf410add13b..e33cbf9613d9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3885,7 +3885,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e4c6ac9fe69..1e20e85a958f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6647,7 +6647,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.25.1

