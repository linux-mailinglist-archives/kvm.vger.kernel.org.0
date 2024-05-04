Return-Path: <kvm+bounces-16577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 092D38BBB43
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B44D81F2208F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259D22C1A9;
	Sat,  4 May 2024 12:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OChQbX/P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172202C1A0
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825787; cv=none; b=dRpVOtfwZ4LYenoUhcVvs84EfJiGFHKAhDjd4+2K5elhaYriRSB5qcqxFH0Hm9PxO+2LFLNh0xW3qr+CUrhJE51AQbzdgQmRzYq8WxIJyc7TwMeuKi9oz/CuqvqoRoWUnCyeREYSSYp1EuygS1Q/onJtaxSz+G1JibVu/+d1oNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825787; c=relaxed/simple;
	bh=+esOD28Xrw/oOACu8sjfJ6yuAEFXUf7gOepPYFafkxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5lw55OLCEUlm+s/j3QcFW5nRwQPW2cmsXdUnTisDqLqfCvi8U5ZgTCw2tswUc1F7CQAWds62U+J0/BFd2p4crtVeLC5UyRwNup9jswaqFG9swhmy1tPbc/rAJdjTw4EJgauaE9+QKNno5SIhgCh2DrqaFMBbF8KgxWu2Z+sVak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OChQbX/P; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f44ed6e82fso499921b3a.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825785; x=1715430585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCnyyrhUMJlPFe7cyug7bxp4Z8jcIGiZmkD9LBikPH8=;
        b=OChQbX/Pc8zYY29SONYHtGz3A+if7TYblF3VXXK9ebLRO0XrJETV8MHfa4yXjxKklT
         J2eBDXcz0mukLXqDUINr8mL9VI98igoFuFtloUNWoEECN9gLLLwkL3OD0H700esBNTat
         OkMe5mhPM3XVpuCvxChrx2f/yyas06LyVtWpbpnGdP4rijqusQOI3OH4wiiIJzHLnPS5
         FzYAhzqo8mmGkFOI5YnrL8nlxK35ctt+TjcGsVU8FAtpsCzCCuh9ftTgOPNwSIOiyVOQ
         0rfUWl/eR5tMwbPbmGy7Y1tvdm4N3PmKeGhGkMgy4BgjOTh4OJAcc9vw1cy224o0cMAJ
         3d4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825785; x=1715430585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCnyyrhUMJlPFe7cyug7bxp4Z8jcIGiZmkD9LBikPH8=;
        b=YedEK36GBL98Tt6VruzbN/WYyFVm2WunTBJce6OBiEtdSegx6m63HbBBqZOdmq0H8U
         ENso3+Sao8lcFZ9Mipfo+9pGg4canb+/lkqJ/qZYTESvZyr3B/oY5undy6DuQDnWRAoX
         dAZFi5IuBjUnAxOXF2U9pDSiFR+2+A0S3tMBGE4Tw0/1YRY/JhPuh50iTE+pPaX0Ny3n
         c24wANeP45XBrfq6kDdUq5LI61AyB2GMDwPjKBfaDwsERZxOklOnp4WLXGUr6YG6kShD
         t8mMxH1oHjuLmLnzVvj1hiUcQxH4s7G0qkFkYQFYgrnBQQthJlh2LBhrW/x+avacewc8
         +qxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQXWezhljyYliYZnBb1bG75erqiECVEV0JfCN31dLCWjKBCtUzQCcWVhlizb5mHFvwlnTZiBdTpDCDK4JQ/xI98HaF
X-Gm-Message-State: AOJu0YycrtUQtC/uMUFUsqnQ1YsiYRvIytgFdtmZ45W9Ko1t2eBw6tOQ
	R5r8pkLlLivar0H0oPsmYMkyOYMnf0e8dZGwo9nFlbHLCZHdmd1G
X-Google-Smtp-Source: AGHT+IHpmwlZ1Ova538YiLDhjk47+Mf6xmDk20bCNSb9DMpIy00uqVcKZrw5LeJQK/2vW1ivif+7wA==
X-Received: by 2002:a05:6a00:22c2:b0:6f0:c214:7974 with SMTP id f2-20020a056a0022c200b006f0c2147974mr5985175pfj.12.1714825785325;
        Sat, 04 May 2024 05:29:45 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:44 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 14/31] powerpc: Remove broken SMP exception stack setup
Date: Sat,  4 May 2024 22:28:20 +1000
Message-ID: <20240504122841.1177683-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The exception stack setup does not work correctly for SMP, because
it is the boot processor that calls cpu_set() which sets SPRG2 to
the exception stack, not the target CPU itself. So secondaries
never got their SPRG2 set to a valid exception stack.

Remove the SMP code and just set an exception stack for the boot
processor. Make the stack 64kB while we're here, to match the
size of the regular stack.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/setup.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 9b665f59c..58be93f08 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -42,10 +42,6 @@ struct cpu_set_params {
 	uint64_t tb_hz;
 };
 
-#define EXCEPTION_STACK_SIZE	(32*1024) /* 32kB */
-
-static char exception_stack[NR_CPUS][EXCEPTION_STACK_SIZE];
-
 static void cpu_set(int fdtnode, u64 regval, void *info)
 {
 	static bool read_common_info = false;
@@ -56,10 +52,6 @@ static void cpu_set(int fdtnode, u64 regval, void *info)
 
 	cpus[cpu] = regval;
 
-	/* set exception stack address for this CPU (in SPGR0) */
-	asm volatile ("mtsprg0 %[addr]" ::
-		      [addr] "r" (exception_stack[cpu + 1]));
-
 	if (!read_common_info) {
 		const struct fdt_property *prop;
 		u32 *data;
@@ -180,6 +172,10 @@ static void mem_init(phys_addr_t freemem_start)
 					 ? __icache_bytes : __dcache_bytes);
 }
 
+#define EXCEPTION_STACK_SIZE	SZ_64K
+
+static char boot_exception_stack[EXCEPTION_STACK_SIZE];
+
 void setup(const void *fdt)
 {
 	void *freemem = &stacktop;
@@ -189,6 +185,10 @@ void setup(const void *fdt)
 
 	cpu_has_hv = !!(mfmsr() & (1ULL << MSR_HV_BIT));
 
+	/* set exception stack address for this CPU (in SPGR0) */
+	asm volatile ("mtsprg0 %[addr]" ::
+		      [addr] "r" (boot_exception_stack + EXCEPTION_STACK_SIZE - 64));
+
 	enable_mcheck();
 
 	/*
-- 
2.43.0


