Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130B84C2E85
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbiBXOhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiBXOhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:37:54 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82CD52E4D
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:37:23 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id q1so1878685plx.4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=poAZtHyLvs6wdh05wh10xP5cMccFcvYZDzxd4P/umwQ=;
        b=WgyQRQSotkNEBJy5EQiuCugh7EDBW4AbeheFmDhVdLtcQfD5mPwihE9UC5tFco02+k
         mH3TbfNW1Ubw0aOjmESks4XumAprgpK8iS5wleJqzHltXQHgMd9SMxL53Wx7PsWyTx4r
         ppsvk1ecMWkjhZ7EX82pPuTuYdJJAm0k/OIDJVeOY+KzP/oSeQT0IqCodf+o9YWZ0ODU
         Ao++JVYXWx4hkpXXTYbld4FWhT9FSZFVr1MFCqHJdadt9244qoguqwAf7tO0NXa5zgnN
         6K5PWXW0uuXRfmQNOLki1e5OoIactRToLslEjkARwJI3WNNlaENTBuO/ucs5uKSo7I2H
         NCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=poAZtHyLvs6wdh05wh10xP5cMccFcvYZDzxd4P/umwQ=;
        b=lATIYyKovW7XjCLZdgqnwyIsFB8VuGepMZ6Wg0AnWS2Q5mTVytc5YwjTolfyHFSAjp
         +iMwf4rPhmHlWmgwlm92I8+rvsVTYFM/X8bNfacbdY9oYe76b/HOULssWAMkJx58HYEL
         rFrqP56GnagxKh19QSVcCiUx91kDxLW9t1/ma/8KjVuNM9FbUbUD7hIEXtmPZ1QRmeMk
         9J7OEH0n/4deK2i/k93YQ87LSRYPH7YV/Hvp5NyGYgdKmxLLo+dZO/eJWUCxREGxXcrA
         CfvMXNVU/9LraTJ41oiLKph+VnHJFTW8rFyAhd7eU/zVUS954EiJmVTNQerO5wJ2ydiW
         wbbg==
X-Gm-Message-State: AOAM533/+P2+FEQYF/wQQzsNIhWezyarIjldYGsMGqw9s5B1e5iQDbgn
        5mIHO+iR3ILQLonrdlPgWG4=
X-Google-Smtp-Source: ABdhPJyTLwBuPSewGO61RWbN1hDGtQKEEgPeoLjdg+nedQwMkbrkpse98FbseRVOIi9YUgPHOGjrVQ==
X-Received: by 2002:a17:902:ea86:b0:14f:b4be:6f83 with SMTP id x6-20020a170902ea8600b0014fb4be6f83mr2772830plb.99.1645713443203;
        Thu, 24 Feb 2022 06:37:23 -0800 (PST)
Received: from localhost.localdomain ([2400:4050:c360:8200:4544:3648:f893:1e45])
        by smtp.gmail.com with ESMTPSA id 19sm3721882pfz.153.2022.02.24.06.37.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Feb 2022 06:37:22 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>,
        Akihiko Odaki <akihiko.odaki@gmail.com>
Subject: [PATCH v2] target/arm: Support PSCI 1.1 and SMCCC 1.0
Date:   Thu, 24 Feb 2022 23:37:16 +0900
Message-Id: <20220224143716.14576-1-akihiko.odaki@gmail.com>
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
 target/arm/kvm-consts.h | 13 +++++++++----
 target/arm/kvm64.c      |  2 +-
 target/arm/psci.c       | 35 ++++++++++++++++++++++++++++++++---
 6 files changed, 80 insertions(+), 14 deletions(-)

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
index 580f1c1fee0..241e02562e1 100644
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
@@ -84,18 +86,21 @@ MISMATCH_CHECK(QEMU_PSCI_0_2_FN_MIGRATE, PSCI_0_2_FN_MIGRATE);
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
-MISMATCH_CHECK(QEMU_PSCI_0_2_RET_VERSION_0_2,
-               (PSCI_VERSION_MAJOR(0) | PSCI_VERSION_MINOR(2)));
+MISMATCH_CHECK(QEMU_PSCI_VERSION_0_1, PSCI_VERSION(0, 1));
+MISMATCH_CHECK(QEMU_PSCI_VERSION_0_2, PSCI_VERSION(0, 2));
+MISMATCH_CHECK(QEMU_PSCI_VERSION_1_1, PSCI_VERSION(1, 1));
 
 /* PSCI return values (inclusive of all PSCI versions) */
 #define QEMU_PSCI_RET_SUCCESS                     0
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

