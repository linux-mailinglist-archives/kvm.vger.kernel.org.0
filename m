Return-Path: <kvm+bounces-45769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D3CAAEF58
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD5481BA7AC6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44731291873;
	Wed,  7 May 2025 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k/xoVlrn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D224293C
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661368; cv=none; b=Z2sp6zy9aqWvmdVk0XK913CXudLfYVCsSPWZgs/wLTfcjxDsihdHeTPbyo5Enq4R7TldTjeZuxhrbSouQiF6+BRRdXWWfV9jtTZTbR99UvQN8Soz4pcvoU3PgU3iqeWuFPaEDNkTJaMx/1TQeFv3fKimWd84BWI8NTTSO+Ildb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661368; c=relaxed/simple;
	bh=GrHJ9aMRYFOPYLENwSyP/tn/Qyq6i8jHxDJH2SFHHsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHgek2Pw9RZnTJ5KKcTgQKMroO1PhY0oRyVMuj6PqgScRheF3lNZ09SgmhqKYEWxnz/J4PhGcaSP20lY/QGtoADD2rb7Fk+YlLcaKc0K3+8uhVhntz1N1mE7Pinyq/YqLVEeSFJIa1T1Oy7tjjVRUNHu3Rus5KpEcTpgFFdHFP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k/xoVlrn; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2264aefc45dso6456725ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661366; x=1747266166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNFwc4Kkoc5DDFWduHklRzCXnbc7NeJWvJ231SivMc0=;
        b=k/xoVlrnMTKIF1y3nAccOAr9kYAjFpEAJZ+5qV+lpI+bnv/H0erwcZqqmcqGkQng6X
         k32+os6NgFT9gGZm4SAmIOMX/uZyQ1mCyDTTXk/+8WNe+0/dC2XsT/bnV3OImMWZb5AN
         7u8ODAwVH8ScwAUVlahIR2R1PwQrkwZ6sVJmUZa1lCFi8p+txaGVGiHGp+TaefFrhcQR
         OGY0YxtKiuqi7yaZxKL3w37Y3lLtboAqTLT+26BUvO/9UCROTVnfOs74uQPRulOv3Ska
         /GLCG1i5YQUUUxQGsHNtUFQT5h52rG8IIK4D8dRjRFL1w+xEzuN+AuDNAYYhYSiL99v+
         /b3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661366; x=1747266166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNFwc4Kkoc5DDFWduHklRzCXnbc7NeJWvJ231SivMc0=;
        b=hu85Q9jL7G/7sH3WhKRMFh8K0kypvBt7lXiaX8ON2Gl6aRFnzGmRZC7l7XEuQJ927i
         kMT/I5FHMkaajAlGQ4PCzbHYUOO1VpA9ftWRXRlCwU/8fylceUms5ibomuA8UN5Y73P5
         OCXVgrch9damYuPhqrcyFetgWOAvPJXdU26b6UGGNsNgs2EL2ig9HbhTEhnoheZCJnvT
         DsDS7TnW207FrHDZ2MJm/KhpgJRLR/dkVGarFZg5njBqmB4HXuYM6oSQS5rddQa02CLQ
         spgrxeMy5tFCcnG5Sahf/+GP52jTk7GjQOf4OKkC8V1ggxEnqne/aKDbS3BhP6FPR6Ay
         29rA==
X-Forwarded-Encrypted: i=1; AJvYcCXD1xZq2PAfO9rBWoqVm7ypJI1Ga1AClUnp7uWsLtwxUP7w44i7E9xhOvSS7RMuoiUFzN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN9twQn6QnO4VHtd5P3A6SeBg+xTkAj+vdVDDKQGHcEGWib0g/
	7cYGBWY7lFrTWKVbTksUU+xnmXHkkMMWAm4RiCS3nZNsvO9zX9YHubbmS4vnhTk=
X-Gm-Gg: ASbGnctiMTCmY1FWyEliGyR9ObiDrfMR1V/VUiNLVfqzPewJXOaCo2YwY7vuFALVVUD
	kEnRThUMAiYdzk3CfOWoQ3NMA7MeBd0tdQc4HN6dRn4OvtjmsTxQUbhkC45lGlI1dbPVixI0qxE
	dZ+swUsei4GE5T3ON7GL9ClrUwBJuNK+7Iu+g/OvFdo+hFfytkvymf2WVb5oCW4/KshEZZ6fWS5
	NLqeLQ7+Vm1I1sk3k4Nhz7EQncMDL4HXXpOQBb8xFt21gl2OX6ltPC5o5xURutsbJ+0tWl2xk0T
	mbhEjwoquymfdiZSIhGsDs7+iBnZo2PVSarmp2lU
X-Google-Smtp-Source: AGHT+IGkYaVot3yx6bVb3HIKk6uS+ccBQnixYSZU5yTEECwQfzfBOngV8UcbQau9STJypaO4rTu2gw==
X-Received: by 2002:a17:902:f682:b0:224:13a4:d61e with SMTP id d9443c01a7336-22e9d1e2bf5mr15945275ad.51.1746661366112;
        Wed, 07 May 2025 16:42:46 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:45 -0700 (PDT)
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
Subject: [PATCH v7 03/49] meson: add common libs for target and target_system
Date: Wed,  7 May 2025 16:41:54 -0700
Message-ID: <20250507234241.957746-4-pierrick.bouvier@linaro.org>
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
index 320dcb3da19..0609d586a74 100644
--- a/meson.build
+++ b/meson.build
@@ -3688,6 +3688,8 @@ target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
 hw_common_arch = {}
+target_common_arch = {}
+target_common_system_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4091,29 +4093,59 @@ common_all = static_library('common',
 
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
 
@@ -4286,12 +4318,24 @@ foreach target : target_dirs
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


