Return-Path: <kvm+bounces-54425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8295EB212D2
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 388B03BF9C6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF924315A;
	Mon, 11 Aug 2025 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zbLvXX7i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6042D47F0
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932015; cv=none; b=FjDDRxE0jt3GTYkMDhWzbA+EoCwqPU5H0KYRfSlD1ztfo9t7i44ivai0qJeAsLp+MshkyfqH4K9HTjeMraq5ugYWsyN4TM9GbKLjZCfdXos4mpoIi8YcYYMBSLjQcgU3RmPwOR3TaVevuscgKk1PsCxXkwzx4qvOWDVRH199vKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932015; c=relaxed/simple;
	bh=QNgZVA3Gw/baJ5zDZpDKLeG8FTE9WDQMlaBFZTcPxlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zs7SaxuIn5QwkDl/a9oGBJogZoC/PqHg00mC2pjrvjMiB3xt5RSAJWvUpnhbRRidnBZF3pkwdjTZXyBhgcOSf04AcgCz0GETA25wktYkJclqaQMdCjT6WiM4IQXP7H0bCCSHcbRRMKfUzGcXnAdJPFjJGED/ZhFRTHwisAC9Z14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zbLvXX7i; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-458ba079338so35851955e9.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932012; x=1755536812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xy66U/Y+GsoS7WvoAHDCbL+/HfooWzRIS+dCFcyd4Uo=;
        b=zbLvXX7ipgK/UQLXFOXmNYXtkR/MVxAndJ6dCDLsvuWQM+HUk/th91aE557j9gIMtT
         mrxRuOxOtb2IiYd8xmDHT/574B/JhJSJ4ukm2n/hPSEQ5oB9G1uZMsCZIiLPtHlH6OGV
         njUZtdTjnu6axyolI4E4tZRU6ko8nNC/AZrzUZ+p5TDvOtZvlNcb2Lf7Nr02UX1vdt+T
         xspz4QlLOS/ebKB0LJGKyy572fgZcW3cWTow7XHdl/rVR4v6qVwnfbz1PdHHK5u+NhDq
         Uy2niaFLKKu4bFbYZyGAGs7t0VGFoIyakx5Ac0d+lt3Nm6724hObQnsShC9xmn8RJgkG
         PztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932012; x=1755536812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xy66U/Y+GsoS7WvoAHDCbL+/HfooWzRIS+dCFcyd4Uo=;
        b=SfAdsmdpEj5WzdQd3Sw18ZqHKRAH8cGJPqPK12rLLI1BgvT1KM/LaVqO1vF017k/Ua
         FOfaunQ2HnQCHLVxqhsT5StA4upbgqgETKtzJ+7/UpvhqyFQMUkU/8EUAc3GqUxOOvF9
         lFXFo/Bj0sGdbiR//eH4qfz3KwnkmMt/bsqdpTtcKwJr5sKvEjMlsrksYSgklFGTo0Co
         hr6B585EegJr8YdDLnK4E8GCLxDgzuZY8eyCbksSM4wVXQqdWhcGiiDbUMA2J9SAjqUp
         FA7JYWHvqjpi+xdtMslhD1qUJy6hYUYGkYFjovV0lEWmgX41jDJNoxCFJOCwA5O43Oir
         Xz9A==
X-Forwarded-Encrypted: i=1; AJvYcCXWMPKA0kfKwveCfCsR616268cBymEmcbuATOvtlUVRmR22Cv13cLA74KH1LVkIWCkHqcI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx52un+bxrQbdgVrns1ZcVnGq66jJtMqcTu76IATzoTMwBROCDE
	qbI0LK0GI1Uaxt7vK6DWrnIgwuhoYduqjdiDdGNGQYo3D4wV+wsD1REZ9htWrOqsfGs=
