Return-Path: <kvm+bounces-44923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4497AA4F48
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACA8917ECAA
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D5913E02D;
	Wed, 30 Apr 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VM/TmGkE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2071BEF6D
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025135; cv=none; b=P0jH9M6GE7xmbFWR5eHZ/llW5cBmkGUIYRCSqB7iIhhThdsYN1daox7yRqzAFXCoZb/XyC5OOrBzq5DHdgc7nbcud2VmJ9XzmLpMv3cwJRQAr3e+SJqgk3mfp/F2YHDj4Zo2y/8fCzckx6VxXXHBE7U5sOYAqoLhJhWO2yNOuX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025135; c=relaxed/simple;
	bh=/uzp66bLBLHy7nrp1F0ayHRjEOR3j9nTuDiSWVbveeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geVRAgjrXouF4epk54+QpiGyJZT69BTB8wavDx8SQkYVf6r0LlOVGN27dhNMs4HK/sN5K5wh9qBUYBmWj8QhWXJU2oHlvuSF4ADNNPVNBe7IM8OxAW2m7BFzpE6Uj9t4tgwCiBiTOn3GthHJDuHCC7Q5rr8Pwe6FxS+X1xlcHZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VM/TmGkE; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b0b2ce7cc81so7305465a12.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025133; x=1746629933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aXdmB6f6CJf71wSR2HMNjOPhUhdvY7cV28foawZJTI=;
        b=VM/TmGkESmby6cH/4wzrH2LGc44p7sVA4/iTN4CqV1+dLSveQmMDkaPrUoKp1kujII
         f0gY29dtOsKZjJvlyy29su6Lo8veB10YUNlWdm4LYXt4Ooqk6J8c5/VS+rFQFbVNNP5D
         kGwgvcxBgUUkRXTUCtV/aHnw1OneMV9pYEzSOs0MNqTodrF93MBeUFymTSBIOJXPluLD
         kbVtLmnZHo0K1wTaoycnjAjXZJNpKUQY5wOj62vfH0VZ69iQ4URlY0uYXKdHb+p8fAeS
         UnUGfu+nx34CO1Sr30JwcHgcHdDGikPCGJcE5e+4yI1EDQCK30oaupht3uKozOJ307nG
         ustA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025133; x=1746629933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aXdmB6f6CJf71wSR2HMNjOPhUhdvY7cV28foawZJTI=;
        b=kI4+yYGXiIiWbuZWEhT8X9rm+IBIaOVYLWPiiJ7O/ynghPknOujam7EsigkHBqecOd
         PcnMgK0EFT1UBmw+YwOrVahEXgH5jhkcEcZRwP4lumt32HZaQ+LhnsyPR27i0VuV4TEz
         z6PnqVD/g7HwNxdDfYm+02z6Fklyx0/Ih0F6NaJnMyW26C+dArbaQcsHebvWIV3qjPPo
         oLIar6zOnONbsmEr7N1ztaZV7yRieQ0d4lHJcg8SFez7Nat7uZyn/i2A7FnP/Lu0US6o
         8s8/ZJEq6Zj2rFOm2I7Z7BuPQa04R5B6GwKbkGDczta9GE0Wxp3/kyvOywImxdSObYCy
         u2wg==
X-Forwarded-Encrypted: i=1; AJvYcCXGr3kWvB6XUEDAdZqwCoMmRj0jYp/WQx283fhwWJ4VkwmXzghV01Oat69YW32IG2fej7A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7fqCBGiTWcS8dqG6F22NfCaJNBpcdVjNPCL1tNbBcuRtotRF9
	K1clbicnnrCQJz2iU6zm3xS165tYGAreeneDcEqckFi9yOggEkgLnX1GyBOSGY53eAHFRpX4Lta
	N
X-Gm-Gg: ASbGnctwZuj3iJWExNZrqlQ2S+s6y4IhOFxGiKexmLCzYQj8qCKME5dIooF9W4SS6Ip
	RUwNnZvgKwyWUAedxiRtu8ypcslUwqeKMa6J6frEE5MCTb7tAU2hiGtHqrq09EOdYDWvPaJBre1
	byTIuABO9uSI0ERNAMLrIFl5ENuh4RaGSl2OoOo8Y09WvUBZcqyvkSEY3rw3VU/LPhq7Ys47glO
	59jUFzr+8zo2gX3Gn00YYVUtFxPuOUn4SUMJ8AS7/Hh6xcKlazQzfuY1+SojjdivotpAACM1Kq6
	PeNJ2Bw6+JjWy40kWZ3v3otEPBQzFsetO+ngyR5Y
X-Google-Smtp-Source: AGHT+IFpssHgsSSYtikIQu6tj8ir0gDcjk2YukXZRDxWJf/hcTFbtG7nZrI131KGmvNhHjq05d2fDQ==
X-Received: by 2002:a17:90b:5444:b0:2f2:a664:df1a with SMTP id 98e67ed59e1d1-30a332d60b6mr5368225a91.2.1746025133341;
        Wed, 30 Apr 2025 07:58:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 03/12] meson: add common libs for target and target_system
Date: Wed, 30 Apr 2025 07:58:28 -0700
Message-ID: <20250430145838.1790471-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
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


