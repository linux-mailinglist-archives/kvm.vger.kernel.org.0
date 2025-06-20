Return-Path: <kvm+bounces-50079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB925AE1B8B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E500172F87
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F1E28EC15;
	Fri, 20 Jun 2025 13:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cpKRkVT/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30BB28DF1F
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424903; cv=none; b=P8esOa85eGB3KEEiN39HYVQPM6IMYYaEOj4tCzt7A4iTp6yWTztPAkmqriA4mb3cRdffCVVyKJUm37TI0+80D8JF40TnNdHNFSId0txo85JOJkLfgrv3S9WS6sJ/YlT5h7icWqlqd5Pn5sXGd+kstS2RB78FutHiDHBYpaBgJwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424903; c=relaxed/simple;
	bh=99FZO/+WmzSXSSct40a4qW+V/VXxB65AVjfgH7E/3+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MoZ6dB5EQjLVGjz/eR+bzbXpeHgiSvAG+pJ8iTq0I+qnULwFr7xuN9D9cq2WdBhz6se4JnPI2OlKQS3cDgKjGvBJb/Qsm0c+1HWHpPzCFdXHjbdiEbhSRESvkfSTq5fxJJ/8r3nf2xGx8ambhxvDJ6BBAGpn75q6AAe1A3/ID1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cpKRkVT/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45310223677so15214985e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424900; x=1751029700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oAt1PQLrHnO21M2Y87z2Ba1KRbOWR+1s+ZX+rYgrLRA=;
        b=cpKRkVT/sB4rRrxFWViAiMXYnD53XPrkmA3m6JWk8pEywlLjFB5FXoB/u7fnAx7SGj
         +Tfuw8+y8tKtp8hC+/k4bYRQT5cU53XODWhzhn2vUHnA3Xq6ZRwy6B/D0+5kYgirufie
         Xu+rSpzh0ih9HbTcCnJjire50DZPEpU1E4jvVt9O/HJpuqpgSu6ePGk8hO4tVoodXxgY
         FqOQNknA2mAgRDKi92KtfqR9fwq6ghN2Tj0gwgdJb86cvVyPSGdoPwM6TAD3sWoI9z2A
         ruyCC9CYQdq5kY9jLnmxoh7qSb2L/vdCU2VUMbevmEKax0X/cOc/f0OkWNVpMNqbOg90
         JjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424900; x=1751029700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oAt1PQLrHnO21M2Y87z2Ba1KRbOWR+1s+ZX+rYgrLRA=;
        b=BAnjmpCmvF38vxtx8de7g4LWeeQD4Tj1vPABR3PkQrzALCrKlnQCxxKdlO+tJ1qbzT
         NdmPKiBskS69mZ6INKFXtPng6/ukoTIstTuz0Wi6xm2I0KVwNjYTItERCCCuSbFPoRay
         8CU8iW9AZi9fvMBbyR8F1d65X23E7BrS+OlxyP3HZIJAIiuPebLQ1Xa1GE6X8ooF8XB/
         NGPBKQjIck1TL2a24CFGmCkiesEaT7ov0wAbg4IQW1lPrnEPwzivdOUKfFF7mMb15NJ1
         n2l7MgdXu82rNZBPlXEqUzWXHMBBi4OLK4k4WMsqw8fJp1ofqVZalmOo8M+aaKDDRiEs
         POYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIalp3daMSgrbseYYyr7QQLdoICxS5gQcBmQtCetC/mm3mrczpk9gVOJ58qzDYoor/JYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT4rO2rIU0Sn/U7ANI04TQrZSU2IySC/BVeRTKqmNGI2qhhivQ
	VNhCywhUV0X5tnVvNUlz7sBvgZI/Cd0Jt7/FTr8FZdCvnNNyvm92wmpIGcmw04mreME=
X-Gm-Gg: ASbGncszkvkmzkAPUcrm35532nhJWHcIpm5oEchHPty7ylkDz4cvblaeYJqJOjmOhAm
	gdNcyLr74Sj3gnMJeqTcxHyWtr9GwJou+uroPvYQWGonJ28kw0kUExHSSSGK13QcBfIwP7Ba6+L
	IXyie+pGNBzUFPoMStYgzmL8oFcserOS3GDKjfVKWzGDeal7Ju5MdbfPQaiM53VCYcaHQlk3aka
	Hk6MV5gPCc01xP+ZOlJKxqmgq3WPloT5zkG0cLhhCXFFe+WHIjdGvw1F2lkHYScSISocW/Fwv5p
	6LOQBtOEQ9HLIri0imd+wY+xPm9oSv+MvxIJgOEfbsBuzHdvPJx6k0e20z5HoIMSkMTaSYe7Gze
	KOjVzEKYKSizQGheQs8Q3sSCcAcs47EwJsy1A
