Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9318D6D7
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 19:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgCTSYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 14:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbgCTSYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 14:24:40 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5777D2078B;
        Fri, 20 Mar 2020 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584728678;
        bh=vuPZljwBteLjDK5eXe0onSQ1DnagyIIgkFOp39/Z3Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmPRl/+aHJJ/Sk+vWKTENNuV5fOwYi4zScQgJO6eRt6fGpV61SxzSJFHYddJ5hME8
         +0tKNduozV/rXDtW30k/7GQeuZ6ChCeAwQopXGO3SuS8LBQfxS8Ogy3XSqHjTZcqqF
         ddeEooINsfqn9EyIcIByNdG6zJEjRpw9tbHjFO3U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFMJw-00EKAx-KI; Fri, 20 Mar 2020 18:24:36 +0000
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
Subject: [PATCH v6 05/23] irqchip/gic-v4.1: Ensure mutual exclusion betwen invalidations on the same RD
Date:   Fri, 20 Mar 2020 18:23:48 +0000
Message-Id: <20200320182406.23465-6-maz@kernel.org>
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

The GICv4.1 spec says that it is CONTRAINED UNPREDICTABLE to write to
any of the GICR_INV{LPI,ALL}R registers if GICR_SYNCR.Busy == 1.

To deal with it, we must ensure that only a single invalidation can
happen at a time for a given redistributor. Add a per-RD lock to that
effect and take it around the invalidation/syncr-read to deal with this.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-6-maz@kernel.org
---
 drivers/irqchip/irq-gic-v3-its.c   | 6 ++++++
 drivers/irqchip/irq-gic-v3.c       | 1 +
 include/linux/irqchip/arm-gic-v3.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c84370245bea..fc5788584df7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1373,10 +1373,12 @@ static void direct_lpi_inv(struct irq_data *d)
 
 	/* Target the redistributor this LPI is currently routed to */
 	cpu = irq_to_cpuid_lock(d, &flags);
+	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
 	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
 	gic_write_lpir(val, rdbase + GICR_INVLPIR);
 
 	wait_for_syncr(rdbase);
+	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
 	irq_to_cpuid_unlock(d, flags);
 }
 
@@ -3662,9 +3664,11 @@ static void its_vpe_send_inv(struct irq_data *d)
 		void __iomem *rdbase;
 
 		/* Target the redistributor this VPE is currently known on */
+		raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
 		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
 		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
 		wait_for_syncr(rdbase);
+		raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
 	} else {
 		its_vpe_send_cmd(vpe, its_send_inv);
 	}
@@ -3825,10 +3829,12 @@ static void its_vpe_4_1_invall(struct its_vpe *vpe)
 	val |= FIELD_PREP(GICR_INVALLR_VPEID, vpe->vpe_id);
 
 	/* Target the redistributor this vPE is currently known on */
+	raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
 	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
 	gic_write_lpir(val, rdbase + GICR_INVALLR);
 
 	wait_for_syncr(rdbase);
+	raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
 }
 
 static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index b6b0f86584d6..0f716c2647fd 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -834,6 +834,7 @@ static int __gic_populate_rdist(struct redist_region *region, void __iomem *ptr)
 	typer = gic_read_typer(ptr + GICR_TYPER);
 	if ((typer >> 32) == aff) {
 		u64 offset = ptr - region->redist_base;
+		raw_spin_lock_init(&gic_data_rdist()->rd_lock);
 		gic_data_rdist_rd_base() = ptr;
 		gic_data_rdist()->phys_base = region->phys_base + offset;
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c29a02678a6f..b28acfa71f82 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -652,6 +652,7 @@
 
 struct rdists {
 	struct {
+		raw_spinlock_t	rd_lock;
 		void __iomem	*rd_base;
 		struct page	*pend_page;
 		phys_addr_t	phys_base;
-- 
2.20.1

