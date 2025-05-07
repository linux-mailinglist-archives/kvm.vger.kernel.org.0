Return-Path: <kvm+bounces-45792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87733AAEF79
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DD371BC468E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6493293726;
	Wed,  7 May 2025 23:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oZD2z1L3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E35291862
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661388; cv=none; b=AP/1K0Wu1JtcqDWs6KZOLSi/1JFV6dOA/Yk1GTbEByWuXqmnzw+L55r0wW/tQA0YYT6xDI7uRRQcv/IsQqSclcqMQNfl13RPKZ1IHvjlNUVEUrVtZhvaeHPf7Vgzrx/WFuryCJcjfOwlsnmXVaFKIf70cXidSiMxQq/7NLXMpbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661388; c=relaxed/simple;
	bh=QTKVnR3dxb6YiT9nVr9N7IaUWwG0tfEl4EVtzghDltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7C5X05M2JDzuchDYyCwA5FdqTxX6e9/DiN0a9VlUhOx1YPn6Jc790v/ycaXBZlkSkerKoRO6cvtibD3tJ6k4sMFxmmkye1Yv6E5SMDm13tXPa3K2Sk4zz2u2ImKGKU1c21l87rE75fXMBCyZof5utGoc9g/v910R7HCiWcsAyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oZD2z1L3; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22d95f0dda4so5061585ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661386; x=1747266186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=oZD2z1L33KkbCLfbL39EXnTcwzuJfzXilDV4aoqQdIkXCw6bb+KWS4Tofyi3oGhJqr
         qLuozVjmTUQKYw8pg+a1scaBkaObOcBGQpAo3kgl/Serr1tudSVnPCXPQrviovZM3uZn
         v8blK7C4f2VpavJakR5UIEVcR9M+aDuL/1Fge/UYPpETxKZ0P9lnDI3c14e2MfVy4jnf
         hfOTLl3i+2qTSxhcJ0YAwborL1+JciONHJWKomFgdcoEonZ9Zm+3ZtLKvGmiCdR4J38t
         K0uXTGLjT14XrJCcMeXaib307ZixPfbZxKRiDBPZ7ZWNKeV3yzVKbFeArgF5pg7zg3xy
         u42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661386; x=1747266186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=w/olAAN94IC8j+PHKq8KsM/OnZCIJQWWAQKQ53p3kiRtba3pt1HxzMYmmcgshywK52
         CIVUu162eYhMCSY7pADkoKtn8zcXtOgo2c9P5HSc1t5iDw9+zDflisxSesznsngGFsuF
         j6rWzxIOJ5O4SFH7p3Xa1PMDfGSQdu+hznbL8CqfemI70/oJSQikgF2FjvQNkVkv0nyl
         Nzf2H2QlnxDfx4XPlMNG/y4jOovhJMB9M3RGZ7xghB4E8dmdyBjbVj5yduHScuD6zdyF
         R7LmGqsWEMgtyP5QHhgzPgU0VAN9tyrixYLpmRDaclZ9rDQnJs3ePfrPuk9UYNFW/VuV
         UeiA==
X-Forwarded-Encrypted: i=1; AJvYcCWLzCs8EJDxMrsSW7IFrs3lopP7gHx963TANySWprUB/BCOMkaFN2A5cjqIH0cKaWPvy6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxtPi6EgT9cmAnx1X8yGT2ig8i42zdg+B2Hba4O0P8nal9Oulo
	C57Rve9PO0L4Ij+ZJzHmg39hqwJdr9RQ5LuLBmjR2jOBHM2O4llZxZBYhZqTLNE=
X-Gm-Gg: ASbGncuyjvSUWRbvpWgqZ4rutBVua5T8HeEZ5SqBpId3HXRb3Rdl/HBQOmlY+j5K+2H
	EJo+CqxdvSo5HN5QJ63M6Qp/uc2oS9A7v5LEEhqSXOBPOSFV/r6J3vJ08XMMyZPy/l3YzHnT5JR
	X0VqkjcSjQi31q6bFwD+zAMHEnzpweiBtBuDRbZLOKZL6uObr5yRIU7mkQBdB2JKRHvjIiCYwMG
	dKFD4M3lr2FrKAPi+hUST87FUjsfx+Qqki8FqLkur8lUwGYSRPpUllOp44w1rS6cIvpVsLV1eKM
	m9+++RUqUnt/t2SBiEVsN/XB1vsH+RzDbUT/guLK7nxK8pzO9cA=
X-Google-Smtp-Source: AGHT+IEU4Pf5XRCP/PZVO8a05wh2KG6IVjY9T2lfZS6hZzaegkdfG3OhY+b1/nT4B2UQV8lzgvaq0A==
X-Received: by 2002:a17:903:2352:b0:220:d078:eb33 with SMTP id d9443c01a7336-22e5eccc55emr75031795ad.36.1746661385885;
        Wed, 07 May 2025 16:43:05 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:05 -0700 (PDT)
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
Subject: [PATCH v7 26/49] target/arm/arch_dump: remove TARGET_AARCH64 conditionals
Date: Wed,  7 May 2025 16:42:17 -0700
Message-ID: <20250507234241.957746-27-pierrick.bouvier@linaro.org>
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


