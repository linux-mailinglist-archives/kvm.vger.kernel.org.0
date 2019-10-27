Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC42EE6B33
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 03:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfJ1C6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 22:58:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:35133 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfJ1C6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 22:58:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 19:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,238,1569308400"; 
   d="scan'208";a="229552490"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2019 19:58:28 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kan.liang@intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 3/6] KVM: x86/vPMU: Rename pmu_ops callbacks from msr_idx to rdpmc_ecx
Date:   Sun, 27 Oct 2019 18:52:40 +0800
Message-Id: <20191027105243.34339-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027105243.34339-1-like.xu@linux.intel.com>
References: <20191027105243.34339-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The leagcy pmu_ops->msr_idx_to_pmc is only called in kvm_pmu_rdpmc, so
this name is restrictedly limited to rdpmc_ecx which could be indexed
exactly to a kvm_pmc. Let's restrict its semantic by renaming the
existing msr_idx_to_pmc to rdpmc_ecx_to_pmc, and is_valid_msr_idx to
is_valid_rdpmc_ecx (likewise for kvm_pmu_is_valid_msr_idx).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  6 +++---
 arch/x86/kvm/pmu.h           |  8 ++++----
 arch/x86/kvm/pmu_amd.c       |  9 +++++----
 arch/x86/kvm/vmx/pmu_intel.c | 10 +++++-----
 arch/x86/kvm/x86.c           |  2 +-
 5 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 46875bbd0419..1d3252d4f9d4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -271,9 +271,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 }
 
 /* check if idx is a valid index to access PMU */
-int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_x86_ops->pmu_ops->is_valid_msr_idx(vcpu, idx);
+	return kvm_x86_ops->pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -323,7 +323,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, idx, &mask);
+	pmc = kvm_x86_ops->pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..c4a80fe285a5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -25,9 +25,9 @@ struct kvm_pmu_ops {
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
-	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx,
-					  u64 *mask);
-	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
+	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
+		unsigned int idx, u64 *mask);
+	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
@@ -110,7 +110,7 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
-int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
+int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index c8388389a3b0..a4a6d8a09f70 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -174,7 +174,7 @@ static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 }
 
 /* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
-static int amd_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+static int amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
@@ -184,7 +184,8 @@ static int amd_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
 }
 
 /* idx is the ECX register of RDPMC instruction */
-static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *mask)
+static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
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
+	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
+	.is_valid_rdpmc_ecx = amd_is_valid_rdpmc_ecx,
 	.is_valid_msr = amd_is_valid_msr,
 	.get_msr = amd_pmu_get_msr,
 	.set_msr = amd_pmu_set_msr,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3e9c059099e9..7a8067ec19bb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -111,7 +111,7 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 }
 
 /* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
-static int intel_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
+static int intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
@@ -122,8 +122,8 @@ static int intel_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
 		(fixed && idx >= pmu->nr_arch_fixed_counters);
 }
 
-static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
-					    unsigned idx, u64 *mask)
+static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
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
+	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
+	.is_valid_rdpmc_ecx = intel_is_valid_rdpmc_ecx,
 	.is_valid_msr = intel_is_valid_msr,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f812719..726a74e1c6a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6108,7 +6108,7 @@ static void emulator_set_smbase(struct x86_emulate_ctxt *ctxt, u64 smbase)
 static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
 			      u32 pmc)
 {
-	return kvm_pmu_is_valid_msr_idx(emul_to_vcpu(ctxt), pmc);
+	return kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc);
 }
 
 static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
-- 
2.21.0

