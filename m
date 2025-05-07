Return-Path: <kvm+bounces-45794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7B3AAEF7B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 748635034DB
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD9B293742;
	Wed,  7 May 2025 23:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jAbJyy4/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23392293472
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661389; cv=none; b=D8BZ3FF8ZTGXIMC9ThSENLAEc4qkXfxpWh3jIafvnYAqNwec6A8EuMnXNKA8mnupwZqyffs5P0FPpX3ET4BmXNKHpNWGVTrlVKr2gb3QIPtacXQZiEnu5lO9uJxf062IVDuu/aEYweu1S6EEkpW+SRjAWunT4cIqvO5owBg1bfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661389; c=relaxed/simple;
	bh=jBQ48UUiTmKfd2YtIeycQ+HfzJJ8p0Zs5JvaTTN+QW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rslvaQpaB3nkdLDeo816mrd8ZqcDGrud0hNlarqhzQHKcnxQ+CzP1wnG/B4vE09V2Yk3Z9IlZGbnwJ2POI3yP+OOhG07tKLoqTem2We11dpiGeVM0pVh3jPUxHZLX2f1KKR/HsDEQq/d1ijx++e4PBX5hp+I6Vv2dxhBs1cuJyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jAbJyy4/; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22e09f57ed4so17063405ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661387; x=1747266187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=jAbJyy4/zBiEG2ewUg+ZSf/EHjiGlff+s7t6l6whX2CpypCp2MWp1QioC0IdP9m8RK
         e647596kJT1PvhPh3FAgOXYDO3BUG55CRPHhDR4k113gnrq4oY5gkE+diGEc3T8p0v80
         3LhLYfu0CIgWOOq7NZnOqkJVTMQRq1Tu33wcyFABrE2VF5QYzCwewfNYxtpZQR93aJT1
         Lf2lq3giPNZcGJgflavPmddXPvqmPQfxiZEAs60jfmsMQLaHalI6aPpsyChiC4wtQfwJ
         J+2xSnyMk0UOAopVUulijCdHqr0gB8NRCtNKGLJj8DAxhThhvWLwDKc/DaHYmxnfkc+Z
         o9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661387; x=1747266187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=eHJ7xWxXAkNPvmhi942KAFFiajw8YlIvdx/NbYly5clI8lPgtIroGbBAn3GGVVgvGD
         CPzRAcWv9Z0nDu9M7/wWAwoEGSDcu91QW5a7Y4rB5ANbA1IP7NrHB26cfG4pUgmK43vt
         jgWfO4drgykIE16v975CTUF2PnDpWNAvk58QrvP67XLrmH/1QuTAL5sPYvL5C0JXke8/
         yhcBMAKeoSimVL1TfODEsGtpQajXnV389QqdpEyVPfA+0d4JRoyAgZMqASFqfPaULM4w
         zUOPJ6+ACP7XS+UgEGlgtxWxDkLJMAWNxXUbtWoD6N+ITjHSy1M6MGGjAwEc4ZGKaMm0
         xG+A==
X-Forwarded-Encrypted: i=1; AJvYcCVtv8i0WjFMlRSRs+eaEYUMNBmK2i4wKA+GNyeJFDeEjCLwgsBk1iQPKsH6uh2JOTcHwkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWZDrK718buyWPli1RSSpe+E6hsABcndFJ8VkZT6B7ZFr29tkb
	mH6PckzZphR3pI6+/T1e2taN8EIU8fx/U0AoNXT2OWgMUxBkQytCmHYa4v0BarQ=
X-Gm-Gg: ASbGnct4x5e5V6wzRN5DW4EK2JGURusLq/gdlPbe7+MTngGBnYPlx8ogeJueYbnMQ+B
	6x9NGDfT5UcWWLQS8Z8PzAi8557snZ6bRzH43dX3haN6l0DjoGzzpn7uqucfPgGS3Q+Rt9ghOAh
	vLU7Ld9Voc+teYfA1kPdOLFKNIHMO+LDl4Dh9feLajNHJ/gdSDMR/2FzU0npBwMhF5mj5rjNsHf
	JUzMyGuadMBd+dfcMKdVtdr0hgRzHs4N99wixbwc1kHYTU5DWxKPqjdmyBh4gNmPqXQeJcEcAhO
	s6fiCeIF5hoFKfw9yde2WUhyNOishRA1dqkGl1Cb
X-Google-Smtp-Source: AGHT+IEYPXXe9Sd9bJoXec6MHpYABc/insXv+r6ni87IqJm+3koI5Clcb8DyzO39kuVZq+4ZV+I75g==
X-Received: by 2002:a17:902:e803:b0:22e:50f2:1450 with SMTP id d9443c01a7336-22e8476efabmr20725095ad.22.1746661387529;
        Wed, 07 May 2025 16:43:07 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:07 -0700 (PDT)
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
Subject: [PATCH v7 28/49] target/arm/arm-powerctl: compile file once (system)
Date: Wed,  7 May 2025 16:42:19 -0700
Message-ID: <20250507234241.957746-29-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 95a2b077dd6..7db573f4a97 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
   'machine.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
+  'arm-powerctl.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


