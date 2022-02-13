Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57264B38E1
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 03:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiBMCKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 21:10:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiBMCKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 21:10:22 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31565FF20
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 18:10:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i30so23073201pfk.8
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 18:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fhu1l4FABvpHBSneW96cVCVrV6Q0B9EJKekNgpZAq+s=;
        b=F5BiOWrFvVmvdsZ3+D0ZN7rrWo+PXntvMnlNJOhlfmOERvl3M2s0M/au3zGkj4/1iX
         8FmKYN9mwS5Hb98V0k9tn/M6eYQTk/14sGSctM3Y2CHiZSvS34hzPsHq5L5fLp6dacwe
         hA0lq2Ilx4142Ysdq+hSTapf2k1gQnyxFlwHJtcxaGx4UGcOI5xKKPNc0Dk4UlVb7xth
         jFnSAfdvE0Lmqcq8tixLWC0aXfw9p0c5ClrAfsK/KREVUqVaKUJwepAXzQEpdzbVrbRw
         2bzlcTDiNrJhkbo/Kpj/A3vOwBuKm4K5uGzY1SLoJUkse56CxxQNcYBQ3lmSgVM1qVdx
         bJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fhu1l4FABvpHBSneW96cVCVrV6Q0B9EJKekNgpZAq+s=;
        b=UjzDCHRUCXHLP9+Bba5uxuxe1DlBsiJ4XhV5sNdSdlPJhchcinf9SMlHTJztCJImez
         x5paGRPz/mG/SzdwfAtSsd3+ScE72MI8bwG+QHhyphxo0JBncP42rtNDtFhxtG4WC36v
         Vfzq6t9jdalEI7//QbOlg5YU4YCIJRc351lux9IN49n+1m8l9Ev6wGPOUWaR4G2zmCaJ
         QIO0BJK6IgVVvdBzWqJt7q/P4X7+IidKXrqPZoJpNgp8bkOynMQQ3ow6gZCRrH65lTSG
         cbcH9Bt2PMLvLnbDsfU6HAVHFPc8uWwf2dRZ9gKsTZb1exR0+rCU4ryEn8GK6mPJRibB
         tR/Q==
X-Gm-Message-State: AOAM531YjVWUTx1W3jiHa8g2iBaso/TLToH9UpbXmX6W4RxsvjumFzKS
        5sdTPbeby3BbKgjocUS1GbQ=
X-Google-Smtp-Source: ABdhPJyMKc087fLsAwMU1XfTCNuBaWL+D+8Xd4MbavbGUUYbjCRKfsvrTFw4qgghEBwJJWl2K9zDJQ==
X-Received: by 2002:a62:f207:: with SMTP id m7mr8241612pfh.44.1644718214430;
        Sat, 12 Feb 2022 18:10:14 -0800 (PST)
Received: from localhost.localdomain ([2400:4050:c360:8200:d85b:35dd:dae2:b7a9])
        by smtp.gmail.com with ESMTPSA id h21sm31615566pfv.135.2022.02.12.18.10.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Feb 2022 18:10:14 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>,
        Akihiko Odaki <akihiko.odaki@gmail.com>
Subject: [PATCH] target/arm: Support PSCI 1.1 and SMCCC 1.0
Date:   Sun, 13 Feb 2022 11:10:04 +0900
Message-Id: <20220213021004.1761-1-akihiko.odaki@gmail.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support the latest PSCI on TCG and HVF. It has optional functions and
none of them are implemented. Unimplemented functions now return
NOT_SUPPORTED, which automatically makes TCG compliant to SMC Calling
Convention 1.0.  HVF had already complied to SMCCC 1.0 for the
compatibility with Windows and this change eliminates the inconsistency
between TCG and HVF.

Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
---
 hw/arm/boot.c                  | 12 +++--
 target/arm/cpu.c               |  5 +-
 target/arm/helper.c            |  4 +-
 target/arm/hvf/hvf.c           | 33 +++++++++++--
 target/arm/internals.h         | 29 +++++++++--
 target/arm/kvm-consts.h        |  8 ++-
 target/arm/kvm64.c             |  2 +-
 target/arm/meson.build         |  2 +-
 target/arm/op_helper.c         | 19 +++-----
 target/arm/{psci.c => smccc.c} | 89 +++++++++++++---------------------
 10 files changed, 116 insertions(+), 87 deletions(-)
 rename target/arm/{psci.c => smccc.c} (76%)

diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index 399f8e837ce..0269d2aba03 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -487,9 +487,15 @@ static void fdt_add_psci_node(void *fdt)
     }
 
     qemu_fdt_add_subnode(fdt, "/psci");
-    if (armcpu->psci_version == 2) {
-        const char comp[] = "arm,psci-0.2\0arm,psci";
-        qemu_fdt_setprop(fdt, "/psci", "compatible", comp, sizeof(comp));
+    if (armcpu->psci_version == QEMU_PSCI_VERSION_0_2 ||
+        armcpu->psci_version == QEMU_PSCI_VERSION_1_1) {
+        if (armcpu->psci_version == QEMU_PSCI_VERSION_0_2) {
+            const char comp[] = "arm,psci-0.2\0arm,psci";
+            qemu_fdt_setprop(fdt, "/psci", "compatible", comp, sizeof(comp));
+        } else {
+            const char comp[] = "arm,psci-1.0\0arm,psci-0.2\0arm,psci";
+            qemu_fdt_setprop(fdt, "/psci", "compatible", comp, sizeof(comp));
+        }
 
         cpu_off_fn = QEMU_PSCI_0_2_FN_CPU_OFF;
         if (arm_feature(&armcpu->env, ARM_FEATURE_AARCH64)) {
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index a211804fd3d..e108fb0abb8 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1110,11 +1110,12 @@ static void arm_cpu_initfn(Object *obj)
      * picky DTB consumer will also provide a helpful error message.
      */
     cpu->dtb_compatible = "qemu,unknown";
-    cpu->psci_version = 1; /* By default assume PSCI v0.1 */
+    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
     cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
 
     if (tcg_enabled() || hvf_enabled()) {
-        cpu->psci_version = 2; /* TCG and HVF implement PSCI 0.2 */
+        /* TCG and HVF implement PSCI 1.1 */
+        cpu->psci_version = QEMU_PSCI_VERSION_1_1;
     }
 }
 
diff --git a/target/arm/helper.c b/target/arm/helper.c
index cfca0f5ba6d..f844f4d41f7 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10195,8 +10195,8 @@ void arm_cpu_do_interrupt(CPUState *cs)
                       env->exception.syndrome);
     }
 
