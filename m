Return-Path: <kvm+bounces-23846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2455D94EE95
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 581081C2168F
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2B0183CC0;
	Mon, 12 Aug 2024 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kqfN1eoj"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF28117C9F9
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470302; cv=none; b=A3nMrirhC9bJ9GzUVrXZWKTEpv0CxmrlKcAdAt31/N4C00Prz5ssbkrc6ni3TcaXyee6MD3KX0XJlPWQ9uMg68wDKqrB5voqMjdW1y2MWdjk22ktxC0+SJdntWhMiDDZOPNaNHHpq6f6GHN2Lzk4Rdeyw2T7QsqtSlfH4GVL3gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470302; c=relaxed/simple;
	bh=yauA6eDczoyHsEMvB/ScoIlvpidBjdOd0bYLDrs8kVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hmod4m+1kLCKJhe/E3ACS1Iws0UxVNXt4QG0ofE7itcMGuyrDd3QnaGTNrmHQDvUQNF5jr91JpFmaXrzJAnP/e91FjA7SUtzqyoqZjCZDuaOBLocphCAq/w9Lp2thL2+fE8GMxUe/+N0KleXQtTXDBsTqaU9zbHZaIZd7rNZI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kqfN1eoj; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JnWydVRlcUj9MsWlBjRPKAbHtiO4c0GMGL7PGlxT7Y=;
	b=kqfN1eojpXs34yYaoOgQt7JdO8JfGcn2+PJWFLEVac7i2RBkt5Inza8z+di1ROKMSrj++o
	u1U5VtGR/AFeJJii3lmlQEUJ1NYhABF+QMs9Ae4vuwQgqzkjq14lg1VTEvUGJ+boDiw/n/
	Ag+SxWzZ3Y6t6OpMro4n/Ejmwdvospg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 1/7] riscv: Fix virt_to_phys again
Date: Mon, 12 Aug 2024 15:44:53 +0200
Message-ID: <20240812134451.112498-10-andrew.jones@linux.dev>
In-Reply-To: <20240812134451.112498-9-andrew.jones@linux.dev>
References: <20240812134451.112498-9-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last fix was a bit hasty since we didn't double check that
virt_to_phys() was the right place for the fix, rather than
virt_to_pte_phys(), and of course it was the latter... All
architectures add on the offset in virt_to_pte_phys() and then
simply wrap virt_to_pte_phys() with virt_to_phys(), if they
implement virt_to_phys() at all. RISCV shouldn't be different.

Fixes: e1dd4ea76894 ("riscv: Fix virt_to_phys")
Fixes: 23100d972705 ("riscv: Enable vmalloc")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index 165a7034bc69..2c9c4f376ac9 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -179,7 +179,7 @@ phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
 	if (!pte_val(*ptep))
 		return 0;
 
-	return __pa(pteval_to_ptep(pte_val(*ptep)));
+	return __pa(pteval_to_ptep(pte_val(*ptep))) | offset_in_page(virt);
 }
 
 unsigned long virt_to_phys(volatile void *address)
@@ -194,7 +194,7 @@ unsigned long virt_to_phys(volatile void *address)
 	paddr = virt_to_pte_phys(pgtable, (void *)address);
 	assert(sizeof(long) == 8 || !(paddr >> 32));
 
-	return (unsigned long)paddr | offset_in_page(address);
+	return (unsigned long)paddr;
 }
 
 void *phys_to_virt(unsigned long address)
-- 
2.45.2


