Return-Path: <kvm+bounces-45770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B25AAEF5B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 892D67BCCDA
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35AC291882;
	Wed,  7 May 2025 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cmq/zD44"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830BD290DAE
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661369; cv=none; b=ItPNs+xgMMEd5AG1GxkTGctA+FvrIZzD3oHoIwXP2TtEFpSDkdnIhVdJ1K6N3X6CeqQXsDQB2YpBQQQnREPAdTuTFrMVPOpE36LEbc4SmW2WDoNMmA7oWRWTtkqdospJCLzLZSiWUu1VBPTr91xbrr2z5dEmfrEko7uh7He/nZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661369; c=relaxed/simple;
	bh=NskDloI8lQLWqdat3b/r2FM0lGH7R5XUaz3l17L+3UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlfjlzOzkknMa+Zi8S1dv/jejiq/92ypYqCoyMQjGakbRFDuWkZ3vebzglm1ZtBl3ClSIUi4Iy6Rlxe4AU0wrji1s+Fuc4vHwdsR3wTdyvu3wv6cofLZ/95cYafLjmfnCywQio1qyMiXEosnOXSbc5NK5E9Jb2ssoBGZI9+Dhzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cmq/zD44; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22e45088d6eso6687405ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661367; x=1747266167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AlvH8T2wxvPoUN2cgh0nAAaoM8ETcHqqaWl8h2qra8=;
        b=cmq/zD442SW4A7SY3enQ3RJuuWwTRK9reB11/XgkZjFm7iH425vNGHNVQ9UL3aGf6q
         D/7kheDHF+F/tY3e9bCrlguTiluNmJpUs30HZX22N0A3W+x+gGo25u4G4iMzwwPAKv7s
         pMs7j89EaTjEEtbKV4YOAZX5FZocvRjrKtNewLFvdldktpg+Nb7Z7+mAO/6E2nqMRXEY
         Q9PhlTVipYoIjeAYwTB2cn9V1QYBCTG9Jqd7V+YqisnGuvVw4GH0RtFCqIottVN9nhkl
         5t2JOTnJxPBc3s/VGfTjk/253571EShqT1Iiz7Xy0Z9tQFw473achGI/UEjVJxkucHuP
         fDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661367; x=1747266167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8AlvH8T2wxvPoUN2cgh0nAAaoM8ETcHqqaWl8h2qra8=;
        b=wImQzBkOA7ADi9QRzfV2b9WxWOidQuLLR3VCBLpBVSLNl8J1lkvEPYm+wlBlFDiGRq
         2cgqMfJOAp24pu8Z8kOmGA+GZUksBDjO7jyO9L0LJXjgBJXtxTvajZ0RpoXOh0Z7QIks
         W4NxLd8X7YfbbA6dhlJ5OZ2iGUaUMa663fZA+7onKcEYBFlhhVTyEG5jcHjGwcY76ygC
         nhTRe7XZ8Vz84n2j7922irAF/ZXJP18RGSJvr7B3KULg4VMFdmIwHgyGbxACz2L8beVx
         MyP24qIVakUR7qnQZt27XCyY3ZdRybS5nWfEIoHB94xKWYFcCbFG7ZsmBcHEDPnfWwHq
         CC9w==
X-Forwarded-Encrypted: i=1; AJvYcCUM8SAGG44JpWxx+0g4HqhdcuVlRAHcctXuyauz97opEpyJ3Tol/N2fiEwYLY9X3oYKc4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsILRriCtRNkJBMEfPWPU95Qm1ZTej+kDmlt+t4/npUduqURA8
	mlPWg6zz/DyAiYUz9jGgl2F7TZWAYxI56VLJg0+W9R9cv/F0jo0zyrbSMZNm91sO+R+cFIMoj1/
	ROlLxvQ==
