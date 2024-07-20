Return-Path: <kvm+bounces-22009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B36F2938076
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6ADC1C20AC5
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD257FBDD;
	Sat, 20 Jul 2024 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="TSl9s2Mi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD6876034
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467888; cv=none; b=na63gk7gont9LF1CMDCqeaneASz73trTYTrclZg2/xF0PNKQEMHsvsRfgvQA4Q5TWU6K57hO1YAYdqW9DhewTI5PoeTPJTfZAP46rZKU6iGKpeO/M2Wu86oiwT6VPF5E88vLlqxhB7miGTIWCIa/At+95bjQ+Z72tWvrVVsqBC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467888; c=relaxed/simple;
	bh=pFdmGOsXnNL9jY7lXR47yIRG8HPGtYn5D0ALUwzKE78=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aoTiqv9om0fK2GPBwzuRk3vJL6qr+XTQ2fY9Uyz4KDt7X9InpYmosbVFplsVNzBEPVzyEmWmtU357O4lbTxhg3/DxQZ3epE4P1UqL3clx4iUivFBUJfs5N56kY6onLJLOhGOq5oscz4yibAWaF9+qGTCuFxCxGJGt+z8L2swm00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=TSl9s2Mi; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2caaae31799so1644603a91.0
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467886; x=1722072686; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zyb9AANp083iaNY8Z+adG9wP/HNnG5GrtOuS/kU6QUk=;
        b=TSl9s2Mi2xpeaAmd4mxXmbDbz3d9VhuFDTVSuwF4jCG1R+hfiszTuAewHpNH9Hwn+R
         a4G8Z7frUFNeVLRbJIj+hCu6+jK68WwdQg2fN6n1EQQiYE4Nh5kpUN07m37E1Yb2lURs
         sG7L7YVKJ+ppLTi+q2z+wxyXi38Y4VaBhT+31RzceiEOI2F2v5qcU2AX6UX5dP29olXc
         UKD3N7CEBmkdGG/97TRtN/bopy6Q+GCwUGJECbTaSCmYWOuWXDR4ByXZeLabPbR5ntY5
         AQr4FlciLUj6ei04wYlWOvw+O8M0z46IwLDa5pOUu+LuwSINSM9LkQFNFLtmhCShw5n3
         9VKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467886; x=1722072686;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyb9AANp083iaNY8Z+adG9wP/HNnG5GrtOuS/kU6QUk=;
        b=oNe6i8Sx02sg1bURxUq6Xk+Bwa32V8MmXGZUGSrLgx5aon4vwqyooA1RSDMFiVCjyB
         U2TfuLWF+Y4vJXBargZj8vwNy/8J5p6YGjU6qE+JGnm0+P3PgU8VHCKgqIGLdOrQOuhT
         5xB5Ic9awq9uL9d0wGMD0DV7S7n+1Vewl30GefAsQEnsWqErZo/rAz1hn5/E76GDZX2g
         YqTS/wLXJ55+g9rXKx9me97kTPLju3DDSTDg0aCUofek6U2L9bcTGVkm+m/sCZLye/2w
         AwGhxxwJmQl0u2fSh/ah9BS33BsGWiLQYxJWqktC2syE9lmKZT7WkzTGwmDIzX4ILt4y
         cJ4A==
X-Forwarded-Encrypted: i=1; AJvYcCU8+L4S4qQzAcSBQtXWmB/nJT2NmXETLnyLhVV9r4J/Si2/dZ8bkek+zyEUaz1PiLO4tuiR1wEB5EetemMzy3EjnHXZ
X-Gm-Message-State: AOJu0YziGadrXFCBm21Q4WtB5ncUK0vlnAJiR8WIEo+sIvypJ0D3Cxbu
	614d9jGU7QzcP4OB2F536jDdc1cqqjGezunIa8F8F4cWqwGNMB7jRlJrPgwICN0=
