Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4839223E42
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGQOi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:38:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41594 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbgGQOi4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:38:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEXIwh126674;
        Fri, 17 Jul 2020 10:38:39 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32awbsaej4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:38:39 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEWISn003044;
        Fri, 17 Jul 2020 14:38:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 327q2y341k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:38:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEbBVE51249460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:37:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E44FF4C04E;
        Fri, 17 Jul 2020 14:38:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7E0E4C046;
        Fri, 17 Jul 2020 14:38:31 +0000 (GMT)
Received: from localhost.localdomain.localdomain (unknown [9.77.207.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:38:31 +0000 (GMT)
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: [v3 01/15] powerpc/perf: Update cpu_hw_event to use `struct` for storing MMCR registers
Date:   Fri, 17 Jul 2020 10:38:13 -0400
Message-Id: <1594996707-3727-2-git-send-email-atrajeev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=875 priorityscore=1501
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

core-book3s currently uses array to store the MMCR registers as part
of per-cpu `cpu_hw_events`. This patch does a clean up to use `struct`
to store mmcr regs instead of array. This will make code easier to read
and reduces chance of any subtle bug that may come in the future, say
when new registers are added. Patch updates all relevant code that was
using MMCR array ( cpuhw->mmcr[x]) to use newly introduced `struct`.
This includes the PMU driver code for supported platforms (power5
to power9) and ISA macros for counter support functions.

Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h | 10 ++++--
 arch/powerpc/perf/core-book3s.c              | 53 +++++++++++++---------------
 arch/powerpc/perf/isa207-common.c            | 20 +++++------
 arch/powerpc/perf/isa207-common.h            |  4 +--
 arch/powerpc/perf/mpc7450-pmu.c              | 21 +++++++----
 arch/powerpc/perf/power5+-pmu.c              | 17 ++++-----
 arch/powerpc/perf/power5-pmu.c               | 17 ++++-----
 arch/powerpc/perf/power6-pmu.c               | 16 ++++-----
 arch/powerpc/perf/power7-pmu.c               | 17 ++++-----
 arch/powerpc/perf/ppc970-pmu.c               | 24 ++++++-------
 10 files changed, 105 insertions(+), 94 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 3e9703f..f9a3668 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -17,6 +17,12 @@
 
 struct perf_event;
 
+struct mmcr_regs {
+	unsigned long mmcr0;
+	unsigned long mmcr1;
+	unsigned long mmcr2;
+	unsigned long mmcra;
+};
 /*
  * This struct provides the constants and functions needed to
  * describe the PMU on a particular POWER-family CPU.
@@ -28,7 +34,7 @@ struct power_pmu {
 	unsigned long	add_fields;
 	unsigned long	test_adder;
 	int		(*compute_mmcr)(u64 events[], int n_ev,
-				unsigned int hwc[], unsigned long mmcr[],
+				unsigned int hwc[], struct mmcr_regs *mmcr,
 				struct perf_event *pevents[]);
 	int		(*get_constraint)(u64 event_id, unsigned long *mskp,
 				unsigned long *valp);
@@ -41,7 +47,7 @@ struct power_pmu {
 	unsigned long	group_constraint_val;
 	u64             (*bhrb_filter_map)(u64 branch_sample_type);
 	void            (*config_bhrb)(u64 pmu_bhrb_filter);
-	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
+	void		(*disable_pmc)(unsigned int pmc, struct mmcr_regs *mmcr);
 	int		(*limited_pmc_event)(u64 event_id);
 	u32		flags;
 	const struct attribute_group	**attr_groups;
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index cd6a742..18b1b6a 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -37,12 +37,7 @@ struct cpu_hw_events {
 	struct perf_event *event[MAX_HWEVENTS];
 	u64 events[MAX_HWEVENTS];
 	unsigned int flags[MAX_HWEVENTS];
-	/*
-	 * The order of the MMCR array is:
-	 *  - 64-bit, MMCR0, MMCR1, MMCRA, MMCR2
-	 *  - 32-bit, MMCR0, MMCR1, MMCR2
-	 */
-	unsigned long mmcr[4];
+	struct mmcr_regs mmcr;
 	struct perf_event *limited_counter[MAX_LIMITED_HWCOUNTERS];
 	u8  limited_hwidx[MAX_LIMITED_HWCOUNTERS];
 	u64 alternatives[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
@@ -121,7 +116,7 @@ static void ebb_event_add(struct perf_event *event) { }
 static void ebb_switch_out(unsigned long mmcr0) { }
 static unsigned long ebb_switch_in(bool ebb, struct cpu_hw_events *cpuhw)
 {
-	return cpuhw->mmcr[0];
+	return cpuhw->mmcr.mmcr0;
 }
 
 static inline void power_pmu_bhrb_enable(struct perf_event *event) {}
@@ -590,7 +585,7 @@ static void ebb_switch_out(unsigned long mmcr0)
 
 static unsigned long ebb_switch_in(bool ebb, struct cpu_hw_events *cpuhw)
 {
-	unsigned long mmcr0 = cpuhw->mmcr[0];
+	unsigned long mmcr0 = cpuhw->mmcr.mmcr0;
 
 	if (!ebb)
 		goto out;
@@ -624,7 +619,7 @@ static unsigned long ebb_switch_in(bool ebb, struct cpu_hw_events *cpuhw)
 	 * unfreeze counters, it should not set exclude_xxx in its events and
 	 * instead manage the MMCR2 entirely by itself.
 	 */
-	mtspr(SPRN_MMCR2, cpuhw->mmcr[3] | current->thread.mmcr2);
+	mtspr(SPRN_MMCR2, cpuhw->mmcr.mmcr2 | current->thread.mmcr2);
 out:
 	return mmcr0;
 }
@@ -1232,9 +1227,9 @@ static void power_pmu_disable(struct pmu *pmu)
 		/*
 		 * Disable instruction sampling if it was enabled
 		 */
-		if (cpuhw->mmcr[2] & MMCRA_SAMPLE_ENABLE) {
+		if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE) {
 			mtspr(SPRN_MMCRA,
-			      cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
+			      cpuhw->mmcr.mmcra & ~MMCRA_SAMPLE_ENABLE);
 			mb();
 			isync();
 		}
@@ -1308,18 +1303,18 @@ static void power_pmu_enable(struct pmu *pmu)
 	 * (possibly updated for removal of events).
 	 */
 	if (!cpuhw->n_added) {
-		mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
-		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+		mtspr(SPRN_MMCRA, cpuhw->mmcr.mmcra & ~MMCRA_SAMPLE_ENABLE);
+		mtspr(SPRN_MMCR1, cpuhw->mmcr.mmcr1);
 		goto out_enable;
 	}
 
 	/*
 	 * Clear all MMCR settings and recompute them for the new set of events.
 	 */
-	memset(cpuhw->mmcr, 0, sizeof(cpuhw->mmcr));
+	memset(&cpuhw->mmcr, 0, sizeof(cpuhw->mmcr));
 
 	if (ppmu->compute_mmcr(cpuhw->events, cpuhw->n_events, hwc_index,
-			       cpuhw->mmcr, cpuhw->event)) {
+			       &cpuhw->mmcr, cpuhw->event)) {
 		/* shouldn't ever get here */
 		printk(KERN_ERR "oops compute_mmcr failed\n");
 		goto out;
@@ -1333,11 +1328,11 @@ static void power_pmu_enable(struct pmu *pmu)
 		 */
 		event = cpuhw->event[0];
 		if (event->attr.exclude_user)
-			cpuhw->mmcr[0] |= MMCR0_FCP;
+			cpuhw->mmcr.mmcr0 |= MMCR0_FCP;
 		if (event->attr.exclude_kernel)
-			cpuhw->mmcr[0] |= freeze_events_kernel;
+			cpuhw->mmcr.mmcr0 |= freeze_events_kernel;
 		if (event->attr.exclude_hv)
-			cpuhw->mmcr[0] |= MMCR0_FCHV;
+			cpuhw->mmcr.mmcr0 |= MMCR0_FCHV;
 	}
 
 	/*
@@ -1346,12 +1341,12 @@ static void power_pmu_enable(struct pmu *pmu)
 	 * Then unfreeze the events.
 	 */
 	ppc_set_pmu_inuse(1);
-	mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
-	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
-	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
+	mtspr(SPRN_MMCRA, cpuhw->mmcr.mmcra & ~MMCRA_SAMPLE_ENABLE);
+	mtspr(SPRN_MMCR1, cpuhw->mmcr.mmcr1);
+	mtspr(SPRN_MMCR0, (cpuhw->mmcr.mmcr0 & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
 				| MMCR0_FC);
 	if (ppmu->flags & PPMU_ARCH_207S)
-		mtspr(SPRN_MMCR2, cpuhw->mmcr[3]);
+		mtspr(SPRN_MMCR2, cpuhw->mmcr.mmcr2);
 
 	/*
 	 * Read off any pre-existing events that need to move
@@ -1402,7 +1397,7 @@ static void power_pmu_enable(struct pmu *pmu)
 		perf_event_update_userpage(event);
 	}
 	cpuhw->n_limited = n_lim;
-	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
+	cpuhw->mmcr.mmcr0 |= MMCR0_PMXE | MMCR0_FCECE;
 
  out_enable:
 	pmao_restore_workaround(ebb);
@@ -1418,9 +1413,9 @@ static void power_pmu_enable(struct pmu *pmu)
 	/*
 	 * Enable instruction sampling if necessary
 	 */
-	if (cpuhw->mmcr[2] & MMCRA_SAMPLE_ENABLE) {
+	if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE) {
 		mb();
-		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+		mtspr(SPRN_MMCRA, cpuhw->mmcr.mmcra);
 	}
 
  out:
@@ -1550,7 +1545,7 @@ static void power_pmu_del(struct perf_event *event, int ef_flags)
 				cpuhw->flags[i-1] = cpuhw->flags[i];
 			}
 			--cpuhw->n_events;
-			ppmu->disable_pmc(event->hw.idx - 1, cpuhw->mmcr);
+			ppmu->disable_pmc(event->hw.idx - 1, &cpuhw->mmcr);
 			if (event->hw.idx) {
 				write_pmc(event->hw.idx, 0);
 				event->hw.idx = 0;
@@ -1571,7 +1566,7 @@ static void power_pmu_del(struct perf_event *event, int ef_flags)
 	}
 	if (cpuhw->n_events == 0) {
 		/* disable exceptions if no events are running */
-		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
+		cpuhw->mmcr.mmcr0 &= ~(MMCR0_PMXE | MMCR0_FCECE);
 	}
 
 	if (has_branch_stack(event))
@@ -2240,7 +2235,7 @@ static void __perf_event_interrupt(struct pt_regs *regs)
 	 * XXX might want to use MSR.PM to keep the events frozen until
 	 * we get back out of this interrupt.
 	 */
-	write_mmcr0(cpuhw, cpuhw->mmcr[0]);
+	write_mmcr0(cpuhw, cpuhw->mmcr.mmcr0);
 
 	if (nmi)
 		nmi_exit();
@@ -2262,7 +2257,7 @@ static int power_pmu_prepare_cpu(unsigned int cpu)
 
 	if (ppmu) {
 		memset(cpuhw, 0, sizeof(*cpuhw));
-		cpuhw->mmcr[0] = MMCR0_FC;
+		cpuhw->mmcr.mmcr0 = MMCR0_FC;
 	}
 	return 0;
 }
diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 4c86da5..2fe63f2 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -363,7 +363,7 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 }
 
 int isa207_compute_mmcr(u64 event[], int n_ev,
-			       unsigned int hwc[], unsigned long mmcr[],
+			       unsigned int hwc[], struct mmcr_regs *mmcr,
 			       struct perf_event *pevents[])
 {
 	unsigned long mmcra, mmcr1, mmcr2, unit, combine, psel, cache, val;
@@ -464,30 +464,30 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 	}
 
 	/* Return MMCRx values */
