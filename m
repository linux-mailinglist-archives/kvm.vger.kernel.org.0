Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534E62751A5
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 08:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIWGgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 02:36:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42828 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbgIWGgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 02:36:45 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0E9B157AA3323F5A97F2;
        Wed, 23 Sep 2020 14:36:41 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.62) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 23 Sep 2020 14:36:33 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [PATCH] irqchip/gic-v4.1: Optimize the wait for the completion of the analysis of the VPT
Date:   Wed, 23 Sep 2020 14:35:43 +0800
Message-ID: <20200923063543.1920-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.186.62]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right after a vPE is made resident, the code starts polling the
GICR_VPENDBASER.Dirty bit until it becomes 0, where the delay_us
is set to 10. But in our measurement, it takes only hundreds of
nanoseconds, or 1~2 microseconds, to finish parsing the VPT in most
cases. And we also measured the time from vcpu_load() (include it)
to __guest_enter() on Kunpeng 920. On average, it takes 2.55 microseconds
(not first run && the VPT is empty). So 10 microseconds delay might
really hurt performance.

To avoid this, we can set the delay_us to 1, which is more appropriate
in this situation and universal. Besides, we can delay the execution
of its_wait_vpt_parse_complete() (call it from kvm_vgic_flush_hwstate()
corresponding to vPE resident), giving the GIC a chance to work in
parallel with the CPU on the entry path.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c      | 18 ++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         |  2 ++
 drivers/irqchip/irq-gic-v3-its.c   | 14 +++++++++++---
 drivers/irqchip/irq-gic-v4.c       | 11 +++++++++++
 include/kvm/arm_vgic.h             |  3 +++
 include/linux/irqchip/arm-gic-v4.h |  4 ++++
 6 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index b5fa73c9fd35..1d5d2d6894d3 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -353,6 +353,24 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+void vgic_v4_wait_vpt(struct kvm_vcpu *vcpu)
+{
+	struct its_vpe *vpe;
+
+	if (kvm_vgic_global_state.type == VGIC_V2 || !vgic_supports_direct_msis(vcpu->kvm))
+		return;
+
+	vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+
+	if (vpe->vpt_ready)
+		return;
+
+	if (its_wait_vpt(vpe))
+		return;
+
+	vpe->vpt_ready = true;
+}
+
 static struct vgic_its *vgic_get_its(struct kvm *kvm,
 				     struct kvm_kernel_irq_routing_entry *irq_entry)
 {
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c3643b7f101b..ed810a80cda2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -915,6 +915,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
+
+	vgic_v4_wait_vpt(vcpu);
 }
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 548de7538632..b7cbc9bcab9d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3803,7 +3803,7 @@ static void its_wait_vpt_parse_complete(void)
 	WARN_ON_ONCE(readq_relaxed_poll_timeout_atomic(vlpi_base + GICR_VPENDBASER,
 						       val,
 						       !(val & GICR_VPENDBASER_Dirty),
-						       10, 500));
+						       1, 500));
 }
 
 static void its_vpe_schedule(struct its_vpe *vpe)
@@ -3837,7 +3837,7 @@ static void its_vpe_schedule(struct its_vpe *vpe)
 	val |= GICR_VPENDBASER_Valid;
 	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
 
-	its_wait_vpt_parse_complete();
+	vpe->vpt_ready = false;
 }
 
 static void its_vpe_deschedule(struct its_vpe *vpe)
@@ -3881,6 +3881,10 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 		its_vpe_schedule(vpe);
 		return 0;
 
+	case WAIT_VPT:
+		its_wait_vpt_parse_complete();
+		return 0;
+
 	case DESCHEDULE_VPE:
 		its_vpe_deschedule(vpe);
 		return 0;
@@ -4047,7 +4051,7 @@ static void its_vpe_4_1_schedule(struct its_vpe *vpe,
 
 	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
 
-	its_wait_vpt_parse_complete();
+	vpe->vpt_ready = false;
 }
 
 static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
@@ -4118,6 +4122,10 @@ static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 		its_vpe_4_1_schedule(vpe, info);
 		return 0;
 
+	case WAIT_VPT:
+		its_wait_vpt_parse_complete();
+		return 0;
+
 	case DESCHEDULE_VPE:
 		its_vpe_4_1_deschedule(vpe, info);
 		return 0;
diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 0c18714ae13e..36be42569872 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -258,6 +258,17 @@ int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en)
 	return ret;
 }
 
+int its_wait_vpt(struct its_vpe *vpe)
+{
+	struct its_cmd_info info = { };
+
+	WARN_ON(preemptible());
+
+	info.cmd_type = WAIT_VPT;
+
+	return its_send_vpe_cmd(vpe, &info);
+}
+
 int its_invall_vpe(struct its_vpe *vpe)
 {
 	struct its_cmd_info info = {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a8d8fdcd3723..b55a835d28a8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -402,6 +402,9 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 				 struct kvm_kernel_irq_routing_entry *irq_entry);
 
 int vgic_v4_load(struct kvm_vcpu *vcpu);
+
+void vgic_v4_wait_vpt(struct kvm_vcpu *vcpu);
+
 int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
 
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 6976b8331b60..68ac2b7b9309 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -75,6 +75,8 @@ struct its_vpe {
 	u16			vpe_id;
 	/* Pending VLPIs on schedule out? */
 	bool			pending_last;
+	/* VPT parse complete */
+	bool			vpt_ready;
 };
 
 /*
@@ -103,6 +105,7 @@ enum its_vcpu_info_cmd_type {
 	PROP_UPDATE_VLPI,
 	PROP_UPDATE_AND_INV_VLPI,
 	SCHEDULE_VPE,
+	WAIT_VPT,
 	DESCHEDULE_VPE,
 	INVALL_VPE,
 	PROP_UPDATE_VSGI,
@@ -128,6 +131,7 @@ struct its_cmd_info {
 int its_alloc_vcpu_irqs(struct its_vm *vm);
 void its_free_vcpu_irqs(struct its_vm *vm);
 int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en);
+int its_wait_vpt(struct its_vpe *vpe);
 int its_make_vpe_non_resident(struct its_vpe *vpe, bool db);
 int its_invall_vpe(struct its_vpe *vpe);
 int its_map_vlpi(int irq, struct its_vlpi_map *map);
-- 
2.19.1

