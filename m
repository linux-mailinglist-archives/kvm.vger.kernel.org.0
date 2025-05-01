Return-Path: <kvm+bounces-45054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E58AA5AE4
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7768117F331
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F5E26D4EC;
	Thu,  1 May 2025 06:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UONbxMUl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F34327CB2A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080656; cv=none; b=d3h+mUj0/T3kJwjwXb98ShMaWrKgGyzaczzkRVSmkI+640JxTMYNXC/0H5RfVJtViM0YqT9r+0KmG231OiBi+6xfOFGRfpyrKYXqXUG0RMSTdRpKyvz1jI5ejEH3rNAXODBb7MJuQcVovtW9PS819kQej9BlP6LlmOI6p1UgxZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080656; c=relaxed/simple;
	bh=d7Y0aJl1uvEpM0i2iSzb0ciUeHLRUAJcKHrcEoyZ6r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMlOh0E42fZFFgkBX4RcPRjmFobgKojfWFuTGY9ZSL27XUNf06ewUNWJh8ZCyk1HECkbADvvlDvgQwwJOwzNdKeoVObneWmhaRwgN+CoqW/bQkCog5MxUkdmUccOpPh4oZCd0+IxcUrl6phAUoaP2zRoSt8v6L91TTVMuBf6q08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UONbxMUl; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso992780b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080654; x=1746685454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4aT1FPx7v6ild1hKo4Zu9XovGo//pi9dSehqEFhLB4=;
        b=UONbxMUlrg3jsHE5h8KI2lskCnigUPGNa+R/ZX3mv1MyxT1kdUCsbZ/21vbbOfoO0q
         Z0vwHKvM6i6wG3qlq00BPfsANnj2/myFK99Z83d1bzoEiam1Zbl8VaMabcBXWkDTQm5e
         6xs3YOjVEix3ULLYKY9fvBF2qfapV28CEIi7oPvPkqoiy4Sf4rEJxq2bD/zpEgje4BR5
         RUevg79YG+uADVmIsyP4GQecFC9jOSI6Y3YN9god7kxPttcV1UCDHvKwYhTNDbSORkJ7
         /xP5Bwns0OWdvWhNvvJoB9KTqQzC1h3XFKpsm2ZRrL7S/blllX7UejaJNTbXLFm2Qsbm
         zbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080654; x=1746685454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4aT1FPx7v6ild1hKo4Zu9XovGo//pi9dSehqEFhLB4=;
        b=JZs5d0mVs6sOzIivUrIs+9JNzGCrdLlbuyUYcEybMrLwxm5UHDs08aYxC8vcHOMSUW
         jOhDJSzsHa7wy5EBYlXxsNQIp4uqvAr2U+Wm416H6Zglk4Pp4SbA1BNTcnKK8jYb7jl1
         b55d2A7EO9cnhWqKEa1/Zo5n0kwdKm/jY57gnDyM/CR6aEM/TM9m69TYY9C7cRfogIML
         Ne2y59GHK1CXRQVlHJy8yswdwPHUQZJX3lfJAjf+qYGWvF3TdTnGKZgqOChxdaPgl1/j
         RJwvSZt+dBwNM4tYDYfY77eDpeBPFUSLURao6v6p/KqlK0fct6lNGYHiBDGzYl6eLOiN
         AUtA==
X-Forwarded-Encrypted: i=1; AJvYcCWMpiC2+osSYGtk3ggupXxTjlx3M2eCIYbiX0kpEs2E7w/i5D35oS1nTUq3iY8b5nKVKag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDkSGULszgFgHpgQMM5CR73e4qSQt7N4vx6IQ/qzTmISzyMpFc
	8eyMCg+l0jn3wU/rZSAgTQxXi3zN0lJvkBQ2p1GfVxHWHJ/2dXbt5Ce3D0GibDs=
X-Gm-Gg: ASbGncuwwjdmczSyO1wpTtX11SRSNaLrpys/lYygBuJRL/Qz0AC5M64VVLPfPUFLesS
	ap1EB+tk+nl7SmOEWQk8XglQxNfg8SRsIfMUFmqIhxF1jmd4VS9E8/xOR4hmlQP543wc32IGXqk
	jv2HHzDH4OjIpKhrDFT898n7CwwEQ54xjn+UgJSmXEQKnR26rXB4e8q7BP616nZ6R2RYOARgUFu
	CT+O+7kLahk1STK2TMOJLzw+4Hott6wFCLYaXIxzflRmKRfSeu9N6lfa4Lj1yc957x00pGhMx/W
	OJLbqtYDn14Adh1pzUC+MTIWAG7oreALvn5UrHiZ
X-Google-Smtp-Source: AGHT+IE2vRA/bWJPyQMqjfkqLzpQvVj8Wad7xwqt7Re1vxsIoaUiDeWrqtNpRohxNat92nerkUYhOQ==
X-Received: by 2002:a05:6a00:170a:b0:730:99cb:7c2f with SMTP id d2e1a72fcca58-7404777ea2emr2728024b3a.6.1746080653861;
        Wed, 30 Apr 2025 23:24:13 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:13 -0700 (PDT)
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
Subject: [PATCH v3 25/33] target/arm/arch_dump: remove TARGET_AARCH64 conditionals
Date: Wed, 30 Apr 2025 23:23:36 -0700
Message-ID: <20250501062344.2526061-26-pierrick.bouvier@linaro.org>
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

Associated code is protected by cpu_isar_feature(aa64*)

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/arch_dump.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/target/arm/arch_dump.c b/target/arm/arch_dump.c
index c40df4e7fd7..1dd79849c13 100644
--- a/target/arm/arch_dump.c
+++ b/target/arm/arch_dump.c
@@ -143,7 +143,6 @@ static int aarch64_write_elf64_prfpreg(WriteCoreDumpFunction f,
     return 0;
 }
 
-#ifdef TARGET_AARCH64
 static off_t sve_zreg_offset(uint32_t vq, int n)
 {
     off_t off = sizeof(struct aarch64_user_sve_header);
@@ -231,7 +230,6 @@ static int aarch64_write_elf64_sve(WriteCoreDumpFunction f,
 
     return 0;
 }
-#endif
 
 int arm_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
                              int cpuid, DumpState *s)
@@ -273,11 +271,9 @@ int arm_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
         return ret;
     }
 
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_sve, cpu)) {
         ret = aarch64_write_elf64_sve(f, env, cpuid, s);
     }
-#endif
 
     return ret;
 }
@@ -451,11 +447,9 @@ ssize_t cpu_get_note_size(int class, int machine, int nr_cpus)
     if (class == ELFCLASS64) {
         note_size = AARCH64_PRSTATUS_NOTE_SIZE;
         note_size += AARCH64_PRFPREG_NOTE_SIZE;
-#ifdef TARGET_AARCH64
         if (cpu_isar_feature(aa64_sve, cpu)) {
             note_size += AARCH64_SVE_NOTE_SIZE(&cpu->env);
         }
-#endif
     } else {
         note_size = ARM_PRSTATUS_NOTE_SIZE;
         if (cpu_isar_feature(aa32_vfp_simd, cpu)) {
-- 
2.47.2


