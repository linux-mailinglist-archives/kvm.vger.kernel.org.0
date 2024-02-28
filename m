Return-Path: <kvm+bounces-10279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD4286B2A7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A19C5B27390
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF0D15D5D2;
	Wed, 28 Feb 2024 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WqJ5LeIu"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0091715D5CA
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132694; cv=none; b=JygO7bqBR0uKp+PP6u4WWGB/HC7IUwGMdTwW7/x4JarvrzKu8k0yVvXQXOnjZSGeEEwlgIJns9/+7z1z33JmARTazqvc/HEWqgJcFBx/F7T8iyurZD2jhLP53JfLk9hiC0n8c3dViVr0kefAMrlwq4XK7bohMlWX46cPqDkAOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132694; c=relaxed/simple;
	bh=/Utm2tQDtCAT2iK1q//ru5gnD+MiMFMB4gCvKo6Bqr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=bn7IPmusPQ6YQwyMTwZe1jE9RFMuYYvjDI1zLwm9G3c1ugw4iAtSGi12un9iMpXQ4lXRMMh52sBZBKqv2oIzHryMn7aJM2v9nAEGrYH3I3ee1T/B7VmOC/mO+xlbnlnOfAkFtdDHQ0eJkzniSSmHSraqyDwh2IHcbgpiwOZuvtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WqJ5LeIu; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Csiy2mam6OUULXjw1JA4n8nLKU/01c1OAjF+6uYUoNc=;
	b=WqJ5LeIuDYAK+Gux47gQVCAvt7BDidqsvJ4uSgo2qSje5HWgjRz9Pb43dVzxHgwcSotUYm
	4TgVv0FrRzkDx9IYaOqjYPQa02oH8xDmBLWpYH1jxWhJlVyy1fZ7SBHUFDAadPK5WzDlgg
	1/20yWI5WKrNKMAkcQV55BV3R9JF+ok=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 10/13] riscv: Refactor setup code
Date: Wed, 28 Feb 2024 16:04:26 +0100
Message-ID: <20240228150416.248948-25-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To prepare for EFI setup, move code that will be shared into
functions. This is the same type of code and the exact same function
names which were created when refactoring Arm's EFI setup, so riscv
setup is still following Arm's setup patterns.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/setup.c | 109 +++++++++++++++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 41 deletions(-)

diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 40ff26a24cfc..f721d81192ac 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -31,6 +31,8 @@
 #define MAX_DT_MEM_REGIONS	16
 #define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + 16)
 
+extern unsigned long _etext;
+
 char *initrd;
 u32 initrd_size;
 
@@ -81,25 +83,12 @@ static void cpu_init(void)
 	cpu0_calls_idle = true;
 }
 
-extern unsigned long _etext;
-
-static void mem_init(phys_addr_t freemem_start)
+static void mem_allocator_init(phys_addr_t freemem_start, phys_addr_t freemem_end)
 {
-	struct mem_region *freemem, *code, *data;
-	phys_addr_t freemem_end, base, top;
-
-	memregions_init(riscv_mem_regions, NR_MEM_REGIONS);
-	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
+	phys_addr_t base, top;
 
-	/* Split the region with the code into two regions; code and data */
-	memregions_split((unsigned long)&_etext, &code, &data);
-	assert(code);
-	code->flags |= MR_F_CODE;
-
-	freemem = memregions_find(freemem_start);
-	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
-
-	freemem_end = freemem->end & PAGE_MASK;
+	freemem_start = PAGE_ALIGN(freemem_start);
+	freemem_end &= PAGE_MASK;
 
 	/*
 	 * The assert below is mostly checking that the free memory doesn't
@@ -129,6 +118,64 @@ static void mem_init(phys_addr_t freemem_start)
 	page_alloc_ops_enable();
 }
 
+static void mem_init(phys_addr_t freemem_start)
+{
+	struct mem_region *freemem, *code, *data;
+
+	memregions_init(riscv_mem_regions, NR_MEM_REGIONS);
+	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
+
+	/* Split the region with the code into two regions; code and data */
+	memregions_split((unsigned long)&_etext, &code, &data);
+	assert(code);
+	code->flags |= MR_F_CODE;
+
+	freemem = memregions_find(freemem_start);
+	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
+
+	mem_allocator_init(freemem_start, freemem->end);
+}
+
+static void freemem_push_fdt(void **freemem, const void *fdt)
+{
+	u32 fdt_size;
+	int ret;
+
+	fdt_size = fdt_totalsize(fdt);
+	ret = fdt_move(fdt, *freemem, fdt_size);
+	assert(ret == 0);
+	ret = dt_init(*freemem);
+	assert(ret == 0);
+	*freemem += fdt_size;
+}
+
+static void freemem_push_dt_initrd(void **freemem)
+{
+	const char *tmp;
+	int ret;
+
+	ret = dt_get_initrd(&tmp, &initrd_size);
+	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+	if (ret == 0) {
+		initrd = *freemem;
+		memmove(initrd, tmp, initrd_size);
+		*freemem += initrd_size;
+	}
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
 static void banner(void)
 {
 	puts("\n");
@@ -141,29 +188,14 @@ static void banner(void)
 void setup(const void *fdt, phys_addr_t freemem_start)
 {
 	void *freemem;
-	const char *bootargs, *tmp;
-	u32 fdt_size;
+	const char *bootargs;
 	int ret;
 
 	assert(sizeof(long) == 8 || freemem_start < VA_BASE);
 	freemem = __va(freemem_start);
 
-	/* Move the FDT to the base of free memory */
-	fdt_size = fdt_totalsize(fdt);
-	ret = fdt_move(fdt, freemem, fdt_size);
-	assert(ret == 0);
-	ret = dt_init(freemem);
-	assert(ret == 0);
-	freemem += fdt_size;
-
-	/* Move the initrd to the top of the FDT */
-	ret = dt_get_initrd(&tmp, &initrd_size);
-	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
-	if (ret == 0) {
-		initrd = freemem;
-		memmove(initrd, tmp, initrd_size);
-		freemem += initrd_size;
-	}
+	freemem_push_fdt(&freemem, fdt);
+	freemem_push_dt_initrd(&freemem);
 
 	mem_init(PAGE_ALIGN(__pa(freemem)));
 	cpu_init();
@@ -174,12 +206,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
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
-- 
2.43.0