-	mmcr[0] = 0;
+	mmcr->mmcr0 = 0;
 
 	/* pmc_inuse is 1-based */
 	if (pmc_inuse & 2)
-		mmcr[0] = MMCR0_PMC1CE;
+		mmcr->mmcr0 = MMCR0_PMC1CE;
 
 	if (pmc_inuse & 0x7c)
-		mmcr[0] |= MMCR0_PMCjCE;
+		mmcr->mmcr0 |= MMCR0_PMCjCE;
 
 	/* If we're not using PMC 5 or 6, freeze them */
 	if (!(pmc_inuse & 0x60))
-		mmcr[0] |= MMCR0_FC56;
+		mmcr->mmcr0 |= MMCR0_FC56;
 
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcra;
-	mmcr[3] = mmcr2;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcra = mmcra;
+	mmcr->mmcr2 = mmcr2;
 
 	return 0;
 }
 
-void isa207_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+void isa207_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
 	if (pmc <= 3)
-		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SHIFT(pmc + 1));
+		mmcr->mmcr1 &= ~(0xffUL << MMCR1_PMCSEL_SHIFT(pmc + 1));
 }
 
 static int find_alternative(u64 event, const unsigned int ev_alt[][MAX_ALT], int size)
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index 63fd4f3..df968fd 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -217,9 +217,9 @@
 
 int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp);
 int isa207_compute_mmcr(u64 event[], int n_ev,
-				unsigned int hwc[], unsigned long mmcr[],
+				unsigned int hwc[], struct mmcr_regs *mmcr,
 				struct perf_event *pevents[]);
