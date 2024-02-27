Return-Path: <kvm+bounces-10126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5755586A017
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E60C41F2D523
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF87214A081;
	Tue, 27 Feb 2024 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U5Bq4CRT"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC7B1487D6
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061722; cv=none; b=OOMiwODJ1NPUfxMjkz9i1lX5fH33AOak0Q0JZNfiZU26a67fOPLskYDCLMekalrbZfuwFWYaHe9wAmsMYLYatk89AE3aqGifgpGY6kpiAHVu9PYZWW0CT/BU4PdGl+8R4zl9Dt+9aWMRrZsXul22AEY/zW3maCG+bCeOqIrP8u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061722; c=relaxed/simple;
	bh=4sTNAa6MnoYrfkKq/iDV5maKOG8CDnDHXU6m+7P7+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=CBwc7D7y76KQX5u3n1jahmE0qwI3v+T5Wt2lj4wG1ZhxkmG6C6X4CviMYEmQCKgd7Uu/BgVLSZzuFEzLH1z3Bkb70EVyzYvXlqvm0SoUS+HV1oRIklYyXA7nW1Zm0DT9wBI8CCVTkdDc1lIt9W63YsDoKTxUZVYmhHBZycPzw0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U5Bq4CRT; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOyBAmSuH+i2SPph24jGVrUxKJ627tNATtbobG5uL1c=;
	b=U5Bq4CRT58It7Wp3kldrfPMWl/xN3k7JF9oDHgaT/up544G5kt9AFl38Qt1AfWZ3Kp1ujx
	lVFDpiovdFhxwsvlnyT+fW7xmaubiebpfxtUdA+s+Mf6y/CzCAnEN3YrpsAEhsDU3dsT+5
	9tN0ypFs5Ee4ZH21cw7hunlJKy8nzqM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 11/18] arm/arm64: Factor out some initial setup
Date: Tue, 27 Feb 2024 20:21:21 +0100
Message-ID: <20240227192109.487402-31-andrew.jones@linux.dev>
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

Factor out some initial setup code into separate functions in order
to share more code between setup() and setup_efi().

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 81 ++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 76aae4627a7b..f96ee04ddd68 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -182,32 +182,57 @@ static void mem_init(phys_addr_t freemem_start)
 	page_alloc_ops_enable();
 }
 
-void setup(const void *fdt, phys_addr_t freemem_start)
+static void freemem_push_fdt(void **freemem, const void *fdt)
 {
-	void *freemem;
-	const char *bootargs, *tmp;
 	u32 fdt_size;
 	int ret;
 
-	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
-	freemem = (void *)(unsigned long)freemem_start;
-
-	/* Move the FDT to the base of free memory */
 	fdt_size = fdt_totalsize(fdt);
-	ret = fdt_move(fdt, freemem, fdt_size);
+	ret = fdt_move(fdt, *freemem, fdt_size);
 	assert(ret == 0);
-	ret = dt_init(freemem);
+	ret = dt_init(*freemem);
 	assert(ret == 0);
-	freemem += fdt_size;
+	*freemem += fdt_size;
+}
+
+static void freemem_push_dt_initrd(void **freemem)
+{
+	const char *tmp;
+	int ret;
 
-	/* Move the initrd to the top of the FDT */
 	ret = dt_get_initrd(&tmp, &initrd_size);
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
-		initrd = freemem;
+		initrd = *freemem;
 		memmove(initrd, tmp, initrd_size);
-		freemem += initrd_size;
+		*freemem += initrd_size;
 	}
+}
+
+static void initrd_setup(void)
+{
+	char *env;
+
+	if (!initrd)
+		return;
+
+	/* environ is currently the only file in the initrd */
+	env = malloc(initrd_size);
+	memcpy(env, initrd, initrd_size);
+	setup_env(env, initrd_size);
+}
+
+void setup(const void *fdt, phys_addr_t freemem_start)
+{
+	void *freemem;
+	const char *bootargs;
+	int ret;
+
+	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
+	freemem = (void *)(unsigned long)freemem_start;
+
+	freemem_push_fdt(&freemem, fdt);
+	freemem_push_dt_initrd(&freemem);
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
 	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
@@ -229,12 +254,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	setup_args_progname(bootargs);
 
-	if (initrd) {
-		/* environ is currently the only file in the initrd */
-		char *env = malloc(initrd_size);
-		memcpy(env, initrd, initrd_size);
-		setup_env(env, initrd_size);
-	}
+	initrd_setup();
 
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
@@ -277,7 +297,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
 	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
 	const void *fdt = efi_bootinfo->fdt;
-	int fdt_size, ret;
 
 	/*
 	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
@@ -344,14 +363,13 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	}
 
 	if (efi_bootinfo->fdt_valid) {
-		/* Move the FDT to the base of free memory */
-		fdt_size = fdt_totalsize(fdt);
-		ret = fdt_move(fdt, (void *)free_mem_start, fdt_size);
-		assert(ret == 0);
-		ret = dt_init((void *)free_mem_start);
-		assert(ret == 0);
-		free_mem_start += ALIGN(fdt_size, EFI_PAGE_SIZE);
-		free_mem_pages -= ALIGN(fdt_size, EFI_PAGE_SIZE) >> EFI_PAGE_SHIFT;
+		unsigned long old_start = free_mem_start;
+		void *freemem = (void *)free_mem_start;
+
+		freemem_push_fdt(&freemem, fdt);
+
+		free_mem_start = ALIGN((unsigned long)freemem, EFI_PAGE_SIZE);
+		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
 	}
 
 	__phys_end &= PHYS_MASK;
@@ -419,13 +437,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	io_init();
 
 	timer_save_state();
-	if (initrd) {
-		/* environ is currently the only file in the initrd */
-		char *env = malloc(initrd_size);
 
-		memcpy(env, initrd, initrd_size);
-		setup_env(env, initrd_size);
-	}
+	initrd_setup();
 
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
-- 
2.43.0


