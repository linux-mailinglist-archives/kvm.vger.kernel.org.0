Return-Path: <kvm+bounces-44669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA20AA0181
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF92B7A5E5E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E7227465E;
	Tue, 29 Apr 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CpsQ5JA9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99822741C9
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902822; cv=none; b=lCfQ2+dM5d1k3Su5WEmlDfAZVfpGj6+WdLa9s3GAD5kX/hFO47hz2A3iNhTZXKRkrpuPvheCqnqoan7utAwsWv9zsKQOF5VX+KsS2E4wFzOjwAZfocIG4/Io/jrEv0NVU4peOA+SXdswIhbLpT57EtCcExVt7XwWtTAZrT8y0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902822; c=relaxed/simple;
	bh=/uzp66bLBLHy7nrp1F0ayHRjEOR3j9nTuDiSWVbveeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BidpTNwmjZ+XgRK/w0J+Cc7lK7LtSzcn/pOP3nZBYuF5LWZuJyqeY+SHpu7/ihyG19Cp68Gd4JAVLAp1/0wHYAvwwC3ZzcaMBCPu9cV0btiP/7FuQOxqfzrrfMzOXHOhvuYZVDiR/5vaKN3hYCO5azzl2TNjbGyISg4OrEfCM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CpsQ5JA9; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2264aefc45dso84208335ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902819; x=1746507619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aXdmB6f6CJf71wSR2HMNjOPhUhdvY7cV28foawZJTI=;
        b=CpsQ5JA93HFZP6cWwXlpZT/HKKOnm8CgdPKSOs8edpDJWZOYIQ4XE0RdWEan/7ik1q
         1DtdVENfpMS09IDhEVO1WFLIIn3FlPh53LQzrACY3REIrKdzlEgHXRhMj70FEOeRcsyU
         KQr+DAQMZxVA4bUs/CSd3RXzPpLMgw1r441neJ+EaMySLfMZMHWLuVKZjjz5uk9aqEZt
         ft/ikhRthAgcAhoBrkG3carU0kyuum4Zz5kic8uTiMVvV6zh1j7nlC0qQ9+pshgEKv7x
         1tYX3YTiNTtiD6PzAFMRqpJt3lwjkRQbilAGApa6neT7vCS7FSUGkF2GGkl6qE7+i3xM
         2njw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902819; x=1746507619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aXdmB6f6CJf71wSR2HMNjOPhUhdvY7cV28foawZJTI=;
        b=fcMuof1SNUqYMCh/+9rqmNvta4UerngN2SMdO237Vyh47S/x8aFxQ8Z2XKqm/NGWnl
         tzFiM8md8/cr3qDeMzrj4zy5/c9CkFHZ8Dt8N7gSV35HAX7mdmGOQEMnK31IFSmuzjJ0
         SLeKQzu4eGMyS/hciwRPVQpfgXNYeiVX/8UiMIrWI9uSaJ4BHVvL/pD2ETlKuRb48pUX
         UQeWgHOsb8IuwsfGAaTP9wCpq+CfCWcw8avxohPTP4xyHmgLSL4x5vFBwhuTIdg7VRMb
         t0qJb36U6+FhyKiWzdb31mPzskmv+jvlcHfjODL0iUkcj27Z709hn4dsBdwqI4puttHA
         bFjw==
X-Forwarded-Encrypted: i=1; AJvYcCVMd11dg6hGngDDv0KLRp6FpKOFTjnCDBEOpG9/KV8eK3jnJKK2/3efsW4BlWls/RnfVEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJsWrysjKIUreer2zBzoGS8f9YXRrARxPyZiyuUnU5JC8LCeCw
	N6U86Qa2p6lj+o9BBZy/HbP9bcmW7dS3x5iDwn+cj+/iemumfxZTQ8HCa++noOE=
X-Gm-Gg: ASbGnctItrMBwkbkCyn1zlGzEH+7JCwKNDIoLgMAJV6Kiqpi+LI+XNc1vdOqFet45Px
	Cm6B+mcySc8md48GjCBJH08jr33vbC+c9bc7uMsabna6RweDcYJKtUL15xfbdDTirOa6VV6Jklx
	Xt4PQ6swp6mH8zoIsdCJ3Rps86JLAsEt0stzOCd7ztuXOYfWjmH5Sba6xC2w/klb+MymkKQNdW1
	DLNayhLO5txacy35AhcJEr1Stk2pqS1MoV90L5ga0Yhgs9qxpRnD+gKpVVZi/Kh7hFBCP5VmxiG
	yqRkTlyD2HrjH6mE9nwRlTkCqaGGtPFp0/XwRRfv
X-Google-Smtp-Source: AGHT+IGeLffPwEfhTSFzcSgCxSnqORDeDooD8lNMMrUFiFJLyupXL0rE4ooCbBeJi10RUeob1yF/hA==
X-Received: by 2002:a17:902:e5c1:b0:223:377f:9795 with SMTP id d9443c01a7336-22de5debd13mr36357395ad.0.1745902819112;
        Mon, 28 Apr 2025 22:00:19 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:18 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 03/13] meson: add common libs for target and target_system
Date: Mon, 28 Apr 2025 22:00:00 -0700
Message-ID: <20250429050010.971128-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
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


