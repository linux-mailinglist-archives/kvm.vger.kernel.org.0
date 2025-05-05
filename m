Return-Path: <kvm+bounces-45374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D3BAA8AD4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B23C165D05
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DF31DF27F;
	Mon,  5 May 2025 01:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GjdYlgBE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4071DE8B5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409975; cv=none; b=TNAzA7qdgOzmzzVPgK65tBCyal7/4hwTcWuBhpUVGmrev5Sb+mQUKEfBraoHf4Ojd2n01yQRLwTWDeP0rMuVkBUjVRTmbjMGW73r6OTro7nK4vIjBB2U6oDa011G6H2P/770ERDtXLHp8to2tDEbI5yyIFh0FTc/2Q6iTZWj/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409975; c=relaxed/simple;
	bh=QTKVnR3dxb6YiT9nVr9N7IaUWwG0tfEl4EVtzghDltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJcI9Vp9pmDzGRiSGnJcyYxDob4ktxdbAmE2Vm1CfT408exa+8kcCo/qA4OeGNBNJ+zsC8S9SZPAqOIBaJkV8ST62lI5pc/i6M5bzctOX+xPKSETQ/1T36c2f6pnuXJ+oE54nHyQDQkbgKU77p9zoND8+ObJ7LTNwdIgzMq9aaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GjdYlgBE; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736aaeed234so3388724b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409973; x=1747014773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=GjdYlgBEOE9Q1oNVs5EpU3BG5FN2el6jU7dIPRO9Q9rR/WLqS2gOA9rJ2E7YtQc3gp
         0EO7dYtY2K77Y75KAD4BxsdeDb+uRaDewuIf4L//+XXPlpJ+xnOBpL4pTBEvgRGp+Igu
         M2aZyDfwGWjUuwjWiDn1lsZweLZn0KCOr+SQ+QE7+TiFtUaOrFe97K55gBuyVT0Vs0oY
         UDDS8iZEIbJypEd+Tl3Vyb+YS4trvqgGWaCbUxRElqJVHtZ9vCF3RgcSS4g3J4V4vI3f
         o79+dM3AP8HlQN9Jt5rE0gi8x4Y9P4xbnD1PHfOdqeA/yC+i7iy84bjywlGcyNgtCN6o
         XLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409973; x=1747014773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=ovPR8cD7o0+gTgFxYdUgpoiQQNi96iY96EWLQa8Q5B0VFAfWs1yWts61os/KTjoIl+
         tLNV/5XRDvLQ2dkonC0Cn2/MoxK5lJMD8EqrVdFI4uzoX1ZVQ9UI4QSbnXh/UzTK4zCd
         D9J+n2w8C+j+5sKQs78+SmZiLq9VnZmEjarqA7NaDQHuNArVJFUhxco4KLEfvKi6NDDS
         Jue5hkqD0/7R+Q1MFFfLoySoIxVM3IS7SXU//EOe0SvNQny+GnOJU+xMvLmQCb3v1tBC
         eVpuic34hJW2+Kg/bUuZTNwcAh1+cPDMm7keEF7BbSm9SaJOKfnkByHM9tg4UzzBHgp8
         24mQ==
X-Forwarded-Encrypted: i=1; AJvYcCU67u/QwJJbSmfQdJ7C21Uplwr00alAskClGPdTXJ1ItpUnLWjvDF4xuXwBlYsZzk/6E+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww0+bsC3/E370hySytkWdf3tc3/Yy/COKd3UfYgd60gkIO92It
	WQ9n865e7zR9PXN1Cfh8wzfJzAE4HECZsVTF0JX924pl6HLWY03xbwq1l32/4Vw=
X-Gm-Gg: ASbGncvmMphJO+cvhNa9A2GBYVG20VMc5MejWONJ3hcctRo0qTsiQlO/U4OdhZAwOxu
	6BQsUXZbbA0ZqoSo/9rYyyfZ9YPCoU3EhbqzITGT4+NdeBuSA5VAMEx0xYiZ1CAepgpBtAHCaX6
	Q9eKQa2izzB7j36VhuZS17dQ74FTHkKIjf3haxiRaTmFdQ+p6+OHHaQQEAkPlRvy8Md7YSu/2j3
	00zUnyK8O2WdYqJstDUIspNc2bjKVT6WYan5MBIsqluUf6WBzWUBP0EMagJAE04L0Tg7g8C+PYt
	gazGkKpWgrNpnLMo2QTWsFGoay1JkYtOzW/ySCPh
X-Google-Smtp-Source: AGHT+IGBQ16QZAGwgjeEboATnbwXZoFnP6fmv9Cr4aS9PWpTHF70jGWZcZkTQiKdWRxPemZ0zpyEXA==
X-Received: by 2002:a05:6a20:1589:b0:1f5:6c94:2cc1 with SMTP id adf61e73a8af0-20e96ae6ab0mr7772543637.21.1746409972928;
        Sun, 04 May 2025 18:52:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:52 -0700 (PDT)
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
Subject: [PATCH v5 27/48] target/arm/arch_dump: remove TARGET_AARCH64 conditionals
Date: Sun,  4 May 2025 18:52:02 -0700
Message-ID: <20250505015223.3895275-28-pierrick.bouvier@linaro.org>
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


