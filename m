Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD1C2AAF4D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgKICRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:64927 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbgKICRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:23 -0500
IronPort-SDR: PGEmqCHIPVBjzs1qNmjYSszxz1J+hEH0RYuPfg3YagHkgpdeZq6E2KInsXFQQYzSSBb7aSo1fC
 rHknhz0y5SnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684607"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684607"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:09 -0800
IronPort-SDR: PDWCVRH/QjBAccniIohJaf05T3OLrWAzeNpkQx/uqJlac55iP0l1jSh0MS4tKRC0g5Ur417Ksw
 Z12u9HZ2wZNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646163"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:05 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/17] KVM: x86/pmu: Reprogram guest PEBS event to emulate guest PEBS counter
Date:   Mon,  9 Nov 2020 10:12:42 +0800
Message-Id: <20201109021254.79755-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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

The attr.precise_ip would be adjusted to a special precision
level when the new PEBS-PDIR feature is supported later which
would affect the host counters scheduling.

The guest PEBS event would not be reused for non-PEBS
guest event even with the same guest counter index.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              | 28 ++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 505f9b39c423..eb0d73a095a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -449,6 +449,8 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 pebs_enable;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 67741d2a0308..c6208234e007 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -76,7 +76,11 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		if (perf_event->attr.precise_ip) {
+			/* Indicate PEBS overflow PMI to guest. */
+			__set_bit(62, (unsigned long *)&pmu->global_status);
+		} else
+			__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
 		/*
@@ -99,6 +103,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -110,6 +115,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
@@ -124,9 +130,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
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
@@ -161,6 +181,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
+	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
+	    pmc->perf_event->attr.precise_ip)
+		return false;
+
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
 	perf_event_enable(pmc->perf_event);
 
-- 
2.21.3

