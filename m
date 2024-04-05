Return-Path: <kvm+bounces-13661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 241A8899803
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3E422886DE
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C0B15FD0C;
	Fri,  5 Apr 2024 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SR6D8fiD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B4145B09
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306237; cv=none; b=ox9nR815rPVFZjHMH31MbWciSld5GNKB7pPUu/j6wCG94VGnsjSlXG6oCSCuj6UfKlZ8uPS91xmDCNBnsFb8JtcYS1LDAeLcqoAm0wwC928izc4Nmpe9M/gHBt/HA/A6NCLjsZTFf61Im0gK13q3x7jyO/ZbQ+diOx7wrsKAThU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306237; c=relaxed/simple;
	bh=V1c2UIEnPXrwqACWciLzGfJgkj2oxvNvvQtouc/639c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsGZ6tZBAxMrek01t4U/BqG6cF2samN+9npEwc2g0qAq2vDhv99khuHMdLF8GLHpPHdlECig6JGl+jSyNh9bjU5VcYBwwLio0NXIiGF6r7L2/xe7WeyjD9BVYWXECXh6Cq3OYSc2BoFz9RD8t91e0eCu2eo8w2JrYHCzpgoSBhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SR6D8fiD; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e0f43074edso1169432a34.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306235; x=1712911035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtLrnSXqdt678CiS0tNUCc+5b/rRAvRjP5Z8cb4bKlQ=;
        b=SR6D8fiDOMly5BVrjyK7d7+2yL471GAwk1VVHmmKkDw4J7J9igDAhdSe4rBx7peN6A
         pjtjiyTThtXHaPuPrvhetgId7Eky44XoT43RDipzIux3z5S2aWpy3rU5+chWhJ4Q2l9P
         ojkHuFdpEbccU8E2xyjUg+IS1wd5sEvVdlUqI0fuPr2TR0hS39DML5dusZwFwT7TnEbX
         agvco404NCZAC007RVbfJCFUgQDUP05UlaP/WIRAr+rPFWvO3y2PCj3Kmb1P4FTmSWZH
         wVSAZQWglDZrI+L+G35AT8A5qQsRwozFX1YHneUxubAk9FXEs22wvvHTO+KLaRyKjzDC
         gZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306235; x=1712911035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NtLrnSXqdt678CiS0tNUCc+5b/rRAvRjP5Z8cb4bKlQ=;
        b=j878LWjEpXdyyLY//oReVwDkscSGm6stW3E1LVhv4CeAN5z2gi6pGmSMc6eCmE3WEN
         /VNOyAEPVRriVXLQP8LmEp7QYuCFqADMFM0ujo6r07eJWSx4AHVRJbdhMi/8jnmHjdhA
         4glskFLDtBPN+xfF3ktJnlTCved5ALVBfe5E2syqPfPcXsWeYrXmZTXCWcvTVeUcTt7O
         OHBTEiabBKJe8BNOCWhChA7ld+zDkyk6c8PWY9mYrh2XdDWZtw+StBXwIhsRk4URa8bv
         5CEiyhR4l9L53ICoyy21I/d5GFHWZ59LZ8PzaqFeuwtX9g/rCAgpxPOK/HxbuedQfQaF
         jn3A==
X-Forwarded-Encrypted: i=1; AJvYcCU4pPg6EqesoB/rs6TPrNyGzC3e3xh0dP3FBv4DVnQTwxWP2iJ+Tw18LKwLQBbKerdLtVXlnvWaZ9yVLt0MiYvL32To
X-Gm-Message-State: AOJu0YwiQ3xMTcAmSZfw/0vse1o2erzTdjgk5+7t4h4cMzrX202hUpmh
	u04ePKGeS2oQJS54yH5FQoWS7A9gVgOXnWZD/DoPg6/IjcIhi5iPCcvQ2mtl
X-Google-Smtp-Source: AGHT+IHmWOpjV+Y1L3Hng8oVd+HC+SSPr9KDiyUK4PN0GZhAizbWKsuQLfdEdo5jlJnCbyqJBRWlZg==
X-Received: by 2002:a05:6830:6c18:b0:6e8:9b1a:6bc2 with SMTP id ds24-20020a0568306c1800b006e89b1a6bc2mr930386otb.20.1712306235503;
        Fri, 05 Apr 2024 01:37:15 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:15 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 21/35] powerpc: Remove broken SMP exception stack setup
Date: Fri,  5 Apr 2024 18:35:22 +1000
Message-ID: <20240405083539.374995-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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
index 9b665f59c..496af40f8 100644
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
+		      [addr] "r" (boot_exception_stack));
+
 	enable_mcheck();
 
 	/*
-- 
2.43.0


