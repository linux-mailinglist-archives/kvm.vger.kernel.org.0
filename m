Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A877B18D7B8
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgCTSvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 14:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbgCTSvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 14:51:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E3E20784;
        Fri, 20 Mar 2020 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584730268;
        bh=pNoFPXIj2ETz1tZjIWZDHdqC7T92YYDtCjMix50dI7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xtjCKHEKkLg+Cymtu4RaWDUU7WMF4faohptSeA/ejHcCH4xTJf8f29XVDOVWQA0Py
         HIzTIgT4u0vhbkoMDI9XezWaGJ1bKkV0aTM0YlndE12/agDBK2nT1gW/MaCNu4LLJv
         DOIVO+7XUflo0ikf2b1huVtpRmiMjk0FM6B1PiWQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFMK6-00EKAx-2I; Fri, 20 Mar 2020 18:24:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 16/23] irqchip/gic-v4.1: Eagerly vmap vPEs
Date:   Fri, 20 Mar 2020 18:23:59 +0000
Message-Id: <20200320182406.23465-17-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320182406.23465-1-maz@kernel.org>
References: <20200320182406.23465-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have HW-accelerated SGIs being delivered to VPEs, it
becomes required to map the VPEs on all ITSs instead of relying
on the lazy approach that we would use when using the ITS-list
mechanism.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20200304203330.4967-17-maz@kernel.org
---
 drivers/irqchip/irq-gic-v3-its.c | 52 ++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 7ad46ff5f0b9..039a1429da07 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -189,6 +189,15 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+/*
+ * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
+ * always have vSGIs mapped.
+ */
+static bool require_its_list_vmovp(struct its_vm *vm, struct its_node *its)
+{
+	return (gic_rdists->has_rvpeid || vm->vlpi_count[its->list_nr]);
+}
+
 static u16 get_its_list(struct its_vm *vm)
 {
 	struct its_node *its;
@@ -198,7 +207,7 @@ static u16 get_its_list(struct its_vm *vm)
 		if (!is_v4(its))
 			continue;
 
-		if (vm->vlpi_count[its->list_nr])
+		if (require_its_list_vmovp(vm, its))
 			__set_bit(its->list_nr, &its_list);
 	}
 
@@ -1295,7 +1304,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
 		if (!is_v4(its))
 			continue;
 
-		if (!vpe->its_vm->vlpi_count[its->list_nr])
+		if (!require_its_list_vmovp(vpe->its_vm, its))
 			continue;
 
 		desc.its_vmovp_cmd.col = &its->collections[col_id];
@@ -1586,12 +1595,31 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+/*
+ * Two favourable cases:
+ *
+ * (a) Either we have a GICv4.1, and all vPEs have to be mapped at all times
+ *     for vSGI delivery
+ *
+ * (b) Or the ITSs do not use a list map, meaning that VMOVP is cheap enough
+ *     and we're better off mapping all VPEs always
+ *
+ * If neither (a) nor (b) is true, then we map vPEs on demand.
+ *
+ */
+static bool gic_requires_eager_mapping(void)
+{
+	if (!its_list_map || gic_rdists->has_rvpeid)
+		return true;
+
+	return false;
+}
+
 static void its_map_vm(struct its_node *its, struct its_vm *vm)
 {
 	unsigned long flags;
 
-	/* Not using the ITS list? Everything is always mapped. */
-	if (!its_list_map)
+	if (gic_requires_eager_mapping())
 		return;
 
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
@@ -1625,7 +1653,7 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
 	unsigned long flags;
 
 	/* Not using the ITS list? Everything is always mapped. */
-	if (!its_list_map)
+	if (gic_requires_eager_mapping())
 		return;
 
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
@@ -4282,8 +4310,12 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
 	struct its_node *its;
 
-	/* If we use the list map, we issue VMAPP on demand... */
-	if (its_list_map)
+	/*
+	 * If we use the list map, we issue VMAPP on demand... Unless
+	 * we're on a GICv4.1 and we eagerly map the VPE on all ITSs
+	 * so that VSGIs can work.
+	 */
+	if (!gic_requires_eager_mapping())
 		return 0;
 
 	/* Map the VPE to the first possible CPU */
@@ -4309,10 +4341,10 @@ static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
 	struct its_node *its;
 
 	/*
-	 * If we use the list map, we unmap the VPE once no VLPIs are
-	 * associated with the VM.
+	 * If we use the list map on GICv4.0, we unmap the VPE once no
+	 * VLPIs are associated with the VM.
 	 */
-	if (its_list_map)
+	if (!gic_requires_eager_mapping())
 		return;
 
 	list_for_each_entry(its, &its_nodes, entry) {
-- 
2.20.1

