Return-Path: <kvm+bounces-45352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3ABAA8AB3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 634443A5F58
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97901A3142;
	Mon,  5 May 2025 01:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G05JYN4V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568D019DF9A
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409955; cv=none; b=efH+nt0Adp9lCWBlyJk/23UY1VKBrCMsNMQTWs4ax5baqrkxY3A5u6sladRAIiRrW2UlUHKF6C1BSr+DHqUGT2TzEhHJOkopYPNyLDBYjvRgGtrZuKS+FilkLa8htp+9GTiIaa32cecVozZiSaFGw7xW1XalmRjXKf18pKWU7B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409955; c=relaxed/simple;
	bh=Oc5IEnZgSw4YEuJW2NB4Ml/1H3pJIm/ZlDs8NaCnCqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq9WZmolw18TXqxANw+hYSrWSp9Xs9knAHeKVzcORJYSoItUH88f3TvCvxF/oZvqHEXGs0kmYYhy9oYbFg264Rnr3Vjz1sVetN7OwRzVZOpdhIz+kYbXbRfPhDJLD/VgLE2LG9a73kUmTxHo0N360exOcmGUzqD7pJhtnsx5Epg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G05JYN4V; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-afc857702d1so3830165a12.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409952; x=1747014752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=G05JYN4Vi04PJhwDfhCMI+JnoUCioClM3ZsPqY0h1NeVgo2eqXe6wMjdgjOfFkrX+Y
         Vj6rZbGY4zsywnhvMW79oWlBTZcHGhT8lMEpiaVQfiuN83Fm+bDigCEim+SQdjuldoBi
         aeLvZSHJnsxD/eR+i+QuR6RsbXsTbYSLXES6R29pYx1mT+RqRpeGedb89xZWxzU5ujFL
         9E8Dq3X14EkfB1vWsV4MFfAPUZJ5HFC0zDRf4Ft5FPu/+cv18M7zBb4PC5YMErlTVZyX
         7sdTIRoSdo5EmoS4se/CAUGIJ8yhN0DZBN2W5bR/IHBmH3gxRNTRE/NhCapyU82Wrov3
         itkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409952; x=1747014752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=UyetBMGY176xz6RSpBIT2XwWcJQDkUjX9oJXLrIqEsBKSJtTbTtyiagS4yp59kNjf2
         2DTfGMP2Y9XQWOHYkoE73ifjUitjzWg061Cwm8ZPKKnhvLnom5BVWovHLZ+2AkidpST0
         ULh6XfVnb0AO2EotzzaO85R1uIntFUG2gk5Gfga5rP8dxebBkJruM+PKtqoSI9QzMW9q
         UnYnu6FO7s3LKnGWPJ4VLsD7E+k5qW8q73vDHABlqO7y87Pd6EoCtBEj/fQ9wYOw4w0d
         KwrqK1VkGfB7I57cHA6PUUpD8+p/hHn9YoeMjqfhGBtdlf4TmVn4lXJ547Uxm5UA5r0H
         CRsw==
X-Forwarded-Encrypted: i=1; AJvYcCVMalIIEpogCZR3OSueZa+xZPwJELEF6S1K8b8QF1UEqDIRxtMTEZdnW/DcGbbxQFxgEw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbXo6W+/D+TepBwj4F3834f8sOkkFktDeg5ZzLXFCYVwQzK0Dz
	cunmKht74JO2YVRFQIH0i3/TTxkHHEqTpVT3CmzYRDntInJ5u7lDMVpCUQXwP5M=
X-Gm-Gg: ASbGncuwrfoACbdhcxFbjYaWmmJU48BoIB3SAPHfd0UK1Bl5q7KXT0RVsNHwAqDvp4m
	Ah1jOOVe5XQ7Yv6ixTH6aM7iuUlVKrl6kGl+MnvxSiGhJxtyICMH9cCHs8vNsX5yjuniwyFlaR+
	MduD8eII4TGex/oSiqhJ64FsfYUpxJoCSq3KzWcW3D2B57iu6gKnLiV0GlSqVTQEYIZJumlXS5r
	NMHNYTkK92jcyFlt33+DKJww1raiuMoXKQq+BfGB1LlUeGIM3ky54OfPz1OdxNQm8MyRDEzMC9f
	sfvS1lkRPfgCiXtWV8iI0FLRXm0DlrSvFcFVZy9BNAS7pwEsP6s=
X-Google-Smtp-Source: AGHT+IFjAqwjw9q6AkboaE4/rlYL10/n/Iij4eqi9L1FrrgnixCKqfek0vtCsT6Ha/m7WQ/8koBzRg==
X-Received: by 2002:a05:6a20:9f4a:b0:1f5:80eb:8481 with SMTP id adf61e73a8af0-20e06436606mr10495461637.13.1746409952595;
        Sun, 04 May 2025 18:52:32 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:31 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 05/48] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Sun,  4 May 2025 18:51:40 -0700
Message-ID: <20250505015223.3895275-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


