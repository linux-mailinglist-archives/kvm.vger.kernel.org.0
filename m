Return-Path: <kvm+bounces-50324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7A0AE3FEF
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF0AF1785B0
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE5124887F;
	Mon, 23 Jun 2025 12:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a5qK/vx3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEDB238C16
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681197; cv=none; b=Bkxl48q0BCloPAXyJeGnOJuh88/RHgQjsvLYZEkb0FOKpo4OXkIUqTepp/lvlXtS3ylCwxaRp1me7Z0yNYLJU0wiyv6v5DrS8yda5+UXkW11me1oSQ7G3IjeWnNQ+NFwTTiU7RqbUDbhMV2dWt8OwdcxZumXvxU3fu0y2r0Eq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681197; c=relaxed/simple;
	bh=aACazlTnjjVuqSSrK+aqVnhw4rNg9Hx0k526/7OHNqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAbAAF+hNxC1T9Puw4sRnUC6Yz4XtMVMkXGYnR09/BJIMAKcx+QKvukS373pE+1/cr9PflJRlVVTA0c3SOsUAJI/FbvaGOrvjteJQAZ9MZ4k0WoRN+6IaLLyrNOIdM3j5o543yCD61EU3s0ciz8J5ZjUgFmeK7EhLUoRlv6PGNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a5qK/vx3; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a588da60dfso2485946f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681194; x=1751285994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9TcP7uZ8sj3k25ApWupc8E4+ydRbD8zQYT0ugNh7kc=;
        b=a5qK/vx3It1eGuUOPmDN5kOXyYCyiwFUi0oqEecqp5Od1+m2UOYU1szFElN3kWqbu6
         87DUWA8Lm+1q3o1JwRRTs0KKsGAvb1cvR0OOBQNZEzjOqbNPx6/dhXgYyPeHQx3ZADOS
         Ag4PJXMqo3erYnXcYdMKwdaIhNBR0n1Nb+Iy2fWgktUrAy7Dm7214TjQgnTN5/9ZZyIq
         vdMDEIpee8fhf9bQGwJwBzZqueJcf3PEho/kCmXDJqSGFS7NIUor5cHp4XaBS6m9phaK
         Jx0683XhqhsGf9fOmPfCvxhjOIYf/4Rid5M7caODuBJljRD7Pm3bUqgC77/G+lhg5nYQ
         lPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681194; x=1751285994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9TcP7uZ8sj3k25ApWupc8E4+ydRbD8zQYT0ugNh7kc=;
        b=JhK8BtgJ5SMi+f3Fp4ys1cTg4DuQKlwWJMJMI+KpSPlCovb7Go4ydYQqTkp3k3RYa6
         XrNHumA6DtSiymS3zFM0OgABOxvAl5pkRLH0DiIMH2m8RgBHjvV5v9iyaBV4SgmGgeng
         qjBsQTf8Inlq/eL5s7j3XlvKsKjs7jPh0r3jkOUKkh4JbiHc+QCbTT/kMOPYDvbiQ2b9
         BIqJ4YOuRCBJVqj2WSBUv0ld8QWJ6Cqfoswkkbf6c+22q8/tdrsxDCvP6pZry6EFeS0M
         cT4oa/QLWMj9UuMHpeaTzW7K/4ZcBjCZbaMvLyz/BLazjwmmNeEWnAL1UbplP/NJxoHo
         RIWw==
X-Forwarded-Encrypted: i=1; AJvYcCUZPgxccuuZUTyrirbWI2SqCZwWK55zQSQWWkvPYbeZNZ0nmdYLuseH9S5n6O4uYEu01nk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+78/Zzolf26o3b/lMcTnMVe3V0ganVPtTDae2Aeq0aSSNibvH
	AT2rmjsFJqn9RLlSTfy9zukwASzyjMNbTEKyboIoGfrWQC8KxLOSgwheJQfivDMJfameFl0oII1
	bZKyN
X-Gm-Gg: ASbGncsfvynjOmmkk4ziHymELBXTJA2JWrERPLlB7wvjw/frIdZj6W8c/4AH5dmrELV
	GNs8LwusP8pLW+jVTHxs+YvtN+TOGa8nhWlGsNH927GVz1PPRThv8B+SG6fht4kywzx0Xswh2KL
	iYv+1VTSrgPrEGrpPEVd/U9xVHy5TdSFeISjQggwMa18+Ltv4EkN2tEK/LIPR7W2QWPtrrIJLdQ
	JKzGEUf43QINqAmVMXkxcpcLtgtvU54BgtfZ5hCD6XA16FQ8KLKrIvsWSR2q2/b8UTYfdXh/yw3
	sKYmGGMBWGykTy+aEnFnQcly7uAHLm1MWYkqpSugQKfLyttaz1ToRBJQGkXKRGPfLWPqt1OT4+8
	Ht7OifMJddjSMOXTt+jCZbWYZHoCn76TuqYWt
X-Google-Smtp-Source: AGHT+IEHiq/SjlZG6KJQYhM0dN6HzIW1qJU45zGcdqrFfg265NhL0FAhAnfqOQcq/6jydwJBpJn65g==
X-Received: by 2002:adf:e187:0:b0:3a4:f723:3e73 with SMTP id ffacd0b85a97d-3a6d129ccdbmr8492187f8f.16.1750681194323;
        Mon, 23 Jun 2025 05:19:54 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f10385sm9537215f8f.17.2025.06.23.05.19.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:53 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 13/26] target/arm: Create GTimers *after* features finalized / accel realized
Date: Mon, 23 Jun 2025 14:18:32 +0200
Message-ID: <20250623121845.7214-14-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


