Return-Path: <kvm+bounces-45800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F1BCAAEF83
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0C031BC539E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563FE2949F8;
	Wed,  7 May 2025 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vY0CnlxL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1736C293B5C
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661394; cv=none; b=jjHKLlb6pKzqM8lxDqOS3AH0JuRERwbL0/b4/suH9n5BAy55BuqkWDvykTeGff8E2tKjjiA23GQyOdZMHEyF99lnUkGhjVeghFbdAscZndgTGJwvgCKPEJeZJsnEPRqfnN91mOv5voeOnPzuR4sgoX7lYZe0I+u8tLjeskSenCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661394; c=relaxed/simple;
	bh=JFv4YlTrDm1SIM/o00YgUrqEFpXOxh+2IWOwbnFpb2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dKInotvOuCnyu2MoSx5SYVJo2MWZ717b52CCpHghcAjGhXKLVwxfvgCZ4a7d1kDQPRd+4Rm8J9HitaeaXyqllrqqVjzdOZs6m9sMYqZ3EjTZ8Ti1ltK3xQpy+s77dY4bAl7zQaJ3hq9sdxVvHfxH/ewpwRvOOVPLqldyJ/fjV3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vY0CnlxL; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22c336fcdaaso5165675ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661392; x=1747266192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=vY0CnlxLbTw6+DYu2lLrbRwmFhWjfU+gV1+iSdTOgbXH4hos7S9ohpAfgfkTWdSsbx
         Bodm3O+G6SyN5AXvdRMJbQMP+ZDgns6HKNRm2jWvhcgKL+D5SVNqULERq+5EMVzK4GNV
         pfxkHfklt3Hxr8gNC0n9jnS6dhzS9AlRKsrYdAcX9DFBGI3tn1N80qIlgvHEn6Fd8jUJ
         9KTrp5bS5yF4WfmN95ZzRkd+yyohmCqNVFTNDLF1ykjWTNy7TlAsatMEwWxk9qj9+h8d
         F1nwAwWDS8nBphRQDVfpaXzg0n21wqSuCSJTRJj1zdW9I8DuYyvle/B1Kc4BuoiDcM0N
         dVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661392; x=1747266192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=XS26kVBqnPigZQyXk4I8qn5phWr029k1YvyUKXZbpLnqaAL5k7IkVHTC0KSL8KhbR6
         ijgkRo7wwXG27fMEHJ2NO+60n1d2jIaS5zsZUJP6DeR6+67/k4NUHN5yF9osVu703tRY
         wpP/2sr80sHJFz9nnGmfbcX53t6QSO/1T9YkRSYch01U417biUvuswNvKpBOhoAR0K3g
         tlMdNEw0cxwIpdLLxAzlf8fAa3+IbJ9p7/UYJo5W4Q9DZK8tvCGKsJM1bF5IIYmm0pzt
         Su4GSQSmSmgooVBnE4KqbQKtbGqo/qSVeL2LfWn+M5PKYhGq3VxD+FznvSfE3lldU9GM
         hgjg==
X-Forwarded-Encrypted: i=1; AJvYcCXXR8nJg/kgRZL68lFHgcdURAdGoDXlS4atyButMx4cHjPabYk9d6R8oHy3IXimiJ26LVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRLLGkR9j/dtelCVP0IFE6FIAfIZ3PpGa7/yNWVuK1wXZZpIWp
	Zhz8+i9g/TJwjLJuOMQaUUkzqyKgqGMBdnQarCwIytkuhDoia6LUEeETJ4bN+FQ=
X-Gm-Gg: ASbGncuUb901dh1GmFs/8DvV/DoqQCX/13L2w9X4b78qFy9X4pr1qOqq4G8Pl48jVPW
	6Ut9bC/uv20BUtDAYDXEzv1DilxGks6g9LXYGi+oMKdHFcOExrt/pWVYVEpv/N+3WA1P+kFHIZj
	2Mo6dZC1jM50mhk1qkQq9yr1sepFuTjax6ypa/JG8H6mgCD9nLT2LpladgF2NUpr3TPtcgbelfh
	yMckh+UfvPf3DTsjsqEdQ4hTfjIMbMcJEX8mFF9tN2ULS+r2929Apx4nlW+sBGCiAQzsFacT5HA
	5wE/SzNrjVyjL1vQJV6LC91zhvWMWg+bY5gPalcF
X-Google-Smtp-Source: AGHT+IGl8QMLkXX0N5h5JsKWC5nqHNtFaM2hyM/uoczjU3eRHoUb/MaTp4KT615HMMrJAssEpmZ66w==
X-Received: by 2002:a17:902:cf0c:b0:224:a74:28d2 with SMTP id d9443c01a7336-22e860ccf77mr15541875ad.26.1746661392516;
        Wed, 07 May 2025 16:43:12 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:12 -0700 (PDT)
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
Subject: [PATCH v7 34/49] target/arm/kvm-stub: compile file once (system)
Date: Wed,  7 May 2025 16:42:25 -0700
Message-ID: <20250507234241.957746-35-pierrick.bouvier@linaro.org>
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 29a36fb3c5e..bb1c09676d5 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,7 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
@@ -32,6 +32,7 @@ arm_user_ss.add(files(
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
-- 
2.47.2


