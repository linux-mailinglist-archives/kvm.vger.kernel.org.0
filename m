Return-Path: <kvm+bounces-61879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 736A8C2D4F0
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86802189CB5F
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F272325487;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tseblQ2p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00C32145E;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188931; cv=none; b=T9RfInnR6mkIf5INnAOVw4YzO01dTUp1H1YGpcBBouAvWEiySAfBHRvnD60KfyF1Dexw51CQFoswhyoOXlA37NgvS+pCRFKPj91nb+b+vWWJiG4iFvvlZXYHJS+za2m4db7pnAJxfQXLloWsSv+ulvLUjcTNOR/4W8Z3kiPE8Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188931; c=relaxed/simple;
	bh=3/UPj3JyOdGjjMKJy1YD56dVdglZfCN/A8x3/NIHl78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKQ495KeuNetuG7h48MKVhyfhAYO0EOkanysKD5ctQ5IWrOQfbFAeyKmhKR8SqcnW8ZDOvNi5iy7wu3XXj638KT1mPdM5KOf4KEawsAWAWE7G0TYI04T1zUZYx66mGFtpt3buC/MivCtjCRuKJGBpyKYGd7nErKQAWdLFljDWXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tseblQ2p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B197C4CEFD;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188931;
	bh=3/UPj3JyOdGjjMKJy1YD56dVdglZfCN/A8x3/NIHl78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tseblQ2prC4cEb/PdN+c0HlVpBCZSkIJRqFCo5pwDu9akkr9HwweR0ELtiqh5a/qn
	 6AZZiegYRfWavxMCvkX2zCe3U7vat1r4QiNid5t/xkZW0wdWCWB0BqkUpbIztwlI61
	 azb2QU9L5uW+ltvarmcDeg/B8LxkZJWYsyOhFjixw4vP3GiEN7V2DzCE6/5uujEyUP
	 Q+xB8+Uf3KefYnxwAW/0mpuj6oIpwSC22VusT0HMiWOTWyVyoneI5HoflZr0zs1TJu
	 K9MNUpwpjS2+cEo+5uDWGguq7RrQSpIFAUVcH34n8quNU03SQfIxaJujfXU1y2GrvF
	 lY5dcApr9Js1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq5-000000021VN-1oDq;
	Mon, 03 Nov 2025 16:55:29 +0000
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
Subject: [PATCH 20/33] KVM: arm64: Revamp vgic maintenance interrupt configuration
Date: Mon,  3 Nov 2025 16:55:04 +0000
Message-ID: <20251103165517.2960148-21-maz@kernel.org>
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

We currently don't use the maintenance interrupt very much, apart
from EOI on level interrupts, and for LR underflow in limited cases.

However, as we are moving toward a setup where active interrupts
can live outside of the LRs, we need to use the MIs in a more
diverse set of cases.

Add a new helper that produces a digest of the ap_list, and use
that summary to set the various control bits as required.

This slightly changes the way v2 SGIs are handled, as they used to
count for more than one interrupt, but not anymore.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 12 ++++-
 arch/arm64/kvm/vgic/vgic-v3.c | 15 +++++-
 arch/arm64/kvm/vgic/vgic.c    | 91 ++++++++++++-----------------------
 arch/arm64/kvm/vgic/vgic.h    | 19 +++++++-
 4 files changed, 71 insertions(+), 66 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 07e93acafd04d..f53bc55288978 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -26,11 +26,19 @@ void vgic_v2_init_lrs(void)
 		vgic_v2_write_lr(i, 0);
 }
 
-void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
+void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu,
+			   struct ap_list_summary *als)
 {
 	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
 
-	cpuif->vgic_hcr |= GICH_HCR_UIE;
+	cpuif->vgic_hcr = GICH_HCR_EN;
+
+	if (irqs_pending_outside_lrs(als))
+		cpuif->vgic_hcr |= GICH_HCR_NPIE;
+	if (irqs_active_outside_lrs(als))
+		cpuif->vgic_hcr |= GICH_HCR_LRENPIE;
+	if (irqs_outside_lrs(als))
+		cpuif->vgic_hcr |= GICH_HCR_UIE;
 }
 
 static bool lr_signals_eoi_mi(u32 lr_val)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 15225cf353f91..79fa16c5344fb 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -20,11 +20,22 @@ static bool common_trap;
 static bool dir_trap;
 static bool gicv4_enable;
 
-void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
+void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
+			   struct ap_list_summary *als)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	cpuif->vgic_hcr |= ICH_HCR_EL2_UIE;
+	cpuif->vgic_hcr = ICH_HCR_EL2_En;
+
+	if (irqs_pending_outside_lrs(als))
+		cpuif->vgic_hcr |= ICH_HCR_EL2_NPIE;
+	if (irqs_active_outside_lrs(als))
+		cpuif->vgic_hcr |= ICH_HCR_EL2_LRENPIE;
+	if (irqs_outside_lrs(als))
+		cpuif->vgic_hcr |= ICH_HCR_EL2_UIE;
+
+	if (!als->nr_sgi)
+		cpuif->vgic_hcr |= ICH_HCR_EL2_vSGIEOICount;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 46b31cd365466..c420f8262e4c1 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -791,38 +791,30 @@ static inline void vgic_clear_lr(struct kvm_vcpu *vcpu, int lr)
 		vgic_v3_clear_lr(vcpu, lr);
 }
 
