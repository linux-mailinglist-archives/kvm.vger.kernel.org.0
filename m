Return-Path: <kvm+bounces-45298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CEEAA83EE
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FC44178D62
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748FB189F20;
	Sun,  4 May 2025 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X8580mZS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC73E176AA1
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336567; cv=none; b=IzTpkX8n9eCFbBPakvrRVlEnPT/o+zMZvKUFROcrs7rMCcgyqgvk5zPSL0Y3VKdzuRqSj8QBE0FRpvwxhxqHIwJsdkQ2LFDli1aMcwN9WyRFt5vyrXgdXAUjWGeYFaJF8n+7U8nnLhUiByf4G/NAdYXs6xV7eBobrBqdXmDRq+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336567; c=relaxed/simple;
	bh=2Zt8LVM3xhAvrkKXp1FE9DExT7OPgzp6oZUZ3a273Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp9AEzEq8/zyl7BjmqIPArzzvKAMnrEWCrSZ64vMHkrzsEvQRo2ucr+iy8FzeGWy9wHkA3p9pbDQUj1XQzr3D+M7HYviCsYr+Jy+srzFNgB+qb6CE59L4D+pOTbv30j98/dgm/+Wmolp4TDffhOmUxdCpjQmXbTenaoRKzDLqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X8580mZS; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso3435586b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336564; x=1746941364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPUzfDhhl74FQ921XpGJdIiei13N9+1r4RBflBlQkuA=;
        b=X8580mZSxyriMyqx7j76U/Io/jAXFLCrcQuLRDnvg+qJo01u+KVXd6ttROFO094ogq
         pWOSp5wS4dn6YmSFzrimNxvvpATzI/4Yexa+SMLGZwwwu4ttc1D6KWGn7NxvrgSGalKz
         NRhqFON0L14cnvv3Cm4uy6O3zvnHqbwsDD3fD0WFtttQzgDe8i03Ws8BDbr5FWbKG+li
         94El7ieovfln/R1Z1yU7807mUePbIBNq7BfnYiWdEmrcg1PuxdVt2M78YHFaSMrvdCUF
         U9H2+mm0EAAHwpTL9MEoLncq6tvgd3atytsbEL6tWHBsFIECl7Q/eP4gz+ys6oX+ZHLS
         SK4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336564; x=1746941364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPUzfDhhl74FQ921XpGJdIiei13N9+1r4RBflBlQkuA=;
        b=DYqIwW7UYdEgbxkM/7Q+LqsvpmwCKHmed+EKUYb9JTZOymRcoWbWGk38So3ym79nY4
         x/6hb5FvNJQy9bStszdJVRHKBaKdntpBSfX++UjgNi0A7qxDMMseOo0c23/hlbL210no
         9buOaD9XeJm2VcJLkZfbRot4ZxmHhE/7H18FA83ALPQ10sPUCPPpGzjL1FcbQWEFtNDt
         BxCsBxX41cHFPnN/x5khI8GHVhcXQPLN9xJDT+uD0FU/tIBomKDht2SyLSEDBl5/CcaO
         qfH5U75Mq9iGezFTnCxU6Q80dM+W8ZuWaPeTB9L7aQOKsuOx3/VRet+AI1crHdp47RWQ
         jsGw==
X-Forwarded-Encrypted: i=1; AJvYcCWgrib/MH2/FGfm9lZrRLxz/im6s4qGykNqlmhEEGtfHPX8JSCNDsk2uLanjLNrrSGGSZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrIFp4QUlPZyIgr+QQcIxABcBVeIQ8CGk1Mr1NiWQaooeAoE9G
	KOPhQ8RRCW6nkfRH8Qc1YXDXXmXxIcZHYF8XkmJpt4JjWP8gJuPR8Px5fHxeJcA=
