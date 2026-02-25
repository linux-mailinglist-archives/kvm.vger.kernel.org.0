Return-Path: <kvm+bounces-71775-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFM4DId7nmlGVgQAu9opvQ
	(envelope-from <kvm+bounces-71775-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:33:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8838D1919B6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:33:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D1063061E32
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318B72C15BE;
	Wed, 25 Feb 2026 04:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="L4JhL86E"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985F22BE7D1;
	Wed, 25 Feb 2026 04:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771993972; cv=none; b=OxScnoTzvDk8neMq/BgzxtFGwqJeTd7G8UqAoGGhOH07ZelSR+b7VkGq5UvrK7UunrErddJI+IlOSZeQEoAgSiALrVfM2HgOiIy2C+XsjOTARpoWcUX9aqdSEkScFCk89au15QaNWylHAbaR2pxYeFU9dYTsZrMZDlQG5+WI5uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771993972; c=relaxed/simple;
	bh=rWA340eIl7oe32N/uRYyvGpnwlhrEM1t7S8p2zlghr8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CJs1ZmH4LrjfP6FSBzQgUlja76S9jVDxCxDTX1roEA5SfwoNJyT2B0k8yKSAoS/p59VJzpBgKckwxEFUe5fFUnUJbuFisHFUAjEsYTs8MAHd1fO/g3huXkFQnrhjYiwpZ75oNjEYocX1Han/kSjRYWEY25Phth02adHcvX1oEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=L4JhL86E reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 61P4VKpQ082120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 25 Feb 2026 13:31:24 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=2rCMzRp/iF3fT18W/FGxsV7DKDHJHn6eX73UWZTJSxg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1771993885; v=1;
        b=L4JhL86ELFsbfessmNTLEuj81tiOOf4OvwOohALrl9gUeHUk2ad9zThuvEL1TnYi
         ET7AIvqwux4C9PBBUBMUO/og+9ALEy2n6BNO1UXNUcjNSjw3DGI4RfZRNSiZ6FxU
         jhBLkkzlOzJ3T1Xrb7cFdFIl9e4jyQj25sUTm4QSKpWaO0LVSTVpV+F+VZeiY3O9
         BQCt0tstSWsGS5BDiUHxG7C3Sw0JhI9KZ91hrSEUR0kYNraYIGX11ZAuno7lBNQW
         Al4A/gz7fHz0hR0iBb+/NELychZr8HSDz3pFJy9ZZlgpCWb2yW/JR0BS8Q6UYJDV
         rrWoDPKlPxHCdkhUa8lKqg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 25 Feb 2026 13:31:15 +0900
Subject: [PATCH v3 1/2] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-hybrid-v3-1-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
References: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-5ab4c
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[u-tokyo.ac.jp : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-71775-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_PERMFAIL(0.00)[rsg.ci.i.u-tokyo.ac.jp:s=rs20250326];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[rsg.ci.i.u-tokyo.ac.jp:~];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[odaki@rsg.ci.i.u-tokyo.ac.jp,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.919];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rsg.ci.i.u-tokyo.ac.jp:mid,u-tokyo.ac.jp:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8838D1919B6
X-Rspamd-Action: no action

On a heterogeneous arm64 system, KVM's PMU emulation is based on the
features of a single host PMU instance. When a vCPU is migrated to a
pCPU with an incompatible PMU, counters such as PMCCNTR_EL0 stop
incrementing.

Although this behavior is permitted by the architecture, Windows does
not handle it gracefully and may crash with a division-by-zero error.

The current workaround requires VMMs to pin vCPUs to a set of pCPUs
that share a compatible PMU. This is difficult to implement correctly in
QEMU/libvirt, where pinning occurs after vCPU initialization, and it
also restricts the guest to a subset of available pCPUs.

Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
create a "fixed-counters-only" PMU. When set, KVM exposes a PMU that is
compatible with all pCPUs but that does not support programmable
event counters which may have different feature sets on different PMUs.

This allows Windows guests to run reliably on heterogeneous systems
without crashing, even without vCPU pinning, and enables VMMs to
schedule vCPUs across all available pCPUs, making full use of the host
hardware.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 Documentation/virt/kvm/devices/vcpu.rst |  29 ++++++
 arch/arm64/include/asm/kvm_host.h       |   3 +
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/arm.c                    |   8 +-
 arch/arm64/kvm/pmu-emul.c               | 155 +++++++++++++++++++++-----------
 include/kvm/arm_pmu.h                   |   1 +
 6 files changed, 146 insertions(+), 51 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60bf205cb373..e0aeb1897d77 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -161,6 +161,35 @@ explicitly selected, or the number of counters is out of range for the
 selected PMU. Selecting a new PMU cancels the effect of setting this
 attribute.
 
+1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
+------------------------------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+:Returns:
+
+	 =======  =====================================================
+	 -EBUSY   Attempted to set after initializing PMUv3 or running
+		  VCPU, or attempted to set for the first time after
+		  setting an event filter
+	 -ENXIO   Attempted to get before setting
+	 -ENODEV  Attempted to set while PMUv3 not supported
+	 =======  =====================================================
+
+If set, PMUv3 will be emulated without programmable event counters. The VCPU
+will use any compatible hardware PMU. This attribute is particularly useful on
+heterogeneous systems where different hardware PMUs cover different physical
+CPUs. The compatibility of hardware PMUs can be checked with
+KVM_ARM_VCPU_PMU_V3_SET_PMU. All VCPUs in a VM share this attribute. It isn't
+possible to set it for the first time if a PMU event filter is already present.
+
+Note that KVM will not make any attempts to run the VCPU on the physical CPUs
+with compatible hardware PMUs. This is entirely left to userspace. However,
+attempting to run the VCPU on an unsupported CPU will fail and KVM_RUN will
+return with exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct
+by setting hardware_entry_failure_reason field to
+KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and the cpu field to the processor id.
+
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64302c438355..d1b0c71afbfe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -54,6 +54,7 @@
 #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
+#define KVM_REQ_CREATE_PMU		KVM_ARCH_REQ(11)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -350,6 +351,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_GUEST_HAS_SVE			9
 	/* MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are writable from userspace */
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
+	/* PMUv3 is emulated without progammable event counters */
+#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	11
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c..7fb7bf07df76 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -436,6 +436,7 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 052bf0d4d0b0..6764d0bb3994 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -629,6 +629,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
+		kvm_make_request(KVM_REQ_CREATE_PMU, vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -1056,6 +1058,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_vcpu_reload_pmu(vcpu);
 
+		if (kvm_check_request(KVM_REQ_CREATE_PMU, vcpu))
+			kvm_vcpu_create_pmu(vcpu);
+
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
 
@@ -1516,7 +1521,8 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
 	 * When the vCPU has a PMU, but no PMU is set for the guest
 	 * yet, set the default one.
 	 */
-	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
+	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
+	    !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
 		ret = kvm_arm_set_default_pmu(kvm);
 
 	/* Prepare for nested if required */
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab..2c19e037d432 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -619,18 +619,24 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
-static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
+static u64 kvm_pmu_enabled_counter_mask(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	unsigned int mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	u64 mask = 0;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx)))
-		return false;
+	if (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HPME)
+		mask |= kvm_pmu_hyp_counter_mask(vcpu);
 
-	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
-		return mdcr & MDCR_EL2_HPME;
+	if (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)
+		mask |= ~kvm_pmu_hyp_counter_mask(vcpu);
 
-	return kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E;
+	return __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+}
+
+static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
+	return kvm_pmu_enabled_counter_mask(vcpu) & BIT(pmc->idx);
 }
 
 static bool kvm_pmc_counts_at_el0(struct kvm_pmc *pmc)
