Return-Path: <kvm+bounces-25274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD0A962D8D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34819B2197D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDA41A4F16;
	Wed, 28 Aug 2024 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BYHqWJjT"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E9F1A4B70
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862134; cv=none; b=MKJkoZNQPtpzCle2v7SLEthITmxtg2+bpjaP2t9sep5naaV+Gc36b862tkxAL4iil2Hfd7kcQlElO1RE/P+hRU6ka+uiaHXWPJXPP3PwgFx93Rl2S3tJFDfCIkl4nkSvJfhK2UXl7mK4uQnfLjh+ii3jp0tbN+StGIttPdmy2O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862134; c=relaxed/simple;
	bh=F2DpSpMD1QNHoM5DzFDACUVb55Fqil98VN1tTLFGdNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8Tei24uAm8NaRIVCxa94eWNhq8Dc0rQkr1agEWScroF9j1WjndxLM1VaRY7OIvvHaQpMf6lchaU0d9a9Jh395OTPefWbnQ5z6JmZenn4JfxxUbr2vvUYyW4xf3bCtZYSjZ90KFZzsUMcXp0RhoBKDWP9gdWIurWXiIKtjoQMfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BYHqWJjT; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724862129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NeWC5wTVvl+NXpTbEp9Dir3lwfIZxO0SfLsx56bqwIs=;
	b=BYHqWJjT1Z28//jQa7QbGLaWAGT6mFDS/wCOE7G13ScAJ1oM0ujtcZK+duQF6vVT09B5QM
	HXH1uokT/Q8KGuFGFpZ8k2JpaczKcPvag6/+xtATXAulxVpwAsllY17yWSz6py76Puq3Il
	s/rQ2dH5G1TDpI186kPeMiru9hWYjFM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/3] riscv: Share sbi_time_ecall with framework
Date: Wed, 28 Aug 2024 18:22:03 +0200
Message-ID: <20240828162200.1384696-7-andrew.jones@linux.dev>
In-Reply-To: <20240828162200.1384696-5-andrew.jones@linux.dev>
References: <20240828162200.1384696-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Setting timers is a useful thing to do for all types of tests. Not
every platform will have Sstc so make the SBI TIME extension
available as well.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h |  1 +
 lib/riscv/sbi.c     |  5 +++++
 riscv/sbi.c         | 13 ++++---------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index a864e268437b..4a35cf38da70 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -67,6 +67,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
 struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
+struct sbiret sbi_set_timer(unsigned long stime_value);
 long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 19d58ab73593..07660e422cbb 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -44,6 +44,11 @@ struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base
 	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
 }
 
+struct sbiret sbi_set_timer(unsigned long stime_value)
+{
+	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
+}
+
 long sbi_probe(int ext)
 {
 	struct sbiret ret;
diff --git a/riscv/sbi.c b/riscv/sbi.c
index e8598fe721a6..85cb7e589bdc 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -35,11 +35,6 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
-static struct sbiret __time_sbi_ecall(unsigned long stime_value)
-{
-	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
-}
-
 static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long arg1, unsigned long arg2)
 {
 	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
@@ -198,7 +193,7 @@ static void timer_irq_handler(struct pt_regs *regs)
 	if (timer_info.mask_timer_irq)
 		timer_irq_disable();
 	else
-		__time_sbi_ecall(ULONG_MAX);
+		sbi_set_timer(ULONG_MAX);
 
 	if (!timer_irq_pending())
 		timer_info.timer_irq_cleared = true;
@@ -217,7 +212,7 @@ static void timer_check_set_timer(bool mask_timer_irq)
 
 	timer_info = (struct timer_info){ .mask_timer_irq = mask_timer_irq };
 	begin = timer_get_cycles();
-	ret = __time_sbi_ecall(begin + d);
+	ret = sbi_set_timer(begin + d);
 
 	report(!ret.error, "set timer%s", mask_test_str);
 	if (ret.error)
@@ -268,10 +263,10 @@ static void check_time(void)
 		report_skip("timer irq enable bit is not writable, skipping mask irq test");
 
 	timer_irq_disable();
-	__time_sbi_ecall(0);
+	sbi_set_timer(0);
 	pending = timer_irq_pending();
 	report(pending, "timer immediately pending by setting timer to 0");
-	__time_sbi_ecall(ULONG_MAX);
+	sbi_set_timer(ULONG_MAX);
 	if (pending)
 		report(!timer_irq_pending(), "pending timer cleared while masked");
 	else
-- 
2.45.2


