Return-Path: <kvm+bounces-30770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3FD9BD49C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A66EA1F2373E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4EB1EABC7;
	Tue,  5 Nov 2024 18:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="b+HLuqkI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E751E883C;
	Tue,  5 Nov 2024 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831546; cv=none; b=JRtRP2+6cip4BQzXwWdu9Zr5Bii+EX95ADRG/97XPUxbj32SVqzeMRrCOwsJGtM74Ykk0Z5F0G9fnJYupue1wIJPnmIhR1Gs1sad3Q9zSaW1DSqMsVR2lEjTGilSiP7uOUbcUq5xXXXWavpddYJCsI22j5F/yvI9dPdo9+g3UBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831546; c=relaxed/simple;
	bh=t30kpWj2OTYiI0ATHwleBX8+0AO3huVHiGER9YBLofI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AqcRBpYMb3ONmuk6k4aq7nEsSc5qnsjGKohuglcCK/m+I7U/E+oqcFu+eCzCdQZLZPxF/FWsm05uPxhqZ2Cx75pmMW6otzBNBj+OK2k3Kos7kIbRAU9U8Vl5rpT9wKT8Cd3d1WR0paGJVL7+JYV/5dDNpKgqVzguOQhU/32UmDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=b+HLuqkI; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730831545; x=1762367545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XT81pCaCySeLSnjYgvTXLKqn2CWQcbY+GGEiD2145i8=;
  b=b+HLuqkI6efbI3OfXxaTDfb5pZFHTIBpnkhuvXTNf5K40swCwvv4i/lK
   OFl7c3vOX6Sv9TxYganTszklnckbLLZnDCtT5sL8e4qNjGqI7FG2AovFn
   MUmkOEu0UQ5ZfFh+ZFu6OCnu4j7cK3bS/7/9361OG6rnFa4moeMEurRHf
   I=;
X-IronPort-AV: E=Sophos;i="6.11,260,1725321600"; 
   d="scan'208";a="39203526"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:32:22 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:25778]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.130:2525] with esmtp (Farcaster)
 id fb722a64-c7d9-4601-a9fb-a5752e9890eb; Tue, 5 Nov 2024 18:32:20 +0000 (UTC)
X-Farcaster-Flow-ID: fb722a64-c7d9-4601-a9fb-a5752e9890eb
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 5 Nov 2024 18:32:20 +0000
Received: from u34cccd802f2d52.amazon.com (10.106.239.17) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 5 Nov 2024 18:32:15 +0000
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
Subject: [PATCH 4/5] arm64: add smp_vcond_load_relaxed()
Date: Tue, 5 Nov 2024 12:30:40 -0600
Message-ID: <20241105183041.1531976-5-harisokn@amazon.com>
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

Implement smp_vcond_load_relaxed() atop __delay_until_ul() on arm64,
to reduce number of busy loops while waiting for a value condition.

This implementation only support unsigned long words. It can be extended
via the enclosed case structure in barrier.h as needed.

Signed-off-by: Haris Okanovic <harisokn@amazon.com>
---
 arch/arm64/include/asm/barrier.h | 18 ++++++++++++++++++
 arch/arm64/lib/delay.c           | 16 ++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 1ca947d5c939..188327e3ce72 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -203,6 +203,24 @@ do {									\
 	(typeof(*ptr))VAL;						\
 })
 
+extern unsigned long __smp_vcond_load_relaxed_ul(
+	u64 nsecs, unsigned long* addr, unsigned long mask, unsigned long val);
+
+#define smp_vcond_load_relaxed(nsecs, addr, mask, val) ({		\
+	u64 __nsecs = (nsecs);						\
+	typeof(addr) __addr = (addr);					\
+	typeof(*__addr) __mask = (mask);				\
+	typeof(*__addr) __val = (val);					\
+	typeof(*__addr) __cur;						\
+	switch (sizeof(*__addr)) {					\
+	case sizeof(unsigned long):					\
+		__cur = __smp_vcond_load_relaxed_ul(			\
+			__nsecs, __addr, __mask, __val);		\
+		break;							\
+	}								\
+	(__cur);							\
+})
+
 #define smp_cond_load_acquire(ptr, cond_expr)				\
 ({									\
 	typeof(ptr) __PTR = (ptr);					\
diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index a7c3040af316..a61a13b04439 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/timex.h>
+#include <linux/sched/clock.h>
 
 #include <clocksource/arm_arch_timer.h>
 #include <asm/readex.h>
@@ -97,3 +98,18 @@ void __ndelay(unsigned long nsecs)
 	__delay(NSECS_TO_CYCLES(nsecs));
 }
 EXPORT_SYMBOL(__ndelay);
+
+unsigned long __smp_vcond_load_relaxed_ul(
+	u64 nsecs, unsigned long* addr, unsigned long mask, unsigned long val)
+{
+	const u64 start = local_clock_noinstr();
+	const u64 cycles = NSECS_TO_CYCLES(nsecs);
+	unsigned long cur;
+
+	do {
+		cur = __delay_until_ul(cycles, addr, mask, val);
+	} while((cur & mask) != val && local_clock_noinstr() - start < nsecs);
+
+	return cur;
+}
+EXPORT_SYMBOL(__smp_vcond_load_relaxed_ul);
-- 
2.34.1


