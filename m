Return-Path: <kvm+bounces-65286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CFFCA4027
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 992C43114F83
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C1D336ED5;
	Thu,  4 Dec 2025 14:24:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3851223EA95
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858239; cv=none; b=Rsdd4xe9MpCaNLiLz8xjtqAFtOGkyMPzqh3Wko/NLODtNJvXFAnkkIg569Y18XZAGyoGU8cojbxWCT+OEo6LS929RNoRMNSEVTgUCCT0Q7furdhSuIZKr7LSh9k05E0ktTa1yhamjiY2+CfzNYXOG2m9KZa3zTR8tqpZv2PO1z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858239; c=relaxed/simple;
	bh=04bo2mqx0IPIuW/8xnTmj89YcFmkr2YUjTNj3D3TnR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t+Fh4RjwLAiRgZ0bJdei1Hlk9i0YxIuDtRv3kZueyZ7TcgxAZU+eRK1G6rLoXtcHClt+0DFsnJtz9WPrxn20e3b+NTDArGdd6J6W+lJT1DyNTl5vbqZaSCCS3CRJyrsw7uRPgcEa3EvDLlmeOR4zCHRzufRorYbuJNUQh8X3Pr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7FA01762;
	Thu,  4 Dec 2025 06:23:50 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EEA83F73B;
	Thu,  4 Dec 2025 06:23:56 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 07/11] arm64: micro-bench: use smc when at EL2
Date: Thu,  4 Dec 2025 14:23:34 +0000
Message-Id: <20251204142338.132483-8-joey.gouly@arm.com>
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

At EL2, hvc would target the current EL, use smc so that it targets EL3.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index f47c5fc1..a6a78f20 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -282,6 +282,11 @@ static bool mmio_read_user_prep(void)
 	return true;
 }
 
+static void smc_exec(void)
+{
+	asm volatile("mov w0, #0x4b000000; smc #0" ::: "w0");
+}
+
 static void mmio_read_user_exec(void)
 {
 	readl(userspace_emulated_addr);
@@ -300,6 +305,8 @@ static void eoi_exec(void)
 	write_eoir(spurious_id);
 }
 
+static bool exec_select(void);
+
 struct exit_test {
 	const char *name;
 	bool (*prep)(void);
@@ -310,7 +317,7 @@ struct exit_test {
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,			hvc_exec,		NULL,		65536,		true},
+	{"hyp_call",		exec_select,		hvc_exec,		NULL,		65536,		true},
 	{"mmio_read_user",	mmio_read_user_prep,	mmio_read_user_exec,	NULL,		65536,		true},
 	{"mmio_read_vgic",	NULL,			mmio_read_vgic_exec,	NULL,		65536,		true},
 	{"eoi",			NULL,			eoi_exec,		NULL,		65536,		true},
@@ -320,6 +327,15 @@ static struct exit_test tests[] = {
 	{"timer_10ms",		timer_prep,		timer_exec,		timer_post,	256,		true},
 };
 
+static bool exec_select(void)
+{
+	if (current_level() == CurrentEL_EL2)
+		tests[0].exec = &smc_exec;
+	else
+		tests[0].exec = &hvc_exec;
+	return true;
+}
+
 struct ns_time {
 	uint64_t ns;
 	uint64_t ns_frac;
-- 
2.25.1


