Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2618D7E8
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 19:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgCTSwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 14:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbgCTSvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 14:51:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D148020788;
        Fri, 20 Mar 2020 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584730270;
        bh=AB4UOyZ8oyBskvWThVKVaY0WT/9377ee2YYUA4RUI48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztgpg6m4VjCacoZKs9ZM2B4kr9TIgGgdS2xRPwc5sMSchwghyi+PtQI4d1S+/y5gC
         gu78UNrQ3Hw7NH9MiJSkjo9ZrMvDa/QYLFX6ZSwY3OHLJ0mLCqQDGTOD9zKRQmmh9C
         unF3M/GywPIRPiiS2CR5FjGSB6nr8d/AfO177sNM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFMK2-00EKAx-EW; Fri, 20 Mar 2020 18:24:42 +0000
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
Subject: [PATCH v6 12/23] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI callbacks
Date:   Fri, 20 Mar 2020 18:23:55 +0000
Message-Id: <20200320182406.23465-13-maz@kernel.org>
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

Just like for vLPIs, there is some configuration information that cannot
be directly communicated through the normal irqchip API, and we have to
use our good old friend set_vcpu_affinity as a side-band communication
mechanism.

This is used to configure group and priority for a given vSGI.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-13-maz@kernel.org
---
 drivers/irqchip/irq-gic-v3-its.c   | 18 ++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  5 +++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ce11cba09d4d..15250faa9ef7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4047,6 +4047,23 @@ static int its_sgi_get_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	struct its_cmd_info *info = vcpu_info;
+
+	switch (info->cmd_type) {
+	case PROP_UPDATE_SGI:
+		vpe->sgi_config[d->hwirq].priority = info->priority;
+		vpe->sgi_config[d->hwirq].group = info->group;
+		its_configure_sgi(d, false);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct irq_chip its_sgi_irq_chip = {
 	.name			= "GICv4.1-sgi",
 	.irq_mask		= its_sgi_mask_irq,
@@ -4054,6 +4071,7 @@ static struct irq_chip its_sgi_irq_chip = {
 	.irq_set_affinity	= its_sgi_set_affinity,
 	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
 	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
+	.irq_set_vcpu_affinity	= its_sgi_set_vcpu_affinity,
 };
 
 static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 44e8c19e3d56..b4dbf899460b 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -103,6 +103,7 @@ enum its_vcpu_info_cmd_type {
 	SCHEDULE_VPE,
 	DESCHEDULE_VPE,
 	INVALL_VPE,
+	PROP_UPDATE_SGI,
 };
 
 struct its_cmd_info {
@@ -115,6 +116,10 @@ struct its_cmd_info {
 			bool		g0en;
 			bool		g1en;
 		};
+		struct {
+			u8		priority;
+			bool		group;
+		};
 	};
 };
 
-- 
2.20.1

