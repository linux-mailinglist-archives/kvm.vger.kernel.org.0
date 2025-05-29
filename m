Return-Path: <kvm+bounces-47978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3758CAC7F57
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2DEAA24FF2
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB0722B8BC;
	Thu, 29 May 2025 13:56:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3024222B5AC
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748527001; cv=none; b=lejboemSFAKYPR2PiJ2u8UXm3NI6VQkpTodMFtpnauAoglpUbnkGsX+MuZdjZlIgLzP6Uj6eyN9XwrK2qQMNSHND99AZmo4gSndKKsVy6dOm99LO5QbvRwrQtNPKsdTY5konEaHnJ+1H/bEIYXv8XfkM8eOXETdtmpvGqBUZ5aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748527001; c=relaxed/simple;
	bh=JgThAc1o8xzaIUrkShRaIJ0a7Z1JzuUb5JRVhO77CHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AaLs8kgvgSO/lOqblQYHd5zDO+IruSma3IzXsNqSKRNfs5spBd7yREYcp+3SueJHGo+MQP9zjGjD5wQ3QgiQRpJdNM+XooxMzq/fePSYfH+Ibqm2Dsl57f1Bvl78Q5ONlORmBxRhMu5snc9uDMldRzp6dFU/9usFvqrKt5vgK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1ACCD176A;
	Thu, 29 May 2025 06:56:23 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46A083F673;
	Thu, 29 May 2025 06:56:38 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 6/9] arm64: micro-bench: use smc when at EL2
Date: Thu, 29 May 2025 14:55:54 +0100
Message-Id: <20250529135557.2439500-7-joey.gouly@arm.com>
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

At EL2, hvc would target the current EL, use smc so that it targets EL3.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/micro-bench.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index f47c5fc1..32029c5a 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -282,6 +282,11 @@ static bool mmio_read_user_prep(void)
 	return true;
 }
 
+static void smc_exec(void)
+{
+       asm volatile("mov w0, #0x4b000000; smc #0" ::: "w0");
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
+       if (current_level() == CurrentEL_EL2)
+               tests[0].exec = &smc_exec;
+       else
+               tests[0].exec = &hvc_exec;
+        return true;
+}
+
 struct ns_time {
 	uint64_t ns;
 	uint64_t ns_frac;
-- 
2.25.1


