Return-Path: <kvm+bounces-54536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 993E6B22F19
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEBC71A26FE3
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332611A2387;
	Tue, 12 Aug 2025 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dgDNHQnY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B727A935
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019910; cv=none; b=GeVdMep7T873L3GErmawc+sn0OZtLzeISwoCZ6dG0yMuA/rxLUpFkJhnnhyeThAMf2MJMlYnONoxsfGoPDpdAywFNZed/QveSgHMHR10EKUUTbFJQAR8O6RQW2v9ns7hk9N5nvBZ6pf8bm/2et9XoUjB82SLXMH2mZsyWypxIIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019910; c=relaxed/simple;
	bh=yshZBcX8grCSh5Oc5nPS9LMtKcLlcmnW880y5ZFZeJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHBU1kNOwUZXIo7cqewG6h9cVA3GKiCUnvC/DVb2uGU5M1k/QkhCRihEbhCJIiJrAbdwN59fhspPuvbz6D9bkZJszeMI1mhlzeKMVCn+Gio6CwAvEMUbuaIECHnIhRf41384StQJHR1OAWWxzRVihZN8xGMnOAAUtj9ErVDSwMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dgDNHQnY; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b783d851e6so4853219f8f.0
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019907; x=1755624707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjnVYhq1zyLWWCSIOk8jGgKJqb2cCbKFxf1rvETdLlw=;
        b=dgDNHQnYEtXdi19lYc1md2+5C1BfSQEBGdBCq1MH0+vBE2Wu3YTOHcBZW3T3w1xrMQ
         nyrms9urLS9wpSLuDyDsylLKCeCRUts1mzfRE1OUVhMXJbdWa8sLxhr52KmWYqed8J0u
         IiBRFphagVOJmsNk/0/4FQayS3XtDvVqqLtJF2f+KXsSCFkWRMWNZ0BQEEVqvNFfqWXX
         5I1N8padLq/ItPL0GwI874kUQefJQ1W/U+7h0YyZJDz0nSjeWEvKsEsPuEN70/kZ5OxX
         Db1P1owzpgidl3XYUuzRrlsFfKcmWuGAAPVpRudqKNzoYV8nrdU9xYAaQ74DgSa6wmnx
         BPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019907; x=1755624707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjnVYhq1zyLWWCSIOk8jGgKJqb2cCbKFxf1rvETdLlw=;
        b=fv6G+Udr//p25/xSUtpZPLoXRQsjdQGI3/5ZbDsKZnIcTGpFabpk3YOziXosZ/5DtN
         UygHZIoFO4iXMo4WphPnMDc5Q9Dwph/bvPmPpBNMDoWM8DDYVCOln7YUq09+w7gzSkMp
         EYMZKgqh82wXyjQ9Bc7psHGMaQJtop/oL49ongrNTOIFNhsrbvV/u2t0pwF+WwzQ5Sov
         wGwe6FVhGkcxkM5uEoWIdfo4wnfLH3yIgJxC01UEmAfCT+kltiAt7MZEOEdVhdcTNu5t
         LZbpgMmee/8OHbYjL1Y4zyOGRfCdgF01gJxljV/d3LELCthh75XNo0KlorfupuMfISkB
         1sSg==
X-Forwarded-Encrypted: i=1; AJvYcCUSkeIXa0kRatQvrr6C8cuibowSnVZrZkgV9FpHi92quBO89pzuZRa0wE+D0qdT6n8Yrzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHZWXGqENV83wvpaWLc6VKIQvY4EWwRVaBYHZno4Rh9r7ab+7l
	0LhTHrBgjJCs9jMrpNWDX4v2mIiOWZ3sW32iMmLoE0K5lTHkJ1xOkCtbMU7lJexAO/4=
X-Gm-Gg: ASbGncuJJ1jdh9ReJXHxypCT9C4TsdhrhalqwPRXA+0wmCinWaN6mXssCwwzQkN6nYS
	+5CvkKca8Sp6qkyy3zE9syeRFqbXhU6K/xli29b3w2IN9yOL0pVnOxvl6yNlWrwNLcq6uO2t6Fg
	/ChY81jvovJQtUuesIhKC8cD41P6duqinQvSHlJtt8D0RhhGpe7w06cqMiKEb26em4wzS5mKlcS
	pGW5RBzcHQ0iE4Z9g3sChSKLTqBkUkYGfudtc+dNdOryo3gaaP7l/l//ndmvi4cZ9LIVrk7F2+r
	Ews1CrwsqfMlyJFfhfGj1LMbQoTJPZVSUa9C9BPbl0v3XPmXWQkKBPx3AllWogk3Dd5XGYvPlYb
	VbA7xYkCNyZrTKQWCKpa3Dahb4/PpfHK+YE4gwT1tGOvMgwIQaHjv/o5QSBL7NfZc0L+bWCok
