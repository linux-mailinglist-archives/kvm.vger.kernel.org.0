Return-Path: <kvm+bounces-45350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B06AA8AB1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E7B7172489
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E89419E99E;
	Mon,  5 May 2025 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m+0F+CQL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBA4199235
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409952; cv=none; b=q/uHTYgF2wUya3ZLKPHGhzKN98Il7dqgA8t0stVDoNC1ZS/owgFH3kPLEbUhG5MjxVledvNtsn9ZbE0ac/Ya94O/XZkCzpLG4Nmb3d8WAkJFvu/mu5kPemtRW6mr7id4Zn6cIPjobyrqJOYI9/umLlkkFkP9VQckv0xn5EncXhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409952; c=relaxed/simple;
	bh=P7cs44e7lLPix//xHmErLxf48gRN9ICukIqVyQB2TCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk+DMwlYkzbEovzj5WwNqQTRPfdo2nBF3WVNyEOj1Y6a8U0UWAZxGEqdwFHsYTJzRwHwR+D9LnjdtxHOlTctqGtumAdnBaQxo6AsLnnkjCYGxdjVkeYY1oXAgtUAoFG+O9jcZTny6bHj39R6HQEqbgpdFhaF2B/OqrtUqHOcvZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m+0F+CQL; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-736aaeed234so3388619b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409950; x=1747014750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mHjwLOmCSZb7+SiNUT87VRUe5PiKHdCHDdwE+42+GQ=;
        b=m+0F+CQLfTxR2NgIQ6y/6E3BlHibgbZVfmQBaAMBe8m/qXw6VEMJTqZ8WEcomniEun
         1+Fyb505ENsfSJx/ZGTl0vEf8KfyEXluU7+5DL5Jvq3pQghQrPZHmsvyYbFs9Rx3ofUn
         u6eoKzmS9AD3aZpW71C9330n9Ht4dgI8n5PomfAaNFMKaQgjY060Wl0QdctlktqkozUg
         hDHMWQupa/poHVKFzLk0jG5765F3lt5XjPMOAzknAe8Mq+zCvHJDHnrROw2Vc+nrO4Bu
         Li/0EKDcGTV1vljdG3EajNh+0NlAJJVCeyWrkLzfOBPmqXaM8x4nUpRJsSZ6UTBSmzGY
         nShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409950; x=1747014750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1mHjwLOmCSZb7+SiNUT87VRUe5PiKHdCHDdwE+42+GQ=;
        b=WU5E/gHRJ2ObzHOPs87na3Y9DEqbZzYIPYJ05oR/yaK082MHHcrGMXjtIjURV/8PJE
         B2ez5tBoSJ+fGl4jAoM2UKWx3HsMUjnvSotmIlVZCumw1+pyKZ61DvdNweXbKNk+whDJ
         wf4HYIHi3J0I3KDaqdiEh053r3oXtvoxl17ZwU74hhWB+Ub4jTm7D7QbrMysPh4iwQuu
         pJSK4YJdlc1xYMRNSEI8VRn7SBtOho+mBsoTqOkBV/usILD1O0cuFISausXdYv8ybJ9S
         Hp0IwNjzaZS5jwv6qPcc/3gAy80z7vVR1A3LpwtlThIt8NOT8H+ZDPkYrn4ArQL0g8S+
         Tmfw==
X-Forwarded-Encrypted: i=1; AJvYcCUKl3jcCTaB/7OJfNr0w4w1TE0wF9LgDju+xVTULrUyCa1LbDdCfX57LO4HKyFW3tjphvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSB9kG36UJkJX3I4xFiReMBohXRa3aIgCZjf9zkrEu59WJpoKJ
	sBDfVAFMrGa8MRRbn2GWByefkT6Ls5f6EH+SdGbT46xjkYzP0XMAtNU9ryu9XUE=
X-Gm-Gg: ASbGncsiVkRD5sikHXvMwwgWuO20j0hygOvAjxnPMQ+QZS2cUMNoGjRa7E5IPjzu8Yc
	hHqh3NE1Ddg8A0BUXzDvOnMHCKsd6H/nQfyYhGseMcAMWRYFidp+fN3zxIZC2aImnQ/imljPCCy
	tGGKR3WLGoytDdf7l+E0APt1GqRYs7pqw2OXLgg43aLMwIyM0MStNT7OG3ZvcftmF4D6EWFr/D/
	yP94iXW6tXUv+iIKDBu8CgOb61/YjWVqBkecsVp3Ck+kX5vUkERq7VbdjMXCUFTxKHKZ9bfIOUR
	4hwJGF8zNZD3PGFXdfZN7EIVIG79Q3kEHM838Po9
X-Google-Smtp-Source: AGHT+IEnw8VfECoK5fXq9FFAAhr8guvZNgIjGdAHEKIO0OBZTov/PyOJGomE9HYGIk9r8C+GFvgmiQ==
X-Received: by 2002:a05:6a21:1743:b0:1f5:80a3:b003 with SMTP id adf61e73a8af0-20e97ea68fbmr8446109637.37.1746409950025;
        Sun, 04 May 2025 18:52:30 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:29 -0700 (PDT)
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
Subject: [PATCH v5 03/48] meson: add common libs for target and target_system
Date: Sun,  4 May 2025 18:51:38 -0700
Message-ID: <20250505015223.3895275-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
index abdb2cc33ea..b2c79a7a928 100644
--- a/meson.build
+++ b/meson.build
@@ -3678,6 +3678,8 @@ target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
 hw_common_arch = {}
+target_common_arch = {}
+target_common_system_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4081,29 +4083,59 @@ common_all = static_library('common',
 
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
 
@@ -4276,12 +4308,24 @@ foreach target : target_dirs
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


