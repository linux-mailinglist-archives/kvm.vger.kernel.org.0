Return-Path: <kvm+bounces-47976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF60FAC7F58
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51BB71C00C91
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9442422ACE7;
	Thu, 29 May 2025 13:56:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D358224B0C
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526998; cv=none; b=ETttvsKWYdzg1glFkVJ4u5pmTMayMsSs6lERuxRgYjzR6z0qdMXcwff1Un8cdXVWhlsofWM5I5P6TPmlV3W1g/ghUX74YYPewXHx94Spjx6UAr5S0bxJLT9a+fDQp00rlVmVO6LBf7liDXhUWpcRPchy2wEHPnXhJPvOwObG/OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526998; c=relaxed/simple;
	bh=XPP/sCvf8MfSqfcXnuRaS2b+6mNE8bRlyablGqvktw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OTitOcdmEb46Kiz87qHP7M3ohJY4OnRiB7JC3mxRs5h0UuYtS5fJ9bO/UjOFnenNNePtBTSQCufLHgrIBMN4ZlHi5a0mEf7pfUdbSEXJgmBb/1CKB8ReKa3hpNxps4GEmO+W5sURazj8OAS7U1M+VTsqDU5/RGbfRauexnk3YkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D44A522EE;
	Thu, 29 May 2025 06:56:19 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09FEC3F673;
	Thu, 29 May 2025 06:56:34 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 4/9] arm64: timer: use hypervisor timers when at EL2
Date: Thu, 29 May 2025 14:55:52 +0100
Message-Id: <20250529135557.2439500-5-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529135557.2439500-1-joey.gouly@arm.com>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At EL2, with VHE:
  CNT{P,V}_{TVAL,CTL}_EL0 is forwarded to CNTH{P,V}_{CVAL,TVAL,CTL}_EL0.

Save the hypervisor physical and virtual timer IRQ numbers from the DT/ACPI.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c         | 10 ++++++++--
 lib/acpi.h          |  2 ++
 lib/arm/asm/timer.h | 11 +++++++++++
 lib/arm/timer.c     | 19 +++++++++++++++++--
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 2cb80518..c6287ca7 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -347,8 +347,14 @@ static void test_ptimer(void)
 static void test_init(void)
 {
 	assert(TIMER_PTIMER_IRQ != -1 && TIMER_VTIMER_IRQ != -1);
-	ptimer_info.irq = TIMER_PTIMER_IRQ;
-	vtimer_info.irq = TIMER_VTIMER_IRQ;
+	if (current_level() == CurrentEL_EL1) {
+		ptimer_info.irq = TIMER_PTIMER_IRQ;
+		vtimer_info.irq = TIMER_VTIMER_IRQ;
+	} else {
+		assert(TIMER_HPTIMER_IRQ != -1 && TIMER_HVTIMER_IRQ != -1);
+		ptimer_info.irq = TIMER_HPTIMER_IRQ;
+		vtimer_info.irq = TIMER_HVTIMER_IRQ;
+	}
 
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
 	ptimer_info.read_ctl();
diff --git a/lib/acpi.h b/lib/acpi.h
index c330c877..66e3062d 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -290,6 +290,8 @@ struct acpi_table_gtdt {
 	u64 counter_read_block_address;
 	u32 platform_timer_count;
 	u32 platform_timer_offset;
+	u32 virtual_el2_timer_interrupt;
+	u32 virtual_el2_timer_flags;
 };
 
 /* Reset to default packing */
diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
index fd8f7796..0dcebc1c 100644
--- a/lib/arm/asm/timer.h
+++ b/lib/arm/asm/timer.h
@@ -21,12 +21,23 @@ struct timer_state {
 		u32 irq;
 		u32 irq_flags;
 	} vtimer;
+	struct {
+		u32 irq;
+		u32 irq_flags;
+	} hptimer;
+	struct {
+		u32 irq;
+		u32 irq_flags;
+	} hvtimer;
 };
 extern struct timer_state __timer_state;
 
 #define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
 #define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
 
+#define TIMER_HPTIMER_IRQ (__timer_state.hptimer.irq)
+#define TIMER_HVTIMER_IRQ (__timer_state.hvtimer.irq)
+
 void timer_save_state(void);
 
 #endif /* !__ASSEMBLER__ */
diff --git a/lib/arm/timer.c b/lib/arm/timer.c
index ae702e41..57f504e2 100644
--- a/lib/arm/timer.c
+++ b/lib/arm/timer.c
@@ -38,10 +38,11 @@ static void timer_save_state_fdt(void)
 	 *      secure timer irq
 	 *      non-secure timer irq            (ptimer)
 	 *      virtual timer irq               (vtimer)
-	 *      hypervisor timer irq
+	 *      hypervisor timer irq            (hptimer)
+	 *      hypervisor virtual timer irq    (hvtimer)
 	 */
 	prop = fdt_get_property(fdt, node, "interrupts", &len);
-	assert(prop && len == (4 * 3 * sizeof(u32)));
+	assert(prop && len >= (4 * 3 * sizeof(u32)));
 
 	data = (u32 *) prop->data;
 	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */ );
@@ -50,6 +51,14 @@ static void timer_save_state_fdt(void)
 	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */ );
 	__timer_state.vtimer.irq = PPI(fdt32_to_cpu(data[7]));
 	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
+	if (len == (5 * 3 * sizeof(u32))) {
+		assert(fdt32_to_cpu(data[9]) == 1 /* PPI */ );
+		__timer_state.hptimer.irq = PPI(fdt32_to_cpu(data[10]));
+		__timer_state.hptimer.irq_flags = fdt32_to_cpu(data[11]);
+		assert(fdt32_to_cpu(data[12]) == 1 /* PPI */ );
+		__timer_state.hvtimer.irq = PPI(fdt32_to_cpu(data[13]));
+		__timer_state.hvtimer.irq_flags = fdt32_to_cpu(data[14]);
+	}
 }
 
 #ifdef CONFIG_EFI
@@ -72,6 +81,12 @@ static void timer_save_state_acpi(void)
 
 	__timer_state.vtimer.irq = gtdt->virtual_timer_interrupt;
 	__timer_state.vtimer.irq_flags = gtdt->virtual_timer_flags;
+
+	__timer_state.hptimer.irq = gtdt->non_secure_el2_interrupt;
+	__timer_state.hptimer.irq_flags = gtdt->non_secure_el2_flags;
+
+	__timer_state.hvtimer.irq = gtdt->virtual_el2_timer_interrupt;
+	__timer_state.hvtimer.irq_flags = gtdt->virtual_el2_timer_flags;
 }
 
 #else
-- 
2.25.1


