Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23584E43E
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfFUJlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:41:08 -0400
Received: from foss.arm.com ([217.140.110.172]:54350 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfFUJkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DB3F1478;
        Fri, 21 Jun 2019 02:40:32 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 286333F246;
        Fri, 21 Jun 2019 02:40:31 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 51/59] KVM: arm64: nv: vgic: Emulate the HW bit in software
Date:   Fri, 21 Jun 2019 10:38:35 +0100
Message-Id: <20190621093843.220980-52-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Should the guest hypervisor use the HW bit in the LRs, we need to
emulate the deactivation from the L2 guest into the L1 distributor
emulation, which is handled by L0.

It's all good fun.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 include/kvm/arm_vgic.h             |  1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c      |  2 +-
 virt/kvm/arm/vgic/vgic-v3-nested.c | 32 ++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c           | 10 ++++++----
 5 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3ebbf307d2e2..f86c396e2c67 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -83,6 +83,8 @@ typeof(orig) * __hyp_text fname(void)					\
 
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
+u64 __hyp_text __gic_v3_get_lr(unsigned int lr);
+
 void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 707fbe627155..17d32c2797c0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -375,6 +375,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index b5d818d8b458..c2e4354416a3 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -27,7 +27,7 @@
 #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
 #define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
 
-static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
+u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
diff --git a/virt/kvm/arm/vgic/vgic-v3-nested.c b/virt/kvm/arm/vgic/vgic-v3-nested.c
index 6fb81dfbb679..c917d49e4a14 100644
--- a/virt/kvm/arm/vgic/vgic-v3-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v3-nested.c
@@ -137,6 +137,38 @@ static void vgic_v3_fixup_shadow_lr_state(struct kvm_vcpu *vcpu)
 	}
 }
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_irq *irq;
+	int i;
+
+	for (i = 0; i < s_cpu_if->used_lrs; i++) {
+		u64 lr = cpu_if->vgic_lr[i];
+		int l1_irq;
+
+		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
+			continue;
+
+		/*
+		 * If we had a HW lr programmed by the guest hypervisor, we
+		 * need to emulate the HW effect between the guest hypervisor
+		 * and the nested guest.
+		 */
+		l1_irq = (lr & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, l1_irq);
+		if (!irq)
+			continue; /* oh well, the guest hyp is broken */
+
+		lr = __gic_v3_get_lr(i);
+		if (!(lr & ICH_LR_STATE))
+			irq->active = false;
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index f32f49b0c803..3dd670166d70 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -872,12 +872,14 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	int used_lrs;
 
-	/* If nesting, this is a load/put affair, not flush/sync. */
-	if (vgic_state_is_nested(vcpu))
-		return;
-
 	WARN_ON(vgic_v4_sync_hwstate(vcpu));
 
+	/* If nesting, emualte the HW effect from L0 to L1 */
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_sync_nested(vcpu);
+		return;
+	}
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
-- 
2.20.1

