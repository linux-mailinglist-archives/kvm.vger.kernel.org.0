Return-Path: <kvm+bounces-30178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9AE49B7AEC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA0A1C21CD2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB07419B5B2;
	Thu, 31 Oct 2024 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QOYvY2te"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A7F19D88B
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378409; cv=none; b=V3EIe51WEOtIx6wAvuPkPLn04Om3KzjOLZzKTThTsGkYG6Bpr25y7loE19tQwMfJhBPFSCsxjvQKut/CPA5+DTS9sVcb4ks7Wd+EQJ8J5fZK4SLwyz39kEVu4e5cHUTjBUHznXQnbpbomfeqv1c+rAq12aLn7EvZttOeyA4VkS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378409; c=relaxed/simple;
	bh=45mFK8dbXqcCxVdhie6fBxKUKT0j+gp5Slggxqk4QyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxOZg1g0sf25anAAlMKGlMtMnAiEMVtRE/1w5DXUrSkLISTPgnL+iEkLOvv1UQz4jpKohCoBrBsetA2HL41j9LEJtwnJW1nbV0UKTWhU8TGdyuw1yTqGgGns9lRi6cJQcXlhLpPpkiwTBbZJ6FpAhZQNruPxRElc7aXVvhm9Rr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QOYvY2te; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730378403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPzKqk+gmXmf2DgmdqtxmOjA4rFHvz5nJ0CLZ7ibfGU=;
	b=QOYvY2teA3lbxD5oJXtk2VS+8rcW5OtSF48WZpf0IwCLxps2ImseheTTJtbqb8Lmgz5frh
	fbClSfucZRA9Iq74THC3oycjnw2t+biFrGiZdBhJ+VaGLZaiLbKLPIX5QG+S3UdmIlIBZI
	pGyj3mRmqXO/el8HsEob8G/tUGj7ww8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/3] lib/on-cpus: Fix on_cpumask
Date: Thu, 31 Oct 2024 13:39:52 +0100
Message-ID: <20241031123948.320652-8-andrew.jones@linux.dev>
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
index 356f284be61b..889b6bc8a186 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -127,24 +127,23 @@ void on_cpumask_async(const cpumask_t *mask, void (*func)(void *data), void *dat
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
 	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
 }
-- 
2.47.0


