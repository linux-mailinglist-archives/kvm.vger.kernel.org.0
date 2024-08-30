Return-Path: <kvm+bounces-25490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBA08965E86
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 272F9B20EF9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF1D1AF4E4;
	Fri, 30 Aug 2024 10:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dJPwSQf0"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC518FC9F
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725012751; cv=none; b=MYLsb8e67e08Kg6B8a28cRtOGGp3sZZsIqwC9KvuofEaHJGLfMLbQ5CQeEYXPPAzx7h9a9Jl/ssfnv5Bv5G9N27Dfmix0nH9rFIooUAq1RHEPmxp9q0FD0JM6JsuXdUMdQcTtp9hkZhrJjLu/IaMzAGsOzV6im3ZYBLh8J7JGJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725012751; c=relaxed/simple;
	bh=7jPlGbTB7MxeJTqNMRDYok689EzX7DiIR1j2PXQvRuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoY1C5Lb8bahvV4XZOdF5mB8l1V3tAP1ChnjNgWdPLpVwV29sJbKz00GJ+sg9YNo1P0rsWCfoVAhQ6hyKKLOIRlDWpX3x1msy1/OYOJcxtCVNSzT+MNBrGpu/CayHDvOXesg5rLzW+B+mcZTf0rKTmrMv1vz37ScOII0adcXhug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dJPwSQf0; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725012747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIgN50Nk075398eDAbRkYLwA2xDhb8GOYDf57SqqBH0=;
	b=dJPwSQf0Vp5OjfDDhbQJX3sDW8KebG5wzdae6eg7BhDdk/sMqleus0lqlwLsqjaQupo5YM
	29aMYSYmjojuKUdFrwB5NSZbVFpF9Aq4OwRpYdNjcfSrkAiPv8mZFVpfOpxCRKGbfWbUN/
	n6W0tE/DygYj7jrigOlRsHaa84KVzag=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] lib/cpumask: Fix and simplify a few functions
Date: Fri, 30 Aug 2024 12:12:23 +0200
Message-ID: <20240830101221.2202707-6-andrew.jones@linux.dev>
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

Simplify cpumask_setall and cpumask_clear by just using memset. Also
simplify cpumask_empty and cpumask_full. This is a fix for
cpumask_empty as it would have reported non-empty for cpumasks that
had uninitialized junk following nr_cpus when nr_cpus < NR_CPUS.
There aren't currently any users of cpumask_empty though so that bug
has never appeared. cpumask_full was just convoluted and can now
follow cpumask_empty's new pattern. I've already yelled at a mirror
to scold the author of the original implementations!

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/cpumask.h | 47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/lib/cpumask.h b/lib/cpumask.h
index be1919234d8e..e1e92aacd1f1 100644
--- a/lib/cpumask.h
+++ b/lib/cpumask.h
@@ -6,8 +6,9 @@
  */
 #ifndef _CPUMASK_H_
 #define _CPUMASK_H_
-#include <asm/setup.h>
 #include <bitops.h>
+#include <limits.h>
+#include <asm/setup.h>
 
 #define CPUMASK_NR_LONGS ((NR_CPUS + BITS_PER_LONG - 1) / BITS_PER_LONG)
 
@@ -49,46 +50,34 @@ static inline int cpumask_test_and_clear_cpu(int cpu, cpumask_t *mask)
 
 static inline void cpumask_setall(cpumask_t *mask)
 {
-	int i;
-	for (i = 0; i < nr_cpus; i += BITS_PER_LONG)
-		cpumask_bits(mask)[BIT_WORD(i)] = ~0UL;
-	i -= BITS_PER_LONG;
-	if ((nr_cpus - i) < BITS_PER_LONG)
-		cpumask_bits(mask)[BIT_WORD(i)] = BIT_MASK(nr_cpus - i) - 1;
+	memset(mask, 0xff, sizeof(*mask));
 }
 
 static inline void cpumask_clear(cpumask_t *mask)
 {
-	int i;
-	for (i = 0; i < nr_cpus; i += BITS_PER_LONG)
-		cpumask_bits(mask)[BIT_WORD(i)] = 0UL;
+	memset(mask, 0, sizeof(*mask));
 }
 
 static inline bool cpumask_empty(const cpumask_t *mask)
 {
-	int i;
-	for (i = 0; i < nr_cpus; i += BITS_PER_LONG) {
-		if (i < NR_CPUS) { /* silence crazy compiler warning */
-			if (cpumask_bits(mask)[BIT_WORD(i)] != 0UL)
-				return false;
-		}
-	}
-	return true;
+	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
+
+	for (int i = 0; i < BIT_WORD(nr_cpus); ++i)
+		if (cpumask_bits(mask)[i])
+			return false;
+
+	return !lastmask || !(cpumask_bits(mask)[BIT_WORD(nr_cpus)] & lastmask);
 }
 
 static inline bool cpumask_full(const cpumask_t *mask)
 {
-	int i;
-	for (i = 0; i < nr_cpus; i += BITS_PER_LONG) {
-		if (cpumask_bits(mask)[BIT_WORD(i)] != ~0UL) {
-			if ((nr_cpus - i) >= BITS_PER_LONG)
-				return false;
-			if (cpumask_bits(mask)[BIT_WORD(i)]
-					!= BIT_MASK(nr_cpus - i) - 1)
-				return false;
-		}
-	}
-	return true;
+	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
+
+	for (int i = 0; i < BIT_WORD(nr_cpus); ++i)
+		if (cpumask_bits(mask)[i] != ULONG_MAX)
+			return false;
+
+	return !lastmask || (cpumask_bits(mask)[BIT_WORD(nr_cpus)] & lastmask) == lastmask;
 }
 
 static inline int cpumask_weight(const cpumask_t *mask)
-- 
2.45.2


