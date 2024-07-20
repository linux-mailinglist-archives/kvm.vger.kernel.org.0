Return-Path: <kvm+bounces-22010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB75938077
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:32:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B72E1C2151F
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4078003F;
	Sat, 20 Jul 2024 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Qnxt+0Kf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA36347C2
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467893; cv=none; b=UHL+tYucAe6gXPNQ1CY+dzIaNUh50t54yYTKDo5NsZUFehq13bfv+8yBlhclWEpETfrmqZha3Dh9YiF2E65tzlvLjTygPf2P16ijXrx0Ako1rXe4wSjCktURvDeZVXSqLJCewSLOEIPamt6GL1Cdz5An+ZJ9b8uY1C5YOshA9no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467893; c=relaxed/simple;
	bh=u7g12Srt7e/9/2tFuU5dbXUVHOQ8y8JmdkVrGzLFbK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bZJuKyjwbsZ4W5FanVr4Fi62Hjd+j5asNlp576D/7W6aQn4eTfeGANnYgzfjcHjso+l0UnD7MABSXATybg61aUH8UXPan9r2OA221mdtHRPDe6yoauTSshYPu1dXmKMsGFo0D2uof9q/ORIJG26JgfKLARHfeLAPICEi6Quxcmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Qnxt+0Kf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc2a194750so26654145ad.1
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467891; x=1722072691; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99AglDGYDKt8UyQF0+i2KqD6ZLYCDLBz3EOwXuGJkA8=;
        b=Qnxt+0KfhcVpKVSiqSqL3RrmzFjTbFoSJ1xnKX1VGkRM4BTjxCuXkebv2exsbTmvdI
         RW8yeTHw9PVZ7p83K0tHWq8yerH2Dn4h595Lsv7g4RBdr3HXjmNjpaAOmF9SHr1vuFR0
         Z4uFg5oiwr7VJ9PfPLeTaVJQrFsTxoI28rbqFcTwoAxPT4OT5CPO6lDQTRWKukfbdkhb
         x7MPY9SMENzZ9bYj2ZXzNXbXQ2/oDpDQJPw2qsj1pIGjV2fArIjA1WiU8mNcKAUhBlws
         hapL20Fz5R8qIueCcrt4Kes3SbTjUa1vMjuuIDg1yvyWbUQPS7Q9Wse+n21TMpnpa3TY
         LD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467891; x=1722072691;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99AglDGYDKt8UyQF0+i2KqD6ZLYCDLBz3EOwXuGJkA8=;
        b=ux/rJ8RZ0zhQosM7rgJqtftp62DxZvKJDIs1Ia0DgPrChv3jNLziYw+yfoGTqg+ZBn
         c3tpj11ZdhjpB+j1CM6ahlgyPS1t4iI3l3VnVErA/C7UfINBeCCpeSstRpgMgdSJ79kW
         mh+GDuZo2jj53v/ImWyUCsf4G81V2nBLaTE4KMFtP238K1PoN4ZT6vck23NvTRKU0r1m
         GCp36fS64uIyWXJEKRIf/tfWH/Uyr7+/Z5YWXWabF2UDZumMx20IHmEzNwI0Zj0EuoOd
         AwLxiaXoTdA72tJqcpDCEipH9Yb9AAKM5Ss/jdKALaPFGgczFiCZwsIzL+4Mr1cHFq/9
         0L9A==
X-Forwarded-Encrypted: i=1; AJvYcCWZCJyYC0aNcdc+5lK3Z1mCuVtAlWEAozmDbzFk3cDeYIOI+1y2PjtiDT71sQ8LExo0m98XXnT2nCnia2OBsOzG8SrG
X-Gm-Message-State: AOJu0YyiPNtJhDOT9lkphVKqpXlrigNjL8nAYZbkWvhiDoEVhzolZNWF
	Z111Du7MceBd8MGI5L71nYIDKPB12Vhv8Kz6nl5WTxeQb0lYZ+TkglgmOyiJAXZfzZzTcDhCLpy
	LgoQ=
