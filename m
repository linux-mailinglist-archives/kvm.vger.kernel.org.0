Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC7217FF2
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgGHGvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:5308 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgGHGvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:18 -0400
IronPort-SDR: Ai1P+QH2DY0lyQzZyb6dnW0v/EX+JhkKLTq5GCufn+zC0ARWNMPzThj1d1AJgK3xM62AUExFi3
 Cnqo9QKckf2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852076"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852076"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:51:12 -0700
IronPort-SDR: qAoT49Y9kP3kFFZk1hrhkQ56FZQNPh5sE97GPka4FbMgP7cERjr2PxMGMOPLbeeA1gOBtWicnD
 uMHHGujNq+GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399175"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:51:09 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 4/8] KVM: X86: Split kvm_update_cpuid()
Date:   Wed,  8 Jul 2020 14:50:50 +0800
Message-Id: <20200708065054.19713-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the part of updating vcpu model out of kvm_update_cpuid(), and put
it into a new kvm_update_vcpu_model(). So it's more clear that
kvm_update_cpuid() is to update guest CPUID settings, while
kvm_update_vcpu_model() is to update vcpu model (settings) based on the
updated CPUID settings.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 38 ++++++++++++++++++++++++--------------
 arch/x86/kvm/cpuid.h |  1 +
 arch/x86/kvm/x86.c   |  1 +
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a825878b7f84..001f5a94880e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -76,7 +76,6 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
-	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best) {
@@ -89,26 +88,14 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	if (best && apic) {
-		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
-			apic->lapic_timer.timer_mode_mask = 3 << 17;
-		else
-			apic->lapic_timer.timer_mode_mask = 1 << 17;
-	}
-
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
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
+void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
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
@@ -218,6 +226,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	kvm_update_cpuid(vcpu);
+	kvm_update_vcpu_model(vcpu);
 
 	kvfree(cpuid_entries);
 out:
@@ -247,6 +256,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	kvm_apic_set_version(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
 	kvm_update_cpuid(vcpu);
+	kvm_update_vcpu_model(vcpu);
 out:
 	return r;
 }
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f136de1debad..45e3643e2fba 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -10,6 +10,7 @@ extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid(struct kvm_vcpu *vcpu);
+void kvm_update_vcpu_model(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09ee54f5e385..6f376392e6e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8184,6 +8184,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 #endif
 
 	kvm_update_cpuid(vcpu);
+	kvm_update_vcpu_model(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 
-- 
2.18.4