@@ -662,10 +668,8 @@ static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
 	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
 }
 
-static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
+static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
 {
-	struct arm_pmu *pmu = kvm->arch.arm_pmu;
-
 	/*
 	 * The CPU PMU likely isn't PMUv3; let the driver provide a mapping
 	 * for the guest's PMUv3 event ID.
@@ -676,6 +680,23 @@ static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
 	return eventsel;
 }
 
+static struct arm_pmu *kvm_pmu_probe_armpmu(int cpu)
+{
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *pmu;
+
+	guard(mutex)(&arm_pmus_lock);
+
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
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -689,6 +710,14 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	int eventsel;
 	u64 evtreg;
 
+	if (!arm_pmu) {
+		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
+		if (!arm_pmu) {
+			vcpu_set_on_unsupported_cpu(vcpu);
+			return;
+		}
+	}
+
 	evtreg = kvm_pmc_read_evtreg(pmc);
 
 	kvm_pmu_stop_counter(pmc);
@@ -717,7 +746,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	 * Don't create an event if we're running on hardware that requires
 	 * PMUv3 event translation and we couldn't find a valid mapping.
 	 */
-	eventsel = kvm_map_pmu_event(vcpu->kvm, eventsel);
+	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
 	if (eventsel < 0)
 		return;
 
@@ -805,42 +834,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	list_add_tail(&entry->entry, &arm_pmus);
 }
 
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
 static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
 {
 	u32 hi[2], lo[2];
@@ -883,6 +876,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
+	if (!cpu_pmu)
+		return 0;
+
 	if (!pmceid1) {
 		val = compute_pmceid0(cpu_pmu);
 		base = 0;
@@ -921,6 +917,15 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 	kvm_pmu_reprogram_counter_mask(vcpu, mask);
 }
 
+void kvm_vcpu_create_pmu(struct kvm_vcpu *vcpu)
+{
+	unsigned long mask = kvm_pmu_enabled_counter_mask(vcpu);
+	int i;
+
+	for_each_set_bit(i, &mask, 32)
+		kvm_pmu_create_perf_event(kvm_vcpu_idx_to_pmc(vcpu, i));
+}
+
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->arch.pmu.created)
@@ -1011,6 +1016,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	if (!arm_pmu)
+		return 0;
+
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
 	 * event, though the same may not be true of non-PMUv3 hardware.
