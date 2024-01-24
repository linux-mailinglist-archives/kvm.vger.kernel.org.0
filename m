Return-Path: <kvm+bounces-6791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A5083A2B9
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22E3B1C24630
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A764E17586;
	Wed, 24 Jan 2024 07:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1+gzvzU"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5878F171B0
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080734; cv=none; b=REhJRyMiyxvteVkm87JROEssR0G3jn0rJZG817EL7/5rkfcEae8ax83vDHvy76qw2nYK6ONcxk8sSDkSgbZDe/j9Tsz+mSG439aLswuJw+ZkWNnl+d0/HdJHN/8sfKqGHaMvnA6u38HKF2gx9BVl4IBgwW4vsdppnbPAgg3XN5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080734; c=relaxed/simple;
	bh=6wo67D93rRbQbtbOQKA4ikUY5Kpj4XTH6WMeyasllNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=SBkKmt14jK1KJFqgGG9cNbHnRqj8h4G/l8um3CiE0AfV5xyACJfzMNuwKfe0kRsK6trbljBSZG9HCPMOSqNvIbuM9xOSZIHcRPnkslGFxkyWzSybWSd+wi0R+lc6NtGOGP80xqhFf9x87jEq5T9FQKRXVQXKf/ZiQ3FooP9YEiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1+gzvzU; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dvVL2+Odv7Es+Ec1hfOJxbvWERsCz+M+dPCEcvi0gWc=;
	b=v1+gzvzUTAm0uDTHxwG4p72GFnwv2MNxL4iSyNhlvs5mv8NSIRcD5YKGCBtHDQwzIb8UMB
	L6cdBXknaNuHOvudDcnZc2wqbZSKFTUN84orjw184jlcpaMbBvbODpFqfNXW4XpvAKiqwI
	uxfnqu4aF8nWJ36o1qgEMVbUQ2+domU=
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
Subject: [kvm-unit-tests PATCH 12/24] arm/arm64: Remove spinlocks from on_cpu_async
Date: Wed, 24 Jan 2024 08:18:28 +0100
Message-ID: <20240124071815.6898-38-andrew.jones@linux.dev>
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

Remove spinlocks from on_cpu_async() by pulling some of their
use into a new function and also by narrowing the locking to a
single on_cpu_info structure by introducing yet another cpumask.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/asm/smp.h |  4 +++-
 lib/arm/smp.c     | 37 ++++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index 9f6d839ab568..f0c0f97a19f8 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -27,9 +27,11 @@ extern bool cpu0_calls_idle;
 extern void halt(void);
 extern void do_idle(void);
 
-extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 extern void on_cpu(int cpu, void (*func)(void *data), void *data);
 extern void on_cpus(void (*func)(void *data), void *data);
 
+extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
+extern void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry);
+
 #endif /* _ASMARM_SMP_H_ */
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index c00fda2efb03..e0872a1a72c2 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -76,12 +76,32 @@ void smp_boot_secondary(int cpu, secondary_entry_fn entry)
 	spin_unlock(&lock);
 }
 
+void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry)
+{
+	spin_lock(&lock);
+	if (!cpu_online(cpu))
+		__smp_boot_secondary(cpu, entry);
+	spin_unlock(&lock);
+}
+
 struct on_cpu_info {
 	void (*func)(void *data);
 	void *data;
 	cpumask_t waiters;
 };
 static struct on_cpu_info on_cpu_info[NR_CPUS];
+static cpumask_t on_cpu_info_lock;
+
+static bool get_on_cpu_info(int cpu)
+{
+	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
+}
+
+static void put_on_cpu_info(int cpu)
+{
+	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
+	assert(ret);
+}
 
 static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
 {
@@ -158,22 +178,21 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
 						"If this is intended set cpu0_calls_idle=1");
 
-	spin_lock(&lock);
-	if (!cpu_online(cpu))
-		__smp_boot_secondary(cpu, do_idle);
-	spin_unlock(&lock);
+	smp_boot_secondary_nofail(cpu, do_idle);
 
 	for (;;) {
 		cpu_wait(cpu);
-		spin_lock(&lock);
-		if ((volatile void *)on_cpu_info[cpu].func == NULL)
-			break;
-		spin_unlock(&lock);
+		if (get_on_cpu_info(cpu)) {
+			if ((volatile void *)on_cpu_info[cpu].func == NULL)
+				break;
+			put_on_cpu_info(cpu);
+		}
 	}
+
 	on_cpu_info[cpu].func = func;
 	on_cpu_info[cpu].data = data;
-	spin_unlock(&lock);
 	set_cpu_idle(cpu, false);
+	put_on_cpu_info(cpu);
 	smp_send_event();
 }
 
-- 
2.43.0


