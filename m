Return-Path: <kvm+bounces-45305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F01D7AA83F9
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEFD3189A8FA
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48BD1684AE;
	Sun,  4 May 2025 05:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u0PliVgu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5741922E7
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336573; cv=none; b=SVrCip7yz57S857bv3X3uIhUVzXRnhESjIco78VAxDJyipZNI/DmlCM1B/qU2eTomtVct4tTkthMQrFQk1ExoZkyO3WqsiGJu2lmU2ZxjnOXXizjZzmJWYPhM2tdnRlTxbDzwjHw/lKG5nWpgRGskkcEd522dnpYJbiBeB5RR9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336573; c=relaxed/simple;
	bh=L3RK6cazlD+4isklQrUjoRwmR2X9C06dPPYneBTr45Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHh/++k3EUtniI62UrWgkskDEV+dFVFoARf44mwK5GUMh6hedI46x7/r8fc3PENUjrq/6fe39FIcyNQRtXLL4IifxHOYJch3VYPenI5khhtIqyBaN8DILlLf+Fj+LJaYlbnb+2JK0PlIBDmEfhx2plvsOe3hPvO0aMMaP+Ath50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u0PliVgu; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-225477548e1so35486705ad.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336571; x=1746941371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=u0PliVguKNy+VDBaZhOiakLFnlRbYS3zi5RBqopC91jkH3wsSilMsmZCEixoEddVsV
         nQi71LBVdA0ZRykEHF7lnk+xRZOZoiLVyWYXn599ffz0MZfflkr7cvUh9g1WzMU1us/Q
         /iub4UhWvwXLgTkz0k5C5EfNflrPmpLoTaq1y7YPp0nc8J/jQrnhfOng394k1pVpEUn7
         wHWcP1VykLP94CGTmHOmWspo0d5RQBED3NchTHAm4F6dPZP82f/GjDNbrqRnBAS5WJkG
         1x9W+RswDYL/Zw1PhqqvQLFMm69HiNY735B/U14rj4gKa8yK6aFx/Y7mC99djTy0y10W
         j/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336571; x=1746941371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=Vun25nWiK/QtU7YIU3Z8viweDMiL51ys3IWvEmKyu3aDMq6SD203DkSWPYYwgO5/tQ
         WnHxgUEovmQU0wF/TYwPda18TvLTewcCKr6J2KvV1D248iD+hQwu0tg5niPRSLX1cV4T
         UoGJeQIXkS+52GyoCJVFuUk/QvaO1WhK2OEaMs9sRmnBLtWVNrgQieu2V/Sjm8appRoQ
         M6SvczX9C2LeXtjnLZnnerjzzHvHTAd3ouUCgSKNY2qUa6LSS1qoGV+KytTV1o+g1jtB
         k3c84QUn3O3Wr01oO4l8miVK1qFi4Uj5XUsfYr/xv59oIidbeHZiI3yfarC9Mzrlx70x
         dNQA==
X-Forwarded-Encrypted: i=1; AJvYcCVnGnhXz8Q/IEtICp5Kys6PpasFnGQDG3+Jfss/wv7O9VBUFXYrS/FkxEgTRBP3hd831Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFnl0F+7NkXVeG/02VgF1IPEnyTvqaWob4eLZMKPM3x0jrQOfV
	purHgkHSgJ7vY8Q78ZEVbMzreydwBzp5iYGrPtvJuTLH3/HYjPAR2qkvHOFye3U=
X-Gm-Gg: ASbGnct+5IluWPZIVz6vMAB5tP3bX5q+QAB6qooDDZQxmKv5Xi5WGu5PAEnM92hW29j
	x97s+PNbX3R8/bgwDah1+76er/UE0cp8ozjxW2LwKTZKpmODUsxfAxgNlUJ5N6dIp75Etem/8WD
	AYaAIMA/KFxyZVQW0dvePWgsxzRtNGNcLFaj51HElqXnJFtwNdnAszg01Cwr8RQHL26X16jBIYi
	ywG5tG68xtFoXG0lD5FTI9SFL1hB+ArSZrQ7i+NopFt14pfDg2hSXghX4P6o7SbW+p8e1GB9hAr
	H8E+J+8rlqPs9vJ7W5HzyOl3rK2rddVq8vGFfxYXeXY20OEdvEo=
X-Google-Smtp-Source: AGHT+IFH2CPFEGOsr4zP8J4shIfyihEyvBzrlgv7YDD+ddkZeusvCH2PEX4Qs29NQDrJVY0zS9lFRw==
X-Received: by 2002:a17:902:f60a:b0:223:432b:593d with SMTP id d9443c01a7336-22e1ea87a44mr43546955ad.42.1746336570833;
        Sat, 03 May 2025 22:29:30 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:30 -0700 (PDT)
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
Subject: [PATCH v4 12/40] target/arm/cpu: compile file twice (user, system) only
Date: Sat,  3 May 2025 22:28:46 -0700
Message-ID: <20250504052914.3525365-13-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c39ddc4427b..89e305eb56a 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,6 +1,6 @@
 arm_ss = ss.source_set()
+arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'cpu.c',
   'debug_helper.c',
   'gdbstub.c',
   'helper.c',
@@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
 )
 
 arm_system_ss = ss.source_set()
+arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
@@ -30,6 +31,9 @@ arm_system_ss.add(files(
 ))
 
 arm_user_ss = ss.source_set()
+arm_user_ss.add(files('cpu.c'))
+
+arm_common_system_ss.add(files('cpu.c'), capstone)
 
 subdir('hvf')
 
@@ -42,3 +46,5 @@ endif
 target_arch += {'arm': arm_ss}
 target_system_arch += {'arm': arm_system_ss}
 target_user_arch += {'arm': arm_user_ss}
+target_common_arch += {'arm': arm_common_ss}
+target_common_system_arch += {'arm': arm_common_system_ss}
-- 
2.47.2


