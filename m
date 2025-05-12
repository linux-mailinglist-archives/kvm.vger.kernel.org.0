Return-Path: <kvm+bounces-46226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EC9AB4241
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23AE217A0B3
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9FB2BFC6B;
	Mon, 12 May 2025 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q7sn+iQh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08DC2BF3F9
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073136; cv=none; b=YzhuQWycjt/21+n2DMuKSJAKnCxtFAwigKS0RzuiKljcrJ1iggZK4O+MIbyQ2QMANsijRQc4fMnFsjZvSYUYrmfMdfIz/HI8M2vJLZOsKKOJigb59XGq1EJZLVnjbhemQVJfEiNrtgbefhrFKjFLMVcD7zYpfQ40PeNmqh631II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073136; c=relaxed/simple;
	bh=QTKVnR3dxb6YiT9nVr9N7IaUWwG0tfEl4EVtzghDltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pe03hNQbw+4SxM6UFIxAklb87+6BC6tg8BDhDA22wbfSKymVWxxmBx8mCeMBZo073TIMiGn1bYP5NZdLKl3PTgMEyVULt+oFvIwC2DbtPY+hH1yDMtow5xBOhsChFXWAcHa31azpTOwuMkzx16l2SYmHk65f7BLqxsxki+n2kqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q7sn+iQh; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b239763eeddso2936927a12.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073134; x=1747677934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=Q7sn+iQheZQaq/QkROsZf6/7MrzLidp1bS9AbPGQEWLLHX7Yi/VOwtW1e6+w/Ymlft
         aTZFws5glqyTiAPTk3evfE7iqfhnrnbHsxr5ny+cmXBb3coSBfQAi3JO45tgzzuhBF4A
         DNatRWku//+Iqx4wtzHkcQdB1AOtWC2UAnz6ZJBwXSlEAOURnr2IHHavBJOHsTxwl11Y
         BYarbnTrS5IsbjlVll1TUrcPus+ygjwe6w4B+DObMl3y/1txJZgMJie0qXt11IFVa+ra
         0QJn07Ul6lI335DSvwfyDqAwZMCA+acrSCZ0SGjBQnnhr+nmoOagDl2oZhqM7DYfbeMQ
         S2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073134; x=1747677934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=fy85hwhxrRKlqP0sO5P7BqRpcyjRhoDTXThFir7u3x0TA9IFE89mf4M7AdC+MnuCXK
         aVk8j3iNicwRoEmDV/4wPtaJom9Ryop2QKAAnJ58VlrrS384Wgce9AFZXyoZyso4gji9
         vyyns85gzyCnjHEW86dv3BhA4eO15rNpoD85cCPCaw52l9Q9KXc/3AAoED74DxldXQ9s
         wU7gecifC67TmkdxKGhSo1omfHPy6yQQnV4vJ3Ric2omX9z1slH3n+PN+/VN1hs2oVVo
         Ik82Ps5YSbsoX1R9Qe8y49oIwvIvc4WUdTgD+7X6dI0tGUqx5BeMfh9ULCoa+NxfyPQc
         HReg==
X-Forwarded-Encrypted: i=1; AJvYcCW9pZx4E6dHYLqZAuXAUaJZg1a332tLcwMvDmSXIal+xCk+LX1cdj7VcIBSLYIuRCUAqgU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4xoFQJ5B2zJj2m+huB1ZrUoW+KcdTh1VUDlMWMBw0aWOGPpla
	gf+j5wnUs3qORmcRRvn/wQtvPLqmJnEpCTW11Qnui2GG9N76qjUI/qJCmaaBdV8=
X-Gm-Gg: ASbGncsIUf9PisNaRpAZj/boJdiTg/mBY/YwpFx05uni95Zbv1RTENXRbYkn6mEKgZG
	5OVBM5Da4+Ppqixzpsg49jYVH1pKJ96hzqB09ab3RqmdYkkgMeGmPfQI+XqQ6UP7JT42tOsYxcV
	oBQu8rFjVyW8M+/Ydv0dDbpzuP0sP0HbLSM1HYkGhldv1sz/Kl7ggIcTq0Qw45z0d3lyTWbpsEl
	j5GDXtS0Xldr8fEjLAK4FFu+c/yonPVa7ipoG127EriU9HhrdSfm658oEpLNLqInx4cerVMRzNy
	8N/eTnwovmPE9B8XKAtuswd1VlaSOdV1uwGoYjvkysOXxKPQl2s=
X-Google-Smtp-Source: AGHT+IHRbtBZKrpk84DwZT3SC9tiE9r4mdkW5j7HAsCCRKXXvOFwFcuCksCJ+/nzbAM4OOHTV0FO3w==
X-Received: by 2002:a17:902:ccd1:b0:224:a74:28c2 with SMTP id d9443c01a7336-22fc8b76a88mr210233865ad.29.1747073134177;
        Mon, 12 May 2025 11:05:34 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:33 -0700 (PDT)
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
Subject: [PATCH v8 25/48] target/arm/arch_dump: remove TARGET_AARCH64 conditionals
Date: Mon, 12 May 2025 11:04:39 -0700
Message-ID: <20250512180502.2395029-26-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


