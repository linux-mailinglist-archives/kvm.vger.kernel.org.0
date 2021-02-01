Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1F30A126
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhBAFUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:20:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:9259 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhBAFTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:19:00 -0500
IronPort-SDR: 7y37UNG6yzT9yafdvm7uRKH/x3/BdcvvB9lngEQri2pw/rRcUIr5Et9KdxmGq+1grsDT0vFYqx
 Z/Knm3ngArhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401830"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401830"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:14 -0800
IronPort-SDR: 3Hfj1G/ekzqrbgdBONjau8RB4kDjU2c89LZUjboEv+S9CQ4YcQxPGOW50z07uA1eF4t/02c0Dg
 kSwfD4eSZdJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694270"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:11 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 02/11] KVM: x86/pmu: Set up IA32_PERF_CAPABILITIES if PDCM bit is available
Date:   Mon,  1 Feb 2021 13:10:30 +0800
Message-Id: <20210201051039.255478-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel platforms, KVM userspace will be able to configure
MSR_IA32_PERF_CAPABILITIES to adjust the visibility of guest
PMU features for vPMU-enabled guests.

Once MSR_IA32_PERF_CAPABILITIES is changed via vmx_set_msr(),
the adjustment in intel_pmu_refresh() will be triggered. To
ensure that the new value is kept, the default initialization
path is moved to intel_pmu_init().

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 5 ++---
 arch/x86/kvm/vmx/vmx.c       | 5 +++++
 arch/x86/kvm/x86.c           | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index cdf5f34518f4..f632039173ff 100644
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
@@ -405,6 +402,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
 	}
+
+	vcpu->arch.perf_capabilities = 0;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4aa378c20986..387adaa1194f 100644
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
index 42ef3659b20a..bdb0b3a37147 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3038,7 +3038,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		vcpu->arch.perf_capabilities = data;
-
+		kvm_pmu_refresh(vcpu);
 		return 0;
 		}
 	case MSR_EFER:
-- 
2.29.2

