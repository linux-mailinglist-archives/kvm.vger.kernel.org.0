Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED33A4B3946
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 04:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiBMD6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 22:58:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBMD6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 22:58:05 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945EA5F27C
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 19:58:00 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id f6so2350169pfj.11
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 19:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hgKkhyGa1MZG+6xTJAHxPgWUd5NWDxfubWdlwv7McIM=;
        b=NOain2WZKo0UUaeoGAXjeJSPdxoXs4d9np2wGC3boKhJUSsooQtcMosFPYDy4scrBR
         F8Tr/IEQCouXe2lKM1fuEA1a0fX7bi5AjiXimIc3A7drox1lntoZRmSn0o/fv9WgQsB9
         33BaM08X7nrBWuG43a6ZL3uJqNt6L/fjLJ/9xmLADAebFTEgVR1cXWDjlaykiaOlbti6
         z5XrGzYbWv7sebEna2sDCmYpZU31GeEc40R1EBPSHzPuPHWaP4DcmFEI/OFv8bzqO92e
         /LWawO1QInloMR5suHGFrSdytiWyHIqIWMjA2yBxPiDPXrVqSc9GBI1CYUF8IS5yQ+ll
         DePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hgKkhyGa1MZG+6xTJAHxPgWUd5NWDxfubWdlwv7McIM=;
        b=kAvqi5/KIZzvNXvQv0l6NorVpryVGdw19mXL//xNUivvjPyQNHl2rGoQY/ha9rcDuD
         SquS5MIk6A1jfGmXMyvkFK27S5DlT6zy3jAbxSsZJvnJiTDQNc4DbUoRQ3YqM5kAw/hQ
         OATNTwFqwpaSYbHE/cLDTb1lUaGQ4PHNKrbL52hmaFaBqMWxLVeRAjKX0SE+1sBmWnVx
         0xBcOTVzs3QuGAOhbvYZaP/oVPPhXpZ8mhvcvd9t9JIZTqSnHanIQLM1KjIFQCIHSmLc
         knb/Dftt4uPpcLORqMBd+07+uLXrgMzu0fA7MzIdJAiRNm9CRkykNRpL11o6zzzhd0PK
         ldBg==
X-Gm-Message-State: AOAM532QgIjED/075CTSi2j1XfI7p9SVw+yDkqYqyX9eTidkFNFulHqb
        tSH2+z6X5PipZJsschWz7lI=
X-Google-Smtp-Source: ABdhPJw2G3smK0LBb39I+7ai6hgAuT0MeP2q1eIerdxt5RVKc98MbH5eE7FqeOJCz/he/50AEigR5A==
X-Received: by 2002:a63:6a87:: with SMTP id f129mr7042808pgc.0.1644724680089;
        Sat, 12 Feb 2022 19:58:00 -0800 (PST)
Received: from localhost.localdomain ([2400:4050:c360:8200:d85b:35dd:dae2:b7a9])
        by smtp.gmail.com with ESMTPSA id u13sm33581348pfg.151.2022.02.12.19.57.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Feb 2022 19:57:59 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>,
        Akihiko Odaki <akihiko.odaki@gmail.com>
Subject: [PATCH v2] target/arm: Support PSCI 1.1 and SMCCC 1.0
Date:   Sun, 13 Feb 2022 12:57:53 +0900
Message-Id: <20220213035753.34577-1-akihiko.odaki@gmail.com>
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

Support the latest PSCI on TCG and HVF. A 64-bit function called from
AArch32 now returns NOT_SUPPORTED, which is necessary to adhere to SMC
Calling Convention 1.0. It is still not compliant with SMCCC 1.3 since
they do not implement mandatory functions.

Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
---
 hw/arm/boot.c           | 12 +++++++++---
 target/arm/cpu.c        |  5 +++--
 target/arm/hvf/hvf.c    | 27 ++++++++++++++++++++++++++-
 target/arm/kvm-consts.h |  8 ++++++--
 target/arm/kvm64.c      |  2 +-
 target/arm/psci.c       | 35 ++++++++++++++++++++++++++++++++---
 6 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index b1e95978f26..0eeef94ceb5 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -488,9 +488,15 @@ static void fdt_add_psci_node(void *fdt)
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
index 5a9c02a2561..307a83a7bb6 100644
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
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 0dc96560d34..1701fb8bbdb 100644
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
+        case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+            ret = 0;
+            break;
+        case QEMU_PSCI_0_1_FN_MIGRATE:
+        case QEMU_PSCI_0_2_FN_MIGRATE:
+        default:
+            ret = QEMU_PSCI_RET_NOT_SUPPORTED;
+        }
+        break;
     default:
         return false;
     }
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
index 71c3ca69717..64d48bfb19d 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -864,7 +864,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
     if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
-        cpu->psci_version = 2;
+        cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
diff --git a/target/arm/psci.c b/target/arm/psci.c
index b279c0b9a45..6c1239bb968 100644
--- a/target/arm/psci.c
+++ b/target/arm/psci.c
@@ -57,7 +57,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
 {
     /*
      * This function partially implements the logic for dispatching Power State
-     * Coordination Interface (PSCI) calls (as described in ARM DEN 0022B.b),
+     * Coordination Interface (PSCI) calls (as described in ARM DEN 0022D.b),
      * to the extent required for bringing up and taking down secondary cores,
      * and for handling reset and poweroff requests.
      * Additional information about the calling convention used is available in
@@ -80,7 +80,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
     }
 
     if ((param[0] & QEMU_PSCI_0_2_64BIT) && !is_a64(env)) {
-        ret = QEMU_PSCI_RET_INVALID_PARAMS;
+        ret = QEMU_PSCI_RET_NOT_SUPPORTED;
         goto err;
     }
 
@@ -89,7 +89,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
         ARMCPU *target_cpu;
 
     case QEMU_PSCI_0_2_FN_PSCI_VERSION:
-        ret = QEMU_PSCI_0_2_RET_VERSION_0_2;
+        ret = QEMU_PSCI_VERSION_1_1;
         break;
     case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
         ret = QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED; /* No trusted OS */
@@ -170,6 +170,35 @@ void arm_handle_psci_call(ARMCPU *cpu)
         }
         helper_wfi(env, 4);
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
+        case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+            if (!(param[1] & QEMU_PSCI_0_2_64BIT) || is_a64(env)) {
+                ret = 0;
+                break;
+            }
+            /* fallthrough */
+        case QEMU_PSCI_0_1_FN_MIGRATE:
+        case QEMU_PSCI_0_2_FN_MIGRATE:
+        default:
+            ret = QEMU_PSCI_RET_NOT_SUPPORTED;
+            break;
+        }
+        break;
     case QEMU_PSCI_0_1_FN_MIGRATE:
     case QEMU_PSCI_0_2_FN_MIGRATE:
     default:
-- 
2.32.0 (Apple Git-132)

