Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D9A2E95DA
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbhADNXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:23:52 -0500
Received: from mga07.intel.com ([134.134.136.100]:23250 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbhADNXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:23:51 -0500
IronPort-SDR: vh6eDlTf1FajgIEvsjVEkcuVZKpVw7zItICBIVxPVQlhNGiskx0bsoXMp35qHPhOXFsKyhB6RO
 URqablbLZpRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034286"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034286"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:05 -0800
IronPort-SDR: 8V3wvu92/v3Ugp0BmNmnvuYtRtHlhMone7GdyMUmehzi5qoTiw+RF3xedx164O6OnmqXXgWbn+
 xjcgL08CqDOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944526"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:02 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/17] KVM: x86/pmu: Use IA32_PERF_CAPABILITIES to adjust features visibility
Date:   Mon,  4 Jan 2021 21:15:27 +0800
Message-Id: <20210104131542.495413-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel platforms, KVM agent could configure MSR_IA32_PERF_CAPABILITIES
(such as unmask some vmx-supported bits in vcpu->arch.perf_capabilities)
to adjust the visibility of guest PMU features for vPMU-enabled guests.

Once MSR_IA32_PERF_CAPABILITIES is changed validly via vmx_set_msr(),
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
index 75c9c6a0a3a4..09bc41c53cd8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2196,6 +2196,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 87f97ffa9966..a38ca932eec5 100644
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

