Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D89272B08
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 11:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfGXJEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 05:04:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2749 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfGXJEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 05:04:47 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 02EDA65D9F3FEEC4FB62;
        Wed, 24 Jul 2019 17:04:46 +0800 (CST)
Received: from localhost (10.177.19.122) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 17:04:42 +0800
From:   Xiangyou Xie <xiexiangyou@huawei.com>
To:     <marc.zyngier@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH 3/3] KVM: arm/arm64: vgic: introduce vgic_cpu pending status and lowest_priority
Date:   Wed, 24 Jul 2019 17:04:37 +0800
Message-ID: <20190724090437.49952-4-xiexiangyou@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
In-Reply-To: <20190724090437.49952-1-xiexiangyou@huawei.com>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During the halt polling process, vgic_cpu->ap_list_lock is frequently
obtained andreleased, (kvm_vcpu_check_block->kvm_arch_vcpu_runnable->
kvm_vgic_vcpu_pending_irq).This action affects the performance of virq
interrupt injection, because vgic_queue_irq_unlock also attempts to get
vgic_cpu->ap_list_lock and add irq to vgic_cpu ap_list.

The irq pending state and the minimum priority introduced by the patch,
kvm_vgic_vcpu_pending_irq do not need to traverse vgic_cpu ap_list, only
the check pending state and priority.

Signed-off-by: Xiangyou Xie <xiexiangyou@huawei.com>
---
 include/kvm/arm_vgic.h   |  5 +++++
 virt/kvm/arm/vgic/vgic.c | 40 ++++++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ce372a0..636db29 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -337,6 +337,11 @@ struct vgic_cpu {
 
 	/* Cache guest interrupt ID bits */
 	u32 num_id_bits;
+
+	/* Minimum of priority in all irqs */
+	u8 lowest_priority;
+	/* Irq pending flag */
+	bool pending;
 };
 
 extern struct static_key_false vgic_v2_cpuif_trap;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index deb8471..767dfe0 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -398,6 +398,12 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 * now in the ap_list.
 	 */
 	vgic_get_irq_kref(irq);
+
+	if (!irq->active) {
+		vcpu->arch.vgic_cpu.pending = true;
+		if (vcpu->arch.vgic_cpu.lowest_priority > irq->priority)
+			vcpu->arch.vgic_cpu.lowest_priority = irq->priority;
+	}
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
@@ -618,6 +624,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 retry:
 	raw_spin_lock(&vgic_cpu->ap_list_lock);
 
+	vgic_cpu->lowest_priority = U8_MAX;
+	vgic_cpu->pending = false;
+
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
 		bool target_vcpu_needs_kick = false;
@@ -649,6 +658,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		}
 
 		if (target_vcpu == vcpu) {
+			if (!irq->active) {
+				vgic_cpu->pending = true;
+				if (vgic_cpu->lowest_priority > irq->priority)
+					vgic_cpu->lowest_priority = irq->priority;
+			}
 			/* We're on the right CPU */
 			raw_spin_unlock(&irq->irq_lock);
 			continue;
@@ -690,6 +704,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 			list_del(&irq->ap_list);
 			irq->vcpu = target_vcpu;
+			if (!irq->active) {
+				new_cpu->pending = true;
+				if (new_cpu->lowest_priority > irq->priority)
+					new_cpu->lowest_priority = irq->priority;
+			}
 			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
 			target_vcpu_needs_kick = true;
 		}
@@ -930,9 +949,6 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_irq *irq;
-	bool pending = false;
-	unsigned long flags;
 	struct vgic_vmcr vmcr;
 
 	if (!vcpu->kvm->arch.vgic.enabled)
@@ -943,22 +959,10 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 
 	vgic_get_vmcr(vcpu, &vmcr);
 
-	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
-
-	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-		raw_spin_lock(&irq->irq_lock);
-		pending = irq_is_pending(irq) && irq->enabled &&
-			  !irq->active &&
-			  irq->priority < vmcr.pmr;
-		raw_spin_unlock(&irq->irq_lock);
-
-		if (pending)
-			break;
-	}
-
-	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+	if (vgic_cpu->pending && vgic_cpu->lowest_priority < vmcr.pmr)
+		return true;
 
-	return pending;
+	return false;
 }
 
 void vgic_kick_vcpus(struct kvm *kvm)
-- 
1.8.3.1


