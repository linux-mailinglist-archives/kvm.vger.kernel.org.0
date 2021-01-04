Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC172E91A0
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 09:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbhADIRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 03:17:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10104 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbhADIRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 03:17:44 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8T3G2fdKzMF8b;
        Mon,  4 Jan 2021 16:15:54 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 16:16:54 +0800
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
Subject: [RFC PATCH v2 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state to physical side
Date:   Mon, 4 Jan 2021 16:16:12 +0800
Message-ID: <20210104081613.100-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210104081613.100-1-lushenming@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.196]
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
 arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index f211a7c32704..7945d6d09cdd 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -454,6 +454,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	irq->host_irq	= virq;
 	atomic_inc(&map.vpe->vlpi_count);
 
+	/* Transfer pending state */
+	ret = irq_set_irqchip_state(irq->host_irq,
+				    IRQCHIP_STATE_PENDING,
+				    irq->pending_latch);
+	WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
+
+	/*
+	 * Let it be pruned from ap_list later and don't bother
+	 * the List Register.
+	 */
+	irq->pending_latch = false;
+
 out:
 	mutex_unlock(&its->its_lock);
 	return ret;
-- 
2.19.1