X-Google-Smtp-Source: AGHT+IGilupQDoh1YjZT0MqsC5EdkPJxgrupVuH9NgGrPu/6pkbEQMPZjNYjiWTJHABuEd78H+Srqg==
X-Received: by 2002:a05:6a20:12cd:b0:1c3:b1b3:75cf with SMTP id adf61e73a8af0-1c4285d386fmr1147019637.14.1721467890772;
        Sat, 20 Jul 2024 02:31:30 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2cb77504fa2sm4228362a91.46.2024.07.20.02.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:30 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 20 Jul 2024 18:30:53 +0900
Subject: [PATCH v4 5/6] hvf: arm: Properly disable PMU
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240720-pmu-v4-5-2a2b28f6b08f@daynix.com>
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

Setting pmu property used to have no effect for hvf so fix it.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/hvf/hvf.c | 184 +++++++++++++++++++++++++++------------------------
 1 file changed, 97 insertions(+), 87 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 1a749534fb0d..adcdfae0b17f 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1204,45 +1204,50 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint64_t *val)
     ARMCPU *arm_cpu = ARM_CPU(cpu);
     CPUARMState *env = &arm_cpu->env;
 
+    if (arm_feature(env, ARM_FEATURE_PMU)) {
+        switch (reg) {
+        case SYSREG_PMCR_EL0:
+            *val = env->cp15.c9_pmcr;
+            return 0;
+        case SYSREG_PMCCNTR_EL0:
+            pmu_op_start(env);
+            *val = env->cp15.c15_ccnt;
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMCNTENCLR_EL0:
+            *val = env->cp15.c9_pmcnten;
+            return 0;
+        case SYSREG_PMOVSCLR_EL0:
+            *val = env->cp15.c9_pmovsr;
+            return 0;
+        case SYSREG_PMSELR_EL0:
+            *val = env->cp15.c9_pmselr;
+            return 0;
+        case SYSREG_PMINTENCLR_EL1:
+            *val = env->cp15.c9_pminten;
+            return 0;
+        case SYSREG_PMCCFILTR_EL0:
+            *val = env->cp15.pmccfiltr_el0;
+            return 0;
+        case SYSREG_PMCNTENSET_EL0:
+            *val = env->cp15.c9_pmcnten;
+            return 0;
+        case SYSREG_PMUSERENR_EL0:
+            *val = env->cp15.c9_pmuserenr;
+            return 0;
+        case SYSREG_PMCEID0_EL0:
+        case SYSREG_PMCEID1_EL0:
+            /* We can't really count anything yet, declare all events invalid */
+            *val = 0;
+            return 0;
+        }
+    }
+
     switch (reg) {
     case SYSREG_CNTPCT_EL0:
         *val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
               gt_cntfrq_period_ns(arm_cpu);
         return 0;
-    case SYSREG_PMCR_EL0:
-        *val = env->cp15.c9_pmcr;
-        return 0;
-    case SYSREG_PMCCNTR_EL0:
-        pmu_op_start(env);
-        *val = env->cp15.c15_ccnt;
-        pmu_op_finish(env);
-        return 0;
-    case SYSREG_PMCNTENCLR_EL0:
-        *val = env->cp15.c9_pmcnten;
-        return 0;
-    case SYSREG_PMOVSCLR_EL0:
-        *val = env->cp15.c9_pmovsr;
-        return 0;
-    case SYSREG_PMSELR_EL0:
-        *val = env->cp15.c9_pmselr;
-        return 0;
-    case SYSREG_PMINTENCLR_EL1:
-        *val = env->cp15.c9_pminten;
-        return 0;
-    case SYSREG_PMCCFILTR_EL0:
-        *val = env->cp15.pmccfiltr_el0;
-        return 0;
-    case SYSREG_PMCNTENSET_EL0:
-        *val = env->cp15.c9_pmcnten;
-        return 0;
-    case SYSREG_PMUSERENR_EL0:
-        *val = env->cp15.c9_pmuserenr;
-        return 0;
-    case SYSREG_PMCEID0_EL0:
-    case SYSREG_PMCEID1_EL0:
-        /* We can't really count anything yet, declare all events invalid */
-        *val = 0;
-        return 0;
     case SYSREG_OSLSR_EL1:
         *val = env->cp15.oslsr_el1;
         return 0;
@@ -1486,64 +1491,69 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
                            SYSREG_OP2(reg),
                            val);
 
