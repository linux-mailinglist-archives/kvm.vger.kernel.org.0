Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4A1343915
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 07:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhCVGDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 02:03:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14050 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhCVGCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 02:02:40 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3kP41QwnzNq3Y;
        Mon, 22 Mar 2021 14:00:08 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 14:02:31 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>,
        "Will Deacon" <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [PATCH v5 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to physical side
Date:   Mon, 22 Mar 2021 14:01:57 +0800
Message-ID: <20210322060158.1584-6-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210322060158.1584-1-lushenming@huawei.com>
References: <20210322060158.1584-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

When setting the forwarding path of a VLPI (switch to the HW mode),
we can also transfer the pending state from irq->pending_latch to
VPT (especially in migration, the pending states of VLPIs are restored
into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
a VLPI to pending.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ac029ba3d337..c1845d8f5f7e 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -404,6 +404,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	struct vgic_its *its;
 	struct vgic_irq *irq;
 	struct its_vlpi_map map;
+	unsigned long flags;
 	int ret;
 
 	if (!vgic_supports_direct_msis(kvm))
@@ -449,6 +450,24 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	irq->host_irq	= virq;
 	atomic_inc(&map.vpe->vlpi_count);
 
+	/* Transfer pending state */
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (irq->pending_latch) {
+		ret = irq_set_irqchip_state(irq->host_irq,
+					    IRQCHIP_STATE_PENDING,
+					    irq->pending_latch);
+		WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
+
+		/*
+		 * Clear pending_latch and communicate this state
+		 * change via vgic_queue_irq_unlock.
+		 */
+		irq->pending_latch = false;
+		vgic_queue_irq_unlock(kvm, irq, flags);
+	} else {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	}
+
 out:
 	mutex_unlock(&its->its_lock);
 	return ret;
-- 
2.19.1

