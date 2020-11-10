Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA82ADA86
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 16:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgKJPhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 10:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbgKJPhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 10:37:48 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8D7C0613CF;
        Tue, 10 Nov 2020 07:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0Ag8YSfqUUAom5EDixyISX08GuKdtdVeG7iNICf4Baw=; b=1R3Tp8f8Fm8lLtp0ok+TpiT9fH
        WtLFIDCP7fU6BfP8z7Rp4vU6GgKCW6MgrDSaNTUtI2XZJmMo1C+tAFytajJBfZ37pDOCaH8okhOcR
        EBk7qznAnt9QDJi34mLvKi4KhfXRagqGR/jDFGUO6N/X1Z/xiVRNmKraiOACEcfcXnJBai2b4jDCD
        2rEtmjguJyk2JgaXPOQ9xjLE7wY+iG29+2UaWG9kuYYo+2K1qG4+mNIDIdxS8xJTvBvay93Qaup5x
        vjS6yNZPqN70f6ZTwgQ7vuH0AKmFu74ZzISmTnT3xeu5le6f/F9rDQ+WfvNDlY8/om7FDJalc7EtY
        VwVIHJqg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcVi1-0005eD-RI; Tue, 10 Nov 2020 15:37:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8779A300238;
        Tue, 10 Nov 2020 16:37:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6B4A92025CA28; Tue, 10 Nov 2020 16:37:21 +0100 (CET)
Date:   Tue, 10 Nov 2020 16:37:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Subject: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
Message-ID: <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110151257.GP2611@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 04:12:57PM +0100, Peter Zijlstra wrote:
> On Mon, Nov 09, 2020 at 10:12:37AM +0800, Like Xu wrote:
> > The Precise Event Based Sampling(PEBS) supported on Intel Ice Lake server
> > platforms can provide an architectural state of the instruction executed
> > after the instruction that caused the event. This patch set enables the
> > the PEBS via DS feature for KVM (also non) Linux guest on the Ice Lake.
> > The Linux guest can use PEBS feature like native:
> > 
> >   # perf record -e instructions:ppp ./br_instr a
> >   # perf record -c 100000 -e instructions:pp ./br_instr a
> > 
> > If the counter_freezing is not enabled on the host, the guest PEBS will
> > be disabled on purpose when host is using PEBS facility. By default,
> > KVM disables the co-existence of guest PEBS and host PEBS.
> 
> Uuhh, what?!? counter_freezing should never be enabled, its broken. Let
> me go delete all that code.

---
Subject: perf/intel: Remove Perfmon-v4 counter_freezing support

Perfmon-v4 counter freezing is fundamentally broken; remove this default
disabled code to make sure nobody uses it.

The feature is called Freeze-on-PMI in the SDM, and if it would do that,
there wouldn't actually be a problem, *however* it does something subtly
different. It globally disables the whole PMU when it raises the PMI,
not when the PMI hits.

This means there's a window between the PMI getting raised and the PMI
actually getting served where we loose events and this violates the
perf counter independence. That is, a counting event should not result
in a different event count when there is a sampling event co-scheduled.

This is known to break existing software.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c | 152 -------------------------------------------
 arch/x86/events/perf_event.h |   3 +-
 2 files changed, 1 insertion(+), 154 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c79748f6921d..9909dfa6fb12 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2121,18 +2121,6 @@ static void intel_tfa_pmu_enable_all(int added)
 	intel_pmu_enable_all(added);
 }
 
-static void enable_counter_freeze(void)
-{
-	update_debugctlmsr(get_debugctlmsr() |
-			DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI);
-}
-
-static void disable_counter_freeze(void)
-{
-	update_debugctlmsr(get_debugctlmsr() &
-			~DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI);
-}
-
 static inline u64 intel_pmu_get_status(void)
 {
 	u64 status;
@@ -2696,95 +2684,6 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	return handled;
 }
 
