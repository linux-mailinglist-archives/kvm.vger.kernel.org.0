Return-Path: <kvm+bounces-8616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D26852CF4
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF42D2880FB
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7697537EF;
	Tue, 13 Feb 2024 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pDp7fdCA"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A84535A0
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817399; cv=none; b=ageFPh9RFT8WuMdlUab94BRAFNAe905HBWJfaIE5Fqe4WGEggmknbN3U5PxnnBfU8KGvhcmC3w0yhOo3WIVWZzLX1NDWHQ6Rqdp9Q74BsX8kWQ/+eAPtBTJqnvfAhXHh60Zrn4pdI9ergZTCM9nQQo9tvmKiBF4zjObFyfnbeb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817399; c=relaxed/simple;
	bh=Sv6AJeH0Hx+RUsbmtZwuRTSHKGXUdMSy3gQCRocBC3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=desjWchIvPuMZHVHF1u1xW0hJ2O/YWADHriHZhI8heHuctNFzPyPXlTM4mxhm+/FlWfZD1JALBdZ6dN1COIOOvP8LNz2Hem8iSTGVe/pUMzyTTPQJYXOPQfZTZm2kdvfdKnI7Fz9CoYVWYS78hWQ1Gm77DVTf8ycXw/Kt+H8YLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pDp7fdCA; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TIA8t073Y1mWOrzngK+gZq8Rv9Ku8mU359Al0v0ZlVo=;
	b=pDp7fdCAMJlgD8V76p/DKAEGmrfeT7I2UsWQvoLbAaKNLUT9y01KmaCeMZdTpFeS02R0Le
	JVNt7gKRp/mnkRddNuxjDZBgW/UEcqz04+uryRzYc036wRnehgDSRuyyN6abFiNmhdWvYG
	pcDSvuPC0fY3JGpzB25sF9KUkpP1R6w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 22/23] KVM: selftests: Hack in support for aligned page allocations
Date: Tue, 13 Feb 2024 09:43:03 +0000
Message-ID: <20240213094303.3962318-1-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Many of the memory allocations handed off to a GIC ITS require 64K
alignment. One would think that requesting 64K of pages would follow
natural alignment in selftests (much like alloc_pages() in the kernel),
however that is unfortunately not the case.

Add a new helper to allow a caller to decide if they want
naturally-aligned page allocations. Deliberately avoid making this the
default in case this subtly breaks assumptions or memory overheads in
other selftests.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 27 ++++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9e5afc472c14..750638cfa849 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -830,6 +830,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_phy_pages_alloc_aligned(struct kvm_vm *vm, size_t num,
+				      vm_paddr_t paddr_min, uint32_t memslot);
 
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e066d584c656..60948a004012 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1984,8 +1984,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+static vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				       vm_paddr_t paddr_min, uint32_t memslot,
+				       bool aligned)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1997,14 +1998,20 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		"  paddr_min: 0x%lx page_size: 0x%x",
 		paddr_min, vm->page_size);
 
+	TEST_ASSERT(!aligned || (paddr_min % vm->page_size * num) == 0,
+		    "Min physical address isn't naturally aligned.\n"
+		    "  paddr_min: 0x%lx page_size: 0x%x num: %lu",
+		    paddr_min, vm->page_size, num);
+
 	region = memslot2region(vm, memslot);
 	base = pg = paddr_min >> vm->page_shift;
 
 	do {
 		for (; pg < base + num; ++pg) {
 			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
+				do {
+					base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
+				} while (aligned && ((pg % num) != 0));
 			}
 		}
 	} while (pg && pg != base + num);
@@ -2024,6 +2031,12 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot, false);
+}
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot)
 {
@@ -2036,6 +2049,12 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 				 vm->memslots[MEM_REGION_PT]);
 }
 
+vm_paddr_t vm_phy_pages_alloc_aligned(struct kvm_vm *vm, size_t num,
+				      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot, true);
+}
+
 /*
  * Address Guest Virtual to Host Virtual
  *
-- 
2.43.0.687.g38aa6559b0-goog


