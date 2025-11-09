Return-Path: <kvm+bounces-62453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F72C44401
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:19:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 888374E90BF
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7327230F7FE;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCBu1Z7L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6910D30E0E2;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708597; cv=none; b=rynvLDApX2UnzsM2CNuc7iw3/oHDwanQ9MWL8pYyX4hm3KPcori4Ver+jwNgYxmuBYBAskBPvhttU/P7ccAYGGENhh7hc7SlwTnheO1UVfo/oQyEo+A1+EOXnKgYQNE0qzUYBTL80MwlachRHPMrzWM/J4PWUgBbxX2lbVcrFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708597; c=relaxed/simple;
	bh=cqtAH1b9qpZi4sn8XeP4mVatePdCI9WKE0NMEYL2+h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si/l1V+AsWl8SB7tsUYHLL20nLp4ZDvrwIeqs+3HNVonLYZ/2+nQ6ZXAgfPzEHCSEU2Ryg3CBaiXu217UrfyNXJyDi6+DD+MEoEhdSYTCD+Dsj4UnjDYXp+mW7MrMdwgZyLPHX69SF9/wVlwN6HSrXMhXNg/acXQY42hIhE5h34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCBu1Z7L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D65C116B1;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708597;
	bh=cqtAH1b9qpZi4sn8XeP4mVatePdCI9WKE0NMEYL2+h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCBu1Z7LcP259qn2g1fzMuzzZyjoT/mnqmUr8CgvXkhoPtDszvqgr2Tvw7rI90W4/
	 PX8VLd+6NKkIyNB4ciLl3euEE+O+v/OAr4BwxwaU68COsWmZRbHznVPo5+DltzGn1l
	 Np8fyxADQfwINm1VscG2KYIilJ0HjqmBifTcOEp3NyIed5SULHbgA6Rze+AehWING1
	 b4A1GX34ivsIYj3XgI9r5NQ/v/mhxZyNYEPf06uZSW3nzCaxlBE67dmFguaHiC9JDC
	 yo8QP7b4+dj+xE2ekxVMoktUmWUqfXFMstxyanl1VbG6bRGnD69GT0ZTelMc7ebI6r
	 9soJ+L2mo6aXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91n-00000003exw-1G6w;
	Sun, 09 Nov 2025 17:16:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 30/45] KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
Date: Sun,  9 Nov 2025 17:16:04 +0000
Message-ID: <20251109171619.1507205-31-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

SPIs are specially annpying, as they can be activated on a CPU and
deactivated on another. WHich means that when an SPI is in flight
anywhere, all CPUs need to have their TDIR trap bit set.

This translates into broadcasting an IPI across all CPUs to make sure
they set their trap bit, The number of in-flight SPIs is kept in
an atomic variable so that CPUs can turn the trap bit off as soon
as possible.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |  1 +
 arch/arm64/kvm/vgic/vgic-v3.c   | 21 +++++++++++++++------
 arch/arm64/kvm/vgic/vgic.c      | 25 +++++++++++++++++++++++--
 include/kvm/arm_vgic.h          |  3 +++
 4 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 6d5e5d708f23a..52de99c0f01ce 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -188,6 +188,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
 	int i;
 
+	dist->active_spis = (atomic_t)ATOMIC_INIT(0);
 	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL_ACCOUNT);
 	if (!dist->spis)
 		return  -ENOMEM;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 26e17ed057f00..bf4dde158d516 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -44,10 +44,17 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
 
 	/*
+	 * Dealing with EOImode=1 is a massive source of headache. Not
+	 * only do we need to track that we have active interrupts
+	 * outside of the LRs and force DIR to be trapped, we also
+	 * need to deal with SPIs that can be deactivated on another
+	 * CPU.
+	 *
 	 * Note that we set the trap irrespective of EOIMode, as that
 	 * can change behind our back without any warning...
 	 */
-	if (irqs_active_outside_lrs(als))
+	if (irqs_active_outside_lrs(als)		     ||
+	    atomic_read(&vcpu->kvm->arch.vgic.active_spis))
 		cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
 }
 
@@ -75,11 +82,6 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 	if (!irq)	/* An LPI could have been unmapped. */
 		return;
 
-	/* Notify fds when the guest EOI'ed a level-triggered IRQ */
-	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
-		kvm_notify_acked_irq(vcpu->kvm, 0,
-				     intid - VGIC_NR_PRIVATE_IRQS);
-
 	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		/* Always preserve the active bit for !LPIs, note deactivation */
 		if (irq->intid >= VGIC_MIN_LPI)
@@ -114,6 +116,13 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 		irq->on_lr = false;
 	}
 
+	/* Notify fds when the guest EOI'ed a level-triggered SPI, and drop the refcount */
+	if (deactivated && lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid)) {
+		kvm_notify_acked_irq(vcpu->kvm, 0,
+				     intid - VGIC_NR_PRIVATE_IRQS);
+		atomic_dec_if_positive(&vcpu->kvm->arch.vgic.active_spis);
+	}
+
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8c502135199f8..60bdddf3472e7 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -367,6 +367,17 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owne
 	return false;
 }
 
+static bool vgic_model_needs_bcst_kick(struct kvm *kvm)
+{
+	/*
+	 * A GICv3 (or GICv3-like) system exposing a GICv3 to the
+	 * guest needs a broadcast kick to set TDIR globally, even if
+	 * the bit doesn't really exist (we still need to check for
+	 * the shadow bit in the DIR emulation fast-path).
+	 */
+	return (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+}
+
 /*
  * Check whether an IRQ needs to (and can) be queued to a VCPU's ap list.
  * Do the queuing if necessary, taking the right locks in the right order.
@@ -379,6 +390,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 			   unsigned long flags) __releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
+	bool bcast;
 
 	lockdep_assert_held(&irq->irq_lock);
 
@@ -453,11 +465,20 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
+	/* A new SPI may result in deactivation trapping on all vcpus */
+	bcast = (vgic_model_needs_bcst_kick(vcpu->kvm) &&
+		 vgic_valid_spi(vcpu->kvm, irq->intid) &&
+		 atomic_fetch_inc(&vcpu->kvm->arch.vgic.active_spis) == 0);
+
 	raw_spin_unlock(&irq->irq_lock);
 	raw_spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
-	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
-	kvm_vcpu_kick(vcpu);
+	if (!bcast) {
+		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+		kvm_vcpu_kick(vcpu);
+	} else {
+		kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_IRQ_PENDING);
+	}
 
 	return true;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b798546755a34..6a4d3d2055966 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -263,6 +263,9 @@ struct vgic_dist {
 	/* The GIC maintenance IRQ for nested hypervisors. */
 	u32			mi_intid;
 
+	/* Track the number of in-flight active SPIs */
+	atomic_t		active_spis;
+
 	/* base addresses in guest physical address space: */
 	gpa_t			vgic_dist_base;		/* distributor */
 	union {
-- 
2.47.3


