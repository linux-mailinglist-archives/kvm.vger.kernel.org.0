Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027D4E6B36
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 03:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfJ1C6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 22:58:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:35133 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbfJ1C6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 22:58:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 19:58:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,238,1569308400"; 
   d="scan'208";a="229552500"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2019 19:58:31 -0700
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
Subject: [PATCH v4 4/6] KVM: x86/vPMU: Introduce a new kvm_pmu_ops->msr_idx_to_pmc callback
Date:   Sun, 27 Oct 2019 18:52:41 +0800
Message-Id: <20191027105243.34339-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027105243.34339-1-like.xu@linux.intel.com>
References: <20191027105243.34339-1-like.xu@linux.intel.com>
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
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  3 ++-
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/pmu_amd.c       | 15 +++++++++++----
 arch/x86/kvm/vmx/pmu_intel.c | 13 +++++++++++++
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1d3252d4f9d4..2674a6659ba4 100644
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
index c4a80fe285a5..b253dd5e56cf 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -27,6 +27,7 @@ struct kvm_pmu_ops {
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
+	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index a4a6d8a09f70..8e7372e10251 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -199,14 +199,20 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 }
 
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	/* please use kvm_pmu_is_valid_msr() instead */
+	return false;
+}
+
+static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
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
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
+	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
 	.is_valid_rdpmc_ecx = amd_is_valid_rdpmc_ecx,
 	.is_valid_msr = amd_is_valid_msr,
 	.get_msr = amd_pmu_get_msr,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7a8067ec19bb..dcde142327ca 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -162,6 +162,18 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
+static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
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
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
+	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
 	.is_valid_rdpmc_ecx = intel_is_valid_rdpmc_ecx,
 	.is_valid_msr = intel_is_valid_msr,
 	.get_msr = intel_pmu_get_msr,
-- 
2.21.0

