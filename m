Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFAC1F4E81
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfKHOnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:43:04 -0500
Received: from foss.arm.com ([217.140.110.172]:44644 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbfKHOnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:43:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA65346A;
        Fri,  8 Nov 2019 06:43:03 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD1F73F719;
        Fri,  8 Nov 2019 06:43:02 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 10/17] arm: gic: Check for writable IGROUPR registers
Date:   Fri,  8 Nov 2019 14:42:33 +0000
Message-Id: <20191108144240.204202-11-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When both groups are avaiable to the non-secure side, the MMIO group
registers need to be writable, so that the group that an IRQ belongs to
can be programmed.

Check that the group can be flipped, after having established that both
groups are usable.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index c882a24..485ca4f 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -683,6 +683,7 @@ static bool gicv3_check_security(void *gicd_base)
 static void test_irq_group(void *gicd_base)
 {
 	bool is_gicv3 = (gic_version() == 3);
+	u32 reg;
 
 	report_prefix_push("GROUP");
 	gic_enable_defaults();
@@ -692,6 +693,16 @@ static void test_irq_group(void *gicd_base)
 		if (!gicv3_check_security(gicd_base))
 			return;
 	}
+
+	/*
+	 * On a security aware GIC in non-secure world the IGROUPR registers
+	 * are RAZ/WI. KVM emulates a single-security-state GIC, so both
+	 * groups are available and the IGROUPR registers are writable.
+	 */
+	reg = gic_get_irq_group(SPI_IRQ);
+	gic_set_irq_group(SPI_IRQ, !reg);
+	report("IGROUPR is writable", gic_get_irq_group(SPI_IRQ) != reg);
+	gic_set_irq_group(SPI_IRQ, reg);
 }
 
 static void spi_send(void)
-- 
2.17.1

