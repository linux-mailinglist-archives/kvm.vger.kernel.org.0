Return-Path: <kvm+bounces-45511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3809AAAD57
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8C346582D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529B6306715;
	Mon,  5 May 2025 23:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U7A+jTKU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C70A3B2883
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487247; cv=none; b=I4tsa6A7fMWDPWxjv2eIT6e8pbaJSK25SRm0clnZDE9OQIpnlXzwzBJnMWwH5dZAKZ9dsrI1Z1WsfFU3elbz7amgnJGiESo5NmAYtCEoaAGTeiCqACVDd5hCCeN7kmFNxXDqEzqjqtrWX9rLr8QIe3+a4oS6T2amABLtYvtL4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487247; c=relaxed/simple;
	bh=rVRDTbWWEqwgabZa5zWcVeyAjZSJEYR9LpoFB4OvRA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUxyAUAMdh7dthQwwviaC5WXAX7Sb7KT6s34CMGkpSCVJoUSCorc1A4aqmR87bSChdfY0rVrL+G95PGQQqWkGCKebyHiERHXwZi/ftAqHHFPC4A9p6ZLE+SwrIntHI3VzYBxAtTz0okEnF59rQRGzUU6VOCf/ac+ypjnmyzluZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U7A+jTKU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22e16234307so27973125ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487244; x=1747092044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=U7A+jTKUxp9sW4K8cV7cSf2rxhZzOwOUHTZlosFvx46/EpuyQLr8ohaW5PXZR97s1H
         ZlA81ltQrP+NNf345QlpIfvcnUgqoAxP+urTNBlXCNJyMJ5s6GRDnl/XdOBy+KfqZcPe
         dX2CPp7pkkycB7R7OLYpNNikLaUVBpQffXn+OXJpkXfnQ/EX5c6XbaYYQT8ptXRSCupO
         phtuFBFiagfHMmo2AepKqq8xDRz8M6TfHR6lwE3Mr6jCS2DMsevJLi0SUZ9qcZ6Y6+7J
         6nYwC7cR+hZ0d+gjveFtja2X6ONB8TrdjsoxAJEbKO3wA7CLmoY1xMicHRvRCuHCvlXU
         9bpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487244; x=1747092044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=wPkHgYKPm/C9Z3HfKXmYNlmfbsOBOa3XscJFtdblagMwwYPzwMjii8ys93Z0jD+qaK
         hqNJzIZfuelOHKCdLkOH8xAjCz/7EryV85Y2j9TdA8L/0tkWe4t+Q6JwVbMtw1S0Oedu
         RloTL4PTS5yjaIN9wA4YRuFnZopqv9fKzTxZbA1c2NjuCVrqQROrSLxqEK0qUMuGgjLL
         wEcrP0SAIBT53VBXlbrexIzAiObCNZHLam4+iJupeWixti9TGuy/vQYfZO1CRo4TOjD9
         i0Pm0LTANu1K8C8VAOEYD2g46IocMLtw8mzQ3CRuhkBnqxDmTyN7TZmqFv7fys6ONs8S
         pvng==
X-Forwarded-Encrypted: i=1; AJvYcCVVJKSHKkiWdb0Nsefe9o6b/03UaeVrYuPYNRSUIU/8R84Hk5Iddphr3qMRh5mnYKzaWjI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/pstHXgEv0saaGc8gKoGQN2oLgym9vJXilfzOVr31WUlAQYQz
	1/pTlDMiWhknrIr1hNUlp3oeigPrD9moJtRlOXHXrtqgg3DhFpVode9z4NRLA94=
X-Gm-Gg: ASbGncvhSPjWkWcbY+dqRfU8nXdKy7enZMuZPL2mFecRnNh2/hzbtRDjpaMRHzDlqqN
	hurBsE48xkIzX5eWxpiJDZqxQNDQ9eZ4JBvPwfL+aJ5i8x78m+3aQta9SNkgQaMkuQgT1uj8hoH
	mSe25tKDe2k5VWig7eYUhL8tC1L4n9uEGvTX0I3wxE/SxTecrI2VfYfxqhNx/gnUtyJ5XCK8D2o
	cdsaJmQLYpGXeOGDDAtIvR68vFYAEMJ362iJ6jBxQ3Z9X3DnQ5E1nY5wJrO1u9/5l0e/ck/YqHq
	jY9/4ZeRWfwBp3RSL8SRIkm5KiJ0U/MjEBdxvz0o
X-Google-Smtp-Source: AGHT+IHCV1/1mp/qT4IZJkCFBwSLPw5Wv839QyIwwKaT5xti1xiNSDzwuFxBUCyW4d3HFhph5x25Xg==
X-Received: by 2002:a17:902:f68e:b0:223:3eed:f680 with SMTP id d9443c01a7336-22e3285f33dmr15966585ad.18.1746487243719;
        Mon, 05 May 2025 16:20:43 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:43 -0700 (PDT)
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
Subject: [PATCH v6 26/50] target/arm/vfp_fpscr: compile file twice (user, system)
Date: Mon,  5 May 2025 16:19:51 -0700
Message-ID: <20250505232015.130990-27-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c8c80c3f969..06d479570e2 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
 
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_user_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -40,6 +40,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


