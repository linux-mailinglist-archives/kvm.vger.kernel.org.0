Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D220234C330
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhC2Ftm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:49:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhC2Ftj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:49:39 -0400
IronPort-SDR: +CLglwajrjfCM0187w0+26ZKq6kQJYWkq1VOfP9suNEBhKYUPEB7PRVyHGGfrnOG3p7HgRuq0K
 2H6GvdmTMz4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478731"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478731"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:49:39 -0700
IronPort-SDR: DyxNaJLyc8unW5YIXh8z0tmu1vlLey9MGIUWhg5sJCWxhFbIfgbunXI6XDVgXLdM6o1o2nrhb/
 uWHv80tY73gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417506742"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:49:35 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH v4 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
Date:   Mon, 29 Mar 2021 13:41:25 +0800
Message-Id: <20210329054137.120994-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel platforms, software may uses IA32_MISC_ENABLE[7]
bit to detect whether the performance monitoring facility
is supported in the processor.

It's dependent on the PMU being enabled for the guest and
a write to this PMU available bit will be ignored.

Cc: Yao Yuan <yuan.yao@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 1 +
 arch/x86/kvm/x86.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9efc1a6b8693..d9dbebe03cae 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
 	perf_get_x86_pmu_capability(&x86_pmu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d95f90a048..536b64360b75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3125,6 +3125,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_MISC_ENABLE:
+		data &= ~MSR_IA32_MISC_ENABLE_EMON;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
-- 
2.29.2

