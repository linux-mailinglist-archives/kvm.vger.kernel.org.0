Return-Path: <kvm+bounces-45051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9207DAA5AE1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5951C9A33F2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B3227CB1A;
	Thu,  1 May 2025 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ewHHyfUw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6A627C15F
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080653; cv=none; b=ewSDezvkutIUnUR8/AN29GGChP6fIgD4VPQhpXn+Jsrr76ntMVxc3QTjDLq3qBVbaTCydDAJUOCLGtuSrxAmrJaaKCWXHZCr/tOLua48nCyhO8XZTljX4pW3Xs9zf5Wv1XAYjPtJV+3z5yOSYhSOpYpHIMdeta0mNP/Q5SRtM3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080653; c=relaxed/simple;
	bh=qapbFlY7ia7S4+IArT2BeAg+vUu/QX0AHmZzT+bcdD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebdn/hJouoJwv1WnWIQ70HXCKvoQgPz4xhzVbYJSR48nXRbm6xkzldsxH61/hk1GuS9qjtKHd/z7xlIDszvLJ5Za8kIsmd/mYEhZHpSwlTQCZtUo6DXUfd+KnkBYf2RN2md+D3TZwMHonVRdk21Qu9Nz5zSPgDYI3e9qGLt9ICo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ewHHyfUw; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso992752b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080650; x=1746685450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIzywu3ug9p30W5eG0L2N1zxQEyM7lznNJHWjTnjaTM=;
        b=ewHHyfUwn8RdxlNd5LoVvH6UOzrrAsIDvnOqOE/lG/kUX6cBEqHy77hx3/Qq1ybHT9
         xkElGGfLM0qg2Om803QoTE5mh3M7V7JS3YcplcuiqPJqcNl8DolHAamVQGT1ju8AMrLh
         I/FDFN9spc2/i6T+KrGPxH2IR8IBSYThMWJa+XuOTs1FbIXgGwSIoKk1Ggk4/WqLyxqr
         d5iKKsExyITTdiJien0BqoEEX8ytksGVR878ubbp2tJsyRgEFuPYYxAm55DxBbts9eeb
         bdOjqtje8siERHn/rlDPZ2LHeMvF+9hHw82i9pm4uVo4F0W9dhwzpfOtiFHctpxxbmNn
         YbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080650; x=1746685450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIzywu3ug9p30W5eG0L2N1zxQEyM7lznNJHWjTnjaTM=;
        b=e95UNgj6et9CirihgaLpzSyIRKaJFtsZ66CqFnRqodBgd4wEcP/RJT6bVJ3BiaQATD
         0DuRL3QtVC5LFd0VRXVxkvFwlvRFmRwR1SvrHADGmi72QMU38RucAO5/gYd5bKBgNP7n
         QZScT+bZ5UTJw1dAuJyQodO+dOl1rVuFNneDhumeU9xYrfaMgZMOGLSyetD5ylHkZvmB
         qKzo8ccyJtuMGK7QZg9CBTnCP/3aVpXxMMJl+dR8R7PKjguF0OcSfejdtpiO6A2e6eBT
         rubRfFKTmSj8GIsqt74YggeGGoLGkqS/jzf1g/1dgzJhFvpZc01MO7XfMuDhBOl4JUNl
         qpeg==
X-Forwarded-Encrypted: i=1; AJvYcCXSP8ARYsoGBP1A0YBf1KYwB1CoFr7TNG/ghn/j9jqh+NSXvgnaeYYao4lao13lb8aGeaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1KkqhgOJvSMrjRyr4OjW7v0i19pOl/QEpBF2OY2bF4/vPpqXc
	4w7Y8sGOtjUe6WPuuf+Y/0BYHarFZ7d51C2RhW+iI6A0WYGrXCgvnJZ4Eck9I9E=
X-Gm-Gg: ASbGnctR3fLjWUADrLeEoOhS9E4yYaCr3V0pfILB5tIImAl0bfThaSi4NYqK9PEZZHU
	AMNEJP8NmnXT1/tSMfNv+zjLj50Gs1KM4C6HKytJWv+9c5hKhdm7NKtc4F09N792yoPRm+u6qvE
	vNoYxULvlOCQgkl8Vkq95SbSTKYScSTU/68ymRXJJFyS++Y0xVW5dKuKdlYlQAWLuE8RT8eVnEX
	TFQIrhewVZs3UwdtFAO5goHM/lK+m3Uy7XDkHtI88vR2fL1W/gWTZ9PTyxShP1AIZ4opqEDmU8e
	m3m32pahBML6D6Q+QUJ3W1zwtXHtbgiaGUEofgDw
X-Google-Smtp-Source: AGHT+IGQmTrN7AnDEHnrZ7Y8mTNrNLs1cJ9kxtU929N6mekWZpSbZF3PYXiv0EdYTWvD2uSXI9SPsg==
X-Received: by 2002:a05:6a00:3e1d:b0:730:97a6:f04 with SMTP id d2e1a72fcca58-7404777ec84mr2994181b3a.7.1746080650223;
        Wed, 30 Apr 2025 23:24:10 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:09 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 21/33] target/arm/helper: expose aarch64 cpu registration
Date: Wed, 30 Apr 2025 23:23:32 -0700
Message-ID: <20250501062344.2526061-22-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

associated define_arm_cp_regs are guarded by
"cpu_isar_feature(aa64_*)", so it's safe to expose that code for arm
target (32 bit).

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 595d9334977..1db40caec38 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6591,7 +6591,6 @@ static const ARMCPRegInfo zcr_reginfo[] = {
       .writefn = zcr_write, .raw_writefn = raw_write },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_tpidr2(CPUARMState *env, const ARMCPRegInfo *ri,
                                     bool isread)
 {
@@ -6825,7 +6824,6 @@ static const ARMCPRegInfo nmi_reginfo[] = {
       .writefn = aa64_allint_write, .readfn = aa64_allint_read,
       .resetfn = arm_cp_reset_ignore },
 };
-#endif /* TARGET_AARCH64 */
 
 static void define_pmu_regs(ARMCPU *cpu)
 {
@@ -7017,7 +7015,6 @@ static const ARMCPRegInfo lor_reginfo[] = {
       .type = ARM_CP_CONST, .resetvalue = 0 },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_pauth(CPUARMState *env, const ARMCPRegInfo *ri,
                                    bool isread)
 {
@@ -7510,8 +7507,6 @@ static const ARMCPRegInfo nv2_reginfo[] = {
       .fieldoffset = offsetof(CPUARMState, cp15.vncr_el2) },
 };
 
-#endif /* TARGET_AARCH64 */
-
 static CPAccessResult access_predinv(CPUARMState *env, const ARMCPRegInfo *ri,
                                      bool isread)
 {
@@ -8952,7 +8947,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_one_arm_cp_reg(cpu, &hcrx_el2_reginfo);
     }
 
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_sme, cpu)) {
         define_arm_cp_regs(cpu, sme_reginfo);
     }
@@ -9013,7 +9007,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_nmi, cpu)) {
         define_arm_cp_regs(cpu, nmi_reginfo);
     }
-#endif
 
     if (cpu_isar_feature(any_predinv, cpu)) {
         define_arm_cp_regs(cpu, predinv_reginfo);
-- 
2.47.2