X-Gm-Gg: ASbGnct80guFkLfPEC/I1qutofjm4EPhEysrsGHYMFvh2uUJaGM7yW0675JMxSvTKeg
	7lSXuQofxsbvqa94tdfY9b94gsi2ax5Q1Fu2Q2szPXUwmZSi5N2kE7sVLZlFxI5htLfsSRWMVZy
	5fqRTmPYy2IuSm9WFrmzFGLUjP4hihMNlE4b2qUd4aMSyFg/sEYG3ZBBO5v3CqPOA8qfAuux3A0
	usGgJvMYG9+3gdJJLVmKu5rCVrTqgC6aPNNUI7JpMdSCIPBcKAIOR3ENvozkP6jnUR+qLTJVkOq
	szUzBaTcXZqsc/PZmjR1PEcZuYEwRyk/+6+VKWc1AxVkQPdnpAJvwGpXQ0+PK3KWFlG3V9EzzK5
	JfRmk3jDrB538+dkkrnv7Km8PUZ0QfImp4DTrfC3DfWs7tAwSWZ1OcwjnrChPycpFiSAZALxu
X-Google-Smtp-Source: AGHT+IGmfphj2mVyIXTj/0jyub2rh0Wyucghu5fqob5NYPlURmtsCqqH6Zi92+hXGXffCLSOUjqF9w==
X-Received: by 2002:a05:600c:1c27:b0:458:bd08:72a8 with SMTP id 5b1f17b1804b1-45a10dac800mr3454185e9.13.1754932011892;
        Mon, 11 Aug 2025 10:06:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453aeasm42842421f8f.40.2025.08.11.10.06.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:51 -0700 (PDT)
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
Subject: [RFC PATCH 07/11] target/arm: Replace kvm_arm_pmu_supported by host_cpu_feature_supported
Date: Mon, 11 Aug 2025 19:06:07 +0200
Message-ID: <20250811170611.37482-8-philmd@linaro.org>
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

Use the generic host_cpu_feature_supported() helper to
check for the PMU feature support. This will allow to
expand to non-KVM accelerators such HVF.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm_arm.h  | 13 -------------
 target/arm/cpu.c      |  4 ++--
 target/arm/kvm-stub.c |  5 -----
 target/arm/kvm.c      |  9 ++-------
 4 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 6a9b6374a6d..364578c50d6 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -177,14 +177,6 @@ void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp);
  */
 bool kvm_arm_aarch32_supported(void);
 
-/**
- * kvm_arm_pmu_supported:
- *
- * Returns: true if KVM can enable the PMU
- * and false otherwise.
- */
-bool kvm_arm_pmu_supported(void);
-
 /**
  * kvm_arm_sve_supported:
  *
@@ -212,11 +204,6 @@ static inline bool kvm_arm_aarch32_supported(void)
     return false;
 }
 
-static inline bool kvm_arm_pmu_supported(void)
-{
-    return false;
-}
-
 static inline bool kvm_arm_sve_supported(void)
 {
     return false;
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 1dc2a8330d8..c78a3c9cda8 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1564,8 +1564,8 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
     ARMCPU *cpu = ARM_CPU(obj);
 
     if (value) {
-        if (kvm_enabled() && !kvm_arm_pmu_supported()) {
-            error_setg(errp, "'pmu' feature not supported by KVM on this host");
+        if (host_cpu_feature_supported(ARM_FEATURE_PMU, false)) {
+            error_setg(errp, "'pmu' feature not supported by this host accelerator");
             return;
         }
         set_feature(&cpu->env, ARM_FEATURE_PMU);
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index c93462c5b9b..3beb336416d 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -32,11 +32,6 @@ bool kvm_arm_aarch32_supported(void)
     return false;
 }
 
-bool kvm_arm_pmu_supported(void)
-{
-    return false;
-}
-
 bool kvm_arm_sve_supported(void)
 {
     return false;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 82853e68d8d..0fe0f89f931 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -288,7 +288,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
                              1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
     }
 
-    if (kvm_arm_pmu_supported()) {
+    if (host_cpu_feature_supported(ARM_FEATURE_PMU, false)) {
         init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
         pmu_supported = true;
         features |= 1ULL << ARM_FEATURE_PMU;
@@ -506,11 +506,6 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
                                     "Set off to disable KVM steal time.");
 }
 
-bool kvm_arm_pmu_supported(void)
-{
-    return kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
-}
-
 int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
 {
     KVMState *s = KVM_STATE(ms->accelerator);
@@ -1783,7 +1778,7 @@ bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate
     case ARM_FEATURE_GENERIC_TIMER:
         return true;
     case ARM_FEATURE_PMU:
-        return kvm_arm_pmu_supported();
+        return kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
     case ARM_FEATURE_EL2:
         return kvm_arm_el2_supported();
     case ARM_FEATURE_EL3:
-- 
2.49.0


