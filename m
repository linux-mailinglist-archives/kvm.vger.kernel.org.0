Return-Path: <kvm+bounces-21709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB0F9326E4
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 14:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1660E1C2249A
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36507143C5A;
	Tue, 16 Jul 2024 12:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="R+4s6mZB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C559419AD47
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134266; cv=none; b=VqWd762S5CqmLv5ea5P0hcNkGqK54OMN6ZHxPW9LUTwb5ABRLaxv7UbdTjUuhbrwU0OQw9wJTOZXgz3I6xIA4Yq/jBkOggUCGwDJt2UORaEp5Hj/T8c9gQXDqlleuO60mjStK0wNmehRxCXrOPY4KGU2xuxhZPqdxyd55t9V2h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134266; c=relaxed/simple;
	bh=ZN+w/dPsYYULRJFjisaG7g1Tpm30qmVbZNzDfC0PBVE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CuwyuAwQZBPcR+ktkoDgVvF1qkyEsEEawQWn+grpUnqrfu5koygKziN67JWpUN5zj3IePeBvNkBJOKVXBhTKm7khWwJy8XnY0bSJNiXGNAs4RbFPOMdBNDvEz2qtxW3CUQqpKAciem96GU+sFX/S2tqHa/g+eTb7YoZno6aZhTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=R+4s6mZB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fbe6f83957so45219345ad.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 05:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721134264; x=1721739064; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WEJblyW6Ds1TMF7KFQ+gDmurIfGkUROkVQ8nHbOWOsc=;
        b=R+4s6mZBaG33cp8a6SHDCcoipKT12Bci/5bb0O9T8khx90v/DJPhntwQD+9m9sw40D
         3lS9ArBWAuI+kDc7MU4xfe1aIAzt7ol4UB69l0ccDv0tqyTbUsn/KFA94a0iee3WvzyE
         lxlJYD+klazpQth+kcLE/FgH9Qo0iqTqvLsUHkrOLOnphaHTwgxb1zRBQkla7BIjiQaK
         b3/HhzTlzvn6ITrP0VHFxIx2YbGUJohtyyf6gYwUJLID9s16DMAYuUiPIXAvSfo1iO2G
         MrTSavK2EIbXkcC8WEM/smeTeWy0eVytFUkdx1bP3DJytEqbOz2LgEJaVqXIlmrj4sqv
         nFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721134264; x=1721739064;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WEJblyW6Ds1TMF7KFQ+gDmurIfGkUROkVQ8nHbOWOsc=;
        b=AhUksGWStQkyYC6op5SUmyZElstswe30WRYuCl8VtvUyWo9ZK9E1ESQWoVUfx5ntdn
         WjS19W0wlh8zGs6GLc0hcyeQ2aEgVeEb5O9h23Rd8HCFxzbmlTVpYZsmGdphhw4rm9JN
         2sRMcQ4sqyktbukU/B6bkessvBjP+F4+40DBzITQ7MUtnpSu8Gu7masI/QTUYjPg08+E
         vymbM7w9ydQ9MTFVqa6iM/3013JdVNbAxzOhpj7dI4cQF3G5rUQNqtcGz6x6sjDw2ANt
         IO/e2eTx0z5AwxKw1kTN/5AymFFj+SjFpEs+ep802qAR3Vw3XhJDOPlpLA5cod99Ut4Q
         e3lQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpfuNhDKHtHYVLMrj224X6ogQ7sfb+Jj6/YSACLdWpmRNnTZZFy2y+1SlUI00FpmoU8WqQiMaHafjZJ5V4SdjJXlKB
X-Gm-Message-State: AOJu0Yxlcx/pRM7Ndf0wP71bR+yUw+YzAoHsPEeo1I3PahNAtJ9Jp91h
	/fVQQV6RT7cKYttB5laVXcR6E4EqJeDEoyCx4DdVanG1S6G5stDfe6z0p3C5dDQ=
X-Google-Smtp-Source: AGHT+IHLl6OhxYtFa4Hu9G+eXwmzB422zbJLkf8LJk3FIsLRsVJ+05Y25EPMKfYbsu8hkTzkg2XY7A==
X-Received: by 2002:a17:902:fc8d:b0:1fc:2c53:80a0 with SMTP id d9443c01a7336-1fc3d93959cmr16756835ad.14.1721134263928;
        Tue, 16 Jul 2024 05:51:03 -0700 (PDT)
Received: from localhost ([157.82.202.230])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fc0bc2634fsm57640325ad.127.2024.07.16.05.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 05:51:03 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 21:50:34 +0900
Subject: [PATCH v3 5/5] hvf: arm: Properly disable PMU
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v3-5-8c7c1858a227@daynix.com>
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
In-Reply-To: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

