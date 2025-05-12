Return-Path: <kvm+bounces-46209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1F2AB422D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53ED33A9A30
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1E52BDC10;
	Mon, 12 May 2025 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dG6lbAfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F68297A6D
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073121; cv=none; b=XHg73K1WENcqAKnyktn2urtbkwTWaU7Wp9fY2dAvRZn6jWTUAv/Vmv1dBgfgLJCij3mesfgQ6eEp0PsKRXMF922IMN5upMZbYcnRQBwchw9MKdSahDoSaXUniNtUefSU2GjCOy7R4Glsf1K+qzxY9fN6mo2GJkhDbqqDz0wUkJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073121; c=relaxed/simple;
	bh=gPyqX7/a+yWPxYGNzwg0czwFhoYu0SfjXLT4PWcZCAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRhC7jRiUtG1sYI0ghM6a0VS8EsdVFjNqGM/XvCvt9xvZcRZKIEFmPDW3PmWc9Re5Dz/JsNIkRyfSs48pULa1X5U6uuChO55VEyQyeOJn4FmD52ND/77yGwU6MgRXfiXyVL4FgxIdX69+l3n67eLRr6CeH62lvSdmWZDNwtsJnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dG6lbAfb; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b24f986674fso2737312a12.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073119; x=1747677919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eeLa55SzX7Awe9dK4zRdJwFSzsCeJiaBfVkd4m0OHRI=;
        b=dG6lbAfbvQRHps3AeSie2CNeVQ0IZwjw0OlaOsihwnwsRF0cgsVLV/N8rIxcFLcjj1
         RKkJteqZfs3iJw/aXSXQj7VY6tZOyajwr7YygjDmwD4iS6ihWyYriPSNPht13EWQztRK
         LXy+76szPd9BVDu4gPdjn0gcD3EW/SZeF88zmsHvJcxrDdaS7ad1vDC85sxkIzjxpL1u
         KdnXabjHvC3riCqsw3/CgU9yGL99QJ1P+eFMuYdp0IXiTTsPRAqtABCgbO5GO8Ht4+ye
         yTV0orvpftBRBrRhU9ejtPUltRuAmZ7lwHxW3FmVOxz4eNmpae5py/EYCT/mOQ/jfLrO
         lJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073119; x=1747677919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eeLa55SzX7Awe9dK4zRdJwFSzsCeJiaBfVkd4m0OHRI=;
        b=R7M1ARZugTc4GJGlFYnQLJrA8s3ByfchRs7L2O8qpFaXMyW8x4m6TdVjQNXAFUB7B7
         4WNo4EEnBL2Lo9+twiR/noIl5Pjy2PoIzrU1tXJgQbw0gq8RmlYpiOGajZY8RdRLDKG4
         phb79SHQdWR/mNHtCckhqLRwV1+/fXsaWDuvypKAUzwug9N54HzU0YqSTGqeRi7k6J/O
         7XWpqDP1SgqBR0UkIwXV/eJFk4MYcy2lgYVcmf0EC3sni+8KI5Bsx/KU9yGsEHMSG0Fo
         oabUOobWlrHzOKYLhw/MWdU5TUzpPtvbagfyB79lGFoJOTvzfP8GMckfv6BI+zI1xw8t
         aL0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXqJm9Q/ERJB4161SpLQUJNO4YYhTupN8H4r5yX/jG4XnF6oDGL+0W6WaoGZAJgCoDguIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzWlOPZvP6HjaKDQYXITzuHveDqAnRMnUScV4GN6AfuEljc1iV
	Vmh2pxOjiSprR/dHZMGuhdr3o2Hq3AJ9uPEm4qmjOOsFVOU/WpA70KoVPdTYMt8=
X-Gm-Gg: ASbGncvQM2iY2W0pehkHNwyn5JZqS5W+8FfZy4iSmle8mH5OSAkB+uoRCeWk6fWveUz
	P87zrKSH5yI2n9JRc+pJcrmuRWn+xF0m0fbZeKb6NcgEk0+c0gKps8b90Uz3rVtpT8AWjK7DTD4
	2TZIWRcQEpPXQbfsWmY8o+2gUwV2Q8TftZ5LnCF5kXtXYNtevyi5OqJHBxsEsGOpmWgs0266qRJ
	K1sOh+nMDnZWsY2mykyKlXX3cz2Qvlos0t82et4Dpftt61Z/j1nOMwt1kawf9zNzLJBRTLhIq3g
	m8UrM2ztuBWnH3Xxur8mKeN1kWcWHMjLbzcTzsEQupdUB3q1a3s=
X-Google-Smtp-Source: AGHT+IF87iJk/TA43x3Co0c2zSLHfscJBqgiiHN6Ikhb88yHzL0ezxJVCrI5abT+ctobEAvuJ/KsMg==
X-Received: by 2002:a17:902:d4d0:b0:221:1356:10c5 with SMTP id d9443c01a7336-2317caf3186mr6221335ad.9.1747073119092;
        Mon, 12 May 2025 11:05:19 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:18 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 08/48] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Mon, 12 May 2025 11:04:22 -0700
Message-ID: <20250512180502.2395029-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
index b0eb02c88ba..b97746faa87 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1182,8 +1182,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1341,15 +1339,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
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


