Return-Path: <kvm+bounces-65287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 744AECA402D
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAA2530671D6
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773AB2FD667;
	Thu,  4 Dec 2025 14:24:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57ACA33CEB6
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858241; cv=none; b=EE6F16irysF7OOnXylWVgr4rI/i0kO7kGoABV9cap+D+vt8EDf6mprSPpVPeIuvA7z4zGF9zahKnZLOj5xIfNIv3MabDBMAtxZMO2apKETaK3n3f1UPNGOv13hJL0+TvyNpuKYtj2CHk00jGZfwJaFt9obUTO7Tl7mg5O8BnWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858241; c=relaxed/simple;
	bh=HNn9k5NfTCuWqgHdDFbZpDP7a4O0VNubIkkOuJjHQwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tsy3a3DljUt5X42VYn5ybrOUyEomurqvQNmM3SnXIwIkTcn4sCb1qGN76Xfy9PIphnQ0CgbEF5sU1dGFjnx0j5s9yIa/13D10BmSzqx3TJLd1LY1RNCU7VSwjRD4eTjD1ntpzrt3JcK6I2BSdt1AHd4vOcV47wiREQXdkVipEwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71077176C;
	Thu,  4 Dec 2025 06:23:52 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57A403F73B;
	Thu,  4 Dec 2025 06:23:58 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 08/11] arm64: selftest: update test for running at EL2
Date: Thu,  4 Dec 2025 14:23:35 +0000
Message-Id: <20251204142338.132483-9-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204142338.132483-1-joey.gouly@arm.com>
References: <20251204142338.132483-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

Remove some hard-coded assumptions that this test is running at EL1.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/selftest.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 1553ed8e..9e30ce41 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
 	__user_psci_system_off();
 }
 #elif defined(__aarch64__)
+static unsigned long expected_level;
 
 /*
  * Capture the current register state and execute an instruction
@@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
 {
 	unsigned i;
 
-	/* exception handlers should always run in EL1 */
-	if (current_level() != CurrentEL_EL1)
+	if (current_level() != expected_level)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
@@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
 		return EL0_SYNC_64;
 
 	asm volatile("mrs %0, daif" : "=r" (daif) ::);
-	expected_regs.pstate = daif | PSR_MODE_EL1h;
+	expected_regs.pstate = daif;
+	if (current_level() == CurrentEL_EL1)
+		expected_regs.pstate |= PSR_MODE_EL1h;
+	else
+		expected_regs.pstate |= PSR_MODE_EL2h;
 	return EL1H_SYNC;
 }
 
@@ -317,8 +321,8 @@ static bool check_und(void)
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
 
-	/* try to read an el2 sysreg from el0/1 */
-	test_exception("", "mrs x0, sctlr_el2", "", "x0");
+	/* try to read an el3 sysreg from el0/1/2 */
+	test_exception("", "mrs x0, sctlr_el3", "", "x0");
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
 
@@ -426,6 +430,10 @@ int main(int argc, char **argv)
 {
 	report_prefix_push("selftest");
 
+#if defined(__aarch64__)
+	expected_level = current_level();
+#endif
+
 	if (argc < 2)
 		report_abort("no test specified");
 
-- 
2.25.1


