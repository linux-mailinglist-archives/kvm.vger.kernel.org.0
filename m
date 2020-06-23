Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4465E20517B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgFWL6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:58474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbgFWL6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:31 -0400
IronPort-SDR: S6+6KISBQ74xbYVjjwRu6OlQr2JYX3lNZW1LTPf8C6on7MDS+7q8awbrel/QXEbyKHizXSxKCD
 1Crl731P0cEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228710092"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="228710092"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 04:58:30 -0700
IronPort-SDR: J3EYd2Ed+YO377YOzdYgFTak2ETrA48FJbCAbIuhcgob9bRZdLWPFrMWtd1Yz2xJv2760zwhVA
 u2E/v67qJUNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="285745721"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 04:58:28 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 4/7] KVM: X86: Split kvm_update_cpuid()
Date:   Tue, 23 Jun 2020 19:58:13 +0800
Message-Id: <20200623115816.24132-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200623115816.24132-1-xiaoyao.li@intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
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
index 67e5c68fdb45..001f5a94880e 100644
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
index 00c88c2f34e4..4dee28bbc087 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8149,6 +8149,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 #endif
 
 	kvm_update_cpuid(vcpu);
+	kvm_update_vcpu_model(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 
-- 
2.18.2