-void isa207_disable_pmc(unsigned int pmc, unsigned long mmcr[]);
+void isa207_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr);
 int isa207_get_alternatives(u64 event, u64 alt[], int size, unsigned int flags,
 					const unsigned int ev_alt[][MAX_ALT]);
 void isa207_get_mem_data_src(union perf_mem_data_src *dsrc, u32 flags,
diff --git a/arch/powerpc/perf/mpc7450-pmu.c b/arch/powerpc/perf/mpc7450-pmu.c
index 4d5ef92..826de25 100644
--- a/arch/powerpc/perf/mpc7450-pmu.c
+++ b/arch/powerpc/perf/mpc7450-pmu.c
@@ -257,7 +257,7 @@ static int mpc7450_get_alternatives(u64 event, unsigned int flags, u64 alt[])
  * Compute MMCR0/1/2 values for a set of events.
  */
 static int mpc7450_compute_mmcr(u64 event[], int n_ev, unsigned int hwc[],
-				unsigned long mmcr[],
+				struct mmcr_regs *mmcr,
 				struct perf_event *pevents[])
 {
 	u8 event_index[N_CLASSES][N_COUNTER];
@@ -321,9 +321,16 @@ static int mpc7450_compute_mmcr(u64 event[], int n_ev, unsigned int hwc[],
 		mmcr0 |= MMCR0_PMCnCE;
 
 	/* Return MMCRx values */
-	mmcr[0] = mmcr0;
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcr2;
+	mmcr->mmcr0 = mmcr0;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcr2 = mmcr2;
+	/*
+	 * 32-bit doesn't have an MMCRA and uses SPRN_MMCR2 to define
+	 * SPRN_MMCRA. So assign mmcra of cpu_hw_events with `mmcr2`
+	 * value to ensure that any write to this SPRN_MMCRA will
+	 * use mmcr2 value.
+	 */
+	mmcr->mmcra = mmcr2;
 	return 0;
 }
 
@@ -331,12 +338,12 @@ static int mpc7450_compute_mmcr(u64 event[], int n_ev, unsigned int hwc[],
  * Disable counting by a PMC.
  * Note that the pmc argument is 0-based here, not 1-based.
  */
-static void mpc7450_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+static void mpc7450_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
 	if (pmc <= 1)
-		mmcr[0] &= ~(pmcsel_mask[pmc] << pmcsel_shift[pmc]);
+		mmcr->mmcr0 &= ~(pmcsel_mask[pmc] << pmcsel_shift[pmc]);
 	else
-		mmcr[1] &= ~(pmcsel_mask[pmc] << pmcsel_shift[pmc]);
+		mmcr->mmcr1 &= ~(pmcsel_mask[pmc] << pmcsel_shift[pmc]);
 }
 
 static int mpc7450_generic_events[] = {
diff --git a/arch/powerpc/perf/power5+-pmu.c b/arch/powerpc/perf/power5+-pmu.c
index f857454..5f0821e 100644
--- a/arch/powerpc/perf/power5+-pmu.c
+++ b/arch/powerpc/perf/power5+-pmu.c
@@ -448,7 +448,8 @@ static int power5p_marked_instr_event(u64 event)
 }
 
 static int power5p_compute_mmcr(u64 event[], int n_ev,
-				unsigned int hwc[], unsigned long mmcr[], struct perf_event *pevents[])
+				unsigned int hwc[], struct mmcr_regs *mmcr,
+				struct perf_event *pevents[])
 {
 	unsigned long mmcr1 = 0;
 	unsigned long mmcra = 0;
@@ -586,20 +587,20 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 	}
 
 	/* Return MMCRx values */
-	mmcr[0] = 0;
+	mmcr->mmcr0 = 0;
 	if (pmc_inuse & 1)
-		mmcr[0] = MMCR0_PMC1CE;
+		mmcr->mmcr0 = MMCR0_PMC1CE;
 	if (pmc_inuse & 0x3e)
-		mmcr[0] |= MMCR0_PMCjCE;
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcra;
+		mmcr->mmcr0 |= MMCR0_PMCjCE;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcra = mmcra;
 	return 0;
 }
 
