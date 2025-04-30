Return-Path: <kvm+bounces-44925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 693B5AA4F44
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 075061C00497
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0A61BEF6D;
	Wed, 30 Apr 2025 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BAZ7AK+v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D851E501C
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025136; cv=none; b=hgs8UGlzS16CBfA9FyT31wd4s7xBdTqjxC8RDbw+pbLGhYmn7c9ph+Qdo7GStPAPVPhtv/ohvSFfruSRgC95ca1UohFnI8859gL+tGfHjVNbPTCyuGQPfjLmULtQR52H4sKUd0kpbCyRofBvOTJAEQpAGvWsAsvsEob4GqXeKE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025136; c=relaxed/simple;
	bh=jrCB9NK32l+gQEAb1vM8Z1sqVslhLbCoMdXtVDmRPnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnVx0gEB0lGxueWAcRU3a2Ob9pCmL04mQY2kEL50CAEJvKXizEmkxZP/SYQk7Le24KNHMYRxRKd8/cnPduqjAJZtM5mYWBXAuI8Q4/A1cm0s4wZzYDLcqF6bqYV8oNvNWW3UqpDLySpPdRcIgwmZgHunh/+ypmZac6tjf1hgcGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BAZ7AK+v; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3014678689aso6264a91.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025134; x=1746629934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgiqh7bhRD5cMq/BEBKsGo2haYh+WuQTB6qucvXC4NY=;
        b=BAZ7AK+vJXgRA8hVtoh5774haPgYBvV1ZnfHaY9qQ/ZizRNg2Pvvijd+pKfaxVhCpq
         ShkCG4uRG0Et1EN7TvXjhcAj8J1kuxsinFeat+pVNVwy4LkNC5FXUNOCUMVLFeZetTkz
         hSDvs2CscfydjYeJ+fVgbjOZRHDo6OIwIDED7X3NstIgsvEWFTfLuoAwtgLesqdoFQWr
         WIVWPsq1VjE7bc5lprjzBDod06kvFQ74HHXtBx5nmSdNfbFALSsc/cPfFGalrRr708yY
         Ufvd1EtNyuHNtdzv+xZx3H3FSijvy3Ud1J/9dRA/4ubL/p/NTcmlZDT80zRdfPCfqTnf
         ztiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025134; x=1746629934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgiqh7bhRD5cMq/BEBKsGo2haYh+WuQTB6qucvXC4NY=;
        b=rFuS4qteJlDwj3meBN3REoJs4ZkBYzDXSuZsEeHgC6X+gLQzbltDXHZoz8SbniuDhM
         8gJzmkKiDoaIYTe5SEk+Ibsa8MnbU5aEyKaBS2luQs/ZlSF/43zPuSg/TM0mrnzxUEnN
         XuBGUQ/yT940VwkxUlwsMAtjZFbt+fpbKXh7qEThv2lFMnBBoCX7038II4jFoMW/D6k8
         F2BMDQynWAaZXw1DMcM6G9wjMCVDUZ/6t4CGbrkzkIVH2hfz6n5GVAXVK3ei5Y9OIhmD
         lDoyV0J5hTcYmVteqD73f1l4dL1eRBxcBiHp/F95MLhAv/LoHPhEY93vuXYVgbZey28W
         CRPg==
X-Forwarded-Encrypted: i=1; AJvYcCU2+UrIJf7bmjAE3IWLqaVfLtRE6s5LyDE99ECyqHqG3xnZL8DyPoVNruf5gJ4LSvfun8I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUFO2FEBYGT+lPKyoz3BjR9WTtpF0HdW2LYw8xT1u2KWORTb+j
	3cZcrNPNTNmp51P0zmcyGnecm8Dr0U4428sJ7AOdAWPWfXsbZtKAMoDw9MVZzLo=
X-Gm-Gg: ASbGncvMZwU/WbJGoPviZQeGn7JlDpuGT7fgLO42SJUfC8T/zpBPVeZUDdFRtYUy2fs
	sNlXSq4nTxwRNym9Xx5p2CBMsXDD4XX74Mt8Y4eSmajYl5QOHOCKaUIQlWRdtOJeORBQIX9/jEn
	JVNhu33rm/o5HYGGhE6GMlf+8PedZrG/kSKVDOPIQQHnjO7aBTvm4tIvh/U9J0dmCFCzbIw0Dog
	2ikAF3Zzw+97Dw3BFMedafsPwnzX3I8OuOa9YpBZpT5kQHk4qymetBfjj+fFgdqEwFEqsynYYKe
	+AThIYYKQEToz55hzU/lgHQAYozXCHRJBgWnn1z5
X-Google-Smtp-Source: AGHT+IFieDyuyjj+C4di99eeA1PGTo0L9NwfDDFPvRC1/0a/H5Z1PDo/6bzUYYe3zw+0C9wzY3sxBg==
X-Received: by 2002:a17:90b:514c:b0:309:fffd:c15a with SMTP id 98e67ed59e1d1-30a343ecc28mr4110169a91.13.1746025134157;
        Wed, 30 Apr 2025 07:58:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:53 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 04/12] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Wed, 30 Apr 2025 07:58:29 -0700
Message-ID: <20250430145838.1790471-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a forward decl for struct kvm_vcpu_init to avoid pulling all kvm
headers.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h  | 83 +------------------------------------------
 target/arm/kvm-stub.c | 77 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 82 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 05c3de8cd46..7b9c7c4a148 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -94,7 +94,7 @@ void kvm_arm_cpu_post_load(ARMCPU *cpu);
  */
 void kvm_arm_reset_vcpu(ARMCPU *cpu);
 
-#ifdef CONFIG_KVM
+struct kvm_vcpu_init;
 /**
  * kvm_arm_create_scratch_host_vcpu:
  * @cpus_to_try: array of QEMU_KVM_ARM_TARGET_* values (terminated with
@@ -221,85 +221,4 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
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