X-Gm-Gg: ASbGncv3YQu6o6Frb2hPHi4vGnFUvROQgh6JsfJaIFsDtrZAJEZ93xC5b6GVz2MSwOP
	SIagYKeWTyABZv7rdXO2rvRmwZh9lQ2aPbCdoB1zuXDi9KarTC0ZjByMUWtd2XrPBB/FRcvl4mF
	mmsYbxwk+REgbjTwQpdPOepfIZGyk4UhPtUB7X7mxwXc56TUFLqe8cSVVs8wRr8DmewCZDKpTh2
	y+ZpDA3y5n8+uiFHlAuViUiCcJBk+t1yeUHSBHR9amsLwQp9hiSFqknOXZFTIYwckfP+pWt7RKa
	r5Cj05SJ7yXn4p4wMyKnkiQpZkjhjVp+DAIVGB9e
X-Google-Smtp-Source: AGHT+IF6fi7TCVQkX+/SReePQP66TObCTTPRskSVKzeExfBKNEWQDe0rnw6/GqhpugwJflD0L6wMsg==
X-Received: by 2002:a05:6a00:ac0b:b0:736:50d1:fc84 with SMTP id d2e1a72fcca58-7406f1a4357mr4097937b3a.21.1746336564105;
        Sat, 03 May 2025 22:29:24 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:23 -0700 (PDT)
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
Subject: [PATCH v4 04/40] meson: apply target config for picking files from libsystem and libuser
Date: Sat,  3 May 2025 22:28:38 -0700
Message-ID: <20250504052914.3525365-5-pierrick.bouvier@linaro.org>
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

semihosting code needs to be included only if CONFIG_SEMIHOSTING is set.
However, this is a target configuration, so we need to apply it to the
libsystem libuser source sets.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/meson.build b/meson.build
index 6f4129826af..59c520de359 100644
--- a/meson.build
+++ b/meson.build
@@ -4056,27 +4056,19 @@ common_ss.add(qom, qemuutil)
 common_ss.add_all(when: 'CONFIG_SYSTEM_ONLY', if_true: [system_ss])
 common_ss.add_all(when: 'CONFIG_USER_ONLY', if_true: user_ss)
 
-libuser_ss = libuser_ss.apply({})
 libuser = static_library('user',
-                         libuser_ss.sources() + genh,
+                         libuser_ss.all_sources() + genh,
                          c_args: ['-DCONFIG_USER_ONLY',
                                   '-DCOMPILING_SYSTEM_VS_USER'],
-                         dependencies: libuser_ss.dependencies(),
+                         dependencies: libuser_ss.all_dependencies(),
                          build_by_default: false)
-libuser = declare_dependency(objects: libuser.extract_all_objects(recursive: false),
-                             dependencies: libuser_ss.dependencies())
-common_ss.add(when: 'CONFIG_USER_ONLY', if_true: libuser)
 
-libsystem_ss = libsystem_ss.apply({})
 libsystem = static_library('system',
-                           libsystem_ss.sources() + genh,
+                           libsystem_ss.all_sources() + genh,
                            c_args: ['-DCONFIG_SOFTMMU',
                                     '-DCOMPILING_SYSTEM_VS_USER'],
-                           dependencies: libsystem_ss.dependencies(),
+                           dependencies: libsystem_ss.all_dependencies(),
                            build_by_default: false)
-libsystem = declare_dependency(objects: libsystem.extract_all_objects(recursive: false),
-                               dependencies: libsystem_ss.dependencies())
-common_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: libsystem)
 
 # Note that this library is never used directly (only through extract_objects)
 # and is not built by default; therefore, source files not used by the build
@@ -4315,6 +4307,16 @@ foreach target : target_dirs
   target_common = common_ss.apply(config_target, strict: false)
   objects = [common_all.extract_objects(target_common.sources())]
   arch_deps += target_common.dependencies()
+  if target_type == 'system'
+    src = libsystem_ss.apply(config_target, strict: false)
+    objects += libsystem.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
+  if target_type == 'user'
+    src = libuser_ss.apply(config_target, strict: false)
+    objects += libuser.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
   if target_base_arch in target_common_arch_libs
     src = target_common_arch[target_base_arch].apply(config_target, strict: false)
     lib = target_common_arch_libs[target_base_arch]
-- 
2.47.2


