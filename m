Return-Path: <kvm+bounces-41913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8081EA6E913
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA402188A3AB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029351F3B92;
	Tue, 25 Mar 2025 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nM46sjDR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FBF1F30D1
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878786; cv=none; b=DTX/hWsGVjLONggFhQ34fQISK2Sm9L2m7R0FtWtlhsVfojpoW/dCGi7oTvpJlxx+wFHh2MjXXA7tfNQsA5l0JFzY7D8G0JkwQswHmlyy8IAUQVf3uknRonNyzG9VQiEuhjWe3CB0PuCGU/St/VzSyQ/Wv/o7xvbq5Db/n+xzBEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878786; c=relaxed/simple;
	bh=PjG4UOtvkoaWWu5GMaGbVHpHxbyv4SFhINlKcWSdzC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OfDuZygfzpIrjcWAV8P/tNSvejDcSxDEdexvAfzth88tNBK8pA/IGpo2zDTXhhCn46LDPic04fC65zlb8fqy1rRdAE6yp7hLTYr8pUzuglH2SFWUYGinF4P3IYLPHdl7Imq+du6HID42l4mSbxCUxaTifFYiQHIaJaPRKAx80cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nM46sjDR; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3014cb646ecso6658863a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878784; x=1743483584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI6HALsdQGcYyIHmM8Ppnw0EYvYwjf9AgyEFGP9MumA=;
        b=nM46sjDRS9/XY1ZvpzaR9fVSr7AYhGdxjcW+gB80hrvkx9Gdotf8WROpwuVnn9BmgD
         9IM+zFhaqyQUuqaDBGZUbIYGnm0KVJ853Hc5/idOSaWC782n1ySROPgyC9yG9GoMU4dt
         RZ5w9bHULUAoS8QVOnj2L18ZooDuBAbeXSZxcjj2D5ZddHxLxmiEXx7pcasbiymUXmnz
         s7uDUHU2l+ry52OXUf9zv68i+vuln2ZUCRMT+jC1Bds+oYxr1TYslN9TDQUrdvzx63zy
         3fHxTDWk/SJG3yO6zON6TAT8lXTqZTDkkKbInW9UQ2JOsBb3EeBAbhcVhbehgqz0e29I
         iB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878784; x=1743483584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kI6HALsdQGcYyIHmM8Ppnw0EYvYwjf9AgyEFGP9MumA=;
        b=beQu7QuFS4kMEl++7Z5nlJOA5v80v8PFTfUCKkam2MFnbHf8nRGWS8sdcu3LIsoPML
         zYjbaC0T7aEqFCh7ALwm0vJS61mvNswZV0wM32J0Wmj6CLNLA2IuZLEAZLp+cgzppH0z
         EVvJohKxEpTedJru5CylSA3HPiN3jp5y/GWmmNmQajNrQ/4fRuCTavRrdDUNBpdxWMWg
         Kpfhu4/M8HSLlWAzFkS6DoR4z0gVNdY/QlFK01CjWDHNNFUDROUuDnsnY6G0pOgjyyUq
         qhNFaSY42KmhNX9eOtaWE0ND69Req38JWbOTFfGqSjShnvPWWhQnNjbstgIznLCNmRJQ
         CG9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUR7gm3QJWIngMPie1SW1S+Hu/PE9GF3/TloRaH9Jz9DbWEVj/WiIH93Hcz1pD/7JtDrFM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0JayQsn+WWbWwiqUEAoTB8wZQMEBeTkavzkcgjEO2afC5N54m
	KD+rA/iFkm4ZSBfzQ9nRyw6X16VmA4tYXa7kmx9rNcHsaOK9nbv8WmJdHGJ4wUI=
X-Gm-Gg: ASbGncuJFyqTXhY31VTtjt7Og73orJptbIqxCEQCI9kqPV+1u/JjCx3TOhDKGw2Z+c/
	WdmcHBKw2M17VzmPXR/LmGI9BKORWwdUm0YoDAUNdo519aQv3lHf0ezY9rkWqk7sI7BcUtJcp7m
	zRMtep/FV1UnvZ5MNONVsxPGR97PO7NcfSvdQGMumGZ5euaPyZw59Tpv4gwgwGgO26+YG5fI7ZU
	Xma2jlJnjPmWYbOPon2ferc6GlFHrzagp2Fqq/3c3uZyrDeviGIP9sx1P/Oc7r8zWSR1YkLyrmr
	5FW3IPjurY43R8Phefc0W0zpqiYDfr8YjQ9czSZVvjoh
X-Google-Smtp-Source: AGHT+IEViWj0HXthzkisCL6XXxnNrY9f+XJAj3XYkE+svRDw8yixLHab1+2GgLUvE4lRjRG8yLIalg==
X-Received: by 2002:a17:90b:3847:b0:2ff:79ca:24b7 with SMTP id 98e67ed59e1d1-3030fe9804emr16981073a91.21.1742878783768;
        Mon, 24 Mar 2025 21:59:43 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:43 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 23/29] meson: add common hw files
Date: Mon, 24 Mar 2025 21:59:08 -0700
Message-Id: <20250325045915.994760-24-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those files will be compiled once per base architecture ("arm" in this
case), instead of being compiled for every variant/bitness of
architecture.

We make sure to not include target cpu definitions (exec/cpu-defs.h) by
defining header guard directly. This way, a given compilation unit can
access a specific cpu definition, but not access to compile time defines
associated.

Previous commits took care to clean up some headers to not rely on
cpu-defs.h content.

Acked-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index c21974020dd..994d3e5d536 100644
--- a/meson.build
+++ b/meson.build
@@ -3691,6 +3691,7 @@ hw_arch = {}
 target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
+hw_common_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4089,6 +4090,34 @@ common_all = static_library('common',
                             implicit_include_directories: false,
                             dependencies: common_ss.all_dependencies())
 
+# construct common libraries per base architecture
+hw_common_arch_libs = {}
+foreach target : target_dirs
+  config_target = config_target_mak[target]
+  target_base_arch = config_target['TARGET_BASE_ARCH']
+
+  # check if already generated
+  if target_base_arch in hw_common_arch_libs
+    continue
+  endif
+
+  if target_base_arch in hw_common_arch
+    target_inc = [include_directories('target' / target_base_arch)]
+    src = hw_common_arch[target_base_arch]
+    lib = static_library(
+      'hw_' + target_base_arch,
+      build_by_default: false,
+      sources: src.all_sources() + genh,
+      include_directories: common_user_inc + target_inc,
+      implicit_include_directories: false,
+      # prevent common code to access cpu compile time
+      # definition, but still allow access to cpu.h
+      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU'],
+      dependencies: src.all_dependencies())
+    hw_common_arch_libs += {target_base_arch: lib}
+  endif
+endforeach
+
 if have_rust
   # We would like to use --generate-cstr, but it is only available
   # starting with bindgen 0.66.0.  The oldest supported versions
@@ -4254,8 +4283,14 @@ foreach target : target_dirs
   arch_deps += t.dependencies()
 
   target_common = common_ss.apply(config_target, strict: false)
-  objects = common_all.extract_objects(target_common.sources())
+  objects = [common_all.extract_objects(target_common.sources())]
   arch_deps += target_common.dependencies()
+  if target_type == 'system' and target_base_arch in hw_common_arch_libs
+    src = hw_common_arch[target_base_arch].apply(config_target, strict: false)
+    lib = hw_common_arch_libs[target_base_arch]
+    objects += lib.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
 
   target_specific = specific_ss.apply(config_target, strict: false)
   arch_srcs += target_specific.sources()
-- 
2.39.5


