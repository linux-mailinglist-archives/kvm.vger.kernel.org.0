Return-Path: <kvm+bounces-45534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08BDEAAB79E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 665547B520C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042F84A654C;
	Tue,  6 May 2025 00:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YMBbwn/9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35AD3B11C5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487234; cv=none; b=liVd29rxcqYjsoj2hXRgB9HyNiL5TjVOo/797EmLmHRxQ/D0xZHweewDSnO3m2SZXyewMOwStQ+QRzcODkJHXsxtKXovatYJ7BJdXOyhNwPR0sbXy1WbS0qa5JgrsWBiZqcCKqw0kHJjqWiwKH7oFvrkDAPsrcMCnH/61pt1DV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487234; c=relaxed/simple;
	bh=AEdec6YxwqEM2SMva6W9gXoK89VbojQSf/TWlriKM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFb0sCMnMQAecvjVRWE6tmSqTl7NSSlHPQ59gukoirO5/dEOzTBqmHgeYGxsCPQydDVjXdaepswa1KpeOAilHEil9G345bq8v3PWwc47NKFnVXjSTmzGPzjNMRG/KcoDeXTobm7g7le/JpPanxkYonPPlIe/yeK9fEClxbZMNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YMBbwn/9; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22c33677183so59912305ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487232; x=1747092032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=YMBbwn/9RxOCoMIn64p3/SJPhVVxJYLpCzGLmHLszUsdM0RhSO3M9kug8o3uoRLKhz
         XXAiHgPa9cQ6enVz6/9m1KqmOV2ca8dv+GSviGWpPVHmmmFtN3LM6ZM2tWdNBbft2HvK
         24yjQVjRiX/2xiTw7XRItwl8e2LCN2KlcI9g7NRAofx8tId12lJGXo9P+M3rE44SJM91
         ZT6EGn31dV+ka5mdySpC775Ytpy3YsneWaAG9NsAW58tjxnH7qIAz5p4DHBVAy5Cb5XB
         Lh9ZjrZ/bsRN6tQw6yHet+XtEky2JGwFF3xcYmLYulOX8Uo5/HWjaICYCpIcZlwOpXG8
         rMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487232; x=1747092032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=sNtHwgJPW9ooEul2WtHZzRJCCUH6BulTcZPeuPSH6RdmHSFZYYT04Ctnp2oINbabV1
         h24u88PkW0lDDGeKmcoWhOmX4nRA7f+rtBUakUlp4uewocaY8VhGzUMlaJCVGvo2UZ/6
         ogcy4GveW1yXqdtJLEOEpE+/DrI5KDU1RP9UzwHanBivfqSFgwH/kFsz4YflAr8so6m1
         V8Dy3QHe50J6whwnnj144/8ZGKJB5C3nAoIRn3W/3sng9MADkjmljYuecykiRRhDYJfk
         XHvMSL4Fq3/GsA6mLyyjYvhoYvdfyyEZ+qgRAVDFGhz/EVyuDeDTKQneJVpHFwEN0/u5
         9QLg==
X-Forwarded-Encrypted: i=1; AJvYcCWQtDElIjHm+z2JqNcx9lQ9Xorcqs9UiPeDNDIfMA2l9/dLdcrZ+iv42uYIbsdNo7/0RgU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3m0xtK9+cbwpmIR6Qyfs9aPBRnaJQ95hFb+ATJsHzBhQD7anc
	H1sRNQFMlwyLriz+YUCmtwptCl6535rVz7QyfkYG/N1N1UF0nPIS81W4CdWc3VI=
X-Gm-Gg: ASbGncubpC1PXaHcmXOFdtbB/kYTuV2pcoid3eqZP/4pzrX4kDeodqiSdLvivbrRUM/
	4n6LZAAQajTnuyzikohP08w3MM8dTDaUlJL4yfS5tgn/ud2g0A8fCwIgpxqQDRD+mrn7JK/RkRZ
	Gh/ai2nHDsD1SwcElEroYSu39Q9O8i0bntgqNn+xQUmEji8ep7ZtQ95Cp+oIyyEfhYJm+ru/TDY
	MPhSRrLUz88zYqpv7oVxiEaFx48KcM8QTZsMxWgCaYvGWhdEUG4a1tl0sXnHBdOizYuqZ252XNO
	f6q6Tv9OciKCJhxgrEzY4bzXiwMHSJCnU6WjyIr/
X-Google-Smtp-Source: AGHT+IHhb5KrNk4Mgz8Jm32CJdaDgHXvMSFxZLzvYea86hfhE5UdJkPL9MIT+4Z7L5B0TwCmGOQzrg==
X-Received: by 2002:a17:902:e750:b0:227:e7c7:d451 with SMTP id d9443c01a7336-22e1eaa4478mr136820055ad.29.1746487232193;
        Mon, 05 May 2025 16:20:32 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:31 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 13/50] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Mon,  5 May 2025 16:19:38 -0700
Message-ID: <20250505232015.130990-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 89e305eb56a..de214fe5d56 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,13 +11,9 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64',
-  if_true: files(
-    'cpu64.c',
-    'gdbstub64.c'),
-  if_false: files(
-    'cpu32-stubs.c'),
-)
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c'))
 
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
@@ -32,8 +28,12 @@ arm_system_ss.add(files(
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
+arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
+arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 subdir('hvf')
 
-- 
2.47.2


