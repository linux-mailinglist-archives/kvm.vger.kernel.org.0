Return-Path: <kvm+bounces-46205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E562EAB4206
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB4321B60231
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACFD2BD017;
	Mon, 12 May 2025 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ru/4qwRD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACCC2BD02B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073117; cv=none; b=a6AOoHb3kd9iQcWvbFvrPE1544E3sm0j/iGOFQXoBIInWXs9H9hzMCWsVy3ChXlP4LlaaqSeKmR1HiUl7M5RKT6dJj7Kyela8RfLgxdwYCa690xDSRhLHrH2hhjg/BsAI1h5V902nJzx1TdUie4b+OHPJtzyt3XL2exR5oVwrOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073117; c=relaxed/simple;
	bh=NskDloI8lQLWqdat3b/r2FM0lGH7R5XUaz3l17L+3UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK4yR0kQGtCL/r4UBujKZP1cJHa2ml7pZujsFVpttjmYTisBL1VuwJhWYR71Ynuw/5PjtlOOT6bZdWedFAd0EfyyFTz/7VvUvaXAzU1nJtO14GDTqoRT3Ia1tdbFpmy80DIDiXc3WnR51MnvPQG9qcIrp/2FpJ1I6uvG99MGxEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ru/4qwRD; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so4108567a12.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073115; x=1747677915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AlvH8T2wxvPoUN2cgh0nAAaoM8ETcHqqaWl8h2qra8=;
        b=Ru/4qwRDw829DmkzmHEwX+ITFSvEIpqH/Sg83zekQDHhnYex6tekbFzOpuOMoFrk/n
         23wEipXHXWS93/dbpspp4vOUM+6xK1Jtt41Hjjh+1gyP3mB7TWz+D2BgPKjaOVvOiYhu
         b4Ty1H5JOeCh4UtTqAoUo1FC7ipfuXZQF/JKtgrYLL9TPSt3lgxyC9vYpkM9+77KYiAp
         maVWDtkmvW0SY6rHo62zCUyn/bwLJfAq5DEQ+yRXw9Az6Lx3PWFvnjafACK2YXOJOBUX
         z53e0tV8VXiBo4yF4WCgbWj6tH+VzAXfu98CZ6wY8wZdOr/FPqwr12vqF3HG0tq32sol
         9AbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073115; x=1747677915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8AlvH8T2wxvPoUN2cgh0nAAaoM8ETcHqqaWl8h2qra8=;
        b=k25kSonVklWMwxXk1RGIuL+MIMOcTk1XBw+JKcu9cHlQO9TCwA563bIU/j5wDVBm4i
         XKQVhMqCbGiGi7i9uZhOzOhtQ/KrNK/PWfv0IUPdg+qHXq6HbohCWmPKMELeisMN+YFy
         gVeyEV5u7n9wIC/4tOeOCrRROyIEDiq2W5/WfNlC+VoYqALR5iK32RcTnVVXN2MC3jdG
         ltPHze8K/MPG5VS1IBdVPnNNdPfQ5/df1qvq37vBQ43bbytM0dyCiGA3oSdQrB28eBgL
         2SmrhurjV/v10cn7d4g1yAJwwgIVcy5UVhxKTRFVLfQJs/8poy0e9348FZXV5HBVP7aq
         68+w==
X-Forwarded-Encrypted: i=1; AJvYcCVIqCoLxfp74tBiIhWOwb91o5K9kowdLftAqmfO13lNlXCUdCCPU+yaHgpoydia4ZHjFEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmVO/VQXvlDJwVw1pDJr8Ma0FQsZp+o11q16SF92yODX+eBNuU
	JZfvHcH1l4N5yAqx6eAgFdJ3T869ksq6vJM3qWLyXPhJeSqpOGIjXKTO4Uce/rw=
X-Gm-Gg: ASbGncuqQPtrVekNoL0RGHYUOAd3zsYrHilKglyp38n55c4WeMpEqLgWB3CrRBUNF0a
	ey/zjbqxgHAvO3JYnzSukhDas1DkqaqVulQHP1QOBFIgfmAANRxHb5pTtB16azPeBZW16Np4mGm
	z8TqMYPWsdjPUjgwTat011rKrOCXmT1TOzX/H5SQt74JNTwmLfJKAzQJ4iNWOdzRb1Agdiw7Crv
	WO/0230xojd64XaGVY9iTE9rsCokxJcyWUKPxcDlQx+VFsmP069e7hjZKqCeAhmTLnP88r1kRVz
	sADhcBmdYyWb8c1CUzPCLxAAWCcx+uAr359kkuNK98QR6mkud0A=
X-Google-Smtp-Source: AGHT+IEtCiZ7pWhfj+zvU+QjNZ6OJ+sx69sEdRwyVqIutBYFsRWs/EvFgb05ePx/aof8VSDvqJ8C0A==
X-Received: by 2002:a17:902:dac5:b0:22e:5389:67fb with SMTP id d9443c01a7336-22fc8b0fab0mr193964295ad.7.1747073115383;
        Mon, 12 May 2025 11:05:15 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:15 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 04/48] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Mon, 12 May 2025 11:04:18 -0700
Message-ID: <20250512180502.2395029-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


