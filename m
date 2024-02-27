Return-Path: <kvm+bounces-10128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AEED86A01A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CE891C2486E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075071487D8;
	Tue, 27 Feb 2024 19:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YXkK9xvL"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A356151C5C
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061731; cv=none; b=s3M0C+v7kSw4r8TuJMzISzYYQwzIfoNZwvsW9Ze/d7Yo95++l4eI/pjj5kc04X06l89WzO81X1QhXGjujnMt9xzrivZSFCg0LieuiI8emOhIfznm8lwArj+ELRWWCv62TVEgwuJgx+LWfa0nosftM9mVATODcI5fn9pEC/oncFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061731; c=relaxed/simple;
	bh=MTPlTatfIghDuZ553cISvbEgjkp8435gVtWr1e6Hliw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=mrY5q/rvVnB5Cg2FgzeSyK7K/++4LH4wlcIkvMagvfg0AY6+eIAJIRlQx5csvOZKyXPrwoVwLxxakSG+QX9qnQasI/2g0w6iEz5iCeZH4a0xyLytA4pYEoGB4d5UlnjaUE8ROy3vXOZ8ByA9ZsU8sUcH2faeKBxZg4knUMWgkNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YXkK9xvL; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PBD1ohiKpXGdC4CTOzC92NNH+OTPx9G6EKUZO37Av4c=;
	b=YXkK9xvLW0CCNieGdY2TUB0tjN0/T5b+nJuyJl2zRa9nrFklK/4PtP3lMJhDpUEf/2R3Po
	OCTRbT3UM+zZttLLERb0NbhKW0CtuNCpTjocqgCwwfZfYyjVGu8pBdWoPipM7VTEEkOZkE
	xyfxakWeIe2G8cuYkofJW600m7nd608=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 13/18] arm64: Simplify efi_mem_init
Date: Tue, 27 Feb 2024 20:21:23 +0100
Message-ID: <20240227192109.487402-33-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reduce the EFI mem_map loop to only setting flags and finding the
largest free memory region. Then, apply memregions_split() for
the code/data region split and do the rest of the things that
used to be done in the EFI mem_map loop in a separate mem_region
loop.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index d0be4c437708..631597b343f1 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -301,9 +301,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
 	efi_memory_desc_t *buffer = *map->map;
 	efi_memory_desc_t *d = NULL;
-	struct mem_region r;
-	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
-	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
+	struct mem_region r, *code, *data;
 	const void *fdt = efi_bootinfo->fdt;
 
 	/*
@@ -337,21 +335,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 			r.flags = MR_F_IO;
 			break;
 		case EFI_LOADER_CODE:
-			if (r.start <= text && r.end > text) {
-				/* This is the unit test region. Flag the code separately. */
-				phys_addr_t tmp = r.end;
-
-				assert(etext <= data);
-				assert(edata <= r.end);
-				r.flags = MR_F_CODE;
-				r.end = data;
-				memregions_add(&r);
-				r.start = data;
-				r.end = tmp;
-				r.flags = 0;
-			} else {
-				r.flags = MR_F_RESERVED;
-			}
+			r.flags = MR_F_CODE;
 			break;
 		case EFI_CONVENTIONAL_MEMORY:
 			if (free_mem_pages < d->num_pages) {
@@ -361,15 +345,27 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 			break;
 		}
 
-		if (!(r.flags & MR_F_IO)) {
-			if (r.start < __phys_offset)
-				__phys_offset = r.start;
-			if (r.end > __phys_end)
-				__phys_end = r.end;
-		}
 		memregions_add(&r);
 	}
 
+	memregions_split((unsigned long)&_etext, &code, &data);
+	assert(code && (code->flags & MR_F_CODE));
+	if (data)
+		data->flags &= ~MR_F_CODE;
+
+	for (struct mem_region *m = mem_regions; m->end; ++m) {
+		if (m != code && (m->flags & MR_F_CODE))
+			m->flags = MR_F_RESERVED;
+
+		if (!(m->flags & MR_F_IO)) {
+			if (m->start < __phys_offset)
+				__phys_offset = m->start;
+			if (m->end > __phys_end)
+				__phys_end = m->end;
+		}
+	}
+	__phys_end &= PHYS_MASK;
+
 	if (efi_bootinfo->fdt_valid) {
 		unsigned long old_start = free_mem_start;
 		void *freemem = (void *)free_mem_start;
@@ -380,7 +376,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
 	}
 
-	__phys_end &= PHYS_MASK;
 	asm_mmu_disable();
 
 	if (free_mem_pages == 0)
-- 
2.43.0


