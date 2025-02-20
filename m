Return-Path: <kvm+bounces-38712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9005FA3DC43
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44FA2189A5EB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EE51FBE9E;
	Thu, 20 Feb 2025 14:14:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5211FAC48
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060856; cv=none; b=hwgGsTmmbeBDJOScEtTIMTkQ1OCM2Dt3uvja303mEi6b+4c0l13ZurbhC+6Kn3Xz4MmQkZOVIKNjy6Qm/VAIIhRVAkeXDqU7EhXDjnh7ZZ1tPvi66oQywB9dDK+XmlOv0CycdK16a35QWuCgL2cAm87KT38gdOurou4kLpVAAyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060856; c=relaxed/simple;
	bh=rDD0jeK/FcB4BgVzf8PzomA+p3S4UOW3YEX+uNBZgvM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O09S+aUHC9BIGrcn/7zPus8ZpPRcwEtej74To7W2pl9qGXKanSLEjtLXS5vaOZLTDef+La3blXZ8sdQ+AFmoCsqz2yqclTB5G1KyVcpT7ygBO2aNYi9JDqI9XrfxZ2n32T62bD03f6xQPYQ/okEEQb8H78OZwgPka+rguoNt0Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 843DB22EE;
	Thu, 20 Feb 2025 06:14:32 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B8F23F59E;
	Thu, 20 Feb 2025 06:14:12 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 3/7] arm64: micro-bench: fix timer IRQ
Date: Thu, 20 Feb 2025 14:13:50 +0000
Message-Id: <20250220141354.2565567-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250220141354.2565567-1-joey.gouly@arm.com>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable the correct (hvtimer) IRQ when at EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/micro-bench.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 22408955..f47c5fc1 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -42,7 +42,7 @@ static void gic_irq_handler(struct pt_regs *regs)
 	irq_received = true;
 	gic_write_eoir(irqstat);
 
-	if (irqstat == TIMER_VTIMER_IRQ) {
+	if (irqstat == TIMER_VTIMER_IRQ || irqstat == TIMER_HVTIMER_IRQ) {
 		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
 			     cntv_ctl_el0);
 		isb();
@@ -215,7 +215,11 @@ static bool timer_prep(void)
 	install_irq_handler(EL1H_IRQ, gic_irq_handler);
 	local_irq_enable();
 
-	gic_enable_irq(TIMER_VTIMER_IRQ);
+	if (current_level() == CurrentEL_EL1)
+		gic_enable_irq(TIMER_VTIMER_IRQ);
+	else
+		gic_enable_irq(TIMER_HVTIMER_IRQ);
+
 	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
-- 
2.25.1


