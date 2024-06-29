Return-Path: <kvm+bounces-20727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8DC91CCCE
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 14:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE41B1F21F60
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 12:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F06D7F487;
	Sat, 29 Jun 2024 12:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="nhbEp9o9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114EC54278
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719665470; cv=none; b=GqjIpQ4LK5IsABOQrUlqT+LaM7Ru9aLQSWALBm8OT4yEkiZv7i400WKfruKPluHJ67OOwtHLKV3CN4VhFMVZivJWROi+HDU+oVE8K0BDD1Pd4zF8gwcsYXQ/i8ikC4YI9SjTgRwIgBNY733EW0NTM5jxvb93oH5yjM35sgp7vvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719665470; c=relaxed/simple;
	bh=ntLWMZMdrDDVCvT8sW7kFT/q9aoNFN+t2v7TiuFBO5c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kvLCx6mmCZlq8K35w/ztkS9yLDQMEYmxqqSOcAfb4qTeDjmTderDV9PlKRDgj8YeCjuQc9diUH6gRRHbI07GiwDESkah5rs88y43c4XilqBjClGf18meovgBeQHjvKim56z41h2U9JtEEloo1L4llxnkwoqAyuZxeInXI5ZROIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=nhbEp9o9; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6c5bcb8e8edso1204955a12.2
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 05:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1719665468; x=1720270268; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLXk3fVoBHrMXW9NOMmJn9sejRtpsd5b8rXX3PkXa4Y=;
        b=nhbEp9o93zYY6pdzN7cVvKaPUea0xOZUm75xx6GK3IQOlaSrM3iCU9zNy1hNJDErUI
         CW7TUs7nbD8V53nedLiztm/UKuYXFUMD6+hkiDWQbXRBSFl9gA/SyT4AYoR/STTfWbbu
         Qz32iXwDcYE5+kvuzKthY/Sm/IINRM6/I2SrnLUOw20S3+vnOyKRHpP3kb6kR4/gIVGg
         FiuQanEmQ8il+0IfRHu2rIaWJlGHgxJjZNXeGEgJvr/j8PHiaRqh2K3+TGnbWLXSWeKS
         6IrJEr1Iao2wqr+f7xEEVh5T/j7Ww0ysnbDsSq3X5R94XMJji3lDqmMc8vW+gMkG5wGt
         PBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719665468; x=1720270268;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLXk3fVoBHrMXW9NOMmJn9sejRtpsd5b8rXX3PkXa4Y=;
        b=no150anWoyPKaOXAFKKnpEU0jiOk9ldeS1h4e/jwaUW122FvGLzLbeuJZQJAShS0dV
         T+BHUSOe0Q7ndDNJorufkE2//c1rqnQy82Et40vhRL8svgTvsAmvfMYHQKNjkGpN5HxS
         1MGk99dO6WoYtdm9F9uDYMshwUb+EeobAPL4SKGJ7WOb55+DZYxDS+9Cr+5G6waRw6RQ
         kb/OlIWliOf4rbQQRgc5ApTaILBtmDQtcWKZzu0CGZrehjlykltLxRJ9NyeS2ZNXx2TW
         veubEoWVHIH0XVTRFl9ryPicrF6PABM/btvVa9mIdzwYYblbRGxtPuo9ZwSvArDF+PpM
         6fPw==
X-Forwarded-Encrypted: i=1; AJvYcCXCqHOmgoTvMiPvbPRVfIsoNtRqhVmDRBeCAmSc86o5+H2eu/C/trxf5AJ3+AbrlPyy1u1/JtxWSHWgtZL1dDtLAGJ1
X-Gm-Message-State: AOJu0YzVeVuMc/Uh2zyatalnd5UMjA/YfvaIclhRQ4zTPSKll19koOft
	n8TqlsfZQttjAFlgBuNNx04o7Ph08ur1ZU1egGBBYjJCfUDUQhSnt2feZvSGm9Q=
X-Google-Smtp-Source: AGHT+IG7G8Ijr8L2HKdiqhp40sGsy6gKftpsugRXAdDH+909J0VbPSV3RAHeQhyAI/SMsNkSSEd/nA==
X-Received: by 2002:a05:6a20:1590:b0:1b5:ae2c:c729 with SMTP id adf61e73a8af0-1bef611bcf7mr1506320637.19.1719665468263;
        Sat, 29 Jun 2024 05:51:08 -0700 (PDT)
Received: from localhost ([157.82.204.135])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fac10c8b3fsm31589815ad.5.2024.06.29.05.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 05:51:08 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 29 Jun 2024 21:50:34 +0900
Subject: [PATCH 3/3] target/arm/kvm: Report PMU unavailability
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240629-pmu-v1-3-7269123b88a4@daynix.com>
References: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
In-Reply-To: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

target/arm/kvm.c checked PMU availability but claimed PMU is
available even if it is not. In fact, Asahi Linux supports KVM but lacks
PMU support. Only advertise PMU availability only when it is really
available.

Fixes: dc40d45ebd8e ("target/arm/kvm: Move kvm_arm_get_host_cpu_features and unexport")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7cf5cf31dec4..6bb72c09be10 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -280,6 +280,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     if (kvm_arm_pmu_supported()) {
         init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
         pmu_supported = true;
+        features |= 1ULL << ARM_FEATURE_PMU;
     }
 
     if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
@@ -448,7 +449,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     features |= 1ULL << ARM_FEATURE_V8;
     features |= 1ULL << ARM_FEATURE_NEON;
     features |= 1ULL << ARM_FEATURE_AARCH64;
-    features |= 1ULL << ARM_FEATURE_PMU;
     features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
 
     ahcf->features = features;

-- 
2.45.2


