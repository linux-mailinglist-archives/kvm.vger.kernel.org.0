Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCCDF4E69
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKHOmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:42:53 -0500
Received: from foss.arm.com ([217.140.110.172]:44522 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHOmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D80CD7A7;
        Fri,  8 Nov 2019 06:42:51 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAD8A3F719;
        Fri,  8 Nov 2019 06:42:50 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 01/17] arm: gic: Enable GIC MMIO tests for GICv3 as well
Date:   Fri,  8 Nov 2019 14:42:24 +0000
Message-Id: <20191108144240.204202-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
machines tend to have a GICv3-only GIC, so can't run those tests.
It turns out that most GIC distributor registers we test in the unit
tests are actually the same in GICv3, so we can just enable those tests
for GICv3 guests as well.
The only exception is the CPU number in the TYPER register, which is
only valid in the GICv2 compat mode (ARE=0), which KVM does not support.
So we protect this test against running on a GICv3 guest.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c            | 13 +++++++++++--
 arm/unittests.cfg    | 26 ++++++++++++++++++++++----
 lib/arm/asm/gic-v3.h |  2 ++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index adb6aa4..04b3337 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -6,6 +6,7 @@
  *   + MMIO access tests
  * GICv3
  *   + test sending/receiving IPIs
+ *   + MMIO access tests
  *
  * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
@@ -496,7 +497,14 @@ static void gic_test_mmio(void)
 		idreg = gic_dist_base + GICD_ICPIDR2;
 		break;
 	case 0x3:
-		report_abort("GICv3 MMIO tests NYI");
+		/*
+		 * We only test generic registers or those affecting
+		 * SPIs, so don't need to consider the SGI base in
+		 * the redistributor here.
+		 */
+		gic_dist_base = gicv3_dist_base();
+		idreg = gic_dist_base + GICD_PIDR2;
+		break;
 	default:
 		report_abort("GIC version %d not supported", gic_version());
 	}
@@ -505,7 +513,8 @@ static void gic_test_mmio(void)
 	nr_irqs = GICD_TYPER_IRQS(reg);
 	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
 
-	test_typer_v2(reg);
+	if (gic_version() == 0x2)
+		test_typer_v2(reg);
 
 	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
 
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a0..12ac142 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -86,28 +86,46 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'ipi'
 groups = gic
 
-[gicv2-mmio]
+[gicv3-ipi]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'ipi'
+groups = gic
+
+[gicv2-max-mmio]
 file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
+[gicv3-max-mmio]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'mmio'
+groups = gic
+
 [gicv2-mmio-up]
 file = gic.flat
 smp = 1
 extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
+[gicv3-mmio-up]
+file = gic.flat
+smp = 1
+extra_params = -machine gic-version=3 -append 'mmio'
+groups = gic
+
 [gicv2-mmio-3p]
 file = gic.flat
 smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
 extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
-[gicv3-ipi]
+[gicv3-mmio-3p]
 file = gic.flat
-smp = $MAX_SMP
-extra_params = -machine gic-version=3 -append 'ipi'
+smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
+extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
 [gicv2-active]
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 347be2f..ed6a5ad 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -23,6 +23,8 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_PIDR2			0xffe8
+
 /* Re-Distributor registers, offsets from RD_base */
 #define GICR_TYPER			0x0008
 
-- 
2.17.1

