Return-Path: <kvm+bounces-11034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD178724B6
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C47351F21A6E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B4D17995;
	Tue,  5 Mar 2024 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ov/y7R7u"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812DAD271
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657235; cv=none; b=umNIgBWQHlGN5nnnmhPIRzyPY+Qfu4F55DhNJRHM8BCuYM9EhxwBSR2CgIbJlxJEwSl1JLZ1zDNp3xaMS95o/FltM2bFBrq2CxDE2WNNeN8zkblk03gr2uP5H8titQW+AlN5PwRM2am0SSKNYDnx2knu47PXfhIWtmBfAZzMPcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657235; c=relaxed/simple;
	bh=j1EKqWAzlpHa1+kUnwwWvWM65Jsb0fYM/Z//tj53g+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=ajXf9TWaVS/DTN1+WvMqVCMqoaZp6/qYU01/bIWHIXgBNYjsFPJEBRmXTW+D6TponkCchNzJd1mgCj7jX5SbakkUW/XHwEdPuW060W2X6qog2pMNJaahwyO71sXNg5Dwb/tesRT2B0LUVu/eMDKsjIEhsZ/QjghCqMTVFskZ9cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ov/y7R7u; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dH+fV3gyfx8+OxNIUICQcE5u8Z7VrJ8xj0gMnCCl3o8=;
	b=Ov/y7R7uEwoY6gp23HjZQg9WEPSB6H7UUZc+F4G7x8DD+USoBBXjW3yrthYv/Gzik7TuX6
	v/bJpsqgFNNyZd3jvPfKblpIDOyc6WDqKQ5u223u13pocPZK22/NGZbfoOf5fyAhuHq6UZ
	aVqJrVdhPsI2d2vyQxqtXuhVfUwEPlo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 13/18] arm64: Simplify efi_mem_init
Date: Tue,  5 Mar 2024 17:46:37 +0100
Message-ID: <20240305164623.379149-33-andrew.jones@linux.dev>
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

Reduce the EFI mem_map loop to only setting flags and finding the
largest free memory region. Then, apply memregions_split() for
the code/data region split (which requires ensuring _etext is
page aligned). Finally, do the rest of the things that used to be
done in the EFI mem_map loop in a separate mem_region loop.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/elf_aarch64_efi.lds |  1 +
 lib/arm/setup.c             | 45 +++++++++++++++++--------------------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/arm/efi/elf_aarch64_efi.lds b/arm/efi/elf_aarch64_efi.lds
index 836d98255d88..7a4192b77900 100644
--- a/arm/efi/elf_aarch64_efi.lds
+++ b/arm/efi/elf_aarch64_efi.lds
@@ -13,6 +13,7 @@ SECTIONS
     *(.rodata*)
     . = ALIGN(16);
   }
+  . = ALIGN(4096);
   _etext = .;
   _text_size = . - _text;
   .dynamic  : { *(.dynamic) }
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 7f2043907634..b8c88b5bf011 100644
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
 	if (fdt) {
 		unsigned long old_start = free_mem_start;
 		void *freemem = (void *)free_mem_start;
@@ -380,7 +376,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
 	}
 
-	__phys_end &= PHYS_MASK;
 	asm_mmu_disable();
 
 	if (free_mem_pages == 0)
-- 
2.44.0