@@ -1065,7 +1073,24 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  */
 int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
-	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
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
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
 
 	if (!arm_pmu)
 		return -ENODEV;
@@ -1094,6 +1119,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 			}
 
 			kvm_arm_set_pmu(kvm, arm_pmu);
+			clear_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
@@ -1104,11 +1130,33 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	return ret;
 }
 
+static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (kvm_vm_has_ran_once(kvm) ||
+	    (kvm->arch.pmu_filter &&
+	     !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags)))
+		return -EBUSY;
+
+	kvm->arch.arm_pmu = NULL;
+	kvm_arm_set_nr_counters(kvm, 0);
+	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
+	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
+
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	if (!kvm->arch.arm_pmu)
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!kvm->arch.arm_pmu &&
+	    !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
 		return -EINVAL;
 
 	if (n > kvm_arm_pmu_get_max_counters(kvm))
@@ -1223,6 +1271,8 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		return kvm_arm_pmu_v3_set_pmu_fixed_counters_only(vcpu);
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -1249,6 +1299,10 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		irq = vcpu->arch.pmu.irq_num;
 		return put_user(irq, uaddr);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		lockdep_assert_held(&vcpu->kvm->arch.config_lock);
+		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
+			return 0;
 	}
 
 	return -ENXIO;
@@ -1262,6 +1316,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b411..197ff8e25128 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -57,6 +57,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu);
+void kvm_vcpu_create_pmu(struct kvm_vcpu *vcpu);
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,

-- 
2.53.0


