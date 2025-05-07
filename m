Return-Path: <kvm+bounces-45815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E23AAAEF96
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A05931C02C60
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E412918FE;
	Wed,  7 May 2025 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xgmjaavG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3190514A4C7
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661621; cv=none; b=Hhlr6y8epys7Jh9EmdBlnk+xS7+8pbfD4x5OVlo3BUXZzmP625Ol0jbWXCkFBdCqZTHBGPYCxn0zQaMzIsORVGGS89C7ssuYZ2/P2CNMRgr0w0CmYxwYApvUiGy88r3y+jkIt4Ps1NklO/9uVJaYmDw2PIx8L949RWC0p5gG93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661621; c=relaxed/simple;
	bh=Rn2lI2/pl5nRyUK/hjfWkym7bAiVbpNG1rk6SoHIe0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJNkW+o2gboogvAg/yZu1I5j14+eJg7b6qsrEcUNRrs2Neiq8kDAwj9zWr7FKfotcNRf4wRsPG+5kHWZ6oEay3z5pPeUD/+radob3vkJXMI/sKusah0xjmchmBP7bb3JcS26UrsIYxEUEpLtEn9s5LdlJJmr1K8zfaJQ9/z/MW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xgmjaavG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22fa414c478so478175ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661619; x=1747266419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9+0A2smB/xfpAp/1FKWxfsvzCeqir2otJn6Vwgzfpo=;
        b=xgmjaavGTnIpIl4gpieuj9i3aWM3JOa97g/yxlsbXXh3G5m27dTRIm8KLqyejlBrFh
         wg8DSJJNrwKV4I9E91j1kD//o6Fk+GpuzChqJdelIzHB46nsiTc9ovsw2COhXJf30rXt
         GxsD+FdlEAT7wgW/16GPY0cdSb4Isdu6ZfJezTG5YsEpqMv2Z4aKM/Qvo3XyrT4mVNNg
         3c6xuH/xv5C3mx6eaVFOcJmOpY8151SXjeo6LfMSOvMXK1l+M7o1wDMmxHhymU5RupbG
         FC+j6JzGRFwpntE64GtUwzcpDYz9/e4ayKr40xMyMcl5CvmcXc1b0Gt4vSur4HNDqOwq
         4zwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661619; x=1747266419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9+0A2smB/xfpAp/1FKWxfsvzCeqir2otJn6Vwgzfpo=;
        b=i9aHjtjyvffn/d4Ez5M7Ioh1+Q0zPutQzQ5NdKQpjIH9ZZtu/ixmKKEkX0AVw8FaEW
         AKanX7bP2ZNFpSW2GPstsZG98xa29IdcjrO6ceYopVXdw61SSbulnqn5lh4dFhZ6NoD2
         sgUZTz1ItIlSDoF33HH2v20DVuHoxvDAy3cT92rzE8JsqHyCuOUTqnFR7lPTzBFl0In4
         J9WY7D/ODa5R1fC2zWbVbvC5mHAP/mc55OpCYDPfU+DT5+M8eA2MUSdBGwPSblaoa6rY
         9Qmi1jVyjEpuE1d0VxVArJHd/0Cym/nb3W+4dDfPCgFVAoeDXcFhPIzFGoc/zDC/0B7L
         egxg==
X-Forwarded-Encrypted: i=1; AJvYcCX0jBlrn4e76R1xuP2weYK1U5b2LUbLzVGP6mWA5hfw4VS5bfwMlawKL2C4iGfQ3MXG/zg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdaA0ee1LXiObMbdsA306qfickNJuTBIdOpUAN1NYdJqRf1BPv
	BG92YDPglwFDAZpcfn53iTZD+AXtn+37vCvq31rERU1fPMayZg9auXEwXT2b2mc=
X-Gm-Gg: ASbGncsifkmCgB1/P4IG8yFMoYJISkJagDWWCjkNDc32sTwOx3IAzEsoMmRXzdn/u8f
	3xBfzNBzfZ4SQK+MCswF9yDpsv9CStm/vlPUjt+EqmBNGml3/YgTG3/XjQ92cWJKlb9p2rILwX4
	ElzgxzzhescLjgyQ3W1b7Cl7pVo2D/ZWwrUa7HvdSqXwJh7Ow2Dlyh0fsp7XHxqYoAhtjOvFI0v
	8VDVWm7688Z0R5sUiGx8nU7rMw+WHi0QMgd9upSCiaFsE4Kb50CsdfYyt48OA4DkAI2vnumtYIp
	Z5dHnNryCI6RKoJ6YT+K6Ubc9FbOh0fUJ1v+7Rnd
X-Google-Smtp-Source: AGHT+IFD7JLl7PMkprSB+gonsSnigWdQwt5Gm7vQMOymA5jKMQ8arRw0rvIvBHmHIJgyHjopluQ80A==
X-Received: by 2002:a17:903:166e:b0:224:c47:cbd with SMTP id d9443c01a7336-22e5e98947fmr80767545ad.0.1746661619500;
        Wed, 07 May 2025 16:46:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:59 -0700 (PDT)
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
Subject: [PATCH v7 49/49] target/arm/tcg/vfp_helper: compile file twice (system, user)
Date: Wed,  7 May 2025 16:42:40 -0700
Message-ID: <20250507234241.957746-50-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/vfp_helper.c | 4 +++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/vfp_helper.c b/target/arm/tcg/vfp_helper.c
index b32e2f4e27c..b1324c5c0a6 100644
--- a/target/arm/tcg/vfp_helper.c
+++ b/target/arm/tcg/vfp_helper.c
@@ -19,12 +19,14 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "fpu/softfloat.h"
 #include "qemu/log.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Set the float_status behaviour to match the Arm defaults:
  *  * tininess-before-rounding
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 7502c5cded6..2d1502ba882 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'vfp_helper.c',
 ))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
@@ -68,10 +67,12 @@ arm_common_system_ss.add(files(
   'neon_helper.c',
   'tlb_helper.c',
   'tlb-insns.c',
+  'vfp_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'vfp_helper.c',
 ))
-- 
2.47.2


