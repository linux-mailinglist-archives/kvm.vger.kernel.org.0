Return-Path: <kvm+bounces-6790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A09B783A2B8
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D40D91C24593
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89177171A7;
	Wed, 24 Jan 2024 07:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MxyvOxko"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E4C168DA
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080731; cv=none; b=TmXABRuWXH3a1y9sLFCqjFWAL6l/8YQCFuB/ooIXZPLrVnlqLcCdjvSj5Q0uhio51fJbFJqA10sfd5Fdj0i6PocqUGqDhql07grSybaGiwxl9Uy0KE+EoNqsYvjVybu6VtJa4JAkDPtbX9bhIXPH+86R+iiw21De3BNHxxRU7k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080731; c=relaxed/simple;
	bh=tClk/5R7ESut3VVlAY0rOaj0ZHY+922asJPxpR1EwCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=kCtZO38p/DG8fmFxPZ0/MI0voXrMdIxL2SMFMH2P/3R1Wf/3+IeNr+sGC59Mt4LTi41guDp57tqGRZ6nAY+Jdh/SaTTEj4eyyj6Pb+qY1QM/p/MWqsLWxJDRVg8KGbwXYmqlePqgg0Buz9ze7ByMgAuP+l7EaCiuHGp7558+4nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MxyvOxko; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1IZ39lZ6JzXUAble/1Vh2nVNaYk86ln+rCUbGyDaitw=;
	b=MxyvOxkoAgFJMyn4GqE8qFI8vdslbKLi6z33vIfaulw8m6ZemnAs5dToO9K0hMVlXDmLDd
	925+5gdYKDII61RQEEb662FUHRubCmupubajbrtCVHHuali5dZn2LVtbkw+rtPwc4dB551
	RxxR/lg8DbiSnKi1ES1VtAIa2KeyoRU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 11/24] arm/arm64: Generalize wfe/sev names in smp.c
Date: Wed, 24 Jan 2024 08:18:27 +0100
Message-ID: <20240124071815.6898-37-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Most of Arm's on_cpus() implementation can be shared by any
architecture which has the possible, present, and idle cpumasks,
like riscv does. Rename the exceptions (wfe/sve) to something
more generic in order to prepare to share the functions.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/asm/smp.h |  4 ++++
 lib/arm/smp.c     | 16 ++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index b89a68dd344f..9f6d839ab568 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -6,6 +6,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <cpumask.h>
+#include <asm/barrier.h>
 #include <asm/thread_info.h>
 
 #define smp_processor_id()		(current_thread_info()->cpu)
@@ -18,6 +19,9 @@ struct secondary_data {
 };
 extern struct secondary_data secondary_data;
 
+#define smp_wait_for_event()	wfe()
+#define smp_send_event()	sev()
+
 extern bool cpu0_calls_idle;
 
 extern void halt(void);
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 78fc1656cefa..c00fda2efb03 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -45,7 +45,7 @@ secondary_entry_fn secondary_cinit(void)
 	 */
 	entry = secondary_data.entry;
 	set_cpu_online(ti->cpu, true);
-	sev();
+	smp_send_event();
 
 	/*
 	 * Return to the assembly stub, allowing entry to be called
@@ -65,7 +65,7 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
 	assert(ret == 0);
 
 	while (!cpu_online(cpu))
-		wfe();
+		smp_wait_for_event();
 }
 
 void smp_boot_secondary(int cpu, secondary_entry_fn entry)
@@ -122,7 +122,7 @@ static void cpu_wait(int cpu)
 	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
 	deadlock_check(me, cpu);
 	while (!cpu_idle(cpu))
-		wfe();
+		smp_wait_for_event();
 	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
 }
 
@@ -134,17 +134,17 @@ void do_idle(void)
 		cpu0_calls_idle = true;
 
 	set_cpu_idle(cpu, true);
-	sev();
+	smp_send_event();
 
 	for (;;) {
 		while (cpu_idle(cpu))
-			wfe();
+			smp_wait_for_event();
 		smp_rmb();
 		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
 		on_cpu_info[cpu].func = NULL;
 		smp_wmb();
 		set_cpu_idle(cpu, true);
-		sev();
+		smp_send_event();
 	}
 }
 
@@ -174,7 +174,7 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 	on_cpu_info[cpu].data = data;
 	spin_unlock(&lock);
 	set_cpu_idle(cpu, false);
-	sev();
+	smp_send_event();
 }
 
 void on_cpu(int cpu, void (*func)(void *data), void *data)
@@ -201,7 +201,7 @@ void on_cpus(void (*func)(void *data), void *data)
 		deadlock_check(me, cpu);
 	}
 	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
-		wfe();
+		smp_wait_for_event();
 	for_each_present_cpu(cpu)
 		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
 }
-- 
2.43.0