Setting pmu property used to have no effect for hvf so fix it.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/hvf/hvf.c | 317 ++++++++++++++++++++++++++-------------------------
 1 file changed, 163 insertions(+), 154 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index eb090e67a2f8..7c593c2d93de 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1199,57 +1199,23 @@ static bool hvf_sysreg_read_cp(CPUState *cpu, uint32_t reg, uint64_t *val)
     return false;
 }
 
-static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
+static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt,
+                           uint64_t *val)
 {
     ARMCPU *arm_cpu = ARM_CPU(cpu);
     CPUARMState *env = &arm_cpu->env;
-    uint64_t val = 0;
 
     switch (reg) {
     case SYSREG_CNTPCT_EL0:
-        val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
-              gt_cntfrq_period_ns(arm_cpu);
-        break;
-    case SYSREG_PMCR_EL0:
-        val = env->cp15.c9_pmcr;
-        break;
-    case SYSREG_PMCCNTR_EL0:
-        pmu_op_start(env);
-        val = env->cp15.c15_ccnt;
-        pmu_op_finish(env);
-        break;
-    case SYSREG_PMCNTENCLR_EL0:
-        val = env->cp15.c9_pmcnten;
-        break;
-    case SYSREG_PMOVSCLR_EL0:
-        val = env->cp15.c9_pmovsr;
-        break;
-    case SYSREG_PMSELR_EL0:
-        val = env->cp15.c9_pmselr;
-        break;
-    case SYSREG_PMINTENCLR_EL1:
-        val = env->cp15.c9_pminten;
-        break;
-    case SYSREG_PMCCFILTR_EL0:
-        val = env->cp15.pmccfiltr_el0;
-        break;
-    case SYSREG_PMCNTENSET_EL0:
-        val = env->cp15.c9_pmcnten;
-        break;
-    case SYSREG_PMUSERENR_EL0:
-        val = env->cp15.c9_pmuserenr;
-        break;
-    case SYSREG_PMCEID0_EL0:
-    case SYSREG_PMCEID1_EL0:
-        /* We can't really count anything yet, declare all events invalid */
-        val = 0;
-        break;
+        *val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
+               gt_cntfrq_period_ns(arm_cpu);
+        return 0;
     case SYSREG_OSLSR_EL1:
-        val = env->cp15.oslsr_el1;
-        break;
+        *val = env->cp15.oslsr_el1;
+        return 0;
     case SYSREG_OSDLR_EL1:
         /* Dummy register */
-        break;
+        return 0;
     case SYSREG_ICC_AP0R0_EL1:
     case SYSREG_ICC_AP0R1_EL1:
     case SYSREG_ICC_AP0R2_EL1:
@@ -1276,11 +1242,11 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_ICC_SRE_EL1:
     case SYSREG_ICC_CTLR_EL1:
         /* Call the TCG sysreg handler. This is only safe for GICv3 regs. */
-        if (!hvf_sysreg_read_cp(cpu, reg, &val)) {
+        if (!hvf_sysreg_read_cp(cpu, reg, val)) {
             hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
             return 1;
         }
-        break;
+        return 0;
     case SYSREG_DBGBVR0_EL1:
     case SYSREG_DBGBVR1_EL1:
     case SYSREG_DBGBVR2_EL1:
@@ -1297,8 +1263,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_DBGBVR13_EL1:
     case SYSREG_DBGBVR14_EL1:
     case SYSREG_DBGBVR15_EL1:
-        val = env->cp15.dbgbvr[SYSREG_CRM(reg)];
-        break;
+        *val = env->cp15.dbgbvr[SYSREG_CRM(reg)];
+        return 0;
     case SYSREG_DBGBCR0_EL1:
     case SYSREG_DBGBCR1_EL1:
     case SYSREG_DBGBCR2_EL1:
@@ -1315,8 +1281,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_DBGBCR13_EL1:
     case SYSREG_DBGBCR14_EL1:
     case SYSREG_DBGBCR15_EL1:
-        val = env->cp15.dbgbcr[SYSREG_CRM(reg)];
-        break;
+        *val = env->cp15.dbgbcr[SYSREG_CRM(reg)];
+        return 0;
     case SYSREG_DBGWVR0_EL1:
     case SYSREG_DBGWVR1_EL1:
     case SYSREG_DBGWVR2_EL1:
@@ -1333,8 +1299,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_DBGWVR13_EL1:
     case SYSREG_DBGWVR14_EL1:
     case SYSREG_DBGWVR15_EL1:
-        val = env->cp15.dbgwvr[SYSREG_CRM(reg)];
-        break;
+        *val = env->cp15.dbgwvr[SYSREG_CRM(reg)];
+        return 0;
     case SYSREG_DBGWCR0_EL1:
     case SYSREG_DBGWCR1_EL1:
     case SYSREG_DBGWCR2_EL1:
@@ -1351,35 +1317,64 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_DBGWCR13_EL1:
     case SYSREG_DBGWCR14_EL1:
     case SYSREG_DBGWCR15_EL1:
-        val = env->cp15.dbgwcr[SYSREG_CRM(reg)];
-        break;
-    default:
-        if (is_id_sysreg(reg)) {
-            /* ID system registers read as RES0 */
-            val = 0;
-            break;
+        *val = env->cp15.dbgwcr[SYSREG_CRM(reg)];
+        return 0;
+    }
+
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
         }
-        cpu_synchronize_state(cpu);
-        trace_hvf_unhandled_sysreg_read(env->pc, reg,
-                                        SYSREG_OP0(reg),
-                                        SYSREG_OP1(reg),
-                                        SYSREG_CRN(reg),
-                                        SYSREG_CRM(reg),
-                                        SYSREG_OP2(reg));
-        hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
-        return 1;
-    }
-
-    trace_hvf_sysreg_read(reg,
-                          SYSREG_OP0(reg),
-                          SYSREG_OP1(reg),
-                          SYSREG_CRN(reg),
-                          SYSREG_CRM(reg),
-                          SYSREG_OP2(reg),
-                          val);
-    hvf_set_reg(cpu, rt, val);
+    }
 
