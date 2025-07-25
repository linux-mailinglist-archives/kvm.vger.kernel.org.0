Return-Path: <kvm+bounces-53455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2135B12049
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FD071C21B35
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575ED2EE275;
	Fri, 25 Jul 2025 14:41:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730392ED856
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753454501; cv=none; b=K4YHccu90CFACY1x+HWGMVW8jQxslJyPN0sINUGR50ZbCqLfdUZgtWPcng2FTrbuJ8vLA1Y5a7qJjZJ0+Jv84kEz0J+aRL7pBlj0QwsPNlbkn8SN6V0UJMCHAr0KrGyhanrDlEas29aAL/0AF2+Kkt36anqlAcfTf2P/FCZhv7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753454501; c=relaxed/simple;
	bh=qO7Oxu4MghnFe89SQZSfyy3L7Fji0ufbNWOYNTXTM5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IdcFk7a+7gl7LKh7hFVVjfWeGHiZuN8rCQ06d0bynDPrrmfzTxHnoeLepI4gFapeexC9txe/svmXOdoN1JGwqrQc+5CYpY8DhjPXRjBpOLdtm98AKBcWtWv50Ae2zididZlM6vatTahNE266HNzhsn4jfmqIVUdbUX0obWTXvu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 778752C27;
	Fri, 25 Jul 2025 07:41:33 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10E843F778;
	Fri, 25 Jul 2025 07:41:38 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2 6/6] arm64: Generate HYP timer interrupt specifiers
Date: Fri, 25 Jul 2025 15:41:00 +0100
Message-Id: <20250725144100.2944226-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725144100.2944226-1-andre.przywara@arm.com>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

FEAT_VHE introduced a non-secure EL2 virtual timer, along with its
interrupt line. Consequently the arch timer DT binding introduced a fifth
interrupt to communicate this interrupt number.

Refactor the interrupts property generation code to deal with a variable
number of interrupts, and forward five interrupts instead of four in case
nested virt is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/arm-cpu.c           |  4 +---
 arm64/include/kvm/timer.h |  2 +-
 arm64/timer.c             | 29 ++++++++++++-----------------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index 1e456f2c6..abdd6324f 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -12,11 +12,9 @@
 
 static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
-	int timer_interrupts[4] = {13, 14, 11, 10};
-
 	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip,
 				kvm->cfg.arch.nested_virt);
-	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
+	timer__generate_fdt_nodes(fdt, kvm);
 	pmu__generate_fdt_nodes(fdt, kvm);
 }
 
diff --git a/arm64/include/kvm/timer.h b/arm64/include/kvm/timer.h
index 928e9ea7a..81e093e46 100644
--- a/arm64/include/kvm/timer.h
+++ b/arm64/include/kvm/timer.h
@@ -1,6 +1,6 @@
 #ifndef ARM_COMMON__TIMER_H
 #define ARM_COMMON__TIMER_H
 
-void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs);
+void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
 #endif /* ARM_COMMON__TIMER_H */
diff --git a/arm64/timer.c b/arm64/timer.c
index 861f2d994..2ac6144f9 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -5,31 +5,26 @@
 #include "kvm/timer.h"
 #include "kvm/util.h"
 
-void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
+void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
-	u32 irq_prop[] = {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[0]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
+	int irqs[5] = {13, 14, 11, 10, 12};
+	int nr = ARRAY_SIZE(irqs);
+	u32 irq_prop[nr * 3];
 
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[1]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
+	if (!kvm->cfg.arch.nested_virt)
+		nr--;
 
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[2]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
-
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[3]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
-	};
+	for (int i = 0; i < nr; i++) {
+		irq_prop[i * 3 + 0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
+		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i]);
+		irq_prop[i * 3 + 2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
+	}
 
 	_FDT(fdt_begin_node(fdt, "timer"));
 	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
-	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, nr * 3 * sizeof(irq_prop[0])));
 	_FDT(fdt_property(fdt, "always-on", NULL, 0));
 	if (kvm->cfg.arch.force_cntfrq > 0)
 		_FDT(fdt_property_cell(fdt, "clock-frequency", kvm->cfg.arch.force_cntfrq));
-- 
2.25.1


