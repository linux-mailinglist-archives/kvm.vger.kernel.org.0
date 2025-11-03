Return-Path: <kvm+bounces-61892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D118C2D521
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DEE7189C8E3
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E74C328B75;
	Mon,  3 Nov 2025 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avy75bU6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EC1328601;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188934; cv=none; b=aWEn+w++tnE6dyh/sn38V/a80mRQQ5LjJnF0QcFl58KkeqJcLaGeT3njScJmYIxkHBjOe/g9I5u+cWAtZw6qIHbj7AZUt4rgeZyVzcxyr9hvGHTCg4CKkYtcdRcpDIbhBZ/OpwfN3A2xuCpRsbLZX939nwaZ8YWinyesVXkA+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188934; c=relaxed/simple;
	bh=1mIPCQAmFQ4SUc8uHFMSk1nEW7q40NxnGo6tyZ3rNV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH7i+WYijyOYVjMkkoaPkozDn4AxQWJ7WcVjHKNxf/p3V2y9WqGmLQRO7wevHk+6FLMlcVQolsZ1SrqnK7UlqyFW6ejCjVG7zgENOB34LRA5aN4vfZWm1a9KqeF01eSuH4epwGr6ENsmMKeN8MpE8i3BBdaMRXBmnoHDPH+qe5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avy75bU6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5171EC19421;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188934;
	bh=1mIPCQAmFQ4SUc8uHFMSk1nEW7q40NxnGo6tyZ3rNV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avy75bU6UP0QNxNHYTGLYenhFa8tLWi/IIUzP4j1xl41AU7UcQom3OJBUz/srxChE
	 ljQ8i17V68/alb630p+u7YY4E0YSQTrsJgWPVF8jIQ6taILrz6pIeZp9jH9z9Z1MmF
	 cXF8MOYJcjSo6TTWypVSYlsHwW3xTX9ld8Loa9Aqrb6E9sW+3LRUitSkQmaYZhlFTQ
	 vmFpON1OVhBklS8uYq6Du23LFS43AguKlU4yu9ZCXNe08x4/Y5+i+jbGaasjb0QG7V
	 kS7Qc8tyuEGiQi4sPp93mOvCdZ+rjKJFM2fyQ1y7i/LVHd6UwKV3ZswUgaxzpHvDUv
	 MWOkJJuNcGeIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq8-000000021VN-2Ngk;
	Mon, 03 Nov 2025 16:55:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 33/33] KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
Date: Mon,  3 Nov 2025 16:55:17 +0000
Message-ID: <20251103165517.2960148-34-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
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
 arch/arm64/kvm/vgic/vgic.c      | 14 ++++++++++++--
 arch/arm64/kvm/vgic/vgic.h      |  6 ++++++
 include/kvm/arm_vgic.h          |  3 +++
 5 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f03cbf0ad154a..54f6c1df9d996 100644
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
index f638fd1f95020..2ec8b66e56e72 100644
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
+	if (irqs_active_outside_lrs(als) ||
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
index 4f9f88ef737e3..5d380ed7e23cf 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -379,6 +379,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 			   unsigned long flags) __releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
+	bool bcast;
 
 	lockdep_assert_held(&irq->irq_lock);
 
@@ -453,11 +454,20 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
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
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index cf41864736204..c932bfd89d70c 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -164,6 +164,12 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
+static inline bool vgic_model_needs_bcst_kick(struct kvm *kvm)
+{
+	return (cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDS) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index caa72a92cb5d9..1eff4ff5f295d 100644
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