-    return 0;
+    if (is_id_sysreg(reg)) {
+        /* ID system registers read as RES0 */
+        *val = 0;
+        return 0;
+    }
+
+    cpu_synchronize_state(cpu);
+    trace_hvf_unhandled_sysreg_read(env->pc, reg,
+                                    SYSREG_OP0(reg),
+                                    SYSREG_OP1(reg),
+                                    SYSREG_CRN(reg),
+                                    SYSREG_CRM(reg),
+                                    SYSREG_OP2(reg));
+    hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+    return 1;
 }
 
 static void pmu_update_irq(CPUARMState *env)
@@ -1499,69 +1494,12 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
                            val);
 
     switch (reg) {
-    case SYSREG_PMCCNTR_EL0:
-        pmu_op_start(env);
-        env->cp15.c15_ccnt = val;
-        pmu_op_finish(env);
-        break;
-    case SYSREG_PMCR_EL0:
-        pmu_op_start(env);
-
-        if (val & PMCRC) {
-            /* The counter has been reset */
-            env->cp15.c15_ccnt = 0;
-        }
-
-        if (val & PMCRP) {
-            unsigned int i;
-            for (i = 0; i < pmu_num_counters(env); i++) {
-                env->cp15.c14_pmevcntr[i] = 0;
-            }
-        }
-
-        env->cp15.c9_pmcr &= ~PMCR_WRITABLE_MASK;
-        env->cp15.c9_pmcr |= (val & PMCR_WRITABLE_MASK);
-
-        pmu_op_finish(env);
-        break;
-    case SYSREG_PMUSERENR_EL0:
-        env->cp15.c9_pmuserenr = val & 0xf;
-        break;
-    case SYSREG_PMCNTENSET_EL0:
-        env->cp15.c9_pmcnten |= (val & pmu_counter_mask(env));
-        break;
-    case SYSREG_PMCNTENCLR_EL0:
-        env->cp15.c9_pmcnten &= ~(val & pmu_counter_mask(env));
-        break;
-    case SYSREG_PMINTENCLR_EL1:
-        pmu_op_start(env);
-        env->cp15.c9_pminten |= val;
-        pmu_op_finish(env);
-        break;
-    case SYSREG_PMOVSCLR_EL0:
-        pmu_op_start(env);
-        env->cp15.c9_pmovsr &= ~val;
-        pmu_op_finish(env);
-        break;
-    case SYSREG_PMSWINC_EL0:
-        pmu_op_start(env);
-        pmswinc_write(env, val);
-        pmu_op_finish(env);
-        break;
-    case SYSREG_PMSELR_EL0:
-        env->cp15.c9_pmselr = val & 0x1f;
-        break;
-    case SYSREG_PMCCFILTR_EL0:
-        pmu_op_start(env);
-        env->cp15.pmccfiltr_el0 = val & PMCCFILTR_EL0;
-        pmu_op_finish(env);
-        break;
     case SYSREG_OSLAR_EL1:
         env->cp15.oslsr_el1 = val & 1;
-        break;
+        return 0;
     case SYSREG_OSDLR_EL1:
         /* Dummy register */
-        break;
+        return 0;
     case SYSREG_ICC_AP0R0_EL1:
     case SYSREG_ICC_AP0R1_EL1:
     case SYSREG_ICC_AP0R2_EL1:
@@ -1591,10 +1529,10 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
         if (!hvf_sysreg_write_cp(cpu, reg, val)) {
             hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
         }
-        break;
+        return 0;
     case SYSREG_MDSCR_EL1:
         env->cp15.mdscr_el1 = val;
-        break;
+        return 0;
     case SYSREG_DBGBVR0_EL1:
     case SYSREG_DBGBVR1_EL1:
     case SYSREG_DBGBVR2_EL1:
@@ -1612,7 +1550,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGBVR14_EL1:
     case SYSREG_DBGBVR15_EL1:
         env->cp15.dbgbvr[SYSREG_CRM(reg)] = val;
-        break;
+        return 0;
     case SYSREG_DBGBCR0_EL1:
     case SYSREG_DBGBCR1_EL1:
     case SYSREG_DBGBCR2_EL1:
@@ -1630,7 +1568,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGBCR14_EL1:
     case SYSREG_DBGBCR15_EL1:
         env->cp15.dbgbcr[SYSREG_CRM(reg)] = val;
-        break;
+        return 0;
     case SYSREG_DBGWVR0_EL1:
     case SYSREG_DBGWVR1_EL1:
     case SYSREG_DBGWVR2_EL1:
@@ -1648,7 +1586,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGWVR14_EL1:
     case SYSREG_DBGWVR15_EL1:
         env->cp15.dbgwvr[SYSREG_CRM(reg)] = val;
-        break;
+        return 0;
     case SYSREG_DBGWCR0_EL1:
     case SYSREG_DBGWCR1_EL1:
     case SYSREG_DBGWCR2_EL1:
@@ -1666,20 +1604,80 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGWCR14_EL1:
     case SYSREG_DBGWCR15_EL1:
         env->cp15.dbgwcr[SYSREG_CRM(reg)] = val;
-        break;
-    default:
-        cpu_synchronize_state(cpu);
-        trace_hvf_unhandled_sysreg_write(env->pc, reg,
-                                         SYSREG_OP0(reg),
-                                         SYSREG_OP1(reg),
-                                         SYSREG_CRN(reg),
-                                         SYSREG_CRM(reg),
-                                         SYSREG_OP2(reg));
-        hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
-        return 1;
+        return 0;
     }
 
