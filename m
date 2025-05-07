Return-Path: <kvm+bounces-45772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E99AAEF63
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D44EE7BDB31
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D6B29189D;
	Wed,  7 May 2025 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c/tlcyTT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA46291878
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661370; cv=none; b=dNTD+VQCIMo0prT0x72IIFV0V8A72WNLx3NoLy1orzOvPdCme7GEC/lSu8kGVWJ76k8Nxt3rHJkyX4buGCHfz+FuvDrV10CM30tOlsHRKzqUEYCuNJyUfjj4eUuGggFG5D5/r7hOdZ7KGgcy5c1M+BaYQ4UkFj/BO16+BI7extc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661370; c=relaxed/simple;
	bh=N3k9mOO4kZXYEsvhczqhrT1Vg1W1TaSoZ5LvUQqhxdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ccZDMr4w05DJfNyDaLDnRxszkp870yf9nZjv5Dby3yMEVJ7V802JCTS8Uidd2vLO+VdfR41n0nl8ozWZP2GrOoLFtCaTS9/esRsMBZ+x6QMUFQKO/6AxOKEceC9fSUx6RBpE/B0k1SaRf7ozY8vp5IgwoQ0SHBQ7ea3NzwLf2Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c/tlcyTT; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22fa47d6578so411235ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661368; x=1747266168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cH5ZtRCeVBPeaEwJ188gDPaPfkE7sAMWROIwRI8/rfo=;
        b=c/tlcyTTv/TGufXwRNHUNx+yhHt87fLk5H53k7qnbhm4CLbl/injhpFRWkSscdBVU1
         9CNbN2iyc0PunUFN7IP2NuwNK9EYRqEZ0PC5LmpR94tWFGjnimKu/Cc1Tx2lH6PFUiUH
         br4vd2AUxZwSF1HT98Dw12l2gqRR5V8bdGbVn1bGN/z83h10GPNPwUE0F4m4YLvip+Ji
         05U2hkJ/JHVwFf840DgL9qtf5zujl4VPOgs47kAIUouBZjZxL89Fyk01yZT2SgHjKaNE
         DmcP+AldOweAcBUfpe3Fc47VbD9536IaMNqtUgdSvsntk3NEn4Hs9UdHTSe/xfGZQDJL
         boVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661368; x=1747266168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cH5ZtRCeVBPeaEwJ188gDPaPfkE7sAMWROIwRI8/rfo=;
        b=dCc0if+T77qiwTn4UBF1WpvcRKuO3FkbA18wyrwbBKOdpeKIXutE/PIwii8ymjdrrf
         odjHiosuwff+J0M/dDOVe1KPpKd0FlrYvM6g5rO5k6ngW8OcEzPIDJfiztjiNzBvjhMS
         dFvVXJ1OqSWwJgEak4fgvBP0F13ZaEw0jXdzu6uZ0mNcpzNkEkQw4NwIdhMeV1piiH7u
         eeG5+xb7hg2JAluVqVZyNUIPzSzBkrj05w0DkQvn4OYFOZ1eUPhSHf3yE9OEQSj5Eppm
         sULERbUA5P6DpGGRwNIFBfwYp+EjIL4wyuB+RwbX+tct9O875Vx8mqX+8U5CmyzGWwJ+
         NV3A==
X-Forwarded-Encrypted: i=1; AJvYcCWdR5cChsVLyGI+h/B2/Ng8hGccyOjrXmKHvS1K3bqojE+k3RrPqWeohiZGi5m+fIAJheY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaNmxosH5DzkXFtT2gLzVaTNINIFF+tsJAoMbktgS2kyEWu1nh
	4fJLuZzfJ94simGsgAb4yi/e3TfPxspmCORb5PpD5LzHIaUMiaQIoIDCn6NE63Q=
