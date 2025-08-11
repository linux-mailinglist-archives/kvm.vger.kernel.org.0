Return-Path: <kvm+bounces-54423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C5BB212D5
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CECF7B3428
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7034A2D47E1;
	Mon, 11 Aug 2025 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HzzFnpcJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6491D2F42
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932004; cv=none; b=AXllXyQmR+Prtn+jdlKV/wT8THh8jQz/tDCB/HT4j9Gat4FT3Q8ibP78dfIMkrY9UTs/COlTmJWHJscbMsqco/Q+L73VwPOrlHOW6a3vD0scXavKKWjLRCo3SpeOSruNvkqVYp3nTlkQOEuBM2iuArdlXr5xMaY5rLjDaiSliB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932004; c=relaxed/simple;
	bh=xIqd5uT79I1piy1mTuKgPPTqgqe+FmDcIJG6nMhhPOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ssCr7ntoAPTyUm8BrTHjIxaxods4xOOBXPsLp9wEIs2UvUX64y9m0Kh/uTX351XxJ5Yy+pufqQyd16WzIzEc3+wJoGoDhCmC/hPgShUndfJa+GHu+1HQjter0ONaHDdGZlLCXuQleiHdTdW7gllLUlLB2Htsz9CAILBxtkzOyMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HzzFnpcJ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-458bc3ce3beso28102135e9.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932001; x=1755536801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87BQk4WDEzqTJD4OBgNMj09kaieo6h7xgFKV69c1SWc=;
        b=HzzFnpcJDoEWX4q05Lk3tC0EX/bEPr8M8niVOTR4u0D+TJA85B2Xq3GCfj0ySJrN+p
         qVA3jQi5N2xypEvS20zsMuLDfZEQafYWS0mKnDqOA/T/EUsmaoyeZ0UIUo1F5IVqUxkM
         qenFhdoxvJO+pR4tXSaXajPmq3//jpZ6U0EkekpzhdKmi5bUrvSpm8K1kQArbOptI3wV
         /8CbFJ6s3k9oyxoDLO9Ka5lj7SzGSkCfrZD+OlAiMW8iWu0oZJLRZlZGeYojNj/vFYFg
         6IWdG14E4K5QFIZYGjT8llBIl1Nc4oPHCHybxKO3ioRs105YKdodkVes8OKeUEFh5pzG
         cycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932001; x=1755536801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87BQk4WDEzqTJD4OBgNMj09kaieo6h7xgFKV69c1SWc=;
        b=ZG0Ycmg2VuhDg3rSCN/5E74BFyHXU0RPCCoCd4X+vigmp86ipO4FC0E5jTRqYaWpaT
         s3s5mnrMXgHA/qYHoUSoW3HCoxiLKEGmrY8KCLIvyuTteR3Cu+ZDzX5aeYL1+r5u/uvv
         n4O+FAgppnJSaTAvZ0HSm/UASS/b97kZDeJCa4FGBoZluDbynNPPtkrAJqwFPsv6Qy4J
         NTwYJ3rhW1ujPnKilnWzMw7hZkU3DbUF+hzYXvBwj8YwsWHqUROTK4OAWEM8jzSXrqNS
         utO1Qrf2Z7AK4fNzVL/tdfIYNpaSB9EHNJHwlv/Xt93F7oRG5VxlZ7jJGXfCj5NgDqNl
         q7Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVge5zX09VrClO53CT7qufhGcR/CuzAtWinCA7ElZFIjsk4qLpApyV4hpecuPUekkQceEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNqnoZSERwzAUiF+BMeuutdB0nGnELMgGkAiPgyxDERZfkcg3z
	xLM8me5D+eJL07pIbgV+RXaNlUw6xhWIhT5s/H6xSPQwt2qIrmCaRVJmgblskU+qee8=
