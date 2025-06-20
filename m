Return-Path: <kvm+bounces-50080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E25EAE1B8F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17EB21C201BF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A494291880;
	Fri, 20 Jun 2025 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="geG7jeWu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EF828D836
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424909; cv=none; b=oRYR2JAVAcM7zJDYbdjT3DzUSnZgsvzGwSsORz1/u+eJ6Lg9keJajTwvwdVZY5WhP+tWhz7V+xcfhsYavtzJjFXOw6oiBojszgmnPTL8X7Zeblnb61sAELh2Iw5SvDIQPJLij8i0jv4zU9Uqwr/Jx8bVjfCJFUYMEvWLuMOy9zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424909; c=relaxed/simple;
	bh=7hCWY+29H0nsvQP6uxUMF39mKyQZfubBxirlgGQjfwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4UN22DqbZFW5kRKNGqQgUtUncDci1s6qhF6Ze7nHoox7CfB1aDTFS0pIKDMteciUOSVgkHbuSM4yKSMGRhal2mjNWy44mKMuKtVNbxY8RV/wQnAjvluil5X3s2fiRnaoN5FzNMYjmsPR9VL3zbMixyd7xjGg9MO8Vknk3Sdv7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=geG7jeWu; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450cfb790f7so13865915e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424906; x=1751029706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbJkhz3jwM/7an+ncj+kPtqJZzlzC4z2AtmZHXah0xc=;
        b=geG7jeWudzXUh85p0Sqsxu4a7V527tLEVnXUBhNg+F2hPRSvB4Am+gf26jpA/wYkAB
         XJgMkYwL5S7yaHeoBuwjPPIIkZAtdYcXqfLcYBsiI9pJYgniQLSTjxjttH8jN61UV9p/
         EFH9e+1r1d67FXCIHrrmbCNe0wn5D2RPNeR9ud/iZWV74g9ddAY0XOHAHjwxfUW4rYIt
         07ooUwHIUVRv+FjfOjOq9xfXeogRoX+HbfkYYTYQzC5CP/0f78v1Q9/iRDR6v8tk00Kc
         zCzQ7du8ngx5o9xBwqozvr8cyKHxbRUIKEBPCyJgTrknucaytY4YkMW8hiJN69hVb3TU
         b3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424906; x=1751029706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbJkhz3jwM/7an+ncj+kPtqJZzlzC4z2AtmZHXah0xc=;
        b=MOwisKqAFgcDz2CpzXyoBx+1AO+N6tBIwZH/VvAPN6q1sOq/LEZVtpGdoMTOFa7/NW
         rORJOlmcdif3ZfHNPjrHkg5xiwAdo5Ie33jqEe0dtX/7DqEXdsOOt4tGDthQ7IWyHN++
         KeiggEQ6gi4073UXB+ttXfjzdsPO1Nx+LLKc7dSZFmt3/lkGkOuCoRI28UZcJd9laqnk
         DZZ4/5DEYvQkX9RA0wx1vWBmYDi3shl11zwKxUaJTQ3WScp5XCrXHEnXBtnGApYH3/ZA
         BVPGmeov5cr28Ctxoz7zmojxuVXV3fVDXGf+ls0dk3umY/5qgsOlIyn3x9pV7P1Zmuno
         QlEg==
X-Forwarded-Encrypted: i=1; AJvYcCUZKsHKnj18Tj8TlJhUwl27nCeuB5OZuIap7s+iH/Aiyd44qW5fiv5nmtGGfOVLIB0kEY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6q7gkoBBCAaF4bHWUSiUUuZIouOMS2L9ATiGdxzduL4C/ull3
	5NqIM1ak68gUhV0yGnA621XGuYiLVZqsozbS0zkIlLMm6suC1358Mc6qVMtNm0Fzwl0=
