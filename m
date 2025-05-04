Return-Path: <kvm+bounces-45296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA73AA83EC
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DFC6189A76A
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB7817B425;
	Sun,  4 May 2025 05:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y+T+NaXS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA0A1684AE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336565; cv=none; b=GLDmhFxt5OTh2qAgoc4hRpcB7NY0RM/loqPJQrgyJSm2DN06Uef7A6TaNwiSw4qv649HV2ZdajQZPcmKvnSMI+d8Xv4ih846emW1QZTfYdmNxJTw8QgI03V+OkR32QFEECJj9A/6Di5/vT8THEbzF195wL/GRgNKA1g+2CvrwWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336565; c=relaxed/simple;
	bh=aB3IY1mr/RP5mvJbUmi+A277E5ivi1af/PTSPuD6SFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvwm5VTyCFZFhyq6j7lYeGsuX/Btor/JEoRutCMlfscwO1//3Bp36yycKdKn05BaMbkw4Dm5FivPtKCvQRV9qhst0Bat8jg/w7ycGBp3g9Mi+sH+Nvul6vw2mtCpUN9URtgHNjmN2zfyb33gSDBVA/74Rnf9Uuwp0UD8/jSzA7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y+T+NaXS; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso3518566b3a.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336563; x=1746941363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACKFwyyWU6WsI3NK/C2B6+xTRZ3tXBLAzhxDpMaoiR4=;
        b=Y+T+NaXSmvdcygIg8iDmH6XfXMoQYZ4H0mD4hPrTBPhej+PecSiVrtLa70LEojRhDi
         kFIJAiyqkeFs9n8GxCuGRBNEeMGqsiAfAd9zplAputgDEl/F+asxX9f0clwvMvzoBcwX
         WhRgzeZPhQ7IZcYwxEHiJHOrY9TQMSQean0ERyPpe23H+krZm6xPLkDuXeVGwcUBuO1U
         8exxs+v0iof65GerfhIFGdTk3MdDtrKOe4dc6vqfMmCGFsBCS+G9B4106N1Up7oqpi7g
         bsuBE2aE3MIVGImI3uU1QJ13f6AOb6BeJVfAzfWpiEiUD9FtPVxNhjtoLNaJxaJXcF35
         Fvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336563; x=1746941363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ACKFwyyWU6WsI3NK/C2B6+xTRZ3tXBLAzhxDpMaoiR4=;
        b=UbUXlagwyTmOEtO+OrE8iqgiwV2qN1BNUd8T2T5ylHnryim3vvYsxOtJ+sURvjLVJl
         JSFJQH1LbW4nocrJYJZulhYbT19mwtQfk7naX+inFcnTOdix/4jtnwjILftoaUvIjeks
         oNWBjpu9XWywKXFU5wj/cY2mFzr+dc0Q6XHKPepfLQJYxeMqXoiPo6bg3PkQ9WP7mf8p
         FLG7aO1LArbqzcOZ7AoD6MP8HDG4S/+ApmtGHZN6m0vVSavDC3utUfpXIw8DXCRXzvX9
         aW2qCehivDW6shTdurdY7MFO0ZN1sdSgAwq3BhHS5aRt4DuO75eUxDcWUauGQOng045K
         AlTg==
X-Forwarded-Encrypted: i=1; AJvYcCVbYzRnlTfNdyn8CEojij8iD7RDO1OA+Y9lnv+i16NfpKG/Af7YscZtqsxlnq6VbAK2F7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEizM3JJXF7/cdatCZdBe9cfD3ONmh4G7YtOOOk8gCpOTF+t80
	i8tJE1JnW5p58J5xS3Zelof3t5D18K01F5PUbsnn8kyBwuV8IiCBib9kC3Eqwic=
X-Gm-Gg: ASbGncsHf0OP+jQ4a2Ph9P74vsN7BwYxeC/Wlw6+2LZKfHqwuGw5XUumVg3vbV2OkN9
	O0IWWyqDnYC1jMcWfgxELeAusciSTl/tk++5PrgG2eAs5yZNGAilu1Zbbj1lIz0zpb4FLH+rh3s
	CYe/qpyTsv7UnHQh2Evf4Wkakfggzz2Q2syEhkXzdJd9HbOcYVRWfk7NyJie2VzIR/rWOsl6JN8
	ZzJLp3W3dMMeD8b52sOiUFyDBXh0wFdMntCkizyjpXPxFtfxvdqN/1Ws1tB1Ul/uyYY0S6oC1GB
	6YFosgnPvqLzy31bqyFnozOw1gn/oaoJ7m966NbI
