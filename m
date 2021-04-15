Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B81360045
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhDODVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:21:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:2262 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhDODVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:21:19 -0400
IronPort-SDR: y4aiIMuQYHLSqp4plARlvDX2WAZP4346c7dtS0ggnZkoGXmzY/hA4uba7uLivVDxJBvIHZttLW
 54Y0X0Dt7Fuw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="258742987"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="258742987"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:20:46 -0700
IronPort-SDR: hYclY1+A9HeeaHLEM74gHCetl4pGT5Mt5SkVcsFahofvwD8L0d8gMM/ay8wZVEQ3YMdHBfaFGZ
 bQm4dNFH1SwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425013970"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:20:42 -0700
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
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v5 06/16] KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
Date:   Thu, 15 Apr 2021 11:20:06 +0800
Message-Id: <20210415032016.166201-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415032016.166201-1-like.xu@linux.intel.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest counter is configured as a PEBS counter through
IA32_PEBS_ENABLE, a guest PEBS event will be reprogrammed by
configuring a non-zero precision level in the perf_event_attr.

The guest PEBS overflow PMI bit would be set in the guest
GLOBAL_STATUS MSR when PEBS facility generates a PEBS
overflow PMI based on guest IA32_DS_AREA MSR.

Even with the same counter index and the same event code and
mask, guest PEBS events will not be reused for non-PEBS events.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 827886c12c16..0f86c1142f17 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -74,11 +74,21 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 {
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	bool skip_pmi = false;
 
 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		if (perf_event->attr.precise_ip) {
+			/* Indicate PEBS overflow PMI to guest. */
+			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+						      (unsigned long *)&pmu->global_status);
+		} else {
+			__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		}
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
+		if (skip_pmi)
+			return;
+
 		/*
 		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
 		 * can be ejected on a guest mode re-entry. Otherwise we can't
@@ -99,6 +109,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -110,6 +121,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
@@ -124,9 +136,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		attr.sample_period = 0;
 		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
+	if (pebs) {
+		/*
+		 * The non-zero precision level of guest event makes the ordinary
+		 * guest event becomes a guest PEBS event and triggers the host
+		 * PEBS PMI handler to determine whether the PEBS overflow PMI
+		 * comes from the host counters or the guest.
+		 *
+		 * For most PEBS hardware events, the difference in the software
+		 * precision levels of guest and host PEBS events will not affect
+		 * the accuracy of the PEBS profiling result, because the "event IP"
+		 * in the PEBS record is calibrated on the guest side.
+		 */
+		attr.precise_ip = 1;
+	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 intr ? kvm_perf_overflow_intr :
+						 (intr || pebs) ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
@@ -161,6 +187,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
+	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
+	    pmc->perf_event->attr.precise_ip)
+		return false;
+
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
 	perf_event_enable(pmc->perf_event);
 
-- 
2.30.2

