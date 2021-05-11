Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50D0379D07
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhEKCo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:44:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:7554 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhEKCoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:44:25 -0400
IronPort-SDR: aeJUavLJyyotwvVdT29KTKWfRYVWDvL+561eMBbN91xO8vMAKC95ZwLQmLSV8LNQpEWB2naePK
 qgVjava+jynQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199391206"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199391206"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:43:19 -0700
IronPort-SDR: 7a2b7LbHr3hNjpiW68vgkN+qcs/SroJu8xA2EpY2hxOzZ+tzr77nHgOQMQcCFhSsfXbfJe1SGn
 /LkGDzI27yGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468591710"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:43:15 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v6 05/16] KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
Date:   Tue, 11 May 2021 10:42:03 +0800
Message-Id: <20210511024214.280733-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511024214.280733-1-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mask value of fixed counter control register should be dynamic
adjusted with the number of fixed counters. This patch introduces a
variable that includes the reserved bits of fixed counter control
registers. This is needed for later Ice Lake fixed counter changes.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..49b421bd3dd8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -457,6 +457,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
 	u64 global_ovf_ctrl;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d9dbebe03cae..ac7fe714e6c1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -400,7 +400,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		if (pmu->fixed_ctr_ctrl == data)
 			return 0;
-		if (!(data & 0xfffffffffffff444ull)) {
+		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
 			reprogram_fixed_counters(pmu, data);
 			return 0;
 		}
@@ -470,6 +470,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	int i;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -477,6 +478,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->fixed_ctr_ctrl_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -511,6 +513,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
 
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
 	pmu->global_ctrl_mask = ~pmu->global_ctrl;
-- 
2.31.1

