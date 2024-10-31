Return-Path: <kvm+bounces-30176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 519699B7AE8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8334F1C2196D
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189CC19F411;
	Thu, 31 Oct 2024 12:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v+g3pbxJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D079019CC1F
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378398; cv=none; b=DZn2NsP5UVwJNwjaWpJxtAN0PCKsZyq/52NOQypWvS3xZQhrKdT7r0a/eV+ISonMQPt/jLIS8V7BWaGOrnXjCRyD3H6+Tr7op63o9Gqva+dr22Edu0UH18IhvqGJE62QWAQBY2XlwUU+hOcX/TRYScc44WGSC+EdUpVpSw2/mwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378398; c=relaxed/simple;
	bh=jRU/yFn2oW7xkZzVSpjURvbyXNtflsGkn735wYplPN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD+Nu/IXwRA8G0DwhDOM/1z2aWo08xlNy8rluSGqX1ulQnCEy9qAnpyjJ/mw2KZCtX4A95VVxJ8l/PBhwVmLfl84U8Hltki2IaJl6WtPg5KgKP2sQcy9SL5PWlhlUn0U71I83RR7op3epNQXEhSkVlUw20YoylMZ3n3zO6LAewA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v+g3pbxJ; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730378394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRNGizBmS3No09royYQAbT6P9mobmk6sdA5rSdYfEw8=;
	b=v+g3pbxJitJk62SxyplCt57DrusgyGpM1bvqDyQRLaklC9QaBKdHygl10drdXSH684vIp3
	GhqLtspjbXJAhsVs6+Eg3dXOPrCelIw2fTKba838UV++/PfIoP17ybbv7COMfBwYCvs9bV
	EEXdPyhXFl4pek866OP5Bw/E5sjZu2s=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] lib/on-cpus: Correct and simplify synchronization
Date: Thu, 31 Oct 2024 13:39:50 +0100
Message-ID: <20241031123948.320652-6-andrew.jones@linux.dev>
In-Reply-To: <20241031123948.320652-5-andrew.jones@linux.dev>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

get/put_on_cpu_info() were providing per-cpu locking for the per-cpu
on_cpu info, but it's difficult to reason that they're correct since
they use test_and_set/clear rather than a typical lock. Just revert
to a typical spinlock to simplify it. Also simplify the break case
for on_cpu_async() - we don't care if func is NULL, we only care
that the cpu is idle. And, finally, add a missing barrier to
on_cpu_async(). Before commit 018550041b38 ("arm/arm64: Remove
spinlocks from on_cpu_async") the spin_unlock() provided an implicit
barrier at the correct location, but moving the release to the more
logical location, below the setting of idle, lost it.

Fixes: 018550041b38 ("arm/arm64: Remove spinlocks from on_cpu_async")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/on-cpus.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/lib/on-cpus.c b/lib/on-cpus.c
index 892149338419..f6072117fa1b 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -9,6 +9,7 @@
 #include <on-cpus.h>
 #include <asm/barrier.h>
 #include <asm/smp.h>
+#include <asm/spinlock.h>
 
 bool cpu0_calls_idle;
 
@@ -18,18 +19,7 @@ struct on_cpu_info {
 	cpumask_t waiters;
 };
 static struct on_cpu_info on_cpu_info[NR_CPUS];
-static cpumask_t on_cpu_info_lock;
-
-static bool get_on_cpu_info(int cpu)
-{
-	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
-}
-
-static void put_on_cpu_info(int cpu)
-{
-	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
-	assert(ret);
-}
+static struct spinlock lock;
 
 static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
 {
@@ -81,18 +71,14 @@ void do_idle(void)
 	if (cpu == 0)
 		cpu0_calls_idle = true;
 
-	set_cpu_idle(cpu, true);
-	smp_send_event();
-
 	for (;;) {
+		set_cpu_idle(cpu, true);
+		smp_send_event();
+
 		while (cpu_idle(cpu))
 			smp_wait_for_event();
 		smp_rmb();
 		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
-		on_cpu_info[cpu].func = NULL;
-		smp_wmb();
-		set_cpu_idle(cpu, true);
-		smp_send_event();
 	}
 }
 
@@ -110,17 +96,17 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 
 	for (;;) {
 		cpu_wait(cpu);
-		if (get_on_cpu_info(cpu)) {
-			if ((volatile void *)on_cpu_info[cpu].func == NULL)
-				break;
-			put_on_cpu_info(cpu);
-		}
+		spin_lock(&lock);
+		if (cpu_idle(cpu))
+			break;
+		spin_unlock(&lock);
 	}
 
 	on_cpu_info[cpu].func = func;
 	on_cpu_info[cpu].data = data;
+	smp_wmb();
 	set_cpu_idle(cpu, false);
-	put_on_cpu_info(cpu);
+	spin_unlock(&lock);
 	smp_send_event();
 }
 
-- 
2.47.0


