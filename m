Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B35ADFF26
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388261AbfJVIM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:12:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:64390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388257AbfJVIM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:12:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 01:12:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="200703505"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 22 Oct 2019 01:12:26 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com, peterz@infradead.org, kvm@vger.kernel.org
Cc:     like.xu@intel.com, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com
Subject: [PATCH v3 3/6] KVM: x86/vPMU: Rename pmu_ops callbacks from msr_idx to rdpmc_idx
Date:   Tue, 22 Oct 2019 00:06:48 +0800
Message-Id: <20191021160651.49508-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021160651.49508-1-like.xu@linux.intel.com>
References: <20191021160651.49508-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The leagcy pmu_ops->msr_idx_to_pmc is only called in kvm_pmu_rdpmc, so
this name is restrictedly limited to rdpmc_idx which could be indexed
exactly to a kvm_pmc. Let's restrict its semantic by renaming the
existing msr_idx_to_pmc to rdpmc_idx_to_pmc, and is_valid_msr_idx to
is_valid_rdpmc_idx (likewise for kvm_pmu_is_valid_msr_idx).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  6 +++---
 arch/x86/kvm/pmu.h           |  8 ++++----
 arch/x86/kvm/pmu_amd.c       |  9 +++++----
 arch/x86/kvm/vmx/pmu_intel.c | 10 +++++-----
 arch/x86/kvm/x86.c           |  2 +-
 5 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 46875bbd0419..de362ba0df01 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -271,9 +271,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 }
 
 /* check if idx is a valid index to access PMU */
-int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+int kvm_pmu_is_valid_rdpmc_idx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_x86_ops->pmu_ops->is_valid_msr_idx(vcpu, idx);
+	return kvm_x86_ops->pmu_ops->is_valid_rdpmc_idx(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -323,7 +323,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, idx, &mask);
+	pmc = kvm_x86_ops->pmu_ops->rdpmc_idx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..c3faa70d9886 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -25,9 +25,9 @@ struct kvm_pmu_ops {
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
-	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx,
-					  u64 *mask);
-	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
+	struct kvm_pmc *(*rdpmc_idx_to_pmc)(struct kvm_vcpu *vcpu,
+		unsigned int idx, u64 *mask);
+	int (*is_valid_rdpmc_idx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
@@ -110,7 +110,7 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
-int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
+int kvm_pmu_is_valid_rdpmc_idx(struct kvm_vcpu *vcpu, unsigned int idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index c8388389a3b0..759b090f8140 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -174,7 +174,7 @@ static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 }
 
 /* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
-static int amd_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+static int amd_is_valid_rdpmc_idx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
@@ -184,7 +184,8 @@ static int amd_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
 }
 
 /* idx is the ECX register of RDPMC instruction */
-static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *mask)
+static struct kvm_pmc *amd_rdpmc_idx_to_pmc(struct kvm_vcpu *vcpu,
+	unsigned int idx, u64 *mask)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *counters;
@@ -306,8 +307,8 @@ struct kvm_pmu_ops amd_pmu_ops = {
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
-	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
-	.is_valid_msr_idx = amd_is_valid_msr_idx,
+	.rdpmc_idx_to_pmc = amd_rdpmc_idx_to_pmc,
+	.is_valid_rdpmc_idx = amd_is_valid_rdpmc_idx,
 	.is_valid_msr = amd_is_valid_msr,
 	.get_msr = amd_pmu_get_msr,
 	.set_msr = amd_pmu_set_msr,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3e9c059099e9..8b999dae15f2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -111,7 +111,7 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 }
 
 /* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
-static int intel_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+static int intel_is_valid_rdpmc_idx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
@@ -122,8 +122,8 @@ static int intel_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
 		(fixed && idx >= pmu->nr_arch_fixed_counters);
 }
 
-static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
-					    unsigned idx, u64 *mask)
+static struct kvm_pmc *intel_rdpmc_idx_to_pmc(struct kvm_vcpu *vcpu,
+					    unsigned int idx, u64 *mask)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
@@ -366,8 +366,8 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
-	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-	.is_valid_msr_idx = intel_is_valid_msr_idx,
+	.rdpmc_idx_to_pmc = intel_rdpmc_idx_to_pmc,
+	.is_valid_rdpmc_idx = intel_is_valid_rdpmc_idx,
 	.is_valid_msr = intel_is_valid_msr,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..72ce691fd45d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6111,7 +6111,7 @@ static void emulator_set_smbase(struct x86_emulate_ctxt *ctxt, u64 smbase)
 static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
 			      u32 pmc)
 {
-	return kvm_pmu_is_valid_msr_idx(emul_to_vcpu(ctxt), pmc);
+	return kvm_pmu_is_valid_rdpmc_idx(emul_to_vcpu(ctxt), pmc);
 }
 
 static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
-- 
2.21.0

