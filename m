Return-Path: <kvm+bounces-70653-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EZbKqhiimleJwAAu9opvQ
	(envelope-from <kvm+bounces-70653-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:41:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE991151D7
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:41:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E805D3027305
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E81D319848;
	Mon,  9 Feb 2026 22:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fn8Urd05"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54849317712
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676853; cv=none; b=EQNbHaJ8+q8XcNcIT204Q5248awkBGrCV4etDZywMuwDC28KWz3vlHMk0gejuCNjviT6T/kZtdFYPDz0TNtuLzOpt0G7Y5IPVWj5IF8lpTka2CUSEANB6ZIMciFw1bDSzAZRl/MkKAJflCPE+iKQ63LK+K7HbW2BtxCM2jN9RiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676853; c=relaxed/simple;
	bh=0DM44odctlhvZua4O7eUrUtzwovZ8bcth0D0ugL1yHM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kXkCKJX0+EjAPV/dmkQy/haoEC/Jy8ABY+d+LSVEzGwFbx2nexG5hXLdT5AHYIpVQ95wJvjCbnSCDe2O2onrO95fsAn11wHhRy7OqppJUH+xfTN/hYD/l2wm/FXcR7zP4Va7ApeLxmE851Ypz59+tHZD8rFmb9lmM6TxvsUBYQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fn8Urd05; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-40418f60513so16026596fac.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676847; x=1771281647; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YRCAmun1TY4onvJPYO4fmNihU9hP5edqKJoyjt/KYR4=;
        b=Fn8Urd05QJ2iAwCckVzlrFbZ+PL88Qg5FcdthppETojcoqYz0jCxhrkwUOmI3BydOp
         8KmwnHpHwJYZtj0PxpMjm51FKt/0ArgZJxPMJxrKk/9TxpPY7roWjwdlnT2jH0uLLWT9
         Qoh3pmeAzR9I1fQWxmuxv+96JglQE2SzhJzYaYrHFnt4M3tAfeUlJQeyUfiyPv42buwn
         E+vHuT/sJzccImt4G9qB4pfZrQC9jVMJtsiM9C9SdYVXeXrk7yMVC3N7utSqRRG31g8g
         jRC0X8x5pGWtoGwjRvljtOMrJIPtYwQNMCRy8oWaKdsdeOCXF+BRbDoKB1GvZGeSlTbP
         wfgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676847; x=1771281647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YRCAmun1TY4onvJPYO4fmNihU9hP5edqKJoyjt/KYR4=;
        b=IWiGEiAqYpaaRY9EDDCaCx7KgAWf3JiVgt52mrYiECXlDjxONxpm82tHeHJB9lH19O
         DtHxvhGHcdaQGojnllTxJhjD3AcnRG3EmcX2w81zzqxE499rosPIWxa3xtFtwtpavZIE
         I1k1ycF3gcIHR8ockFsVFfW0U/taPVcOLNSMLgTV75amvq+tgUo7iQf5BUTztBFG3Lio
         XEh+rMmgl/M6BdpWiJs3Zr9wtUMWPhfkYJhAq1KqQQJ3K8Cs9oapuZVLhDHrV7KNOMIV
         eM07PaflGc8RwQvPT5Su4jCuaNCUSbv1XOSJz/jW2n4+Cv/sPVSgfmj91Mm61vhqy6MJ
         ugUQ==
X-Gm-Message-State: AOJu0Yx+HIO0llivHUjDcdGV8Dl7xcvsDeGjglZZiMgnri9RJxBwOcp0
	NLu+ymSAZD388XBwwKtFsUohmM3zkQPh/bbA5fyjSv94h/Fq+cEahIG4WAf2A3mXOWI+3bzCRLh
	DGp9Ii1BPW6yLcErCygLw7AqvDDFuA25YG7Itx9IRgkAIQOSEqhuKYs2cCGi794yoBJacx6ujEq
	2ovC0r529z6D+ABHYWFNsrgPn+CngcH9w7mOpAobe4wd6BBUnijxl5yp4VIUM=
X-Received: from oabub17.prod.google.com ([2002:a05:6871:4b11:b0:3ec:c0dc:2314])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:4207:b0:409:96b8:6515 with SMTP id 586e51a60fabf-40a9706d0c6mr5983956fac.48.1770676847092;
 Mon, 09 Feb 2026 14:40:47 -0800 (PST)
Date: Mon,  9 Feb 2026 22:13:58 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-4-coltonlewis@google.com>
Subject: [PATCH v6 03/19] KVM: arm64: Reorganize PMU functions
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_FROM(0.00)[bounces-70653-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4AE991151D7
X-Rspamd-Action: no action

A lot of functions in pmu-emul.c aren't specific to the emulated PMU
implementation. Move them to the more appropriate pmu.c file where
shared PMU functions should live.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 672 +------------------------------------
 arch/arm64/kvm/pmu.c      | 676 ++++++++++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h     |   7 +
 3 files changed, 684 insertions(+), 671 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab9..a40db0d5120ff 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -17,19 +17,10 @@
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
-static LIST_HEAD(arm_pmus);
-static DEFINE_MUTEX(arm_pmus_lock);
-
 static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
-bool kvm_supports_guest_pmuv3(void)
-{
-	guard(mutex)(&arm_pmus_lock);
-	return !list_empty(&arm_pmus);
-}
-
 static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
 {
 	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[pmc->idx]);
@@ -40,46 +31,6 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 __kvm_pmu_event_mask(unsigned int pmuver)
-{
-	switch (pmuver) {
-	case ID_AA64DFR0_EL1_PMUVer_IMP:
-		return GENMASK(9, 0);
-	case ID_AA64DFR0_EL1_PMUVer_V3P1:
-	case ID_AA64DFR0_EL1_PMUVer_V3P4:
-	case ID_AA64DFR0_EL1_PMUVer_V3P5:
-	case ID_AA64DFR0_EL1_PMUVer_V3P7:
-		return GENMASK(15, 0);
-	default:		/* Shouldn't be here, just for sanity */
-		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
-		return 0;
-	}
-}
-
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
-{
-	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
-	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
-
-	return __kvm_pmu_event_mask(pmuver);
-}
-
-u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
-{
-	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
-		   kvm_pmu_event_mask(kvm);
-
-	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
-		mask |= ARMV8_PMU_INCLUDE_EL2;
-
-	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
-		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
-			ARMV8_PMU_EXCLUDE_NS_EL1 |
-			ARMV8_PMU_EXCLUDE_EL3;
-
-	return mask;
-}
-
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -272,59 +223,6 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
-static u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
-{
-	unsigned int hpmn, n;
-
-	if (!vcpu_has_nv(vcpu))
-		return 0;
-
-	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-	n = vcpu->kvm->arch.nr_pmu_counters;
-
-	/*
-	 * Programming HPMN to a value greater than PMCR_EL0.N is
-	 * CONSTRAINED UNPREDICTABLE. Make the implementation choice that an
-	 * UNKNOWN number of counters (in our case, zero) are reserved for EL2.
-	 */
-	if (hpmn >= n)
-		return 0;
-
-	/*
-	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
-	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
-	 * depend on hardware (all PMU registers are trapped), make the
-	 * implementation choice that all counters are included in the second
-	 * range reserved for EL2/EL3.
-	 */
-	return GENMASK(n - 1, hpmn);
-}
-
-bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
-{
-	return kvm_pmu_hyp_counter_mask(vcpu) & BIT(idx);
-}
-
-u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
-{
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
-
-	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
-		return mask;
-
-	return mask & ~kvm_pmu_hyp_counter_mask(vcpu);
-}
-
-u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
-{
-	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
-
-	if (val == 0)
-		return BIT(ARMV8_PMU_CYCLE_IDX);
-	else
-		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
-}
-
 static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
 {
 	if (!pmc->perf_event) {
@@ -370,7 +268,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
  * counter where the values of the global enable control, PMOVSSET_EL0[n], and
  * PMINTENSET_EL1[n] are all 1.
  */
-static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
@@ -393,24 +291,6 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 	return reg;
 }
 
-static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	bool overflow;
-
-	overflow = kvm_pmu_overflow_status(vcpu);
-	if (pmu->irq_level == overflow)
-		return;
-
-	pmu->irq_level = overflow;
-
-	if (likely(irqchip_in_kernel(vcpu->kvm))) {
-		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
-					      pmu->irq_num, overflow, pmu);
-		WARN_ON(ret);
-	}
-}
-
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
@@ -436,43 +316,6 @@ void kvm_pmu_update_run(struct kvm_vcpu *vcpu)
 		regs->device_irq_level |= KVM_ARM_DEV_PMU;
 }
 
