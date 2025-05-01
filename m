Return-Path: <kvm+bounces-45032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9614FAA5AC8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6571BA751E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490F326C3A0;
	Thu,  1 May 2025 06:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YMaR7MJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3627268FF1
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080636; cv=none; b=J11Tp1APzIDeyyLK4QMI6P9Nj+W+ha536YqyxAoLu23cUdW1O5B9TEySi1Py3ZjSavfePwUvkTq5ROTq372h5ZAL1BOWHM+5Ck8Jhem31ahrvyqM6vK4KoYdggswfB/6S3z1ZprVNDYdfSpPQQTMbaRY/zE1+RTTkYPWiYDD9gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080636; c=relaxed/simple;
	bh=CU4h1uCEJVcOpx1eBC5/bWxXgC4OWAabA9+JMuwWEto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9dv9qv/ewNieU65cZfzXGxWvwnY1iIFfk7/42DB5qkBhc5PSTnxS79bfipiT92bajcPuf3kOKN6fcwAyn7nHjsXrPoeBixB+uijjcbymuoiWHYMAQAVC3XG7QGqKreeUC/dsVi41BTryY/27lariK6yGg4U5AYNaDNfDYa1Eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YMaR7MJ4; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso987631b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080634; x=1746685434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRQcX2zj5rKRmJl38W94XdQVe0UW4OEH2J5EM4DWdNo=;
        b=YMaR7MJ4ycrnoXRkWXqRrZmVLBHz3xfhSt/Ekt80YEx3D6PiaysImqttrYZQ1DMXvJ
         wWE9PhjV8kZpK1NjGiGa5bE4nKWu5GqxBQxexLoPffinfs9yY3ajhE3z1WiuJECZpqRq
         KCCLP0LX9agHMMsfiyPUkpAVjfIW8sT0R58bcoRI4B1iFxHw2SUIz+BJwnrIX4c31VNG
         49E9PCgC2klXerZu8LMrMw2ef1jZtngitVLL+YJJD+PJIGfW5JhfZfkUuzxbmZR0+m0C
         eugj8KOO5vlHZDHzjXAGrW1qI64IHH5z1iikmFev7eXWAm5XthkGK+izSeb21U+CtMhU
         BMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080634; x=1746685434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRQcX2zj5rKRmJl38W94XdQVe0UW4OEH2J5EM4DWdNo=;
        b=HwTsx+m0LGCVQFBNezv19TvyB3/QWoU3Hlp6+Hob08/2RTXhQq/9q0zFyVCPMDfPKR
         wItdrIwi0nBbPxdZ4HhPJkTXtIBBWfd6g4HhC6T0ai/1evSzcIjArmj9hT/3d/bY8wCY
         nP0lJEjSkib5DEH/Efum+lcWcmdMcP2fP/Y17ZA/vg3BUgGIGlwyoi2Jsj8nBby99G1t
         bQSQxTbEr4BO6kDjYexFdYi3mNUWSHEpzY+LzFa9dkNmOEH90sBq69dKeJyXjfFPhQAQ
         6VqxLpHSTGbrNea8M4CVtGLKr9jUvfu3x1LkTDr6ZgtYoQYXEaDQNcowB862PjES6wN8
         NBBg==
X-Forwarded-Encrypted: i=1; AJvYcCUAhG8kle4D17hdQGmYmpNh8L1cI5JQ2x/0utvKQyl1VV8ZOWQmcLArtib/9mtuj1uuy7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm8bX/xy/QwBuw3uVqu1KA+DkmlAqJClBb448ep3uCUkCCvAlx
	z18jxekYSASixuQG2TaAxCpZOxJR/14OdE+iHEymaUlm/jihUlCHX41uaTU5PcM=
X-Gm-Gg: ASbGncskzSnKLG5hUqL2AMKfa/kb4faqPHIhCJQZgzXkzA2Oz9U5ZBiKvnfs+YklbuU
	liA8M5xLht+I2TeEGQGq0VFSxRR4dNUIPmbqmxV0Gme9INe9kGrwctwqVeyEB5ivM15KTpUg3H0
	Atd41n07qpKWZvFI6uGajuRBHHeh1G/fGS/9F2uAfps30Nk204EJCFuvR9O9iHNMuqQUKXpgChg
	H9kLAJkvbkDYt6Yw68hI95uLR+yBFqn3ztxnpJ3tdhVSkuP9owLEumlSPfYQy/W+zCHqKhxw30C
	VMWAwcnBBjg+u801zQhTH9c5y3GVAO4AOtdYaAFX
X-Google-Smtp-Source: AGHT+IHKWHJJEyntNtUOURmqxwObv8CnYTNyX1sITXamA4/jKCZTWAekB5bBp7ZEISulZ7JhHIow3Q==
X-Received: by 2002:a05:6a21:1788:b0:1f5:837b:1868 with SMTP id adf61e73a8af0-20aa4380499mr9068562637.29.1746080634113;
        Wed, 30 Apr 2025 23:23:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:53 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 03/33] meson: add common libs for target and target_system
Date: Wed, 30 Apr 2025 23:23:14 -0700
Message-ID: <20250501062344.2526061-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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
index 68d36ac140f..7b2cf3cd7d1 100644
--- a/meson.build
+++ b/meson.build
@@ -3684,6 +3684,8 @@ target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
 hw_common_arch = {}
+target_common_arch = {}
+target_common_system_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4087,29 +4089,59 @@ common_all = static_library('common',
 
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
 
@@ -4282,12 +4314,24 @@ foreach target : target_dirs
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


