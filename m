Return-Path: <kvm+bounces-45369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E5AAA8ACC
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99AB9188F699
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4198B1DC993;
	Mon,  5 May 2025 01:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PAnCVQvG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F771CEAD6
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409971; cv=none; b=GWuJ45d6HqmtMgbJMbPiAvU7SjnSannMkZLSavyjG/hnjQlxFCFgOc259a1lt8OAXhiIJo5zWbvYjSX5reGS/1GWR8q5k/M0TU7UKtW+pHKEPreALC5od9Gn4/0CRGU1Y6aTh/NciHt3fU+UnftgWoC48zc0IfU9j+WiwcRXaro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409971; c=relaxed/simple;
	bh=kMI89uwz3CZQxLYmt+ENIXbqtUjYiWkNNse372VP55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fv/zSv1PbSdwtwXBSrKzZGBAlrfGVQXIcVLELQRDEQL66byMqc4rLUiiyKIf9rtsrE3dcHDKp5WJZnmfSwy8EIRSDHQf8ewvb/XTOjb+/+FZDWyIg/HkUk06+nrLcLjwho/bOV2ooN3Ku92qPKduGV8jGHHTnf/LzaQyPzjumio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PAnCVQvG; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7376e311086so5536780b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409969; x=1747014769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8C01O7GU6PtK/NYVapVL2wa5t0zjMaLo72cjg41Wlg=;
        b=PAnCVQvGWQAfIlMwhj61RbC/sObgxao4SZjeSG1AsFAtIgi+Jx4UEIsZHOeeA5arSy
         jn2EPY0pyzdZL2r41M9jTgKMDoP9Wc7F9UMinfoh1yC+XcfWEwOFws1j4tu4XWgKDkTI
         ji6bQGeOSLewEvmOY+lXQi+Brukpw16ctx3Fn6x+DoHwzeP8H40JRlooJEotDCewQpnn
         cW9UGaiz8AwCdVEa5aYos3jBrahmeNSg+sqxGfL2MWwLxAIVRYimd/x/XMLKuJWfqlBl
         n3d8PTiiNDNk4muunJNrIPeCXh+e9fosG3NBMqGXe5++ikgHPYGHvq/6cy3FvdqGEUlr
         PSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409969; x=1747014769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8C01O7GU6PtK/NYVapVL2wa5t0zjMaLo72cjg41Wlg=;
        b=sxdmiUggGSTfvc8G3URT5UIwwhJLEhd4wvmSE1sthYDqRYpF/1KOCoqyTI+3+NuQqt
         hx1mSenMLFH2KhbBBIqthykUhuLL/RaOcEyzT7SsQteVUqnXxR49NZVAcGxtoHpmz6Ye
         tawDlnv21J3fjuE5+xi4REv5RxdJfL9wjGTcb7BjEHjdzrazSkn8J0NI2UvRYT3HP9af
         3KGNx+qp7zmdJjoHCX34NR2dDxUVr+61p71fpZ3YaHtaa0VhJC8zL4k2xMrtPx2Fkttl
         1MqUSehoc5/wGC6+Psh+fh81AHyF/Frf3k7uiC/CRE0pkEMHoxJaPrGOJojgiYcZAk2+
         YlaA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ45MY6pj5Vq0YNUCJxtUIgRXPLCVczJyZ7V8Rwsjf3xgByoDACWV6k+tASLkX49gilwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbJzJdi6j18Td2AD1EbzCGBgHjptsej6ui6rN29g3nEs4H7vq6
	egxM5qvyMBlJiqXAjzShL2fS9amXb7JDW8f6g09Qr1VZbQQ7UcIc2H/KlLTMD6Q=
X-Gm-Gg: ASbGncuceSZUrE2hdzKZvy0+Hum4jCLNZTO5YWcHHTzs3op0sgFcmjKMecAgzuQ5Paq
	Y8lyoOEauKiQCpmvS/ANC7lAt50xxCNy25A6psLMzP7TW64zUWFOjadQOjnDM/VrYttTs7tCqAY
	0ooJut9Tujdz5sskn9Yi6F9mEqHF5hRn6VQujnQenfE/89O5JoyFEZZBTcOaP1o7H4oNApz3fZU
	mAzdrTgR0Q9/3F6LYkoU9cGcjqRySLy84TZQk8hzW5tCBcRmCDzOr64v/bXUKsUQ6d6pknac7Qn
	CZX+n1Vi4qMht9Oc9xGb+Js8nkyh6+y8G21GT9sx
X-Google-Smtp-Source: AGHT+IHiEk3UOQip9JYyp7dcUAGKcm8K1pFYoaIR5DOLsapNGpbY+g96PPg3mXrgXS7c1B+8FJb02Q==
X-Received: by 2002:a05:6a20:d046:b0:1f5:8eb1:d5d2 with SMTP id adf61e73a8af0-20e966051a7mr7469413637.13.1746409969294;
        Sun, 04 May 2025 18:52:49 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:48 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 23/48] target/arm/helper: expose aarch64 cpu registration
Date: Sun,  4 May 2025 18:51:58 -0700
Message-ID: <20250505015223.3895275-24-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
index 7daf44e199d..7e07ed04a5b 100644
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


