Return-Path: <kvm+bounces-61885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE9EC2D4D5
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E5263340F9C
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA823271EE;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sl5htj6a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89BE325482;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188933; cv=none; b=ruUV17Xs5fOznYXjCAwDburb027f5HLc3yTdyOl06fZQyZqeFyqxzNXM4+txlVMb+Dz7eI8m/007RKCco0l/40StLX5OhMYVPnW82u8MvcaHO+aIQeKIGCfb0s9do7ngndq4V1v8rR9Eq7cRNQ9LZcNl1Kso0LBzdOZbSMhd0/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188933; c=relaxed/simple;
	bh=H45ACQ31zwJs1iN2ph2dhip32kIZZ3Ja116Yq9uq39w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F79b2uKBOC6g7MxIV9GA+bQW0VvGSoypCs3ewG8jcHAs+GDdHcbWK/Ex5oUuX0WIvYHcyzyNgwaz4lEWgIApjtXnafECb/oSfXe4UX3hzNzFpxOLit0tXOZH6tpBBbo9HC5073H2IYp8nVZF24ZIaqmV9KkV8EHgFnmY3RLwylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sl5htj6a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8192EC113D0;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188932;
	bh=H45ACQ31zwJs1iN2ph2dhip32kIZZ3Ja116Yq9uq39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sl5htj6aziAwulZZC3H3V7p9+I2Z48ggSRrHZQgdsSoJ+9yXguulRF2uyhLrql2kz
	 bP/IwInJk+Cc32RfZJb22pxqLIKqC4kEqAlIxFHE4MLEzr59LOO/mVhRMcQ1+3D6Mt
	 9DFKDmGRd3dy9Omkmtopd4P+GsWWaUdmyCK3Wp/SmOF9R0oqfp4REy1Oaf7nnfI8D6
	 ab7ig0tyq8/TjaoWQFwgIhxWkjyyn3Yci8VQo0k1mUGQPqNzGr94C+Q6tmQocilJyQ
	 0QKE9yRJZOSt9xPmzzcZQijYXtZak/hhvjGpuAjVYqjMrQLQlQDl7WcN7KrfIJzx+v
	 GDq7NrjOoSWqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq6-000000021VN-2h9B;
	Mon, 03 Nov 2025 16:55:30 +0000
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
Subject: [PATCH 25/33] KVM: arm64: Add AP-list overflow split/splice
Date: Mon,  3 Nov 2025 16:55:09 +0000
Message-ID: <20251103165517.2960148-26-maz@kernel.org>
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

When EOImode==0, the deactivation of an interrupt outside of the LRs
results in an increment of EOIcount, but not much else.

In order to figure out what interrupts did not make it into the LRs,
split the ap_list to make it easy to find the interrupts EOIcount
applies to. Also provide a bit of documentation for how things are
expected to work.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |  2 ++
 arch/arm64/kvm/vgic/vgic.c      | 48 ++++++++++++++++++++++++++++++++-
 include/kvm/arm_vgic.h          |  6 +++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1796b1a22a72a..f03cbf0ad154a 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -331,6 +331,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	INIT_LIST_HEAD(&vgic_cpu->overflow_ap_list_head);
 	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
 	atomic_set(&vgic_cpu->vgic_v3.its_vpe.vlpi_count, 0);
 
@@ -455,6 +456,7 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	INIT_LIST_HEAD(&vgic_cpu->overflow_ap_list_head);
 	kfree(vgic_cpu->private_irqs);
 	vgic_cpu->private_irqs = NULL;
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5c9204d18b27d..bd77365331530 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -687,6 +687,15 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 retry:
 	raw_spin_lock(&vgic_cpu->ap_list_lock);
 
+	/*
+	 * Replug the overflow list into the ap_list so that we can walk the
+	 * whole thing in one go. Note that we only replug it once,
+	 * irrespective of how many tries we perform.
+	 */
+	if (!list_empty(&vgic_cpu->overflow_ap_list_head))
+		list_splice_tail_init(&vgic_cpu->overflow_ap_list_head,
+				      &vgic_cpu->ap_list_head);
+
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
 		bool target_vcpu_needs_kick = false;
@@ -914,12 +923,33 @@ static void summarize_ap_list(struct kvm_vcpu *vcpu,
  *   if they were made pending sequentially. This may mean that we don't
  *   always present the HPPI if other interrupts with lower priority are
  *   pending in the LRs. Big deal.
+ *
+ * Additional complexity comes from dealing with these overflow interrupts,
+ * as they are not easy to locate on exit (the ap_list isn't immutable while
+ * the vcpu is running, and new interrupts can be added).
+ *
+ * To deal with this, we play some games with the ap_list:
+ *
+ * - On entering the guest, interrupts that haven't made it onto the LRs are
+ *   placed on an overflow list. These entries are still notionally part of
+ *   the ap_list (the vcpu field still points to the owner).
+ *
+ * - On exiting the guest, the overflow list is used to handle the
+ *   deactivations signaled by EOIcount, by walking the list and
+ *   deactivating EOIcount interrupts from the overflow list.
+ *
+ * - The overflow list is then spliced back with the rest of the ap_list,
+ *   before pruning of idle interrupts.
+ *
+ * - Interrupts that are made pending while the vcpu is running are added to
+ *   the ap_list itself, never to the overflow list. This ensures that these
+ *   new interrupts are not evaluated for deactivation when the vcpu exits.
  */
 static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct ap_list_summary als;
-	struct vgic_irq *irq;
+	struct vgic_irq *irq, *last = NULL;
 	int count = 0;
 
 	lockdep_assert_held(&vgic_cpu->ap_list_lock);
@@ -933,6 +963,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		scoped_guard(raw_spinlock,  &irq->irq_lock) {
 			if (likely(vgic_target_oracle(irq) == vcpu)) {
 				vgic_populate_lr(vcpu, irq, count++);
+				last = irq;
 			}
 		}
 
@@ -951,6 +982,21 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		vcpu->arch.vgic_cpu.vgic_v3.used_lrs = count;
 		vgic_v3_configure_hcr(vcpu, &als);
 	}
+
+	/*
+	 * Move the end of the list to the overflow list, unless:
+	 *
+	 * - either we didn't inject anything at all
+	 * - or we injected everything there was to inject
+	 */
+	if (!count ||
+	    (last && list_is_last(&last->ap_list, &vgic_cpu->ap_list_head))) {
+		INIT_LIST_HEAD(&vgic_cpu->overflow_ap_list_head);
+		return;
+	}
+
+	vgic_cpu->overflow_ap_list_head = vgic_cpu->ap_list_head;
+	list_cut_position(&vgic_cpu->ap_list_head, &vgic_cpu->overflow_ap_list_head, &last->ap_list);
 }
 
 static inline bool can_access_vgic_from_kernel(void)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ec349c5a4a8b6..1d700850f6ea7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -359,6 +359,12 @@ struct vgic_cpu {
 	 */
 	struct list_head ap_list_head;
 
+	/*
+	 * List of IRQs that have not made it onto an LR, but still
+	 * notionally par of the AP list
+	 */
+	struct list_head overflow_ap_list_head;
+
 	/*
 	 * Members below are used with GICv3 emulation only and represent
 	 * parts of the redistributor.
-- 
2.47.3