-static bool disable_counter_freezing = true;
-static int __init intel_perf_counter_freezing_setup(char *s)
-{
-	bool res;
-
-	if (kstrtobool(s, &res))
-		return -EINVAL;
-
-	disable_counter_freezing = !res;
-	return 1;
-}
-__setup("perf_v4_pmi=", intel_perf_counter_freezing_setup);
-
-/*
- * Simplified handler for Arch Perfmon v4:
- * - We rely on counter freezing/unfreezing to enable/disable the PMU.
- * This is done automatically on PMU ack.
- * - Ack the PMU only after the APIC.
- */
-
-static int intel_pmu_handle_irq_v4(struct pt_regs *regs)
-{
-	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-	int handled = 0;
-	bool bts = false;
-	u64 status;
-	int pmu_enabled = cpuc->enabled;
-	int loops = 0;
-
-	/* PMU has been disabled because of counter freezing */
-	cpuc->enabled = 0;
-	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
-		bts = true;
-		intel_bts_disable_local();
-		handled = intel_pmu_drain_bts_buffer();
-		handled += intel_bts_interrupt();
-	}
-	status = intel_pmu_get_status();
-	if (!status)
-		goto done;
-again:
-	intel_pmu_lbr_read();
-	if (++loops > 100) {
-		static bool warned;
-
-		if (!warned) {
-			WARN(1, "perfevents: irq loop stuck!\n");
-			perf_event_print_debug();
-			warned = true;
-		}
-		intel_pmu_reset();
-		goto done;
-	}
-
-
-	handled += handle_pmi_common(regs, status);
-done:
-	/* Ack the PMI in the APIC */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
-	/*
-	 * The counters start counting immediately while ack the status.
-	 * Make it as close as possible to IRET. This avoids bogus
-	 * freezing on Skylake CPUs.
-	 */
-	if (status) {
-		intel_pmu_ack_status(status);
-	} else {
-		/*
-		 * CPU may issues two PMIs very close to each other.
-		 * When the PMI handler services the first one, the
-		 * GLOBAL_STATUS is already updated to reflect both.
-		 * When it IRETs, the second PMI is immediately
-		 * handled and it sees clear status. At the meantime,
-		 * there may be a third PMI, because the freezing bit
-		 * isn't set since the ack in first PMI handlers.
-		 * Double check if there is more work to be done.
-		 */
-		status = intel_pmu_get_status();
-		if (status)
-			goto again;
-	}
-
-	if (bts)
-		intel_bts_enable_local();
-	cpuc->enabled = pmu_enabled;
-	return handled;
-}
-
 /*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
@@ -4081,9 +3980,6 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (x86_pmu.version > 1)
 		flip_smm_bit(&x86_pmu.attr_freeze_on_smi);
 
-	if (x86_pmu.counter_freezing)
-		enable_counter_freeze();
-
 	/* Disable perf metrics if any added CPU doesn't support it. */
 	if (x86_pmu.intel_cap.perf_metrics) {
 		union perf_capabilities perf_cap;
@@ -4154,9 +4050,6 @@ static void free_excl_cntrs(struct cpu_hw_events *cpuc)
 static void intel_pmu_cpu_dying(int cpu)
 {
 	fini_debug_store_on_cpu(cpu);
-
-	if (x86_pmu.counter_freezing)
-		disable_counter_freeze();
 }
 
 void intel_cpuc_finish(struct cpu_hw_events *cpuc)
@@ -4548,39 +4441,6 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
-static const struct x86_cpu_desc counter_freezing_ucodes[] = {
-	INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT,	 2, 0x0000000e),
-	INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT,	 9, 0x0000002e),
-	INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT,	10, 0x00000008),
-	INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT_D,	 1, 0x00000028),
-	INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT_PLUS,	 1, 0x00000028),
-	INTEL_CPU_DESC(INTEL_FAM6_ATOM_GOLDMONT_PLUS,	 8, 0x00000006),
-	{}
-};
-
-static bool intel_counter_freezing_broken(void)
-{
-	return !x86_cpu_has_min_microcode_rev(counter_freezing_ucodes);
-}
-
-static __init void intel_counter_freezing_quirk(void)
-{
-	/* Check if it's already disabled */
-	if (disable_counter_freezing)
-		return;
-
-	/*
-	 * If the system starts with the wrong ucode, leave the
-	 * counter-freezing feature permanently disabled.
-	 */
-	if (intel_counter_freezing_broken()) {
-		pr_info("PMU counter freezing disabled due to CPU errata,"
-			"please upgrade microcode\n");
-		x86_pmu.counter_freezing = false;
-		x86_pmu.handle_irq = intel_pmu_handle_irq;
-	}
-}
-
 /*
  * enable software workaround for errata:
  * SNB: BJ122
@@ -4966,9 +4826,6 @@ __init int intel_pmu_init(void)
 			max((int)edx.split.num_counters_fixed, assume);
 	}
 
-	if (version >= 4)
-		x86_pmu.counter_freezing = !disable_counter_freezing;
-
 	if (boot_cpu_has(X86_FEATURE_PDCM)) {
 		u64 capabilities;
 
@@ -5090,7 +4947,6 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ATOM_GOLDMONT:
 	case INTEL_FAM6_ATOM_GOLDMONT_D:
-		x86_add_quirk(intel_counter_freezing_quirk);
 		memcpy(hw_cache_event_ids, glm_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, glm_hw_cache_extra_regs,
@@ -5117,7 +4973,6 @@ __init int intel_pmu_init(void)
 		break;
 
 	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
-		x86_add_quirk(intel_counter_freezing_quirk);
 		memcpy(hw_cache_event_ids, glp_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, glp_hw_cache_extra_regs,
@@ -5577,13 +5432,6 @@ __init int intel_pmu_init(void)
 		pr_cont("full-width counters, ");
 	}
 
-	/*
-	 * For arch perfmon 4 use counter freezing to avoid
-	 * several MSR accesses in the PMI.
-	 */
-	if (x86_pmu.counter_freezing)
-		x86_pmu.handle_irq = intel_pmu_handle_irq_v4;
-
 	if (x86_pmu.intel_cap.perf_metrics)
 		x86_pmu.intel_ctrl |= 1ULL << GLOBAL_CTRL_EN_PERF_METRICS;
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 10032f023fcc..4084fa31cc21 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -681,8 +681,7 @@ struct x86_pmu {
 
 	/* PMI handler bits */
 	unsigned int	late_ack		:1,
-			enabled_ack		:1,
-			counter_freezing	:1;
+			enabled_ack		:1;
 	/*
 	 * sysfs attrs
 	 */
