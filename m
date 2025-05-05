Return-Path: <kvm+bounces-45351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F99EAA8AB2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53DF73A595E
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2312D199235;
	Mon,  5 May 2025 01:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bvlq6a4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B3E19CC37
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409953; cv=none; b=DXLFl6TKFsxvNYBDJ/NyeKTfVR9aYdwEj0gLsfpFL0qZL6A6HsHFRcq5FtWSmE92q7yHTnKZPnDXLLPMxYqizWmcskggmham/6UO8DiPqb2ateNHlrxh3CkSUeDRoGhCf4q59tNxR+WAfweJYSetWvyhNvTuoS00Ld61mkGnSoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409953; c=relaxed/simple;
	bh=ABI/EFHJHVaNCHaijxg+KILIg7bxJn+29Q9oySvuJn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EemrGIZ9GTfyR8J49aJWRixPk9KGNs9Y6zSD1QfCuw8wm/DFA1zooiX/EI+UTg88qXaOgVdsoQu3m+uqT9iT8cGA/eb/nigBMAil0Bj3hor6HlpyvGd0boUGTo56kObVNxUAri+X+z1EFncCeCMJjwg0qj7mcs3v23D4GKpbZBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bvlq6a4Z; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-74068f95d9fso1023918b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409951; x=1747014751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+insc5JF0LDgOcxml+QzIIv4GANFmGAhKwH/cRPIB3k=;
        b=Bvlq6a4Zr/ay1q2m07r3z/6IzdIK7mzY2pMF4B5fU6PfsBKNW4fF6i4en8UwctW9d4
         DnYH+1mWrG3aiyz9vuAeCq6+XeJob6xEK9eKmaeTSP2yzYh9qOhHgjoSilVGQv8OZpL3
         1CM8wproDbvPCMB9ICwW7912XDJrBsnXGTRDKooUgNCYABge30kjhgHkP24cfpYk9e/c
         qtUaGx8CLBxBPKgdZaqUo7rxtT9pnVb21dbXFbkNZiqe6bgRjVwt+8wG+lUNsts+3A73
         mlTCNMVfIvu1myPeXIkgsguzT0wUaUx/Nc6b0Zgo0m/RnCmx7ohHKcWN63dqQq2d52aR
         uGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409951; x=1747014751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+insc5JF0LDgOcxml+QzIIv4GANFmGAhKwH/cRPIB3k=;
        b=dx8BseqSQVc9l3NAzmXqk9tR/fC6iE2DCIIy5/L/Pm4tVtgXQd8r1eNPcl/8l8YEmT
         R6FQysRTcJNOA/q9EGNYcO3iJIabcMVrfqvcz6/ME7w4wJ5XJB/nVh0ugCJr3Z853Q6+
         Oi6HVV5YPuKqtGJwe8GEnN6U7Em6QvyAbaDZ/nyhzxVdYOP7p/kHiTiQNPUN0W5Iyp2t
         AQN3hd4E4VmL31XCKnbsahHcrVV4cZ24c5dmminNTcaNNmOozGXTWNB5evl1I8iXCHhw
         gGQIgwIvzEZP/Ql/I/Om9pR/3vvfoo586PLJhtfmK8YGapyeeTU5e6auyolm5lNxSW8e
         Jb6w==
X-Forwarded-Encrypted: i=1; AJvYcCXTPjlJF/Yll6exCFxklreJ0OP6a1+VVm+zTfFptk2BxME7jLQzMxDgnUx4Q28hHDMIWck=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN2vaa1oyyIgUcQ/EakYQz6MrZU6zGDyGfMPShvYLx4nCh0BYx
	kM8vulgie1Jm4H18wt6V7I7hcCiI/icO/n5er9Gkw6Aft/ohK7HoYcy3AevCXu0=
X-Gm-Gg: ASbGncvYiVPG/faOe69BZtH8IYtenSQS3/PKSEDnKpW/ZiHTD1ah9jXT6nsCgnVMx32
	r5yws4S/O2kNfdT4Cl8SrfmuyYwRWxzgMlJuat/wEWfLLsSRBHhhd4xE4zQRUd8vxTdE6qHv+p1
	xrdlfCRYjEPD99ymahiugaLtsSZAjKXoLaB/GpJLs63pg2LVCv697XLJS6whRPA/QZxRPU9hIQP
	BKNQQjmnRC0CVgmZSApmbCXJJz6Ng+vCKoPU02yuX1AzJPcVXNChIz21hwKxTq+7eYT+Hk977Ku
	E+EA7HQNWXwBHAKmTawvTksdwntdVrb8qpDAcI7xkRFuRY3Pnn8=
X-Google-Smtp-Source: AGHT+IE8QIMP7OfGkKKt3trPX6lPSRIjp3VYA8PxD/ZDYRx4dMoMuOmuOKmsaz6Im0Gy3fu/ZCT8rw==
X-Received: by 2002:a05:6a21:3405:b0:1f5:7710:fd18 with SMTP id adf61e73a8af0-20e9660883emr6877505637.17.1746409951002;
        Sun, 04 May 2025 18:52:31 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:30 -0700 (PDT)
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
Subject: [PATCH v5 04/48] meson: apply target config for picking files from libsystem and libuser
Date: Sun,  4 May 2025 18:51:39 -0700
Message-ID: <20250505015223.3895275-5-pierrick.bouvier@linaro.org>
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

semihosting code needs to be included only if CONFIG_SEMIHOSTING is set.
However, this is a target configuration, so we need to apply it to the
libsystem libuser source sets.

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


