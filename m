Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469312C706F
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 19:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgK1R7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 12:59:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8526 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733144AbgK1R4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 12:56:39 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cjtsh1WnPzhj5H;
        Sat, 28 Nov 2020 22:19:20 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 22:19:33 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Jason Cooper" <jason@lakedaemon.net>,
        <linux-kernel@vger.kernel.org>,
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
Subject: [PATCH v2 1/2] irqchip/gic-v4.1: Reduce the delay time of the poll on the GICR_VPENDBASER.Dirty bit
Date:   Sat, 28 Nov 2020 22:18:56 +0800
Message-ID: <20201128141857.983-2-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20201128141857.983-1-lushenming@huawei.com>
References: <20201128141857.983-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 10 delay_us of the poll on the GICR_VPENDBASER.Dirty bit is too
high, which might greatly affect the total scheduling latency of a
vCPU in our measurement. So we reduce it to 1 to lessen the impact.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0fec31931e11..22f427135c6b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3809,7 +3809,7 @@ static void its_wait_vpt_parse_complete(void)
 	WARN_ON_ONCE(readq_relaxed_poll_timeout_atomic(vlpi_base + GICR_VPENDBASER,
 						       val,
 						       !(val & GICR_VPENDBASER_Dirty),
-						       10, 500));
+						       1, 500));
 }
 
 static void its_vpe_schedule(struct its_vpe *vpe)
-- 
2.23.0

