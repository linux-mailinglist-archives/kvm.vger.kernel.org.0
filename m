Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E29133EE14
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCQKHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:07:45 -0400
Received: from foss.arm.com ([217.140.110.172]:56178 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhCQKH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 06:07:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5799101E;
        Wed, 17 Mar 2021 03:07:25 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EEA63F70D;
        Wed, 17 Mar 2021 03:07:25 -0700 (PDT)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 1/1] irqchip/gic-v4.1: Disable vSGI upon (GIC CPUIF < v4.1) detection
Date:   Wed, 17 Mar 2021 10:07:19 +0000
Message-Id: <20210317100719.3331-2-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20210317100719.3331-1-lorenzo.pieralisi@arm.com>
References: <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
 <20210317100719.3331-1-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GIC CPU interfaces versions predating GIC v4.1 were not built to
accommodate vINTID within the vSGI range; as reported in the GIC
specifications (8.2 "Changes to the CPU interface"), it is
CONSTRAINED UNPREDICTABLE to deliver a vSGI to a PE with
ID_AA64PFR0_EL1.GIC < b0011.

Check the GIC CPUIF version by reading the SYS_ID_AA64_PFR0_EL1.

Disable vSGIs if a CPUIF version < 4.1 is detected to prevent using
vSGIs on systems where they may misbehave.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  4 ++--
 drivers/irqchip/irq-gic-v4.c       | 27 +++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 15a6c98ee92f..2f1b156021a6 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -86,7 +86,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case GICD_TYPER2:
-		if (kvm_vgic_global_state.has_gicv4_1)
+		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
 			value = GICD_TYPER2_nASSGIcap;
 		break;
 	case GICD_IIDR:
@@ -119,7 +119,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1)
+		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 5d1dc9915272..4ea71b28f9f5 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -87,17 +87,40 @@ static struct irq_domain *gic_domain;
 static const struct irq_domain_ops *vpe_domain_ops;
 static const struct irq_domain_ops *sgi_domain_ops;
 
+#ifdef CONFIG_ARM64
+#include <asm/cpufeature.h>
+
+bool gic_cpuif_has_vsgi(void)
+{
+	unsigned long fld, reg = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	fld = cpuid_feature_extract_unsigned_field(reg, ID_AA64PFR0_GIC_SHIFT);
+
+	return fld >= 0x3;
+}
+#else
+bool gic_cpuif_has_vsgi(void)
+{
+	return false;
+}
+#endif
+
 static bool has_v4_1(void)
 {
 	return !!sgi_domain_ops;
 }
 
+static bool has_v4_1_sgi(void)
+{
+	return has_v4_1() && gic_cpuif_has_vsgi();
+}
+
 static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
 {
 	char *name;
 	int sgi_base;
 
-	if (!has_v4_1())
+	if (!has_v4_1_sgi())
 		return 0;
 
 	name = kasprintf(GFP_KERNEL, "GICv4-sgi-%d", task_pid_nr(current));
@@ -182,7 +205,7 @@ static void its_free_sgi_irqs(struct its_vm *vm)
 {
 	int i;
 
-	if (!has_v4_1())
+	if (!has_v4_1_sgi())
 		return;
 
 	for (i = 0; i < vm->nr_vpes; i++) {
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 943c3411ca10..2c63375bbd43 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -145,4 +145,6 @@ int its_init_v4(struct irq_domain *domain,
 		const struct irq_domain_ops *vpe_ops,
 		const struct irq_domain_ops *sgi_ops);
 
+bool gic_cpuif_has_vsgi(void);
+
 #endif
-- 
2.29.1

