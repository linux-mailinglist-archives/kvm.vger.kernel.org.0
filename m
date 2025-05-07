Return-Path: <kvm+bounces-45813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70228AAEF9C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A47AB20E09
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68372918E6;
	Wed,  7 May 2025 23:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tytUYKVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3952918D2
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661621; cv=none; b=aeRJPDYiirf/rbkYzKydP8Z2bNgjnDcr+yDnmPseeJbhtmDkwRl9LbdUeDL2WK0n8QFNdBeEpboSPLsE7S4M57cmWxdrY29+SWu+1BD4qEOUneSm6geqH4TzgV4TyNDxcAJ82efbeKhLUv3ZnJyg8SE374gjXcQkCiHBxcaKBPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661621; c=relaxed/simple;
	bh=faRCTrf6TBAyy1Gxn1R7zpsi5M9ebC+tFXR3moVS+yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia+oEy1d5EkO0MManvpsldxTic2ySv2NFJAt2DoLpBzZcpIBGkeYIuA7EqMbmYmno22skJdSk3ZA9rBAf0wzZhvaBRSW0zXMcqBccSnpsu42rCukk/qZZ8ndSaOazBbVLeox6wf58k6W2UWNAN4Xd8OtPQT6Y5LB0MvJ4wEee1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tytUYKVN; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22fa47f295aso253235ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661618; x=1747266418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZWI42H1mGpC+qtJnGTlft49SFGxWloHLdh6QbAbdhzc=;
        b=tytUYKVNXB78hywZpOrQsBGQv3uK3i345+MMa65Ax9NqaKfheIIjnxRg5/HBNLuCAV
         0GJv3uix7OZBdPBM2o6OEvhqEajhdLLXrWErjyRpJly5G2wCeSN+B//ITi8HwVdkN7Pg
         O1K/78zxbRFIBKg4vhvTTtJ/mA6xZ6l8ApbNRaKjpPe5mZH2kkky/iTd4p3BJdaXSMIP
         g7xjTvDAoXhgbDSLXgojhrBwXsaB4GiuRO3fnYcjNz5s2GD/gQREj1c8B3vfSEA9zUYs
         92q1qsNvkdVmBr/ogSFdTP1y4EV8eZbtp364b9Xa9YcavhWGNo9ojkD4/d2BczwDVR3h
         sC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661618; x=1747266418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZWI42H1mGpC+qtJnGTlft49SFGxWloHLdh6QbAbdhzc=;
        b=v4CzFKe2jZu43jC356KDKEpT2h7I+X72V/6VjjyJ9EWyPMKCQ91CC31Gsn6E0DXsm/
         +Ren5RnqG6aqvn9htMDgIAH/KLs4JARAhCvqSoZt7AKmkEATGASQCUxTwiXp/0JwgCJM
         qfhTehEacQMhGHggfcpWKcnDNRbhigZrmtkIEQ8Z/ZAf2asdKSIkIkbjUvgYZC+TzCZI
         X6W+laARHphWUJeN6q+hax5zv2Jzy45JykQUWPuZRY4I6nmj8gcoiCzCXYERoDmDTVFY
         +2DbxzxSaJVHByz6OsN+kyzqeF3VXk+/uwFydDqae3rPp2XI2fhiLtZ/n0zkig4W0/hc
         6Ecg==
X-Forwarded-Encrypted: i=1; AJvYcCWXDlefL5Z51kPrQdJveoetST4LsoSRWlcjYRQ8H98CKqqzUZkqIu+mLQ+Xl4BNnEFAP8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAyOBhRul/bY92P61BoF+Lq8laBvMTtBiSoSETJU+KSwXvDJHt
	w5OLiVQhbmZlApnBKulX5JWuPzv8/VeT+/H/Cj9ylZCwnQWoeA8Uxz8r+nEL3K0=
