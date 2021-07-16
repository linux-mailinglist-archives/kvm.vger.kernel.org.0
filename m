Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBB13CB4CD
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 10:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhGPI5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 04:57:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:47980 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238896AbhGPI5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 04:57:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="274526338"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="274526338"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:54:19 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="495983922"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:54:15 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Yao Yuan <yuan.yao@intel.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V8 05/18] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
Date:   Fri, 16 Jul 2021 16:53:12 +0800
Message-Id: <20210716085325.10300-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210716085325.10300-1-lingshan.zhu@intel.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
detect whether the processor supports performance monitoring facility.

It depends on the PMU is enabled for the guest, and a software write
operation to this available bit will be ignored. The proposal to ignore
the toggle in KVM is the way to go and that behavior matches bare metal.

Cc: Yao Yuan <yuan.yao@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
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
index 429cb4c22097..2f5d1ed00e4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_MISC_ENABLE:
+		data &= ~MSR_IA32_MISC_ENABLE_EMON;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
-- 
2.27.0

