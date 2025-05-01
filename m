Return-Path: <kvm+bounces-45033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 766E5AA5ACA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5F8D17FB5B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253CF268FF1;
	Thu,  1 May 2025 06:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zUtu0UwK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72B726A1B1
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080637; cv=none; b=mOPVEDLFFsvSePaJjluBPNADPlQ48/vvDrtZSWTUk9NKFnLeFssFq05pb4rInQYD0B7G05BW8SSwkVdZwBqGRXFBC+xYQvNDbiQHig4iuO82O+B0+oY3J8tUEt7PVZrepEGNQL7eY9htUbTjKZXUsO85eqq0R2bIYE1RVlbiiUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080637; c=relaxed/simple;
	bh=Oc5IEnZgSw4YEuJW2NB4Ml/1H3pJIm/ZlDs8NaCnCqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGCMs3HlHxGuEVB+q5GshIb3vEbbgQGKdxRZ2v3nrMxkbRKu1iKKyM5+8hg1fzD6JG78Rl0AwPuhI+RT5mqoq63JoKXc2uthQbsku4O6nfrEkMpI6zu4dz6FPJKfL3ZXbsPct7jxEZoecT58Uj1oMmqHjTNFLtzBIt0w2D9O+dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zUtu0UwK; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso987642b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080635; x=1746685435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=zUtu0UwKVEcFcjCynGJqr/d26U1mDDQnHxcByuUNMMX/8dgI+A1A+NcwQk8rtoEV1p
         cdoUPCPek31wukGqsBGJaTywq6s1YuaxP4a51HamDk8QOUo50F02y6EUibnFiIvac5tP
         yxs+TnZzEqToE8FEoa+oBr8SSOU37dDe2jbrjuP1A9E4KxT9wFUfBLyAkHV9PdLwMSuQ
         BuUtCfx5DYkd1LYF3kCSiLdrXmy3u8OmUmHSWk3Du5KDq6RTtqv0tMEiL1jUewHMDqR8
         HakLi1KcJ924Q7vieAaXVErjd+xjAgZSdmLUVlzft+TFjbtzDr4h3G6/aYm/xemt1OCS
         +Yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080635; x=1746685435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=ZGYdELhdXdeIu0cUo7NFvN5Q1XgcxlpCS/kcGBXrKLLBKsLn1RLsY4cHp5pP9qG/u3
         oYpKw+aixeMVsW/xKTAJS3+FvAxpS+AtyOyKCCsFV9GgJKRQbr3vTd6u18itqmAa8h8p
         9CU3s6MkQrXxYl7OjHcj1fWBl3juKUwHz/AbbLqDaRWWPXhUoLmTPAfg38wYbr2djRnp
         LkHAv0PjpNZhBiKp7sLRUsx3baZYAjoUe96U7PyEG1KpxG+0mtt/eL/IMaguhNdMhVjX
         mT04h3TWbShEb83vFfPyacktNNNuMqqr1OKWr4X5uZjqUseTMVi1/x5FCkSETcpnFOAG
         CDAw==
X-Forwarded-Encrypted: i=1; AJvYcCUm711XI4nStuAP7sMLAj8U0nScPXuouXMzlELKn48P9F2RMJZLDFzHkbVY83r4ugSe3NI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUzF9hDbLVPcjMHlqZSb8DtpKthOsw5dtXlYfgeRAK7kvYECJ4
	nE0+g0WXs5llntwsx92ie0gXZ/zFXKa1aqU7QGDE7YEn9qQZv8yGR8ctWIrveo8EOnplsqTDZHZ
	8
X-Gm-Gg: ASbGncsU3Jr4t6HXn+bUfr/Gw13IwSqBFZJBkoLJ444u396Y9IDaghY7p3Q/KAyBDtH
	kLPBfX2InEWcrwuMSm3Dxh0WRQqn+JOITvzHXCnvBb52caGtj1YzdBd3/LFeniRKxg9CrXVwBtb
	8shqPy8v19IA9T3eJZcUYH+UnISSHs2Knn0dAZmFWcSX4cw64DAliLkm0O8CgkY52mtzAFFSoLW
	LuFMhD3SaW6mdjlk+0zckda2Y90Upj6q29zzGGmEZzVAdkO3vWq+jLoDaSc7UeqdV0ZGnSCUQtm
	wAX3ZmYeQMUFY5I6ivoPN6ol2GJd1eJN8y5wJWGs
X-Google-Smtp-Source: AGHT+IGlMb2qztkg2Rx6pmu/u6ZCoVkAeWR3qrIvj3Q3m9yTRtGqMLCa/e0e8f+/8AZaUvVsWUmoBw==
X-Received: by 2002:a05:6a00:3997:b0:73e:598:7e5b with SMTP id d2e1a72fcca58-7403a75b2a8mr7324415b3a.1.1746080634976;
        Wed, 30 Apr 2025 23:23:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:54 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 04/33] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Wed, 30 Apr 2025 23:23:15 -0700
Message-ID: <20250501062344.2526061-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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