-static void power5p_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+static void power5p_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
 	if (pmc <= 3)
-		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
+		mmcr->mmcr1 &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
 }
 
 static int power5p_generic_events[] = {
diff --git a/arch/powerpc/perf/power5-pmu.c b/arch/powerpc/perf/power5-pmu.c
index da52eca..426021d 100644
--- a/arch/powerpc/perf/power5-pmu.c
+++ b/arch/powerpc/perf/power5-pmu.c
@@ -379,7 +379,8 @@ static int power5_marked_instr_event(u64 event)
 }
 
 static int power5_compute_mmcr(u64 event[], int n_ev,
-			       unsigned int hwc[], unsigned long mmcr[], struct perf_event *pevents[])
+			       unsigned int hwc[], struct mmcr_regs *mmcr,
+			       struct perf_event *pevents[])
 {
 	unsigned long mmcr1 = 0;
 	unsigned long mmcra = MMCRA_SDAR_DCACHE_MISS | MMCRA_SDAR_ERAT_MISS;
@@ -528,20 +529,20 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 	}
 
 	/* Return MMCRx values */
-	mmcr[0] = 0;
+	mmcr->mmcr0 = 0;
 	if (pmc_inuse & 1)
-		mmcr[0] = MMCR0_PMC1CE;
+		mmcr->mmcr0 = MMCR0_PMC1CE;
 	if (pmc_inuse & 0x3e)
