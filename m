Return-Path: <kvm+bounces-47979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DC0AC7F59
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0B4C16C867
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B970622C356;
	Thu, 29 May 2025 13:56:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D5822B8B8
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748527003; cv=none; b=t3ARdFLATxIGX0t9SX6MxO1d+MzgU7/EWpqBjz1p7VWLbvXMv06XTs0koef+x051zlDKvg5nxT1Fqre84wLfD/Kvwt3fvZ54rj1P/41mx8e5f1wQyevkCZW7WGW2U0t3AfQ4N2NrhZTRr0FenB2oauhwYIze1hou6IEdjEjGw8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748527003; c=relaxed/simple;
	bh=qIXLdy/UPD7nprbob3ifjb7b9Hg7GZgPkfWiXSOlIq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SeOdYA+aoPD7BUwncEUtI+dV/ZlQZqBzaLX9jmH6XwjWAiABXOXbgqmxPUWHYEbyqaA7TBZWxnQP7UDh1Xy/9PzXMdyoZqaS7X6jLpRyvSs0ibKi4YcPHQnXb6q+umZxdSPgQAQY4AzUYduCuHinQNLLNUPpa+iUmMo4AbQ1WiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B363E22D7;
	Thu, 29 May 2025 06:56:24 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEC0A3F673;
	Thu, 29 May 2025 06:56:39 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 7/9] arm64: selftest: update test for running at EL2
Date: Thu, 29 May 2025 14:55:55 +0100
Message-Id: <20250529135557.2439500-8-joey.gouly@arm.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

Remove some hard-coded assumptions that this test is running at EL1.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/selftest.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 1553ed8e..01691389 100644
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
 
@@ -429,6 +433,10 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		report_abort("no test specified");
 
+#if defined(__aarch64__)
+	expected_level = current_level();
+#endif
+
 	report_prefix_push(argv[1]);
 
 	if (strcmp(argv[1], "setup") == 0) {
-- 
2.25.1