X-Gm-Gg: ASbGncsGb36PjVR16ivQY8Mn0oPl8W+IUwh+FQvvaRCpAhuhLiBsZ2mP9O/tHx4ne6p
	maqxHlWN7dMwER98nNd5YTwk3rd8WayyzJZKI+nQpQne04SdhnLp7N1Q4QHP9gLHtGJ1b7qsFAl
	PWiJXts2DPCrNazVD270O/LHHa/18npbOFEC5GAonsh55T/i2YajVn2xcUKWlNGVxDqVwjqjlf/
	Nzz3nfn7mBdHMM+rPS1ivSjJnqociHPAWsp2zDI4t3t9PYZhIFAartyivNFQnCcbyHzZw2UVGVE
	nsc1Gd6nNVmIQXZ/TNn1YL1a/LEslXaODSa7pwFgm+LUDKt24/SElJCaZj4QoYhD96NiVuKg3TP
	88jfzZRfJDnn9CUfKkh4Slb1F8Ulbdw94st4W97bGkYjSyOTXHk0DVX5VYiiW38Sir0lv3ZZOil
	HOFvl8/ls=
X-Google-Smtp-Source: AGHT+IHaTwICaPRcKARdQT0mw9k+cJoRSQtgKTQLc8LGODj1lp8+nI2sBInpFOyWKeNcBONwY9kYnw==
X-Received: by 2002:a05:600c:45c7:b0:459:e398:ed80 with SMTP id 5b1f17b1804b1-459f4f3b70dmr100697845e9.32.1754932001105;
        Mon, 11 Aug 2025 10:06:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dcb86d6asm311879855e9.5.2025.08.11.10.06.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:40 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 05/11] target/arm: Introduce arm_hw_accel_cpu_feature_supported()
Date: Mon, 11 Aug 2025 19:06:05 +0200
Message-ID: <20250811170611.37482-6-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Introduce arm_hw_accel_cpu_feature_supported() helper,
an accelerator implementation to return whether a ARM
feature is supported by host hardware. Allow optional
fallback on emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h     | 12 ++++++++++++
 target/arm/hvf/hvf.c | 20 ++++++++++++++++++++
 target/arm/kvm.c     | 22 ++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index dc9b6dce4c9..5136c4caabf 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -2507,6 +2507,18 @@ static inline ARMSecuritySpace arm_secure_to_space(bool secure)
 }
 
 #if !defined(CONFIG_USER_ONLY)
+
+/**
+ * arm_hw_accel_cpu_feature_supported:
+ * @feat: Feature to test for support
+ * @can_emulate: Whether Allow to fall back to emulation if @feat is not
+ *               supported by hardware accelerator
+ *
+ * Hardware accelerator implementation of cpu_feature_supported().
+ */
+bool arm_hw_accel_cpu_feature_supported(enum arm_features feat,
+                                        bool can_emulate);
+
 /**
  * arm_security_space_below_el3:
  * @env: cpu context
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 81dc4df686d..5174973991f 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -964,6 +964,26 @@ uint32_t hvf_arm_get_max_ipa_bit_size(void)
     return round_down_to_parange_bit_size(max_ipa_size);
 }
 
+bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate)
+{
+    if (!hvf_enabled()) {
+        return false;
+    }
+    switch (feat) {
+    case ARM_FEATURE_V8:
+    case ARM_FEATURE_NEON:
+    case ARM_FEATURE_AARCH64:
+    case ARM_FEATURE_PMU:
+    case ARM_FEATURE_GENERIC_TIMER:
+        return true;
+    case ARM_FEATURE_EL2:
+    case ARM_FEATURE_EL3:
+        return false;
+    default:
+        g_assert_not_reached();
+    }
+}
+
 void hvf_arm_set_cpu_features_from_host(ARMCPU *cpu)
 {
     if (!arm_host_cpu_features.dtb_compatible) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 66723448554..82853e68d8d 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1771,6 +1771,28 @@ void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp)
     }
 }
 
+bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate)
+{
+    if (!kvm_enabled()) {
+        return false;
+    }
+    switch (feat) {
+    case ARM_FEATURE_V8:
+    case ARM_FEATURE_NEON:
+    case ARM_FEATURE_AARCH64:
+    case ARM_FEATURE_GENERIC_TIMER:
+        return true;
+    case ARM_FEATURE_PMU:
+        return kvm_arm_pmu_supported();
+    case ARM_FEATURE_EL2:
+        return kvm_arm_el2_supported();
+    case ARM_FEATURE_EL3:
+        return false;
+    default:
+        g_assert_not_reached();
+    }
+}
+
 bool kvm_arm_aarch32_supported(void)
 {
     return kvm_check_extension(kvm_state, KVM_CAP_ARM_EL1_32BIT);
-- 
2.49.0


