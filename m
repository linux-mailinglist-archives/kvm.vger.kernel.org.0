Return-Path: <kvm+bounces-41358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8683EA668AF
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCF56176459
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576C01D63D6;
	Tue, 18 Mar 2025 04:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OA6Iv3Ee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B711D47A2
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273506; cv=none; b=Lsy8O/ZGZu+IdTqpLCnsEzaekWSAbdG4CAphCqV6IlvbXJI1DN/3U+gZhZXsh5G196TbtCOU2TzyVOZ2dhb83T8cVlzjRg/6HDQYalDTjS8E/HZRdUXaaD+6syl0UvsyUD34LcfFc550EnzpcAgw2cujNA078PWrfL2auM/MCeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273506; c=relaxed/simple;
	bh=aOQ8YPliesSPuGl81Om6tjbXSGreEyq1q4eTrvn9f70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H3jDacgJcfLVhhRtlSuKSNx/PkbsLnT/LBBrqxcE+k/MjrNhaakNRi6bntF5ly1Q9mv6U6W/fRRZyCNncwv9vZ9m2E0D+PTscKl+7bo+lFURFA2Yfhk5dc2MIi6ekfK+x2u+Lf3cfBS4FWKbK93flvAq5Vb23AtdhbwFK7gno34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OA6Iv3Ee; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223fb0f619dso85479965ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273504; x=1742878304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ek8XPpj4hrtyNGDcqo+uXNBksQzSJC0Hy5Yo4DqMKUU=;
        b=OA6Iv3EeQq5lhdiZScLiHHwMJb2gEczfJzcdhSN4DxsUhi/iYetVCPyFKsjhMPVkc8
         yDU+dE4lHN1kGyVo1Amz0VRB7QLxnqmwTM0I4jjvTN/jUIfpPLtvcQqddUpptjuNqqk7
         gq8fcE/U2HIoTwLZDEbzJYNCAYMgeBDgnV2cpNcc3JBEOTH+UWSXCGFu5GYgrngFW9VB
         HBLmS8TFclJh8aA8927OiuR/MHCc/bYrPAlh+jw1mQN6Abcq/otHD/YKRohJP+DCVZfF
         mUylGffU5bgAFtPcGeuL0DY5C5DbcMQpUDmVsvaXEnTnc1obn3DBc8eqMTPDA132omCZ
         R0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273504; x=1742878304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ek8XPpj4hrtyNGDcqo+uXNBksQzSJC0Hy5Yo4DqMKUU=;
        b=dfLhX8wuMEo6Swp84G+vFaLUB4exdmxCk6+0GQH7ps+4pM72rUBTqsZKsiB1gp1BQs
         90n5HSDr9WdM3TZ1ZNBkXJWFRWG2ykQmLvO9zfQgJdWF5o+ejEuCw1EjeV5xUWO0PuCA
         azGmy2uI+qaFvxOXQ+JU0jZChabZD2TcjfPIwRBR+YNX8YjqijLTzDe+7dJ1kIOR51Ge
         QM6K5neISruDYXdmYAjPO8bMqqBDQRjlRtKlSvec34TNg1uAghWBaHoCgmq3SDOJLWMM
         EzZEtMIld0lM55LeqIyjw8a2WKIHfVqAE6BEaA4Mv7ZpYteJDHL5hhG/9+yKtOLHvupe
         5EbA==
X-Forwarded-Encrypted: i=1; AJvYcCVrh3IgjlnCq6SusUPsvgNIn24oi2/WA+d8tH1Sn+TADRTjkhfo0uVAFmJwk0dMrEyk18M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYnZB5vTNsYbT0XMKKZww162SHe/NRF7VpmYieYMZZVmQbcoiU
	HEBs/UoZs8conCWvh6+USxdDBLOc1T+tYIfoFR9TyknpkJ7Wa2eA3vedrNBQyn8=
X-Gm-Gg: ASbGncu8s4iVWIg5VMaoiaNyvjrGFg+2WYVr9b8n45tL1mprnip+MbFwwTKYkQeOBFZ
	z0LWgORgRsqiX95LCOQ+oCVfDMu9odrKYbM4/RnOtK2fmInw0S+nT1J5V7b34/puxRR7CD9JmrU
	Kgt70DIjYbGlh69AfDnENCpACbKzOM8pTe1nYlVmq61b0SLIfATBRXXOnY4IWhMlesSOOVn6GVe
	WqAVN+9sXU+vDxsoGCawfu8Qhgqp1Wh8JwLQ1RcL3nlzROmAKI+61NAsJw/zX4B5yivXz+3GJBV
	8OZu8G34yAoW8vDt0BfevwPxbHjKGKTUDCoX0hADX+OX
X-Google-Smtp-Source: AGHT+IGT3hRB7cgRAOTfF6ymEpowIUFgQzMXE5GAC2ISpsBZy5NX8Js4RVALQRBZLAuQQLxc3QHe/w==
X-Received: by 2002:a05:6a21:68e:b0:1f5:82ae:69d1 with SMTP id adf61e73a8af0-1f5c12098fcmr21810295637.20.1742273504481;
        Mon, 17 Mar 2025 21:51:44 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 12/13] meson: add common hw files
Date: Mon, 17 Mar 2025 21:51:24 -0700
Message-Id: <20250318045125.759259-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
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
 meson.build | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 672a0f79d11..0dec7d9750e 100644
--- a/meson.build
+++ b/meson.build
@@ -3689,6 +3689,7 @@ hw_arch = {}
 target_arch = {}
 target_system_arch = {}
 target_user_arch = {}
+hw_common_arch = {}
 
 # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
 # that is filled in by qapi/.
@@ -4065,6 +4066,33 @@ common_all = static_library('common',
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
+    src = hw_common_arch[target_base_arch]
+    lib = static_library(
+      'hw_' + target_base_arch,
+      build_by_default: false,
+      sources: src.all_sources() + genh,
+      include_directories: common_user_inc,
+      implicit_include_directories: false,
+      # prevent common code to access cpu compile time
+      # definition, but still allow access to cpu.h
+      c_args: ['-DCPU_DEFS_H', '-DCONFIG_SOFTMMU'],
+      dependencies: src.all_dependencies())
+    hw_common_arch_libs += {target_base_arch: lib}
+  endif
+endforeach
+
 if have_rust
   # We would like to use --generate-cstr, but it is only available
   # starting with bindgen 0.66.0.  The oldest supported versions
@@ -4230,8 +4258,14 @@ foreach target : target_dirs
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


