Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F73205215
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 14:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbgFWMMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 08:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732436AbgFWMMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 08:12:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745B420707;
        Tue, 23 Jun 2020 12:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592914342;
        bh=82FEL/lqihaAkT9TFcf9PCxFsGrapDUAVvxVatgi5Vo=;
        h=From:To:Cc:Subject:Date:From;
        b=pD87Q8rJB6cjNx4jAe7RfbqAjaHX3486yTR/IyiwU9rVik33STPz3KTZf1mEdrJMm
         MkYRT1QLW4gAG6Coup+KXL+blU0reYnw21TSoS6DYNEIXFu/NM1J+y44m6J6DkXhxG
         QbxgCa5SjpPW/IVpnkfMwAytwNhpiO+WxlwCPa5Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnhmm-005gBg-Rs; Tue, 23 Jun 2020 13:12:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell
Date:   Tue, 23 Jun 2020 13:12:01 +0100
Message-Id: <20200623121201.362532-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When making a vPE non-resident because it has hit a blocking WFI,
the doorbell can fire at any time after the write to the RD.
Crucially, it can fire right between the write to GICR_VPENDBASER
and the write to the pending_last field in the its_vpe structure.

This means that we would overwrite pending_last with stale data,
and potentially not wakeup until some unrelated event (such as
a timer interrupt) puts the vPE back on the CPU.

GICv4 isn't affected by this as we actively mask the doorbell on
entering the guest, while GICv4.1 automatically manages doorbell
delivery without any hypervisor-driven masking.

Use the vpe_lock to synchronize such update, which solves the
problem altogether.

Fixes: ae699ad348cdc ("irqchip/gic-v4.1: Move doorbell management to the GICv4 abstraction layer")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v4.c    | 8 ++++++++
 drivers/irqchip/irq-gic-v3-its.c | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 27ac833e5ec7..b5fa73c9fd35 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -90,7 +90,15 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 	    !irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
 		disable_irq_nosync(irq);
 
+	/*
+	 * The v4.1 doorbell can fire concurrently with the vPE being
+	 * made non-resident. Ensure we only update pending_last
+	 * *after* the non-residency sequence has completed.
+	 */
+	raw_spin_lock(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vpe_lock);
 	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
+	raw_spin_unlock(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vpe_lock);
+
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 	kvm_vcpu_kick(vcpu);
 
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index cd685f521c77..205f69592471 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4054,16 +4054,24 @@ static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
 	u64 val;
 
 	if (info->req_db) {
+		unsigned long flags;
+
 		/*
 		 * vPE is going to block: make the vPE non-resident with
 		 * PendingLast clear and DB set. The GIC guarantees that if
 		 * we read-back PendingLast clear, then a doorbell will be
 		 * delivered when an interrupt comes.
+		 *
+		 * Note the locking to deal with the concurrent update of
+		 * pending_last from the doorbell interrupt handler that can
+		 * run concurrently.
 		 */
+		raw_spin_lock_irqsave(&vpe->vpe_lock, flags);
 		val = its_clear_vpend_valid(vlpi_base,
 					    GICR_VPENDBASER_PendingLast,
 					    GICR_VPENDBASER_4_1_DB);
 		vpe->pending_last = !!(val & GICR_VPENDBASER_PendingLast);
+		raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
 	} else {
 		/*
 		 * We're not blocking, so just make the vPE non-resident
-- 
2.27.0

