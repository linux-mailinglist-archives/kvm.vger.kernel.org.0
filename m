Return-Path: <kvm+bounces-58774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A154B9FFDB
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A22D73B2749
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929AE2D2391;
	Thu, 25 Sep 2025 14:25:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE302D0638
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810321; cv=none; b=fQDnV6QxJJVmd6sQXvKVUciG8GoJ3qaQJfYK0l40cHhHWtm1E4+1kdWKSnDIGADFHfHqUZ3N22iT7Q03xLXarxfCTmYENS6WXzva86l61JxmHUWipPxZH06mB2Z4peNJWsMAzQL9+KQUidz0br3H5oxex6HlnlDR/OV729kzDSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810321; c=relaxed/simple;
	bh=yVg02McpL7H1sKddh1dGY5nQzfykRbvdRrbAQjgo17s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QNfvhHbG6kgrPZWFTDQquOrrmTXkuE2vqEEKkpE+i8qMbf+0b15uu7/4vKNFGKeCVwbr9wLfNituM/ThTbkPHSN3VJIquIT0+vL0yjZyDIAMBfrVhbCCK9dyCi56kA9gNaT2GUgedOhXsxXEP0p1WLvVbND79EZNmdW28uC9xno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E1401692;
	Thu, 25 Sep 2025 07:25:12 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5BCC3F694;
	Thu, 25 Sep 2025 07:25:18 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 08/10] arm64: pmu: count EL2 cycles
Date: Thu, 25 Sep 2025 15:19:56 +0100
Message-Id: <20250925141958.468311-9-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
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
 arm/pmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 2dc0822b..e6c0f05b 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -121,6 +121,8 @@ static struct pmu pmu;
 #define PMINTENCLR   __ACCESS_CP15(c9, 0, c14, 2)
 #define PMCCNTR64    __ACCESS_CP15_64(0, c9)
 
+#define PMCCFILTR_EL0_DEFAULT	0
+
 static inline uint32_t get_id_dfr0(void) { return read_sysreg(ID_DFR0); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(PMCR); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, PMCR); }
@@ -206,6 +208,9 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
 #define ID_DFR0_PMU_V3_8_5	0b0110
 #define ID_DFR0_PMU_IMPDEF	0b1111
 
+#define PMCCFILTR_EL0_NSH	BIT(27)
+#define PMCCFILTR_EL0_DEFAULT	(current_level() == CurrentEL_EL2 ? PMCCFILTR_EL0_NSH : 0)
+
 static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
@@ -246,8 +251,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 #define PMCNTENSET_EL0 sys_reg(3, 3, 9, 12, 1)
 #define PMCNTENCLR_EL0 sys_reg(3, 3, 9, 12, 2)
 
-#define PMEVTYPER_EXCLUDE_EL1 BIT(31)
-#define PMEVTYPER_EXCLUDE_EL0 BIT(30)
+#define PMEVTYPER_EXCLUDE_EL0 BIT(30) | (current_level() == CurrentEL_EL2 ? BIT(27) : 0)
 
 static bool is_event_supported(uint32_t n, bool warn)
 {
@@ -1063,7 +1067,8 @@ static bool check_cycles_increase(void)
 	/* init before event access, this test only cares about cycle count */
 	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
-	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
+
+	set_pmccfiltr(PMCCFILTR_EL0_DEFAULT);
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
 	isb();
@@ -1118,7 +1123,7 @@ static bool check_cpi(int cpi)
 	/* init before event access, this test only cares about cycle count */
 	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
-	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
+	set_pmccfiltr(PMCCFILTR_EL0_DEFAULT);
 
 	if (cpi > 0)
 		printf("Checking for CPI=%d.\n", cpi);
-- 
2.25.1


