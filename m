Return-Path: <kvm+bounces-45320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B43AAAA840B
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27DEA17A161
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D664F17A58F;
	Sun,  4 May 2025 05:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X6+omtfP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1317A318
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336586; cv=none; b=bChh5ng71vmWatHoswICCQBHL/5S6KfD9tPxl6MX0edz2KZ3FB11gUbCqLpuY+sz0ZCpYAzWo+WwOrU9duT5QTUddSjANePhDNS2mEZegEG2cSWRNFbsAOLf7oG+/WRwa3Cfk8A0aOZPBzWGxjU5HEZmcKJLjjJbKdZxNyTbaR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336586; c=relaxed/simple;
	bh=QTKVnR3dxb6YiT9nVr9N7IaUWwG0tfEl4EVtzghDltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMnKtr2E21o+QEitNwfPd/aXFPZGk/AwGMw4iE0gkDkH3Fqs5CdQTYrv1P4SbJ0/nvLqEnf58SXhvMWMZ7W66bQ1ki6IV7zyIJpUWlHaPURYwquTD4Wcyh+bHIddYhXqU2H3PXy7EO5NNFfctru/tK+e2Yei4qCEKYeFV5iH/BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X6+omtfP; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-73712952e1cso3370906b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336584; x=1746941384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=X6+omtfPsj2pUD/zsoHHzE2u4dgXtrloTQr4c5ODawU/WUF41ymj9Oj50j8Nfr2sKy
         sRpsIVK7uhGTRuCCYyR7ssz2nzgz4QslWdz/GMQ+IewFhMymQnREp73ri+ZGjllyPSDN
         Sw3epwIAfudw1dZCJuJs75/C7G7GMhS9Aj/ESgmuR8fcFlvch+pNsPF21e2dXcz7BMdo
         YFHk6bRBZmNCnQyua9WWahdwLDRQvVfsnDwu0XMf037W2ZeEh8Zd2HyOG/cf1/MfpuUt
         qUXs8sb1u5+mV7X7yWvK5I1P+yLLfb2Mpf9WuS1ekoPo4/DiKBN32vvwYSfhXyRcm9eQ
         +psg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336584; x=1746941384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=BipkRgoka2tC7C+JCqeTi6aFYu5t+ewikl3/FuONuixYyRI/d8L23FYINCJAZZ+AM2
         gkeXXtvzdcUQ1LRY57mwylthCBqxrFZMPoL0KunBvbnUo+f/AWpQ/tAcJUuEB21J2K49
         sVqmvO99b13TZO9xWszizcT0gNuZzwPasccZVl7MOOzByk2n3U0i0g/xWVSNvof6IcnS
         gfy3hgiRnV1YNEOY0R7l3KnehIzYXcUqaMwiLc5JODs/ml72w24qy+3h2b0q9L+cG1tJ
         z5BnLvu97JkOvAJ6a0Kp8bXgGpY+oGWeg6i4Hla8xAhIeh4ZGdg71SbBGlElH2bx9hjh
         VgEg==
X-Forwarded-Encrypted: i=1; AJvYcCUro2o1ihQ+DjIxl7TO00/xOWjlE3ID5eYnPSbR0iY/Tk/CSTd/eFyEjCxTiJ/7PKqTZ8E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjbmw5/ZFlVs7fUk4l4XVPe1c9smQPyHQJeTLJyu/Fzm9Zajm4
	zvpNeyrne2/J3J2gFnUtSliqNZgGtojQiaGdi6GAnGXia5v28ECjc1zkXM7o+6I=
X-Gm-Gg: ASbGnct4WJ7NRMzbM6OhwWszf1+b2C4s1pulGYkZmZlFP3YxEeH77hJOCuKtlyZ+8mo
	g9gGbifcdlYeJaD9DCV94O1vD8w+sfN4n8vs3cqW5HZ42v3at4UEik+Toi0Qhtr2M+VgeZXIzWW
	lb+Ufh5jAAXheDzWfS2+mzuhWYtUeMxlBEWEJKb4RnLkZwW+D9QhktYoKKpXNtdDwUoYse8kIjI
	vaRfDHfRnqiKk7pEbjljcuRqXOddtFdEZxazSXN+DTp6aDpMh33cS32DGdjirTug5xE/UdIXOm8
	q8eZIGAiv5j2oFInfu9HbF59bpAROO96qBKgxRzuHufg/zTmvH0=
X-Google-Smtp-Source: AGHT+IFFBK8c34bQn544bg+nODkndDO7YUq7xG/ssggchm4p/JYvKNTvfhwfbEZR6iSs/1WMinW6Zg==
X-Received: by 2002:a05:6a00:e1b:b0:73e:96f:d4c1 with SMTP id d2e1a72fcca58-7406f0d9ef8mr4125601b3a.13.1746336583780;
        Sat, 03 May 2025 22:29:43 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:43 -0700 (PDT)
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
Subject: [PATCH v4 27/40] target/arm/arch_dump: remove TARGET_AARCH64 conditionals
Date: Sat,  3 May 2025 22:29:01 -0700
Message-ID: <20250504052914.3525365-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Associated code is protected by cpu_isar_feature(aa64*)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


