Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D680305B12
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhA0MSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:18:14 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11519 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbhA0MPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 07:15:02 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQjDF3lVtzjDSK;
        Wed, 27 Jan 2021 20:13:01 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 27 Jan 2021 20:14:07 +0800
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
Subject: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state to physical side
Date:   Wed, 27 Jan 2021 20:13:36 +0800
Message-ID: <20210127121337.1092-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210127121337.1092-1-lushenming@huawei.com>
References: <20210127121337.1092-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.186.182]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

When setting the forwarding path of a VLPI (switch to the HW mode),
we could also transfer the pending state from irq->pending_latch to
VPT (especially in migration, the pending states of VLPIs are restored
into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
a VLPI to pending.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ac029ba3d337..a3542af6f04a 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -449,6 +449,20 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	irq->host_irq	= virq;
 	atomic_inc(&map.vpe->vlpi_count);
 
+	/* Transfer pending state */
+	if (irq->pending_latch) {
+		ret = irq_set_irqchip_state(irq->host_irq,
+					    IRQCHIP_STATE_PENDING,
+					    irq->pending_latch);
+		WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
+
+		/*
+		 * Let it be pruned from ap_list later and don't bother
+		 * the List Register.
+		 */
+		irq->pending_latch = false;
+	}
+
 out:
 	mutex_unlock(&its->its_lock);
 	return ret;
-- 
2.19.1

