Return-Path: <kvm+bounces-22292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B706D93CE70
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 148B8281CC7
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB23D176240;
	Fri, 26 Jul 2024 07:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djy0UPwf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F716F85B
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977514; cv=none; b=ZKnod+0qWwjk8H/gflUA8JjgvHIcaHvrapty8EguZqwDNXloI5GwmQCOrNduB6xjJIC9mcRpafqGXexDrwTvKZDlxxsg538tt+aNCkWNebt+5c3Zj66o5FaVkGkh95L48zKyExDWuPSK/ArJEnAppcgbmwkaVJQCKxuk30EDrFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977514; c=relaxed/simple;
	bh=OrGTBbNyuge6EYsy4SyIPWIDEUFuFc1z+3qepHn++hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LR2rRL2xDjY9gf1pXYsxS1E9gWl6ptxmD3YfiRUTajNxIYYVmcahBzWdbdY29bOsHhbukQurpbicsm/pAcc5kGppbA0cScioyrhlk/eWwbj5FufWmhc8xxZi/WUF9J9mDQYDImvx1YBfyqK3bie+4Iq9owuFJ+x1oW6aMBq5KH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djy0UPwf; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fc56fd4de1so2418525ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977513; x=1722582313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGi7ji53HlNG3/YSiL/LhTXWaHGlRjdPMvK3G4NM8cI=;
        b=djy0UPwfE7frLJZmgV12LlukdfUIQs7THPKNs3k7wltEEKD7IrnqX5wUSc2Q5f5nkl
         mSLEZGDBHUm/dvCVLBz1MjF0qUsQ1VWaMti+4GkNzYQGIatvJU0ZaRsEyKbFbb3YcnTZ
         P8OAwgjYq3UFO4Turs5pyW4Q3Fuyz9Oc40iq0TU/22HBNRbhz0E5gSrvh10ohnwj0H3U
         WryuC4t3SbGkiOYhqWobG1sYklkKPZ46V3z19+DKASc4fx/O4vCEVmYndYPDswjc8NqZ
         /oJQ4jAiC8MfgQZfupPSAx1e7idiUVWI0BvXYxY7au3Fz/JrGFp2y/YoXfouSRSbc8Nd
         BiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977513; x=1722582313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vGi7ji53HlNG3/YSiL/LhTXWaHGlRjdPMvK3G4NM8cI=;
        b=HJ/wxCiL7OOhbQxuwjf2aFtFLnBmdUHe8z4JWQ6i3/eM/7fF4SgkeMBs5CTVe3uIMj
         jhD4kfr2rHnjOg6b7VJp0DSy06aq6eQ0RXCmpSnk0ZcPK9XZ3mX1k0etKNsatj+TXaNo
         Od5B9SEsOgPWQ/MO00JD3e4QP16QEcTThc4JgrwY+V/UrqbW3l6b0kLNyJhGShrgdkbl
         N9ClPjOooGtd/F9p/3KVWBvNQmT1Z0jhRCo25xVt6NyDBSdZOCXSe4GCrAIiNzaoUlvf
         BZBasfTQYvp8gGsZcjt8c4VX6qXPQd1JwVCbPbR25hDLvUgDkU7lNNt3DSHNeiqtyh3P
         Hvww==
X-Forwarded-Encrypted: i=1; AJvYcCVKS3T60ERBc8fVPpusFDdqU0VBs3DROgJCn7lrMaA45d3QEaNOfTs3SHkxVlq2Wz9T0fhViZLus1z7J4pPRb2sw6s3
X-Gm-Message-State: AOJu0YyXKq8nqKRX+wgzQXKARAI5tOCgB84L56KglGVtepPzoGNF9irF
	vUW0UgVrNIDab7xb44NFURJnJjP7igXx6/YRqGQJpXOSabbgFEPp
X-Google-Smtp-Source: AGHT+IFQTXyZGfJYNXpyLECOWluf4r0sSuh8a7Z6QtMj+sXCHLyq0R+BN2Pl/98Ck84wgVQvryWQfQ==
X-Received: by 2002:a17:903:2592:b0:1fa:2b11:657d with SMTP id d9443c01a7336-1fed2733888mr61993635ad.10.1721977512802;
        Fri, 26 Jul 2024 00:05:12 -0700 (PDT)
Received: from wheely.local0.net ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4d26sm25034215ad.166.2024.07.26.00.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 00:05:12 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org,
	Subhasish Ghosh <subhasish.ghosh@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 2/6] arm: Fix kerneldoc
Date: Fri, 26 Jul 2024 17:04:43 +1000
Message-ID: <20240726070456.467533-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240726070456.467533-1-npiggin@gmail.com>
References: <20240726070456.467533-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some invalid kerneldoc comments crept in while centos ci job was down.

Cc: Subhasish Ghosh <subhasish.ghosh@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/fpu.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index 39413fc3e..edbd9a946 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -212,8 +212,8 @@ static void nr_cpu_check(int nr)
 		report_abort("At least %d cpus required", nr);
 }
 
-/**
- * @brief check if the FPU/SIMD/SVE register contents are the same as
+/*
+ * check if the FPU/SIMD/SVE register contents are the same as
  * the input data provided.
  */
 static uint32_t __fpuregs_testall(uint64_t *indata, int sve)
@@ -256,8 +256,8 @@ static uint32_t __fpuregs_testall(uint64_t *indata, int sve)
 	return result;
 }
 
-/**
- * @brief writes randomly sampled data into the FPU/SIMD registers.
+/*
+ * Write randomly sampled data into the FPU/SIMD registers.
  */
 static void __fpuregs_writeall_random(uint64_t **indata, int sve)
 {
@@ -315,9 +315,9 @@ static void sveregs_testall_run(void *data)
 	       "SVE register save/restore mask: 0x%x", result);
 }
 
-/**
- * @brief This test uses two CPUs to test FPU/SIMD save/restore
- * @details CPU1 writes random data into FPU/SIMD registers,
+/*
+ * This test uses two CPUs to test FPU/SIMD save/restore
+ * CPU1 writes random data into FPU/SIMD registers,
  * CPU0 corrupts/overwrites the data and finally CPU1 checks
  * if the data remains unchanged in its context.
  */
@@ -344,9 +344,9 @@ static void fpuregs_context_switch_cpu1(int sve)
 	free(indata_local);
 }
 
-/**
- * @brief This test uses two CPUs to test FPU/SIMD save/restore
- * @details CPU0 writes random data into FPU/SIMD registers,
+/*
+ * This test uses two CPUs to test FPU/SIMD save/restore
+ * CPU0 writes random data into FPU/SIMD registers,
  * CPU1 corrupts/overwrites the data and finally CPU0 checks if
  * the data remains unchanged in its context.
  */
@@ -374,7 +374,7 @@ static void fpuregs_context_switch_cpu0(int sve)
 	free(indata_local);
 }
 
-/**
+/*
  * Checks if during context switch, FPU/SIMD registers
  * are saved/restored.
  */
@@ -384,7 +384,7 @@ static void fpuregs_context_switch(void)
 	fpuregs_context_switch_cpu1(0);
 }
 
-/**
+/*
  * Checks if during context switch, SVE registers
  * are saved/restored.
  */
-- 
2.45.2


