Return-Path: <kvm+bounces-30925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E27399BE5C4
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6BC42850F2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB1D1DF72D;
	Wed,  6 Nov 2024 11:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S7nJ8xmY"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3411DEFEB
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 11:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893116; cv=none; b=Ohj+Wjo0s1YVaG2xdFuQ0yDENmJYY58pnlTOIli3UEETKOw/gXz6323QwtkyRmqhFDQJot1f8gUTSWGHeVo13ex/n/4fF0vOhvKqfe/UUrWtyhQIoBKzQrdWw9TsutxwgXxo00cXNLsxJDFs1GICF9WdXjDwACSWViO0hBwzfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893116; c=relaxed/simple;
	bh=DFNEoMtxV11E35T3a3MXNMORxXhvZwAf8/xDB0l1wr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqhFEO7vbwMI6awulEYyHsPUP36agceuV0ah+y9tYfCh4lkSOtqiXLzF5FRWL5B18G/7Wkh6+D6ch6z+HcMQZbG3DaYIv8Sp1SxlxSJDTiqniSitOl3YRbqrlnSFWTOsJmvZ3SFYgPWXHGS9PszitDT7bAIMa7h/PcG6EoPVD/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S7nJ8xmY; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730893112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPZ3SUBHEP/krVjbR2O6PIbvJJxePC2EroXXOKSSCDU=;
	b=S7nJ8xmYxMgu5etE4xqwe8IYMoEjgQUGtik2But4/mZBwT9zeFfIhTNGgwZTnBRhqKTjjZ
	nk6YDK4kJKrWGu+npE4tqPwPlDgsR6JfTzlgdrAKeiZXfD13o4+xZoFVexzx4gD9DOqLBr
	4h0UpDGkf0INUPSYAwZwk7KvRsFbb0A=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com,
	atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add two in hart_mask IPI test
Date: Wed,  6 Nov 2024 12:38:18 +0100
Message-ID: <20241106113814.42992-8-andrew.jones@linux.dev>
In-Reply-To: <20241106113814.42992-5-andrew.jones@linux.dev>
References: <20241106113814.42992-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We should ensure that when hart_mask has more than one hartid
that both harts get IPIs with a single call of the IPI function.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index cdf8d13cc9cf..8ccdf42f902a 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -364,10 +364,11 @@ static void check_ipi(void)
 	int nr_cpus_present = cpumask_weight(&cpu_present_mask);
 	int me = smp_processor_id();
 	unsigned long max_hartid = 0;
+	unsigned long hartid1, hartid2;
 	cpumask_t ipi_receivers;
 	static prng_state ps;
 	struct sbiret ret;
-	int cpu;
+	int cpu, cpu2;
 
 	ps = prng_init(0xDEADBEEF);
 
@@ -398,6 +399,42 @@ static void check_ipi(void)
 	ipi_hart_check(&ipi_receivers);
 	report_prefix_pop();
 
+	report_prefix_push("two in hart_mask");
+
+	if (nr_cpus_present < 3) {
+		report_skip("3 cpus required");
+		goto end_two;
+	}
+
+	cpu = rand_online_cpu(&ps);
+	hartid1 = cpus[cpu].hartid;
+	hartid2 = 0;
+	for_each_present_cpu(cpu2) {
+		if (cpu2 == cpu || cpu2 == me)
+			continue;
+		hartid2 = cpus[cpu2].hartid;
+		if (__builtin_labs(hartid2 - hartid1) < BITS_PER_LONG)
+			break;
+	}
+	if (cpu2 == nr_cpus) {
+		report_skip("hartids are too sparse");
+		goto end_two;
+	}
+
+	cpumask_clear(&ipi_done);
+	cpumask_clear(&ipi_receivers);
+	cpumask_set_cpu(cpu, &ipi_receivers);
+	cpumask_set_cpu(cpu2, &ipi_receivers);
+	on_cpu_async(cpu, ipi_hart_wait, (void *)d);
+	on_cpu_async(cpu2, ipi_hart_wait, (void *)d);
+	ret = sbi_send_ipi((1UL << __builtin_labs(hartid2 - hartid1)) | 1UL, hartid1 < hartid2 ? hartid1 : hartid2);
+	report(ret.error == SBI_SUCCESS, "ipi returned success");
+	while (!cpumask_equal(&ipi_done, &ipi_receivers))
+		cpu_relax();
+	ipi_hart_check(&ipi_receivers);
+end_two:
+	report_prefix_pop();
+
 	report_prefix_push("broadcast");
 	cpumask_clear(&ipi_done);
 	cpumask_copy(&ipi_receivers, &cpu_present_mask);
-- 
2.47.0


