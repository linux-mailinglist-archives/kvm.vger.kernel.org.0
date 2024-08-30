Return-Path: <kvm+bounces-25491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F4D965E8D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94E751C22E19
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8146F1B1D50;
	Fri, 30 Aug 2024 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uKbtkh45"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE0918FC93
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 10:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725012753; cv=none; b=qmPyYQlZJfgFlrX79cKHKJNnnwEE/W+7BIrjlFuMyM/w5i9jmrrY4cwUl4bC/8lOUjn4ji2V1QHP3TbU9tk1Gm5OgxM50RyJPU72Uj9rfvKD35g9HA6QafVrzUbmFQVxv3qHiduG9xesfA/6o2s4SIqr85UvFp/jaRmdBxzk+Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725012753; c=relaxed/simple;
	bh=EkVLgyI+PiNCuoF2l5eLwqCpwIwMnyXIvB+/6HuV4rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbxaoYiFAiRK86Wr9fWR+OHBb6m+2O4G4flT4vJiElJZZBfynAvrF1IWi9/gf2tUkF5Jy1rbQ7Oubk/oBYbmjmr06BScJXbKmso3Rr05BTkY/FIoUhe3SfcZ2k6yL7xpq2vRLCObaohj7pKJVts8w3tKomIW1CfUPNFpcVNPYA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uKbtkh45; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725012749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acH8W84ZyAce4P3EP3Hx16y1Mjg34j7uh57mDyDs55E=;
	b=uKbtkh45mr5ph8AZ4VtrJIH0BtSj/D6JcA7ux/i3zC15o7x/+NwMN6WCGlak5SIQxr8bRc
	IMBbomULAF/pn1XO1Nbl9vM2KoCMZYVKOr4B07gTO8GNp3leB79bnM7mot6BV5uack9uw+
	l51p5ZZOQYqBERj6bA+nhJqaF8hrLQM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/3] lib/on-cpus: Introduce on_cpumask and on_cpumask_async
Date: Fri, 30 Aug 2024 12:12:24 +0200
Message-ID: <20240830101221.2202707-7-andrew.jones@linux.dev>
In-Reply-To: <20240830101221.2202707-5-andrew.jones@linux.dev>
References: <20240830101221.2202707-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Provide functions to launch tasks on a selection of cpus identified
by a cpumask.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/on-cpus.c | 35 +++++++++++++++++++++++++++--------
 lib/on-cpus.h |  3 +++
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/lib/on-cpus.c b/lib/on-cpus.c
index aed70f7b27b2..892149338419 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -124,24 +124,32 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 	smp_send_event();
 }
 
-void on_cpu(int cpu, void (*func)(void *data), void *data)
+void on_cpumask_async(const cpumask_t *mask, void (*func)(void *data), void *data)
 {
-	on_cpu_async(cpu, func, data);
-	cpu_wait(cpu);
+	int cpu, me = smp_processor_id();
+
+	for_each_cpu(cpu, mask) {
+		if (cpu == me)
+			continue;
+		on_cpu_async(cpu, func, data);
+	}
+	if (cpumask_test_cpu(me, mask))
+		func(data);
 }
 
-void on_cpus(void (*func)(void *data), void *data)
+void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
 {
 	int cpu, me = smp_processor_id();
 
-	for_each_present_cpu(cpu) {
+	for_each_cpu(cpu, mask) {
 		if (cpu == me)
 			continue;
 		on_cpu_async(cpu, func, data);
 	}
-	func(data);
+	if (cpumask_test_cpu(me, mask))
+		func(data);
 
-	for_each_present_cpu(cpu) {
+	for_each_cpu(cpu, mask) {
 		if (cpu == me)
 			continue;
 		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
@@ -149,6 +157,17 @@ void on_cpus(void (*func)(void *data), void *data)
 	}
 	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
 		smp_wait_for_event();
-	for_each_present_cpu(cpu)
+	for_each_cpu(cpu, mask)
 		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
 }
+
+void on_cpu(int cpu, void (*func)(void *data), void *data)
+{
+	on_cpu_async(cpu, func, data);
+	cpu_wait(cpu);
+}
+
+void on_cpus(void (*func)(void *data), void *data)
+{
+	on_cpumask(&cpu_present_mask, func, data);
+}
diff --git a/lib/on-cpus.h b/lib/on-cpus.h
index 41103b0245c7..4bc6236d6b58 100644
--- a/lib/on-cpus.h
+++ b/lib/on-cpus.h
@@ -2,6 +2,7 @@
 #ifndef _ON_CPUS_H_
 #define _ON_CPUS_H_
 #include <stdbool.h>
+#include <cpumask.h>
 
 extern bool cpu0_calls_idle;
 
@@ -10,5 +11,7 @@ void do_idle(void);
 void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 void on_cpu(int cpu, void (*func)(void *data), void *data);
 void on_cpus(void (*func)(void *data), void *data);
+void on_cpumask_async(const cpumask_t *mask, void (*func)(void *data), void *data);
+void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data);
 
 #endif /* _ON_CPUS_H_ */
-- 
2.45.2