X-Google-Smtp-Source: AGHT+IFLK7YAa8KVAxsj8+pIl37nqSE3PlIwtNlg+Ie+K7ixATPTr/4qrNsV0Adtr+FdH2XvbPWsOg==
X-Received: by 2002:a17:90a:5993:b0:2c9:5f45:5d26 with SMTP id 98e67ed59e1d1-2cd27432453mr681429a91.19.1721467886441;
        Sat, 20 Jul 2024 02:31:26 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2ccf7c5391bsm3130441a91.24.2024.07.20.02.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:26 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 20 Jul 2024 18:30:52 +0900
Subject: [PATCH v4 4/6] hvf: arm: Raise an exception for sysreg by default
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240720-pmu-v4-4-2a2b28f6b08f@daynix.com>
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

Any sysreg access results in an exception unless defined otherwise so
we should raise an exception by default.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/hvf/hvf.c | 174 +++++++++++++++++++++++++--------------------------
 1 file changed, 85 insertions(+), 89 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index eb090e67a2f8..1a749534fb0d 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1199,57 +1199,56 @@ static bool hvf_sysreg_read_cp(CPUState *cpu, uint32_t reg, uint64_t *val)
     return false;
 }
 
-static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
+static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint64_t *val)
 {
     ARMCPU *arm_cpu = ARM_CPU(cpu);
     CPUARMState *env = &arm_cpu->env;
-    uint64_t val = 0;
 
     switch (reg) {
     case SYSREG_CNTPCT_EL0:
-        val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
+        *val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
               gt_cntfrq_period_ns(arm_cpu);
-        break;
+        return 0;
     case SYSREG_PMCR_EL0:
-        val = env->cp15.c9_pmcr;
-        break;
+        *val = env->cp15.c9_pmcr;
+        return 0;
     case SYSREG_PMCCNTR_EL0:
         pmu_op_start(env);
-        val = env->cp15.c15_ccnt;
+        *val = env->cp15.c15_ccnt;
         pmu_op_finish(env);
-        break;
+        return 0;
     case SYSREG_PMCNTENCLR_EL0:
-        val = env->cp15.c9_pmcnten;
-        break;
+        *val = env->cp15.c9_pmcnten;
+        return 0;
     case SYSREG_PMOVSCLR_EL0:
-        val = env->cp15.c9_pmovsr;
-        break;
+        *val = env->cp15.c9_pmovsr;
+        return 0;
     case SYSREG_PMSELR_EL0:
-        val = env->cp15.c9_pmselr;
-        break;
+        *val = env->cp15.c9_pmselr;
+        return 0;
     case SYSREG_PMINTENCLR_EL1:
-        val = env->cp15.c9_pminten;
-        break;
+        *val = env->cp15.c9_pminten;
+        return 0;
     case SYSREG_PMCCFILTR_EL0:
-        val = env->cp15.pmccfiltr_el0;
-        break;
+        *val = env->cp15.pmccfiltr_el0;
+        return 0;
     case SYSREG_PMCNTENSET_EL0:
-        val = env->cp15.c9_pmcnten;
-        break;
+        *val = env->cp15.c9_pmcnten;
+        return 0;
     case SYSREG_PMUSERENR_EL0:
-        val = env->cp15.c9_pmuserenr;
-        break;
+        *val = env->cp15.c9_pmuserenr;
+        return 0;
     case SYSREG_PMCEID0_EL0:
     case SYSREG_PMCEID1_EL0:
         /* We can't really count anything yet, declare all events invalid */
-        val = 0;
-        break;
+        *val = 0;
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
@@ -1276,9 +1275,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_ICC_SRE_EL1:
     case SYSREG_ICC_CTLR_EL1:
         /* Call the TCG sysreg handler. This is only safe for GICv3 regs. */
-        if (!hvf_sysreg_read_cp(cpu, reg, &val)) {
-            hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
-            return 1;
+        if (hvf_sysreg_read_cp(cpu, reg, &val)) {
+            return 0;
         }
         break;
     case SYSREG_DBGBVR0_EL1:
@@ -1297,8 +1295,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
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
@@ -1315,8 +1313,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
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
@@ -1333,8 +1331,8 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
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
@@ -1351,35 +1349,25 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint32_t rt)
     case SYSREG_DBGWCR13_EL1:
     case SYSREG_DBGWCR14_EL1:
     case SYSREG_DBGWCR15_EL1:
-        val = env->cp15.dbgwcr[SYSREG_CRM(reg)];
-        break;
+        *val = env->cp15.dbgwcr[SYSREG_CRM(reg)];
+        return 0;
     default:
         if (is_id_sysreg(reg)) {
             /* ID system registers read as RES0 */
-            val = 0;
-            break;
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
     }
 
-    trace_hvf_sysreg_read(reg,
-                          SYSREG_OP0(reg),
-                          SYSREG_OP1(reg),
-                          SYSREG_CRN(reg),
-                          SYSREG_CRM(reg),
-                          SYSREG_OP2(reg),
-                          val);
-    hvf_set_reg(cpu, rt, val);
-
-    return 0;
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
@@ -1503,7 +1491,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
         pmu_op_start(env);
         env->cp15.c15_ccnt = val;
         pmu_op_finish(env);
-        break;
+        return 0;
     case SYSREG_PMCR_EL0:
         pmu_op_start(env);
 
@@ -1523,45 +1511,45 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
         env->cp15.c9_pmcr |= (val & PMCR_WRITABLE_MASK);
 
         pmu_op_finish(env);
-        break;
+        return 0;
     case SYSREG_PMUSERENR_EL0:
         env->cp15.c9_pmuserenr = val & 0xf;
-        break;
+        return 0;
     case SYSREG_PMCNTENSET_EL0:
         env->cp15.c9_pmcnten |= (val & pmu_counter_mask(env));
-        break;
+        return 0;
     case SYSREG_PMCNTENCLR_EL0:
         env->cp15.c9_pmcnten &= ~(val & pmu_counter_mask(env));
-        break;
+        return 0;
     case SYSREG_PMINTENCLR_EL1:
         pmu_op_start(env);
         env->cp15.c9_pminten |= val;
         pmu_op_finish(env);
-        break;
+        return 0;
     case SYSREG_PMOVSCLR_EL0:
         pmu_op_start(env);
         env->cp15.c9_pmovsr &= ~val;
         pmu_op_finish(env);
-        break;
+        return 0;
     case SYSREG_PMSWINC_EL0:
         pmu_op_start(env);
         pmswinc_write(env, val);
         pmu_op_finish(env);
-        break;
+        return 0;
     case SYSREG_PMSELR_EL0:
         env->cp15.c9_pmselr = val & 0x1f;
-        break;
+        return 0;
     case SYSREG_PMCCFILTR_EL0:
         pmu_op_start(env);
         env->cp15.pmccfiltr_el0 = val & PMCCFILTR_EL0;
         pmu_op_finish(env);
-        break;
+        return 0;
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
@@ -1591,10 +1579,10 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
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
@@ -1612,7 +1600,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGBVR14_EL1:
     case SYSREG_DBGBVR15_EL1:
         env->cp15.dbgbvr[SYSREG_CRM(reg)] = val;
-        break;
+        return 0;
     case SYSREG_DBGBCR0_EL1:
     case SYSREG_DBGBCR1_EL1:
     case SYSREG_DBGBCR2_EL1:
@@ -1630,7 +1618,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGBCR14_EL1:
     case SYSREG_DBGBCR15_EL1:
         env->cp15.dbgbcr[SYSREG_CRM(reg)] = val;
-        break;
+        return 0;
     case SYSREG_DBGWVR0_EL1:
     case SYSREG_DBGWVR1_EL1:
     case SYSREG_DBGWVR2_EL1:
@@ -1648,7 +1636,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_DBGWVR14_EL1:
     case SYSREG_DBGWVR15_EL1:
         env->cp15.dbgwvr[SYSREG_CRM(reg)] = val;
-        break;
+        return 0;
     case SYSREG_DBGWCR0_EL1:
     case SYSREG_DBGWCR1_EL1:
     case SYSREG_DBGWCR2_EL1:
@@ -1666,20 +1654,18 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
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
@@ -1944,7 +1930,17 @@ int hvf_vcpu_exec(CPUState *cpu)
         int sysreg_ret = 0;
 
         if (isread) {
-            sysreg_ret = hvf_sysreg_read(cpu, reg, rt);
+            sysreg_ret = hvf_sysreg_read(cpu, reg, &val);
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


