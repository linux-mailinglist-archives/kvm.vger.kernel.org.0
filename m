Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B93971AA
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhFAKmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 06:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233422AbhFAKlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 06:41:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4D8613AF;
        Tue,  1 Jun 2021 10:40:14 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo1oi-004nNs-JJ; Tue, 01 Jun 2021 11:40:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v4 3/9] KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt masking
Date:   Tue,  1 Jun 2021 11:39:59 +0100
Message-Id: <20210601104005.81332-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601104005.81332-1-maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As it turns out, not all the interrupt controllers are able to
expose a vGIC maintenance interrupt that can be independently
enabled/disabled.

And to be fair, it doesn't really matter as all we require is
for the interrupt to kick us out of guest mode out way or another.

To that effect, add gic_kvm_info.no_maint_irq_mask for an interrupt
controller to advertise the lack of masking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c       | 8 +++++++-
 include/linux/irqchip/arm-vgic-info.h | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 2fdb65529594..6752d084934d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -519,12 +519,15 @@ void kvm_vgic_init_cpu_hardware(void)
  */
 int kvm_vgic_hyp_init(void)
 {
+	bool has_mask;
 	int ret;
 
 	if (!gic_kvm_info)
 		return -ENODEV;
 
-	if (!gic_kvm_info->maint_irq) {
+	has_mask = !gic_kvm_info->no_maint_irq_mask;
+
+	if (has_mask && !gic_kvm_info->maint_irq) {
 		kvm_err("No vgic maintenance irq\n");
 		return -ENXIO;
 	}
@@ -552,6 +555,9 @@ int kvm_vgic_hyp_init(void)
 	if (ret)
 		return ret;
 
+	if (!has_mask)
+		return 0;
+
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
 				 vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
index a25d4da5697d..7c0d08ebb82c 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -24,6 +24,8 @@ struct gic_kvm_info {
 	struct resource vcpu;
 	/* Interrupt number */
 	unsigned int	maint_irq;
+	/* No interrupt mask, no need to use the above field */
+	bool		no_maint_irq_mask;
 	/* Virtual control interface */
 	struct resource vctrl;
 	/* vlpi support */
-- 
2.30.2

