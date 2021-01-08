Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CBD2EEB0D
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbhAHBqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:46:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:27993 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729466AbhAHBqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:46:09 -0500
IronPort-SDR: uqKyTDYG1Wp+69dKGRWoK5v5J5xHl/BBU88mjMYrLSim1bNMewFPQoVLvY0sFew/sNUAacTV0S
 82OB5aggkO/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177672386"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177672386"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 17:43:14 -0800
IronPort-SDR: r3Lu4qp+eMJ0PLLfj1cPpDKLwA5CNbEcWqoA5qIWR3zv8MupfN0FsGYGz3t594mzbE5pDY31E3
 Bgjt04ANwfpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379938048"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 07 Jan 2021 17:43:10 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v13 03/10] KVM: x86/pmu: Use IA32_PERF_CAPABILITIES to adjust features visibility
Date:   Fri,  8 Jan 2021 09:36:57 +0800
Message-Id: <20210108013704.134985-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108013704.134985-1-like.xu@linux.intel.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
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
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 6 +++---
 arch/x86/kvm/vmx/vmx.c       | 5 +++++
 arch/x86/kvm/x86.c           | 2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a886a47daebd..f8083ecf8c7b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -327,7 +327,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
-	vcpu->arch.perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -340,8 +339,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
-		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -401,6 +398,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
 	}
+
+	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
+		vmx_get_perf_capabilities() : 0;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 035bd6d279a4..085a14579bbe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2209,6 +2209,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index c765fd72a66c..a1b251ae648a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3037,7 +3037,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		vcpu->arch.perf_capabilities = data;
-
+		kvm_pmu_refresh(vcpu);
 		return 0;
 		}
 	case MSR_EFER:
-- 
2.29.2

