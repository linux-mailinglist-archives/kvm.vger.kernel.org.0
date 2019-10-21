Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E29DFC18
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 05:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbfJVDAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 23:00:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:10515 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387463AbfJVDAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 23:00:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 20:00:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="398869385"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2019 20:00:34 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, like.xu@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/vPMU: Declare kvm_pmu->reprogram_pmi field using DECLARE_BITMAP
Date:   Mon, 21 Oct 2019 18:55:04 +0800
Message-Id: <20191021105504.120838-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <2175c2cd-2c1e-22e8-2f67-3fc334ef2a40@redhat.com>
References: <2175c2cd-2c1e-22e8-2f67-3fc334ef2a40@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the explicit declaration of "u64 reprogram_pmi" with the generic
macro DECLARE_BITMAP for all possible appropriate number of bits.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/pmu.c              | 15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50eb430b0ad8..236a876a5a2e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -469,7 +469,7 @@ struct kvm_pmu {
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
-	u64 reprogram_pmi;
+	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 46875bbd0419..75e8f9fae031 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -62,8 +62,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!test_and_set_bit(pmc->idx,
-			      (unsigned long *)&pmu->reprogram_pmi)) {
+	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 	}
@@ -76,8 +75,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!test_and_set_bit(pmc->idx,
-			      (unsigned long *)&pmu->reprogram_pmi)) {
+	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
@@ -137,7 +135,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	pmc->perf_event = event;
-	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
+	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
@@ -253,16 +251,13 @@ EXPORT_SYMBOL_GPL(reprogram_counter);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	u64 bitmask;
 	int bit;
 
-	bitmask = pmu->reprogram_pmi;
-
-	for_each_set_bit(bit, (unsigned long *)&bitmask, X86_PMC_IDX_MAX) {
+	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
 		struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
-			clear_bit(bit, (unsigned long *)&pmu->reprogram_pmi);
+			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
 
-- 
2.21.0

