Return-Path: <kvm+bounces-38716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CED4A3DC45
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BA6A1891D1B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600131FA851;
	Thu, 20 Feb 2025 14:14:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099861FC7E8
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060862; cv=none; b=EJ1ts3ZoxyrGLNsnLIq359fa00rmx31xdczh9RdB+MgNrbbhk1JT4hlEvWzWP0FICrdI0OPTWS2g18uh+uILqF6TE9z+CCRLqIh1JP87BgoZTIaJ7nZDvnPzOAmah2D0EcEHLpqHf/EZkbDpI5KPWyVFrEBVP+oY8r3z8ePjd1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060862; c=relaxed/simple;
	bh=+QymMD9PZ03FYhrzS94YxXSriXLeyHDZss1xD7MUkKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G3NSi3v6iB0YcuAFxH8c+mcV+740tWuoYKSmzIHgP31kw7bUMVznLmethBoyKTZ/+gbcRYhrTDGPJMwfJYQ8hF9jseJF6YvjBqeB2obZIvYferAjdEwQg3cRyaFgorG1x1X3aj3VMdHXBCuAJO6Q7fXho37C6C0+2gUpskR97Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 803B82BC2;
	Thu, 20 Feb 2025 06:14:37 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17E1A3F59E;
	Thu, 20 Feb 2025 06:14:17 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 6/7] arm64: pmu: count EL2 cycles
Date: Thu, 20 Feb 2025 14:13:53 +0000
Message-Id: <20250220141354.2565567-7-joey.gouly@arm.com>
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

Count EL2 cycles if that's the EL kvm-unit-tests is running at!

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/pmu.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 2dc0822b..238e4628 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -206,6 +206,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
 #define ID_DFR0_PMU_V3_8_5	0b0110
 #define ID_DFR0_PMU_IMPDEF	0b1111
 
+#define PMCCFILTR_EL0_NSH	BIT(27)
+
 static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
@@ -247,7 +249,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 #define PMCNTENCLR_EL0 sys_reg(3, 3, 9, 12, 2)
 
 #define PMEVTYPER_EXCLUDE_EL1 BIT(31)
-#define PMEVTYPER_EXCLUDE_EL0 BIT(30)
+#define PMEVTYPER_EXCLUDE_EL0 BIT(30) | BIT(27)
 
 static bool is_event_supported(uint32_t n, bool warn)
 {
@@ -1059,11 +1061,18 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 static bool check_cycles_increase(void)
 {
 	bool success = true;
+	u64 pmccfiltr = 0;
 
 	/* init before event access, this test only cares about cycle count */
 	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
-	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
+
+#if defined(__aarch64__)
+	if (current_level() == CurrentEL_EL2)
+		// include EL2 cycle counts
+		pmccfiltr |= PMCCFILTR_EL0_NSH;
+#endif
+	set_pmccfiltr(pmccfiltr);
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
 	isb();
@@ -1114,11 +1123,17 @@ static void measure_instrs(int num, uint32_t pmcr)
 static bool check_cpi(int cpi)
 {
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
+	u64 pmccfiltr = 0;
 
 	/* init before event access, this test only cares about cycle count */
 	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
-	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
+#if defined(__aarch64__)
+	if (current_level() == CurrentEL_EL2)
+		// include EL2 cycle counts
+		pmccfiltr |= PMCCFILTR_EL0_NSH;
+#endif
+	set_pmccfiltr(pmccfiltr);
 
 	if (cpi > 0)
 		printf("Checking for CPI=%d.\n", cpi);
-- 
2.25.1


