Return-Path: <kvm+bounces-41627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBB5A6B0EA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC176988335
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E32622DFA7;
	Thu, 20 Mar 2025 22:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RboBOC9C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087DF22D7BE
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509837; cv=none; b=a57Gfgr6ORygsKX7y7pnGg7tBcoKpoA1BTilsUVfis8Xw6xrluHO7bgcq1fev5vvi7KSSYGWi5iuyFc9+IiMeF1Qs7ZuQYeCM3VgIhRRcniowUrno8qP6FrT7V+vVtBhP4+pWywhvytBsFy7Yy9+vK/EW3yg+X8wZpDIbLQi08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509837; c=relaxed/simple;
	bh=L3vlmn+0/JcnOD0RY5BwB/hxoRPTed+jZ0Yyr0DYVPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KmN/5tYfHws59ZIS2nwvuGb6MMJvqJ4kyGrCb4ysvLG+G22U2wC3RyUc5V343UA8vt8xOszgrI2TGNGj9APhBpsSqqebP/U3OidGHr88mD5TJqTfhVo/TJODxqY71dvoO3y5ZQfPQhtN3walBtAp0XlBve7oOeVmnybrCNAdHsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RboBOC9C; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-225b5448519so25994495ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509835; x=1743114635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fni5tdTWafvZot1y+akur3pFHYiAMm3JM0mRyhC4D90=;
        b=RboBOC9CpdK29iwXsEM7+IyD5gcNa5WOQKv9IX1EEZhgZy21VBWLO9WzDy5is4gmCF
         VRc/WFuzL4s8nD8+lY2NDTOV4yH7LzLY/Hgx3tPdblEVjksubrJ1NZMFl0zZ8o08rRvy
         +WOVElRDnR5Ra/vFIG+M6Y+f+QQRVabAwYCCqZ3tqLigURWleCeWq5Yvdxfz6FbNhbKr
         QXWqSyTzngJ4tHuU4PqTyxwFtjtpwDrZ5kWfs8QbjtO2jwuZlsTQs3weckpC6d0xMYVI
         XmG54pK7Nukfu2vMl+N5/wZpdmmolzA1dnmayVbM75S98sf39c6OkD2BvYfRyf21wY9X
         JgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509835; x=1743114635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fni5tdTWafvZot1y+akur3pFHYiAMm3JM0mRyhC4D90=;
        b=oJ8tItlQ/wmeKh3gvl4HNgViH3g02eaLId3gS+eqA4YQtObY180tP15qTI+lVeO2jq
         Yd7rwx8GJ/OliIHjbFfJ6z+UrutPY2BYBJhbkH/H9Sbhx8/V6Te7qI1wjOB35bMqxkz9
         TzQQ07cxn5AxUa+j6OV7qLQhBAHodU+Glgunv1sHJdb+B1vJgYK+38zEBpxp7CqgToOR
         H6P0Wz27yDNgvD4OupbRRVMNcrrPsCVUiHuxsvy20UUe+ZlKU/UWj2Hae1tVuokGLgHK
         cn0UlOnrNaaDArGCk533uEBPQaLRBNF2fHI1ysf/N+ucNdml41ThyC/NCtKdOLDISnIn
         KtUQ==
X-Gm-Message-State: AOJu0YxNsH/1zsaxAmfJ76SMdYRiQCct4G5VbxPgG4vQ03leDil3IFw0
	9lTvoIMkw/9DVTH6x2ILYkpFOO0uG62hW5uodIACLO/Rx6u6T2ySy5d42BmpKww=
X-Gm-Gg: ASbGncu1ZrqNYmtGGvUWdLwqD4MDgL2daPqFGt/1qhtMvtRdAcoDSV7mBPAjj8X48n0
	AgJZLL0kWmd3mwbIJDq6giAzG2dJ7iErQ2hXwfmHOREdA/3aL9KEHAdWJAmePZS/uOfziiMAy4y
	xMcOTtWYbMtfIjZ+t6N+9dCAumimJysw/8njB0FvMiZBurt6w8Tof4kw1/B+Hw90ekFyZyZNyT4
	M5Bm3SQlk31TVFdAjJXAEV/d/S35YsYjVEYAKR7KBKhHi7S6KwmonzXeNDNHqWdySNiUTocx60/
	GMtE52Ce3NCBdCriZj5GcRdxPIMkj/KWAJvcK1Lezl3l
X-Google-Smtp-Source: AGHT+IEDnR46Jwg3e0H5vN3WKKFSDOwpObSW/kBf7o+0T2zwRq7UNU9x9J0cLoc6huCy1CQ8GPGUhQ==
X-Received: by 2002:a17:902:ccc2:b0:224:a79:5fe4 with SMTP id d9443c01a7336-22780c54d58mr15290515ad.2.1742509835392;
        Thu, 20 Mar 2025 15:30:35 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:35 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 24/30] meson: add common hw files
Date: Thu, 20 Mar 2025 15:29:56 -0700
Message-Id: <20250320223002.2915728-25-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
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


