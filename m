Return-Path: <kvm+bounces-30769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C7B9BD498
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52CEF1F23447
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8509C1D9A62;
	Tue,  5 Nov 2024 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="accik1HK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812A1E3DE6;
	Tue,  5 Nov 2024 18:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831535; cv=none; b=WJuxbhr76KoOEGahWSuve12GaRQ5JMjAHW2tpS+69njxANIn92Q7pEU1roVtCEy5S+gG34u2Z6pTnZHx8sEHnz1YrNUpmYT9aelPHDWcKavSNUKRXTREeOhzkuj2wvbyrH9r7Kv0t/IZ2qMxhPivkj48sjs/1Uh2l78CGyqT1YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831535; c=relaxed/simple;
	bh=fBp3cBImyKuDZ79nZuK4LWeumA4FRziZpF4LixBVSag=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9OA3ZPwV0eAVnp1+AcrBonWGGYXPTjonhSdmM/iWRJFs28g5UiFdnHmd+Vr8iiPwEAa3j5FBCakMX4dPnfQ0ohhxNRdSQtJFXjvIVgfc6O4EQJ/TwD525Jt3Kg5jIm45P8s5MqrpTVIJUP6z325RS8jCmPjseU2ouudX7frVUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=accik1HK; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730831534; x=1762367534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jU1idzmOqOXlXb1t2IMpZrPTuLA9eFztDBmS3LLVVOw=;
  b=accik1HKQzUKKKqjDWXwXHuwoB92Oc5ZKGojZTYK/l3c82kwqFmkIJIP
   zlR2qB8DacEKx0IVFBAd8mqq32YufSA3YfNbztdnMMTuIrYlaMp/5sbFi
   KfVXUdfbBpKZDAWO5WjygmZQCBR53OQdXPgn4Oxh2kzl3M7NHA8paiGpc
   M=;
X-IronPort-AV: E=Sophos;i="6.11,260,1725321600"; 
   d="scan'208";a="773030717"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:32:13 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:34625]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.28.125:2525] with esmtp (Farcaster)
 id f9c0b0d1-8be1-4e25-ab5f-c68efeaab89c; Tue, 5 Nov 2024 18:32:12 +0000 (UTC)
X-Farcaster-Flow-ID: f9c0b0d1-8be1-4e25-ab5f-c68efeaab89c
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 5 Nov 2024 18:32:12 +0000
Received: from u34cccd802f2d52.amazon.com (10.106.239.17) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 5 Nov 2024 18:32:06 +0000
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
Subject: [PATCH 3/5] arm64: refactor delay() to enable polling for value
Date: Tue, 5 Nov 2024 12:30:39 -0600
Message-ID: <20241105183041.1531976-4-harisokn@amazon.com>
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

Refactor arm64's delay() to poll for a mask/value condition (vcond) in
it's wfet(), wfe(), and relaxed polling loops.

Signed-off-by: Haris Okanovic <harisokn@amazon.com>
---
 arch/arm64/lib/delay.c | 70 ++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index cb2062e7e234..a7c3040af316 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -14,43 +14,73 @@
 #include <linux/timex.h>
 
 #include <clocksource/arm_arch_timer.h>
+#include <asm/readex.h>
 
-#define USECS_TO_CYCLES(time_usecs)			\
-	xloops_to_cycles((time_usecs) * 0x10C7UL)
-
-static inline unsigned long xloops_to_cycles(unsigned long xloops)
+static inline u64 xloops_to_cycles(u64 xloops)
 {
 	return (xloops * loops_per_jiffy * HZ) >> 32;
 }
 
-void __delay(unsigned long cycles)
+#define USECS_TO_XLOOPS(time_usecs) \
+	((time_usecs) * 0x10C7UL)
+
+#define USECS_TO_CYCLES(time_usecs) \
+	xloops_to_cycles(USECS_TO_XLOOPS(time_usecs))
+
+#define NSECS_TO_XLOOPS(time_nsecs) \
+	((time_nsecs) * 0x10C7UL)
+
+#define NSECS_TO_CYCLES(time_nsecs) \
+	xloops_to_cycles(NSECS_TO_XLOOPS(time_nsecs))
+
+static unsigned long __delay_until_ul(u64 cycles, unsigned long* addr, unsigned long mask, unsigned long val)
 {
-	cycles_t start = get_cycles();
+	u64 start = get_cycles();
+	unsigned long cur;
 
 	if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
 		u64 end = start + cycles;
 
-		/*
-		 * Start with WFIT. If an interrupt makes us resume
-		 * early, use a WFET loop to complete the delay.
-		 */
-		wfit(end);
-		while ((get_cycles() - start) < cycles)
+		do {
+			cur = __READ_ONCE_EX(*addr);
+			if ((cur & mask) == val) {
+				break;
+			}
 			wfet(end);
-	} else 	if (arch_timer_evtstrm_available()) {
-		const cycles_t timer_evt_period =
+		} while ((get_cycles() - start) < cycles);
+	} else if (arch_timer_evtstrm_available()) {
+		const u64 timer_evt_period =
 			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
 
-		while ((get_cycles() - start + timer_evt_period) < cycles)
+		do {
+			cur = __READ_ONCE_EX(*addr);
+			if ((cur & mask) == val) {
+				break;
+			}
 			wfe();
+		} while ((get_cycles() - start + timer_evt_period) < cycles);
+	} else {
+		do {
+			cur = __READ_ONCE_EX(*addr);
+			if ((cur & mask) == val) {
+				break;
+			}
+			cpu_relax();
+		} while ((get_cycles() - start) < cycles);
 	}
 
-	while ((get_cycles() - start) < cycles)
-		cpu_relax();
+	return cur;
+}
+
+void __delay(unsigned long cycles)
+{
+	/* constant word for wfet()/wfe() to poll */
+	unsigned long dummy ____cacheline_aligned = 0;
+	__delay_until_ul(cycles, &dummy, 0, 1);
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	__delay(xloops_to_cycles(xloops));
 }
@@ -58,12 +88,12 @@ EXPORT_SYMBOL(__const_udelay);
 
 void __udelay(unsigned long usecs)
 {
-	__const_udelay(usecs * 0x10C7UL); /* 2**32 / 1000000 (rounded up) */
+	__delay(USECS_TO_CYCLES(usecs));
 }
 EXPORT_SYMBOL(__udelay);
 
 void __ndelay(unsigned long nsecs)
 {
-	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
+	__delay(NSECS_TO_CYCLES(nsecs));
 }
 EXPORT_SYMBOL(__ndelay);
-- 
2.34.1


