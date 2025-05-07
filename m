Return-Path: <kvm+bounces-45788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE086AAEF72
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 019FF1BC4713
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC96293442;
	Wed,  7 May 2025 23:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aR6H30YS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A846292914
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661384; cv=none; b=CHkRR/7COrvnc2UVs02p6771AZufmyNPsMWKmOff6zdHgBZN5CwDzTKY4tcD+uPtIRzmL1B7ffEiL78cnJT7G8HPKY/8h7zWnHMtp+LaJlFHENp7LdV79TjP14zdWxWpa3BLNMb9b5zIaxvue9wLib7YFUY/3VM0o6B1tAO0ZiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661384; c=relaxed/simple;
	bh=Ub4pOBawgqIRmZ6UP3LC23XhD8KGMGnlv6PDUuDooFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YLJlwe98EF2P1jmniPqMJ9n9VCVt+Zj/FVXfx7n9jEV4+S5bSqw56j2TS/AgJYKoTzE6QcdubF25hM5/lXUI92Dk0EQgjLZmwNY2VtSy5T53ZCMc3Jvv9+l6/KhdAzFFgqSyZTw87tGR8TjOYvIRl/J79rlHOYnFlboLHApulfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aR6H30YS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22c33e4fdb8so4068975ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661382; x=1747266182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6DV+2RAAVd7Czk8H7PoRnAo43qLQObnu+pSnMRVopks=;
        b=aR6H30YSuMr98km8kK31paYirV1p/gm5OTz4GBH7KDfOvFgzCilH+vRynrK8eb9dMI
         FDzU94e9bMzSNDpjkIjmwI2L4kBc+zJZZy0ZX37EDdJZBBOkUZaPFuzNKdJvmqd3CB3r
         qOELTAqvoqLF01XolHiujkCFkjp+t2bJrZefn0Rzey6Gvi/BZvg2uezYKhGelQE3LhdZ
         uhMOMWQPjdIKGfSUWwvHZ1IYJTj8XRv+y4ChZRbViRsVHRVtJiC+rIEPo19nEFTZorCW
         1/u+MTmD4pFfL04Gn7niXM5x6vMWuB9CN67WqE6016YFMUAua7RcXDFSE7WktL/LUOOS
         iAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661382; x=1747266182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6DV+2RAAVd7Czk8H7PoRnAo43qLQObnu+pSnMRVopks=;
        b=LD+/tqd1T0CTZm1wOzi1vowDnzBjrPhJkaH3N8/dutLICw01uL+kk1FILR7/9Bg9tg
         T9hK2Z7mrOHhjSN7xB7qSplXrYpv5imzAAnJ223ysIcWGNJNVCH9O7fyKvUsonJalAig
         zz1i3+fod7wpuSi0VApM78MdsSDRsa4xZf7+uwoDwlPJF+hNtYT/VdXCJLRRIU+lZ7Fa
         PoVmKBbeZaV0e5VBh4FCufA6HghaQQvr1oOFroKQDEiyRQ5CTzbXiO4XSQ6GTN6nn8V5
         0gCJxu2vmeth/sKlDzWGpj2ABv0fEtuyoHKWLjHFVmxNfdIeGOggWDWX4tKrj5eJ5iM/
         Zv3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTSjNVq493Wur4uFTMoFU7MYEzYN4DOVNrYp6PUXFvk8gWshYCv6SBaPtzu5hxEnY4glU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS325mrPcc2qkGIfCX3vdawvn2KQOmd8a/oX0m5sN7052W8KAi
	O8YB+DGtqyVDMIjeaz5sIHEcKs1cm/I/rKTfoRM7StZclZ31uExH61hWcQvZf7A=
X-Gm-Gg: ASbGncuO7JhSwx+B3MD8hwijLyqDqhtmYMnsguqmcoVSxkEoIBNtWyVpTaY395DO/zr
	8nHG3850RQuCyV+xoQzzoqmxo1+IObhBmePM8BbDPwV/CvCxAOttvT+HHUeFc8aSE5NJQEjTvv0
	Q10KprxwUMOeljUib47v5SqBUN4GIMztDYLWEf59VVQ8l0QGxUozKIDeMBbZSMM68pW8ritpdBe
	V4nqTjSy4rsw8H2uNMtNb8Eco/2Zc1VLUcrvVGpf8Ers0DtIC3yMFqaB+DdjEHtg23WL8j1fDxi
	aoRKhm5QtmxmLlNE+XnvXkmJ/x2soxjHOIbXW5Kd
X-Google-Smtp-Source: AGHT+IEFUNK62tE1si4fuK2RKKlN0gVISYH36IdERyQZ1SgpJ1N+YZe4RJbDf6/SEw8jryGADSirZg==
X-Received: by 2002:a17:902:ce86:b0:22e:4203:9f33 with SMTP id d9443c01a7336-22e865f7573mr16624385ad.33.1746661382643;
        Wed, 07 May 2025 16:43:02 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:02 -0700 (PDT)
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
Subject: [PATCH v7 22/49] target/arm/helper: expose aarch64 cpu registration
Date: Wed,  7 May 2025 16:42:13 -0700
Message-ID: <20250507234241.957746-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

associated define_arm_cp_regs are guarded by
"cpu_isar_feature(aa64_*)", so it's safe to expose that code for arm
target (32 bit).

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 2e57fa80b08..18ac8192331 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6590,7 +6590,6 @@ static const ARMCPRegInfo zcr_reginfo[] = {
       .writefn = zcr_write, .raw_writefn = raw_write },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_tpidr2(CPUARMState *env, const ARMCPRegInfo *ri,
                                     bool isread)
 {
@@ -6824,7 +6823,6 @@ static const ARMCPRegInfo nmi_reginfo[] = {
       .writefn = aa64_allint_write, .readfn = aa64_allint_read,
       .resetfn = arm_cp_reset_ignore },
 };
-#endif /* TARGET_AARCH64 */
 
 static void define_pmu_regs(ARMCPU *cpu)
 {
@@ -7016,7 +7014,6 @@ static const ARMCPRegInfo lor_reginfo[] = {
       .type = ARM_CP_CONST, .resetvalue = 0 },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_pauth(CPUARMState *env, const ARMCPRegInfo *ri,
                                    bool isread)
 {
@@ -7509,8 +7506,6 @@ static const ARMCPRegInfo nv2_reginfo[] = {
       .fieldoffset = offsetof(CPUARMState, cp15.vncr_el2) },
 };
 
-#endif /* TARGET_AARCH64 */
-
 static CPAccessResult access_predinv(CPUARMState *env, const ARMCPRegInfo *ri,
                                      bool isread)
 {
@@ -8951,7 +8946,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_one_arm_cp_reg(cpu, &hcrx_el2_reginfo);
     }
 
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_sme, cpu)) {
         define_arm_cp_regs(cpu, sme_reginfo);
     }
@@ -9012,7 +9006,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_nmi, cpu)) {
         define_arm_cp_regs(cpu, nmi_reginfo);
     }
-#endif
 
     if (cpu_isar_feature(any_predinv, cpu)) {
         define_arm_cp_regs(cpu, predinv_reginfo);
-- 
2.47.2


