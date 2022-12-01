Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03E763EDEC
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiLAKeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiLAKd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:33:28 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2191990752
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 02:33:23 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y4so1251475plb.2
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 02:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uh5vklaDIaIg0E7Mn51RCtOAsyBHikcVipH+NCl7KLQ=;
        b=MCYdv72/SEE9pYLrRB4MMqijiskrQu1JplbAnz8btw08J8CmJoEyI1p8RBc3IFD62I
         isl4DYkSTALpIvdjI0U4D7INXPEMSTCqGuW0d+/Vv6ghfbx+87KOVVNngJMsAH3Zo4FB
         IUJNv8kx8l6z12mzh6tfZJZTn3/Mso/MBn/69UbO+QQKacXCn2F/6H5P6g+Wp3fodZ5U
         F4b/qW9Uch667yZ7eT/Qy0JgXW627QibzCE4OQs2O/L+kHG/fSPDKT1e4fkdohHAS4zJ
         qGYrw/FF9gKeS4Q91HISsYAu1QtaqM3iPFWV+MyPYU20WKxOOEk8YU1pvyQdOyD4b3g8
         t35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uh5vklaDIaIg0E7Mn51RCtOAsyBHikcVipH+NCl7KLQ=;
        b=sX9ne7t80kN5EnvUL+6q8gtMn7K4a1xUZetPYmjbxG5AzvEER0fGsheou+QMG1u0yg
         wVsaNlhppbEVOfGzy69loaKHoAvVc3AIl9rXADAr7Ya9VJECpG6hOARe+z3jKe6k0LRU
         irHc5/OqrcKvMl2AW7Qj2BvmdDoNpH7rXFg4pJrDj9O/QVDxgvjITLjJKTj45mUBnIiC
         w1oCAwxSyuxRCaS2DCMJXHQ0hnZFSKb2BLiPc9bi9mjXBMBlMux0QHz08V4TUGte6RA0
         TDn1xbdzWtmy2wPgqp9xtqITTNkv+kGjFdBW6jZejM+eV48Mm4Rh9hDZYz305+Dk/lyz
         gULA==
X-Gm-Message-State: ANoB5pltuKi9NfnHR1c1tdVHoPntAJW67LVhxzrOsYwjH3oBBw8gEg3v
        I46eoWoo+4W5zkwbkfWninEDxg==
X-Google-Smtp-Source: AA0mqf5CvHwquaNH2Jo/ayhCOBdRs0FgH1Q2KJvYhb13kHdIDXSX9NuBnLgwDkbkuykZ4CwVH5DsSw==
X-Received: by 2002:a17:90a:fb4e:b0:219:5a12:e1eb with SMTP id iq14-20020a17090afb4e00b002195a12e1ebmr10545612pjb.88.1669890802668;
        Thu, 01 Dec 2022 02:33:22 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
        by smtp.gmail.com with ESMTPSA id g18-20020aa79dd2000000b005752496094bsm2936725pfq.40.2022.12.01.02.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:33:22 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] target/arm: Propagate errno when writing list
Date:   Thu,  1 Dec 2022 19:33:12 +0900
Message-Id: <20221201103312.70720-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before this change, write_kvmstate_to_list() and
write_list_to_kvmstate() tolerated even if it failed to access some
register, and returned a bool indicating whether one of the register
accesses failed. However, it does not make sen not to fail early as the
the callers check the returned value and fail early anyway.

So let write_kvmstate_to_list() and write_list_to_kvmstate() fail early
too. This will allow to propagate errno to the callers and log it if
appropriate.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm-stub.c |  4 ++--
 target/arm/kvm.c      | 27 +++++++++++----------------
 target/arm/kvm64.c    | 10 ++++++----
 target/arm/kvm_arm.h  | 15 ++++-----------
 target/arm/machine.c  | 13 ++++++++-----
 5 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 965a486b32..f659afd7b8 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -13,12 +13,12 @@
 #include "cpu.h"
 #include "kvm_arm.h"
 
-bool write_kvmstate_to_list(ARMCPU *cpu)
+int write_kvmstate_to_list(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
 
-bool write_list_to_kvmstate(ARMCPU *cpu, int level)
+int write_list_to_kvmstate(ARMCPU *cpu, int level)
 {
     g_assert_not_reached();
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f022c644d2..4cef0efc96 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -501,12 +501,12 @@ int kvm_arm_init_cpreg_list(ARMCPU *cpu)
     }
     assert(cpu->cpreg_array_len == arraylen);
 
-    if (!write_kvmstate_to_list(cpu)) {
+    ret = write_kvmstate_to_list(cpu);
+    if (ret) {
         /* Shouldn't happen unless kernel is inconsistent about
          * what registers exist.
          */
         fprintf(stderr, "Initial read of kernel register state failed\n");
-        ret = -EINVAL;
         goto out;
     }
 
@@ -515,11 +515,10 @@ out:
     return ret;
 }
 
-bool write_kvmstate_to_list(ARMCPU *cpu)
+int write_kvmstate_to_list(ARMCPU *cpu)
 {
     CPUState *cs = CPU(cpu);
     int i;
-    bool ok = true;
 
     for (i = 0; i < cpu->cpreg_array_len; i++) {
         struct kvm_one_reg r;
@@ -545,17 +544,16 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
             g_assert_not_reached();
         }
         if (ret) {
-            ok = false;
+            return ret;
         }
     }
-    return ok;
+    return 0;
 }
 