X-Gm-Gg: ASbGncvfMVwudrK7lUnH3CJvisQheAI64QL0+3OgjGW8n+oGgjPVjQF65bOol2184O3
	gAHXLkwcE+Ia34DT6a6BduKu4AqrY7GaPhMKoIMPHMWTKXCFiieQMUPFHTja1yaxdXWbtdVAiSj
	hBLUSnulCrCnuBRuz/FZxD7uHjpN4gHKydyNN5RQ3/KRBZRG0bnFciAIQtoMIpdusSiEjGj14jl
	F4PoYGB07zzVzN1m9fslT03DurfClieAnOQHND4fjjnoyiqXP63WhZUp1DyR3eiZE6Ncjh413qJ
	Tn5BVjDV0OmUjVJ/gMclVWUyOs5a4t7165FYAvbu
X-Google-Smtp-Source: AGHT+IFDUVNwwhWVulYfNSLoyuZxcW1zQrk5HN1MrlYxS3XpcmOjPsatZYcv0uHEc9J9FrqM7d+Acw==
X-Received: by 2002:a17:902:d50f:b0:220:c911:3f60 with SMTP id d9443c01a7336-22e5ee1cc66mr81484075ad.47.1746661368656;
        Wed, 07 May 2025 16:42:48 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:48 -0700 (PDT)
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
Subject: [PATCH v7 06/49] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Wed,  7 May 2025 16:41:57 -0700
Message-ID: <20250507234241.957746-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow to get rid of CONFIG_KVM in target/arm/cpu.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h  |  2 ++
 target/arm/cpu.c      | 31 -------------------------------
 target/arm/kvm-stub.c |  5 +++++
 target/arm/kvm.c      | 29 +++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 5bf5d56648f..b638e09a687 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -216,4 +216,6 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
 void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
+
 #endif
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 45cb6fd7eed..d062829ec14 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1098,37 +1098,6 @@ static void arm_cpu_set_irq(void *opaque, int irq, int level)
     }
 }
 
-static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
-{
-#ifdef CONFIG_KVM
-    ARMCPU *cpu = opaque;
-    CPUARMState *env = &cpu->env;
-    CPUState *cs = CPU(cpu);
-    uint32_t linestate_bit;
-    int irq_id;
-
-    switch (irq) {
-    case ARM_CPU_IRQ:
-        irq_id = KVM_ARM_IRQ_CPU_IRQ;
-        linestate_bit = CPU_INTERRUPT_HARD;
-        break;
-    case ARM_CPU_FIQ:
-        irq_id = KVM_ARM_IRQ_CPU_FIQ;
-        linestate_bit = CPU_INTERRUPT_FIQ;
-        break;
-    default:
-        g_assert_not_reached();
-    }
-
-    if (level) {
-        env->irq_line_state |= linestate_bit;
-    } else {
-        env->irq_line_state &= ~linestate_bit;
-    }
-    kvm_arm_set_irq(cs->cpu_index, KVM_ARM_IRQ_TYPE_CPU, irq_id, !!level);
-#endif
-}
-
 static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index e34d3f5e6b4..4806365cdc5 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -104,3 +104,8 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
+
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 9c62d12b233..b6c39ca61fa 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2429,3 +2429,32 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
         cpu->kvm_mte = true;
     }
 }
+
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
+{
+    ARMCPU *cpu = arm_cpu;
+    CPUARMState *env = &cpu->env;
+    CPUState *cs = CPU(cpu);
+    uint32_t linestate_bit;
+    int irq_id;
+
+    switch (irq) {
+    case ARM_CPU_IRQ:
+        irq_id = KVM_ARM_IRQ_CPU_IRQ;
+        linestate_bit = CPU_INTERRUPT_HARD;
+        break;
+    case ARM_CPU_FIQ:
+        irq_id = KVM_ARM_IRQ_CPU_FIQ;
+        linestate_bit = CPU_INTERRUPT_FIQ;
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    if (level) {
+        env->irq_line_state |= linestate_bit;
+    } else {
+        env->irq_line_state &= ~linestate_bit;
+    }
+    kvm_arm_set_irq(cs->cpu_index, KVM_ARM_IRQ_TYPE_CPU, irq_id, !!level);
+}
-- 
2.47.2


