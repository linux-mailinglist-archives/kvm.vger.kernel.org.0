Return-Path: <kvm+bounces-55154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0466B2E03F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EED37BF9EE
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34463375BD;
	Wed, 20 Aug 2025 14:58:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB54321F4F;
	Wed, 20 Aug 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701899; cv=none; b=Vl7eJo526nLaOeXztzUAPk1gBPIh4O3wcg/4LDQdIQGtxAz05KwrSlM1gOm2efNNC2hu5h2Y2heGhFiSJEpQD1QKTjrOrQXGdi2N1KtSxpscFJlHPE5lS2sg5B+994jFvtHQdznuS1sXJRa3oI/w0Khm7K/oUP+GcFFU7KHGu14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701899; c=relaxed/simple;
	bh=P0p1qZbPVPDSokJ2CQT1gFEsnxFcPoVxQoLqZX7X/S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGscJZpz/qh8YMIDxmlG33q6ckSWFqyLZcA7Q7ZB7gElg+g2xvZykTwy1Bjl46N3tGb7o5gKgSSuMTxryfz4n3ngUB4MzTyYOCZG1AkIVeQMLuIRipzviU09x4XBLNpYQwW9pkU0/8mTuZ8zoVd6pdXCwaylEECr0kw6+e6uGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 347412C27;
	Wed, 20 Aug 2025 07:58:09 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEB073F738;
	Wed, 20 Aug 2025 07:58:11 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 14/43] KVM: arm64: Support timers in realm RECs
Date: Wed, 20 Aug 2025 15:55:34 +0100
Message-ID: <20250820145606.180644-15-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM keeps track of the timer while the realm REC is running, but on
exit to the normal world KVM is responsible for handling the timers.

The RMM doesn't provide a mechanism to set the counter offset, so don't
expose KVM_CAP_COUNTER_OFFSET for a realm VM.

A later patch adds the support for propagating the timer values from the
exit data structure and calling kvm_realm_timers_update().

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v9:
 * No need to move the call to kvm_timer_unblocking() in
   kvm_timer_vcpu_load().
Changes since v7:
 * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
---
 arch/arm64/kvm/arch_timer.c  | 44 ++++++++++++++++++++++++++++++++++--
 arch/arm64/kvm/arm.c         |  2 +-
 include/kvm/arm_arch_timer.h |  2 ++
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index dbd74e4885e2..0a15450571df 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -148,6 +148,13 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	if (kvm_is_realm(vcpu->kvm)) {
+		WARN_ON(offset);
+		return;
+	}
+
 	if (!ctxt->offset.vm_offset) {
 		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
 		return;
@@ -462,6 +469,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 			    timer_ctx);
 }
 
+void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
+	int i;
+
+	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
+		struct arch_timer_context *timer = &arch_timer->timers[i];
+		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
+		bool level = kvm_timer_irq_can_fire(timer) && status;
+
+		if (level != timer->irq.level)
+			kvm_timer_update_irq(vcpu, level, timer);
+	}
+}
+
 /* Only called for a fully emulated timer */
 static void timer_emulate(struct arch_timer_context *ctx)
 {
@@ -1065,7 +1087,9 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->vcpu = vcpu;
 
-	if (timerid == TIMER_VTIMER)
+	if (kvm_is_realm(vcpu->kvm))
+		ctxt->offset.vm_offset = NULL;
+	else if (timerid == TIMER_VTIMER)
 		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
 	else
 		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
@@ -1087,13 +1111,19 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
+	u64 cntvoff;
 
 	for (int i = 0; i < NR_KVM_TIMERS; i++)
 		timer_context_init(vcpu, i);
 
+	if (kvm_is_realm(vcpu->kvm))
+		cntvoff = 0;
+	else
+		cntvoff = kvm_phys_timer_read();
+
 	/* Synchronize offsets across timers of a VM if not already provided */
 	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
-		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
+		timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
 	}
 
@@ -1633,6 +1663,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
+	/*
+	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
+	 * us setting the LR.HW bit in the VGIC.
+	 */
+	if (vcpu_is_rec(vcpu))
+		return 0;
+
 	get_timer_map(vcpu, &map);
 
 	ret = kvm_vgic_map_phys_irq(vcpu,
@@ -1764,6 +1801,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
+	if (kvm_is_realm(kvm))
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 
 	if (!kvm_trylock_all_vcpus(kvm)) {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8d7f4421d8fc..81a4193d78cf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -351,10 +351,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
-	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
 		r = 1;
 		break;
+	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_SET_GUEST_DEBUG:
 		r = !kvm_is_realm(kvm);
 		break;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 681cf0c8b9df..f64e317c091b 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -113,6 +113,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
+void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
+
 u64 kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
-- 
2.43.0