-		mmcr[0] |= MMCR0_PMCjCE;
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcra;
+		mmcr->mmcr0 |= MMCR0_PMCjCE;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcra = mmcra;
 	return 0;
 }
 
-static void power5_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+static void power5_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
 	if (pmc <= 3)
-		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
+		mmcr->mmcr1 &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
 }
 
 static int power5_generic_events[] = {
diff --git a/arch/powerpc/perf/power6-pmu.c b/arch/powerpc/perf/power6-pmu.c
index 3929cac..e343a51 100644
--- a/arch/powerpc/perf/power6-pmu.c
+++ b/arch/powerpc/perf/power6-pmu.c
@@ -171,7 +171,7 @@ static int power6_marked_instr_event(u64 event)
  * Assign PMC numbers and compute MMCR1 value for a set of events
  */
 static int p6_compute_mmcr(u64 event[], int n_ev,
-			   unsigned int hwc[], unsigned long mmcr[], struct perf_event *pevents[])
+			   unsigned int hwc[], struct mmcr_regs *mmcr, struct perf_event *pevents[])
 {
 	unsigned long mmcr1 = 0;
 	unsigned long mmcra = MMCRA_SDAR_DCACHE_MISS | MMCRA_SDAR_ERAT_MISS;
@@ -243,13 +243,13 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 		if (pmc < 4)
 			mmcr1 |= (unsigned long)psel << MMCR1_PMCSEL_SH(pmc);
 	}
-	mmcr[0] = 0;
+	mmcr->mmcr0 = 0;
 	if (pmc_inuse & 1)
-		mmcr[0] = MMCR0_PMC1CE;
+		mmcr->mmcr0 = MMCR0_PMC1CE;
 	if (pmc_inuse & 0xe)
