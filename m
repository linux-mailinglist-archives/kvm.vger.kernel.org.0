Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01F53B0093
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFVJqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:46:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:20239 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhFVJqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:46:25 -0400
IronPort-SDR: UJVUd5CgRxq9Y27bEr4r6k7ikMQjtQtH3MJZcC9PFB1wKINH+Iw3A75++yHIdR8xtZbkUj2MwQ
 xHi4b8kyuANw==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194330993"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194330993"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:58 -0700
IronPort-SDR: AWGaIfpHE6oEIxgpEXdZBEiR+s1IhGkQx5YZEeckuyvlTIHImbg4oN46z9gWV9wOoo8SaPch8q
 Icx9UCkRtpWQ==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="641600225"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:54 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V7 09/18] KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
Date:   Tue, 22 Jun 2021 17:42:57 +0800
Message-Id: <20210622094306.8336-10-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

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
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/x86/kvm/pmu.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2dcbd1b30004..d76b0a5d80d7 100644
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
@@ -110,6 +121,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+	perf_overflow_handler_t ovf = kvm_perf_overflow;
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
@@ -124,10 +137,27 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
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
+		 *
+		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
+		 * could possibly care here is unsupported and needs changes.
+		 */
+		attr.precise_ip = 1;
+	}
+	if (pebs || intr)
+		ovf = kvm_perf_overflow_intr;
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 intr ? kvm_perf_overflow_intr :
-						 kvm_perf_overflow, pmc);
+	event = perf_event_create_kernel_counter(&attr, -1, current, ovf, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
 			    PTR_ERR(event), pmc->idx);
@@ -161,6 +191,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
+	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
+	    pmc->perf_event->attr.precise_ip)
+		return false;
+
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
 	perf_event_enable(pmc->perf_event);
 
-- 
2.27.0

