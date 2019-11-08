Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E6BF52F5
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 18:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbfKHRuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 12:50:04 -0500
Received: from foss.arm.com ([217.140.110.172]:47752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731008AbfKHRuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 12:50:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4DDDAB6;
        Fri,  8 Nov 2019 09:50:03 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76D1F3F719;
        Fri,  8 Nov 2019 09:50:02 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 3/3] kvm: arm: VGIC: Enable proper Group0 handling
Date:   Fri,  8 Nov 2019 17:49:52 +0000
Message-Id: <20191108174952.740-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108174952.740-1-andre.przywara@arm.com>
References: <20191108174952.740-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that our VGIC emulation can properly deal with two separate
interrupt groups and their enable bits, we can allow a guest to control
the Group0 enable bit in the distributor.

When evaluating the state of an interrupt, we now take its individual
group enable bit into account, and drop the global "distributor
disabled" notion when checking for VCPUs with a pending interrupt.

This allows the guest to control both groups independently.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 28d9ff282017..ed3a10b9ea93 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -203,8 +203,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
 
 static bool vgic_irq_is_grp_enabled(struct kvm *kvm, struct vgic_irq *irq)
 {
-	/* Placeholder implementation until we properly support Group0. */
-	return kvm->arch.vgic.groups_enable;
+	return vgic_dist_group_enabled(kvm, irq->group);
 }
 
 /**
@@ -320,15 +319,6 @@ int vgic_dist_enable_group(struct kvm *kvm, int group, bool status)
 	if (new_bit == was_enabled)
 		return 0;
 
-	/* Group 0 on GICv3 and Group 1 on GICv2 are ignored for now. */
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		if (group == GIC_GROUP0)
-			return 0;
-	} else {
-		if (group == GIC_GROUP1)
-			return 0;
-	}
-
 	dist->groups_enable &= ~group_mask;
 	dist->groups_enable |= new_bit;
 	if (new_bit > was_enabled)
@@ -435,15 +425,6 @@ bool vgic_dist_group_enabled(struct kvm *kvm, int group)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	/* Group 0 on GICv3 and Group 1 on GICv2 are ignored for now. */
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		if (group == GIC_GROUP0)
-			return false;
-	} else {
-		if (group == GIC_GROUP1)
-			return false;
-	}
-
 	return dist->groups_enable & (1U << group);
 }
 
@@ -1093,9 +1074,6 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
 
-	if (!vcpu->kvm->arch.vgic.groups_enable)
-		return false;
-
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
 		return true;
 
-- 
2.17.1

