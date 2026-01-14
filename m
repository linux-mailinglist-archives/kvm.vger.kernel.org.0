Return-Path: <kvm+bounces-68026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8439AD1E9AC
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 13:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E5453072E8D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89E1395DB6;
	Wed, 14 Jan 2026 11:59:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CD7396D16
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391943; cv=none; b=Ulm22iNjmQpgbBE8I+RKIn+Hg8JHAl1vnYvC8n4HoFFKMlZ0/brl3lxbhLyD6BfWtzISqrFIV1E5zpsp8ORmGUwNEsZ9LuZLAZF3huF2egHDHqXSk5P8/bWfyNM9Bpuhe0cpHS5siAt0hXQkrlHIxmnWCEi32NFWslOtsH24saQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391943; c=relaxed/simple;
	bh=z4OqmW7V4WXq1LnpHaIWOXRJ+/5wHr9jGOYnM/t/4X8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uLpQIkG9c5EiYjo0HM1t3Y1INgpCImFkdGBV2FjL3KXzpeENzcSo7vEDMPHkg5ZNx1yPyWTL82eJKXIFFua7rHQeRRQzdIsxHOXJBl+6DD7ycf3QVkwfFc77pW4WNHoWjWFLVBp9WeYxQa2SOQUcX82+6+3/1TDl6ILxSndZW88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 362B21650;
	Wed, 14 Jan 2026 03:58:50 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC0593F632;
	Wed, 14 Jan 2026 03:58:55 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 08/11] arm64: selftest: update test for running at EL2
Date: Wed, 14 Jan 2026 11:57:00 +0000
Message-Id: <20260114115703.926685-9-joey.gouly@arm.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

Remove some hard-coded assumptions that this test is running at EL1.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/selftest.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 1553ed8e..77ea1d47 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -106,6 +106,8 @@ static bool und_works;
 static bool svc_works;
 static bool pabt_works;
 #if defined(__arm__)
+static void test_exception_prep(void) { }
+
 /*
  * Capture the current register state and execute an instruction
  * that causes an exception. The test handler will check that its
@@ -232,6 +234,11 @@ static void user_psci_system_off(struct pt_regs *regs)
 	__user_psci_system_off();
 }
 #elif defined(__aarch64__)
+static unsigned long expected_level;
+
+static void test_exception_prep(void) {
+	expected_level = current_level();
+}
 
 /*
  * Capture the current register state and execute an instruction
@@ -276,8 +283,7 @@ static bool check_regs(struct pt_regs *regs)
 {
 	unsigned i;
 
-	/* exception handlers should always run in EL1 */
-	if (current_level() != CurrentEL_EL1)
+	if (current_level() != expected_level)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
@@ -301,7 +307,11 @@ static enum vector check_vector_prep(void)
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
 
@@ -317,8 +327,8 @@ static bool check_und(void)
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
 
-	/* try to read an el2 sysreg from el0/1 */
-	test_exception("", "mrs x0, sctlr_el2", "", "x0");
+	/* try to read an el3 sysreg from el0/1/2 */
+	test_exception("", "mrs x0, sctlr_el3", "", "x0");
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
 
@@ -426,6 +436,8 @@ int main(int argc, char **argv)
 {
 	report_prefix_push("selftest");
 
+	test_exception_prep();
+
 	if (argc < 2)
 		report_abort("no test specified");
 
-- 
2.25.1


