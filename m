Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF0DFF28
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388149AbfJVIMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:12:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:64390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388257AbfJVIMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:12:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 01:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="200703512"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 22 Oct 2019 01:12:28 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com, peterz@infradead.org, kvm@vger.kernel.org
Cc:     like.xu@intel.com, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com
Subject: [PATCH v3 4/6] KVM: x86/vPMU: Introduce a new kvm_pmu_ops->msr_idx_to_pmc callback
Date:   Tue, 22 Oct 2019 00:06:49 +0800
Message-Id: <20191021160651.49508-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021160651.49508-1-like.xu@linux.intel.com>
References: <20191021160651.49508-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new callback msr_idx_to_pmc that returns a struct kvm_pmc*,
and change kvm_pmu_is_valid_msr to return ".msr_idx_to_pmc(vcpu, msr) ||
.is_valid_msr(vcpu, msr)" and AMD just returns false from .is_valid_msr.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  3 ++-
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/pmu_amd.c       | 15 +++++++++++----
 arch/x86/kvm/vmx/pmu_intel.c | 13 +++++++++++++
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index de362ba0df01..39a259b701e0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -339,7 +339,8 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	return kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr);
+	return kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
+		kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr);
 }
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c3faa70d9886..3b4f1942d206 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -27,6 +27,7 @@ struct kvm_pmu_ops {
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_idx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
+	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*is_valid_rdpmc_idx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 759b090f8140..88fe3f5f5bd1 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -199,14 +199,20 @@ static struct kvm_pmc *amd_rdpmc_idx_to_pmc(struct kvm_vcpu *vcpu,
 }
 
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	/* please use kvm_pmu_is_valid_msr() instead */
+	return false;
+}
+
+struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int ret = false;
+	struct kvm_pmc *pmc;
 
-	ret = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER) ||
-		get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
+	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
+	pmc = pmc ? pmc : get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 
-	return ret;
+	return pmc;
 }
 
 static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
@@ -308,6 +314,7 @@ struct kvm_pmu_ops amd_pmu_ops = {
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_idx_to_pmc = amd_rdpmc_idx_to_pmc,
+	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
 	.is_valid_rdpmc_idx = amd_is_valid_rdpmc_idx,
 	.is_valid_msr = amd_is_valid_msr,
 	.get_msr = amd_pmu_get_msr,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8b999dae15f2..714afcd9244c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -162,6 +162,18 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
+struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+
+	pmc = get_fixed_pmc(pmu, msr);
+	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
+	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
+
+	return pmc;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -367,6 +379,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_idx_to_pmc = intel_rdpmc_idx_to_pmc,
+	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
 	.is_valid_rdpmc_idx = intel_is_valid_rdpmc_idx,
 	.is_valid_msr = intel_is_valid_msr,
 	.get_msr = intel_pmu_get_msr,
-- 
2.21.0

