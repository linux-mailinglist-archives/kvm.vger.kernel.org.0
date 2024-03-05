Return-Path: <kvm+bounces-11032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE468724B2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E6BA1C21A5D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6DB17579;
	Tue,  5 Mar 2024 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wOTt9O0L"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F92412B95
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657223; cv=none; b=ELB2PZaQPI/nwFiPXWcl8aRc7ef5hjxPuWj0cwC1Nb/Sl+0G3uCYXknCx5B88bBt0Uyz4zmdpdnI5dzshcdqNqfj++zlasfrYEE3MTTZ00VrSruRU93U0MB/xasBIuFWo7amfv0iN4bwnhArzxTnNCGfB8R7OMPlWdDEwHDbVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657223; c=relaxed/simple;
	bh=BRyzR1N6qoiuhdGPe3Cildp1pqOUJI+St6VAbDZtbpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Lay9Jdblvqx3tzSWj2Ff5zyl50nSSvJgGtOKw9hz+///LWcBn/t0ChKbdH020n8Zd7K8Hig/3kLNgtr9bfoG0798dyOl7XKmYn446I+Dpe6/I042yTplxAnF4BO5GtjN2phB8S08+lBIp9hWAhMLSsiO59garYYwlUBBv1bHKtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wOTt9O0L; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dqc8QWk0JmKETB1/0K1/J4fZdeEt4YcHxzr8v1+J8yM=;
	b=wOTt9O0Lcm3ypMms9VBtAIinC0mxuJpeXabPXeoyZJmKhEhREOmlaiaWBfs5zFkqcUGYoZ
	DK2Y5u4IpxNp//X8ernPGLtfaWSf1PPHtu9QVla4VLra+4y3ltR6u1mDEPCy1Oq2Kv4QIx
	mEbznVRdxX+kKOidk9iIQcSz/eSWMjc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 11/18] arm/arm64: Factor out some initial setup
Date: Tue,  5 Mar 2024 17:46:35 +0100
Message-ID: <20240305164623.379149-31-andrew.jones@linux.dev>
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

Factor out some initial setup code into separate functions in order
to share more code between setup() and setup_efi().

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 82 +++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 0382cbdaf5a1..80f952377cf9 100644
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
@@ -342,15 +361,15 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		}
 		memregions_add(&r);
 	}
+
 	if (fdt) {
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
@@ -418,13 +437,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
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
2.44.0


