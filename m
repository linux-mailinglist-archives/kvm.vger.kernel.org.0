Return-Path: <kvm+bounces-54535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFF7B22F18
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11BFC624ABE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890C92FD1D0;
	Tue, 12 Aug 2025 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iG9eRO5v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EAB27A935
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019905; cv=none; b=THrF6CVAosu2BwKy4dXTJkApwStpxbkflPsYTTk+XjklTT3Wg5cxxUZXbqHuDT7eI7bU5KClrGzjxz05zQES3CoYIPjEku+sU4D1cCD3IB6xo29KToJ5AYhUzZb+vC0eY02bf8NI5IyZa8dmd7sdCjHw0GIMGGofO/Q1GE1kUoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019905; c=relaxed/simple;
	bh=XVDyOskt4u+sQTdZCan1Pa6I7dcIREXnthwI2oR4ui8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJ0iugS+ls/p3e3JMoHglDdqC9W7zBVNcg34d5Mf59nh3WhzJhQV4JVBeAuzlMBCN5eM1cBNjLZKDQYsBw3tBFbxo0AMJ6DoIkR2eLXO88kvcOJj6RUNfJsF2oI5bpp9MB8JfwxZEoisBbuqgk1CQ799GO88ZdZwjmeS6RNwsS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iG9eRO5v; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-459eb4ae596so52916075e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019902; x=1755624702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItlZL67yXVkL33ShD3YcHf/7JlewuU1bqR+ufSEzLKs=;
        b=iG9eRO5vUbfUFZC9zNNDrPfKiy0sHN5GPXdqgXeoxyWsXuxADKZWTZn/b14h3j9/hS
         clEerbQDSFiMhh2Lrdo+vRDMa66Jjv/VSY4fzImKWRQKBqxJTRCJsId1TmJ2T/UdlLwU
         fVYNQzdG9SarveLdQYUF0NlW7aX6rTAP2WGd09ZlIEveIJKFVV+Gcyh42PexH8ej+qH5
         j8zSm6kuJOAeo/CkZQIu+6zidrPEHRFqJdh11GS5VP6/h8xHPeoOn6pRQNGIEfbDTbdx
         p3mHEFaVIhXqHRgEeIeDStYdgBmjXRyrZ/SI9n7gKIUev6h4Dza6AVGVOoPwH9RDZkZx
         D7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019902; x=1755624702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItlZL67yXVkL33ShD3YcHf/7JlewuU1bqR+ufSEzLKs=;
        b=XYgz3dGcrn/jnT+mwwu2GFWNFnq2/HakaxHVhB/RGMxa+5Sh2XlRHloQPub9HLPYvM
         tDnCjzjvl0n/7Zrnr4mTp/8ttMpZdzjRlebFDPniy8azLBRkxfCi7gkhoYlCpQgULPUx
         UyPdp1jx8ctnrY9CnQAC1mCX9qJgy65tNY5JnwfJi3aO64EuFGaOFTsN1cwDukcE2SQL
         cnu8fQSV9IfYxx+WJ8CO65B/aD56ilzazwqHjnWZ4BcReWHbAXSiLfWyRpi51g9+/oPa
         2FgXaoLvZmgBtAHXa27i4oQnUS1/OARuGno92IjTRWav2OjVdWfxJharaxzt+WgsmYML
         2VZA==
X-Forwarded-Encrypted: i=1; AJvYcCXk0jVjuNpZuUBsNqzBUlPWnj0ICakpTnS7zwKquj9kSfDql+dFjfqtTmpz86WxovAXzEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrwDzRMY6i5kb9XuMzLg1JofmEQnwaSeDCO3dtJ9fI3rTRFFiG
	UCCJunmSY5bLt/Fl6ySRDpLQoI0ddleTqwMfkpwbpMJj2dq89nc97TzQN+AI5ymRa40KKFsh3Ma
	XP0zp
X-Gm-Gg: ASbGncuzVt3LcjT3PLAm1jPAYh5gKUKyKOtsx2tnoLLlf84ykdDg3daKWkMYN6kwUsI
	dbbeMQ8xFY3Qz1safK3ZkhMoF2//bcGGXDoo+pQPd1mbnJb7iVuKwRClnCMY9olaOj4cZ2WoaN4
	q2fjfP2z/aaQgANEHk06CoHPYsl4SuZ82kLNb4EVzv2OlyKF3oRcqbZoK2bxaY6EausFEXbxvQt
	x2J33VHHCoLx0WACRWP1+GslPbJyDwJ3ofLoTUHzPvVvfaU6MeGpHoqW3h0ESjbqQn8S3KfgQrp
	oUguji71psR8XxETpFQeahRQtX6A1cPMEM4NPG1xO1ZngVXt3e5wKlZdebHqs1q6sk5PUEDudVk
	9cyeyP1bZLe+RmPdeWNX2qMiHwDG0Y0RIkIIZDMPQwGqhK6b7z1E2VA3ISPXwQo/JeGqBovsG
X-Google-Smtp-Source: AGHT+IFzbket4AksstrlBz0r9ZXzdT5oXYjhvGXkYpRrgm5GJc/8f6Fzu3mmwL0yHFoI/yyxIiZ/Dw==
X-Received: by 2002:a05:600c:1c01:b0:458:bbed:a827 with SMTP id 5b1f17b1804b1-45a165b7b15mr178235e9.1.1755019901964;
        Tue, 12 Aug 2025 10:31:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e584302csm329645345e9.7.2025.08.12.10.31.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:31:41 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [RFC PATCH v2 06/10] target/arm: Replace kvm_arm_pmu_supported by host_cpu_feature_supported
Date: Tue, 12 Aug 2025 19:31:30 +0200
Message-ID: <20250812173131.86888-2-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250812173131.86888-1-philmd@linaro.org>
References: <20250812172823.86329-1-philmd@linaro.org>
 <20250812173131.86888-1-philmd@linaro.org>
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
 target/arm/cpu.c      |  6 ++++--
 target/arm/kvm-stub.c |  5 -----
 target/arm/kvm.c      |  9 ++-------
 4 files changed, 6 insertions(+), 27 deletions(-)

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
index 1dc2a8330d8..ace8e73b532 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -24,6 +24,7 @@
 #include "qemu/log.h"
 #include "exec/page-vary.h"
 #include "target/arm/idau.h"
+#include "qemu/accel.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
 #include "cpu.h"
@@ -1564,8 +1565,9 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
     ARMCPU *cpu = ARM_CPU(obj);
 
     if (value) {
-        if (kvm_enabled() && !kvm_arm_pmu_supported()) {
-            error_setg(errp, "'pmu' feature not supported by KVM on this host");
+        if (host_cpu_feature_supported(ARM_FEATURE_PMU)) {
+            error_setg(errp, "'pmu' feature not supported by %s on this host",
+                       current_accel_name());
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
index 93da9d67806..0aa2680a8e6 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -288,7 +288,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
                              1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
     }
 
-    if (kvm_arm_pmu_supported()) {
+    if (host_cpu_feature_supported(ARM_FEATURE_PMU)) {
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
@@ -1783,7 +1778,7 @@ bool host_cpu_feature_supported(enum arm_features feature)
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


