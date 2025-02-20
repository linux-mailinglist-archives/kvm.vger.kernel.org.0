Return-Path: <kvm+bounces-38713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12725A3DC42
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45C51762D6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A091F709E;
	Thu, 20 Feb 2025 14:14:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4565A1FBCB6
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060857; cv=none; b=KG1SBWq41s4s5rj2dCIfWPTr9QDI7YAczq8rhAH5J1mfMBlC0smOfuZ+1hrNlDNCk8TQEuWO2JHc0ktTsQRH/UmQGaUvIoG6o9L/d21P4yfU6tNtXqhBLIEJuYsD8fpJsHQLLECqD3UVO3yHmOOx0atBzz6FPTqMsFD+O1dzoDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060857; c=relaxed/simple;
	bh=mOtZZVMzbGeAvRtXFioKQvB1RsHgdPml9E/RILnggg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eGiPqPvfM0l9+oRIqaeBoMqeIWRZ9Qxa6H/jvnsU9iRqdYo12Kj0lctma9h9nwWR6A2LMzH7rnglVEdTzFuxxDi+HPDnDd99gjEBkJ2fbiRcDCskowWgmcualhV5IW6xg/IYEgldEumc2cnNL/j6qfkscm8WDkeAE/rR3zn7auQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 317CC2696;
	Thu, 20 Feb 2025 06:14:34 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD5933F59E;
	Thu, 20 Feb 2025 06:14:14 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 4/7] arm64: micro-bench: use smc when at EL2
Date: Thu, 20 Feb 2025 14:13:51 +0000
Message-Id: <20250220141354.2565567-5-joey.gouly@arm.com>
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


