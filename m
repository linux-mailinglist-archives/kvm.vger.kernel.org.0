Return-Path: <kvm+bounces-9820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9F9867296
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F5F7B27F2F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13295D91B;
	Mon, 26 Feb 2024 10:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTD2Q6DK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9265A5D909
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942421; cv=none; b=ZNXwjgU5fKdBhnHBi6Lpt7/BuqPo7KvDnRv7tsjsa4CM+T4ZQFWTw8uxUPcKr7kbPIqdD7GM+kfDeHjqnzMfvmjYR04q8pzkZVrA69qhn0dYhnc3UDYKvEkrRTv86ADBNabtDQBXvXiQvDBwj1chWgnDWwF4bnpLuncFTrG1F5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942421; c=relaxed/simple;
	bh=0npRfbr84eIL6tfFA8NZrC1s0pBV7buW5iGG+00FdQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxLsMtNiqhbC0Lw4KLdopnMt/e9KS8MNRKM3Yd+0FsecSCz5F6HlPgSWaPInjK8fSOjZoXc+7dteuhdrr31RsmyL2+KGTErpjFhJ7B594kO4QaStfR/M0z1rSbT1vHQohu0SmhPkTq2oTcwXsU1tVKjY0wW79McStw2MlDYCdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GTD2Q6DK; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5ca29c131ebso2305535a12.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942420; x=1709547220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGo+1arrsYAVXsfTP4gQ2EL+vABqvISnH52kVRdFyBU=;
        b=GTD2Q6DKkybt4XL4QQm79cG0vlPW9V0TSzunZGjHqSU76D/r5IRifL7DV8pRRMRoSC
         wUovryYe9RZ/DaLqfyk3dPio2HoF6KR2LiZsSwpGPARrJZJZ33kamgcjGmpNZaSDv+EH
         +x8MixQli/Lb5lUn6FTPBRlNiAcwOhYC7QWNY19TAhFgqbN1UOogQZ9FoZehDZZKYDPZ
         uyJceVHhxDiBJYkYfyNlPiT/l5NQbsi/iAsjyNpEjcqSE7mdBVBVLYfAQoNz1qkPvyRY
         cB1BzurqyYYe7TreYJr2N2XSEpApmEA9/Qevw5aB4ejllVZBoAKCwNyWXWdd2UAI4cAJ
         qy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942420; x=1709547220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGo+1arrsYAVXsfTP4gQ2EL+vABqvISnH52kVRdFyBU=;
        b=Ay4Mr/1pLueM97UXJ2EO2sa7366miGS9L3+io0vZI4sYRzHOe5+FCO2DBcaC8iiscP
         Y0ocED05wGEAvVbqHZ3pL2Tcuiiv7VN4RvtINncx+DfF1cGgslpEIqmiomKLAr1pp6ev
         KO1O+kD57YU78IqMtyvRIpIchewQyCLtIUgeUFZvutCl53YBQIq9AqTklCZclWoxSKqq
         ihKtPMjjEe8btRk/K9l00VlfGCkfo5/uWkVH2x5h++VDw1txwUUIdfpqEIp3ieHFxXK8
         1Edv7is7Zjxqam2gHHHT9yIKm6qNo1HAK4TUHTDYkD02krEfCMpHfUtKv4S7HZKqX2j1
         E7Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXSRIlZPJ65HwpVIW2d0jwQlAU7jVZ/54DjuXIb7C/kc1rGOht36vXNNm8fXRG/W0Wviq8yiTE6KTfss3LLFbqTQYV5
X-Gm-Message-State: AOJu0YxHnoUCLjmtT/l+bincaByjS7AFQTsNuv98ro3ZmUzIjx86d3ZO
	sl36kPhGSKxdH7Y3JptXTiChYPe7760YDdZvPN8FTitXH6mY8H+THa5C0GHL
X-Google-Smtp-Source: AGHT+IGmdxxayQXgJvWM0G91cEodyIXuZQEu0yL5dXAiDbtmtpAhynPpesxFSZ24zZJ/kBp/aQ6TSA==
X-Received: by 2002:a05:6a20:9c8b:b0:1a0:e4af:3c12 with SMTP id mj11-20020a056a209c8b00b001a0e4af3c12mr10054112pzb.48.1708942419825;
        Mon, 26 Feb 2024 02:13:39 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:39 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 16/32] powerpc: Remove broken SMP exception stack setup
Date: Mon, 26 Feb 2024 20:12:02 +1000
Message-ID: <20240226101218.1472843-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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