-		mmcr[0] |= MMCR0_PMCjCE;
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcra;
+		mmcr->mmcr0 |= MMCR0_PMCjCE;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcra = mmcra;
 	return 0;
 }
 
@@ -457,11 +457,11 @@ static int p6_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 	return nalt;
 }
 
-static void p6_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+static void p6_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
 	/* Set PMCxSEL to 0 to disable PMCx */
 	if (pmc <= 3)
-		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
+		mmcr->mmcr1 &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
 }
 
 static int power6_generic_events[] = {
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index a137813..3152336 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -242,7 +242,8 @@ static int power7_marked_instr_event(u64 event)
 }
 
 static int power7_compute_mmcr(u64 event[], int n_ev,
-			       unsigned int hwc[], unsigned long mmcr[], struct perf_event *pevents[])
+			       unsigned int hwc[], struct mmcr_regs *mmcr,
+			       struct perf_event *pevents[])
 {
 	unsigned long mmcr1 = 0;
 	unsigned long mmcra = MMCRA_SDAR_DCACHE_MISS | MMCRA_SDAR_ERAT_MISS;
@@ -298,20 +299,20 @@ static int power7_compute_mmcr(u64 event[], int n_ev,
 	}
 
 	/* Return MMCRx values */
-	mmcr[0] = 0;
+	mmcr->mmcr0 = 0;
 	if (pmc_inuse & 1)
-		mmcr[0] = MMCR0_PMC1CE;
+		mmcr->mmcr0 = MMCR0_PMC1CE;
 	if (pmc_inuse & 0x3e)
-		mmcr[0] |= MMCR0_PMCjCE;
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcra;
+		mmcr->mmcr0 |= MMCR0_PMCjCE;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcra = mmcra;
 	return 0;
 }
 
-static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+static void power7_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
 	if (pmc <= 3)
-		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
+		mmcr->mmcr1 &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
 }
 
 static int power7_generic_events[] = {
diff --git a/arch/powerpc/perf/ppc970-pmu.c b/arch/powerpc/perf/ppc970-pmu.c
index 4035d93..89a90ab 100644
--- a/arch/powerpc/perf/ppc970-pmu.c
+++ b/arch/powerpc/perf/ppc970-pmu.c
@@ -253,7 +253,8 @@ static int p970_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 }
 
 static int p970_compute_mmcr(u64 event[], int n_ev,
-			     unsigned int hwc[], unsigned long mmcr[], struct perf_event *pevents[])
+			     unsigned int hwc[], struct mmcr_regs *mmcr,
+			     struct perf_event *pevents[])
 {
 	unsigned long mmcr0 = 0, mmcr1 = 0, mmcra = 0;
 	unsigned int pmc, unit, byte, psel;
@@ -393,27 +394,26 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 	mmcra |= 0x2000;	/* mark only one IOP per PPC instruction */
 
 	/* Return MMCRx values */
-	mmcr[0] = mmcr0;
-	mmcr[1] = mmcr1;
-	mmcr[2] = mmcra;
+	mmcr->mmcr0 = mmcr0;
+	mmcr->mmcr1 = mmcr1;
+	mmcr->mmcra = mmcra;
 	return 0;
 }
 
-static void p970_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+static void p970_disable_pmc(unsigned int pmc, struct mmcr_regs *mmcr)
 {
-	int shift, i;
+	int shift;
 
+	/*
+	 * Setting the PMCxSEL field to 0x08 disables PMC x.
+	 */
 	if (pmc <= 1) {
 		shift = MMCR0_PMC1SEL_SH - 7 * pmc;
-		i = 0;
+		mmcr->mmcr0 = (mmcr->mmcr0 & ~(0x1fUL << shift)) | (0x08UL << shift);
 	} else {
 		shift = MMCR1_PMC3SEL_SH - 5 * (pmc - 2);
-		i = 1;
+		mmcr->mmcr1 = (mmcr->mmcr1 & ~(0x1fUL << shift)) | (0x08UL << shift);
 	}
-	/*
-	 * Setting the PMCxSEL field to 0x08 disables PMC x.
-	 */
-	mmcr[i] = (mmcr[i] & ~(0x1fUL << shift)) | (0x08UL << shift);
 }
 
 static int ppc970_generic_events[] = {
-- 
1.8.3.1

