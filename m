Return-Path: <kvm+bounces-23547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B50FA94AC93
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DEDAB24C9B
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B367584A46;
	Wed,  7 Aug 2024 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fg5NgsoJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCA078291
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043807; cv=none; b=VheG+P1cduALYxiAHAXXdvTzG8YqEa8BC4Yck847JEop8uys1UJYDRnmiBetUc/7yeFl6v59XgX3V0pJPmyMMu8im70Gwolwp6N4QNw7mI1AjnAY32HdSs6joe5HGWZMGvw/zjzH82f58vvDY4VhrLzRiAK9RKiIZ0waw1rYquM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043807; c=relaxed/simple;
	bh=yauA6eDczoyHsEMvB/ScoIlvpidBjdOd0bYLDrs8kVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3mrwH/Ujbs9qRCr7LHEtXwMEKAl4WTvP4sf8cjLUNNom+OTS0y4PAmNeKJXkKtn34osQVugwMfsZ489vhP7TCriae/xadf5Tikc8f1kz+cC2Tx7SciB3ysj2Rr/DFSd73eI9a434gMhMl+CGhPh9HSW6zcfIqGcL00h5sE1AZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fg5NgsoJ; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723043803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JnWydVRlcUj9MsWlBjRPKAbHtiO4c0GMGL7PGlxT7Y=;
	b=Fg5NgsoJGBQLwal8r4tS97dNmfiatXZJdjpoo1nO5VjIz7WBTp5KVLkLOD4Jx2Wi7BKaV7
	uwFAFvZsI6c869zXzNpZWMkqSLvy7p8ht12cyW0sag+FPBq46gyrdXZ6Dh97MonrJsFEfh
	86JpRJ9yCUQ+OdKobsJtZxuwk7SB3zo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] riscv: Fix virt_to_phys again
Date: Wed,  7 Aug 2024 17:16:31 +0200
Message-ID: <20240807151629.144168-6-andrew.jones@linux.dev>
In-Reply-To: <20240807151629.144168-5-andrew.jones@linux.dev>
References: <20240807151629.144168-5-andrew.jones@linux.dev>
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


