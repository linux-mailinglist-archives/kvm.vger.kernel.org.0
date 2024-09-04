Return-Path: <kvm+bounces-25875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3825596BBB8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9FCB28B45E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCEC61D88C9;
	Wed,  4 Sep 2024 12:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ceZh0HyZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A69A1D88AF
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 12:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725451707; cv=none; b=C2nY1TPJh4tznYfPDjBX7cr2dHyTS/wccW038IRsZoAcgh6lcrCPkan74Vl4iNZsJJWMCr+gNgOmqkTn0KtZjXxTl5kWumd590P6tyw/dkJzqgWnbXlA12WH/XD1s0Ghvk69a+WwEsteXeAeKleOaAkKjG6q0WgSdida/qaUd/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725451707; c=relaxed/simple;
	bh=bFG2FDa9tEWlymKNw56TmGGDzWaKEzCfiyg6afxU3TU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k7i2iU60Tx1DIwzpp2uTxUUw1uLmvHJWbnPdNs7BCRUjlOP4ZOf2Z3ibqedFvCXc8DBhi9Oz1CqM4QQhi6hldntX0JiLlTa1F31Bja1DfnvkHGDQzYyf5xzIYY07Pmqb1jU2TrQvzVKSwwkpQF6qIDf/v/M1Rwa67lPaq7dKO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ceZh0HyZ; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725451702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1FN/cuPZhQTlSUDM6M7twoPiQBEwLUN1Od86oqRrQbw=;
	b=ceZh0HyZdaLSBTeLH2LZamX988oPNas8BYGVFB7xo7qt0C9kZV5upBKyiGjhaSQ550oocV
	XdSR3wGVry1ueVMA6g6zq6mjJ1pacv7dEGdgsyQiazda8Az+Wa57oOc1UyYnnNjIqITP3H
	rvdGEymgNgJCF0R1MUSBcZaDCvVHjIg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] riscv: Fix smp_boot_secondary
Date: Wed,  4 Sep 2024 14:08:13 +0200
Message-ID: <20240904120812.1798715-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last few instructions of secondary_entry had the right concept,
but were the totally wrong implementation. Without setting ra, then,
when the boot function doesn't stay in an infinite loop, like
do_idle() would, we'd go off into the weeds when trying to return
from it. Make sure we set ra to come back to where we can then call
do_idle() instead. The bug was found by inspection since nobody is
calling smp_boot_secondary() with anything other than do_idle() at
this time.

Fixes: 9c92b28e6b7b ("riscv: Add SMP support")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/cstart.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/riscv/cstart.S b/riscv/cstart.S
index a9ac72df4dd2..8f26999759da 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -130,9 +130,9 @@ secondary_entry:
 	mv	a0, sp
 	call	secondary_cinit
 	addi	sp, sp, SECONDARY_DATA_SIZE
-	jr	a0
-	la	a0, do_idle
-	jr	a0
+	jalr	ra, a0
+	call	do_idle
+	j	.	/* unreachable */
 
 /*
  * Save context to address in a0.
-- 
2.46.0


