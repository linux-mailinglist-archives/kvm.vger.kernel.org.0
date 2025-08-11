Return-Path: <kvm+bounces-54426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D16F7B212D3
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CAB6420407
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DED2D372A;
	Mon, 11 Aug 2025 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HPtOHMnW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACFC2C21F8
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932020; cv=none; b=SrTEsjyEKpNREzmi76PnUaCxgiZcEiDYdmrJYJV9IAIf5sBRJTuzMFE7OshmNdF1VeCQACUllmOsBML32jPMy9an7kaQpL+S8VC9KOIIlhUTSlyUg9s+eAtQIf+hQBr0SibdROeAXQla+dmuqkhGbWH23ieagCk4vv01sYT+sjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932020; c=relaxed/simple;
	bh=8ugITbRZEiHMCfxQDeQG1K4GsU8ExzFfq2Qkxkdvv2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkIoVmvt3sDy4Y7Ck0kkXGCBAZqsAnjybpPGJQE7RU5E+GDrIBQNNaHTLUtbTHIDuGLB6fKJSfmURwGgMJMHTsVYBGQ5muIqT0rxqChc95sIPftzvo+dgO/Pn2CPRUt6R/dvv9EtR2GPIcuc+3kVMkf7mTBgdQgiDx/rJQrhPbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HPtOHMnW; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-458aee6e86aso30620065e9.3
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932017; x=1755536817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTxLOjP4FhmiKvW9Jt5SVA/50ytmZzwnIVFBfjDcbbg=;
        b=HPtOHMnWSZbZiT45RI3pUhI3WQCYUVG+mF/v/MT1S6NT1hKa3qvLNqKGyjkz2QgpmU
         TMbAX5fu/aaSAQrpBKT+b760JMgL2P3YZkJB2mT2KTihstySBLpiMGpJMn+VTQ02rARa
         ltUgtcuWsqG3LHMuvsfQGmrN/Pecu5in5HHtx8yYBscS16xTrY1ocOgEwMt16kowL8jf
         djpmiED2xaWNKwqsPBCq53b2JLG5RXFScGyuX0iu5G6bmxbTSc5vWhIixwZkv43cY4Rx
         aZ27qW8zk67e9ECfF0FgR+11N9tzUlmZ1/5968UPd2smPRMxKIVO0vu5v4FC9jGyDtKY
         jBWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932017; x=1755536817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tTxLOjP4FhmiKvW9Jt5SVA/50ytmZzwnIVFBfjDcbbg=;
        b=b0w1YDHqaC+MrtgBPOJzbYsKUlaPJqyYn4syWGhvcdclc63hj1ALl45HjKhAf7hZRE
         wCv30kfEDzLQ1UbuQ+8/SqxLGNiQLhK4RfzylfJq4lMVp4JOcl6jKZP/0uM0mwTMZ7v3
         07o5c+lByBKuPDsnxSVESLrd6XPj3cEei3jXDoRZyRCgeLDresU28ZZlL3X0EmoShq9D
         njqkkjbraSzIRGwvohNDfg27yCs0KjOVTMiMrUe+nnxh9Uj6z00Wz3eu8RxqLD5fRbw6
         YRTXZZpXW8m2t+ZC4eHidkXTPnEohVdA9Pt02NrYr8zLFxbyKRSZ2MKbTzVZHIk+29RA
         cO9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSu5tUh3xiTCsx6HnBwK4S4VkczLM1HvySdqel12SPqum8AGZEK/PM/DNc1RxeEHxwfXE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9OLGXzVFSp679iXJomQfIpgBe/bd4zq7KFZXiD3Jf5DCvv++P
	ROjAa4wiaVYsg1HgNqokPlkA6zfjCqGsJjpe/dnKm1Hjp89BpMXrYvAjKchYy3jfmbI=
X-Gm-Gg: ASbGnctI9vzvPyQ3N5/zkowr6RzEZvoLICwKySuUKaccWx1jIpjXwVxzFv7ORYq8XYN
	OBvSRRSVhefS52wDrA8n8QXizgf2drBUg8M5g7PAuPgwfEhLn964Wc2hgTHB3b1wgNSD8pVGpNg
	3kBvZC8MoQDJgMB2dV6me9jf5roXOuj5HNXKzsnouYMztzu5jrDrhQPw+pQV3cPMo5cJ2jqe+dd
	DYV3cj72loqU6r4JKreFjKJy46tGr4MtjsMDDasyMDD9oXeD7Pgk+Qn7x2EiRIeWvwCyW7eD6mi
	1gAnOAiwN9Wksi57Sggj+MUnoX+CYZ+XN4pwgv/sT5iaMMkY8KREdW19MnSIR6nKyM47utYCB7Y
	OjYsjAVGyrocPy4MO4u2+EiTbl1lMx3OPtUk39PuGW3L9tiAYKEXV02ZnAaZOPiyB18xi/Rg+x5
	FznLpsREo=
X-Google-Smtp-Source: AGHT+IEMcG/Ev4eyU/L7hIS6KC5DMgPfd5GRoRtRkLPDfgT0WRaP7S9VSCoMBvoitgce/yrC+B3d3w==
X-Received: by 2002:a05:600c:470c:b0:459:d709:e5cf with SMTP id 5b1f17b1804b1-45a10bad987mr5229185e9.3.1754932017284;
        Mon, 11 Aug 2025 10:06:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5887b7fsm261545415e9.30.2025.08.11.10.06.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:56 -0700 (PDT)
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
Subject: [RFC PATCH 08/11] target/arm: Replace kvm_arm_el2_supported by host_cpu_feature_supported
Date: Mon, 11 Aug 2025 19:06:08 +0200
Message-ID: <20250811170611.37482-9-philmd@linaro.org>
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
index ef6be3660f5..c2f71ecbfa7 100644
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
+    if (vms->virt && !host_cpu_feature_supported(ARM_FEATURE_EL2, true)) {
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
index 0fe0f89f931..a9f05bfa7ea 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -274,7 +274,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     /*
      * Ask for EL2 if supported.
      */
-    el2_supported = kvm_arm_el2_supported();
+    el2_supported = host_cpu_feature_supported(ARM_FEATURE_EL2, false);
     if (el2_supported) {
         init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
@@ -1780,7 +1780,7 @@ bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate
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
+    if (cpu->has_el2 && host_cpu_feature_supported(ARM_FEATURE_EL2, false)) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
 
-- 
2.49.0