X-Google-Smtp-Source: AGHT+IGjACNX5uAUyFCHGk3bklz89ji8zZKeOyLS4Gcm5HJgZXwpRju3I7foEuYzZHYmB77R6TjtjQ==
X-Received: by 2002:a05:6a00:6ca1:b0:736:5753:12f7 with SMTP id d2e1a72fcca58-740589050bdmr13949906b3a.3.1746336563237;
        Sat, 03 May 2025 22:29:23 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:22 -0700 (PDT)
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
Subject: [PATCH v4 03/40] meson: add common libs for target and target_system
Date: Sat,  3 May 2025 22:28:37 -0700
Message-ID: <20250504052914.3525365-4-pierrick.bouvier@linaro.org>
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

Following what we did for hw/, we need target specific common libraries
for target. We need 2 different libraries:
- code common to a base architecture
- system code common to a base architecture

For user code, it can stay compiled per target for now.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 78 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 17 deletions(-)

diff --git a/meson.build b/meson.build
index 64778edeb2c..6f4129826af 100644
--- a/meson.build
+++ b/meson.build
@@ -3685,6 +3685,8 @@ target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
 hw_common_arch = {}
+target_common_arch = {}
+target_common_system_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4088,29 +4090,59 @@ common_all = static_library('common',
 
 # construct common libraries per base architecture
 hw_common_arch_libs = {}
+target_common_arch_libs = {}
+target_common_system_arch_libs = {}
 foreach target : target_dirs
   config_target = config_target_mak[target]
   target_base_arch = config_target['TARGET_BASE_ARCH']
+  target_inc = [include_directories('target' / target_base_arch)]
+  inc = [common_user_inc + target_inc]
 
-  # check if already generated
-  if target_base_arch in hw_common_arch_libs
-    continue
-  endif
+  # prevent common code to access cpu compile time definition,
+  # but still allow access to cpu.h
+  target_c_args = ['-DCPU_DEFS_H']
+  target_system_c_args = target_c_args + ['-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU']
 
   if target_base_arch in hw_common_arch
-    target_inc = [include_directories('target' / target_base_arch)]
-    src = hw_common_arch[target_base_arch]
-    lib = static_library(
-      'hw_' + target_base_arch,
-      build_by_default: false,
-      sources: src.all_sources() + genh,
-      include_directories: common_user_inc + target_inc,
-      implicit_include_directories: false,
-      # prevent common code to access cpu compile time
-      # definition, but still allow access to cpu.h
-      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU'],
-      dependencies: src.all_dependencies())
-    hw_common_arch_libs += {target_base_arch: lib}
+    if target_base_arch not in hw_common_arch_libs
+      src = hw_common_arch[target_base_arch]
+      lib = static_library(
+        'hw_' + target_base_arch,
+        build_by_default: false,
+        sources: src.all_sources() + genh,
+        include_directories: inc,
+        c_args: target_system_c_args,
+        dependencies: src.all_dependencies())
+      hw_common_arch_libs += {target_base_arch: lib}
+    endif
+  endif
+
+  if target_base_arch in target_common_arch
+    if target_base_arch not in target_common_arch_libs
+      src = target_common_arch[target_base_arch]
+      lib = static_library(
+        'target_' + target_base_arch,
+        build_by_default: false,
+        sources: src.all_sources() + genh,
+        include_directories: inc,
+        c_args: target_c_args,
+        dependencies: src.all_dependencies())
+      target_common_arch_libs += {target_base_arch: lib}
+    endif
+  endif
+
+  if target_base_arch in target_common_system_arch
+    if target_base_arch not in target_common_system_arch_libs
+      src = target_common_system_arch[target_base_arch]
+      lib = static_library(
+        'target_system_' + target_base_arch,
+        build_by_default: false,
+        sources: src.all_sources() + genh,
+        include_directories: inc,
+        c_args: target_system_c_args,
+        dependencies: src.all_dependencies())
+      target_common_system_arch_libs += {target_base_arch: lib}
+    endif
   endif
 endforeach
 
@@ -4283,12 +4315,24 @@ foreach target : target_dirs
   target_common = common_ss.apply(config_target, strict: false)
   objects = [common_all.extract_objects(target_common.sources())]
   arch_deps += target_common.dependencies()
+  if target_base_arch in target_common_arch_libs
+    src = target_common_arch[target_base_arch].apply(config_target, strict: false)
+    lib = target_common_arch_libs[target_base_arch]
+    objects += lib.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
   if target_type == 'system' and target_base_arch in hw_common_arch_libs
     src = hw_common_arch[target_base_arch].apply(config_target, strict: false)
     lib = hw_common_arch_libs[target_base_arch]
     objects += lib.extract_objects(src.sources())
     arch_deps += src.dependencies()
   endif
+  if target_type == 'system' and target_base_arch in target_common_system_arch_libs
+    src = target_common_system_arch[target_base_arch].apply(config_target, strict: false)
+    lib = target_common_system_arch_libs[target_base_arch]
+    objects += lib.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
 
   target_specific = specific_ss.apply(config_target, strict: false)
   arch_srcs += target_specific.sources()
-- 
2.47.2


