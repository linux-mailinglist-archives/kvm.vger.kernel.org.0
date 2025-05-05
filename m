Return-Path: <kvm+bounces-45531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 408B9AAB589
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E484B7BA5B1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5D934A1BA;
	Tue,  6 May 2025 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GUZxx6mI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA633B0A06
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487227; cv=none; b=QKln+AKFTI1lRlClqmgbtIfwCp5HviTxIgKViLc4rofbzMKF4Sp2J0iGcTS0VqDZbpYSSR1MXBEyeG11uDE/GgSFoczOqCCUKTxGlRGHU4KJM4IZhU1oxGj6q+pvG+QAlSjoBNKHr/moMBgiOxntQz4ZjQ+Xt14JKvFpu1rhxjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487227; c=relaxed/simple;
	bh=P7cs44e7lLPix//xHmErLxf48gRN9ICukIqVyQB2TCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC0AojWaX0qTGvbZtSyEUAsgaVgraHYBOURwRyx67SMH3Oog/KBgGIyazjNZe+2Sn2GgPLmxY5+D0shdWg7DNTXi1pfbYBaahhMvVSKU8uIsGeg0NY34iym0vtTnQm58rfR3pLEMZj2lJ4QDezSYicGcVGOOmof/32ZPU8OFWnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GUZxx6mI; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-309d2e8c20cso6538669a91.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487223; x=1747092023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mHjwLOmCSZb7+SiNUT87VRUe5PiKHdCHDdwE+42+GQ=;
        b=GUZxx6mIsJQnwOlUR9UvCVZ3BcMMCoXt87Pf4pI2KtsTfto/56Q4x+acPqIUv7YI8Z
         K/C19ylhs29o/4PIrrjJncDLoqnRutIjWMeK6eNivfBG75R0ydKsdtnDQx2CUA7nYykU
         qEadTZadDVRbF4y1t5MzWgvoCnPpi++Ts5HBe5IJEH7BWa0l0ADrt0RQX71FGWDQo5Um
         V9H0vxAuJ8hYdYz4kyjwqdowxv+I1jwg5ltlJNjsss6X9QY3NSadoH6KCYlrwG5eJ1pj
         tZFqkoQ5RmMzC/FTnX5KIo14NCt8CCbN9nfvEm78Op+ctW6CbEGHSG18Le8Y4114/HEi
         waZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487223; x=1747092023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1mHjwLOmCSZb7+SiNUT87VRUe5PiKHdCHDdwE+42+GQ=;
        b=B/4bV9Ab4nGvtdRqT4e9ImH2TvLNN+/4F+73+LGbV5WJjFOtGztGKl0u2hfldXHMW8
         HVYlDnsxpacrLTUQVmAwaBPeAnme7UECM1b0WhspdO7M7A0FIR6Q01UnX7DjQ+Ft67Ap
         lJ/canpNYLGBcmRuutVU1Hk1fXawhSORh7ZGVkIojU/WrADAA0iGjuD+aTzNhMFOyf75
         w6OpANzsX0WHx7Yw8q3Am3SB7INXITsmIxNKkW7lLVZ1Cg+ISA7JxuUTv8KN6w9K+V6A
         anifsRmVTm5iY70Knd/DeZOP/iSkEFQC7BqteSlIjx3/oQ6uOskcrAgs6pBvCYohS64e
         NYpA==
X-Forwarded-Encrypted: i=1; AJvYcCUO/zhnrLnWJcygQPs2Nl+EK0L2sr1qESoysPM5b3Qbx/EIeUWcFfJbj0LubneWR3bXr74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+2ebg+48Ihbex9d2Jt6b7LNqNnmgu430ooyfVz1b+LPBCprMf
	BpRv5BfwLcE643UTqU9kMtspsp1hhHs1vDzngR6e2YSa4azj4yt1j9gS/K95k4o=
X-Gm-Gg: ASbGncsc+s1jmDSXAGHySUDnMauYN7HzBXaTXQ6JtnFCFXNCVpySvUowWOFw/plnRB7
	lKP9EhRM0nrGO0WHQfFlrbnYX8K5OehNjTyEa8bI9zEYyQP8GhWx9ECvv5IW9qz/LhU0C4xba72
	n7EKaa6fMuZI13tK7WU0Nz1bUrnQHcnPXwGVPtatZ75o+lMD/W8dOcRU31N/k4jQyQ+ACP0uHCM
	2rsQ/g4oGYHmzrPWHeFDm3VZL6WOSGlwg19e4htu6McZ6Rh7eFWEHKkXU7Gh92v8KLt7B+IXznS
	ywISeBG1nfe4P90oOem1aZ+aS9fFuAddEkevW1bJ
X-Google-Smtp-Source: AGHT+IEtE934oujmV2pKBRwhDluY2PMtTrYzh17Tl99vZJ7tWXNrTSDKs/LD7LR96GjhlWfhH+B8Zg==
X-Received: by 2002:a17:90b:3e45:b0:301:98fc:9b5a with SMTP id 98e67ed59e1d1-30a7dac8b0dmr876783a91.6.1746487223333;
        Mon, 05 May 2025 16:20:23 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:22 -0700 (PDT)
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
Subject: [PATCH v6 03/50] meson: add common libs for target and target_system
Date: Mon,  5 May 2025 16:19:28 -0700
Message-ID: <20250505232015.130990-4-pierrick.bouvier@linaro.org>
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


