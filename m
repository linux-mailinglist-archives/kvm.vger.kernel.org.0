Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8911E78DF
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgE2I4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:56:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:46106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2I4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:56:00 -0400
IronPort-SDR: M+pygays1SCz1Gtona4LEP5g4qrV9oaleWhix2/fz0r8Rim4VOssMMRvFS83GenOJZTPL5m3qM
 mAQQq9/l/Tpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:55:57 -0700
IronPort-SDR: Goe37uVlvC/b9BvY6HmI0J2GOXpM9GNVItHad9+2XpIe0TYQRxSC595K9qVc/hFSXmJj+hvJbt
 uIVt0oKgZdwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311188340"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:55:55 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 4/6] KVM: X86: Split kvm_update_cpuid()
Date:   Fri, 29 May 2020 16:55:43 +0800
Message-Id: <20200529085545.29242-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200529085545.29242-1-xiaoyao.li@intel.com>
References: <20200529085545.29242-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the part of updating KVM states from kvm_update_cpuid(), and put
it into a new kvm_update_state_based_on_cpuid(). So it's clear that
kvm_update_cpuid() is to update guest CPUID settings, while
kvm_update_state_based_on_cpuid() is to update KVM states based on the
updated CPUID settings.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 38 ++++++++++++++++++++++++--------------
 arch/x86/kvm/cpuid.h |  1 +
 arch/x86/kvm/x86.c   |  1 +
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c8cb373056f1..a4a2072f5253 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -76,7 +76,6 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
-	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best) {
@@ -87,13 +86,6 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
-
-		if (apic) {
-			if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
-				apic->lapic_timer.timer_mode_mask = 3 << 17;
-			else
-				apic->lapic_timer.timer_mode_mask = 1 << 17;
-		}
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
@@ -102,13 +94,8 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best) {
-		vcpu->arch.guest_supported_xcr0 = 0;
-	} else {
-		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
-	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
@@ -127,6 +114,27 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
+}
+
+void kvm_update_state_based_on_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	if (best && apic) {
+		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
+			apic->lapic_timer.timer_mode_mask = 3 << 17;
+		else
+			apic->lapic_timer.timer_mode_mask = 1 << 17;
+	}
+
+	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	if (!best)
+		vcpu->arch.guest_supported_xcr0 = 0;
+	else
+		vcpu->arch.guest_supported_xcr0 =
+			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
 
 	/* Note, maxphyaddr must be updated before tdp_level. */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
@@ -221,6 +229,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	kvm_update_cpuid(vcpu);
+	kvm_update_state_based_on_cpuid(vcpu);
 
 out:
 	vfree(cpuid_entries);
@@ -250,6 +259,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	kvm_update_cpuid(vcpu);
+	kvm_update_state_based_on_cpuid(vcpu);
 out:
 	return r;
 }
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f136de1debad..0ccf9ec4bf55 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -10,6 +10,7 @@ extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid(struct kvm_vcpu *vcpu);
+void kvm_update_state_based_on_cpuid(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc993b79ae2f..fcb85432d30b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8100,6 +8100,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 #endif
 
 	kvm_update_cpuid(vcpu);
+	kvm_update_state_based_on_cpuid(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 
-- 
2.18.2

