Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E97E8736E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405922AbfHIHtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:49:07 -0400
Received: from foss.arm.com ([217.140.110.172]:42812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405811AbfHIHtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:49:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DDA3344;
        Fri,  9 Aug 2019 00:49:06 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D509C3F706;
        Fri,  9 Aug 2019 00:49:04 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 4/4] KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable
Date:   Fri,  9 Aug 2019 08:48:32 +0100
Message-Id: <20190809074832.13283-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809074832.13283-1-maz@kernel.org>
References: <20190809074832.13283-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

A HW mapped level sensitive interrupt asserted by a device will not be put
into the ap_list if it is disabled at the VGIC level. When it is enabled
again, it will be inserted into the ap_list and written to a list register
on guest entry regardless of the state of the device.

We could argue that this can also happen on real hardware, when the command
to enable the interrupt reached the GIC before the device had the chance to
de-assert the interrupt signal; however, we emulate the distributor and
redistributors in software and we can do better than that.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3ba7278fb533..44efc2ff863f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -113,6 +113,22 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		if (vgic_irq_is_mapped_level(irq)) {
+			bool was_high = irq->line_level;
+
+			/*
+			 * We need to update the state of the interrupt because
+			 * the guest might have changed the state of the device
+			 * while the interrupt was disabled at the VGIC level.
+			 */
+			irq->line_level = vgic_get_phys_line_level(irq);
+			/*
+			 * Deactivate the physical interrupt so the GIC will let
+			 * us know when it is asserted again.
+			 */
+			if (!irq->active && was_high && !irq->line_level)
+				vgic_irq_set_phys_active(irq, false);
+		}
 		irq->enabled = true;
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
-- 
2.20.1