X-Gm-Gg: ASbGncuVMdo//OUDg4iRVtpXpYzQd+GxU/hQeU6TzO8M9yn/MEeWY5BHcXfMQEGl5O/
	odqzLVP7U4GJ8Y3Y1nPJVmglcgp1r9Y09B3saQsJbQIodcOQl+PZb04LJ1nl+sbaGUJvQnPsBlu
	komYnB8516nCxF5/eRZgijmOT1TLvP1diuda7glWqwHUa9HVUDIOta349h5GavZ8m6cVQd2O1Nf
	UXRdixhgkECQ0ux/aUVvTbMCXclfWGPjtMfN1183Baal60AhzWVj/2WlcXymkw3/5PFl29DwH3D
	PtR5cyx5vhx7kkBhR+iwj639KmUmxH1oFBndZNLM
X-Google-Smtp-Source: AGHT+IF+9FdcXEjg+vjvcbNJXKTc/SzGzp3tVqidhIc+lSQaQpxF9T3Yy5aNHSF14QdgE/W2bTVreQ==
X-Received: by 2002:a17:903:32c5:b0:211:e812:3948 with SMTP id d9443c01a7336-22e85367010mr21293255ad.0.1746661617799;
        Wed, 07 May 2025 16:46:57 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:57 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 47/49] target/arm/tcg/tlb-insns: compile file once (system)
Date: Wed,  7 May 2025 16:42:38 -0700
Message-ID: <20250507234241.957746-48-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aarch64 specific code is guarded by cpu_isar_feature(aa64*), so it's
safe to expose it.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/tlb-insns.c | 7 -------
 target/arm/tcg/meson.build | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/target/arm/tcg/tlb-insns.c b/target/arm/tcg/tlb-insns.c
index 0407ad5542d..95c26c6d463 100644
--- a/target/arm/tcg/tlb-insns.c
+++ b/target/arm/tcg/tlb-insns.c
@@ -35,7 +35,6 @@ static CPAccessResult access_ttlbis(CPUARMState *env, const ARMCPRegInfo *ri,
     return CP_ACCESS_OK;
 }
 
-#ifdef TARGET_AARCH64
 /* Check for traps from EL1 due to HCR_EL2.TTLB or TTLBOS. */
 static CPAccessResult access_ttlbos(CPUARMState *env, const ARMCPRegInfo *ri,
                                     bool isread)
@@ -46,7 +45,6 @@ static CPAccessResult access_ttlbos(CPUARMState *env, const ARMCPRegInfo *ri,
     }
     return CP_ACCESS_OK;
 }
-#endif
 
 /* IS variants of TLB operations must affect all cores */
 static void tlbiall_is_write(CPUARMState *env, const ARMCPRegInfo *ri,
@@ -802,7 +800,6 @@ static const ARMCPRegInfo tlbi_el3_cp_reginfo[] = {
       .writefn = tlbi_aa64_vae3_write },
 };
 
-#ifdef TARGET_AARCH64
 typedef struct {
     uint64_t base;
     uint64_t length;
@@ -1270,8 +1267,6 @@ static const ARMCPRegInfo tlbi_rme_reginfo[] = {
       .writefn = tlbi_aa64_paallos_write },
 };
 
-#endif
-
 void define_tlb_insn_regs(ARMCPU *cpu)
 {
     CPUARMState *env = &cpu->env;
@@ -1299,7 +1294,6 @@ void define_tlb_insn_regs(ARMCPU *cpu)
     if (arm_feature(env, ARM_FEATURE_EL3)) {
         define_arm_cp_regs(cpu, tlbi_el3_cp_reginfo);
     }
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_tlbirange, cpu)) {
         define_arm_cp_regs(cpu, tlbirange_reginfo);
     }
@@ -1309,5 +1303,4 @@ void define_tlb_insn_regs(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_rme, cpu)) {
         define_arm_cp_regs(cpu, tlbi_rme_reginfo);
     }
-#endif
 }
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 49c8f4390a1..5d326585401 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'tlb-insns.c',
   'arith_helper.c',
   'vfp_helper.c',
 ))
@@ -68,6 +67,7 @@ arm_common_system_ss.add(files(
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'tlb-insns.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
-- 
2.47.2


