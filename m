Return-Path: <kvm+bounces-14497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 764BE8A2C6E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 027FAB22729
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4DE54FBE;
	Fri, 12 Apr 2024 10:34:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C5754FA2
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918082; cv=none; b=L6oVBBsJqRHhu1D5g1oqvHtZSbzB2q3PvyzTGEBz8yCXo8M/XPtwR9/H3xQE1QhnrbmeqvtIx1xtRWDCQc6kZvKsqwXoNPhuoDWa+uCt40vouWnifxb5R4ey2GCHdz0aEFSusnbCOXag6Zs6o4DgrPqJGjlhnps5apzUCKYdzjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918082; c=relaxed/simple;
	bh=pZ7mLnD94FsR1K0sTug/9Aicac45RvhW/45TgNmnA8g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O8ijpSaxiZP0dHknTSNWhkqsolGbRdf+hS81uIQwciBV0qQ3xMk+eu5DGBQbL4dtN94g2IxH9LI6BQB4rZx6Tk9u7G7mzcNUJ3n8btsJz5yYaKN/cXNbWw34jDt5iIjtrkQiZiChVozS/fHpnuxXSihTD6vrK+P0owpQAvGCykk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FD80113E;
	Fri, 12 Apr 2024 03:35:10 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6AF7D3F64C;
	Fri, 12 Apr 2024 03:34:39 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 11/33] arm: realm: Set RIPAS state for RAM
Date: Fri, 12 Apr 2024 11:33:46 +0100
Message-Id: <20240412103408.2706058-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A Realm must ensure that the "RAM" region is set to RIPAS_RAM, before any
access is made. This patch makes sure that all memory blocks are marked as
RIPAS_RAM. Also, before we relocate the "FDT" and "initrd", make sure the
target location is marked too. This happens before we parse the memory blocks.

It is OK to do this operation on a given IPA multiple times. So, we don't
exclude the inital image areas from the "target" list.

Also, this operation doesn't require the host to commit physical memory to back
the IPAs yet. It can be done on demand via fault handling.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/setup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index ebd6d058..d726c32a 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -184,6 +184,7 @@ static void mem_init(phys_addr_t freemem_start)
 	while (r && r->end != mem.end)
 		r = memregions_find(r->end);
 	assert(r);
+	arm_set_memory_protected_safe(r->start, r->end - r->start);
 
 	/* Ensure our selected freemem range is somewhere in our full range */
 	assert(freemem_start >= mem.start && freemem->end <= mem.end);
@@ -206,7 +207,14 @@ static void freemem_push_fdt(void **freemem, const void *fdt)
 	assert((unsigned long)fdt > (unsigned long)&stacktop);
 
 	fdt_size = fdt_totalsize(fdt);
+
+	/*
+	 * Before we touch the memory @freemem, make sure it
+	 * is set to protected for Realms.
+	 */
+	arm_set_memory_protected_safe((unsigned long)*freemem, fdt_size);
 	ret = fdt_move(fdt, *freemem, fdt_size);
+
 	assert(ret == 0);
 	ret = dt_init(*freemem);
 	assert(ret == 0);
@@ -222,6 +230,7 @@ static void freemem_push_dt_initrd(void **freemem)
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
 		initrd = *freemem;
+		arm_set_memory_protected_safe((unsigned long)initrd, initrd_size);
 		memmove(initrd, tmp, initrd_size);
 		*freemem += initrd_size;
 	}
-- 
2.34.1


