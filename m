Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687DF2DD2B6
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgLQOO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:14:57 -0500
Received: from foss.arm.com ([217.140.110.172]:38412 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgLQOO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 09:14:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 916A51042;
        Thu, 17 Dec 2020 06:14:11 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A34033F66B;
        Thu, 17 Dec 2020 06:14:10 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, eric.auger@redhat.com, yuzenghui@huawei.com
Subject: [kvm-unit-tests PATCH v2 02/12] lib: arm/arm64: gicv2: Add missing barrier when sending IPIs
Date:   Thu, 17 Dec 2020 14:13:50 +0000
Message-Id: <20201217141400.106137-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217141400.106137-1-alexandru.elisei@arm.com>
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GICv2 generates IPIs with a MMIO write to the GICD_SGIR register. A common
pattern for IPI usage is for the IPI receiver to read data written to
memory by the sender. The armv7 and armv8 architectures implement a
weakly-ordered memory model, which means that barriers are required to make
sure that the expected values are observed.

It turns out that because the receiver CPU must observe the write to memory
that generated the IPI when reading the GICC_IAR MMIO register, we only
need to ensure ordering of memory accesses, and not completion. Use a
smp_wmb (DMB ISHST) barrier before sending the IPI.

This also matches what the Linux GICv2 irqchip driver does (more details
in commit 8adbf57fc429 ("irqchip: gic: use dmb ishst instead of dsb when
raising a softirq")).

The gicv2_ipi_send_self() function sends an IPI from a CPU to itself.
The tests that use this function rely on the interrupt handler to record
information about the interrupt by using several arrays. It is possible
for the compiler to infer that the arrays won't be changed during normal
program flow and try to perform harmful optimizations (like stashing a
previous read in a register and reusing it). To prevent this, for GICv2,
a compile barrier is added to gicv2_ipi_send_self(). For GICv3, the
wmb() barrier in gic_ipi_send_single() (which is also used when a CPU
sends an IPI to itself) already implies a compiler barrier.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/gic-v2.c | 4 ++++
 arm/gic.c        | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
index dc6a97c600ec..da244c82de34 100644
--- a/lib/arm/gic-v2.c
+++ b/lib/arm/gic-v2.c
@@ -45,6 +45,8 @@ void gicv2_ipi_send_single(int irq, int cpu)
 {
 	assert(cpu < 8);
 	assert(irq < 16);
+
+	smp_wmb();
 	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
 }
 
@@ -53,5 +55,7 @@ void gicv2_ipi_send_mask(int irq, const cpumask_t *dest)
 	u8 tlist = (u8)cpumask_bits(dest)[0];
 
 	assert(irq < 16);
+
+	smp_wmb();
 	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
 }
diff --git a/arm/gic.c b/arm/gic.c
index fee48f9b4ccb..ca61dba2986c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -13,6 +13,7 @@
  */
 #include <libcflat.h>
 #include <errata.h>
+#include <linux/compiler.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
@@ -260,11 +261,14 @@ static void check_lpi_hits(int *expected, const char *msg)
 
 static void gicv2_ipi_send_self(void)
 {
+	/* Prevent the compiler from optimizing memory accesses */
+	barrier();
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
 static void gicv2_ipi_send_broadcast(void)
 {
+	smp_wmb();
 	writel(1 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
-- 
2.29.2