X-Google-Smtp-Source: AGHT+IEGmchw+a0k0hX0S9KobjryclE57uq2sgKFzkmMvuxn/d4B/I66wfS6mkzaJen5FMifqGqbXw==
X-Received: by 2002:a05:600c:37c5:b0:453:5c30:a1d0 with SMTP id 5b1f17b1804b1-453659dcd62mr23896155e9.21.1750424899969;
        Fri, 20 Jun 2025 06:08:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646cb57fsm25578125e9.1.2025.06.20.06.08.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:19 -0700 (PDT)
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
Subject: [PATCH v2 12/26] target/arm: Restrict system register properties to system binary
Date: Fri, 20 Jun 2025 15:06:55 +0200
Message-ID: <20250620130709.31073-13-philmd@linaro.org>
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

Do not expose the following system-specific properties on user-mode
binaries:

 - psci-conduit
 - cntfrq (ARM_FEATURE_GENERIC_TIMER)
 - rvbar (ARM_FEATURE_V8)
 - has-mpu (ARM_FEATURE_PMSA)
 - pmsav7-dregion (ARM_FEATURE_PMSA)
 - reset-cbar (ARM_FEATURE_CBAR)
 - reset-hivecs (ARM_FEATURE_M)
 - init-nsvtor (ARM_FEATURE_M)
 - init-svtor (ARM_FEATURE_M_SECURITY)
 - idau (ARM_FEATURE_M_SECURITY)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index eb0639de719..e5b70f5de81 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1500,6 +1500,7 @@ static void arm_cpu_initfn(Object *obj)
  * 0 means "unset, use the default value". That default might vary depending
  * on the CPU type, and is set in the realize fn.
  */
+#ifndef CONFIG_USER_ONLY
 static const Property arm_cpu_gt_cntfrq_property =
             DEFINE_PROP_UINT64("cntfrq", ARMCPU, gt_cntfrq_hz, 0);
 
@@ -1509,7 +1510,6 @@ static const Property arm_cpu_reset_cbar_property =
 static const Property arm_cpu_reset_hivecs_property =
             DEFINE_PROP_BOOL("reset-hivecs", ARMCPU, reset_hivecs, false);
 
-#ifndef CONFIG_USER_ONLY
 static const Property arm_cpu_has_el2_property =
             DEFINE_PROP_BOOL("has_el2", ARMCPU, has_el2, true);
 
@@ -1532,6 +1532,7 @@ static const Property arm_cpu_has_neon_property =
 static const Property arm_cpu_has_dsp_property =
             DEFINE_PROP_BOOL("dsp", ARMCPU, has_dsp, true);
 
+#ifndef CONFIG_USER_ONLY
 static const Property arm_cpu_has_mpu_property =
             DEFINE_PROP_BOOL("has-mpu", ARMCPU, has_mpu, true);
 
@@ -1544,6 +1545,7 @@ static const Property arm_cpu_pmsav7_dregion_property =
             DEFINE_PROP_UNSIGNED_NODEFAULT("pmsav7-dregion", ARMCPU,
                                            pmsav7_dregion,
                                            qdev_prop_uint32, uint32_t);
+#endif
 
 static bool arm_get_pmu(Object *obj, Error **errp)
 {
@@ -1731,6 +1733,7 @@ static void arm_cpu_post_init(Object *obj)
                                         "Set on/off to enable/disable aarch64 "
                                         "execution state ");
     }
+#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_CBAR) ||
         arm_feature(&cpu->env, ARM_FEATURE_CBAR_RO)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_cbar_property);
@@ -1746,7 +1749,6 @@ static void arm_cpu_post_init(Object *obj)
                                        OBJ_PROP_FLAG_READWRITE);
     }
 
-#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_EL3)) {
         /* Add the has_el3 state CPU property only if EL3 is allowed.  This will
          * prevent "has_el3" from existing on CPUs which cannot support EL3.
@@ -1818,6 +1820,7 @@ static void arm_cpu_post_init(Object *obj)
         qdev_property_add_static(DEVICE(obj), &arm_cpu_has_dsp_property);
     }
 
+#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_PMSA)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_has_mpu_property);
         if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
@@ -1854,8 +1857,6 @@ static void arm_cpu_post_init(Object *obj)
                                    &cpu->psci_conduit,
                                    OBJ_PROP_FLAG_READWRITE);
 
-    qdev_property_add_static(DEVICE(obj), &arm_cpu_cfgend_property);
-
     if (arm_feature(&cpu->env, ARM_FEATURE_GENERIC_TIMER)) {
         qdev_property_add_static(DEVICE(cpu), &arm_cpu_gt_cntfrq_property);
     }
@@ -1864,7 +1865,6 @@ static void arm_cpu_post_init(Object *obj)
         kvm_arm_add_vcpu_properties(cpu);
     }
 
-#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64) &&
         cpu_isar_feature(aa64_mte, cpu)) {
         object_property_add_link(obj, "tag-memory",
@@ -1882,6 +1882,7 @@ static void arm_cpu_post_init(Object *obj)
         }
     }
 #endif
+    qdev_property_add_static(DEVICE(obj), &arm_cpu_cfgend_property);
 }
 
 static void arm_cpu_finalizefn(Object *obj)
-- 
2.49.0


