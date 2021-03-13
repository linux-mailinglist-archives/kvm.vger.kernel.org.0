Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A7E339CFE
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 09:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhCMIj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 03:39:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13162 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhCMIjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 03:39:47 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DyGJk0R9YzmWBR;
        Sat, 13 Mar 2021 16:37:26 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 13 Mar 2021 16:39:38 +0800
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
Subject: [PATCH v4 1/6] irqchip/gic-v3-its: Add a cache invalidation right after vPE unmapping
Date:   Sat, 13 Mar 2021 16:38:55 +0800
Message-ID: <20210313083900.234-2-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210313083900.234-1-lushenming@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Since there may be a direct read from the CPU side to the VPT after
unmapping the vPE, we add a cache coherency maintenance at the end
of its_vpe_irq_domain_deactivate() to ensure the validity of the VPT
read later.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ed46e6057e33..4eb907f65bd0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4554,6 +4554,15 @@ static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
 
 		its_send_vmapp(its, vpe, false);
 	}
+
+	/*
+	 * There may be a direct read to the VPT after unmapping the
+	 * vPE, to guarantee the validity of this, we make the VPT
+	 * memory coherent with the CPU caches here.
+	 */
+	if (find_4_1_its() && !atomic_read(&vpe->vmapp_count))
+		gic_flush_dcache_to_poc(page_address(vpe->vpt_page),
+					LPI_PENDBASE_SZ);
 }
 
 static const struct irq_domain_ops its_vpe_domain_ops = {
-- 
2.19.1

