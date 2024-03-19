Return-Path: <kvm+bounces-12097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986C787F8B8
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528DD282CF0
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCC6548F3;
	Tue, 19 Mar 2024 08:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4/MRUtJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF6537E4
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835257; cv=none; b=jNzujL7cCf87DRbCcI+5CkGzYD7lGzkeSWk2w+lezdiKCxOXqzLDLhQlMG7JMURFTjJkhk4SnqRja8gyYW9Wu7J7nxIGStwTvLsXhucT/XuJsr6A462dJ3XFttqNaewL/Pen3ImP1qy5a1da97/gaL2uUsWwgX4OCW5oRb90qF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835257; c=relaxed/simple;
	bh=0npRfbr84eIL6tfFA8NZrC1s0pBV7buW5iGG+00FdQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV8Zu7RshpHB/stCYImDokIFmNazQPVmfJXC5u9IlFVjxS62LLLRqA/0Qn9LWty6yMZAPsGX38v+HraACPUs0v3gxMMGhQamHn63juTAibt/StnfofVoCh9aszzeWLwkX6akR1ELwdnoHVxyk/k3oStradCKbSrBnU0fr/91k30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4/MRUtJ; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5a477c48fdeso2535077eaf.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835255; x=1711440055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGo+1arrsYAVXsfTP4gQ2EL+vABqvISnH52kVRdFyBU=;
        b=M4/MRUtJdmmGCSH1FDx1feK/x8G24Ryz1NZPb5yDNWJg9kFqxDgJgpshteVj/UppQ9
         54nyxW1Yb3mo7gLcR0lAjBOqsJQhO9izqpcVIZ5YwBO+pfNkSreJeLTLZAVEqGFYNYGt
         3KxGN8pLmMR7F4JIar5WT29ogeIIG178TjpY4Dv3nfyt5SkP2Gl3S8UoQK1foEawBLJw
         tizJGcY2OF3HnjpxgpSvJMmPG+08NSR3DfEAe7hELo503LOeMZiymtdO2StWpvPjAsRR
         jVKo1Venr2nrUDtRr57gqyHBk7HRQqXtAv0jyCvO8FMRgxlhI9VFpGBR5uYi8X0Wi1UB
         6KIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835255; x=1711440055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGo+1arrsYAVXsfTP4gQ2EL+vABqvISnH52kVRdFyBU=;
        b=eK/7I8xhVKnNvSMtu+rY3okzmQdazRTWaR7kyw/rtE3OeMYvO9pIIUo/CRugELEFmM
         cYInCUtWLogK+mB4Fp4G4rRNzdi47cpZ6jpZ5hqOU3CHt+AhqR4uvIdvJvbFVKDn2kjG
         A1BBMKopoIUP5evtj3+OLlWwz9t/7LlyR0aJBOKb74RoTkOS3koBrBqoJMAPUEPiPahr
         f6H1HVHzcZ1YmdnPoP8/sV5G5u8nUOnBs7KNwUqgWb+1Va1gKFPZLRQv1aoAptFh5udo
         XDLnNzmOApyGeEIyPd/vCLpy3Dd7dYuJ3qt4NytpF0mDeqmRfaK+bhCKdafkByp8rNuJ
         8GxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUScA3QckKtdQGE19H7SZE7wDoEshrFSDHl0L3lLN9UA3xJ9vvEF9/+V/Jxpwy+nejQVP3chOogtkLDMEhDFQy3zJUk
X-Gm-Message-State: AOJu0YwmT6LgAgMqb0PzcrafcfEqHbDoKjAMW5OrQve+3+fVdX80QPNK
	j2wDCiEentM5gXCo//p+84AMAdQ311bULtUV2AhN6nTb20RGiQSS
X-Google-Smtp-Source: AGHT+IFs4elYHLqSQaWxfOpvn0n1iBEA3/4l52mkNvpdgddck5fItF7mXhG/KqTc01Uq87acxqM7Qg==
X-Received: by 2002:a05:6820:1629:b0:5a1:78c0:4327 with SMTP id bb41-20020a056820162900b005a178c04327mr13805982oob.4.1710835254929;
        Tue, 19 Mar 2024 01:00:54 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:54 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 21/35] powerpc: Remove broken SMP exception stack setup
Date: Tue, 19 Mar 2024 17:59:12 +1000
Message-ID: <20240319075926.2422707-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0