X-Gm-Gg: ASbGncv9E7cDbt4HbV5/YCUZK1IaKldX1QkOE9dvqa1P4fPuL/T6/LMuJHQYc+9B/oz
	XIHYk974fadL/rG+83FFtcvJw3SrQTt+HmkDy0bpdrjFmXWmoU6QptnB1bKQW8AMVSLqyVLcwlq
	glVDpMm8OZKWDlE60NtmrdTkN9xBn9J3l2pFMLwCRCTLY6+lFZMfuZi4QDCGe+HNpMeu0dxtLsn
	JdIr/CQP5dz2GmRg64o95wscC2mo8v87ubaYx5oGwb9Zfs1E8suS6OpK2bprop59v0gohc88ONl
	f4f2V6srrBe+GbOIjGuM7UhVHwuclLfwhbB+fK76mmQo/Y3oQ6d0hsNlIE3LMM5Uvxb76FW/nrR
	4HbrTO/urA7ZnJ2GnO2TOVmb+VOoC0WK/G8vX
X-Google-Smtp-Source: AGHT+IEovICPCvjwxdsOFxQYVKyO0QusibpDDvB3y28q9auAAPau9mFOJbflgaPhOt3KoclCZXn79Q==
X-Received: by 2002:a05:600c:1d0b:b0:43c:fa24:873e with SMTP id 5b1f17b1804b1-453654cb826mr25614575e9.13.1750424906120;
        Fri, 20 Jun 2025 06:08:26 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eac8c41sm59776775e9.26.2025.06.20.06.08.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:25 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 13/26] target/arm: Create GTimers *after* features finalized / accel realized
Date: Fri, 20 Jun 2025 15:06:56 +0200
Message-ID: <20250620130709.31073-14-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Call generic (including accelerator) cpu_realize() handlers
*before* setting @gt_cntfrq_hz default

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.c | 65 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index e5b70f5de81..ab5fbd9b40b 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1985,26 +1985,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!cpu->gt_cntfrq_hz) {
-        /*
-         * 0 means "the board didn't set a value, use the default". (We also
-         * get here for the CONFIG_USER_ONLY case.)
-         * ARMv8.6 and later CPUs architecturally must use a 1GHz timer; before
-         * that it was an IMPDEF choice, and QEMU initially picked 62.5MHz,
-         * which gives a 16ns tick period.
-         *
-         * We will use the back-compat value:
-         *  - for QEMU CPU types added before we standardized on 1GHz
-         *  - for versioned machine types with a version of 9.0 or earlier
-         */
-        if (arm_feature(env, ARM_FEATURE_BACKCOMPAT_CNTFRQ) ||
-            cpu->backcompat_cntfrq) {
-            cpu->gt_cntfrq_hz = GTIMER_BACKCOMPAT_HZ;
-        } else {
-            cpu->gt_cntfrq_hz = GTIMER_DEFAULT_HZ;
-        }
-    }
-
 #ifndef CONFIG_USER_ONLY
     /* The NVIC and M-profile CPU are two halves of a single piece of
      * hardware; trying to use one without the other is a command line
@@ -2051,7 +2031,40 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
             return;
         }
     }
+#endif
 
+    cpu_exec_realizefn(cs, &local_err);
+    if (local_err != NULL) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    arm_cpu_finalize_features(cpu, &local_err);
+    if (local_err != NULL) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+#ifndef CONFIG_USER_ONLY
+    if (!cpu->gt_cntfrq_hz) {
+        /*
+         * 0 means "the board didn't set a value, use the default". (We also
+         * get here for the CONFIG_USER_ONLY case.)
+         * ARMv8.6 and later CPUs architecturally must use a 1GHz timer; before
+         * that it was an IMPDEF choice, and QEMU initially picked 62.5MHz,
+         * which gives a 16ns tick period.
+         *
+         * We will use the back-compat value:
+         *  - for QEMU CPU types added before we standardized on 1GHz
+         *  - for versioned machine types with a version of 9.0 or earlier
+         */
+        if (arm_feature(env, ARM_FEATURE_BACKCOMPAT_CNTFRQ) ||
+            cpu->backcompat_cntfrq) {
+            cpu->gt_cntfrq_hz = GTIMER_BACKCOMPAT_HZ;
+        } else {
+            cpu->gt_cntfrq_hz = GTIMER_DEFAULT_HZ;
+        }
+    }
     {
         uint64_t scale = gt_cntfrq_period_ns(cpu);
 
@@ -2072,18 +2085,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 #endif
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
-    arm_cpu_finalize_features(cpu, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
 #ifdef CONFIG_USER_ONLY
     /*
      * User mode relies on IC IVAU instructions to catch modification of
-- 
2.49.0


