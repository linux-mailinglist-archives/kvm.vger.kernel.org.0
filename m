Return-Path: <kvm+bounces-29511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D729ACAF0
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19A63B2333F
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF75B1B4F0C;
	Wed, 23 Oct 2024 13:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d8JTL1cG"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000E01AC458
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689453; cv=none; b=M7KWK/dmetQyttfmXWEGaSO9C6c7kz5Yl90/nHjDguBFmI/JXqJRXzxCPUBulWwDEBwtO4RNSYXqCTQR+xhmwm6Xz5SccY0QOFlhMYR2mgH27oWN1TMeN6Tjhy0zEEz27vG+yyeYFiCK7XUmEu+Xl+a6te/SwSAnzJPYLGZFRqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689453; c=relaxed/simple;
	bh=jPdbXTwp1wvSiTi8oi6fu6OHZh0zLWkywdVsZHJNOYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzK2fDZqny8gAMFhqw5GwGr6mhpthEvRMsp4v5KQmpLYFY0vTwodAXJzoCyqHz9OoWAcKFdqby2TlFFkMkpma0lEetRQJxkC5TxbVJVV8YaMqaPsgZNGJaj2yVrUVUZFV80hx4vyVLlI1nPsrJnGSFcWVgJiVQLwIVTBMspugOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d8JTL1cG; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l02EqjoVbZcAjRJYCFnsAiDgQGfpjHtDxV/1hFAAx5k=;
	b=d8JTL1cGcamsFcXSsTnfwg0zmJhp07O0P+V48OrBInRouEh7PN8TXnTn1jKjXUAEePy9ey
	oVTKD6TlRbW83tlRrrnXgecnzCz93rvxwxxT8pqvlU5p8FpnTZ7eZlv22XoE015fsq5aTt
	+4u9hi9mnMnfPByUZPCu4ZlpXNfvBNg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 2/2] lib/on-cpus: Fix on_cpumask
Date: Wed, 23 Oct 2024 15:17:21 +0200
Message-ID: <20241023131718.117452-6-andrew.jones@linux.dev>
In-Reply-To: <20241023131718.117452-4-andrew.jones@linux.dev>
References: <20241023131718.117452-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

on_cpumask should wait until the cpus in the mask, not including
the calling cpu, are idle. Checking the weight against nr_cpus
minus 1 only works when the mask is the same as the present mask.

Fixes: d012cfd5d309 ("lib/on-cpus: Introduce on_cpumask and on_cpumask_async")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/cpumask.h | 14 ++++++++++++++
 lib/on-cpus.c | 17 ++++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/lib/cpumask.h b/lib/cpumask.h
index e1e92aacd1f1..37d360786573 100644
--- a/lib/cpumask.h
+++ b/lib/cpumask.h
@@ -58,6 +58,20 @@ static inline void cpumask_clear(cpumask_t *mask)
 	memset(mask, 0, sizeof(*mask));
 }
 
+/* true if src1 is a subset of src2 */
+static inline bool cpumask_subset(const struct cpumask *src1, const struct cpumask *src2)
+{
+	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
+	int i;
+
+	for (i = 0; i < BIT_WORD(nr_cpus); ++i) {
+		if (cpumask_bits(src1)[i] & ~cpumask_bits(src2)[i])
+			return false;
+	}
+
+	return !lastmask || !((cpumask_bits(src1)[i] & ~cpumask_bits(src2)[i]) & lastmask);
+}
+
 static inline bool cpumask_empty(const cpumask_t *mask)
 {
 	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
diff --git a/lib/on-cpus.c b/lib/on-cpus.c
index f6072117fa1b..7ce58be0e7e9 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -126,24 +126,23 @@ void on_cpumask_async(const cpumask_t *mask, void (*func)(void *data), void *dat
 void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
 {
 	int cpu, me = smp_processor_id();
+	cpumask_t tmp;
 
-	for_each_cpu(cpu, mask) {
-		if (cpu == me)
-			continue;
+	cpumask_copy(&tmp, mask);
+	cpumask_clear_cpu(me, &tmp);
+
+	for_each_cpu(cpu, &tmp)
 		on_cpu_async(cpu, func, data);
-	}
 	if (cpumask_test_cpu(me, mask))
 		func(data);
 
-	for_each_cpu(cpu, mask) {
-		if (cpu == me)
-			continue;
+	for_each_cpu(cpu, &tmp) {
 		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
 		deadlock_check(me, cpu);
 	}
-	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
+	while (!cpumask_subset(&tmp, &cpu_idle_mask))
 		smp_wait_for_event();
-	for_each_cpu(cpu, mask)
+	for_each_cpu(cpu, &tmp)
 		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
 }
 
-- 
2.47.0


