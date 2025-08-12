Return-Path: <kvm+bounces-54534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E904DB22F17
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A49AE6249FE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EE72FA0FD;
	Tue, 12 Aug 2025 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qZk1cDZK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03E1DE2D7
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019900; cv=none; b=vCUbN6kNgrvCcDFuZcwdpt8/nIxCASvg3olLMiQWO4B6r3U9uYL9TAhwtOs8vm1y3tfzbecI+6Pd6kGUwI4Sx6KtIF50V8OracqhFyUkBvoq3aMXs3HglL3B6K4mfGcbutI/Lkn8NzqaVYBqeL+0AUT8jhE+jlh0jIznpWILKhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019900; c=relaxed/simple;
	bh=HFvxAgwcp5mtD5aOQO/FgFG6xWpsq2ZrXVJ1V5LQJUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TULnKRhJkOgm609SLWwDwI2YC86kY8DiKWlNQ4mSZ4ArQ/Aj2eIIRi0235LU3ageyJGE2KMYcrk7IAdsAuCggD8J/9wi1Bj2CU9pq0ixTEBLIS15JRnkhfTNYbW1I1dbn7LB++sthag5CCvLhB91ftfh3PGflhkCQGS50YXPKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qZk1cDZK; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-459e20ec1d9so56102565e9.3
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019897; x=1755624697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGIZJncm597lQ1UHTGlOf0gdA0nz+VRBE4mDNz581R8=;
        b=qZk1cDZK3zTGcDw90wgCaFbExZdLTRo4gywBDYTgw1EzNjraYyrW1Gj7C1m3iycTVY
         OxaPxLJ4T0FlRLjjpa53hpRqPoDPBufBaMxC7H+YPk4fq6ivgISWkcAY8BI0WIK/QMWB
         hYisDiK74RS/MVxVYKduftr95DZkuCyDMHQiJCCF4iONkvASs0pyAWF6M9QwOt0P+cPr
         IFKkdwvJKQarXHioi53EyVDiPOztAja2NzFUba09lTaXj69muX124HVay+lTJvbPEmG0
         FAunsoFl5r7Y4YYR0I1wm9r3vjERp3vTDUcxlnHAjOsZ5YI5vi+rLKIZ/3NBaTWLWW5t
         CC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019897; x=1755624697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGIZJncm597lQ1UHTGlOf0gdA0nz+VRBE4mDNz581R8=;
        b=JD0Q5GKRqXa5iDlpQ/Qc8OPufKmW2Vq06oMTUgLlTibstbAzm8JlBSv61+FjW0jtHt
         4F9axIXl/25+/A0j0SnqqG1VUMFdOJWvJ0pHgBPEBDvrBBYwwTOTMrWCufl8l+G04mNC
         cOhVX70FpgrHiySGsqd5rjYuE/Kbfgr9i4Hsfj5sHbh6ErvI2rWF0nS7JFEVU83oFrfp
         hYShPXfbi3roYwmYvpR+FB6x/U1Ay42Iv/tYbKAE/3F+gXNW2nK6OzfABGwvRru7L6Il
         8t2DoyKami/AEz9/puoBnm7hZxyvcKDoq/T19m8TMAmA53u11YRw/3L339PQkQiSjxVe
         Zidg==
X-Forwarded-Encrypted: i=1; AJvYcCVZhz6iVj62vOr8LcMrLEMCcCLN5S7uToarZ0gqgxdPatIXFRMPX0dp9W3HolG0lXAJNyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNC0WhbinyOHc5uRnvucw/iulzH5S79jekVeo5CDdsAFbOniuS
	PoxjIrOXYvY+ELO3mA2j7WRCd1dAM5IZ9I75zyAhs527yTZJIHMw4gxr17R2XifMn2M=
X-Gm-Gg: ASbGnctb+HUhdFeIRqYEH3RGaHmiOxNg5yv+EYYWix/l4O1Z7UljvjQb6C5HfQIZITd
	zI0vHxbhq9Zc9u3dPAcxe/QdfcJw3vkSJK21MouN4FSmbkOdJskm5eMzkIyTKSw3z/9mfDNTkLv
	JBkzk0/hpGoxHE9NKL0TzfT/I+UYuY0L4g8V5s9q3JFhxwaxN5r0MQIMwXSKVV7tL2H1akwjGmC
	8puNg6x73uF4fEF5ybuInGJc7gs1LCHwt0Qlos41TsT2XgBQFR/R3W/M64zBFNTLKs9Dkap+fM0
	O9gWZcgBt7iVmA4b174cjrPJvhXQNfR5TxrAbqB/mPOnfJCvCBqUcpYPQ5dM/sufmQrcDYqA1tf
	CJCiec9X3hFwh78Utp3SQ/86Ue/0rEg9+4zKntv9IY+ncsYVelYZQcqtWfm+YfPiMBqMgIjah
X-Google-Smtp-Source: AGHT+IGEtHAmytFVhll3Er2XT0W8VFQFfgTL33dO4ePx6UWWR29T0NixVEQVlSdAz1cpzX+OtO9DqQ==
X-Received: by 2002:a05:600c:3b97:b0:459:e165:2661 with SMTP id 5b1f17b1804b1-45a1660b14dmr25675e9.23.1755019897070;
        Tue, 12 Aug 2025 10:31:37 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dc900606sm370219985e9.15.2025.08.12.10.31.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:31:36 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexander Graf <agraf@csgraf.de>,
	Mads Ynddal <mads@ynddal.dk>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [RFC PATCH v2 05/10] target/arm: Introduce host_cpu_feature_supported()
Date: Tue, 12 Aug 2025 19:31:29 +0200
Message-ID: <20250812173131.86888-1-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250812172823.86329-1-philmd@linaro.org>
References: <20250812172823.86329-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Introduce host_cpu_feature_supported() helper, returning
whether a ARM feature is supported by host hardware.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/internals.h |  8 ++++++++
 target/arm/hvf/hvf.c   | 20 ++++++++++++++++++++
 target/arm/kvm.c       | 22 ++++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index 1b3d0244fd6..1742dd88443 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1612,6 +1612,14 @@ bool pmsav8_mpu_lookup(CPUARMState *env, uint32_t address,
 
 void arm_log_exception(CPUState *cs);
 
+/**
+ * host_cpu_feature_supported:
+ * @feature: Feature to test for support
+ *
+ * Returns: whether @feature is supported by hardware accelerator or emulator
+ */
+bool host_cpu_feature_supported(enum arm_features feature);
+
 #endif /* !CONFIG_USER_ONLY */
 
 /*
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 48e86e62945..05fbd8f7fc9 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -547,6 +547,26 @@ static struct hvf_sreg_match hvf_sreg_match[] = {
     { HV_SYS_REG_SP_EL1, HVF_SYSREG(4, 1, 3, 4, 0) },
 };
 
+bool host_cpu_feature_supported(enum arm_features feature)
+{
+    if (!hvf_enabled()) {
+        return false;
+    }
+    switch (feature) {
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
 int hvf_get_registers(CPUState *cpu)
 {
     ARMCPU *arm_cpu = ARM_CPU(cpu);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 66723448554..93da9d67806 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1771,6 +1771,28 @@ void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp)
     }
 }
 
+bool host_cpu_feature_supported(enum arm_features feature)
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


