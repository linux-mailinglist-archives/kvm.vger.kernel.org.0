Return-Path: <kvm+bounces-45489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B639AAAD11
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B9437B3822
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEF23E718A;
	Mon,  5 May 2025 23:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gJAvuXQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79C63B0A19
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487228; cv=none; b=lCzZ9vAUPzndzPj7+UZLh3gwMEZ7lheF9WOYEab9aKxcIpVMHzqfzlZ70mMjdiJS5L4yE/okZiZBS5CDkDbGTYpfsUw1//vpT5h0tS/e2cTiaTgm4CRrGQnmc4LPxePGuep+6jwiXCUfoP06t1NHi4FMfA8q85uTUAkWNxoPbWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487228; c=relaxed/simple;
	bh=Oc5IEnZgSw4YEuJW2NB4Ml/1H3pJIm/ZlDs8NaCnCqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohhuFGLt2+0R+jN5J36UcX7TmxyBdA+3XuO9M6lxsW02Luia3pkYjtWrXajhRbBFuDAAHmyGzBDIcbbns2OA28cLnDZJl6JWu86ddfuVJ3l9r1k+fb7zpjhxGdLQY6OljvrrslVAp9AhnCWCjg64xuimWnB/ZnOrEzI5u671lzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gJAvuXQ0; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22c33e5013aso53522955ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487225; x=1747092025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=gJAvuXQ08t+bnBCYMWUG0gxW1f5UFSXQDU/55Jw1c90nDDl6HukCZbgUJZ9LRDScch
         SW0EomzG2GNDp9VDch4if8XzeAEvivQmyhi6f7KeBksYTvOf4wOFiYEfMzhvZaiDvPh3
         tZ5/qO/L+6Du2gw8X1fkyb6EEV2607tDi7QlyIf1Gpt520KHEQKbPcYbN/YBaO8jK1b1
         rTaF86srV8La2PnMqVuHrLyzMvlqXoS1nLySNKdR1QrktVlQQlTcGhIviYoMkjCXjdPh
         iX7lxI4fbyEVYht4Dj7VGHxFmYxRoipUB/z5i9vvDXgYuLxNfbLfWpWqApwVZT2OvIu4
         2g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487225; x=1747092025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=hhK5xFluJKpDm/uDLrqYm6ir/LuN/1PbQafNaxNFNEoSYDihnjdZPbIFY6DK5zUahk
         qCGH868mF3En4m/WM7crnCSW5UNQxaBHjqdLFmUfzjhe90/a6KLH+L9dG/Q+3LD3demI
         VkOjgjhjLAaaVL/sS0iytSWZNIj4VIpE+SH+bfvs/cDv6PyLqz/PUyzt90fyLbu5ENeV
         PvfsV4SKBxzu5pGPCNx1lg8zgpu3IBqyTxBff+yG+G/IOowCNJyvMgkjQeJDTSBSYomK
         YwKDLupgow2nvILkc9zrNJ8Tmd1HRTrwHaR/oD3VJQYsXKqeocx9FuH/whVc8OaQIVAA
         BQ8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtBygBOANG116KAijIekkG+f9KnFRntGm6D7ok60pdk8htYKnmSCa2rJBQ661wacPhtNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZXcAU3FG1GmnsyJbuNxr4Z4bnXixwsXrrerEEmUlIHrmcPnaR
	5RzWFp1dKCQm9eWHieHOt1tK8wnTo11eiVpSz3w18hpNzAlxz8JElTo1RxcJ698=
X-Gm-Gg: ASbGncsxTIXplmXn6mZGg9zSddQPyDcfdAj8L2dVBQaG1/u00OHRRnvSCqWpbg9iE8F
	IUxQsgVCS8Fmirg6305abpX/QsfPxqWi2B8Bd4Mh3wiILz/A0EHiZ14AB5DyitEMQM1wbn8pn+b
	tFEzZuupJHqxfmv8KclUf5vorMrYyEZ9VCsehNPLyf9ATtn2TmXWV2MeG8dqxvEq18VuoDW7Hfz
	oX5ckSZvqOFSjivcrXYpN0hTahvAncSuZAT5uMQ6A+5vLv6s3bmdtDIOYkRImfU9zq2TRUo7Duo
	/q12L5W0U5cQuXdAEDAxkVdlLJVpRjAxXwatSP6o
X-Google-Smtp-Source: AGHT+IEppQ78GCWxvrp1Kg3rIqo0UbIgXB98fJRAHTjCpcIyipY13SYl5qyGbdie65ZUaGKZqlqcrA==
X-Received: by 2002:a17:902:ef07:b0:223:fdac:2e4 with SMTP id d9443c01a7336-22e1ea1f373mr137466205ad.1.1746487225057;
        Mon, 05 May 2025 16:20:25 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 05/50] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Mon,  5 May 2025 16:19:30 -0700
Message-ID: <20250505232015.130990-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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


