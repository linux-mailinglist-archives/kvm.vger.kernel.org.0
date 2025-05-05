Return-Path: <kvm+bounces-45488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E47AAAD0E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2466A7B3770
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51753B0A04;
	Mon,  5 May 2025 23:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vVA+4uFB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AA3B0A14
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487227; cv=none; b=T5RFOfOziU62NRtWXLow5CvcdvqJKIAzHoQboWIti1KAwctmvwUOIALF+bFDm3OgNGO3Shw4EO43SZ9haSK/SvzsKmSFcVywKLTdETqE8HH3f2EpIjNTHXoTNI+Tcg6Zgml4XU8QnBbEnU7nMof01KvumVbwltKnY//HcXXRFQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487227; c=relaxed/simple;
	bh=znCq36hlXSwrJ49LjZDZum6F/G7FLis5lycOLVMlAUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcsQ6TkHGi26G2Kvf6SSPbatx4OWiJ8QLAhbMFH9EsGzFpBJesmtrbPk2wejnpdqT1E3VYqFDXXtIbvX1UsCUvQbhlmXRHCkj9zwh2iGIRZ/vw7LTLZWdW+wVf1i+FlpikIOxH9slKbJq9m3E8O1NYL6cbn+++MLJVquQdU0MnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vVA+4uFB; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b1f7f239b31so5126579a12.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487224; x=1747092024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMNeg3Y4FuUndpYOZQCJwSPCGo/Nsl7SC/sGcqIL57A=;
        b=vVA+4uFBMaSoSx5g8csXJGvLNwDb7eb6IZV0/CZQpNHP1CcQ/+Dgj2m7yQPkatZKzk
         BvI3e0HFcW4lv5R4VjQMD9K+8V/qNbhValArxu4cuqoZrSqhdWe3FMPEOkUpNY5mEN7f
         19xh3Bnv8658Jgn/6qw3uyhEDn/OUiBrrBWowxDYyHf/rsbk+6J2fq2hp1FBmpksC+M6
         vvxIhsgdFoVxt0mgdZW6zRzPjT+3JjR1FHHSr3vj9VPMqyve4ZfIWMj9UmU3n7+T+Y7G
         cVtUl12v4zwqn6HK0j6g+k14d5I58z6MK6IJIfLpsLzKFtdmnT04Xd6a2bYWOWJHxc9J
         SsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487224; x=1747092024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMNeg3Y4FuUndpYOZQCJwSPCGo/Nsl7SC/sGcqIL57A=;
        b=tltkDs0smhY6bXFa0DiXW2B13b82nLH/7PwZFAGhz2jlXgjJJhssBzGUrw4ghpaqK5
         kbzppIv5SfS5kCMlziMz3MAGN1so2CW25c3zr5TAIbtKAPDBnB16u0oNnXrFp3jm95De
         u8P0p2RqrZUB+QpabTox2JzfFdMpFUaQwfLCJ2KxA8c6H6HYGe9JIFz50QSjiJfxIRFp
         ADLUTbky06xAJyBrlw8CSoL7v5S1TT2J82vRJWkT8LlvpOTFg8Gh2/sQrCpZTlrjXHpS
         lk814Csf2uW/aols4QZSlqcJJQJK2iamUpXFo/acKO7qMCnaAbsnBjqtAyYi+3Qr/Ksa
         0EeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHsh9CYEOZ3o0sI6Ew4u8ctC/7t/z6BU89ygG1tvyWG3cO6WB3Hj/z5186Vl/50XE2FII=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt4uGIe7nbajbqZA35Q95iQ9XSwyqQycir0d8lifIi/tGT7V5C
	LNcQjaa63UETAV2s8pYtfYqzTRjmirPuI6Pk4v0iSXdflA9cuhzTwx/gGLmnW8Y=
