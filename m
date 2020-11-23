Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF382C0059
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 07:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgKWGzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 01:55:03 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8014 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbgKWGy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 01:54:59 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CfdDt1sSMzhg2x;
        Mon, 23 Nov 2020 14:54:38 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:46 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state to physical side
Date:   Mon, 23 Nov 2020 14:54:09 +0800
Message-ID: <20201123065410.1915-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20201123065410.1915-1-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

When setting the forwarding path of a VLPI, it is more consistent to
also transfer the pending state from irq->pending_latch to VPT (especially
in migration, the pending states of VLPIs are restored into kvm’s vgic
first). And we currently send "INT+VSYNC" to trigger a VLPI to pending.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index b5fa73c9fd35..cc3ab9cea182 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -418,6 +418,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
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
2.23.0

