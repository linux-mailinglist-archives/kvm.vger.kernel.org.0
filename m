Return-Path: <kvm+bounces-45297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9343CAA83ED
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E670189A74A
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBCF186E20;
	Sun,  4 May 2025 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L9ztVKdN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D4817A316
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336567; cv=none; b=J0BKQmcYqHwIbYeSo2hJ+6pm6mK+N62iVVemE+s8h4xsVX33q7yFoZ+Cxv6E8WhIC/Riy0LkJSNeaerFOZbstTQSqHE3glc9xRdudE6/G39c7julcLVyf4oGgLkFJk0268w+YRS8ZsWHGNRPxTD2pAXyR6lNbe1BOMCSV/eT4dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336567; c=relaxed/simple;
	bh=Oc5IEnZgSw4YEuJW2NB4Ml/1H3pJIm/ZlDs8NaCnCqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxiLON0N2gOBVg69V78tlDVyF9RdJejeiGxdwOgaHJgJNB6D8KA9MJd08lgkcdv7PdO29xkzbMzyQW9uuoXnBjExCovaAF0GFL3kwrAPAvOc+r27DgG9ftCb9PKDGPJ5YwNhJWUUXGImQDD6hA3h+SU9AVFtzY6Spqspw6YsbQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L9ztVKdN; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736ad42dfd6so2821201b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336565; x=1746941365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=L9ztVKdNjoaTjzNni9yFJsNamoVNl/DgMlSz1IXJqzZAbxlzdsICFIJtI/fQKiQqsA
         cIWHCSn1ebJcJp/AgaQQD7VFwShYyez6ReUutKdTu3QVf/D8y9+iPTe746vqIr2mZKw0
         UDYD4F21+kIilW1lhfufX3oA/DaOQz318ehBJvEQqCFd6XF2SAGfVA6td0YQ1mGD2ryl
         tSSRCoO52DzfreGqzs1ink5pg0+i1wcH4hXeAcX8bJD/Tb2phxxVTKiSB8qvWHFISOpY
         fu+mMJk4O2KvmKfGzYBkm/5AoG/xCqbqr/crHmvxsNN2V0dHh6oD/yQIwVmL+wpbhDN3
         01oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336565; x=1746941365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ktcl5OZ+t3GMcQQ7Jgx3PtMsJ0l/J5yPLlaHDm/4GNI=;
        b=sPWdXpWYyPz/mxaydA3cYsMYoEfcM288IY7Oq6+3WRYgCii8BmQggBsj+onZqTmfpK
         dkFdk3Bve1OXAJoae3fElcFzIqkocVpnw26Eheag+moWN9M+T8UIlhoZOmrdZuwzuNs0
         OPHeR3G+fgr5MlZuvOUP7EUyDpzxAs8uqgxuhI0bNEXCHcpZRzjSMWQ0GvbZ63wusAxA
         sm5HHVl58lbecUQ8a0eWESdR3X0IZ0eu9OdRjCI5k71C67tupZozDSYfr+a7yuD/HNUQ
         jcLzBkQ09WyUVFgtkdEabXfLaxEyHNOi2l11fhY4usF7Ss4YGpoi/IqJOuB9cloyJDGn
         pU5A==
X-Forwarded-Encrypted: i=1; AJvYcCVwheXQMa4fAj04QKHgyy3A9WKXuvQyQaPuETAFcI1ns3rALYHVAszm+yHOP1/jM/Hu1Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwemGju1bFLwyu5HPAwrkB8cY3YSBaUEkETiLIXnNy+6O8UMBYa
	/52TwJklCBM9ijDckEHNQ4VW1vVwsr3DR4MdCTriLYi5QUxF+orNr02INzcGIEg=
X-Gm-Gg: ASbGnctDw5eYzPr8Tr5hy0EvzvrmKEMpcpGormvHdf+4eGSUJxu1kqJEyGQa4heQUoO
	oAJPEBXeONZbA9A8olLIivnYHSFjXZyFU3Up1e8CedyAJj/bUKtKMgMV/ebiM3tTHQnJXF//B1t
	OhXlDb2vBqlkQIElW8zIwxTkdIYfBXpZLWOBzB2eN7jcsEsA0feci6D2F9ohUA8gJ/eYr8mSwPr
	F3KZxjjEuBU8v0Xb4inJVVtRPz9gstqAXBbXNsiZV69h1G8RZInxuryMoFM7PX5Qo6pl47PXE8r
	si0pWFrIHkvWCKjMuh1b/poWie7kcsX0qDNJq1Wm
X-Google-Smtp-Source: AGHT+IEfRJdSGLDsp6T32tCM2l+029460i4Q8IRtkfvq61UYn5o5uI0RqXkkPb/trprs30PETo/lIw==
X-Received: by 2002:a05:6a00:1384:b0:740:596b:eaf4 with SMTP id d2e1a72fcca58-740673f2464mr7015748b3a.16.1746336564975;
        Sat, 03 May 2025 22:29:24 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 05/40] target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
Date: Sat,  3 May 2025 22:28:39 -0700
Message-ID: <20250504052914.3525365-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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