X-Google-Smtp-Source: AGHT+IEtd5L0jW86Ar6WLd6Ww86OMtiv2D5ZzZ1HpTHh6p/p+A+PvclInEfr4XkgVxPeZYGiUKEy/A==
X-Received: by 2002:a05:6000:290b:b0:3b5:f0af:4bb0 with SMTP id ffacd0b85a97d-3b9172649f9mr194931f8f.23.1755019906766;
        Tue, 12 Aug 2025 10:31:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf970sm44724147f8f.25.2025.08.12.10.31.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:31:46 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [RFC PATCH v2 07/10] target/arm: Replace kvm_arm_el2_supported by host_cpu_feature_supported
Date: Tue, 12 Aug 2025 19:31:31 +0200
Message-ID: <20250812173131.86888-3-philmd@linaro.org>
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
check for the EL2 feature support. This will allow to
expand to non-KVM accelerators such HVF.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm_arm.h  | 11 -----------
 hw/arm/virt.c         |  8 +-------
 target/arm/kvm-stub.c |  5 -----
 target/arm/kvm.c      |  6 +++---
 4 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 364578c50d6..7e5755d76b2 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -191,12 +191,6 @@ bool kvm_arm_sve_supported(void);
  */
 bool kvm_arm_mte_supported(void);
 
-/**
- * kvm_arm_el2_supported:
- *
- * Returns true if KVM can enable EL2 and false otherwise.
- */
-bool kvm_arm_el2_supported(void);
 #else
 
 static inline bool kvm_arm_aarch32_supported(void)
@@ -213,11 +207,6 @@ static inline bool kvm_arm_mte_supported(void)
 {
     return false;
 }
-
-static inline bool kvm_arm_el2_supported(void)
-{
-    return false;
-}
 #endif
 
 /**
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index ef6be3660f5..62350f642ef 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2267,13 +2267,7 @@ static void machvirt_init(MachineState *machine)
         exit(1);
     }
 
-    if (vms->virt && kvm_enabled() && !kvm_arm_el2_supported()) {
-        error_report("mach-virt: host kernel KVM does not support providing "
-                     "Virtualization extensions to the guest CPU");
-        exit(1);
-    }
-
-    if (vms->virt && !kvm_enabled() && !tcg_enabled() && !qtest_enabled()) {
+    if (vms->virt && !host_cpu_feature_supported(ARM_FEATURE_EL2)) {
         error_report("mach-virt: %s does not support providing "
                      "Virtualization extensions to the guest CPU",
                      current_accel_name());
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 3beb336416d..35afcc7d6f9 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -42,11 +42,6 @@ bool kvm_arm_mte_supported(void)
     return false;
 }
 
-bool kvm_arm_el2_supported(void)
-{
-    return false;
-}
-
 /*
  * These functions should never actually be called without KVM support.
  */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0aa2680a8e6..53aebd77bf1 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -274,7 +274,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     /*
      * Ask for EL2 if supported.
      */
-    el2_supported = kvm_arm_el2_supported();
+    el2_supported = host_cpu_feature_supported(ARM_FEATURE_EL2);
     if (el2_supported) {
         init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
@@ -1780,7 +1780,7 @@ bool host_cpu_feature_supported(enum arm_features feature)
     case ARM_FEATURE_PMU:
         return kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
     case ARM_FEATURE_EL2:
-        return kvm_arm_el2_supported();
+        return kvm_check_extension(kvm_state, KVM_CAP_ARM_EL2);
     case ARM_FEATURE_EL3:
         return false;
     default:
@@ -1918,7 +1918,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         cpu->kvm_init_features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
                                       1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
     }
-    if (cpu->has_el2 && kvm_arm_el2_supported()) {
+    if (cpu->has_el2 && host_cpu_feature_supported(ARM_FEATURE_EL2)) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
 
-- 
2.49.0