-static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_set_underflow(vcpu);
-	else
-		vgic_v3_set_underflow(vcpu);
-}
-
-/* Requires the ap_list_lock to be held. */
-static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
-				 bool *multi_sgi)
+static void summarize_ap_list(struct kvm_vcpu *vcpu,
+			      struct ap_list_summary *als)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
-	int count = 0;
-
-	*multi_sgi = false;
 
 	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
-	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-		int w;
+	*als = (typeof(*als)){};
 
-		raw_spin_lock(&irq->irq_lock);
-		/* GICv2 SGIs can count for more than one... */
-		w = vgic_irq_get_lr_count(irq);
-		raw_spin_unlock(&irq->irq_lock);
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		scoped_guard(raw_spinlock, &irq->irq_lock) {
+			if (vgic_target_oracle(irq) != vcpu)
+				continue;
+
+			if (!irq->active)
+				als->nr_pend++;
+			else
+				als->nr_act++;
+		}
 
-		count += w;
-		*multi_sgi |= (w > 1);
+		if (irq->intid < VGIC_NR_SGIS)
+			als->nr_sgi++;
 	}
-	return count;
 }
 
 /*
@@ -908,60 +900,39 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
 static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct ap_list_summary als;
 	struct vgic_irq *irq;
-	int count;
-	bool multi_sgi;
-	u8 prio = 0xff;
-	int i = 0;
+	int count = 0;
 
 	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
-	count = compute_ap_list_depth(vcpu, &multi_sgi);
-	if (count > kvm_vgic_global_state.nr_lr || multi_sgi)
-		vgic_sort_ap_list(vcpu);
+	summarize_ap_list(vcpu, &als);
 
-	count = 0;
+	if (irqs_outside_lrs(&als))
+		vgic_sort_ap_list(vcpu);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-		raw_spin_lock(&irq->irq_lock);
-
-		/*
-		 * If we have multi-SGIs in the pipeline, we need to
-		 * guarantee that they are all seen before any IRQ of
-		 * lower priority. In that case, we need to filter out
-		 * these interrupts by exiting early. This is easy as
-		 * the AP list has been sorted already.
-		 */
-		if (multi_sgi && irq->priority > prio) {
-			raw_spin_unlock(&irq->irq_lock);
-			break;
+		scoped_guard(raw_spinlock,  &irq->irq_lock) {
+			if (likely(vgic_target_oracle(irq) == vcpu)) {
+				vgic_populate_lr(vcpu, irq, count++);
+			}
 		}
 
-		if (likely(vgic_target_oracle(irq) == vcpu)) {
-			vgic_populate_lr(vcpu, irq, count++);
-
-			if (irq->source)
-				prio = irq->priority;
-		}
-
-		raw_spin_unlock(&irq->irq_lock);
-
-		if (count == kvm_vgic_global_state.nr_lr) {
-			if (!list_is_last(&irq->ap_list,
-					  &vgic_cpu->ap_list_head))
-				vgic_set_underflow(vcpu);
+		if (count == kvm_vgic_global_state.nr_lr)
 			break;
-		}
 	}
 
 	/* Nuke remaining LRs */
-	for (i = count ; i < kvm_vgic_global_state.nr_lr; i++)
+	for (int i = count ; i < kvm_vgic_global_state.nr_lr; i++)
 		vgic_clear_lr(vcpu, i);
 
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		vcpu->arch.vgic_cpu.vgic_v2.used_lrs = count;
-	else
+		vgic_v2_configure_hcr(vcpu, &als);
+	} else {
 		vcpu->arch.vgic_cpu.vgic_v3.used_lrs = count;
+		vgic_v3_configure_hcr(vcpu, &als);
+	}
 }
 
 static inline bool can_access_vgic_from_kernel(void)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5b7318ceefbd1..f35410de1457b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -220,6 +220,21 @@ struct its_ite {
 	u32 event_id;
 };
 
+struct ap_list_summary {
+	unsigned int	nr_pend;	/* purely pending, not active */
+	unsigned int	nr_act;		/* active, or active+pending */
+	unsigned int	nr_sgi;		/* any SGI */
+};
+
+#define irqs_outside_lrs(s)						\
+	 (((s)->nr_pend + (s)->nr_act) > kvm_vgic_global_state.nr_lr)
+
+#define irqs_pending_outside_lrs(s)			\
+	((s)->nr_pend > kvm_vgic_global_state.nr_lr)
+
+#define irqs_active_outside_lrs(s)		\
+	((s)->nr_act &&	irqs_outside_lrs(s))
+
 int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 		       struct vgic_reg_attr *reg_attr);
 int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
@@ -246,7 +261,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
-void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu, struct ap_list_summary *als);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
@@ -286,7 +301,7 @@ static inline void vgic_get_irq_ref(struct vgic_irq *irq)
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
-void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu, struct ap_list_summary *als);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-- 
2.47.3