-    if (arm_is_psci_call(cpu, cs->exception_index)) {
-        arm_handle_psci_call(cpu);
+    if (arm_is_smccc_call(cpu, cs->exception_index)) {
+        arm_handle_smccc_call(cpu);
         qemu_log_mask(CPU_LOG_INT, "...handled as PSCI call\n");
         return;
     }
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 0dc96560d34..e8ac9a6d14e 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -653,7 +653,7 @@ static bool hvf_handle_psci_call(CPUState *cpu)
 
     switch (param[0]) {
     case QEMU_PSCI_0_2_FN_PSCI_VERSION:
-        ret = QEMU_PSCI_0_2_RET_VERSION_0_2;
+        ret = QEMU_PSCI_VERSION_1_1;
         break;
     case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
         ret = QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED; /* No trusted OS */
@@ -721,6 +721,31 @@ static bool hvf_handle_psci_call(CPUState *cpu)
     case QEMU_PSCI_0_2_FN_MIGRATE:
         ret = QEMU_PSCI_RET_NOT_SUPPORTED;
         break;
+    case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+        switch (param[1]) {
+        case QEMU_PSCI_0_2_FN_PSCI_VERSION:
+        case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+        case QEMU_PSCI_0_2_FN_AFFINITY_INFO:
+        case QEMU_PSCI_0_2_FN64_AFFINITY_INFO:
+        case QEMU_PSCI_0_2_FN_SYSTEM_RESET:
+        case QEMU_PSCI_0_2_FN_SYSTEM_OFF:
+        case QEMU_PSCI_0_1_FN_CPU_ON:
+        case QEMU_PSCI_0_2_FN_CPU_ON:
+        case QEMU_PSCI_0_2_FN64_CPU_ON:
+        case QEMU_PSCI_0_1_FN_CPU_OFF:
+        case QEMU_PSCI_0_2_FN_CPU_OFF:
+        case QEMU_PSCI_0_1_FN_CPU_SUSPEND:
+        case QEMU_PSCI_0_2_FN_CPU_SUSPEND:
+        case QEMU_PSCI_0_2_FN64_CPU_SUSPEND:
+        case QEMU_PSCI_0_1_FN_MIGRATE:
+        case QEMU_PSCI_0_2_FN_MIGRATE:
+        case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+            ret = 0;
+            break;
+        default:
+            ret = QEMU_PSCI_RET_NOT_SUPPORTED;
+        }
+        break;
     default:
         return false;
     }
@@ -1208,8 +1233,7 @@ int hvf_vcpu_exec(CPUState *cpu)
         if (arm_cpu->psci_conduit == QEMU_PSCI_CONDUIT_HVC) {
             if (!hvf_handle_psci_call(cpu)) {
                 trace_hvf_unknown_hvc(env->xregs[0]);
-                /* SMCCC 1.3 section 5.2 says every unknown SMCCC call returns -1 */
-                env->xregs[0] = -1;
+                env->xregs[0] = SMCCC_RET_NOT_SUPPORTED;
             }
         } else {
             trace_hvf_unknown_hvc(env->xregs[0]);
@@ -1223,8 +1247,7 @@ int hvf_vcpu_exec(CPUState *cpu)
 
             if (!hvf_handle_psci_call(cpu)) {
                 trace_hvf_unknown_smc(env->xregs[0]);
-                /* SMCCC 1.3 section 5.2 says every unknown SMCCC call returns -1 */
-                env->xregs[0] = -1;
+                env->xregs[0] = SMCCC_RET_NOT_SUPPORTED;
             }
         } else {
             trace_hvf_unknown_smc(env->xregs[0]);
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 89f7610ebc5..a6f143b3e13 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -306,20 +306,39 @@ vaddr arm_adjust_watchpoint_address(CPUState *cs, vaddr addr, int len);
 /* Callback function for when a watchpoint or breakpoint triggers. */
 void arm_debug_excp_handler(CPUState *cs);
 
+/* ARM DEN 0028B section 5.2 says every unknown SMCCC call returns -1 */
+#define SMCCC_RET_NOT_SUPPORTED -1
+
 #if defined(CONFIG_USER_ONLY) || !defined(CONFIG_TCG)
-static inline bool arm_is_psci_call(ARMCPU *cpu, int excp_type)
+static inline bool arm_is_smccc_call(ARMCPU *cpu, int excp_type)
 {
     return false;
 }
-static inline void arm_handle_psci_call(ARMCPU *cpu)
+static inline void arm_handle_smccc_call(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
 #else
 /* Return true if the r0/x0 value indicates that this SMC/HVC is a PSCI call. */
-bool arm_is_psci_call(ARMCPU *cpu, int excp_type);
-/* Actually handle a PSCI call */
-void arm_handle_psci_call(ARMCPU *cpu);
+static inline bool arm_is_smccc_call(ARMCPU *cpu, int excp_type)
+{
+    /* Return true if the exception type matches the configured PSCI conduit.
+     * This is called before the SMC/HVC instruction is executed, to decide
+     * whether we should treat it as a SMCCC-compliant call or with the
+     * architecturally defined behaviour for an SMC or HVC (which might be
+     * UNDEF or trap to EL2 or to EL3).
+     */
+    switch (excp_type) {
+    case EXCP_HVC:
+        return cpu->psci_conduit == QEMU_PSCI_CONDUIT_HVC;
+    case EXCP_SMC:
+        return cpu->psci_conduit == QEMU_PSCI_CONDUIT_SMC;
+    default:
+        return false;
+    }
+}
+/* Actually handle a SMCCC-compliant call */
+void arm_handle_smccc_call(ARMCPU *cpu);
 #endif
 
 /**
diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 580f1c1fee0..ee877aa3a5c 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -77,6 +77,8 @@ MISMATCH_CHECK(QEMU_PSCI_0_1_FN_MIGRATE, KVM_PSCI_FN_MIGRATE);
 #define QEMU_PSCI_0_2_FN64_AFFINITY_INFO QEMU_PSCI_0_2_FN64(4)
 #define QEMU_PSCI_0_2_FN64_MIGRATE QEMU_PSCI_0_2_FN64(5)
 
+#define QEMU_PSCI_1_0_FN_PSCI_FEATURES QEMU_PSCI_0_2_FN(10)
+
 MISMATCH_CHECK(QEMU_PSCI_0_2_FN_CPU_SUSPEND, PSCI_0_2_FN_CPU_SUSPEND);
 MISMATCH_CHECK(QEMU_PSCI_0_2_FN_CPU_OFF, PSCI_0_2_FN_CPU_OFF);
 MISMATCH_CHECK(QEMU_PSCI_0_2_FN_CPU_ON, PSCI_0_2_FN_CPU_ON);
@@ -84,14 +86,16 @@ MISMATCH_CHECK(QEMU_PSCI_0_2_FN_MIGRATE, PSCI_0_2_FN_MIGRATE);
 MISMATCH_CHECK(QEMU_PSCI_0_2_FN64_CPU_SUSPEND, PSCI_0_2_FN64_CPU_SUSPEND);
 MISMATCH_CHECK(QEMU_PSCI_0_2_FN64_CPU_ON, PSCI_0_2_FN64_CPU_ON);
 MISMATCH_CHECK(QEMU_PSCI_0_2_FN64_MIGRATE, PSCI_0_2_FN64_MIGRATE);
+MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 
 /* PSCI v0.2 return values used by TCG emulation of PSCI */
 
 /* No Trusted OS migration to worry about when offlining CPUs */
 #define QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED        2
 
-/* We implement version 0.2 only */
-#define QEMU_PSCI_0_2_RET_VERSION_0_2                       2
+#define QEMU_PSCI_VERSION_0_1                     0x00001
+#define QEMU_PSCI_VERSION_0_2                     0x00002
+#define QEMU_PSCI_VERSION_1_1                     0x10001
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_VERSION_0_2,
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index e790d6c9a57..8adefb3434a 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -847,7 +847,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
     if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
-        cpu->psci_version = 2;
+        cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 50f152214af..c71624d7f30 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -57,7 +57,7 @@ arm_softmmu_ss.add(files(
   'arm-powerctl.c',
   'machine.c',
   'monitor.c',
-  'psci.c',
+  'smccc.c',
 ))
 
 subdir('hvf')
diff --git a/target/arm/op_helper.c b/target/arm/op_helper.c
index 70b42b55fd0..3e2173e49cc 100644
--- a/target/arm/op_helper.c
+++ b/target/arm/op_helper.c
@@ -778,9 +778,9 @@ void HELPER(pre_hvc)(CPUARMState *env)
     bool secure = false;
     bool undef;
 
-    if (arm_is_psci_call(cpu, EXCP_HVC)) {
-        /* If PSCI is enabled and this looks like a valid PSCI call then
-         * that overrides the architecturally mandated HVC behaviour.
+    if (arm_is_smccc_call(cpu, EXCP_HVC)) {
+        /* If SMCCC is supported then that overrides the architecturally
+         * mandated HVC behaviour.
          */
         return;
     }
@@ -826,24 +826,21 @@ void HELPER(pre_smc)(CPUARMState *env, uint32_t syndrome)
      *  -> ARM_FEATURE_EL3 and !SMD
      *                           HCR_TSC && NS EL1   !HCR_TSC || !NS EL1
      *
-     *  Conduit SMC, valid call  Trap to EL2         PSCI Call
-     *  Conduit SMC, inval call  Trap to EL2         Trap to EL3
+     *  Conduit SMC              Trap to EL2         SMCCC-compliant Call
      *  Conduit not SMC          Trap to EL2         Trap to EL3
      *
      *
      *  -> ARM_FEATURE_EL3 and SMD
      *                           HCR_TSC && NS EL1   !HCR_TSC || !NS EL1
      *
-     *  Conduit SMC, valid call  Trap to EL2         PSCI Call
-     *  Conduit SMC, inval call  Trap to EL2         Undef insn
+     *  Conduit SMC              Trap to EL2         SMCCC-compliant Call
      *  Conduit not SMC          Trap to EL2         Undef insn
      *
      *
      *  -> !ARM_FEATURE_EL3
      *                           HCR_TSC && NS EL1   !HCR_TSC || !NS EL1
      *
-     *  Conduit SMC, valid call  Trap to EL2         PSCI Call
-     *  Conduit SMC, inval call  Trap to EL2         Undef insn
+     *  Conduit SMC              Trap to EL2         SMCCC-compliant Call
      *  Conduit not SMC          Undef insn          Undef insn
      */
 
@@ -881,10 +878,10 @@ void HELPER(pre_smc)(CPUARMState *env, uint32_t syndrome)
     }
 
     /* Catch the two remaining "Undef insn" cases of the previous table:
-     *    - PSCI conduit is SMC but we don't have a valid PCSI call,
+     *    - SMCCC conduit is SMC but we don't have a valid SMCCC-compliant call,
      *    - We don't have EL3 or SMD is set.
      */
-    if (!arm_is_psci_call(cpu, EXCP_SMC) &&
+    if (!arm_is_smccc_call(cpu, EXCP_SMC) &&
         (smd || !arm_feature(env, ARM_FEATURE_EL3))) {
         raise_exception(env, EXCP_UDEF, syn_uncategorized(),
                         exception_target_el(env));
diff --git a/target/arm/psci.c b/target/arm/smccc.c
similarity index 76%
rename from target/arm/psci.c
rename to target/arm/smccc.c
index 6709e280133..ce3f608ee3e 100644
--- a/target/arm/psci.c
+++ b/target/arm/smccc.c
@@ -25,61 +25,11 @@
 #include "internals.h"
 #include "arm-powerctl.h"
 
-bool arm_is_psci_call(ARMCPU *cpu, int excp_type)
-{
-    /* Return true if the r0/x0 value indicates a PSCI call and
-     * the exception type matches the configured PSCI conduit. This is
-     * called before the SMC/HVC instruction is executed, to decide whether
-     * we should treat it as a PSCI call or with the architecturally
-     * defined behaviour for an SMC or HVC (which might be UNDEF or trap
-     * to EL2 or to EL3).
-     */
-    CPUARMState *env = &cpu->env;
-    uint64_t param = is_a64(env) ? env->xregs[0] : env->regs[0];
-
-    switch (excp_type) {
-    case EXCP_HVC:
-        if (cpu->psci_conduit != QEMU_PSCI_CONDUIT_HVC) {
-            return false;
-        }
-        break;
-    case EXCP_SMC:
-        if (cpu->psci_conduit != QEMU_PSCI_CONDUIT_SMC) {
-            return false;
-        }
-        break;
-    default:
-        return false;
-    }
-
-    switch (param) {
-    case QEMU_PSCI_0_2_FN_PSCI_VERSION:
-    case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
-    case QEMU_PSCI_0_2_FN_AFFINITY_INFO:
-    case QEMU_PSCI_0_2_FN64_AFFINITY_INFO:
-    case QEMU_PSCI_0_2_FN_SYSTEM_RESET:
-    case QEMU_PSCI_0_2_FN_SYSTEM_OFF:
-    case QEMU_PSCI_0_1_FN_CPU_ON:
-    case QEMU_PSCI_0_2_FN_CPU_ON:
-    case QEMU_PSCI_0_2_FN64_CPU_ON:
-    case QEMU_PSCI_0_1_FN_CPU_OFF:
-    case QEMU_PSCI_0_2_FN_CPU_OFF:
-    case QEMU_PSCI_0_1_FN_CPU_SUSPEND:
-    case QEMU_PSCI_0_2_FN_CPU_SUSPEND:
-    case QEMU_PSCI_0_2_FN64_CPU_SUSPEND:
-    case QEMU_PSCI_0_1_FN_MIGRATE:
-    case QEMU_PSCI_0_2_FN_MIGRATE:
-        return true;
-    default:
-        return false;
-    }
-}
-
-void arm_handle_psci_call(ARMCPU *cpu)
+void arm_handle_smccc_call(ARMCPU *cpu)
 {
     /*
      * This function partially implements the logic for dispatching Power State
-     * Coordination Interface (PSCI) calls (as described in ARM DEN 0022B.b),
+     * Coordination Interface (PSCI) calls (as described in ARM DEN 0022D.b),
      * to the extent required for bringing up and taking down secondary cores,
      * and for handling reset and poweroff requests.
      * Additional information about the calling convention used is available in
@@ -102,7 +52,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
     }
 
     if ((param[0] & QEMU_PSCI_0_2_64BIT) && !is_a64(env)) {
-        ret = QEMU_PSCI_RET_INVALID_PARAMS;
+        ret = SMCCC_RET_NOT_SUPPORTED;
         goto err;
     }
 
@@ -111,7 +61,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
         ARMCPU *target_cpu;
 
     case QEMU_PSCI_0_2_FN_PSCI_VERSION:
-        ret = QEMU_PSCI_0_2_RET_VERSION_0_2;
+        ret = QEMU_PSCI_VERSION_1_1;
         break;
     case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
         ret = QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED; /* No trusted OS */
@@ -196,8 +146,37 @@ void arm_handle_psci_call(ARMCPU *cpu)
     case QEMU_PSCI_0_2_FN_MIGRATE:
         ret = QEMU_PSCI_RET_NOT_SUPPORTED;
         break;
+    case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+        switch (param[1]) {
+        case QEMU_PSCI_0_2_FN_PSCI_VERSION:
+        case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+        case QEMU_PSCI_0_2_FN_AFFINITY_INFO:
+        case QEMU_PSCI_0_2_FN64_AFFINITY_INFO:
+        case QEMU_PSCI_0_2_FN_SYSTEM_RESET:
+        case QEMU_PSCI_0_2_FN_SYSTEM_OFF:
+        case QEMU_PSCI_0_1_FN_CPU_ON:
+        case QEMU_PSCI_0_2_FN_CPU_ON:
+        case QEMU_PSCI_0_2_FN64_CPU_ON:
+        case QEMU_PSCI_0_1_FN_CPU_OFF:
+        case QEMU_PSCI_0_2_FN_CPU_OFF:
+        case QEMU_PSCI_0_1_FN_CPU_SUSPEND:
+        case QEMU_PSCI_0_2_FN_CPU_SUSPEND:
+        case QEMU_PSCI_0_2_FN64_CPU_SUSPEND:
+        case QEMU_PSCI_0_1_FN_MIGRATE:
+        case QEMU_PSCI_0_2_FN_MIGRATE:
+        case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+            if (!(param[1] & QEMU_PSCI_0_2_64BIT) || is_a64(env)) {
+                ret = 0;
+                break;
+            }
+            /* fallthrough */
+        default:
+            ret = QEMU_PSCI_RET_NOT_SUPPORTED;
+            break;
+        }
+        break;
     default:
-        g_assert_not_reached();
+        ret = SMCCC_RET_NOT_SUPPORTED;
     }
 
 err:
-- 
2.32.0 (Apple Git-132)

