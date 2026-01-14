Return-Path: <kvm+bounces-68028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B2BD1E9A5
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 12:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 423E7301A3B4
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454C22F3608;
	Wed, 14 Jan 2026 11:59:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B537B396B96
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391944; cv=none; b=BxoMyNBxVWAX2kilRS0jTdk+bAjBjeZySzasTpw4wDygr0PvHdmFGyhCTxU8ZmqOhBwcXcNpGcQEL7ALLc71HbnCUx4ltzxsq1fYwfbbiLZ4yXCkpal8YFmNfXFyrMdrs8hQPOC9+cj2TvmW8GICc2cJPNUnTmbgq6v5KuxnB0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391944; c=relaxed/simple;
	bh=Y9vT8uDrc2u+sG0KjA0eAFsuuqyojZfE365Bl67ufFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bwqKDTouGEkJymjYsa2WMG69S70KNCZUZyQSRTx/92lW15YfQuq5iburJr83XdaWB+Mu96g3rStg9F4RAm/f/DBltw7ltcnKf7NXawU3ndlVHzv5/MDxG/hpItTBisZvSdRayx/lNBu39+slRXF7YPWGMYw6e5Rmp3KTovlIbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6EB01655;
	Wed, 14 Jan 2026 03:58:51 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 387553F632;
	Wed, 14 Jan 2026 03:58:57 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 09/11] arm64: pmu: count EL2 cycles
Date: Wed, 14 Jan 2026 11:57:01 +0000
Message-Id: <20260114115703.926685-10-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Count EL2 cycles if that's the EL kvm-unit-tests is running at!

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 2dc0822b..2fcec71a 100644
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
+#define PMEVTYPER_EXCLUDE_EL0 (BIT(30) | (current_level() == CurrentEL_EL2 ? BIT(27) : 0))
 
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


