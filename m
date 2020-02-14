Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C7715D9FA
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgBNO6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:58:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbgBNO5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:57:50 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F6324693;
        Fri, 14 Feb 2020 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581692269;
        bh=sAvtGM0FsVAKYbwOAWV48kf1eOD+wb7UuRYTXyiFbn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKjh2jVJhMhTBIWomZmEqihulCRjcRJ4E0zSMQczMm6CAgihYyKMnzWVOuixne8G7
         pq7ZUDEwbN0Po5TRraU3ja7L20knaSvClLjqqVFSx3fpunEAvh0kn3Tt5NLma1eTWn
         bVZqCj76l4tLrKkJiGeDsNm7y1i/SZdpnj3g3zPc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j2cPb-0057sw-Q0; Fri, 14 Feb 2020 14:57:47 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 04/20] irqchip/gic-v4.1: Map the ITS SGIR register page
Date:   Fri, 14 Feb 2020 14:57:20 +0000
Message-Id: <20200214145736.18550-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214145736.18550-1-maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One of the new features of GICv4.1 is to allow virtual SGIs to be
directly signaled to a VPE. For that, the ITS has grown a new
64kB page containing only a single register that is used to
signal a SGI to a given VPE.

Add a second mapping covering this new 64kB range, and take this
opportunity to limit the original mapping to 64kB, which is enough
to cover the span of the ITS registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 9a7854416b89..d6201443b406 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -96,6 +96,7 @@ struct its_node {
 	struct mutex		dev_alloc_lock;
 	struct list_head	entry;
 	void __iomem		*base;
+	void __iomem		*sgir_base;
 	phys_addr_t		phys_base;
 	struct its_cmd_block	*cmd_base;
 	struct its_cmd_block	*cmd_write;
@@ -4408,7 +4409,7 @@ static int __init its_probe_one(struct resource *res,
 	struct page *page;
 	int err;
 
-	its_base = ioremap(res->start, resource_size(res));
+	its_base = ioremap(res->start, SZ_64K);
 	if (!its_base) {
 		pr_warn("ITS@%pa: Unable to map ITS registers\n", &res->start);
 		return -ENOMEM;
@@ -4459,6 +4460,13 @@ static int __init its_probe_one(struct resource *res,
 
 		if (is_v4_1(its)) {
 			u32 svpet = FIELD_GET(GITS_TYPER_SVPET, typer);
+
+			its->sgir_base = ioremap(res->start + SZ_128K, SZ_64K);
+			if (!its->sgir_base) {
+				err = -ENOMEM;
+				goto out_free_its;
+			}
+
 			its->mpidr = readl_relaxed(its_base + GITS_MPIDR);
 
 			pr_info("ITS@%pa: Using GICv4.1 mode %08x %08x\n",
@@ -4472,7 +4480,7 @@ static int __init its_probe_one(struct resource *res,
 				get_order(ITS_CMD_QUEUE_SZ));
 	if (!page) {
 		err = -ENOMEM;
-		goto out_free_its;
+		goto out_unmap_sgir;
 	}
 	its->cmd_base = (void *)page_address(page);
 	its->cmd_write = its->cmd_base;
@@ -4539,6 +4547,9 @@ static int __init its_probe_one(struct resource *res,
 	its_free_tables(its);
 out_free_cmd:
 	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
+out_unmap_sgir:
+	if (its->sgir_base)
+		iounmap(its->sgir_base);
 out_free_its:
 	kfree(its);
 out_unmap:
-- 
2.20.1

