Return-Path: <kvm+bounces-30771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9FD9BD49F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0F65B22EB5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21821E8850;
	Tue,  5 Nov 2024 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ndrIjuLm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB401DA62E;
	Tue,  5 Nov 2024 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831564; cv=none; b=rNikaGMseWdj+xXEZmngvkvkWAR6t5aANy2j1mIlqqc5a8vwkxF+3cgR65nL0Cohq8KBhIxVKq0bO3Q/UoscUGvHd+RmgGmMITNTsIqhqc+sHPO7Y9L0FbsJZNoDWfnTM0fKZu4kFyDbng5M6dt0tWF+0zalnCuC8nj20e5QCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831564; c=relaxed/simple;
	bh=pHYrsUjHjMYFIcOobr9tAgX+7EpJGfgPZXK6ho0GR34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hNllMDvQnnXqV3x0HU8Xw4iMclpdp7QeP4v0fY2kh0VlsBJhxbFR2b7GkhhdyTkndABhnyGc3oTrY5kcM6ld/ihW6h/5rMiIeVG03ISjyL7qgTXJH3dJF4l2nveTYeW0R9oe+hWU7FN4cdDNTHSlZW33olhKf6O7ULESbI7ENqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ndrIjuLm; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730831562; x=1762367562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TrNQ3LJeAMesAmpKUJ7N1Al9kS1bwIA8hsz/KHf4MgU=;
  b=ndrIjuLmgnRimDeKoZu1P68bqtmHh4+j82ue+5SFgyDPDTvOKZsgYs5H
   txRuU3XjznbZn4WexGt83hS5tPlFrLcgNWYF/hGp1Tljjtis2lpZxosKK
   Qm2wRnHpgcQHvrtBkFSyzEhFgpmAOjFEv76GWmIFgtROTpifNepdtxcl8
   w=;
X-IronPort-AV: E=Sophos;i="6.11,260,1725321600"; 
   d="scan'208";a="440503091"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:32:39 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:4506]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.170:2525] with esmtp (Farcaster)
 id 3e5bd2bb-9e63-4844-b995-362add075696; Tue, 5 Nov 2024 18:32:39 +0000 (UTC)
X-Farcaster-Flow-ID: 3e5bd2bb-9e63-4844-b995-362add075696
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 5 Nov 2024 18:32:37 +0000
Received: from u34cccd802f2d52.amazon.com (10.106.239.17) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 5 Nov 2024 18:32:32 +0000
From: Haris Okanovic <harisokn@amazon.com>
To: <ankur.a.arora@oracle.com>, <catalin.marinas@arm.com>
CC: <linux-pm@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<will@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<pbonzini@redhat.com>, <wanpengli@tencent.com>, <vkuznets@redhat.com>,
	<rafael@kernel.org>, <daniel.lezcano@linaro.org>, <peterz@infradead.org>,
	<arnd@arndb.de>, <lenb@kernel.org>, <mark.rutland@arm.com>,
	<harisokn@amazon.com>, <mtosatti@redhat.com>, <sudeep.holla@arm.com>,
	<cl@gentwo.org>, <misono.tomohiro@fujitsu.com>, <maobibo@loongson.cn>,
	<joao.m.martins@oracle.com>, <boris.ostrovsky@oracle.com>,
	<konrad.wilk@oracle.com>
Subject: [PATCH 5/5] cpuidle: implement poll_idle() using smp_vcond_load_relaxed()
Date: Tue, 5 Nov 2024 12:30:41 -0600
Message-ID: <20241105183041.1531976-6-harisokn@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105183041.1531976-1-harisokn@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA003.ant.amazon.com (10.13.138.211)

Implement poll_idle() using smp_vcond_load_relaxed() function.

Signed-off-by: Haris Okanovic <harisokn@amazon.com>
---
 drivers/cpuidle/poll_state.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 61df2395585e..5553e6f31702 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -7,46 +7,20 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
-
-#ifdef CONFIG_ARM64
-/*
- * POLL_IDLE_RELAX_COUNT determines how often we check for timeout
- * while polling for TIF_NEED_RESCHED in thread_info->flags.
- *
- * Set this to a low value since arm64, instead of polling, uses a
- * event based mechanism.
- */
-#define POLL_IDLE_RELAX_COUNT	1
-#else
-#define POLL_IDLE_RELAX_COUNT	200
-#endif
+#include <asm/barrier.h>
 
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
-	u64 time_start;
-
-	time_start = local_clock_noinstr();
+	unsigned long flags;
 
 	dev->poll_time_limit = false;
 
 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		u64 limit;
-
-		limit = cpuidle_poll_time(drv, dev);
-
-		while (!need_resched()) {
-			unsigned int loop_count = 0;
-			if (local_clock_noinstr() - time_start > limit) {
-				dev->poll_time_limit = true;
-				break;
-			}
-
-			smp_cond_load_relaxed(&current_thread_info()->flags,
-					      VAL & _TIF_NEED_RESCHED ||
-					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
-		}
+		u64 limit = cpuidle_poll_time(drv, dev);
+		flags = smp_vcond_load_relaxed(limit, &current_thread_info()->flags, _TIF_NEED_RESCHED, _TIF_NEED_RESCHED);
+		dev->poll_time_limit = !(flags & _TIF_NEED_RESCHED);
 	}
 	raw_local_irq_disable();
 
-- 
2.34.1


