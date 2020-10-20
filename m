Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3AD293F28
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407122AbgJTPCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 11:02:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:19882 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406930AbgJTPCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 11:02:22 -0400
IronPort-SDR: sQdDk8UkLymvyc4gV7/AIpw7VkwMd63MqYDRyQSOl6bUaqwf3hYvb7cDLdUcE0qTs6pJCbmUmc
 Yy2WXB2vYkmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="228851198"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="228851198"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 08:02:22 -0700
IronPort-SDR: kvHgMnI2kAxpcm5yAaq7cDX7P3tSol8NKIv+Gqolm2CoSMH0fRDMEbsBzo3cPQfXbijok9hzbj
 4pEh3DjeVCvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="301755425"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 20 Oct 2020 08:02:20 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: vmx/pmu: Use IA32_PERF_CAPABILITIES to adjust features visibility
Date:   Tue, 20 Oct 2020 22:57:55 +0800
Message-Id: <20201020145755.122333-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201020145755.122333-1-like.xu@linux.intel.com>
References: <20201020145755.122333-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel platforms, KVM agent could configure MSR_IA32_PERF_CAPABILITIES
(such as unmask some vmx-supported bits in vcpu->arch.perf_capabilities)
to adjust the visibility of guest PMU features for vPMU-enabled guests.

Once MSR_IA32_PERF_CAPABILITIES is changed via vmx_set_msr() validly,
the adjustment in intel_pmu_refresh() will be triggered. To ensure the
sustainability of the new value, the default initialization path is
moved to intel_pmu_init().

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 6 +++---
 arch/x86/kvm/vmx/vmx.c       | 5 +++++
 arch/x86/kvm/x86.c           | 2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 01c7d84ecf3e..7c18c85328da 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -327,7 +327,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
-	vcpu->arch.perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -342,8 +341,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
-		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -403,6 +400,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
 	}
+
+	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
+		vmx_get_perf_capabilities() : 0;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc..a3f3ce222af1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2182,6 +2182,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if ((data >> 32) != 0)
 			return 1;
 		goto find_uret_msr;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (data && !vcpu_to_pmu(vcpu)->version)
+			return 1;
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		break;
 
 	default:
 	find_uret_msr:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7b8f98ada93..a525447a92c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2985,7 +2985,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		vcpu->arch.perf_capabilities = data;
-
+		kvm_pmu_refresh(vcpu);
 		return 0;
 		}
 	case MSR_EFER:
-- 
2.21.3

