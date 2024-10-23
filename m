Return-Path: <kvm+bounces-29516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8308D9ACB18
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7D20B2143D
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7E31AE018;
	Wed, 23 Oct 2024 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BQBr5S2s"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651331AC8AE
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689713; cv=none; b=XxpLd5wRwcJVrSZQrZQYNXTt45Jc0UWj8wGmJsoQIJmDaF20WAyfu6NcSGvDXzK005knCg/CaK69xsSbq3VBehHxww7QsA85/4q2oAh+sAgpZ9Q/S2WXA1WG6sRXApCbLXTnl4zDIjiXBGoyhXCSEyz427SFIoak9mdTvLjfcao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689713; c=relaxed/simple;
	bh=MydZWpquF4n+CRZGVxGaYdwOH4b7Q8U/Iy+qcqVU8z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ps4yWf+NGokkiG1m/R45dt/xCnRYTsYxzAGb6F62cGJEyAilT2KYYnhv6MeWoN3vMNCcbR2qlykifkmpf9pxZgAdKbHk1LCQbrqKl/lzu3zI1Kh6/JRtSLo882D7dWINQid/lqEnImlLj3nkZED7KUo22y/Xe+t7VEgY7Qqe5CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BQBr5S2s; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nh3KjWy9iMLDSdx8xjwI08CQw6sxDmd7hGwJRrvc7UY=;
	b=BQBr5S2scTAX50tMufJcEaRHKgZpnuxvgRQu9C1Jd1mV8mWocl9ZFdfJmp/IyoVLry3WUp
	ULv8gkcqYuPVLaCrF4SAGTTSPCmXj6GadHS9EKMk1T3TjiSXachK7D9a+CHsvYJA9clEs9
	8G11q7tXV5VQmWqGBzPRjjjBKQ/JBgU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 4/4] riscv: Rework smp_boot_secondary
Date: Wed, 23 Oct 2024 15:21:35 +0200
Message-ID: <20241023132130.118073-10-andrew.jones@linux.dev>
In-Reply-To: <20241023132130.118073-6-andrew.jones@linux.dev>
References: <20241023132130.118073-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use HSM status to determine when a secondary should be started.
Also save the stack pointer so a secondary may be stopped and
started again without leaking old stacks.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/processor.h |  1 +
 lib/riscv/smp.c           | 49 +++++++++++++++++++++++++++------------
 riscv/cstart.S            |  1 +
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 4063255a3475..401042724cee 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -13,6 +13,7 @@ struct thread_info {
 	int cpu;
 	unsigned long hartid;
 	unsigned long isa[1];
+	unsigned long sp;
 	exception_fn exception_handlers[EXCEPTION_CAUSE_MAX];
 	exception_fn interrupt_handlers[INTERRUPT_CAUSE_MAX];
 };
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index eb7061abfe7f..e92f83e1310d 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -19,8 +19,6 @@ cpumask_t cpu_present_mask;
 cpumask_t cpu_online_mask;
 cpumask_t cpu_idle_mask;
 
-static cpumask_t cpu_started;
-
 secondary_func_t secondary_cinit(struct secondary_data *data)
 {
 	struct thread_info *info;
@@ -37,27 +35,40 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 
 static void __smp_boot_secondary(int cpu, secondary_func_t func)
 {
-	struct secondary_data *sp = alloc_pages(1) + SZ_8K - 16;
-	phys_addr_t sp_phys;
+	void *sp_mem = (void *)cpus[cpu].sp;
+	struct secondary_data *data;
 	struct sbiret ret;
 
-	sp -= sizeof(struct secondary_data);
-	sp->satp = csr_read(CSR_SATP);
-	sp->stvec = csr_read(CSR_STVEC);
-	sp->func = func;
+	if (!sp_mem) {
+		phys_addr_t sp_phys;
+
+		sp_mem = alloc_pages(1) + SZ_8K - 16;
+		sp_phys = virt_to_phys(sp_mem);
+		cpus[cpu].sp = __pa(sp_phys);
 
-	sp_phys = virt_to_phys(sp);
-	assert(sp_phys == __pa(sp_phys));
+		assert(sp_phys == cpus[cpu].sp);
+	}
 
-	ret = sbi_hart_start(cpus[cpu].hartid, (unsigned long)&secondary_entry, __pa(sp_phys));
+	sp_mem -= sizeof(struct secondary_data);
+	data = (struct secondary_data *)sp_mem;
+	data->satp = csr_read(CSR_SATP);
+	data->stvec = csr_read(CSR_STVEC);
+	data->func = func;
+
+	ret = sbi_hart_start(cpus[cpu].hartid, (unsigned long)&secondary_entry, cpus[cpu].sp);
 	assert(ret.error == SBI_SUCCESS);
 }
 
 void smp_boot_secondary(int cpu, void (*func)(void))
 {
-	int ret = cpumask_test_and_set_cpu(cpu, &cpu_started);
+	struct sbiret ret;
 
-	assert_msg(!ret, "CPU%d already boot once", cpu);
+	do {
+		ret = sbi_hart_get_status(cpus[cpu].hartid);
+		assert(!ret.error);
+	} while (ret.value == SBI_EXT_HSM_STOP_PENDING);
+
+	assert_msg(ret.value == SBI_EXT_HSM_STOPPED, "CPU%d is not stopped", cpu);
 	__smp_boot_secondary(cpu, func);
 
 	while (!cpu_online(cpu))
@@ -66,10 +77,18 @@ void smp_boot_secondary(int cpu, void (*func)(void))
 
 void smp_boot_secondary_nofail(int cpu, void (*func)(void))
 {
-	int ret = cpumask_test_and_set_cpu(cpu, &cpu_started);
+	struct sbiret ret;
+
+	do {
+		ret = sbi_hart_get_status(cpus[cpu].hartid);
+		assert(!ret.error);
+	} while (ret.value == SBI_EXT_HSM_STOP_PENDING);
 
-	if (!ret)
+	if (ret.value == SBI_EXT_HSM_STOPPED)
 		__smp_boot_secondary(cpu, func);
+	else
+		assert_msg(ret.value == SBI_EXT_HSM_START_PENDING || ret.value == SBI_EXT_HSM_STARTED,
+			   "CPU%d is in an unexpected state %ld", cpu, ret.value);
 
 	while (!cpu_online(cpu))
 		smp_wait_for_event();
diff --git a/riscv/cstart.S b/riscv/cstart.S
index 687173706d83..b7ee9b9c96b3 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -149,6 +149,7 @@ secondary_entry:
 	csrw	CSR_SSCRATCH, a0
 	mv	sp, a1
 	mv	fp, zero
+	addi	sp, sp, -SECONDARY_DATA_SIZE
 	REG_L	a0, SECONDARY_STVEC(sp)
 	csrw	CSR_STVEC, a0
 	mv	a0, sp
-- 
2.47.0


