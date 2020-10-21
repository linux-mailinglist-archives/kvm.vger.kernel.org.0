Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DCF294A36
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437421AbgJUJKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:58982 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437412AbgJUJKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:41 -0400
IronPort-SDR: beshNKjWfC/TpHV2fUZtxSWZHbF5pO+lETlBvIG2J9jyeQ30qDKVzWQ1Onw4IOFdx2CXX3YVSo
 Bnd3U8hXeYeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530470"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530470"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:39 -0700
IronPort-SDR: NyV5lLzv6sQZ2+jtKDJV5Bgjjg+9D4k8nRvVhTTuBVvc/mhA4heLhO+QfL0igeqCJOKzJEk2PM
 h1njaRiKyn9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682477"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:37 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 6/7] kvm: x86: Refactor kvm_vcpu_after_set_cpuid()
Date:   Wed, 21 Oct 2020 17:10:09 +0800
Message-Id: <1603271410-71343-7-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract kvm_pv_unhalt_toggle_cpuid() from kvm_update_cpuid_runtime().
Add/wrap other 2 functions: kvm_pv_unhalt_toggle_cpuid() and
kvm_pv_unhalt_toggle_cpuid().
Refactor kvm_vcpu_after_set_cpuid() with these new functions.

kvm_vcpu_after_set_cpuid() contents doesn't essentially change.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 59 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ff2d73c..454eda9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,6 +125,41 @@ void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
 		e->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 }
 
+static void kvm_pv_unhalt_toggle_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *e;
+
+	e = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	if (kvm_hlt_in_guest(vcpu->kvm) && e &&
+	    (e->eax & (1 << KVM_FEATURE_PV_UNHALT)))
+		e->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
+}
+
+static void kvm_update_maxphyaddr(struct kvm_vcpu *vcpu)
+{
+
+	/* Note, maxphyaddr must be updated before tdp_level. */
+	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	kvm_mmu_reset_context(vcpu);
+}
+
+static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (apic) {
+		struct kvm_cpuid_entry2 *e;
+
+		e = kvm_find_cpuid_entry(vcpu, 1, 0);
+		if (!e)
+			return;
+		if (cpuid_entry_has(e, X86_FEATURE_TSC_DEADLINE_TIMER))
+			apic->lapic_timer.timer_mode_mask = 3 << 17;
+		else
+			apic->lapic_timer.timer_mode_mask = 1 << 17;
+	}
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -170,30 +205,16 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	struct kvm_cpuid_entry2 *best;
-
 	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
-	if (best && apic) {
-		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
-			apic->lapic_timer.timer_mode_mask = 3 << 17;
-		else
-			apic->lapic_timer.timer_mode_mask = 1 << 17;
+	kvm_update_lapic_timer_mode(vcpu);
+	kvm_apic_set_version(vcpu);
 
-		kvm_apic_set_version(vcpu);
-	}
+	kvm_xcr0_update_cpuid(vcpu);
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best)
-		vcpu->arch.guest_supported_xcr0 = 0;
-	else
-		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+	kvm_update_maxphyaddr(vcpu);
 
-	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	kvm_mmu_reset_context(vcpu);
+	kvm_pv_unhalt_toggle_cpuid(vcpu);
 
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
-- 
1.8.3.1

