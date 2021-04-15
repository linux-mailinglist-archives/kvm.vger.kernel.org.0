Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8C36003F
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhDODVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:21:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:1119 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhDODVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:21:01 -0400
IronPort-SDR: R6R8egIkm6ZDylhZw+kJWNwUvFLbRaG5okgC9F/vT05fYyJmiKD5znvvSplZWS10Z7pLiK9Cc7
 o0dvtREGinlw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="191592836"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="191592836"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:20:38 -0700
IronPort-SDR: QQ9forMpHkyfI3O6LB/A1xSFyX8UhjbgPncptD1JOXYpfPebcRk0oixU7dAH7qfK4cW7hP3fnQ
 ntAcLL3dU6Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425013917"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:20:34 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH v5 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
Date:   Thu, 15 Apr 2021 11:20:04 +0800
Message-Id: <20210415032016.166201-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415032016.166201-1-like.xu@linux.intel.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
detect whether the processor supports performance monitoring facility.

It depends on the PMU is enabled for the guest, and a software write
operation to this available bit will be ignored.

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
index 16fb39503296..1a64e816e06d 100644
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
2.30.2