-bool write_list_to_kvmstate(ARMCPU *cpu, int level)
+int write_list_to_kvmstate(ARMCPU *cpu, int level)
 {
     CPUState *cs = CPU(cpu);
     int i;
-    bool ok = true;
 
     for (i = 0; i < cpu->cpreg_array_len; i++) {
         struct kvm_one_reg r;
@@ -581,14 +579,10 @@ bool write_list_to_kvmstate(ARMCPU *cpu, int level)
         }
         ret = kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &r);
         if (ret) {
-            /* We might fail for "unknown register" and also for
-             * "you tried to set a register which is constant with
-             * a different value from what it actually contains".
-             */
-            ok = false;
+            return ret;
         }
     }
-    return ok;
+    return 0;
 }
 
 void kvm_arm_cpu_pre_save(ARMCPU *cpu)
@@ -620,8 +614,9 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
         fprintf(stderr, "kvm_arm_vcpu_init failed: %s\n", strerror(-ret));
         abort();
     }
-    if (!write_kvmstate_to_list(cpu)) {
-        fprintf(stderr, "write_kvmstate_to_list failed\n");
+    ret = write_kvmstate_to_list(cpu);
+    if (ret < 0) {
+        fprintf(stderr, "write_kvmstate_to_list failed: %s\n", strerror(-ret));
         abort();
     }
     /*
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 1197253d12..f7879194f9 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -1202,8 +1202,9 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 
     write_cpustate_to_list(cpu, true);
 
-    if (!write_list_to_kvmstate(cpu, level)) {
-        return -EINVAL;
+    ret = write_list_to_kvmstate(cpu, level);
+    if (ret) {
+        return ret;
     }
 
    /*
@@ -1418,8 +1419,9 @@ int kvm_arch_get_registers(CPUState *cs)
         return ret;
     }
 
-    if (!write_kvmstate_to_list(cpu)) {
-        return -EINVAL;
+    ret = write_kvmstate_to_list(cpu);
+    if (ret) {
+        return ret;
     }
     /* Note that it's OK to have registers which aren't in CPUState,
      * so we can ignore a failure return here.
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 99017b635c..05fce74baf 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -106,13 +106,9 @@ int kvm_arm_cpreg_level(uint64_t regidx);
  * This updates KVM's working data structures from TCG data or
  * from incoming migration state.
  *
- * Returns: true if all register values were updated correctly,
- * false if some register was unknown to the kernel or could not
- * be written (eg constant register with the wrong value).
- * Note that we do not stop early on failure -- we will attempt
- * writing all registers in the list.
+ * Returns: 0 if success, else < 0 error code
  */
-bool write_list_to_kvmstate(ARMCPU *cpu, int level);
+int write_list_to_kvmstate(ARMCPU *cpu, int level);
 
 /**
  * write_kvmstate_to_list:
@@ -123,12 +119,9 @@ bool write_list_to_kvmstate(ARMCPU *cpu, int level);
  * copy info from KVM's working data structures into TCG or
  * for outbound migration.
  *
- * Returns: true if all register values were read correctly,
- * false if some register was unknown or could not be read.
- * Note that we do not stop early on failure -- we will attempt
- * reading all registers in the list.
+ * Returns: 0 if success, else < 0 error code
  */
-bool write_kvmstate_to_list(ARMCPU *cpu);
+int write_kvmstate_to_list(ARMCPU *cpu);
 
 /**
  * kvm_arm_cpu_pre_save:
diff --git a/target/arm/machine.c b/target/arm/machine.c
index 54c5c62433..8a5f3d53ff 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -686,15 +686,16 @@ static const VMStateInfo vmstate_powered_off = {
 static int cpu_pre_save(void *opaque)
 {
     ARMCPU *cpu = opaque;
+    int ret;
 
     if (!kvm_enabled()) {
         pmu_op_start(&cpu->env);
     }
 
     if (kvm_enabled()) {
-        if (!write_kvmstate_to_list(cpu)) {
-            /* This should never fail */
-            g_assert_not_reached();
+        ret = write_kvmstate_to_list(cpu);
+        if (ret) {
+            return ret;
         }
 
         /*
@@ -752,7 +753,7 @@ static int cpu_post_load(void *opaque, int version_id)
 {
     ARMCPU *cpu = opaque;
     CPUARMState *env = &cpu->env;
-    int i, v;
+    int i, v, ret;
 
     /*
      * Handle migration compatibility from old QEMU which didn't
@@ -796,7 +797,9 @@ static int cpu_post_load(void *opaque, int version_id)
     }
 
     if (kvm_enabled()) {
-        if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
+        ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
+        if (ret) {
+            error_report("Failed to set KVM register: %s", strerror(-ret));
             return -1;
         }
         /* Note that it's OK for the TCG side not to know about
-- 
2.38.1

