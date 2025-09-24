Return-Path: <kvm+bounces-58644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D15B9A197
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CC951B265FF
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04ADF3064AF;
	Wed, 24 Sep 2025 13:45:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7D5305E1B
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721530; cv=none; b=Xi3vsOysNq12MwYNIaKngMkkhx5uS5E2EISNDYT+8XN01G4r8Vo8n5zjC0g3lK+MRkZ+GZBO6iSULN1zWRN3ytcMk8kF6bHXVPsN9JzSqrOkjBBG1p3zkgQxlwFv6tUjz1c8d5W4RIrX4lnU68dGpPKNQH2guUbSnFiUEQEsipo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721530; c=relaxed/simple;
	bh=Cpso67FU36zzst0YVL6XmLZdKfDGZy8KngJOpF2Fry4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=psNNqznmWD3hFjJa3yVvSekp5lrFZ4uAcDs+teUwKR5/taw31isj0ylEIy0Wozjwoqeo03wBjNWWZXRKTLVkLpdSKoLFcw1R5hVsZpj2qjEyXn0FlzADsd/Y/56/dyQELaUMXwZGtZHHUKurnoNC7/kW6Hw4adwKeFdNvcw6xDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65EE1106F;
	Wed, 24 Sep 2025 06:45:20 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B52C3F5A1;
	Wed, 24 Sep 2025 06:45:27 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 6/7] arm64: Generate HYP timer interrupt specifiers
Date: Wed, 24 Sep 2025 14:45:10 +0100
Message-Id: <20250924134511.4109935-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250924134511.4109935-1-andre.przywara@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
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
index 0843ac051..5b5484d8b 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -12,10 +12,8 @@
 
 static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
-	int timer_interrupts[4] = {13, 14, 11, 10};
-
 	gic__generate_fdt_nodes(fdt, kvm);
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


