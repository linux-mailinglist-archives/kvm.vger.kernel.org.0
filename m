Return-Path: <kvm+bounces-11036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E963F8724B8
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4630289F98
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F47E17BC2;
	Tue,  5 Mar 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AXZXHZqC"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A0F17991
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657237; cv=none; b=uVnZSUwfP2V0wnchd+dzqvi2TOOXoYC05/86PiSF/SHUpAOfe4AYEp6RwzqB0ixmVRGt43xQk3/qMxa2X1TViqKWQCVKMDZBgReh1gXt3DxhIw752Ih0DTazxjWVEe2Od7TXLz9vNUtRVrelxdBcNPqmJPZKUaq4MUsnAvqevZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657237; c=relaxed/simple;
	bh=XBJZp6ep8E7+cVBx43W9FeQM1BKgBcJ15SCjBL3J220=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=kk63+Wj1w3eUFWECYp1zbjBPH3tyym2PM4vIvWmWsWaEhh0le87N2VBm7RAU9NDOZGm6dGRTAf3zb8h19/FTbb37cv/kAbB2JVr0nrf3b4G1gtaQhDZcYfl2TxsmPzPzg2bWE++RN1cGXM2IdXbo+RVphiwE6FNtMa+vgGVxYbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AXZXHZqC; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJm1m+a6ogkgQ7YvI/xJOAAFGjcodxS9hnq7BUF+HMU=;
	b=AXZXHZqCY0XghW3jF/URRyYKeBvrwwlGMxv/UQ9paHtzEe2qVaeBCiBeI2v8oLmYAwHYsA
	C8FhONQ2TwG5VUXw+FR3esJ83DqA4IiYByn3ljpffg7dAoNycHsa+y5nahUf2WR4nobqDS
	j1pgJFxqtkcK3aMRaSVH0NaCloYepUc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 15/18] arm64: efi: Don't map reserved regions
Date: Tue,  5 Mar 2024 17:46:39 +0100
Message-ID: <20240305164623.379149-35-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We shouldn't need to map all the regions that the EFI memory map
contains. Just map EFI_LOADER_CODE and EFI_LOADER_DATA, since
those are for the loaded unit test, and any region types which
could be used by the unit test for its own memory allocations. We
still map EFI_BOOT_SERVICES_DATA since the primary stack is on a
region of that type. In a later patch we'll switch to a stack we
allocate ourselves to drop that one too.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/mmu.c    | 6 +-----
 lib/arm/setup.c  | 4 ++--
 lib/memregions.c | 8 ++++++++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index eb5e82a95f06..9dce7da85709 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -221,12 +221,8 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 		mmu_idmap = alloc_page();
 
 	for (r = mem_regions; r->end; ++r) {
-		if (r->flags & MR_F_IO) {
+		if (r->flags & (MR_F_IO | MR_F_RESERVED)) {
 			continue;
-		} else if (r->flags & MR_F_RESERVED) {
-			/* Reserved pages need to be writable for whatever reserved them */
-			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
-					   __pgprot(PTE_WBWA));
 		} else if (r->flags & MR_F_CODE) {
 			/* armv8 requires code shared between EL1 and EL0 to be read-only */
 			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index f5dbb48e721a..50a3bb65d865 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -309,8 +309,8 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		data->flags &= ~MR_F_CODE;
 
 	for (struct mem_region *m = mem_regions; m->end; ++m) {
-		if (m != code && (m->flags & MR_F_CODE))
-			m->flags = MR_F_RESERVED;
+		if (m != code)
+			assert(!(m->flags & MR_F_CODE));
 
 		if (!(m->flags & MR_F_IO)) {
 			if (m->start < __phys_offset)
diff --git a/lib/memregions.c b/lib/memregions.c
index 9cdbb639ab62..3c6f751eb4f2 100644
--- a/lib/memregions.c
+++ b/lib/memregions.c
@@ -112,6 +112,14 @@ void memregions_efi_init(struct efi_boot_memmap *mem_map,
 		case EFI_LOADER_CODE:
 			r.flags = MR_F_CODE;
 			break;
+		case EFI_LOADER_DATA:
+			break;
+		case EFI_BOOT_SERVICES_DATA:
+			/*
+			 * FIXME: This would ideally be MR_F_RESERVED, but the
+			 * primary stack is in a region of this EFI type.
+			 */
+			break;
 		case EFI_PERSISTENT_MEMORY:
 			r.flags = MR_F_PERSISTENT;
 			break;
-- 
2.44.0


