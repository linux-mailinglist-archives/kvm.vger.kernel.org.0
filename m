Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0874C2ADD
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbfI3X2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:28:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:63706 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732506AbfI3X2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:28:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 16:28:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,568,1559545200"; 
   d="scan'208";a="215880222"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 30 Sep 2019 16:28:00 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/vPMU: Reuse perf_event to avoid unnecessary pmc_reprogram_counter
Date:   Mon, 30 Sep 2019 15:22:56 +0800
Message-Id: <20190930072257.43352-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930072257.43352-1-like.xu@linux.intel.com>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The perf_event_create_kernel_counter() in the pmc_reprogram_counter() is
a high-frequency and heavyweight operation, especially when host disables
the watchdog (maximum 21000000 ns) which leads to an unacceptable latency
of the guest NMI handler and limits the vPMU usage scenario.

When a vPMC is fully enabled, the legacy reprogram_*_counter() would stop
and release its existing perf_event (if any) every time EVEN in most cases
almost the same requested perf_event will be created and configured again.

For each vPMC, if the reuqested config ('u64 eventsel' for gp and 'u8 ctrl'
for fixed) is the same as its last programed config AND a new sample period
based on pmc->counter is accepted by host perf interface, the current event
could be reused safely as a new created one does. Otherwise, do release the
undesirable perf_event and reprogram a new one as usual.

It's light-weight to call pmc_pause_counter (disable event & reset count)
and pmc_resume_counter (recalibrate period & re-enable event) as guest
expects instead of release-and-create again on any condition. Compared to
use the filterable event->attr or hw.config, a new 'u64 programed_config'
field is added to save the last original programed config for each vPMC.

Based on this implementation, the number of calls to pmc_reprogram_counter
is reduced by ~94% for a gp sampling event and ~99.9% for a fixed event.
In the usage of multiplexing perf sampling mode, the average latency of the
guest NMI handler is reduced from 99450 ns to 56195 ns (1.76x speed up).
If host disables watchdog, the minimum latecy of guest NMI handler could be
speed up at 2994x (from 18134692 to 6057 ns) and in the average at 685x.

Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              | 45 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/pmu.h              | 12 +++++++--
 arch/x86/kvm/pmu_amd.c          |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    |  2 ++
 5 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 23edf56cf577..15f2ebad94f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -458,6 +458,8 @@ struct kvm_pmc {
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
+	/* the exact requested config for perf_event reusability check */
+	u64 programed_config;
 };
 
 struct kvm_pmu {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 46875bbd0419..74bc5c42b8b5 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -140,6 +140,35 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
+static void pmc_pause_counter(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event)
+		return;
+
+	pmc->counter = pmc_read_counter(pmc);
+
+	perf_event_disable(pmc->perf_event);
+
+	/* reset count to avoid redundant accumulation */
+	local64_set(&pmc->perf_event->count, 0);
+}
+
+static bool pmc_resume_counter(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event)
+		return false;
+
+	/* recalibrate sample period and check if it's accepted by perf core */
+	if (perf_event_period(pmc->perf_event,
+			(-pmc->counter) & pmc_bitmask(pmc)))
+		return false;
+
+	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
+	perf_event_enable(pmc->perf_event);
+	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
+	return true;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
@@ -154,7 +183,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	pmc->eventsel = eventsel;
 
-	pmc_stop_counter(pmc);
+	pmc_pause_counter(pmc);
 
 	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
 		return;
@@ -193,6 +222,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (type == PERF_TYPE_RAW)
 		config = eventsel & X86_RAW_EVENT_MASK;
 
+	if (pmc->programed_config == eventsel && pmc_resume_counter(pmc))
+		return;
+
+	pmc_release_perf_event(pmc);
+
+	pmc->programed_config = eventsel;
 	pmc_reprogram_counter(pmc, type, config,
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
@@ -209,7 +244,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 	struct kvm_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
 
-	pmc_stop_counter(pmc);
+	pmc_pause_counter(pmc);
 
 	if (!en_field || !pmc_is_enabled(pmc))
 		return;
@@ -224,6 +259,12 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 			return;
 	}
 
+	if (pmc->programed_config == (u64)ctrl && pmc_resume_counter(pmc))
+		return;
+
+	pmc_release_perf_event(pmc);
+
+	pmc->programed_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
 			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..3a95952702d2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -55,12 +55,20 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	return counter & pmc_bitmask(pmc);
 }
 
-static inline void pmc_stop_counter(struct kvm_pmc *pmc)
+static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
 	if (pmc->perf_event) {
-		pmc->counter = pmc_read_counter(pmc);
 		perf_event_release_kernel(pmc->perf_event);
 		pmc->perf_event = NULL;
+		pmc->programed_config = 0;
+	}
+}
+
+static inline void pmc_stop_counter(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		pmc->counter = pmc_read_counter(pmc);
+		pmc_release_perf_event(pmc);
 	}
 }
 
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index c8388389a3b0..3d656b2d439f 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -285,6 +285,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
+		pmu->gp_counters[i].programed_config = 0;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0e7e39..73bbefa1d54e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -325,12 +325,14 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
+		pmu->gp_counters[i].programed_config = 0;
 	}
 
 	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
+		pmu->fixed_counters[i].programed_config = 0;
 	}
 }
 
-- 
2.21.0

