Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233D154E576
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377248AbiFPOzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 10:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243496AbiFPOzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 10:55:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 808882F00D
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 07:55:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EB1C2B;
        Thu, 16 Jun 2022 07:55:32 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 036283F7F5;
        Thu, 16 Jun 2022 07:55:30 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool] arm: gic: fdt: fix PPI CPU mask calculation
Date:   Thu, 16 Jun 2022 15:55:26 +0100
Message-Id: <20220616145526.3337196-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GICv2 DT binding describes the third cell in each interrupt
descriptor as holding the trigger type, but also the CPU mask that this
IRQ applies to, in bits [15:8]. However this is not the case for GICv3,
where we don't use a CPU mask in the third cell: a simple mask wouldn't
fit for the many more supported cores anyway.

At the moment we fill this CPU mask field regardless of the GIC type,
for the PMU and arch timer DT nodes. This is not only the wrong thing to
do in case of a GICv3, but also triggers UBSAN splats when using more
than 30 cores, as we do shifting beyond what a u32 can hold:
$ lkvm run -k Image -c 31 --pmu
arm/timer.c:13:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
arm/timer.c:13:38: runtime error: signed integer overflow: -2147483648 - 1 cannot be represented in type 'int'
arm/timer.c:13:43: runtime error: left shift of 2147483647 by 8 places cannot be represented in type 'int'
arm/aarch64/pmu.c:202:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
arm/aarch64/pmu.c:202:38: runtime error: signed integer overflow: -2147483648 - 1 cannot be represented in type 'int'
arm/aarch64/pmu.c:202:43: runtime error: left shift of 2147483647 by 8 places cannot be represented in type 'int'

Fix that by adding a function that creates the mask by looking at the
GIC type first, and returning zero when a GICv3 is used. Also we
explicitly check for the CPU limit again, even though this would be
done before already, when we try to create a GICv2 VM with more than 8
cores.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch64/pmu.c            |  3 +--
 arm/gic.c                    | 13 +++++++++++++
 arm/include/arm-common/gic.h |  1 +
 arm/timer.c                  |  4 +---
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arm/aarch64/pmu.c b/arm/aarch64/pmu.c
index 5f189b32..5ed4979a 100644
--- a/arm/aarch64/pmu.c
+++ b/arm/aarch64/pmu.c
@@ -199,8 +199,7 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	int pmu_id = -ENXIO;
 	int i;
 
-	u32 cpu_mask = (((1 << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT) \
-		       & GIC_FDT_IRQ_PPI_CPU_MASK;
+	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
 	u32 irq_prop[] = {
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
 		cpu_to_fdt32(irq - 16),
diff --git a/arm/gic.c b/arm/gic.c
index 26be4b4c..a223a72c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -399,6 +399,19 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 	_FDT(fdt_end_node(fdt));
 }
 
+u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
+{
+	/* Only for GICv2 */
+	if (kvm->cfg.arch.irqchip == IRQCHIP_GICV3 ||
+	    kvm->cfg.arch.irqchip == IRQCHIP_GICV3_ITS)
+		return 0;
+
+	if (kvm->nrcpus > 8)
+		return GIC_FDT_IRQ_PPI_CPU_MASK;
+
+	return ((1U << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT;
+}
+
 #define KVM_IRQCHIP_IRQ(x) (KVM_ARM_IRQ_TYPE_SPI << KVM_ARM_IRQ_TYPE_SHIFT) |\
 			   ((x) & KVM_ARM_IRQ_NUM_MASK)
 
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index ec9cf31a..ad8bcbf2 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -37,6 +37,7 @@ int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
 void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
+u32 gic__get_fdt_irq_cpumask(struct kvm *kvm);
 
 int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
 		   int resample_fd);
diff --git a/arm/timer.c b/arm/timer.c
index 71bfe8d4..6acc50ef 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -9,9 +9,7 @@
 void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
 {
 	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
-
-	u32 cpu_mask = (((1 << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT) \
-		       & GIC_FDT_IRQ_PPI_CPU_MASK;
+	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
 	u32 irq_prop[] = {
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
 		cpu_to_fdt32(irqs[0]),
-- 
2.25.1

