Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF972E95EC
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbhADN1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:27:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:23242 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbhADN1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:27:47 -0500
IronPort-SDR: MzK1duyH9jnufNKLFt2IHQpyD0qdbJCWW3qmTFxem+cfLB/5SD+8IGBJLlWT/Pi1Lf6XKRLKNx
 ckAXv8DG5qEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034356"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034356"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:29 -0800
IronPort-SDR: V3QLTmqhuWAhAPq5N7CVtMd3EeW49h0LVSZz5EgncE+g8Ifcjvc0JH1PsJKBeJcbxK8Jd6nrH4
 NepbiIOSoJIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944612"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:26 -0800
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
Subject: [PATCH v3 09/17] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Mon,  4 Jan 2021 21:15:34 +0800
Message-Id: <20210104131542.495413-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bit 12 represents "Processor Event Based Sampling Unavailable (RO)" :
	1 = PEBS is not supported.
	0 = PEBS is supported.

A write to this PEBS_UNAVL available bit will bring #GP(0) when guest PEBS
is enabled. Some PEBS drivers in guest may care about this bit.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/x86.c           | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c04e12812797..99d9453e0176 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -426,6 +426,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = ~pmu->global_ctrl;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
@@ -436,6 +437,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		} else
 			pmu->pebs_enable_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
 	} else {
+		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a38ca932eec5..213368e47500 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3095,6 +3095,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_MISC_ENABLE:
 		data &= ~MSR_IA32_MISC_ENABLE_EMON;
+		if (!msr_info->host_initiated &&
+		    (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) &&
+		    (data & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
+			return 1;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
-- 
2.29.2

