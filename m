Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7708260CC8
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgIHH7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbgIHH6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:58:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 317C321D47;
        Tue,  8 Sep 2020 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599551928;
        bh=ke6U1LmQ1mseo/L4gp8OXGOendg+AP1Mv3LPdNBjBLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paQfb3ljsQaCIxbwBgN9EF/362fD8IhUux1vyPoQcaGcjPS4oKy+RtNsluRhdk9MP
         bee0ponVHT6ozkZrTMa16prNBezdyuNukZvpLyCKRO0OilzVJ1Nwf0VXEg+TQxEjUj
         xs4ZBFVRYfq5EnPp50Bty/k4YpbtNL7k3O/TQQpc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFYWc-009zhy-BL; Tue, 08 Sep 2020 08:58:46 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>, graf@amazon.com,
        kernel-team@android.com
Subject: [PATCH v3 3/5] KVM: arm64: Add PMU event filtering infrastructure
Date:   Tue,  8 Sep 2020 08:58:28 +0100
Message-Id: <20200908075830.1161921-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908075830.1161921-1-maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com, graf@amazon.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It can be desirable to expose a PMU to a guest, and yet not want the
guest to be able to count some of the implemented events (because this
would give information on shared resources, for example.

For this, let's extend the PMUv3 device API, and offer a way to setup a
bitmap of the allowed events (the default being no bitmap, and thus no
filtering).

Userspace can thus allow/deny ranges of event. The default policy
depends on the "polarity" of the first filter setup (default deny if the
filter allows events, and default allow if the filter denies events).
This allows to setup exactly what is allowed for a given guest.

Note that although the ioctl is per-vcpu, the map of allowed events is
global to the VM (it can be setup from any vcpu until the vcpu PMU is
initialized).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++
 arch/arm64/include/uapi/asm/kvm.h | 16 +++++++
 arch/arm64/kvm/arm.c              |  2 +
 arch/arm64/kvm/pmu-emul.c         | 70 ++++++++++++++++++++++++++++---
 4 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6cd60be69c28..1e64260b7e2b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -111,6 +111,11 @@ struct kvm_arch {
 	 */
 	bool return_nisv_io_abort_to_user;
 
+	/*
+	 * VM-wide PMU filter, implemented as a bitmap and big enough for
+	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
+	 */
+	unsigned long *pmu_filter;
 	unsigned int pmuver;
 };
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ba85bb23f060..7b1511d6ce44 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -159,6 +159,21 @@ struct kvm_sync_regs {
 struct kvm_arch_memory_slot {
 };
 
+/*
+ * PMU filter structure. Describe a range of events with a particular
+ * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
+ */
+struct kvm_pmu_event_filter {
+	__u16	base_event;
+	__u16	nevents;
+
+#define KVM_PMU_EVENT_ALLOW	0
+#define KVM_PMU_EVENT_DENY	1
+
+	__u8	action;
+	__u8	pad[3];
+};
+
 /* for KVM_GET/SET_VCPU_EVENTS */
 struct kvm_vcpu_events {
 	struct {
@@ -329,6 +344,7 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
+#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 691d21e4c717..0f11d0009c17 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -145,6 +145,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	int i;
 
+	bitmap_free(kvm->arch.pmu_filter);
+
 	kvm_vgic_destroy(kvm);
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8a5f65763814..67a731bafbc9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -30,6 +30,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	case 6:			/* ARMv8.5 */
 		return GENMASK(15, 0);
 	default:		/* Shouldn't be there, just for sanity */
+		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
 		return 0;
 	}
 }
@@ -592,11 +593,21 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
-	eventsel = data & kvm_pmu_event_mask(vcpu->kvm);;
+	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
+		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	else
+		eventsel = data & kvm_pmu_event_mask(vcpu->kvm);
+
+	/* Software increment event doesn't need to be backed by a perf event */
+	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
+		return;
 
-	/* Software increment event does't need to be backed by a perf event */
-	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
-	    pmc->idx != ARMV8_PMU_CYCLE_IDX)
+	/*
+	 * If we have a filter in place and that the event isn't allowed, do
+	 * not install a perf event either.
+	 */
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
@@ -608,8 +619,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
-	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
-		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
+	attr.config = eventsel;
 
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
@@ -892,6 +902,53 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		vcpu->arch.pmu.irq_num = irq;
 		return 0;
 	}
+	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		struct kvm_pmu_event_filter __user *uaddr;
+		struct kvm_pmu_event_filter filter;
+		int nr_events;
+
+		nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
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
+		mutex_lock(&vcpu->kvm->lock);
+
+		if (!vcpu->kvm->arch.pmu_filter) {
+			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL);
+			if (!vcpu->kvm->arch.pmu_filter) {
+				mutex_unlock(&vcpu->kvm->lock);
+				return -ENOMEM;
+			}
+
+			/*
+			 * The default depends on the first applied filter.
+			 * If it allows events, the default is to deny.
+			 * Conversely, if the first filter denies a set of
+			 * events, the default is to allow.
+			 */
+			if (filter.action == KVM_PMU_EVENT_ALLOW)
+				bitmap_zero(vcpu->kvm->arch.pmu_filter, nr_events);
+			else
+				bitmap_fill(vcpu->kvm->arch.pmu_filter, nr_events);
+		}
+
+		if (filter.action == KVM_PMU_EVENT_ALLOW)
+			bitmap_set(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+		else
+			bitmap_clear(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+
+		mutex_unlock(&vcpu->kvm->lock);
+
+		return 0;
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -928,6 +985,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
+	case KVM_ARM_VCPU_PMU_V3_FILTER:
 		if (kvm_arm_support_pmu_v3() &&
 		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 			return 0;
-- 
2.28.0