-    return 0;
+    if (arm_feature(env, ARM_FEATURE_PMU)) {
+        switch (reg) {
+        case SYSREG_PMCCNTR_EL0:
+            pmu_op_start(env);
+            env->cp15.c15_ccnt = val;
+            pmu_op_finish(env);
+            return 0;
+        case SYSREG_PMCR_EL0:
+            pmu_op_start(env);
+
+            if (val & PMCRC) {
+                /* The counter has been reset */
+                env->cp15.c15_ccnt = 0;
+            }
+
+            if (val & PMCRP) {
+                unsigned int i;
+                for (i = 0; i < pmu_num_counters(env); i++) {
+                    env->cp15.c14_pmevcntr[i] = 0;
+                }
+            }
+
+            env->cp15.c9_pmcr &= ~PMCR_WRITABLE_MASK;
+            env->cp15.c9_pmcr |= (val & PMCR_WRITABLE_MASK);
+
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
+    cpu_synchronize_state(cpu);
+    trace_hvf_unhandled_sysreg_write(env->pc, reg,
+                                     SYSREG_OP0(reg),
+                                     SYSREG_OP1(reg),
+                                     SYSREG_CRN(reg),
+                                     SYSREG_CRM(reg),
+                                     SYSREG_OP2(reg));
+    hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+    return 1;
 }
 
 static int hvf_inject_interrupts(CPUState *cpu)
@@ -1944,7 +1942,18 @@ int hvf_vcpu_exec(CPUState *cpu)
         int sysreg_ret = 0;
 
         if (isread) {
-            sysreg_ret = hvf_sysreg_read(cpu, reg, rt);
+            sysreg_ret = hvf_sysreg_read(cpu, reg, rt, &val);
+
+            if (!sysreg_ret) {
+                trace_hvf_sysreg_read(reg,
+                                      SYSREG_OP0(reg),
+                                      SYSREG_OP1(reg),
+                                      SYSREG_CRN(reg),
+                                      SYSREG_CRM(reg),
+                                      SYSREG_OP2(reg),
+                                      val);
+                hvf_set_reg(cpu, rt, val);
+            }
         } else {
             val = hvf_get_reg(cpu, rt);
             sysreg_ret = hvf_sysreg_write(cpu, reg, val);

-- 
2.45.2


