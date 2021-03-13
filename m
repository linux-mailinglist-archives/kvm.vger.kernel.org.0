Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D5E339D03
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 09:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhCMIj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 03:39:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13600 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhCMIjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 03:39:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DyGKM5fQYz17KRS;
        Sat, 13 Mar 2021 16:37:59 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 13 Mar 2021 16:39:41 +0800
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
Subject: [PATCH v4 2/6] irqchip/gic-v3-its: Drop the setting of PTZ altogether
Date:   Sat, 13 Mar 2021 16:38:56 +0800
Message-ID: <20210313083900.234-3-lushenming@huawei.com>
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

GICv4.1 gives a way to get the VLPI state, which needs to map the
vPE first, and after the state read, we may remap the vPE back while
the VPT is not empty. So we can't assume that the VPT is empty at
the first map. Besides, the optimization of PTZ is probably limited
since the HW should be fairly efficient to parse the empty VPT. Let's
drop the setting of PTZ altogether.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4eb907f65bd0..c8b5a88ac31c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -794,8 +794,16 @@ static struct its_vpe *its_build_vmapp_cmd(struct its_node *its,
 
 	its_encode_alloc(cmd, alloc);
 
-	/* We can only signal PTZ when alloc==1. Why do we have two bits? */
-	its_encode_ptz(cmd, alloc);
+	/*
+	 * We can only signal PTZ when alloc==1. Why do we have two bits?
+	 * GICv4.1 gives a way to get the VLPI state, which needs the vPE
+	 * to be unmapped first, and in this case, we may remap the vPE
+	 * back while the VPT is not empty. So we can't assume that the
+	 * VPT is empty at the first map. Besides, the optimization of PTZ
+	 * is probably limited since the HW should be fairly efficient to
+	 * parse the empty VPT. Let's drop the setting of PTZ altogether.
+	 */
+	its_encode_ptz(cmd, false);
 	its_encode_vconf_addr(cmd, vconf_addr);
 	its_encode_vmapp_default_db(cmd, desc->its_vmapp_cmd.vpe->vpe_db_lpi);
 
-- 
2.19.1

