Return-Path: <kvm+bounces-44668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 072D1AA0182
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB14E1B61612
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1C9274658;
	Tue, 29 Apr 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hk2ScMeS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95C22741C6
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902822; cv=none; b=GeqQozq+Hqld3J0RTnymRP6Zuw98wEeOpNAVGMvYMQ0BaNRBN7RgHuD1krpRw3OQlzIeqIZjDtkkE8A7ZxefWpxS5DHSq7R4M/v8ixQuyCEvhPQZ5ep5waswvolppzqCR4g0xOmtda1z4bAG2v4elWQRu2IVn5dLNT5uMnxjLXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902822; c=relaxed/simple;
	bh=nvf5rOFVtKLON5aqtAenStgatyFtxhl9/xmMJqYNb+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvULysWhNAPKfwxYmJ3Okf6OHUc4aF+OMK+YXE9ulOpyXZBhtXi72tgjrdWsSc5XynaGSgbIH2901HIRzTKRKRbSkqHEUUgzcSbKrFG+632EPOMJa6m9iCAyuBDxH/TOjcU8UFLzknUGhUbI68U5nYOXeG80OK1Tf+B/jJxz1ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hk2ScMeS; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-227914acd20so55783255ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902820; x=1746507620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTaFFMYBVP+QujpvomI3smt+CnB1wh0iLnUK0PT4pEc=;
        b=Hk2ScMeS56/pY0LsyvDgKdOYvfk78aFZH1IZf42Ivwu1GdwrAfUPgnSlbWTtk5b++Y
         EGlLa7ca5wb9oyvGYlpt9KbZzsSRv9wcPu//n7QVnKCkTLF7dkCHt63ORy+P77at27ks
         zo0nnH7QpRpq2Y4mSReZspxFmgk1XKSvhAecP5Hbei3ReCOF7jE5jGepWRcR9CAfMyqe
         okROjgaC0prU2Sna2ZcUqvbSzDZNhazokJtLWDhytA/hmed1x8VFIloiDWe0kLaHrnTb
         s0VnAIe7LBDEsuUNV+Huy7+5PmupxLAGlGGx8ZAP/M3BvstFXMxAzrq3W9z0o84mPl4C
         NG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902820; x=1746507620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTaFFMYBVP+QujpvomI3smt+CnB1wh0iLnUK0PT4pEc=;
        b=PgNFch/0YANji04uyZJ6G7iSp9IiBEsW6Y4mGJCgAMb7sBOt/VzggPGrXW3edFP1vA
         03mU+OXLAKA+2jNp4pD0SvwZJC22UfGFxhJG63Hm1sgl6uABlVkWflVr6GSmNCukVrj2
         J7TQZMSegjnbKpnCKM12X9daWZQglTDj87OE3+I7SFeS+kXBwieNBaRbmSlQrn+kIFLZ
         xB+sg6kqV7/BqRW29V2CgKYuGisWIRlpLUcDHq3rbkz/bQ0YTMwNiGjiKSeQB3Qc3H/I
         EzXWr5iSBfF44FTdLMm/w+Zhi0D3pi++8xs5k1Plchm+6ejbh7mAdZ5Vdz31R4Gb9FVK
         f3aA==
X-Forwarded-Encrypted: i=1; AJvYcCXs06XTj/3uSoBiDtW3xAVaFB6OJxhiEkuv/fzO+mPE3oMG9uTF8iv9SnzDz4bkBgN9ltI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3ZtMGsl0OSw96xTgq936AGSTStjwTj0SW31dqDg+EbooUVVTD
	0RCPwIwQ+jaOtn5E37pFowv+KyGCSR6hKn2PE2/Cnta+OzrYKMQ1Y3wkPwoiY5w=
X-Gm-Gg: ASbGncv9fODInqc6PY/HlaoaiUfWibLELQyCYhs4OOAq3Xk9YY0GapDR+EvjjPxWcAW
	HmCByG/3kkA2WcY3xJdZaV1upVHdEwB1ZwB8COsmhk2AGvnKQ6dnPTRDRFZxyHeOCx5D0lPopYj
	o8T5BSb9CIpxQva01kDiODpJN30FFv0N+78ThH4iYFZhfzXa6PFnbLG728kXfUT3O1lV7qk1x22
	RQEpQ/buj0lZvouwHQJNCVss4hhDHBwaumuamX45VS/VrbRyiU4ywHsgJvBUlwx3Bx7z/rjOQij
	RyHtdx3C0cihEELZlfLgNNJAcwWBKa+iPOReIIjC
X-Google-Smtp-Source: AGHT+IEx/Jh51iAi9wYCRK0qOdbUNLmln4cWvAe8L1xYO15g0HGBE2gNuockkWPBNYfIVdVxbblv3w==
X-Received: by 2002:a17:902:d488:b0:215:a56f:1e50 with SMTP id d9443c01a7336-22de6bff536mr25643515ad.8.1745902819983;
        Mon, 28 Apr 2025 22:00:19 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:19 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 04/13] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Mon, 28 Apr 2025 22:00:01 -0700
Message-ID: <20250429050010.971128-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have to be careful to expose struct kvm_vcpu_init only when kvm is
possible, thus the additional CONFIG_KVM_IS_POSSIBLE around
kvm_arm_create_scratch_host_vcpu.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h  | 84 ++-----------------------------------------
 target/arm/kvm-stub.c | 77 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 82 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 05c3de8cd46..c8ddf8beb2e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -94,7 +94,7 @@ void kvm_arm_cpu_post_load(ARMCPU *cpu);
  */
 void kvm_arm_reset_vcpu(ARMCPU *cpu);
 
-#ifdef CONFIG_KVM
+#ifdef CONFIG_KVM_IS_POSSIBLE
 /**
  * kvm_arm_create_scratch_host_vcpu:
  * @cpus_to_try: array of QEMU_KVM_ARM_TARGET_* values (terminated with
@@ -116,6 +116,7 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu);
 bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
                                       int *fdarray,
                                       struct kvm_vcpu_init *init);
+#endif /* CONFIG_KVM_IS_POSSIBLE */
 
 /**
  * kvm_arm_destroy_scratch_host_vcpu:
@@ -221,85 +222,4 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
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


