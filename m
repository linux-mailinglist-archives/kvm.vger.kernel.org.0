Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBBA10CE46
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfK1SEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:47 -0500
Received: from foss.arm.com ([217.140.110.172]:39396 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfK1SEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D6BD31B;
        Thu, 28 Nov 2019 10:04:45 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 81A773F6C4;
        Thu, 28 Nov 2019 10:04:44 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 11/18] arm64: timer: Write to ICENABLER to disable timer IRQ
Date:   Thu, 28 Nov 2019 18:04:11 +0000
Message-Id: <20191128180418.6938-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 1fc10a096259..09826fd5bc29 100644
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
index 0b808d5da9da..a4e3f98c4559 100644
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
@@ -306,9 +302,13 @@ static void test_init(void)
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
2.20.1

