Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384E4EABC6
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 09:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfJaIuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 04:50:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:43817 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfJaIuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 04:50:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 01:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="401811082"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 31 Oct 2019 01:50:04 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     like.xu@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Update guest cpuid10 entry if pmu->nr_*_counters are changed
Date:   Thu, 31 Oct 2019 00:44:18 +0800
Message-Id: <20191030164418.2957-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the cpuid10_eax.split.num_counters* from kvm_vcpu_ioctl_set_cpuid2
is larger than the host x86_pmu.num_counters_*, the min_t() is applied.
We need do cpuid synchronisation locally for cpuid10 entry to avoid
functional ambiguity and it's heavyweight to call kvm_update_cpuid for
these simple assignments.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3e9c059099e9..f83b7506dcff 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -266,6 +266,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	bool cpuid_update_needed = false;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -288,6 +289,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
+	if (pmu->nr_arch_gp_counters != eax.split.num_counters)
+		cpuid_update_needed = true;
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
@@ -298,6 +301,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
 			      x86_pmu.num_counters_fixed);
+		if (pmu->nr_arch_fixed_counters != edx.split.num_counters_fixed)
+			cpuid_update_needed = true;
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
@@ -317,6 +322,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
 		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+
+	if (cpuid_update_needed) {
+		((union cpuid10_eax *)&entry->eax)->split.num_counters
+			= pmu->nr_arch_gp_counters;
+		((union cpuid10_edx *)&entry->edx)->split.num_counters_fixed
+			= pmu->nr_arch_fixed_counters;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.21.0

