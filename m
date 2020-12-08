Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDC72D1F10
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgLHAhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgLHAhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:37:52 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD71C0617B0
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:11 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ga15so22187456ejb.4
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3nQ2rq5dw00RN3ISHz847HNPzVTdJvTY+D4+K8lpZUM=;
        b=O6uCHU2nt9XOgHKby483Y1sNEgW9zJgaE8hSa8WQWYgH66G6t7hlJbK2MH5lk+LFwN
         o1Qlnt2501GAvmbCTl7B9MwtCzBVK2TpKTFypwDbmjxFe/y30J0jJ28WlsC8JaQSZIxH
         ocj81ieDaVgREldsWZrOdhUoAA+9W2hnZIHaaMSPktKI0OA9S+CI3vSEmfkGucYVgYJZ
         eA2PV7Cn4wmwQKMIcKsdsIlIf1s0wkcGBZFrBKkbNITyizVDfx5rGyGy/4HMycsqtXsi
         lobwTUTDvEGqNjiePtcpkVKjn2hHm7v18PMFCV3r6PwO9oEDKyKPshn/QIGF5RyjO2Dt
         izow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3nQ2rq5dw00RN3ISHz847HNPzVTdJvTY+D4+K8lpZUM=;
        b=P7RFETfuaRh83EpAc6Ewlj/Ret+opTXSs64TRDX9PQR7GF2EYnKKcned6o1CrO99zH
         QhPc/5FymJPspA8tCpLgtslo0+r7Mn86aI2cyR0umDDNYjfdbHJXtjZtf322yec+2XmT
         Sna1dQckgrxn3ugqyN8xzmdCS4aw+G0NbWCosUC0naN6aFotF7ldlnMuxBfGr+VK78Yd
         htN5h35ZpSTp4ycm/df8uSq3pNTtaFb9i4ozUTEWFN/v1L1kce0Sdmx0eVNhGQS0BQPV
         XwxUO0rtLwQaEH8kUgmnUY3a32j1xDaix5Rgq5VDokeoXaIOOy8A6RIJLnnuBF6dTh1C
         fJww==
X-Gm-Message-State: AOAM5300gFy+0HFwF1UE4PN+yHSpSaqkhpqZ+iK9d9vbRYXduUpdi1nV
        2TYtVz5VQkD6DB62A7i0cLM=
X-Google-Smtp-Source: ABdhPJxMESd4QPMEdVDiXLWmRmAHveLm75pKdNMT0gidZNPbzqokGnxte7sQEw5ftElnbdGNm96S1Q==
X-Received: by 2002:a17:906:a106:: with SMTP id t6mr21575903ejy.63.1607387830419;
        Mon, 07 Dec 2020 16:37:10 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id x15sm15114272edj.91.2020.12.07.16.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:09 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 01/17] target/mips: Introduce ase_msa_available() helper
Date:   Tue,  8 Dec 2020 01:36:46 +0100
Message-Id: <20201208003702.4088927-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of accessing CP0_Config3 directly and checking
the 'MSA Present' bit, introduce an explicit helper,
making the code easier to read.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.h       |  6 ++++++
 target/mips/kvm.c       | 12 ++++++------
 target/mips/translate.c |  8 +++-----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 7b3ff2fd6fb..6d4c8d63930 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1296,6 +1296,12 @@ int cpu_mips_signal_handler(int host_signum, void *pinfo, void *puc);
 bool cpu_supports_cps_smp(const char *cpu_type);
 bool cpu_supports_isa(const char *cpu_type, uint64_t isa);
 
+/* Check presence of MSA implementation */
+static inline bool ase_msa_available(CPUMIPSState *env)
+{
+    return env->CP0_Config3 & (1 << CP0C3_MSAP);
+}
+
 /* Check presence of multi-threading ASE implementation */
 static inline bool ase_mt_available(CPUMIPSState *env)
 {
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 3ca3a0da93f..c511a1303c6 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -82,7 +82,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
-    if (kvm_mips_msa_cap && env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (kvm_mips_msa_cap && ase_msa_available(env)) {
         ret = kvm_vcpu_enable_cap(cs, KVM_CAP_MIPS_MSA, 0, 0);
         if (ret < 0) {
             /* mark unsupported so it gets disabled on reset */
@@ -108,7 +108,7 @@ void kvm_mips_reset_vcpu(MIPSCPU *cpu)
         warn_report("KVM does not support FPU, disabling");
         env->CP0_Config1 &= ~(1 << CP0C1_FP);
     }
-    if (!kvm_mips_msa_cap && env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (!kvm_mips_msa_cap && ase_msa_available(env)) {
         warn_report("KVM does not support MSA, disabling");
         env->CP0_Config3 &= ~(1 << CP0C3_MSAP);
     }
@@ -621,7 +621,7 @@ static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
          * FPU register state is a subset of MSA vector state, so don't put FPU
          * registers if we're emulating a CPU with MSA.
          */
-        if (!(env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if (!ase_msa_available(env)) {
             /* Floating point registers */
             for (i = 0; i < 32; ++i) {
                 if (env->CP0_Status & (1 << CP0St_FR)) {
@@ -640,7 +640,7 @@ static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
     }
 
     /* Only put MSA state if we're emulating a CPU with MSA */
-    if (env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (ase_msa_available(env)) {
         /* MSA Control Registers */
         if (level == KVM_PUT_FULL_STATE) {
             err = kvm_mips_put_one_reg(cs, KVM_REG_MIPS_MSA_IR,
@@ -701,7 +701,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
          * FPU register state is a subset of MSA vector state, so don't save FPU
          * registers if we're emulating a CPU with MSA.
          */
-        if (!(env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if (!ase_msa_available(env)) {
             /* Floating point registers */
             for (i = 0; i < 32; ++i) {
                 if (env->CP0_Status & (1 << CP0St_FR)) {
@@ -720,7 +720,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
     }
 
     /* Only get MSA state if we're emulating a CPU with MSA */
-    if (env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (ase_msa_available(env)) {
         /* MSA Control Registers */
         err = kvm_mips_get_one_reg(cs, KVM_REG_MIPS_MSA_IR,
                                    &env->msair);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 80c9c17819f..cb822e52c4b 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -24928,8 +24928,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         gen_trap(ctx, op1, rs, rt, -1);
         break;
     case OPC_LSA: /* OPC_PMON */
-        if ((ctx->insn_flags & ISA_MIPS32R6) ||
-            (env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if ((ctx->insn_flags & ISA_MIPS32R6) || ase_msa_available(env)) {
             decode_opc_special_r6(env, ctx);
         } else {
             /* Pmon entry point, also R4010 selsl */
@@ -25031,8 +25030,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case OPC_DLSA:
-        if ((ctx->insn_flags & ISA_MIPS32R6) ||
-            (env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if ((ctx->insn_flags & ISA_MIPS32R6) || ase_msa_available(env)) {
             decode_opc_special_r6(env, ctx);
         }
         break;
@@ -31879,7 +31877,7 @@ void cpu_state_reset(CPUMIPSState *env)
     }
 
     /* MSA */
-    if (env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (ase_msa_available(env)) {
         msa_reset(env);
     }
 
-- 
2.26.2

