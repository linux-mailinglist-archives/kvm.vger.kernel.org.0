Return-Path: <kvm+bounces-68299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B89FD2F23E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 10:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0B573024D47
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 09:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC4D3587CE;
	Fri, 16 Jan 2026 09:57:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailer.gwdg.de (mailer.gwdg.de [134.76.10.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395FF239594
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768557466; cv=none; b=AFa6n5/iKiBpIu3v9hx9BwWKyd4bStjqkuU1CjeGZlNzcn5DyTStTPfV6x8VEyXnMGuMKknyn0ggRS0w1jUL4qosH7jl6I6jwtODQf0h3ZoAuE0Lt57wUwJ+cAJ5tG70QTSc5cVARLyHwfFICaS3iLFm1ou787PayRU2IN9mO3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768557466; c=relaxed/simple;
	bh=PABCyGtNhgDgSqd/5zBffvko7K5sEbmyDFvOyHII7Jw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eAdKwH3Y0cUB212I+RvQYBK9jlGIK0wfHDYBvSCPguT1TEIFRyLT4RCHURSPsv+FR8JmPInNvGRfDnF7XjDPaoRy8pyFf4ZuGjopZ9h8nAsbznK/Rp6a7Zi9zDZsjDV/94LiX8PkWJ8/T20lUEwbBdSUwRPUAcX+zf1lZkCUcyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; arc=none smtp.client-ip=134.76.10.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vggaI-0004Pd-03;
	Fri, 16 Jan 2026 10:57:38 +0100
Received: from Mac (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.35; Fri, 16 Jan
 2026 10:57:37 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
To: <anup@brainfault.org>, <atish.patra@linux.dev>
CC: <pjw@kernel.org>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
	<alex@ghiti.fr>, <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <daniel.weber@cispa.de>,
	<marton.bognar@kuleuven.be>, <jo.vanbulck@kuleuven.be>,
	<michael.schwarz@cispa.de>, Lukas Gerlach <lukas.gerlach@cispa.de>
Subject: [PATCH] KVM: riscv: Fix Spectre-v1 in APLIC interrupt handling
Date: Fri, 16 Jan 2026 10:57:31 +0100
Message-ID: <20260116095731.24555-1-lukas.gerlach@cispa.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MBX19-GWD-08.um.gwdg.de (10.108.142.61) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Spam-Level: -
X-Virus-Scanned: (clean) by clamav

Guests can control IRQ indices via MMIO. Sanitize them with
array_index_nospec() to prevent speculative out-of-bounds access
to the aplic->irqs[] array.

Similar to arm64 commit 41b87599c743 ("KVM: arm/arm64: vgic: fix possible
spectre-v1 in vgic_get_irq()") and x86 commit 8c86405f606c ("KVM: x86:
Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks").

Fixes: 74967aa208e2 ("RISC-V: KVM: Add in-kernel emulation of AIA APLIC")
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/aia_aplic.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index f59d1c0c8c43..a2b831e57ecd 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -10,6 +10,7 @@
 #include <linux/irqchip/riscv-aplic.h>
 #include <linux/kvm_host.h>
 #include <linux/math.h>
+#include <linux/nospec.h>
 #include <linux/spinlock.h>
 #include <linux/swab.h>
 #include <kvm/iodev.h>
@@ -45,7 +46,7 @@ static u32 aplic_read_sourcecfg(struct aplic *aplic, u32 irq)

 	if (!irq || aplic->nr_irqs <= irq)
 		return 0;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);
 	ret = irqd->sourcecfg;
@@ -61,7 +62,7 @@ static void aplic_write_sourcecfg(struct aplic *aplic, u32 irq, u32 val)

 	if (!irq || aplic->nr_irqs <= irq)
 		return;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	if (val & APLIC_SOURCECFG_D)
 		val = 0;
@@ -81,7 +82,7 @@ static u32 aplic_read_target(struct aplic *aplic, u32 irq)

 	if (!irq || aplic->nr_irqs <= irq)
 		return 0;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);
 	ret = irqd->target;
@@ -97,7 +98,7 @@ static void aplic_write_target(struct aplic *aplic, u32 irq, u32 val)

 	if (!irq || aplic->nr_irqs <= irq)
 		return;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	val &= APLIC_TARGET_EIID_MASK |
 	       (APLIC_TARGET_HART_IDX_MASK << APLIC_TARGET_HART_IDX_SHIFT) |
@@ -116,7 +117,7 @@ static bool aplic_read_pending(struct aplic *aplic, u32 irq)

 	if (!irq || aplic->nr_irqs <= irq)
 		return false;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);
 	ret = (irqd->state & APLIC_IRQ_STATE_PENDING) ? true : false;
@@ -132,7 +133,7 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)

 	if (!irq || aplic->nr_irqs <= irq)
 		return;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);

@@ -170,7 +171,7 @@ static bool aplic_read_enabled(struct aplic *aplic, u32 irq)

 	if (!irq || aplic->nr_irqs <= irq)
 		return false;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);
 	ret = (irqd->state & APLIC_IRQ_STATE_ENABLED) ? true : false;
@@ -186,7 +187,7 @@ static void aplic_write_enabled(struct aplic *aplic, u32 irq, bool enabled)

 	if (!irq || aplic->nr_irqs <= irq)
 		return;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);
 	if (enabled)
@@ -205,7 +206,7 @@ static bool aplic_read_input(struct aplic *aplic, u32 irq)

 	if (!irq || aplic->nr_irqs <= irq)
 		return false;
-	irqd = &aplic->irqs[irq];
+	irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 	raw_spin_lock_irqsave(&irqd->lock, flags);

@@ -254,7 +255,7 @@ static void aplic_update_irq_range(struct kvm *kvm, u32 first, u32 last)
 	for (irq = first; irq <= last; irq++) {
 		if (!irq || aplic->nr_irqs <= irq)
 			continue;
-		irqd = &aplic->irqs[irq];
+		irqd = &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];

 		raw_spin_lock_irqsave(&irqd->lock, flags);

@@ -283,7 +284,7 @@ int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level)

 	if (!aplic || !source || (aplic->nr_irqs <= source))
 		return -ENODEV;
-	irqd = &aplic->irqs[source];
+	irqd = &aplic->irqs[array_index_nospec(source, aplic->nr_irqs)];
 	ie = (aplic->domaincfg & APLIC_DOMAINCFG_IE) ? true : false;

 	raw_spin_lock_irqsave(&irqd->lock, flags);
--
2.51.0


