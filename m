Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74C6E6B38
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 03:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfJ1C6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 22:58:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:35133 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbfJ1C6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 22:58:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 19:58:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,238,1569308400"; 
   d="scan'208";a="229552514"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2019 19:58:35 -0700
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
Subject: [PATCH v4 5/6] KVM: x86/vPMU: Reuse perf_event to avoid unnecessary pmc_reprogram_counter
Date:   Sun, 27 Oct 2019 18:52:42 +0800
Message-Id: <20191027105243.34339-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027105243.34339-1-like.xu@linux.intel.com>
References: <20191027105243.34339-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The perf_event_create_kernel_counter() in the pmc_reprogram_counter() is
a heavyweight and high-frequency operation, especially when host disables
the watchdog (maximum 21000000 ns) which leads to an unacceptable latency
of the guest NMI handler. It limits the use of vPMUs in the guest.

When a vPMC is fully enabled, the legacy reprogram_*_counter() would stop
and release its existing perf_event (if any) every time EVEN in most cases
almost the same requested perf_event will be created and configured again.

For each vPMC, if the reuqested config ('u64 eventsel' for gp and 'u8 ctrl'
for fixed) is the same as its current config AND a new sample period based
on pmc->counter is accepted by host perf interface, the current event could
be reused safely as a new created one does. Otherwise, do release the
undesirable perf_event and reprogram a new one as usual.

It's light-weight to call pmc_pause_counter (disable, read and reset event)
and pmc_resume_counter (recalibrate period and re-enable event) as guest
expects instead of release-and-create again on any condition. Compared to
use the filterable event->attr or hw.config, a new 'u64 current_config'
field is added to save the last original programed config for each vPMC.

Based on this implementation, the number of calls to pmc_reprogram_counter
is reduced by ~82.5% for a gp sampling event and ~99.9% for a fixed event.
In the usage of multiplexing perf sampling mode, the average latency of the
guest NMI handler is reduced from 104923 ns to 48393 ns (~2.16x speed up).
If host disables watchdog, the minimum latecy of guest NMI handler could be
speed up at ~3413x (from 20407603 to 5979 ns) and at ~786x in the average.

Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++++
 arch/x86/kvm/pmu.c              | 45 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/pmu.h              | 12 +++++++--
 arch/x86/kvm/pmu_amd.c          |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    |  2 ++
 5 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24d6598dea29..c4e0da8e899c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -451,6 +451,11 @@ struct kvm_pmc {
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
+	/*
+	 * eventsel value for general purpose counters,
+	 * ctrl value for fixed counters.
+	 */
+	u64 current_config;
 };
 
 struct kvm_pmu {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2674a6659ba4..47a01a75a8fa 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -140,6 +140,35 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
+static void pmc_pause_counter(struct kvm_pmc *pmc)
+{
+	u64 counter = pmc->counter;
+
+	if (!pmc->perf_event)
+		return;
+
+	/* update counter, reset event value to avoid redundant accumulation */
+	counter += perf_event_pause(pmc->perf_event, true);
+	pmc->counter = counter & pmc_bitmask(pmc);
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
+
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
 
+	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
+		return;
+
+	pmc_release_perf_event(pmc);
+
+	pmc->current_config = eventsel;
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
 
+	if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
+		return;
+
+	pmc_release_perf_event(pmc);
+
+	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
 			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b253dd5e56cf..7eba298587dc 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -56,12 +56,20 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	return counter & pmc_bitmask(pmc);
 }
 
-static inline void pmc_stop_counter(struct kvm_pmc *pmc)
+static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
 	if (pmc->perf_event) {
-		pmc->counter = pmc_read_counter(pmc);
 		perf_event_release_kernel(pmc->perf_event);
 		pmc->perf_event = NULL;
+		pmc->current_config = 0;
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
index 8e7372e10251..aaa065989ea1 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -292,6 +292,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
+		pmu->gp_counters[i].current_config = 0;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index dcde142327ca..9b1ddc42f604 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -340,12 +340,14 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
+		pmu->gp_counters[i].current_config = 0;
 	}
 
 	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
+		pmu->fixed_counters[i].current_config = 0;
 	}
 }
 
-- 
2.21.0

