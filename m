Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F47A0361
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfH1Ni6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:38:58 -0400
Received: from foss.arm.com ([217.140.110.172]:59558 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfH1Ni5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:38:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0D781570;
        Wed, 28 Aug 2019 06:38:56 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B33613F246;
        Wed, 28 Aug 2019 06:38:55 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 05/16] arm64: timer: Write to ICENABLER to disable timer IRQ
Date:   Wed, 28 Aug 2019 14:38:20 +0100
Message-Id: <1566999511-24916-6-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According the Generic Interrupt Controller versions 2, 3 and 4 architecture
specifications, a write of 0 to the GIC{D,R}_ISENABLER{,0} registers is
ignored; this is also how KVM emulates the corresponding register. Write
instead to the ICENABLER register when disabling the timer interrupt.

Note that fortunately for us, the timer test was still working as intended
because KVM does the sensible thing and all interrupts are disabled by
default when creating a VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/gic-v3.h |  1 +
 lib/arm/asm/gic.h    |  1 +
 arm/timer.c          | 22 +++++++++++-----------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 347be2f9da17..0dc838b3ab2d 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -31,6 +31,7 @@
 /* Re-Distributor registers, offsets from SGI_base */
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
+#define GICR_ICENABLER0			GICD_ICENABLER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index f6dfb907a7d5..a67111607bcf 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -15,6 +15,7 @@
 #define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
 #define GICD_ISPENDR			0x0200
 #define GICD_ICPENDR			0x0280
 #define GICD_ISACTIVER			0x0300
diff --git a/arm/timer.c b/arm/timer.c
index f2f60192ba62..78f0dd870993 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,6 +17,9 @@
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
 static void *gic_ispendr;
+static void *gic_isenabler;
+static void *gic_icenabler;
+
 static bool ptimer_unsupported;
 
 static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
@@ -132,19 +135,12 @@ static struct timer_info ptimer_info = {
 
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
-	u32 val = 0;
+	u32 val = 1 << PPI(info->irq);
 
 	if (enabled)
-		val = 1 << PPI(info->irq);
-
-	switch (gic_version()) {
-	case 2:
-		writel(val, gicv2_dist_base() + GICD_ISENABLER + 0);
-		break;
-	case 3:
-		writel(val, gicv3_sgi_base() + GICR_ISENABLER0);
-		break;
-	}
+		writel(val, gic_isenabler);
+	else
+		writel(val, gic_icenabler);
 }
 
 static void irq_handler(struct pt_regs *regs)
@@ -305,9 +301,13 @@ static void test_init(void)
 	switch (gic_version()) {
 	case 2:
 		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
+		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
+		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
 		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
+		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
+		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
 		break;
 	}
 
-- 
2.7.4