X-Gm-Gg: ASbGncvZOY6dHmzvSPyhIJbUvOZ58CmljpB8ypmthjztTSSICJeGLXCLax6vEV2a129
	trnTJw6iluLadgOVT4PIfr9Cey256P8EnneqHypSTqhiKqVAFlhL8uPQYCyxHry4IL1pcXlAoiP
	46bSkxjCFHYiw8zQoVp8GQ2e3wGjaGPJbK7gbBGJMbk3dv7NwwzVt7Ld0MPUrz5aBfnui8+VxMv
	BPeoWOIJZk53EaVil26o7SU1gN6kPuzUegN285MlKrRiu32cYfynTwfzSLYsBDgM63PMWNP3XHm
	CnBfzuGl7ueTkVemnimEuK+Ex928UFrNKFkDWkrH
X-Google-Smtp-Source: AGHT+IHc9BLJTRra4Ml/NypvQQD2sL46NjWq+atgO/ogg8mn3XracQtlR5Z2GwyWMF3jG2uboLtq3g==
X-Received: by 2002:a17:902:cad3:b0:22e:7c70:ed12 with SMTP id d9443c01a7336-22e7c70ee50mr26992465ad.48.1746661366936;
        Wed, 07 May 2025 16:42:46 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 04/49] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Wed,  7 May 2025 16:41:55 -0700
Message-ID: <20250507234241.957746-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a forward decl for struct kvm_vcpu_init to avoid pulling all kvm
headers.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h  | 83 +------------------------------------------
 target/arm/kvm-stub.c | 77 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 82 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 5f17fc2f3d5..5bf5d56648f 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -94,7 +94,7 @@ void kvm_arm_cpu_post_load(ARMCPU *cpu);
  */
 void kvm_arm_reset_vcpu(ARMCPU *cpu);
 
-#ifdef CONFIG_KVM
+struct kvm_vcpu_init;
 /**
  * kvm_arm_create_scratch_host_vcpu:
  * @fdarray: filled in with kvmfd, vmfd, cpufd file descriptors in that order
@@ -216,85 +216,4 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
 void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
-#else
-
-/*
- * It's safe to call these functions without KVM support.
- * They should either do nothing or return "not supported".
- */
-static inline bool kvm_arm_aarch32_supported(void)
-{
-    return false;
-}
-
-static inline bool kvm_arm_pmu_supported(void)
-{
-    return false;
-}
-
-static inline bool kvm_arm_sve_supported(void)
-{
-    return false;
-}
-
-static inline bool kvm_arm_mte_supported(void)
-{
-    return false;
-}
-
-/*
- * These functions should never actually be called without KVM support.
- */
-static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
-{
-    g_assert_not_reached();
-}
-
-static inline void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
-{
-    g_assert_not_reached();
-}
-
-static inline int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
-{
-    g_assert_not_reached();
-}
-
-static inline int kvm_arm_vgic_probe(void)
-{
-    g_assert_not_reached();
-}
-
-static inline void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
-{
-    g_assert_not_reached();
-}
-
-static inline void kvm_arm_pmu_init(ARMCPU *cpu)
-{
-    g_assert_not_reached();
-}
-
-static inline void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
-{
-    g_assert_not_reached();
-}
-
-static inline void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp)
-{
-    g_assert_not_reached();
-}
-
-static inline uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu)
-{
-    g_assert_not_reached();
-}
-
-static inline void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 #endif
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 965a486b320..2b73d0598c1 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -22,3 +22,80 @@ bool write_list_to_kvmstate(ARMCPU *cpu, int level)
 {
     g_assert_not_reached();
 }
+
+/*
+ * It's safe to call these functions without KVM support.
+ * They should either do nothing or return "not supported".
+ */
+bool kvm_arm_aarch32_supported(void)
+{
+    return false;
+}
+
+bool kvm_arm_pmu_supported(void)
+{
+    return false;
+}
+
+bool kvm_arm_sve_supported(void)
+{
+    return false;
+}
+
+bool kvm_arm_mte_supported(void)
+{
+    return false;
+}
+
+/*
+ * These functions should never actually be called without KVM support.
+ */
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
+{
+    g_assert_not_reached();
+}
+
+int kvm_arm_vgic_probe(void)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_pmu_init(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