X-Gm-Gg: ASbGncvO9QlJjF6PqT0f+p314OY0wB/gDSs1WMq9ZLvIfQm1CrdWC/8RflITwGhcH7c
	4DWmd+nx7qWFDp1Vvy+27mPuZUPmnLsxWmm86E6DPjbjLDW94eVlqacakDaS3lj+DZEkK+otpZX
	Orm4gp73S2/eWB0KQ6bMA8m6IXXba96XKDeK0ur9gxG2EY3e5/vWLcSSf6mHvI0+7HL1NZE2YRv
	LmP80ieYMVfEPopfQFjZHOQyAtdDLnk/0v5oS/PfdK8PoLCQ+o/iQeDEIloQClh2BWN0MzKf85W
	scQ4MByA80GR9Fl8myzIQLvSCc8VPkxqFv8OrNbV
X-Google-Smtp-Source: AGHT+IHoFN+rr8Lwq19Sx2mB1Yb2Gf6GH5Yb4OTaXFvREpHxBgl5rUjVxpoL1Lsyqn6N2c59nXy8cg==
X-Received: by 2002:a17:902:daca:b0:224:3d:2ffd with SMTP id d9443c01a7336-22e3285f134mr16144225ad.17.1746487224186;
        Mon, 05 May 2025 16:20:24 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:23 -0700 (PDT)
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
Subject: [PATCH v6 04/50] meson: apply target config for picking files from libsystem and libuser
Date: Mon,  5 May 2025 16:19:29 -0700
Message-ID: <20250505232015.130990-5-pierrick.bouvier@linaro.org>
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

semihosting code needs to be included only if CONFIG_SEMIHOSTING is set.
However, this is a target configuration, so we need to apply it to the
libsystem libuser source sets.

Acked-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/meson.build b/meson.build
index b2c79a7a928..1b365dcae17 100644
--- a/meson.build
+++ b/meson.build
@@ -4049,27 +4049,19 @@ common_ss.add(qom, qemuutil)
 common_ss.add_all(when: 'CONFIG_SYSTEM_ONLY', if_true: [system_ss])
 common_ss.add_all(when: 'CONFIG_USER_ONLY', if_true: user_ss)
 
-libuser_ss = libuser_ss.apply({})
 libuser = static_library('user',
-                         libuser_ss.sources() + genh,
+                         libuser_ss.all_sources() + genh,
                          c_args: ['-DCONFIG_USER_ONLY',
                                   '-DCOMPILING_SYSTEM_VS_USER'],
-                         dependencies: libuser_ss.dependencies(),
+                         dependencies: libuser_ss.all_dependencies(),
                          build_by_default: false)
-libuser = declare_dependency(objects: libuser.extract_all_objects(recursive: false),
-                             dependencies: libuser_ss.dependencies())
-common_ss.add(when: 'CONFIG_USER_ONLY', if_true: libuser)
 
-libsystem_ss = libsystem_ss.apply({})
 libsystem = static_library('system',
-                           libsystem_ss.sources() + genh,
+                           libsystem_ss.all_sources() + genh,
                            c_args: ['-DCONFIG_SOFTMMU',
                                     '-DCOMPILING_SYSTEM_VS_USER'],
-                           dependencies: libsystem_ss.dependencies(),
+                           dependencies: libsystem_ss.all_dependencies(),
                            build_by_default: false)
-libsystem = declare_dependency(objects: libsystem.extract_all_objects(recursive: false),
-                               dependencies: libsystem_ss.dependencies())
-common_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: libsystem)
 
 # Note that this library is never used directly (only through extract_objects)
 # and is not built by default; therefore, source files not used by the build
@@ -4308,6 +4300,16 @@ foreach target : target_dirs
   target_common = common_ss.apply(config_target, strict: false)
   objects = [common_all.extract_objects(target_common.sources())]
   arch_deps += target_common.dependencies()
+  if target_type == 'system'
+    src = libsystem_ss.apply(config_target, strict: false)
+    objects += libsystem.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
+  if target_type == 'user'
+    src = libuser_ss.apply(config_target, strict: false)
+    objects += libuser.extract_objects(src.sources())
+    arch_deps += src.dependencies()
+  endif
   if target_base_arch in target_common_arch_libs
     src = target_common_arch[target_base_arch].apply(config_target, strict: false)
     lib = target_common_arch_libs[target_base_arch]
-- 
2.47.2


