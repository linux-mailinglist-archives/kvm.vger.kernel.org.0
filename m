Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6202921976E
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgGIEej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:34:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:10037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIEeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:34:36 -0400
IronPort-SDR: ZdqJrd5h7a00R88rirAlMA4SzT62LlOWRJ3E/SfOO+1IkT2JAzfaY5B9vCiCM50IrnBbv0WKzI
 LuqLWzoHSiXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147011563"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147011563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:34:36 -0700
IronPort-SDR: SJ4cJbjBGRfCYGbJtlW6BH9MDmnfsC/6riSyN+lmKwKJwo7+WFz2CTmQ4fxvzfa+QR2fG7YJMF
 AjTn7Z0uSOPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="297942875"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 21:34:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 2/5] KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()
Date:   Thu,  9 Jul 2020 12:34:23 +0800
Message-Id: <20200709043426.92712-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200709043426.92712-1-xiaoyao.li@intel.com>
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Beside called in kvm_vcpu_ioctl_set_cpuid*(), kvm_update_cpuid() is also
called 5 places else in x86.c and 1 place else in lapic.c. All those 6
places only need the part of updating guest CPUIDs (OSXSAVE, OSPKE, APIC,
KVM_FEATURE_PV_UNHALT, ...) based on the runtime vcpu state, so extract
them as a separate kvm_update_cpuid_runtime().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 44 +++++++++++++++++++++++++++-----------------
 arch/x86/kvm/cpuid.h |  2 +-
 arch/x86/kvm/lapic.c |  2 +-
 arch/x86/kvm/x86.c   | 10 +++++-----
 4 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1a053022a961..0ed3b343c44e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -73,10 +73,9 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_update_cpuid(struct kvm_vcpu *vcpu)
+void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
-	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best) {
@@ -89,28 +88,14 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	if (best && apic) {
-		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
-			apic->lapic_timer.timer_mode_mask = 3 << 17;
-		else
-			apic->lapic_timer.timer_mode_mask = 1 << 17;
-
-		kvm_apic_set_version(vcpu);
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
@@ -129,6 +114,29 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
+}
+
+static void kvm_update_cpuid(struct kvm_vcpu *vcpu)
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
+
+		kvm_apic_set_version(vcpu);
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
 
 	cpuid_fix_nx_cap(vcpu);
 	kvm_x86_ops.cpuid_update(vcpu);
+	kvm_update_cpuid_runtime(vcpu);
 	kvm_update_cpuid(vcpu);
 
 	kvfree(cpuid_entries);
@@ -249,6 +258,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	}
 
 	kvm_x86_ops.cpuid_update(vcpu);
+	kvm_update_cpuid_runtime(vcpu);
 	kvm_update_cpuid(vcpu);
 out:
 	return r;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f136de1debad..3a923ae15f2f 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -9,7 +9,7 @@
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
-void kvm_update_cpuid(struct kvm_vcpu *vcpu);
+void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e5dbb7ebae78..47801a44cfa6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2230,7 +2230,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-		kvm_update_cpuid(vcpu);
+		kvm_update_cpuid_runtime(vcpu);
 
 	if (!apic)
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b987bccf0c8..e27d3db7e43f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -940,7 +940,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	vcpu->arch.xcr0 = xcr0;
 
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
-		kvm_update_cpuid(vcpu);
+		kvm_update_cpuid_runtime(vcpu);
 	return 0;
 }
 
@@ -1004,7 +1004,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		kvm_mmu_reset_context(vcpu);
 
 	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid(vcpu);
+		kvm_update_cpuid_runtime(vcpu);
 
 	return 0;
 }
@@ -2916,7 +2916,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
-			kvm_update_cpuid(vcpu);
+			kvm_update_cpuid_runtime(vcpu);
 		} else {
 			vcpu->arch.ia32_misc_enable_msr = data;
 		}
@@ -8170,7 +8170,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 		kvm_x86_ops.set_efer(vcpu, 0);
 #endif
 
-	kvm_update_cpuid(vcpu);
+	kvm_update_cpuid_runtime(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 
@@ -9192,7 +9192,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 				(X86_CR4_OSXSAVE | X86_CR4_PKE));
 	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
 	if (cpuid_update_needed)
-		kvm_update_cpuid(vcpu);
+		kvm_update_cpuid_runtime(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (is_pae_paging(vcpu)) {
-- 
2.18.4

