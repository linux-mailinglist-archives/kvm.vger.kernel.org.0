Return-Path: <kvm+bounces-46204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D146DAB4218
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:18:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3DFE3A7749
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F742BD58C;
	Mon, 12 May 2025 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F/CXL3OF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52D2BD017
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073117; cv=none; b=FTtigOit9UVtedMij5HRKvvqjvTfgCusb7aYE1oSIuxttkBG70Y4f1yoJ6GlAJreIVdV40oqgrVDIzApr4LL7XWR589PakpTi70t0/DygaT827grQ43kLf9UaOT+6zQASDZsu1ARLuY/TJwSAL9aAXjjqMJ5gWnGd9HZjdE7Uf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073117; c=relaxed/simple;
	bh=nHLB4cPQI+YybzMbPC0nddTq4ayzQU1BYK72ytXMW+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMFaRG6B0Oo67fdQFKagFFJUmVSr66wkzhsLRAERTq0mKdtvuNBwrDuP9D6iW/wD0UeRQJyGU5mh6OAxRLZPhOAW+LVr5HEKovLmc0EfMY73SuBDVja8VQhfGsT47uDf5NSUZjyDkFR3mYe7SJLdE0qVwaa/iTBsFyeAobUHs58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F/CXL3OF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22e45088d6eso61800405ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073114; x=1747677914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6FGLSZTqO/KSoe45Th2y1VHmRd/kN2aH8D38tKOyoXc=;
        b=F/CXL3OFGalvQT3zEpe+LdXeB6Ezz1PmxYK8E9et05pd//xZ27lr0cXxZXyho8VtQn
         roXqUypo/EKLnLAZBRo4/p/gUnSExLqU4hm1DztMBVhbOx7XDkQEIGfy6t7sXUPdlXeR
         n7STqwOXVAc5qSezFIZIs6JCoocKIjzS9/XzIVyZue863XlM+TYQV4nxpXh5iS/SUhXW
         zkYa+hz4L3cy+hBBlrxH9qCnvcYaoKdjWpYyDnX0RbuR0EDc6kO09I+A8IFSKxwqSjnT
         1IU1JkW1BasRGHP7ulxlpdgiL27cJZd70fM57ru2//3GB7SfIh3EcGZcWGmc5Jty899g
         0SyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073114; x=1747677914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6FGLSZTqO/KSoe45Th2y1VHmRd/kN2aH8D38tKOyoXc=;
        b=dIuneAZn/sBAJ4r82+Tgy/e116f4kEJYdNPMmeeSIp+7j/U7D+KpnGnsNjPvig7+LR
         Drq+PI4GQTwOb5gDooB8xeXdajHyj1Q3mhqG1y0xqwtOcF0Ap/gbMT5OX2GkZDiZv2hQ
         KODUMeDShQGy83Zn5/vKig2DhetXynklzCnG04dsPIO3cqWE6hBmGVih4UlT9LV+Etr4
         00sy5oohpMFXqnDi3bKsN6ehViwitYrcUhKjZkXU5Cmjpn1b+mYJigZen9Y+EaQYzZGT
         QjmBKGMU9rFMA4XWV0ynaSGhvpKzQTjjK8ZeQjhqtS1tnMPEfvdMsk9J/SFmml0iCBCi
         kBkg==
X-Forwarded-Encrypted: i=1; AJvYcCX7pxj5m4+oiq5X2rdWIPblGFlVjPS8hFm5oYMqpscWxeQYFb3YuaQ7/tixQxzwGBxTads=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEMP46kH25OmVHqipBnR5F3xU6oavj3QP9PK58hAHunnJeAvBr
	IAu9Y6xUOsvwXaIMapSRCVgUWeX5aP+GHucBV1VtxaOVuCb46550sKwyV0sc/0w=
X-Gm-Gg: ASbGncvkw1B+VVcUsnMQyJVF6MojNZrADHUDZLc7KAE1X1NyoJWBGBEtAqk5lML3jx5
	XZE/fLcVjRzLWQYdhtVROmXY9U9qlwNSI5RMrdK12vQdAZ/FgGsgfCb9OGTaG5LDCHSAVx1/qeh
	0QYxVEfthvLPL2E1L7ZytnvwyicYCmPJLTzkonhMHBpQnUMUX15orWlUbEmrJBvPTLsGuKLRvsY
	tn2rWdYzDscJZTa0ET08pg/bw9Ayba/pfGTypAOUrJlwVNrYyUy7E2Y0oa5qCbJW7x34xBwfR/f
	C+Qw9EIDc9vNHycDt6AuqCDDvLewijEatE9wv8Qs6c+smSFlid47U6QlTfsvMQ==
X-Google-Smtp-Source: AGHT+IFmXHZOtSdCdLVo7meuSiXO0630xCPLqApSephMacKWL+WSH3IS2ya1Tkuv7qwGub+XyjrxZg==
X-Received: by 2002:a17:903:98c:b0:22f:9f6a:7cf with SMTP id d9443c01a7336-22fc91a8c92mr188920805ad.52.1747073114488;
        Mon, 12 May 2025 11:05:14 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:14 -0700 (PDT)
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
Subject: [PATCH v8 03/48] meson: add common libs for target and target_system
Date: Mon, 12 May 2025 11:04:17 -0700
Message-ID: <20250512180502.2395029-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
index bbcba3a84a1..bdcde9746c1 100644
--- a/meson.build
+++ b/meson.build
@@ -3706,6 +3706,8 @@ target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
 hw_common_arch = {}
+target_common_arch = {}
+target_common_system_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4111,29 +4113,59 @@ common_all = static_library('common',
 
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
 
@@ -4306,12 +4338,24 @@ foreach target : target_dirs
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


