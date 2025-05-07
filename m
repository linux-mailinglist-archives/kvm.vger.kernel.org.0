Return-Path: <kvm+bounces-45775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42142AAEF5F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37C07986477
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5737128BA9F;
	Wed,  7 May 2025 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PnmyzKDK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063692918C4
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661373; cv=none; b=LKVVggNI15essSH6J/buKmWtrqFR9fGU6hnsZcYIX6yq5eJ0Pz57sHvsq1KCQHOAmQOLYFM01Lx9p34/VBD0yiKRDyvf1oNuHsRBO9jjwnCS++tuP04rIYjFsoT61nq8mM4h5FAofMs2vfQlv1t5qrYwPTpZCjAWNqWRN+lDT0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661373; c=relaxed/simple;
	bh=gPyqX7/a+yWPxYGNzwg0czwFhoYu0SfjXLT4PWcZCAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2qvWgjqTXnV7m5J4OeDmEmHzbrU5K+7IfTlPJuXhvMznfmL+3DzL84gCMmNFoL1wNKGuF8NWbcWfbUcPl4NjP4bg07uLR+6Qlb0G+iRByAiFeSDSuBiCgKoqMrw20hEsI4gKaqIrRKz94cG4bi0G3GC3VK6q1Ray38lYMlYJRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PnmyzKDK; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22e8e4423ecso3901705ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661371; x=1747266171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eeLa55SzX7Awe9dK4zRdJwFSzsCeJiaBfVkd4m0OHRI=;
        b=PnmyzKDKR6BptA62T/w6FXLpRArRA5N6Jst7G/7f7nMoS8MlbObd3DY8m5L2++04cv
         rzwuSueb+hPqNEZK9N8LT0jWHamttDLnnHNC2lOWIQBSifN8ZNqBFUNJL6x8W7vFE21F
         mX6qmB0YD0qDWNJ+5oYnirmXb7xzTtl8FK+x9gNn09TLgjGjZniYedoyrTLDoSaADyB7
         ravwsYt8MIn8xW0LqR3MGV2w3WyHDN8dp2N3uf8BOEI4MkImNJweqVn3xdOZxRvilJUf
         aiThMi1k7eiDxbduup17NAeODhwGdk5sAekeUsFCvQFyFvOgO/qJsW8mH0eNF1IkU71A
         QKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661371; x=1747266171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eeLa55SzX7Awe9dK4zRdJwFSzsCeJiaBfVkd4m0OHRI=;
        b=YA2g+ClravLyge97bohuATDFGEmOpevoI5VYucJsElUiR/mvLHjXu7dx0xeZE43q3p
         /y58h8Sak0l8s40t9aBo6zSTcNUL05MoemxKTB114lpcJsUrzG+y66aT637+Ld//4dva
         BbqzV7A+JzUmcgbr3G/gd8ep6tO1/jWbN/TLR55v4lLl9RQPppxh7f0x65S28FI6RUjH
         HLZfQTQXUZrop2hB6r1XPMgBxx5ZmU7HH+MFfRu8BvSTUtytip6iQiCvBqLkDzXBeMUm
         Mjvuw9DrfvpPibQnbJn00n8ZNXoc9u3j54Z04Dmno1W3lLUAufObklb1XDxVzRQ1TztX
         P6+g==
X-Forwarded-Encrypted: i=1; AJvYcCXd3useKwLNplasfM2WRpDcMTYaEo1XBTWxadiIYB+ut9NnVCeS33ijMs7eedzEo5+tIR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzS7xUMwDuLa80OxJBdvVD8ASY3bjC7MkMN5jXNzT0bnOMCw8x
	qvKR7KU2kTspsYLNwxiuu73Re0kXh+G9kk+e10O8tIQERSqWyuvSlB8dhyzuq8M=
X-Gm-Gg: ASbGncs6M/Vbzp37eFRbK3KxUq3jKQWFUZpdsRTpgfuikrJ0qH6YqtabXwgiZ1zRUlK
	wgf0MxO2xcunu0IIQjjEoKgI/Wpw6mAlJafa2CQ9vX7459YKBELZ4cCeyyRAid5V3tgAlsK+jIK
	bWTg03wrKHIATQFYneqO3RsuStOe7O8DrSXerCt84J5PG7WklGi+eKYmL0hRyMJVYeYrBvXuklg
	F4cMV6E1UwfiV7DRa8Uwl8318XzWEIp96/7m0AMdaVBUD+yb5OA0vZz/WaBAnxkQnq4wMLeXCLa
	mY8cqUVcyAU+QySqMqyTjX4TE/niJ2aWRorUCXKu
X-Google-Smtp-Source: AGHT+IEM99O2b2UnNUSxhoZQhjrZxHOh6vHDqf4IdMXmXOb8iZbwhEjpUUo/CTJ0GCRvuLSYmd0K2Q==
X-Received: by 2002:a17:90b:3dcd:b0:2f2:ab09:c256 with SMTP id 98e67ed59e1d1-30b3a6e7b5amr1778610a91.33.1746661371246;
        Wed, 07 May 2025 16:42:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:50 -0700 (PDT)
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
Subject: [PATCH v7 09/49] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Wed,  7 May 2025 16:42:00 -0700
Message-ID: <20250507234241.957746-10-pierrick.bouvier@linaro.org>
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