-    switch (reg) {
-    case SYSREG_PMCCNTR_EL0:
-        pmu_op_start(env);
-        env->cp15.c15_ccnt = val;
-        pmu_op_finish(env);
-        return 0;
-    case SYSREG_PMCR_EL0:
-        pmu_op_start(env);
+    if (arm_feature(env, ARM_FEATURE_PMU)) {
+        switch (reg) {
+        case SYSREG_PMCCNTR_EL0:
+            pmu_op_start(env);
+            env->cp15.c15_ccnt = val;
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMCR_EL0:
+            pmu_op_start(env);
 
-        if (val & PMCRC) {
-            /* The counter has been reset */
-            env->cp15.c15_ccnt = 0;
-        }
+            if (val & PMCRC) {
+                /* The counter has been reset */
+                env->cp15.c15_ccnt = 0;
+            }
 
-        if (val & PMCRP) {
-            unsigned int i;
-            for (i = 0; i < pmu_num_counters(env); i++) {
-                env->cp15.c14_pmevcntr[i] = 0;
+            if (val & PMCRP) {
+                unsigned int i;
+                for (i = 0; i < pmu_num_counters(env); i++) {
+                    env->cp15.c14_pmevcntr[i] = 0;
+                }
             }
-        }
 
-        env->cp15.c9_pmcr &= ~PMCR_WRITABLE_MASK;
-        env->cp15.c9_pmcr |= (val & PMCR_WRITABLE_MASK);
+            env->cp15.c9_pmcr &= ~PMCR_WRITABLE_MASK;
+            env->cp15.c9_pmcr |= (val & PMCR_WRITABLE_MASK);
 
-        pmu_op_finish(env);
-        return 0;
-    case SYSREG_PMUSERENR_EL0:
-        env->cp15.c9_pmuserenr = val & 0xf;
-        return 0;
-    case SYSREG_PMCNTENSET_EL0:
-        env->cp15.c9_pmcnten |= (val & pmu_counter_mask(env));
-        return 0;
-    case SYSREG_PMCNTENCLR_EL0:
-        env->cp15.c9_pmcnten &= ~(val & pmu_counter_mask(env));
-        return 0;
-    case SYSREG_PMINTENCLR_EL1:
-        pmu_op_start(env);
-        env->cp15.c9_pminten |= val;
-        pmu_op_finish(env);
-        return 0;
-    case SYSREG_PMOVSCLR_EL0:
-        pmu_op_start(env);
-        env->cp15.c9_pmovsr &= ~val;
-        pmu_op_finish(env);
-        return 0;
-    case SYSREG_PMSWINC_EL0:
-        pmu_op_start(env);
-        pmswinc_write(env, val);
-        pmu_op_finish(env);
-        return 0;
-    case SYSREG_PMSELR_EL0:
-        env->cp15.c9_pmselr = val & 0x1f;
-        return 0;
-    case SYSREG_PMCCFILTR_EL0:
-        pmu_op_start(env);
-        env->cp15.pmccfiltr_el0 = val & PMCCFILTR_EL0;
-        pmu_op_finish(env);
-        return 0;
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMUSERENR_EL0:
+            env->cp15.c9_pmuserenr = val & 0xf;
+            return 0;
+        case SYSREG_PMCNTENSET_EL0:
+            env->cp15.c9_pmcnten |= (val & pmu_counter_mask(env));
+            return 0;
+        case SYSREG_PMCNTENCLR_EL0:
+            env->cp15.c9_pmcnten &= ~(val & pmu_counter_mask(env));
+            return 0;
+        case SYSREG_PMINTENCLR_EL1:
+            pmu_op_start(env);
+            env->cp15.c9_pminten |= val;
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMOVSCLR_EL0:
+            pmu_op_start(env);
+            env->cp15.c9_pmovsr &= ~val;
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMSWINC_EL0:
+            pmu_op_start(env);
+            pmswinc_write(env, val);
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMSELR_EL0:
+            env->cp15.c9_pmselr = val & 0x1f;
+            return 0;
+        case SYSREG_PMCCFILTR_EL0:
+            pmu_op_start(env);
+            env->cp15.pmccfiltr_el0 = val & PMCCFILTR_EL0;
+            pmu_op_finish(env);
+            return 0;
+        }
+    }
+
+    switch (reg) {
     case SYSREG_OSLAR_EL1:
         env->cp15.oslsr_el1 = val & 1;
         return 0;

-- 
2.45.2