-/**
- * kvm_pmu_flush_hwstate - flush pmu state to cpu
- * @vcpu: The vcpu pointer
- *
- * Check if the PMU has overflowed while we were running in the host, and inject
- * an interrupt if that was the case.
- */
-void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
-{
-	kvm_pmu_update_state(vcpu);
-}
-
-/**
- * kvm_pmu_sync_hwstate - sync pmu state from cpu
- * @vcpu: The vcpu pointer
- *
- * Check if the PMU has overflowed while we were running in the guest, and
- * inject an interrupt if that was the case.
- */
-void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
-{
-	kvm_pmu_update_state(vcpu);
-}
-
-/*
- * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
- * to the event.
- * This is why we need a callback to do it once outside of the NMI context.
- */
-static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = container_of(work, struct kvm_vcpu, arch.pmu.overflow_work);
-	kvm_vcpu_kick(vcpu);
-}
-
 /*
  * Perform an increment on any of the counters described in @mask,
  * generating the overflow if required, and propagate it as a chained
@@ -784,132 +627,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	kvm_pmu_create_perf_event(pmc);
 }
 
-void kvm_host_pmu_init(struct arm_pmu *pmu)
-{
-	struct arm_pmu_entry *entry;
-
-	/*
-	 * Check the sanitised PMU version for the system, as KVM does not
-	 * support implementations where PMUv3 exists on a subset of CPUs.
-	 */
-	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
-		return;
-
-	guard(mutex)(&arm_pmus_lock);
-
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return;
-
-	entry->arm_pmu = pmu;
-	list_add_tail(&entry->entry, &arm_pmus);
-}
-
-static struct arm_pmu *kvm_pmu_probe_armpmu(void)
-{
-	struct arm_pmu_entry *entry;
-	struct arm_pmu *pmu;
-	int cpu;
-
-	guard(mutex)(&arm_pmus_lock);
-
-	/*
-	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
-	 * the same value is used for the entirety of the loop. Given this, and
-	 * the fact that no percpu data is used for the lookup there is no need
-	 * to disable preemption.
-	 *
-	 * It is still necessary to get a valid cpu, though, to probe for the
-	 * default PMU instance as userspace is not required to specify a PMU
-	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core during vcpu init. A dependent use
-	 * case would be a user with disdain of all things big.LITTLE that
-	 * affines the VMM to a particular cluster of cores.
-	 *
-	 * In any case, userspace should just do the sane thing and use the UAPI
-	 * to select a PMU type directly. But, be wary of the baggage being
-	 * carried here.
-	 */
-	cpu = raw_smp_processor_id();
-	list_for_each_entry(entry, &arm_pmus, entry) {
-		pmu = entry->arm_pmu;
-
-		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
-			return pmu;
-	}
-
-	return NULL;
-}
-
-static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
-{
-	u32 hi[2], lo[2];
-
-	bitmap_to_arr32(lo, pmu->pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
-	bitmap_to_arr32(hi, pmu->pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
-
-	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
-}
-
-static u64 compute_pmceid0(struct arm_pmu *pmu)
-{
-	u64 val = __compute_pmceid(pmu, 0);
-
-	/* always support SW_INCR */
-	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
-	/* always support CHAIN */
-	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
-	return val;
-}
-
-static u64 compute_pmceid1(struct arm_pmu *pmu)
-{
-	u64 val = __compute_pmceid(pmu, 1);
-
-	/*
-	 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
-	 * as RAZ
-	 */
-	val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
-		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
-		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
-	return val;
-}
-
-u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
-{
-	struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
-	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
-	u64 val, mask = 0;
-	int base, i, nr_events;
-
-	if (!pmceid1) {
-		val = compute_pmceid0(cpu_pmu);
-		base = 0;
-	} else {
-		val = compute_pmceid1(cpu_pmu);
-		base = 32;
-	}
-
-	if (!bmap)
-		return val;
-
-	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
-
-	for (i = 0; i < 32; i += 8) {
-		u64 byte;
-
-		byte = bitmap_get_value8(bmap, base + i);
-		mask |= byte << i;
-		if (nr_events >= (0x4000 + base + 32)) {
-			byte = bitmap_get_value8(bmap, 0x4000 + base + i);
-			mask |= byte << (32 + i);
-		}
-	}
-
-	return val & mask;
-}
-
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
@@ -921,393 +638,6 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 	kvm_pmu_reprogram_counter_mask(vcpu, mask);
 }
 
-int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->arch.pmu.created)
-		return -EINVAL;
-
-	/*
-	 * A valid interrupt configuration for the PMU is either to have a
-	 * properly configured interrupt number and using an in-kernel
-	 * irqchip, or to not have an in-kernel GIC and not set an IRQ.
-	 */
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		int irq = vcpu->arch.pmu.irq_num;
-		/*
-		 * If we are using an in-kernel vgic, at this point we know
-		 * the vgic will be initialized, so we can check the PMU irq
-		 * number against the dimensions of the vgic and make sure
-		 * it's valid.
-		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
-			return -EINVAL;
-	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
-		   return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
-{
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		int ret;
-
-		/*
-		 * If using the PMU with an in-kernel virtual GIC
-		 * implementation, we require the GIC to be already
-		 * initialized when initializing the PMU.
-		 */
-		if (!vgic_initialized(vcpu->kvm))
-			return -ENODEV;
-
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
-
-		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
-					 &vcpu->arch.pmu);
-		if (ret)
-			return ret;
-	}
-
-	init_irq_work(&vcpu->arch.pmu.overflow_work,
-		      kvm_pmu_perf_overflow_notify_vcpu);
-
-	vcpu->arch.pmu.created = true;
-	return 0;
-}
-
-/*
- * For one VM the interrupt type must be same for each vcpu.
- * As a PPI, the interrupt number is the same for all vcpus,
- * while as an SPI it must be a separate number per vcpu.
- */
-static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
-{
-	unsigned long i;
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			continue;
-
-		if (irq_is_ppi(irq)) {
-			if (vcpu->arch.pmu.irq_num != irq)
-				return false;
-		} else {
-			if (vcpu->arch.pmu.irq_num == irq)
-				return false;
-		}
-	}
-
-	return true;
-}
-
-/**
- * kvm_arm_pmu_get_max_counters - Return the max number of PMU counters.
- * @kvm: The kvm pointer
- */
-u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
-{
-	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
-
-	/*
-	 * PMUv3 requires that all event counters are capable of counting any
-	 * event, though the same may not be true of non-PMUv3 hardware.
-	 */
-	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
-		return 1;
-
-	/*
-	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
-	 * Ignore those and return only the general-purpose counters.
-	 */
-	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
-}
-
-static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
-{
-	kvm->arch.nr_pmu_counters = nr;
-
-	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
-	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
-		struct kvm_vcpu *vcpu;
-		unsigned long i;
-
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
-			val &= ~MDCR_EL2_HPMN;
-			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
-			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
-		}
-	}
-}
-
-static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
-{
-	lockdep_assert_held(&kvm->arch.config_lock);
-
-	kvm->arch.arm_pmu = arm_pmu;
-	kvm_arm_set_nr_counters(kvm, kvm_arm_pmu_get_max_counters(kvm));
-}
-
-/**
- * kvm_arm_set_default_pmu - No PMU set, get the default one.
- * @kvm: The kvm pointer
- *
- * The observant among you will notice that the supported_cpus
- * mask does not get updated for the default PMU even though it
- * is quite possible the selected instance supports only a
- * subset of cores in the system. This is intentional, and
- * upholds the preexisting behavior on heterogeneous systems
- * where vCPUs can be scheduled on any core but the guest
- * counters could stop working.
- */
-int kvm_arm_set_default_pmu(struct kvm *kvm)
-{
-	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
-
-	if (!arm_pmu)
-		return -ENODEV;
-
-	kvm_arm_set_pmu(kvm, arm_pmu);
-	return 0;
-}
-
-static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct arm_pmu_entry *entry;
-	struct arm_pmu *arm_pmu;
-	int ret = -ENXIO;
-
-	lockdep_assert_held(&kvm->arch.config_lock);
-	mutex_lock(&arm_pmus_lock);
-
-	list_for_each_entry(entry, &arm_pmus, entry) {
-		arm_pmu = entry->arm_pmu;
-		if (arm_pmu->pmu.type == pmu_id) {
-			if (kvm_vm_has_ran_once(kvm) ||
-			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
-				ret = -EBUSY;
-				break;
-			}
-
-			kvm_arm_set_pmu(kvm, arm_pmu);
-			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
-			ret = 0;
-			break;
-		}
-	}
-
-	mutex_unlock(&arm_pmus_lock);
-	return ret;
-}
-
-static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
-{
-	struct kvm *kvm = vcpu->kvm;
-
-	if (!kvm->arch.arm_pmu)
-		return -EINVAL;
-
-	if (n > kvm_arm_pmu_get_max_counters(kvm))
-		return -EINVAL;
-
-	kvm_arm_set_nr_counters(kvm, n);
-	return 0;
-}
-
-int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-{
-	struct kvm *kvm = vcpu->kvm;
-
-	lockdep_assert_held(&kvm->arch.config_lock);
-
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return -ENODEV;
-
-	if (vcpu->arch.pmu.created)
-		return -EBUSY;
-
-	switch (attr->attr) {
-	case KVM_ARM_VCPU_PMU_V3_IRQ: {
-		int __user *uaddr = (int __user *)(long)attr->addr;
-		int irq;
-
-		if (!irqchip_in_kernel(kvm))
-			return -EINVAL;
-
-		if (get_user(irq, uaddr))
-			return -EFAULT;
-
-		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
-			return -EINVAL;
-
-		if (!pmu_irq_is_valid(kvm, irq))
-			return -EINVAL;
-
-		if (kvm_arm_pmu_irq_initialized(vcpu))
-			return -EBUSY;
-
-		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
-		vcpu->arch.pmu.irq_num = irq;
-		return 0;
-	}
-	case KVM_ARM_VCPU_PMU_V3_FILTER: {
-		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
-		struct kvm_pmu_event_filter __user *uaddr;
-		struct kvm_pmu_event_filter filter;
-		int nr_events;
-
-		/*
-		 * Allow userspace to specify an event filter for the entire
-		 * event range supported by PMUVer of the hardware, rather
-		 * than the guest's PMUVer for KVM backward compatibility.
-		 */
-		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
-
-		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
-
-		if (copy_from_user(&filter, uaddr, sizeof(filter)))
-			return -EFAULT;
-
-		if (((u32)filter.base_event + filter.nevents) > nr_events ||
-		    (filter.action != KVM_PMU_EVENT_ALLOW &&
-		     filter.action != KVM_PMU_EVENT_DENY))
-			return -EINVAL;
-
-		if (kvm_vm_has_ran_once(kvm))
-			return -EBUSY;
-
-		if (!kvm->arch.pmu_filter) {
-			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
-			if (!kvm->arch.pmu_filter)
-				return -ENOMEM;
-
-			/*
-			 * The default depends on the first applied filter.
-			 * If it allows events, the default is to deny.
-			 * Conversely, if the first filter denies a set of
-			 * events, the default is to allow.
-			 */
-			if (filter.action == KVM_PMU_EVENT_ALLOW)
-				bitmap_zero(kvm->arch.pmu_filter, nr_events);
-			else
-				bitmap_fill(kvm->arch.pmu_filter, nr_events);
-		}
-
-		if (filter.action == KVM_PMU_EVENT_ALLOW)
-			bitmap_set(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
-		else
-			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
-
-		return 0;
-	}
-	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
-		int __user *uaddr = (int __user *)(long)attr->addr;
-		int pmu_id;
-
-		if (get_user(pmu_id, uaddr))
-			return -EFAULT;
-
-		return kvm_arm_pmu_v3_set_pmu(vcpu, pmu_id);
-	}
-	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS: {
-		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
-		unsigned int n;
-
-		if (get_user(n, uaddr))
-			return -EFAULT;
-
-		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
-	}
-	case KVM_ARM_VCPU_PMU_V3_INIT:
-		return kvm_arm_pmu_v3_init(vcpu);
-	}
-
-	return -ENXIO;
-}
-
-int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-{
-	switch (attr->attr) {
-	case KVM_ARM_VCPU_PMU_V3_IRQ: {
-		int __user *uaddr = (int __user *)(long)attr->addr;
-		int irq;
-
-		if (!irqchip_in_kernel(vcpu->kvm))
-			return -EINVAL;
-
-		if (!kvm_vcpu_has_pmu(vcpu))
-			return -ENODEV;
-
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
-
-		irq = vcpu->arch.pmu.irq_num;
-		return put_user(irq, uaddr);
-	}
-	}
-
-	return -ENXIO;
-}
-
-int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-{
-	switch (attr->attr) {
-	case KVM_ARM_VCPU_PMU_V3_IRQ:
-	case KVM_ARM_VCPU_PMU_V3_INIT:
-	case KVM_ARM_VCPU_PMU_V3_FILTER:
-	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
-	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
-		if (kvm_vcpu_has_pmu(vcpu))
-			return 0;
-	}
-
-	return -ENXIO;
-}
-
-u8 kvm_arm_pmu_get_pmuver_limit(void)
-{
-	unsigned int pmuver;
-
-	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer,
-			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
-
-	/*
-	 * Spoof a barebones PMUv3 implementation if the system supports IMPDEF
-	 * traps of the PMUv3 sysregs
-	 */
-	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
-		return ID_AA64DFR0_EL1_PMUVer_IMP;
-
-	/*
-	 * Otherwise, treat IMPLEMENTATION DEFINED functionality as
-	 * unimplemented
-	 */
-	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
-		return 0;
-
-	return min(pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
-}
-
-/**
- * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
- * @vcpu: The vcpu pointer
- */
-u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
-{
-	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
-
-	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
-		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-
-	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
-}
-
 void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
 {
 	bool reprogrammed = false;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 6b48a3d16d0d5..74a5d35edb244 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -8,8 +8,22 @@
 #include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
 
+#include <kvm/arm_pmu.h>
+
+#include <asm/kvm_emulate.h>
+
+static LIST_HEAD(arm_pmus);
+static DEFINE_MUTEX(arm_pmus_lock);
 static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
+
+bool kvm_supports_guest_pmuv3(void)
+{
+	guard(mutex)(&arm_pmus_lock);
+	return !list_empty(&arm_pmus);
+}
+
 /*
  * Given the perf event attributes and system type, determine
  * if we are going to need to switch counters at guest entry/exit.
@@ -209,3 +223,665 @@ void kvm_vcpu_pmu_resync_el0(void)
 
 	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
 }
+
+void kvm_host_pmu_init(struct arm_pmu *pmu)
+{
+	struct arm_pmu_entry *entry;
+
+	/*
+	 * Check the sanitised PMU version for the system, as KVM does not
+	 * support implementations where PMUv3 exists on a subset of CPUs.
+	 */
+	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
+		return;
+
+	guard(mutex)(&arm_pmus_lock);
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	entry->arm_pmu = pmu;
+	list_add_tail(&entry->entry, &arm_pmus);
+}
+
+static struct arm_pmu *kvm_pmu_probe_armpmu(void)
+{
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *pmu;
+	int cpu;
+
+	guard(mutex)(&arm_pmus_lock);
+
+	/*
+	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
+	 * the same value is used for the entirety of the loop. Given this, and
+	 * the fact that no percpu data is used for the lookup there is no need
+	 * to disable preemption.
+	 *
+	 * It is still necessary to get a valid cpu, though, to probe for the
+	 * default PMU instance as userspace is not required to specify a PMU
+	 * type. In order to uphold the preexisting behavior KVM selects the
+	 * PMU instance for the core during vcpu init. A dependent use
+	 * case would be a user with disdain of all things big.LITTLE that
+	 * affines the VMM to a particular cluster of cores.
+	 *
+	 * In any case, userspace should just do the sane thing and use the UAPI
+	 * to select a PMU type directly. But, be wary of the baggage being
+	 * carried here.
+	 */
+	cpu = raw_smp_processor_id();
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		pmu = entry->arm_pmu;
+
+		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
+			return pmu;
+	}
+
+	return NULL;
+}
+
+static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
+{
+	u32 hi[2], lo[2];
+
+	bitmap_to_arr32(lo, pmu->pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+	bitmap_to_arr32(hi, pmu->pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+
+	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
+}
+
+static u64 compute_pmceid0(struct arm_pmu *pmu)
+{
+	u64 val = __compute_pmceid(pmu, 0);
+
+	/* always support SW_INCR */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
+	/* always support CHAIN */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
+	return val;
+}
+
+static u64 compute_pmceid1(struct arm_pmu *pmu)
+{
+	u64 val = __compute_pmceid(pmu, 1);
+
+	/*
+	 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
+	 * as RAZ
+	 */
+	val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
+		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
+		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
+	return val;
+}
+
+u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
+{
+	struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
+	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
+	u64 val, mask = 0;
+	int base, i, nr_events;
+
+	if (!pmceid1) {
+		val = compute_pmceid0(cpu_pmu);
+		base = 0;
+	} else {
+		val = compute_pmceid1(cpu_pmu);
+		base = 32;
+	}
+
+	if (!bmap)
+		return val;
+
+	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+
+	for (i = 0; i < 32; i += 8) {
+		u64 byte;
+
+		byte = bitmap_get_value8(bmap, base + i);
+		mask |= byte << i;
+		if (nr_events >= (0x4000 + base + 32)) {
+			byte = bitmap_get_value8(bmap, 0x4000 + base + i);
+			mask |= byte << (32 + i);
+		}
+	}
+
+	return val & mask;
+}
+
+/*
+ * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
+ * to the event.
+ * This is why we need a callback to do it once outside of the NMI context.
+ */
+static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(work, struct kvm_vcpu, arch.pmu.overflow_work);
+	kvm_vcpu_kick(vcpu);
+}
+
+static u32 __kvm_pmu_event_mask(unsigned int pmuver)
+{
+	switch (pmuver) {
+	case ID_AA64DFR0_EL1_PMUVer_IMP:
+		return GENMASK(9, 0);
+	case ID_AA64DFR0_EL1_PMUVer_V3P1:
+	case ID_AA64DFR0_EL1_PMUVer_V3P4:
+	case ID_AA64DFR0_EL1_PMUVer_V3P5:
+	case ID_AA64DFR0_EL1_PMUVer_V3P7:
+		return GENMASK(15, 0);
+	default:		/* Shouldn't be here, just for sanity */
+		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
+		return 0;
+	}
+}
+
+u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
+	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
+
+	return __kvm_pmu_event_mask(pmuver);
+}
+
+u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
+{
+	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
+		   kvm_pmu_event_mask(kvm);
+
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
+		mask |= ARMV8_PMU_INCLUDE_EL2;
+
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
+		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
+			ARMV8_PMU_EXCLUDE_NS_EL1 |
+			ARMV8_PMU_EXCLUDE_EL3;
+
+	return mask;
+}
+
+static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	bool overflow;
+
+	overflow = kvm_pmu_overflow_status(vcpu);
+	if (pmu->irq_level == overflow)
+		return;
+
+	pmu->irq_level = overflow;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm))) {
+		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
+					      pmu->irq_num, overflow, pmu);
+		WARN_ON(ret);
+	}
+}
+
+/**
+ * kvm_pmu_flush_hwstate - flush pmu state to cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the PMU has overflowed while we were running in the host, and inject
+ * an interrupt if that was the case.
+ */
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_update_state(vcpu);
+}
+
+/**
+ * kvm_pmu_sync_hwstate - sync pmu state from cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the PMU has overflowed while we were running in the guest, and
+ * inject an interrupt if that was the case.
+ */
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_update_state(vcpu);
+}
+
+int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.pmu.created)
+		return -EINVAL;
+
+	/*
+	 * A valid interrupt configuration for the PMU is either to have a
+	 * properly configured interrupt number and using an in-kernel
+	 * irqchip, or to not have an in-kernel GIC and not set an IRQ.
+	 */
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int irq = vcpu->arch.pmu.irq_num;
+		/*
+		 * If we are using an in-kernel vgic, at this point we know
+		 * the vgic will be initialized, so we can check the PMU irq
+		 * number against the dimensions of the vgic and make sure
+		 * it's valid.
+		 */
+		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+			return -EINVAL;
+	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
+{
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int ret;
+
+		/*
+		 * If using the PMU with an in-kernel virtual GIC
+		 * implementation, we require the GIC to be already
+		 * initialized when initializing the PMU.
+		 */
+		if (!vgic_initialized(vcpu->kvm))
+			return -ENODEV;
+
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			return -ENXIO;
+
+		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
+					 &vcpu->arch.pmu);
+		if (ret)
+			return ret;
+	}
+
+	init_irq_work(&vcpu->arch.pmu.overflow_work,
+		      kvm_pmu_perf_overflow_notify_vcpu);
+
+	vcpu->arch.pmu.created = true;
+	return 0;
+}
+
+/*
+ * For one VM the interrupt type must be same for each vcpu.
+ * As a PPI, the interrupt number is the same for all vcpus,
+ * while as an SPI it must be a separate number per vcpu.
+ */
+static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			continue;
+
+		if (irq_is_ppi(irq)) {
+			if (vcpu->arch.pmu.irq_num != irq)
+				return false;
+		} else {
+			if (vcpu->arch.pmu.irq_num == irq)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+/**
+ * kvm_arm_pmu_get_max_counters - Return the max number of PMU counters.
+ * @kvm: The kvm pointer
+ */
+u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+
+	/*
+	 * PMUv3 requires that all event counters are capable of counting any
+	 * event, though the same may not be true of non-PMUv3 hardware.
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return 1;
+
+	/*
+	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
+	 * Ignore those and return only the general-purpose counters.
+	 */
+	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+}
+
+static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
+{
+	kvm->arch.nr_pmu_counters = nr;
+
+	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
+		struct kvm_vcpu *vcpu;
+		unsigned long i;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+			val &= ~MDCR_EL2_HPMN;
+			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
+			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
+		}
+	}
+}
+
+static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	kvm->arch.arm_pmu = arm_pmu;
+	kvm_arm_set_nr_counters(kvm, kvm_arm_pmu_get_max_counters(kvm));
+}
+
+/**
+ * kvm_arm_set_default_pmu - No PMU set, get the default one.
+ * @kvm: The kvm pointer
+ *
+ * The observant among you will notice that the supported_cpus
+ * mask does not get updated for the default PMU even though it
+ * is quite possible the selected instance supports only a
+ * subset of cores in the system. This is intentional, and
+ * upholds the preexisting behavior on heterogeneous systems
+ * where vCPUs can be scheduled on any core but the guest
+ * counters could stop working.
+ */
+int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
+
+	if (!arm_pmu)
+		return -ENODEV;
+
+	kvm_arm_set_pmu(kvm, arm_pmu);
+	return 0;
+}
+
+static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *arm_pmu;
+	int ret = -ENXIO;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+	mutex_lock(&arm_pmus_lock);
+
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		arm_pmu = entry->arm_pmu;
+		if (arm_pmu->pmu.type == pmu_id) {
+			if (kvm_vm_has_ran_once(kvm) ||
+			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
+				ret = -EBUSY;
+				break;
+			}
+
+			kvm_arm_set_pmu(kvm, arm_pmu);
+			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
+			ret = 0;
+			break;
+		}
+	}
+
+	mutex_unlock(&arm_pmus_lock);
+	return ret;
+}
+
+static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvm->arch.arm_pmu)
+		return -EINVAL;
+
+	if (n > kvm_arm_pmu_get_max_counters(kvm))
+		return -EINVAL;
+
+	kvm_arm_set_nr_counters(kvm, n);
+	return 0;
+}
+
+int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return -ENODEV;
+
+	if (vcpu->arch.pmu.created)
+		return -EBUSY;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(kvm))
+			return -EINVAL;
+
+		if (get_user(irq, uaddr))
+			return -EFAULT;
+
+		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
+		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+			return -EINVAL;
+
+		if (!pmu_irq_is_valid(kvm, irq))
+			return -EINVAL;
+
+		if (kvm_arm_pmu_irq_initialized(vcpu))
+			return -EBUSY;
+
+		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
+		vcpu->arch.pmu.irq_num = irq;
+		return 0;
+	}
+	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
+		struct kvm_pmu_event_filter __user *uaddr;
+		struct kvm_pmu_event_filter filter;
+		int nr_events;
+
+		/*
+		 * Allow userspace to specify an event filter for the entire
+		 * event range supported by PMUVer of the hardware, rather
+		 * than the guest's PMUVer for KVM backward compatibility.
+		 */
+		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
+
+		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
+
+		if (copy_from_user(&filter, uaddr, sizeof(filter)))
+			return -EFAULT;
+
+		if (((u32)filter.base_event + filter.nevents) > nr_events ||
+		    (filter.action != KVM_PMU_EVENT_ALLOW &&
+		     filter.action != KVM_PMU_EVENT_DENY))
+			return -EINVAL;
+
+		if (kvm_vm_has_ran_once(kvm))
+			return -EBUSY;
+
+		if (!kvm->arch.pmu_filter) {
+			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
+			if (!kvm->arch.pmu_filter)
+				return -ENOMEM;
+
+			/*
+			 * The default depends on the first applied filter.
+			 * If it allows events, the default is to deny.
+			 * Conversely, if the first filter denies a set of
+			 * events, the default is to allow.
+			 */
+			if (filter.action == KVM_PMU_EVENT_ALLOW)
+				bitmap_zero(kvm->arch.pmu_filter, nr_events);
+			else
+				bitmap_fill(kvm->arch.pmu_filter, nr_events);
+		}
+
+		if (filter.action == KVM_PMU_EVENT_ALLOW)
+			bitmap_set(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+		else
+			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+
+		return 0;
+	}
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int pmu_id;
+
+		if (get_user(pmu_id, uaddr))
+			return -EFAULT;
+
+		return kvm_arm_pmu_v3_set_pmu(vcpu, pmu_id);
+	}
+	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS: {
+		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
+		unsigned int n;
+
+		if (get_user(n, uaddr))
+			return -EFAULT;
+
+		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
+	}
+	case KVM_ARM_VCPU_PMU_V3_INIT:
+		return kvm_arm_pmu_v3_init(vcpu);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
+		if (!kvm_vcpu_has_pmu(vcpu))
+			return -ENODEV;
+
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			return -ENXIO;
+
+		irq = vcpu->arch.pmu.irq_num;
+		return put_user(irq, uaddr);
+	}
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ:
+	case KVM_ARM_VCPU_PMU_V3_INIT:
+	case KVM_ARM_VCPU_PMU_V3_FILTER:
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
+	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+		if (kvm_vcpu_has_pmu(vcpu))
+			return 0;
+	}
+
+	return -ENXIO;
+}
+
+u8 kvm_arm_pmu_get_pmuver_limit(void)
+{
+	unsigned int pmuver;
+
+	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer,
+			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
+
+	/*
+	 * Spoof a barebones PMUv3 implementation if the system supports IMPDEF
+	 * traps of the PMUv3 sysregs
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return ID_AA64DFR0_EL1_PMUVer_IMP;
+
+	/*
+	 * Otherwise, treat IMPLEMENTATION DEFINED functionality as
+	 * unimplemented
+	 */
+	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return 0;
+
+	return min(pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
+}
+
+u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
+
+	if (val == 0)
+		return BIT(ARMV8_PMU_CYCLE_IDX);
+	else
+		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
+}
+
+u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
+{
+	unsigned int hpmn, n;
+
+	if (!vcpu_has_nv(vcpu))
+		return 0;
+
+	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	n = vcpu->kvm->arch.nr_pmu_counters;
+
+	/*
+	 * Programming HPMN to a value greater than PMCR_EL0.N is
+	 * CONSTRAINED UNPREDICTABLE. Make the implementation choice that an
+	 * UNKNOWN number of counters (in our case, zero) are reserved for EL2.
+	 */
+	if (hpmn >= n)
+		return 0;
+
+	/*
+	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
+	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
+	 * depend on hardware (all PMU registers are trapped), make the
+	 * implementation choice that all counters are included in the second
+	 * range reserved for EL2/EL3.
+	 */
+	return GENMASK(n - 1, hpmn);
+}
+
+bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	return kvm_pmu_hyp_counter_mask(vcpu) & BIT(idx);
+}
+
+u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+
+	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
+		return mask;
+
+	return mask & ~kvm_pmu_hyp_counter_mask(vcpu);
+}
+
+/**
+ * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
+ * @vcpu: The vcpu pointer
+ */
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+
+	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
+		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+
+	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e91d15a7a564b..24a471cf59d56 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -53,13 +53,16 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
+u32 kvm_pmu_event_mask(struct kvm *kvm);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
+bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu);
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
@@ -132,6 +135,10 @@ static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	return 0;
+}
 static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


