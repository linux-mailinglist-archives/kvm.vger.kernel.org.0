Return-Path: <kvm+bounces-70843-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Eg/DGuAjGl9pwAAu9opvQ
	(envelope-from <kvm+bounces-70843-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:13:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93740124AAC
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:13:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBDF1301D30D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCE236AB5B;
	Wed, 11 Feb 2026 13:13:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA60D32D7C7
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815588; cv=none; b=J89j7ol4fZq7RWQ/NR9mkGyNFhcB80roagIRcNWXGRihYoJAksOuBBLsVVzJ3wz7UdfAqRHVqm913EydgrcP7CotTJslLsEESYcz+D7XMrA75rR/UvsugpQeP3MNxFfFA6NbP7vcAGm7sX4SBQAN7Rwn376mSSDZfLL//g7RhJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815588; c=relaxed/simple;
	bh=2iAOdQbPMpk2RWpOR3qV3Ui+TVfEqJUhAvd/eQ5w+u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfF8Iu1sUe+e81nl2OOffnm2Q9IDRlSdrVLSmErJvMCiOWuschCatl8mNGPo/qtuHhYTdfxIggFhy3TuKqyObZEzfJAVJgBMvNYEKB6DpQn59JkByu5mcrNi87rn+AMxm/kZXh2hqOiNR5YbboSr0+YJkjsmr5ZUX6yfS/gNqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1899B497;
	Wed, 11 Feb 2026 05:13:00 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B98B73F63F;
	Wed, 11 Feb 2026 05:13:04 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 5/6] arm64: Generate HYP timer interrupt specifiers
Date: Wed, 11 Feb 2026 13:12:48 +0000
Message-ID: <20260211131249.399019-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211131249.399019-1-andre.przywara@arm.com>
References: <20260211131249.399019-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70843-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 93740124AAC
X-Rspamd-Action: no action

From: Marc Zyngier <maz@kernel.org>

FEAT_VHE introduced a non-secure EL2 virtual timer, along with its
interrupt line. Consequently the arch timer DT binding introduced a fifth
interrupt to communicate this interrupt number.

Refactor the interrupts property generation code to deal with a variable
number of interrupts, and forward five interrupts instead of four in case
nested virt is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/arm-cpu.c           |  4 +---
 arm64/include/kvm/timer.h |  2 +-
 arm64/timer.c             | 29 ++++++++++++-----------------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index 0843ac0..5b5484d 100644
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
index 928e9ea..81e093e 100644
--- a/arm64/include/kvm/timer.h
+++ b/arm64/include/kvm/timer.h
@@ -1,6 +1,6 @@
 #ifndef ARM_COMMON__TIMER_H
 #define ARM_COMMON__TIMER_H
 
-void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs);
+void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
 #endif /* ARM_COMMON__TIMER_H */
diff --git a/arm64/timer.c b/arm64/timer.c
index 861f2d9..2ac6144 100644
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
2.47.3


