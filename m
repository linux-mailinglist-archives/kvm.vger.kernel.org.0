Return-Path: <kvm+bounces-45303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 602DBAA83F4
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C63973B4AB7
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02974192D70;
	Sun,  4 May 2025 05:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AzglBvle"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C0918DB20
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336571; cv=none; b=RSryO6/FLf1I4k8FdWF+pS+9K1mGaGg46yTTWij3ZywK1/tl5cajZt7ioxR+TyTWHvZ3tE2+GKGrAD2lemByZA87R/92TkNIAJriZfxdAuMUIQ2QZNrhn/7AE0//i409dYbj3CLejLrUkViron6oobglTR7V82kEvv4Ld/kr1i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336571; c=relaxed/simple;
	bh=BNFujmsKrmM2bZBmRA8jtPvMWhPu772BZRFsylHF7nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ticb+bnsnC+PqgekXPZXay4vSi452+0QEwSdhoPFg+DhRnq8eLWNFa76sUKHaUPMJjK2N0+C+jZMeUQkEEb4WNLSLbG7BhgicmKn9zhRQR6mN/n2cw3OmiWuFLpS6E03TIYoiQM1Fczpjv0pLzyyAG/N7aignvC1phwASBggQQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AzglBvle; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22c336fcdaaso39705315ad.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336569; x=1746941369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+98FJCPUkZxLytRMJNRmc7jhTB2VJSy0tbuhiYCP08=;
        b=AzglBvlecw8tz2Q6JeUyMWIYgB9EzqX9bGcovEOZVQcg7hrhuw4GM1z3o0AnDH9ZRZ
         L7rrtWNGsHWNLmG7ttm47CmZxrS/4YFwl9PHVnnPamobI4c64uTvZbFmiB9FhkhvTMc+
         MTQrt32FNpPZMctqLeFNErAgkN7s+lQVZF4YbrpHLuv5mL+HD7844ZNlno/Ju7JtjYr/
         t+ZvDsloIDsGx5q78wqVo/JOFtfEsgsKDjx7440WaFXrlkyg2f4UnAiCgf6qIwgma/D6
         7o4VxWcYsdtLWQcqSP/eer1o8W2BYCD0mS1sFPuNXw4cW7aoVA6P9N1WfMg6/XdBWuBi
         +GMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336569; x=1746941369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+98FJCPUkZxLytRMJNRmc7jhTB2VJSy0tbuhiYCP08=;
        b=LSBb0jVpaTmXdM10SDYUj71KoxrEgaIi0IMi4jxxQyHZvCmOC+JaNhOG5cJm0o5lwT
         KWujm91861WxgbHPOsjV4d8co/1P9LHl/+QszdJ50Sihqy6HsYyfGDbqyFF3SAL5DdcJ
         s/plxpbwvbI4rZs9m28bka/kr+x9wEnuR7TYalmW/t7noe0Nh7ZkbVxBF4Ui5H6bb5Ck
         yog7rUcI9hhxI/H1QswAGp4QbzmtXOTh1VLqPCpog5G15tFpNiF60juAOEPgnoxOLUwG
         sMUuYCZSa4EA3XG7VFGBfThLp3HYiCp6DGbWv4rs2WIT210t4GrFP8dbLayQKdlvlM7u
         6dKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW78yi6XW7QeYgjg6jwKNqUF9oIRiMrgL3RrkxM7uU4SkrcXQQ8a2oTy97CwSZYlA+SFbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbXY0SpPUVvo0TTdncK6pvqCEE2g84xLb7tIGFd/awLyirfrct
	noEFZdiPEl7/4YA4lyLKgF31spvZDpRhQMJHmXHo5Uhme1Dy4ke9Hp9Yac6fcpy32S6RkQJer9N
	lovY=
X-Gm-Gg: ASbGncuoxDplperBXC9Q5k+8zGZ+Iqj1yfkBxCeIPtKtN5PEuyLRo0r6WwYwRPwA87/
	W1YoQAi+gxnuldfU3V8NfpzAUeT5oATtbunpPWXbXIO6vjs8FoEQXAHAFz4ZpWhHN18cRwuiozg
	TXXKHIMU7MZWCNsS4DgDYEi9XIi9RxTxY0P+Q+xlvIwO3uofJ0gxYMPGd35fAOrllnRXreaiRWF
	sJ8ESY2i3HqrBf/0/uDshvEdrb3Ocp5IGOiwzLpbwskWBaHDEY5aUnekOfRQi+8UmJc2x7wKU1Z
	EPo4Z5v8BtG1iFUnm9QLlD2f1YUNrbIsdj3S2/Dn
X-Google-Smtp-Source: AGHT+IFljFPpmm9aEq/53ursjQGrDhfCp3IjU9vvxW7IWwdA3NjR6LQgS9h1HaQFPxGtz1FrTWBD5g==
X-Received: by 2002:a17:902:ce05:b0:224:1005:7280 with SMTP id d9443c01a7336-22e1ea67d6amr53346185ad.38.1746336569135;
        Sat, 03 May 2025 22:29:29 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:28 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 10/40] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Sat,  3 May 2025 22:28:44 -0700
Message-ID: <20250504052914.3525365-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call is guarded by is_a64(env), so it's safe to expose without needing
to assert anything.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 37b11e8866f..00ae2778058 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-#else
-
-static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-- 
2.47.2


